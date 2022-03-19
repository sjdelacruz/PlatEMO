function statisticalComparison(Results,nAlg,ind)
global path_figures

[~,m] = size(Results);

Valores=size(m,nAlg);

%For all experiments
for i=1:m 
    
    %For each algorithm in the experiment
    for j=1: nAlg
        
        %Take the results for the ith experiment and the values of the
        %desired indicator
        estructura_ =Results(i).answer;
        renglones = estructura_(ind).renglones;
        
        %Store the value of the algoritm in the matrix
        if isempty(renglones(j).promedio)
            Valores(i,j) = -1;
        else
            Valores(i,j) = renglones(j).promedio;
        end
    end
end

[p,tbl,stats]=kruskalwallis(Valores,{'CMaOEAIGDvs1';'CMaOEAIGDvs2';'NSGAIII'});
[results,means,~,gnames] = multcompare(stats,'CType','bonferroni');
saveas(gcf,strcat(path_figures,'\','Bonferroni_General',estructura_(ind).nombre,'.png'));


end