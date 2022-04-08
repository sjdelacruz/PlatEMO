function [pvalues] = WilcoxonGroups(cellG1, cellG2)

nExperiments = length(cellG1);
pvalues = zeros(1, nExperiments);

for i=1:nExperiments 
    res = ranksum(cellG1{i},cellG2{i});
    if isnan(res)
        pvalues(i) = 0;
    else
        pvalues(i) = res;
    end
end
end

