function [Results] = generateResults(Experiments,Algorithms,QIs)

nExp = length(Experiments);
nAlg = length(Algorithms);

%For each experiment, obtain results
for exp=1: nExp

    %For each algorithm, obtain result in the experiment i
    for alg=1: nAlg
        Result.nExp = func2str(Experiments(exp).MOP);
        Result.algorithm = func2str(Algorithms(alg).Function); 
        Result.stadistics = generateResult(Experiments(exp),Algorithms(alg),QIs);
        ResultsA(alg) = Result;
    end
    
    Results{exp} = ResultsA;
end
end

function Results = generateResult(Experiment,Algorithm,QIs)

nIndicators = length(QIs);
pro = Experiment.MOP(Experiment.M, Experiment.D);

for ind=1 : nIndicators
    
    %Obtain the results of all runs of the experiment
    [PopObj, ~, ~,RunTime,~,History] = LoadData(Experiment,Algorithm);
    
    %For each aproximation find by the algorithm
    %Evaluate the approximation and obtain the indicator value 1 -> hv1,
    %2->hv2, 3-> hv3, etc
    for run=1 : Experiment.Runs
        Indicator(run) = QIs{ind}(PopObj{run},pro.optimum);
    end
    
    %Remove no numbers(no feasible runs)
    wrongs = isnan(Indicator);
    Pivot = 1:Experiment.Runs;
    Indicator(wrongs) = [];
    Pivot(wrongs) =[];
    
    if ~isempty(Indicator)
    %Results by indicator
    Result.Indicator= func2str(QIs{ind});
    Result.FeasibleRuns = length(Indicator);
    Result.Promedio = mean(Indicator);
    [vals] = sortrows([Indicator',Pivot'],1);
    Result.Max = vals(end,1);
    Result.Min = vals(1,1);
    Result.std = std(Indicator);
    Result.Median = vals(round(Result.FeasibleRuns/2),2);
    Result.PopObj = PopObj{Result.Median};
    Result.History = History{Result.Median};
    Result.Indicators = Indicator; %Only to conserve
    Result.RunTime = mean(RunTime);
    Results(ind) = Result;
    else
        Results =[];
    end  
end
end


function [PopObj, UPF, CPF,RunTime,Problem,History] = LoadData(Experiment,Algorithm)
global path_data;

Runs = Experiment.Runs;
Function = Algorithm.Function;
Parameters = Algorithm.Parameters;

if Experiment.M==0
    Problem = Experiment.MOP();
    M = Problem.M;
    D = Problem.D;
elseif Experiment.D == 0
    Problem = Experiment.MOP(Experiment.M);
    M = Experiment.M;
    D = Problem.D;
else
    M = Experiment.M;
    D = Experiment.D;
end

nParameters= length(Parameters);
cad='';
if nParameters > 0 && isstruct(Parameters)
    cad='_';
    for par=1:nParameters
        cad = strcat(cad, Parameters(par).Name, '_', num2str(Parameters(par).Value),'_');
    end
end

for r=1 : Runs
    PopObj_= load(path_data + "/" + func2str(Function) + "/" + "/" + func2str(Function) + "_" ...
        + func2str(Experiment.MOP) + "_M" + num2str(M)+ "_D" + num2str(D)+"_" + convertCharsToStrings(cad) + num2str(r) + ".mat");
    PopObj{1,r}= PopObj_.result{end};
    UPF{1,r} = PopObj{1,r}.objs;
    CPF{1,r} = PopObj{1,r}(all(PopObj{1,r}.cons<=0,2)).objs;
    RunTime(1,r) = PopObj_.metric(1).runtime;
    History{1,r} = PopObj_.result;
end 
end


