function statistics = createTable(Indicator,Value_Indicator)
Titulo = {'Algoritmo'; 'Min'; 'Max'; 'Mean'; 'Std'; 'Feasibles'};

[r,~] = size(Value_Indicator);
MOEAs = [];
Mins = [];
Maxs = [];
Means = [];
Stds = [];
Feasibles = [];
for i=1 : r
   [Min,Max,Mean,Std,Feasible] = Statistics(cell2mat(Value_Indicator{i,2}.'));
   MOEAs{i,1} = Value_Indicator{i,1};
   Mins(i,1) = Min;
   Maxs(i,1) = Max;
   Means(i,1) = Mean;
   Stds(i,1) = Std;
   Feasibles(i,1) = Feasible;
end
statistics = table(MOEAs,Mins, Maxs,Means,Stds,Feasibles, 'VariableNames', Titulo);
end

