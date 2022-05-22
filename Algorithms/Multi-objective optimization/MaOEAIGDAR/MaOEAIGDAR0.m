classdef MaOEAIGDAR0 < ALGORITHM
    % <many> <real/binary/permutation>
    % IGD based many-objective evolutionary algorithm
    % Its include an Adaptive penalty function
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
            
            %Structure for save the results
            %First column for feasibles counter of Offpsring and the second
            %for the population in the environmental selection
            genFeasibles = zeros(1,2);
            genFeasibles(1,2) = CounterFeasibles(Population);
            
            currentGen=2;
            while Algorithm.NotTerminated(Population) && Problem.FE < DNPE
                
                Offspring  = OperatorGA(Population(randi(end,1,Problem.N)),{0.9,20,1,20});
                
                %Count the number of feasible individuals generated in the
                %offspring stage
                genFeasibles(currentGen,1) = CounterFeasibles(Offspring);
                
                Population = [Population,Offspring];
                
                %currentGen-1 because the index of the structure start in 2
                %and not in 1, that its the real generation. I considered
                %save the feasible solutions in the base population.
                
                %rank return the indexes of the values ordered by column in
                %ascendent order.
                [~,rank]   = sort(FitnessAdaptive(Population.objs,Population.cons),1);
                
                %N/M percentage of the indexes are selected and ordered in
                %one column without repetition.
                Population = Population(unique(rank(1:ceil(Problem.N/Problem.M),:)));
                [Population,Rank,Dis] = EnvironmentalSelection([Population,Offspring],W,Problem.N);

                %Count the feasible indivuals of the current population
                genFeasibles(currentGen,2) = CounterFeasibles(Population);
                
                %Increment the generation counter
                currentGen= currentGen+1;
            end
            
            GeneralProcess.initRPG = genFeasibles;
            
            % Find the nadir point and ideal point
            [~,ext] = min(FitnessAdaptive(Population.objs,Population.cons),[],1);
            zmax    = diag(Population(ext).objs)';
            zmin    = min(Population.objs,[],1);
            zmax(zmax<1e-6) = 1;
            
            % Transform the points into the Utopian Pareto front
            W = W.*repmat(zmax-zmin,Problem.N,1) + repmat(zmin,Problem.N,1);
            
            %Saving the structure and others variables of interest
            GeneralProcess.initRP = W;
            
            %% Generate random population
            Population = Problem.Initialization();
            [Population, Rank, Dis] = EnvironmentalSelection(Population, W, Problem.N);

            onlineFC = zeros(1,2);
            onlineFC(1,2) = CounterFeasibles(Population);
            GeneralProcess.onlineFC = onlineFC;
            
            %Saving in the super class to next save
            Algorithm.SearchProcess = GeneralProcess;
            
            %% Optimization
            currentGen=2;
            while Algorithm.NotTerminated(Population)
                
                %The mating pool is done based on the new fitness
                MatingPool = TournamentSelection(2, Problem.N, Rank, min(Dis,[],2));
                Offspring  = OperatorGAhalf(Population(MatingPool));
                
                %Save the feasible individuals producen in the offspring
                %stage
                Algorithm.SearchProcess.onlineFC(currentGen,1) = CounterFeasibles(Offspring);
                
                %Environmetal selection phase
                %currentGen-1 because the index of the structure start in 2
                %and not in 1, that its the real generation
                
                %The environmental is based on non-dominated sorting and
                %the crowding distance.
                [Population, Rank, Dis] = EnvironmentalSelection(Population, W, Problem.N);
                Algorithm.SearchProcess.onlineFC(currentGen,2) = CounterFeasibles(Population);
                
                %Reference points update
                W = UpdatePointsAdaptive(W, Population);
                
                %Computing others metrics
                Algorithm.FeasibleR = [Algorithm.FeasibleR; FeasibleRatio(Population.cons,Problem.N)];
                Algorithm.RandomWalk = [Algorithm.RandomWalk; RandomWalkFeature(Population.cons,Problem.N)];
                currentGen= currentGen +1;
            end
        end
    end
end