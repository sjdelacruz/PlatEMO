%Generate structure algorithm to pass to the main function of platEMO
function [algorithm] = GenerateAlgorithm(Function,Description,N,ExtraParameters)
algorithm.function =Function;
algorithm.description = Description;
algorithm.n = N;
algorithm.parameters = ExtraParameters;
end

