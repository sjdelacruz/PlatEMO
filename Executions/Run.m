%Nombre: Sebasti�n Jos� de la Cruz Mart�nez
%Script to runs experiments in platEMO and obtain experiments
clear all
clc

%To set seed
rng('default');
global reproducibility;
global save_figures;
reproducibility = true;


%Global paths
global path_data;
global path_figures;
global whatAnalyze;
path_data = "C:\Users\Sebastian Jose\Desktop\PlatEMO\Data";
path_figures = 'C:\Users\Sebastian Jose\Desktop\PlatEMO\Figures';
save_figures = true;

whatAnalyze=1;

%Indicators to evaluate results
QIs = {@HV,@IGD};

%False == analize results
whatDo=[true,true];

%Configurations of experimentation and algorithms

%To set an experiments, the user need to pass the number of independents
%runs, the funtion handle of the problem, M objectives, D dimensions,
%Maxevals, the number of functions evaluations to save the population to
%generate convergence, and if it is a constrained problem

%Example Experiment(i) =
%generateExperiment(Runs,Problem,M,D,MaxEvals,Save)
Exe=20;
Experiments(1) = GenerateExperiment(Exe,@C1_DTLZ1,3,7,75000,1000);
Experiments(2) = GenerateExperiment(Exe,@C1_DTLZ3,3,12,75000,1000);
Experiments(3) = GenerateExperiment(Exe,@C2_DTLZ2,3,12,75000,1000);
Experiments(4) = GenerateExperiment(Exe,@C3_DTLZ4,3,12,75000,1000);
Experiments(5) = GenerateExperiment(Exe,@MW1,2,15,60000,1000);
Experiments(6) = GenerateExperiment(Exe,@MW2,2,15,60000,1000);
Experiments(7) = GenerateExperiment(Exe,@MW3,2,15,60000,1000);
Experiments(8) = GenerateExperiment(Exe,@MW4,3,15,60000,1000);
Experiments(9) = GenerateExperiment(Exe,@MW5,2,15,60000,1000);
Experiments(10) = GenerateExperiment(Exe,@MW6,2,15,60000,1000);
Experiments(11) = GenerateExperiment(Exe,@MW7,2,15,60000,1000);
Experiments(12) = GenerateExperiment(Exe,@MW8,3,15,60000,1000);
Experiments(13) = GenerateExperiment(Exe,@MW9,2,15,60000,1000);
Experiments(14) = GenerateExperiment(Exe,@MW10,2,15,60000,1000);
Experiments(15) = GenerateExperiment(Exe,@MW11,2,15,60000,1000);
Experiments(16) = GenerateExperiment(Exe,@MW12,2,15,60000,1000);
Experiments(17) = GenerateExperiment(Exe,@MW13,2,15,60000,1000);
Experiments(18) = GenerateExperiment(Exe,@MW14,3,15,60000,1000);

% Experiments(1) = GenerateExperiment(15,@MW4,5,15,100000,1000);
% Experiments(2) = GenerateExperiment(15,@MW8,5,15,100000,1000);
% Experiments(3) = GenerateExperiment(15,@MW14,5,15,100000,1000);
% Experiments(4) = GenerateExperiment(15,@MW4,10,15,200000,1000);
% Experiments(5) = GenerateExperiment(15,@MW8,10,15,200000,1000);
% Experiments(6) = GenerateExperiment(15,@MW14,10,15,200000,1000);

