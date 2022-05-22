function template = generateTableWilcoxon(QIs,name)

n = length(QIs);

%Creating label of colums
varNames = cell(1,3);
varNames{1} = 'Problem';
varNames{2} = 'M';

for i=1 : n
    varNames{i+2} = strcat(func2str(QIs{i}));
end

t_ = varNames;
t_ = array2table(t_);
template.name = name;
template.table = t_;
end