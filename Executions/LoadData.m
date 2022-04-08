%Output: population (next if is necessary extract the UPF or CPF), the
%gistory and the runtime.
function [population, history, runtime] = LoadData(ExperimentStruct, AlgorithmStruct, Problem)
global path_data;

runs = ExperimentStruct.runs;
algorithm = AlgorithmStruct.function;
Parameters = AlgorithmStruct.parameters;

nParameters= length(Parameters);
cad='';
if nParameters > 0 && isstruct(Parameters)
    cad='_';
    for par=1:nParameters
        cad = strcat(cad, Parameters(par).Name, '_', num2str(Parameters(par).Value),'_');
    end
end

for r=1 : runs
    BestPopulation= load(path_data + "/" + func2str(algorithm) + "/" + "/" + func2str(algorithm) + "_" ...
        + func2str(ExperimentStruct.mop) + "_M" + num2str(Problem.M)+ "_D" + num2str(Problem.D)+"_" + convertCharsToStrings(cad) + num2str(r) + ".mat");
    
    population{1,r}= BestPopulation.result{end,2};
    runtime(1,r) = BestPopulation.metric.runtime;
    history{1,r} = BestPopulation.result;
end
end

