%Execute a set of algorithms in a set of experiments
function solveExperiments(experiments,algorithms,varargin)

%Optional reproducibility
p = inputParser;
validStruct = @(x) isstruct(x);

addRequired(p,'Experiments',validStruct);
addRequired(p,'Algorithms',validStruct);
addOptional(p,'reproducibility', @islogical);
parse(p,experiments,algorithms,varargin{:});

try
    nExperiments = length(experiments);
    nAlgorithms = length(algorithms);
    
    for exp=1:nExperiments
        for alg=1: nAlgorithms
            solveExperiment(experiments(1,exp),algorithms(1,alg),varargin);
        end
    end

catch ME
    switch ME.identifier
        case 'Writing:BadConfiguration'
            message = [ME.message, ' ' ,experiments(1,exp).name, ' and ', ' ', algorithms(1,alg).name];
            causeException = MException('Writing:BadConfiguration', message);
            ME = addCause(ME,causeException);  
        case 'MATLAB:UndefinedFunction'
            message = [ME.message, ' ' , 'Missing configuration for the problem',' ',experiments(1,exp).name, ' in the algorithm ', ' ', algorithms(1,alg).name ];
            causeException = MException('Writing:BadConfiguration', message);
            ME = addCause(ME,causeException);  
    end
    
    rethrow(ME);
end
end

function solveExperiment(experiment,algorithm,varargin)

%General parameters
algFunc = algorithm.function;
parameters = algorithm.parameters;
probFunc = experiment.function;

%Verify all the variants of each problem to solve
listVariations = experiment.listVariations;
nVariations= length(listVariations);

%Obtain all the configurations for each variations. The ordering is done
%for match configuration and variation (one more validation)
listConfigurations = algorithm.configurations;

%Obtain the configurations of the algorithm for the problem in order based
%on the m objectives functions
ordered = orderedConfigurations(experiment.name,listVariations,listConfigurations);

reproducibility = varargin{1,1}{1,2};

if reproducibility
    for i=1 : nVariations
        runs = listVariations(i).runs;
        m = listVariations(i).objectives;
        d = listVariations(i).dimensions;
        maxEvals = listVariations(i).maxEvals;
        n = ordered(i).n;
        
        for r=1: runs
            rng(r,'twister'); % init generator for random repeatable with seed 
            platemo('algorithm',{algFunc,parameters},'problem',probFunc, 'M', m, 'D', d,'N',n,'maxFE',maxEvals,'run',r,'save',50);
        end
    end
    
else
    for i=1 : nVariations
        runs  =listVariations(i).runs;
        m = listVariations(i).objectives;
        d = listVariations(i).dimensions;
        maxEvals = listVariations(i).maxEvals;
        n = ordered(i).n;
        
        for r=1: runs
            platemo('algorithm',{algFunc,parameters},'problem',probFunc, 'M', m, 'D', d,'N',n,'maxFE',maxEvals,'run',r,'save',50);
        end
    end
end
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
if length(ordered) ~= nVariations
    message = 'Probably write bad the experiment in configurations algorithm and variation experiment; It is in';
    causeException = MException('Writing:BadConfiguration', message);
    throw(causeException);
end
end


