%GenerateExperiment(char,cell,cell,cell,cell,cell)
%The objective is generate an experiment for the algorithms, its experiment
%will have different parameters, like as the number of objectives and
%dimensions.
function [experiment] = generateExperiment(name, runs, objectives, dimensions, max_evals)

try
    validateattributes(name, {'char'},{'nonempty'});
    validateattributes(runs, {'cell'},{'nonempty'});
    validateattributes(objectives, {'cell'},{'nonempty'});
    validateattributes(dimensions, {'cell'},{'nonempty'});
    validateattributes(max_evals, {'cell'},{'nonempty'});
    
    experiment.name = name;
    experiment.function = str2func(name);
    experiment.listVariations = setStructure(runs,objectives, dimensions, max_evals);
catch ME
    switch ME.identifier
        
        case 'MATLAB:invalidType'
            message = [ME.message, ' ', 'Validate experiments parameters, not all are cells.'];
            causeException = MException('MATLAB:invalidType', message);
            ME = addCause(ME,causeException);
        case 'MATLAB:badsubscript'
            message = [ME.message, ' ' ,'Not all cells have the same length.'];
            causeException = MException('MATLAB:badsubscript', message);
            ME = addCause(ME,causeException);
        case 'MATLAB:minrhs'
            message = [ME.message, ' ' ,'Bad configuration for problems, check call the parameters cells array have the same length in the algororithm', ' ', name, '.' ];
            causeException = MException('MATLAB:minrhs', message);
            ME = addCause(ME,causeException);
    end
    rethrow(ME)
end
end

%Function to create a structure that represent the variations of the
%experiments, it means for example the problems with 2 and 3 objective
%funtions
function struct = setStructure(runs,objectives, dimensions, max_evals)

[~,rr] = size(runs);
[~,ro] = size(objectives);
[~,rd] = size(dimensions);
[~,re] = size(max_evals);

if rr == ro && ro == rd && rd == re
    for i=1: rr
       struct(i).runs = runs{i};
       struct(i).objectives = objectives{i};
       struct(i).dimensions = dimensions{i};
       struct(i).maxEvals = max_evals{i};
    end
else
    MException();
end
end

