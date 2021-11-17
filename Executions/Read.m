clear all
clc
%Parameters
ruta= "C:\Users\Sebastian Jose\Desktop\PlatEMO\Data";
Problem = "C2_DTLZ2";
algoritmo2 = "CMaOEAIGDv2";
algoritmo1 = "NSGAIII";
QI = "HV";
%algoritmo = "CMaOEAIGDv1";
R= 20;
M = 8;
Max_Gen = 500;


switch M
    case 3
        N = 91;
    case 5
        N = 210;
    case 8
        N = 156;
    case 10
        N = 275;
end

switch Problem
    
    case "C1_DTLZ1"
        D = M+4;
    otherwise
        D = M+9;
end
Max_FE = Max_Gen * N;



x = generaIndicador(R,N, M, D, Max_FE, ruta, algoritmo1, Problem, QI);
y = generaIndicador(R,N, M, D, Max_FE, ruta, algoritmo2, Problem, QI);
[p,h] = ranksum(x,y)


function Metric = generaIndicador(R, N, M, D, Max_FE, ruta, algoritmo, Problem, QI)
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
    case "C1_DTLZ3"
        pro = C1_DTLZ3('N',N,'M',M,'D',D,'maxFE',Max_FE); 

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

%Limpiando valores nulos
Metric(isnan(Metric)) = [];
Copia = Metric;
end
% %Estadistica
% 
% switch QI
%     
%     case "IGD"
%         mejor = min(Metric)
%         promedio = mean(Metric)
%         peor = max(Metric)
%         fexe = length(Metric)
%         mf = mean(Feasible)
%     case "HV"
%         mejor = max(Metric)
%         promedio = mean(Metric)
%         peor = min(Metric)
%         fexe = length(Metric)
%         mf = mean(Feasible)
% end
% 
% index = find(Copia == mejor);    
% pfv = APF{1,index};
% cpf = pfv(all(pfv.cons<=0,2)).objs;
% scatter3(cpf(:,1),cpf(:,2),cpf(:,3))
% title(algoritmo)


