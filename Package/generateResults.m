function [principalInformation,statisticsInformation] = generateResults(Experiments,Algorithms,QIs,varargin)
defaultSymbol = '\';

%Optional symbol
p = inputParser;
validStruct = @(x) isstruct(x);

addRequired(p,'Experiments',validStruct);
addRequired(p,'Algorithms',validStruct);
addRequired(p,'QIs',@iscell);
addParameter(p,'symbol', defaultSymbol,@ischar);
parse(p,Experiments,Algorithms,QIs,varargin{:});

[principalInformation,statisticsInformation] = generateResult(Experiments, Algorithms,QIs,p.Results.symbol);
end

function [principalInformation,statisticsInformation] = generateResult(experiments, algorithms,QIs,symbol)
global path_data;

nExperiments = length(experiments);
nAlgorithms = length(algorithms);

%Obtain the experiments and their variations, and for each algorithm the
%configurations set for the experiment and their variations
for exp=1 : nExperiments
    listVariations = experiments(exp).listVariations;
    nVariations = length(listVariations);
    
    for alg=1 : nAlgorithms
        
        listConfigurations = algorithms(alg).configurations;
        firstInformation = [];
        secondInformation = [];
        
        
        %Obtain the configurations of the algorithm for the problem in order based
        %on the m objectives functions
        ordered = orderedConfigurations(experiments(exp).name,listVariations,listConfigurations);
        
        %Obtain result for each variation
        for var=1 : nVariations
            experiment = listVariations(var);
            
            %Configure the problem to obtain the optimun based on PlatEMO
            problemInput = {'M',experiment.objectives,'D',experiment.dimensions,'N', ...
                ordered(var).n,'maxFE',experiment.maxEvals};
            pro = experiments(exp).function(problemInput{:});
            
            %Generate cad to indicate the path
            algorithm = algorithms(alg).name;
            parameters = algorithms(alg).parameters;
            nParameters= length(parameters);
            cad='';
            
            if nParameters > 0 && isstruct(parameters)
                cad='';
                for par = 1 : nParameters
                    cad = strcat(cad, parameters(par).name, '_', num2str(parameters(par).value),'_');
                end
            end
            
            generalCad = [path_data,symbol, algorithm,symbol, algorithm, "_", ...
                experiments(exp).name, "_M",experiment.objectives, "_D",experiment.dimensions,...
                "_",cad];
            generalCad = join(generalCad,'');
            
            %Load all the information of the algorithm
            [lastPopulations, history,fr,rw,SearchProcess] = loadData(generalCad, experiment.runs);
            
            %Quality indicators computed medianIndicators return the index
            %of the median by each indicator
            [meansIndicators,medianRuns,historiesIndicators,convergenceIndicators,...
                meansMetrics,convergenceMetrics] = calculateMetrics(lastPopulations,...
                QIs,pro,experiment.runs,history,fr,rw);
            
            principalRow = {experiments(exp).name, experiment.objectives};
           	principalRow = [principalRow, num2cell(meansIndicators), num2cell(meansMetrics)];
            
            secundaryRow = {historiesIndicators,convergenceIndicators,convergenceMetrics,SearchProcess};
            
            firstInformation =[firstInformation; principalRow];
            secondInformation = [secondInformation;secundaryRow];
        end
            principalInformation{exp,alg} = firstInformation;
            statisticsInformation{exp,alg} = secondInformation;
    end
    
%%Busy computed    
%     %Configuring information desired
%     problem = experiments(exp).name;
%     
%     %For each algorithm set the information
%     for res = 1 :  nAlgorithms
%         
%         %Obtain the info of all experiments of the current algorithm
%         resultRow = infoAlgorithms{res};
%         
%         %check how much information is realted with each experiment' variant
%         nRows = length(resultRow);
%         
%         %For each row extract the information
%         for row = 1 : nRows
%             localRow = resultRow{row};
%             
%             %Obtain the means of each indicator evaluated
%             for ind=1 : nIndicators
%                 indicator{row,ind} = localRow{ind+2};
%             end
%             
%             %3 because two names and the metric position
%             indicator{row,nIndicators+1} = localRow{nIndicators+3};
%             indicator{row,nIndicators+2} = localRow{nIndicators+4};
%         end
%     end
            
            
end
end


%medianRuns return the indexes of the median quality indicator
%historiesIndicators return the quality indicators in all the runs for statistical
%comparison
%convergenceIndicators return a struct array with the data for generate figure of
%convergence
%convergenceMetrics return a struct array with the data for generate figure of
%convergence



