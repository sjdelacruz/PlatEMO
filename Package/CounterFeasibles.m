%Count the number of feasible solutions in the population
function n = CounterFeasibles(Population)
cvs = sum(max(0,Population.cons),2);
bool = cvs <=0;
n = sum(bool);
end

