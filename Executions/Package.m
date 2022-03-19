%Nombre: Sebastián José de la Cruz Martínez
%Experimentos en platEMO
clear all
clc

%Para establecer semilla
%rng('default');

%Global variables
global path_data;
global path_figures;
path_data = "C:\Users\Sebastian Jose\Desktop\PlatEMO\Data";
path_figures = 'C:\Users\Sebastian Jose\Desktop\PlatEMO\Figures';

if ~exist(path_figures)
    mkdir(path_figures)
end

%False == analize results
WhatDo=[false,true];

%Indicators to evaluate approximations
QIs = {@HV, @IGD, @Spacing};

%Problems to solve Runs,Problem,M,D,MaxEvals,Save,Constrained    
Experiments(1) = generateExperiment(20,@C1_DTLZ1,0,0,50000,500,true);
Experiments(2) = generateExperiment(20,@C1_DTLZ3,0,0,100000,500,true);
Experiments(3) = generateExperiment(20,@C2_DTLZ2,0,0,25000,500,true);
Experiments(4) = generateExperiment(20,@C3_DTLZ1,0,0,75000,500,true);
Experiments(5) = generateExperiment(20,@C3_DTLZ4,0,0,75000,500,true);
Experiments(6) = generateExperiment(20,@MW1,0,0,60000,500,true);
Experiments(7) = generateExperiment(20,@MW2,0,0,60000,500,true);
Experiments(8) = generateExperiment(20,@MW3,0,0,60000,500,true);
Experiments(9) = generateExperiment(20,@MW4,0,0,60000,500,true);
Experiments(10) = generateExperiment(20,@MW5,0,0,60000,500,true);
Experiments(11) = generateExperiment(20,@MW6,0,0,60000,500,true);
Experiments(12) = generateExperiment(20,@MW7,0,0,60000,500,true);
Experiments(13) = generateExperiment(20,@MW8,0,0,60000,500,true);
Experiments(14) = generateExperiment(20,@MW9,0,0,60000,500,true);
Experiments(15) = generateExperiment(20,@MW10,0,0,60000,500,true);
Experiments(16) = generateExperiment(20,@MW11,0,0,60000,500,true);
Experiments(17) = generateExperiment(20,@MW12,0,0,60000,500,true);
Experiments(18) = generateExperiment(20,@MW13,0,0,60000,500,true);
Experiments(19) = generateExperiment(20,@MW14,0,0,60000,500,true);


%Algorithms in experimentation
%Warning when use the same algorithm. If is the case, use differents extra
%parameters
Algorithms(1) = generateAlgorithm(@CMaOEAIGDvs1, 'MaOEAIGD con Penalidad Recocido',100,{});
Algorithms(2) = generateAlgorithm(@CMaOEAIGDvs2, 'MaOEAIGD con Penalidad Dinámica Joines and Houck',100,...
    struct('Name',{'C','Beta','Alfa'}, 'Value',{0.5,2,2}));
Algorithms(3) = generateAlgorithm(@NSGAIII, 'NSGAIII',100,{});
%Algorithms(3) = generateAlgorithm(@CMaOEAIGDvs3, 'MaOEAIGD con Penalidad Recocido',91,{});

if WhatDo(1) == true
    executeExperiments(Experiments,Algorithms);
end
   
if WhatDo(2) == true
Results = generateResults(Experiments,Algorithms,QIs);
ListTables = generateInformation(Results,QIs,Experiments);

%Join all results;
%statisticalComparison(ListTables,length(Algorithms),1);
end