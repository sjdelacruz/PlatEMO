clear all
clc
%Parameters
ruta= "C:\Users\Sebastian Jose\Desktop\PlatEMO\Data";
algoritmo = "CMaOEAIGDv1";
R= 20;
M = 3;
Max_Gen = 500;
N = 91;
D = M+4;
Max_FE = Max_Gen * N;

%Evaluate
Problem = "C1_DTLZ1";
QI = "IGD";

%Structures to load data and save indicators values
Data = {};
APF = {};
Metric =[];
Feasible = [];

%Obtaining the "TPF" to compare the aproximation
switch Problem 
    case "C1_DTLZ1"
        pro = C1_DTLZ1('N',N,'M',M,'D',D,'maxFE',Max_FE);  
    case "C2_DTLZ2"
        pro = C2_DTLZ2('N',N,'M',M,'D',D,'maxFE',Max_FE);  
    case "C3_DTLZ4"
        pro = C3_DTLZ4('N',N,'M',M,'D',D,'maxFE',Max_FE);  

end

%Loading all the results
for i=1 : R 
    Data{1,i}= load(ruta + "\" + algoritmo + "\" +algoritmo + "_" + Problem + "_M" + num2str(M)+"_D"+num2str(D)+"_" + num2str(i),"result");
    PFi= Data{1,i}.result{end};
    APF{1,i} = PFi;
    
    cpf = PFi(all(PFi.cons<=0,2));
    Fi = length(cpf);
    Feasible(1,i)= Fi;
    switch QI
        case "IGD"
            Metric = [Metric; IGD(cpf,pro.optimum)];
        case "HV"
            Metric = [Metric; HV(cpf,pro.optimum)];
        case "Spacing"
            Metric = [Metric; Spacing(cpf,pro.optimum)];
    end
end

Copia = Metric;
%Limpiando valores nulos
Metric(isnan(Metric)) = [];


%Estadistica

mejor = min(Metric)
promedio = mean(Metric)
peor = max(Metric)
fexe = length(Metric)
mf = mean(Feasible)

index = find(Copia == mejor);    
pfv = APF{1,index};
cpf = pfv(all(pfv.cons<=0,2)).objs;
scatter3(cpf(:,1),cpf(:,2),cpf(:,3))
title(algoritmo)
