%Function to generate results in a set of experiments of a set of
%algorithms.
%Output a cell array by experiment with the results of the algorithms set
function [Results] = GenerateResults(experiments,algorithms,QIs)

nExperiments = length(experiments);
nAlgorithms = length(algorithms);

%For each experiment, obtain results
for exp=1: nExperiments
    
    %For each algorithm, obtain result in the experiment i
    for alg=1: nAlgorithms
        answer.name = func2str(experiments(exp).mop);
        answer.algorithm = func2str(algorithms(alg).function);
        answer.stadistics = ObtainResult(experiments(exp),algorithms(alg),QIs);
        resAlgorithmI(alg) = answer;
    end
    Results{exp} = resAlgorithmI;
end
end


%Obtain results of an algorithm in one experiment using indicators
%1 experiment-> 1 algorithm in  N independent runs
function Results = ObtainResult(experiment,algorithm,QIs)

pro = experiment.mop(experiment.m, experiment.d,algorithm.n,experiment.maxEvals);
nIndicators = length(QIs);

%Load all the information of the algorithm
[population, history, runtime] = LoadData(experiment,algorithm,pro);

%Compute the indicators by each population obtained in R independent run
for ind=1 : nIndicators
    
    %For each aproximation find by the algorithm
    %Evaluate the approximation and obtain the indicator value 1 -> hv1,
    %2->hv2, 3-> hv3, etc
    for run=1 : experiment.runs
        Indicator(run) = QIs{ind}(population{1,run},pro.optimum);
    end
    
    %Remove no numbers(no feasible runs)
    wrongs = isnan(Indicator);
    Pivot = 1:experiment.runs;
    Indicator(wrongs) = [];
    Pivot(wrongs) =[];
    
    if ~isempty(Indicator)
        
        result.indicator= func2str(QIs{ind});
        result.feasibleRuns = length(Indicator);
        result.mean = mean(Indicator);
        result.std = std(Indicator);
        result.runtime = mean(runtime);
        
        [vals] = sortrows([Indicator',Pivot'],1);
        result.max = vals(end,1);
        result.min = vals(1,1);
        
        median = vals(round(result.feasibleRuns/2),2);
        result.cpf = population{median}.best.objs;
        result.history = history{median};
        
        %Conserve all the computed value by posible statistical
        %diferences
        result.computedMetric = Indicator;
        Results(ind) = result;
    else
        Results =[];
    end
end
end

%Load data of all runs of the algorithms. For that, i need to set the
%information of the experiment , algorithm and the problem to load based on
%that parameters.




