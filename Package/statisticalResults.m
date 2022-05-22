function table = statisticalResults(secundaryInformation,QIs,principalInformation)
nIndicators = length(QIs);
[exp,~] = size(secundaryInformation);
generalRows ={};

table = generateTableWilcoxon(QIs,'Indicators');


for i=1 : exp
    
    %Columns information
    currentExperiment = principalInformation(i,:);
    commonExperiment = currentExperiment{1,1}(:,1:2);
    
    %Histories to compare(both algorithms)
    currentInformation = secundaryInformation(i,:);
    [nVariations,~] = size(currentInformation{1,1});
    
    %Obtain the name of the experiment and the number of objectives
    common = commonExperiment;
    localRow={};
    
    %For each variation, its need compare both algorithms
    for var=1 : nVariations
        
        %Compute the wilcoxon based on each indicator information
        for ind=1: nIndicators
       
            infoFirst = currentInformation{1,1}{var,1}(:,ind);
            infoSecond = currentInformation{1,2}{var,1}(:,ind);
        
            try
                p = ranksum(infoFirst,infoSecond);
                pval{ind} = p;
            catch ME
                if (strcmp(ME.identifier,'stats:signrank:NotEnoughData'))
                    pval{ind}=NaN;
                end
            end
        end
        localRow{var} = pval;
    end
    generalRows = [ generalRows; [common,cat(1, localRow{:})]];
    
end
    
    union = [table2array(table.table);generalRows];
    table.table =  array2table(union);
end