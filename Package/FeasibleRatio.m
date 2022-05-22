function value = FeasibleRatio(PopCons, N)
cvs = sum(max(0,PopCons),2);
feasibles = cvs == 0;
value = sum(feasibles)/N;
end

