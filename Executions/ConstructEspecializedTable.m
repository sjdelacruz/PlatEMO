function GeneralTable = ConstructEspecializedTable(experiments,algorithms,QIs, expList,whatAnalize)

nExperiments = length(experiments);
indicator = func2str(QIs{whatAnalize});
nAlgorithms = length(algorithms);
varNames = cell(1,nAlgorithms+1);
varNames{1} = 'Problem';
varTypes = {'string'};
for lab = 2 : nAlgorithms+1
    varNames{lab} = func2str(algorithms(lab-1).function);
    varTypes{end+1} = 'double';
end

GeneralTable = table('Size',[nExperiments nAlgorithms+1],'VariableTypes',varTypes,'VariableNames',varNames);

%for each experiment
for j=1 : nExperiments
    
    vector = expList(j).answer; %obtaqin data of experiment j
    results = length(vector); %number of answer or results in the experiment j
    
    %Identifying the index of the structure based on the indicator's name
    for i=1: results
        if vector{i}.name == convertCharsToStrings(indicator)
            index=i;
            break;
        end
    end
    
    %Obtain values calculated for the selected indicator
    vectorsRow = vector{index}.stadistics;
    nRows = length(vectorsRow); %how many elements are there?
    
    %Obtaint the name of the current experiment
    problem =  func2str(experiments(j).mop);
    
    %Extract the calculated values for the indicator for all algorithms
    data = cell(1,nAlgorithms+1);
    data{1}=problem;
    
    for k=1: nRows    
        %horizontal concatenation
        if convertCharsToStrings(vectorsRow(k).algorithm) == varNames(k+1)
            if ~isempty(vectorsRow(k).mean)
                data{k+1} = vectorsRow(k).mean;
            else
                data{k+1} = NaN;
            end
        end
    end
    GeneralTable(j,:) =data;
end
end