function template = generateTemplate(algorithms,name)

nAlgorithms = length(algorithms);

%Creating label of colums
varNames = cell(1,nAlgorithms+2);
varNames{1} = 'Problem';
%varTypes{1} = {'string'};
varNames{2} = 'M';
%varTypes{2} = {'double'};

for col = 3 : nAlgorithms+2
 %   varTypes{end+1} = 'double';
    varNames{col} = algorithms(col-2).description;
end

t_ = varNames;
t_ = array2table(t_);
template.name = name;
template.table = t_;
end