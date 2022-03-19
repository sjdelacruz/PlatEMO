function [Experiment] = generateExperiment(Runs,Problem,M,D,MaxEvals,Save,Constrained)
    
Experiment.Runs = Runs;
Experiment.MOP = Problem;
Experiment.M = M;
Experiment.D = D;
Experiment.MaxEvals = MaxEvals;
Experiment.Save = Save;
Experiment.Constrained = Constrained;

end

