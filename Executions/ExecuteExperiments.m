%Execute a set of algorithms in a set of experiments
%Plural version of the SolveExperiment method
function ExecuteExperiments(experiments,algorithms)

nExperiments = length(experiments);
nAlgorithms = length(algorithms);

%For each algorithm
for alg=1: nAlgorithms
    
    %Solve all the experiments
   for exp=1:nExperiments
       SolveExperiment(experiments(exp),algorithms(alg));
   end  
end

end



%Execute one algorithm in one experiment;
%Input: an algorithm structure and an experiment structure
function SolveExperiment(experiment,algorithm)
global reproducibility;

runs = experiment.runs;
problem = experiment.mop;
m = experiment.m;
d = experiment.d;
maxEvals = experiment.maxEvals;
save = experiment.save;

if m==3 && contains(func2str(problem), 'MW')
    n=300;
else
    n = algorithm.n;
end

if contains(func2str(problem), convertCharsToStrings('LIRCMOP'))
    n=300;
end

fun_handle = algorithm.function;
extra_parameters = algorithm.parameters;

for r=1: runs
    
    %If the global variable is true use a seed for reprodubility based on
    %this seed. Its condition is in this part because is for each
    %experiment and for each algorithm
    if reproducibility
        rng(r);
    end
        platemo('algorithm',{fun_handle,extra_parameters},'problem',{problem,m,d,n,maxEvals},'N',n,'maxFE',maxEvals,'run',r,'save',save);
end
end
