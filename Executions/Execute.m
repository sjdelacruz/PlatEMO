%Sebastián José de la Cruz Martínez
clear all
clc

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%General parameters%%%%%%%%%%%%%%%%%%%%
R=20;
M =5;
Max_Gen = 1250;
N = 210;
D = M+9;
Problem = @C3_DTLZ4;
Max_NFE = N * Max_Gen;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Algorithms%%%%%%%%%%%%%%%%%%%%%%%%%%%%                    
nsgaiii = @NSGAIII;
vs1 = @CMaOEAIGDv1;
vs2 = @CMaOEAIGDv2;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
execute(nsgaiii,Problem,R,Max_NFE,M,D,N);
execute(vs1,Problem,R,Max_NFE,M,D,N);
execute(vs2,Problem,R,Max_NFE,M,D,N);


function execute(Algorithm, Problem, Runs, Max_NFE, Objectives, Dimensions, Individuals)
    for i=1 : Runs
        platemo('algorithm',Algorithm,'problem',Problem,'N',Individuals,'M',Objectives,'D',Dimensions,'maxFE',Max_NFE,'save',1,'run',i);
    end
end