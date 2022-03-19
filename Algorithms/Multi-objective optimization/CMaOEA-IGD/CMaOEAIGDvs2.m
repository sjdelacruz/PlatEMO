classdef CMaOEAIGDvs2 < ALGORITHM
% <many> <real/binary/permutation>
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
            c=Algorithm.parameter{1}(1).Value;
            beta=Algorithm.parameter{1}(2).Value;
            alfa = Algorithm.parameter{1}(3).Value;
            %% Nadir point estimation
            [W,Problem.N] = UniformPoint(Problem.N,Problem.M);
            % Optimize Problem.M single-objective optimization problems
            Population = Problem.Initialization();
            
            %sum(max(0,Population.cons),2) violation sum
            g=1;
            while Algorithm.NotTerminated(Population) && Problem.FE < DNPE
                Offspring  = OperatorGA(Population(randi(end,1,Problem.N)),{0.9,20,1,20});
                Population = [Population,Offspring];
                [~,rank]   = sort(Fitness(Population.objs,Population.cons,c,beta,alfa, g),1);
                Population = Population(unique(rank(1:ceil(Problem.N/Problem.M),:)));
                g=g+1;
            end
            % Find the nadir point and ideal point
            [~,ext] = min(Fitness(Population.objs,Population.cons,c,beta,alfa, g),[],1);
            zmax    = diag(Population(ext).objs)';
            zmin    = min(Population.objs,[],1);
            zmax(zmax<1e-6) = 1;
            
            % Transform the points into the Utopian Pareto front
            W = W.*repmat(zmax-zmin,Problem.N,1) + repmat(zmin,Problem.N,1);

            %% Generate random population
            Population = Problem.Initialization();
            [Population,Rank,Dis] = EnvironmentalSelection(Population,W,Problem.N);

            %% Optimization
            while Algorithm.NotTerminated(Population)
                MatingPool = TournamentSelection(2,Problem.N,sum(max(0,Population.cons),2),Rank,min(Dis,[],2));
                Offspring  = OperatorGAhalf(Population(MatingPool));
                [Population,Rank,Dis] = EnvironmentalSelection([Population,Offspring],W,Problem.N);
            end
        end
    end
end

function fit = Fitness(PopObj,PopCon,c,beta,alfa,t)
% Calculate the objective value of each solution on each single-objective
% optimization problem in nadir point estimation
    fit   = zeros(size(PopObj));
    [~,nColumn] = size(PopCon);
  
    for j=1 : nColumn
        Column = PopCon(:,j);
        Column(Column <= 0) = 0;
        high=find(Column> 0);
        Column(high) = abs(Column(high));
        PopCon(:,j)= Column;
        PopCon(:,j) = PopCon(:,j).^beta;
    end
    
    penalty = ((c * t)^alfa) * sum(PopCon,2);
    
    for i = 1 : size(PopObj,2)
        fst =  abs(PopObj(:,i));
        snd = sum(PopObj(:,[1:i-1,i+1:end]).^2,2);
        fit(:,i) = fst + (100*snd) + penalty;
    end
   
end