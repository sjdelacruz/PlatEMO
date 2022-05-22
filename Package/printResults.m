function tables = printResults(principalInformation,Algorithms,QIs)
nIndicators = length(QIs);
[exp,algs] = size(principalInformation);

for ind=1: nIndicators
    tables{ind} = generateTemplate(Algorithms,func2str(QIs{ind}));
end

tables{nIndicators+1} = generateTemplate(Algorithms,'Feasible ratio');
tables{nIndicators+2} = generateTemplate(Algorithms,'Random Walk');

for i=1 : exp
    
    currentExperiment = principalInformation(i,:);
    commonInformation = currentExperiment{1,1}(:,1:2);
    %common = currentExperiment{1,1}(:,1:2);
    
    for ind=1: nIndicators+2
        common = commonInformation;
        for j=1 : algs
            currentAlgorithm = currentExperiment{1,j};
            A= currentAlgorithm(1:end,ind+2);
            common = [common A];
        end
        Rows{i,ind} = common;
    end
end

for i=1 : nIndicators+2
    results{i} = Rows(:,i);
    unified = cat(1, results{i}{:});
    union = [table2array(tables{i}.table);unified];
    tables{i}.table =  array2table(union);
end
end