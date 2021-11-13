%Sebastián José de la Cruz Martínez
%Main parameters

clear all
clc

R=20;
M = 15;
Max_Gen = 1500;
N = 135;
D = M+4;
Problem = @C1_DTLZ1;
Algorithm = @CMaOEAIGDv1;

%Extras parameters
Max_NFE = N * Max_Gen;
Save = 1;

for i=1 : R 
    platemo('algorithm',Algorithm,'problem',Problem,'N',N,'M',M,'D',D,'maxFE',Max_NFE,'save',Save,'run',i);
    %platemo('algorithm',@NSGAIII,'problem',Problem,'N',N,'M',M,'D',D,'maxFE',Max_NFE,'save',Save);
end

