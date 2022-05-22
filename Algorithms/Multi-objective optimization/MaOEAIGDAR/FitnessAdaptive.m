function Sum = FitnessAdaptive(PopObjs,PopCons)

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
    PopCons(:,i) = max(0,PopCons(:,i)) / max(1,consMax);
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

