function bigTable = ConstructGeneralTable(experiments,QIs, listTable)

nExperiments = length(experiments);
nIndicators = length(QIs);
bigTable = cell(nExperiments,1);
nameIndicators = strings(1,nIndicators);
for i=1 : nIndicators
    bigTable{i}.indicator = func2str(QIs{i});
    nameIndicators(i) =  bigTable{i}.indicator;
    bigTable{i}.data =[];
end

for j=1 : nExperiments
      
    results = length(listTable(j).answer);
    vectorsRow = listTable(j).answer;
    
    for k=1: results
        
        %Count how rows are in the results of indicators (not always are 
        %equal to the number of indicators, not always can be computed)
        nRows = length(vectorsRow{k}.stadistics);
        
        %detect what indicator is extracting information
        index = find(vectorsRow{k}.name == nameIndicators);
        
        %Generate the identification problem for rows
        prob =  convertCharsToStrings(func2str(experiments(j).mop));
        probNames = repmat(prob,nRows,1);
        
        %Desired data in table
        problemName = array2table( probNames , 'VariableNames',{'Problem'}); 
        partialTable = [problemName struct2table(vectorsRow{k}.stadistics)];
        bigTable{index}.data = [bigTable{index}.data ; partialTable]; 
    end
end
end