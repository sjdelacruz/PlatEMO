function executeExperiments(Experiments,Algorithms)

nExp = length(Experiments);
nAlg = length(Algorithms);

for alg=1: nAlg
   for exp=1:nExp
       executeExperiment(Experiments(exp),Algorithms(alg));
   end  
end

end

function executeExperiment(Experiment,Algorithm)

Runs = Experiment.Runs;
Problem = Experiment.MOP;
M = Experiment.M;
D = Experiment.D;
MaxEvals = Experiment.MaxEvals;
Save = Experiment.Save;
N = Algorithm.N;
Function = Algorithm.Function;

Others = Algorithm.Parameters;

for r=1: Runs
    platemo('algorithm',{Function,Others},'problem',{Problem,M,D},'N',N,'maxFE',MaxEvals,'run',r,'save',Save);
end
end