% Experiments(1) = GenerateExperiment(30,@LIRCMOP1,2,30,300000,1000);
% Experiments(16) = GenerateExperiment(30,@LIRCMOP2,2,30,300000,1000);
% Experiments(17) = GenerateExperiment(30,@LIRCMOP3,2,30,300000,1000);
% Experiments(18) = GenerateExperiment(30,@LIRCMOP4,2,30,300000,1000);
% Experiments(19) = GenerateExperiment(30,@LIRCMOP5,2,30,300000,1000);
% Experiments(20) = GenerateExperiment(30,@LIRCMOP6,2,30,300000,1000);
% Experiments(21) = GenerateExperiment(30,@LIRCMOP7,2,30,300000,1000);
% Experiments(22) = GenerateExperiment(30,@LIRCMOP8,2,30,300000,1000);
% Experiments(23) = GenerateExperiment(30,@LIRCMOP9,2,30,300000,1000);
% Experiments(24) = GenerateExperiment(30,@LIRCMOP10,2,30,300000,1000);
% Experiments(25) = GenerateExperiment(30,@LIRCMOP11,2,30,300000,1000);
% Experiments(26) = GenerateExperiment(30,@LIRCMOP12,2,30,300000,1000);
% Experiments(27) = GenerateExperiment(30,@LIRCMOP13,3,30,300000,1000);
% Experiments(28) = GenerateExperiment(30,@LIRCMOP14,3,30,300000,1000);

%Warning when use the same algorithm because going to execute the same 
%version whithout execute the desired variant. If is the case, use 
%differents extra parameters

%The parameters are the function handle of the algorithm, the description
%of the algorithms, N individuals, and if its necesarry additionals
%paramteres that need be handled by ALGORITHM.ParameterSet of platEMO

%Example: Algorithms(1) = GenerateAlgorithm(@CMaOEAIGDvs2, 'MaOEAIGD con 
%Penalidad Din�mica Joines and Houck',100,struct('Name',{'C','Beta','Alfa'}, 
%'Value',{0.5,2,2}));
%Algorithms(1) = GenerateAlgorithm(@CMaOEAIGDvs1, 'MaOEAIGD_Penalidad_Recocido',100,{});
Algorithms(1) = GenerateAlgorithm(@CMaOEAIGDvs2, 'MaOEAIGD_Penalidad_Din�mica_Joines and Houck',100,...
    struct('Name',{'C','Beta','Alfa'}, 'Value',{0.5,2,2}));
N=100;
NDPE= 100*N;
k=(NDPE/5)/100;
Algorithms(2) = GenerateAlgorithm(@CMaOEAIGDvs3, 'MaOEAIGD_Adaptive_penalty',N,{});
%Algorithms(4) = GenerateAlgorithm(@TiGE2, 'Three indicators',300,{});
%Algorithms(5) = GenerateAlgorithm(@CCMO, 'Coevolutionary framework',300,{});
%Algorithms(6) = GenerateAlgorithm(@MOEADDAE, 'MOEAD with detect-and-escape strategy',300,{});
%Algorithms(7) = GenerateAlgorithm(@CTAEA, 'Two-archive evolutionary algorithm',300,{});

%Verify if is necessary to solve experiments
if whatDo(1) == true
    ExecuteExperiments(Experiments,Algorithms);
end

%Save the results
%t = datetime;
%name= path_data + 'Results_experiments_' + datestr(t,'mm_dd_yyyy HH_MM_SS AM');
%save(name);

%Verify if is necessary to generate information obtained of algorithm(s) in
%experiment(s)
if whatDo(2) == true
    Results = GenerateResults(Experiments,Algorithms,QIs);
    ListTables = GenerateInformation(Experiments,Algorithms,Results,QIs);
    %GeneralTables = ConstructGeneralTable(Experiments,QIs,ListTables);
    Especialized = ConstructEspecializedTable(Experiments,Algorithms,QIs,ListTables,whatAnalyze);
    
    %Join all results
    [statisticalResults,means,stats,tbl] =StatisticalComparison(Especialized,func2str(QIs{whatAnalyze}));
end

% recocido = readExecutions(Experiments,Algorithms(1),QIs{1});
 dinamico = readExecutions(Experiments,Algorithms(1),QIs{1});
 adaptativo = readExecutions(Experiments,Algorithms(2),QIs{1});
% 
% A = WilcoxonGroups(recocido, dinamico);
 B= WilcoxonGroups(dinamico, adaptativo);
% C= WilcoxonGroups(recocido, adaptativo);
