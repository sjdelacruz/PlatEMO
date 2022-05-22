function value = RandomWalkFeature(PopCons, N)
cvs = sum(max(0,PopCons),2);
Counter=0;

for i=1 : N-1
    if ~(cvs(i) == 0 && cvs(i+1) == 0)
        Counter = Counter+1;
    end
end
value = (1/(N-1)) * Counter;
end

