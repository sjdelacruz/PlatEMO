%GenerateAlgorithm(char,cell,cell,cell,cell,cell)
%The objective is generate an experiment for the algorithms, its experiment
%will have different parameters, like as the number of objectives and
%dimensions.
function [algorithm] = generateAlgorithm(name, description, configurations, varargin)

p = inputParser;
addRequired(p,'name',@ischar);
addRequired(p,'description',@ischar);
addRequired(p,'configurations',@(x) iscell(x) && ~isempty(x));
addOptional(p,'parameters',{});
parse(p,name,description,configurations,varargin{:});

results = p.Results;

 try   
    algorithm.name = results.name;
    algorithm.function = str2func(results.name);
    algorithm.description = results.description;
    
    if ~isempty(results.parameters)
        algorithm.parameters = process_struct(results.parameters(:,1), results.parameters(:,2));
    else
        algorithm.parameters = results.parameters;
    end
    algorithm.configurations = process_configurations(configurations);
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
            message = [ME.message, ' ' ,'Bad configuration for problems, check configurations be triplets in the algorithm', ' ', name, '.' ];
            causeException = MException('MATLAB:minrhs', message);
            ME = addCause(ME,causeException);
            
    end
    rethrow(ME)
end
end

function pairs = process_struct(parameters,values)

[rp,~] = size(parameters);
[rv,~] = size(values);

if rp == rv
    for i=1: rp
        pairs(i).name = parameters{i,1};
        pairs(i).value = values{i,1};
    end
end
end

function configurations = process_configurations(cells)
[rc,cc] = size(cells);

if rc >=1 && cc == 3
    for i=1 : rc
    configurations(i).problem = cells{i,1};
    configurations(i).objectives = cells{i,2};
    configurations(i).n = cells{i,3};
    end
else
    MException();
end
end

