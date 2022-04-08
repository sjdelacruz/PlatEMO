classdef CMaOEAIGDvs3 < ALGORITHM
% <many> <real/binary/permutation>
% Adaptive penalty function
% IGD based many-objective evolutionary algorithm
% DNPE --- --- Number of evaluations for nadir point estimation

%------------------------------- Reference --------------------------------
% Y. Sun, G. G. Yen, and Z. Yi, IGD indicator-based evolutionary algorithm
% for many-objective optimization problems, IEEE Transactions on
% Evolutionary Computation, 2018.
%------------------------------- Copyright --------------------------------
% Copyright (c) 2021 BIMK Group. You are free to use the PlatEMO for
% research purposes. All publications which use this platform or any code
% in the platform should acknowledge the use of "PlatEMO" and reference "Ye
% Tian, Ran Cheng, Xingyi Zhang, and Yaochu Jin, PlatEMO: A MATLAB platform
% for evolutionary multi-objective optimization [educational forum], IEEE
% Computational Intelligence Magazine, 2017, 12(4): 73-87".
%--------------------------------------------------------------------------

    methods
        function main(Algorithm,Problem)
            %% Parameter setting
            DNPE = 100*Problem.N;

            %% Nadir point estimation
            [W,Problem.N] = UniformPoint(Problem.N,Problem.M);
            % Optimize Problem.M single-objective optimization problems
            Population = Problem.Initialization();
            
            while Algorithm.NotTerminated(Population) && Problem.FE < DNPE
                Offspring  = OperatorGA(Population(randi(end,1,Problem.N)),{0.9,20,1,20});
                Population = [Population,Offspring];
                [~,rank]   = sort(Fitness(Population.objs,Population.cons),1);
                Population = Population(unique(rank(1:ceil(Problem.N/Problem.M),:)));
                
            end
            % Find the nadir point and ideal point
            [~,ext] = min(Fitness(Population.objs,Population.cons),[],1);
            zmax    = diag(Population(ext).objs)';
            zmin    = min(Population.objs,[],1);
            zmax(zmax<1e-6) = 1;
            
            % Transform the points into the Utopian Pareto front
            W = W.*repmat(zmax-zmin,Problem.N,1) + repmat(zmin,Problem.N,1);

            %% Generate random population
            Population = Problem.Initialization();
            [Population,Rank,Dis] = EnvironmentalSelection(Population,W,Problem.N);

            %% Optimization
            g=1;
            while Algorithm.NotTerminated(Population)
                MatingPool = TournamentSelection(2,Problem.N,sum(max(0,Population.cons),2),Rank,min(Dis,[],2));
                Offspring  = OperatorGAhalf(Population(MatingPool));
                [Population,Rank,Dis] = EnvironmentalSelection([Population,Offspring],W,Problem.N);
                
                if mod(g,50) == 0
                    [~,ext] = min(Fitness(Population.objs,Population.cons),[],1);
                    zmax    = diag(Population(ext).objs)';
                    zmin    = min(Population.objs,[],1);
                    zmax(zmax<1e-6) = 1;
                    
                    % Transform the points into the Utopian Pareto front
                    W = W.*repmat(zmax-zmin,Problem.N,1) + repmat(zmin,Problem.N,1);
                end
                g=g+1;

            end
        end
    end
end

function Sum = Fitness(PopObjs,PopCons)
% Calculate the objective value of each solution on each single-objective
% optimization problem in nadir point estimation
fit   = zeros(size(PopObjs));
for i = 1 : size(PopObjs,2)
    fst =  abs(PopObjs(:,i));
    snd = sum(PopObjs(:,[1:i-1,i+1:end]).^2,2);
    fit(:,i) = fst + (100*snd);
end

PopNorm = ObjsNormalization(fit);
CVS = ConsNormalization(PopCons);
[DisValues,rf] = DistanceValues(PopNorm,CVS);
[Penalties] = ComputePenalties(PopNorm, CVS,rf);

Sum = DisValues + Penalties;
end

function PopObjs = ObjsNormalization(PopObjs)
[~,m] = size(PopObjs);

for i=1: m
    fmin = min(PopObjs(:,i));
    fmax = max(PopObjs(:,i));
    PopObjs(:,i) = (PopObjs(:,i) - fmin) / (fmax-fmin);
end
end

function CVS = ConsNormalization(PopCons)

[~,p] = size(PopCons);

for i=1: p
    consMax = max(PopCons(:,i));
    PopCons(:,i) = max(0,PopCons(:,i)) / consMax;
end

CVS = sum(PopCons,2) * (1/p);
end

function [DisValues,rf] = DistanceValues(PopObs,PopCons)

[n,m] = size(PopObs);
feasibles = PopCons(PopCons == 0);
nFeasibles = length(feasibles);

DisValues = zeros(n,m);
rf = nFeasibles /n;

for i=1: m
     if rf == 0
         DisValues(:,i) = PopCons;
     else
         DisValues(:,i) = sqrt(PopObs(:,i).^2 + PopCons.^2); 
     end  
end
end

function Penalties = ComputePenalties(PopObjs, PopCons,rf)
[n,m] = size(PopObjs);

Xs = zeros(n,m);
Ys = zeros(n,m);
Penalties = zeros(n,m);

for i=1:m
    if rf ~= 0
        Xs(:,i) = PopCons;
    end
    
    for j=1:n
        if PopCons(j) ~= 0
            Ys(j,i)= PopObjs(j,i);
        end
    end
     Penalties(:,i) = ((1-rf) .* Xs(:,i)) + (rf .* Ys(:,i));
end



end

% function best = ObtainBest(Population)
% 
% n = length(Population);
% m= length(Population(1).obj);
% best= cell(1,n);
% 
% Objs_ = Population.objs;
% Cons_= Population.cons;
% for i=1 : m
%     
%     Objs= Objs_(:,i);
%     Cons = max(0,Cons_(:,i));
%     preProcess = [Cons,Objs];
%     [~,localIndexes] = sortrows(preProcess,[1,2]);
%     best{1,i} = Population(localIndexes(1));
% end
% end