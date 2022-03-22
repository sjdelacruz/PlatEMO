function [results,means,stats,tbl] = StatisticalComparison(GeneralTable,name)
global path_figures

%Extract names of groups in the table
variablesName = GeneralTable.Properties.VariableNames(1,2:end);

%KruskalWallis test
[p,tbl,stats]=kruskalwallis(GeneralTable{:,2:end},variablesName);

%Bonferroni post hoc
[results,means,~,gnames] = multcompare(stats,'CType','bonferroni');
title(strcat('Comparison of all problems using ',name))

%Save figure
saveas(gcf,strcat(path_figures,'\','Bonferroni_General_',name,'.png'));
end