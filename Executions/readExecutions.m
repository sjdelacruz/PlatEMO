function executions = readExecutions(Experiments,algorithm,QI)

nExperiments = length(Experiments);
executions = cell(1,nExperiments);
for i=1 : nExperiments
    executions{i} = evaluateLoadData(Experiments(i),algorithm,QI);
end
end

function [values] = evaluateLoadData(ExperimentStruct, AlgorithmStruct,QI)
global path_data;

runs = ExperimentStruct.runs;
algorithm = AlgorithmStruct.function;
Parameters = AlgorithmStruct.parameters;
Problem = ExperimentStruct.mop(ExperimentStruct.m, ExperimentStruct.d,AlgorithmStruct.n,ExperimentStruct.maxEvals);
values = zeros(1,runs);

nParameters= length(Parameters);
cad='';
if nParameters > 0 && isstruct(Parameters)
    cad='_';
    for par=1:nParameters
        cad = strcat(cad, Parameters(par).Name, '_', num2str(Parameters(par).Value),'_');
    end
end

for r=1 : runs
    data= load(path_data + "/" + func2str(algorithm) + "/" + "/" + func2str(algorithm) + "_" ...
        + func2str(ExperimentStruct.mop) + "_M" + num2str(Problem.M)+ "_D" + num2str(Problem.D)+"_" + convertCharsToStrings(cad) + num2str(r) + ".mat");
    
    population= data.result{end,2};
    res = QI(population,Problem.optimum);
    if isnan(res)
        values(r) = 0;
    else
        values(r) = res;
    end
end
end


