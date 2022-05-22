%Nombre: Sebastián José de la Cruz Martínez

%What to do
%First-> Solve experiments
%Second-> Load Results in tables and collect for convergence
%Third-> Print tables based on Indicators
%Fourth-> Statistical results
whatDo=[1,0,0,0];

%Get the path where Data are stored
data_ = what('Data');
global path_data;
path_data = data_.path;

figures_ = what('Figs');
global path_figures;
path_figures = figures_.path;

%Quality indicators to be calculated
QIs = {@HV,@IGD,@Spacing};

%Define experiments
runs=30;
Experiments(1) = generateExperiment('C1_DTLZ1',{runs,runs},{2,3},{6,7},{50000,60000});
Experiments(2) = generateExperiment('C1_DTLZ3',{runs,runs},{2,3},{11,12},{50000,60000});
Experiments(3) = generateExperiment('C2_DTLZ2',{runs},{2},{11},{50000});
Experiments(4) = generateExperiment('C3_DTLZ4',{runs},{2},{11},{50000});
Experiments(5) = generateExperiment('MW1',{runs},{2},{15},{60000});
Experiments(6) = generateExperiment('MW2',{runs},{2},{15},{60000});
Experiments(7) = generateExperiment('MW3',{runs},{2},{15},{60000});
Experiments(8) = generateExperiment('MW4',{runs},{3},{15},{60000});
Experiments(9) = generateExperiment('MW5',{runs},{2},{15},{60000});
Experiments(10) = generateExperiment('MW6',{runs},{2},{15},{60000});
Experiments(11) = generateExperiment('MW7',{runs},{2},{15},{60000});
Experiments(12) = generateExperiment('MW8',{runs},{3},{15},{60000});
Experiments(13) = generateExperiment('MW9',{runs},{2},{15},{60000});
Experiments(14) = generateExperiment('MW10',{runs},{2},{15},{60000});
Experiments(15) = generateExperiment('MW11',{runs},{2},{15},{60000});
Experiments(16) = generateExperiment('MW12',{runs},{2},{15},{60000});
Experiments(17) = generateExperiment('MW13',{runs},{2},{15},{60000});
Experiments(18) = generateExperiment('MW14',{runs},{3},{15},{60000});
Experiments(19) = generateExperiment('LIRCMOP1',{runs},{2},{30},{300000});
Experiments(20) = generateExperiment('LIRCMOP2',{runs},{2},{30},{300000});
Experiments(21) = generateExperiment('LIRCMOP3',{runs},{2},{30},{300000});
Experiments(22) = generateExperiment('LIRCMOP4',{runs},{2},{30},{300000});
Experiments(23) = generateExperiment('LIRCMOP5',{runs},{2},{30},{300000});
Experiments(24) = generateExperiment('LIRCMOP6',{runs},{2},{30},{300000});
Experiments(25) = generateExperiment('LIRCMOP7',{runs},{2},{30},{300000});
Experiments(26) = generateExperiment('LIRCMOP8',{runs},{2},{30},{300000});
Experiments(27) = generateExperiment('LIRCMOP9',{runs},{2},{30},{300000});
Experiments(28) = generateExperiment('LIRCMOP10',{runs},{2},{30},{300000});
Experiments(29) = generateExperiment('LIRCMOP11',{runs},{2},{30},{300000});
Experiments(30) = generateExperiment('LIRCMOP12',{runs},{2},{30},{300000});
Experiments(31) = generateExperiment('LIRCMOP13',{runs},{3},{30},{300000});
Experiments(32) = generateExperiment('LIRCMOP14',{runs},{3},{30},{300000});

%Define Algorithms and their configurations for problems
configurations = {'C1_DTLZ1',2,100;
'C1_DTLZ1',3,300;
'C1_DTLZ3',2,100;
'C1_DTLZ3',3,300;
'C2_DTLZ2',2,100;
'C3_DTLZ4',2,100;
'MW1',2,100;
'MW2',2,100;
'MW3',2,100;
'MW4',3,100;
'MW5',2,100;
'MW6',2,100;
'MW7',2,100;
'MW8',3,100;
'MW9',2,100;
'MW10',2,100;
'MW11',2,100;
'MW12',2,100;
'MW13',2,100;
'MW14',3,100;
'LIRCMOP1',2,300;
'LIRCMOP2',2,300;
'LIRCMOP3',2,300;
'LIRCMOP4',2,300;
'LIRCMOP5',2,300;
'LIRCMOP6',2,300;
'LIRCMOP7',2,300;
'LIRCMOP8',2,300;
'LIRCMOP9',2,300;
'LIRCMOP10',2,300;
'LIRCMOP11',2,300;
'LIRCMOP12',2,300;
'LIRCMOP13',3,300;
'LIRCMOP14',3,300;
};

Algorithms(1) = generateAlgorithm('MaOEAIGDDR', 'MaOEAIGDDR',configurations,{'C',0.9;'Beta',1;'Alfa',1});
Algorithms(2) = generateAlgorithm('MaOEAIGDAR', 'MaOEAIGDAR',configurations);

%Solve problems
if whatDo(1) == true
    %Execute each algorithm in each experiment
    solveExperiments(Experiments,Algorithms,'reproducibility',0)
end

%Load the results by algorithm in each experiment and their variations
if whatDo(2) == true
    [principalInformation,statisticsInformation] = generateResults(Experiments,Algorithms,QIs);
end

%Generate statistical results
if whatDo(3) == true
    generalTables = printResults(principalInformation,Algorithms,QIs);
end

if whatDo(4) == true
%     name= {Algorithms(:).name};
%     name = strcat(name(1), '_vs_', name(2));
    wilcoxon = statisticalResults(statisticsInformation,QIs,principalInformation);
end
