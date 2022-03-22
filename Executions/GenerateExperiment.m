%function to generate a structure called Experiment with the main objective
%to pass all the data of the experiment which it is wanted to solve to the 
%main method platEMO()
function [experiment] = GenerateExperiment(Runs,Problem,M,D,MaxEvals,Save)
experiment.runs = Runs;
experiment.mop = Problem;
experiment.m = M;
experiment.d = D;
experiment.maxEvals = MaxEvals;
experiment.save = Save;
end