function [means,medianRuns,historiesIndicators,convergenceIndicators,meansMetrics,convergenceMetrics] = calculateMetrics(lastPopulations,QIs,pro,runs,history,fr,rw)

nIndicators = length(QIs);
historiesIndicators = zeros(runs,nIndicators);
medianRuns = zeros(1,nIndicators);
means = zeros(1,nIndicators);

for ind = 1 : nIndicators
    
    %Compute the indicators values
    for r = 1 : runs
        histInd(r) = QIs{1,ind}(lastPopulations{r}, pro.optimum);
    end
    
    auxForSave = histInd;
    %Delete nan computet values
    wrongs = isnan(histInd);
    histInd(wrongs) = [];
    
    if isempty(histInd)
        historiesIndicators(:,ind) = NaN;
        convergenceIndicators = [];
        means(1,ind) = NaN;
    else
        
        %Saving the histories of the algorithms;
        historiesIndicators(:,ind) =  auxForSave';
        
        %Means of each quality indicator
        means(1,ind) = mean(histInd);
        
        %Obtain the indexes where runs dont return nan values in quality
        %indicators
        indexes = 1:runs;
        indexes(wrongs) = [];
        
        %for not lost real indexes of runs where indicator was calculated
        historiesLocal = [histInd',indexes'];
        ordered = sortrows(historiesLocal,1);
        
        %Remaining is the number of indicators values calculated correctly
        [remaining, ~] = size(ordered);
        medianRuns(1,ind) = ordered(round(remaining/2),2);
        
        %Compute the convergence of the median (generations and population)
        convergenceIndicators(ind).generations = cell2mat(history{1,medianRuns(1,ind)}(:,1));
        
        %Compute metric by each row
        [nGens,~] = size(convergenceIndicators(ind).generations);
        for row=1: nGens
            population = history{1,medianRuns(1,ind)}{row,2};
            metric(row,1)= QIs{1,ind}(population, pro.optimum);
        end
        convergenceIndicators(ind).computedMetrics = metric;
    end
end

%Compute the median of all results based on fr and rw
convergenceMetrics(1).name = 'Feasible ratio';
convergenceMetrics(2).name = 'Random Walk';

%structures
nRow1 = length(fr);
nRow2 = length(rw);
frHistories = zeros(1,nRow1);
rwHistories = zeros(1,nRow2);

%Computing median
for i=1 : nRow1
    frGen = fr{i};
    wrongs = isnan(frGen);
    frGen(wrongs) = [];
    frHistories(i) = mean(frGen);
end

for j=1 : nRow2
    rwGen = rw{j};
    wrongs = isnan(rwGen);
    rwGen(wrongs) = [];
    rwHistories(j) = mean(rwGen);
end

%Compute means
meansMetrics(1) = mean(frHistories);
meansMetrics(2) = mean(rwHistories);

%Compute median of the metrics
index1 = extractMedianIndexes(frHistories);
index2 = extractMedianIndexes(rwHistories);

%Convergence metrics
convergenceMetrics(1).computedMetrics = fr{index1};
convergenceMetrics(2).computedMetrics = rw{index2};
convergenceMetrics(1).generations = (1:length(fr{index1}))';
convergenceMetrics(2).generations = (1:length(rw{index2}))';
end

function ordered = orderedConfigurations(problem,variations, configurations)
nVariations = length(variations);
nConfigurations = length(configurations);

for i=1 : nVariations
    mVar = variations(i).objectives;
    
    for j=1 : nConfigurations
        probConfig = configurations(j).problem;
        mConfig = configurations(j).objectives;
        
        if strcmp(problem, probConfig) && mVar == mConfig
            ordered(i) = configurations(j);
            break;
        end
    end
end

if ~exist('ordered') || length(ordered) ~= nVariations
    message = 'Probably write bad the experiment in configurations algorithm and variation experiment; It is in';
    causeException = MException('Writing:BadConfiguration', message);
    throw(causeException);
end
end

function index = extractMedianIndexes(array)

n = length(array);

wrongs = isnan(array);
indexes = 1:n;
indexes(wrongs) = [];

auxiliary = [array(indexes)',indexes'];
ordered = sortrows(auxiliary,1);
nOrdered = length(ordered);

index = ordered(round(nOrdered/2),2);
end