function [Population,Rank,Dis] = EnvironmentalSelection(Population,W,N)
% The environmental selection of MaOEA/IGD

%------------------------------- Copyright --------------------------------
% Copyright (c) 2021 BIMK Group. You are free to use the PlatEMO for
% research purposes. All publications which use this platform or any code
% in the platform should acknowledge the use of "PlatEMO" and reference "Ye
% Tian, Ran Cheng, Xingyi Zhang, and Yaochu Jin, PlatEMO: A MATLAB platform
% for evolutionary multi-objective optimization [educational forum], IEEE
% Computational Intelligence Magazine, 2017, 12(4): 73-87".
%--------------------------------------------------------------------------

    %% Assign proximity distance
    [~,x]      = unique(round(Population.objs*1e4)/1e4,'rows');
    Population = Population(x);
    N          = min(N,length(Population));
    Rank = zeros(1,length(Population));
    Dis  = zeros(length(Population),size(W,1));
    
    %Counter of reference point dominated by each solution
    DomCount = zeros(1,length(Population));
    
    %Constraint violation sum of each individual
    CVS = sum(max(0,Population.cons),2);
    
    for i = 1 : length(Population)
        
        %Compare the current individual with all the reference points
        temp = repmat(Population(i).obj,size(W,1),1);
        
        %Determine if the solution dominates a reference point or if it is 
        % worse than some reference points
        domx = any(temp<W,2);
        domi = domx - any(temp>W,2);
        DomCount(i) = sum(domx);
        
        if CVS(i) <= 0 && any(domi==1)% the solution dominates reference points
            Rank(i)  = 1;
            Dis(i,:) = -sqrt(sum((temp-W).^2,2))';
        elseif CVS(i) <= 0 && any(domi==-1) %the solution is daminated by reference points
            Rank(i)  = 3;
            Dis(i,:) = sqrt(sum((temp-W).^2,2))';
        elseif CVS(i) <= 0 && any(domi==0)% the solutions is non dominated with reference point
            Rank(i)  = 2;
            Dis(i,:) = sqrt(sum(max(temp-W,0).^2,2))';
        elseif CVS(i) >= 0 && any(domi==1) && DomCount(i) == length(W)
            Rank(i)  = 4;
            Dis(i,:) = -sqrt(sum((temp-W).^2,2))';
        elseif CVS(i) >= 0 && any(domi==1)
            Rank(i)  = 5;
            Dis(i,:) = -sqrt(sum((temp-W).^2,2))';
        elseif CVS(i) >= 0 && any(domi==-1)
            Rank(i)  = 6;
            Dis(i,:) = sqrt(sum((temp-W).^2,2))';
        else
            Rank(i)  = 7;
            Dis(i,:) = sqrt(sum(max(temp-W,0).^2,2))';
        end 
    end

    %% Select the solutions in the first fronts
    MaxFNo = find(cumsum(hist(Rank,1:7))>=N,1);
    Next   = Rank < MaxFNo;
    
    %% Select the solutions in the last front
    Last   = find(Rank==MaxFNo);
    Choose = LastSelection(Dis(Last,:),N-sum(Next),W);
    Next(Last(Choose)) = true;
    % Population for next generation
    Population = Population(Next);
    Rank       = Rank(Next);
    Dis        = Dis(Next,:);
end

function Choose = LastSelection(Dis,K,W)
% Select part of the solutions in one front

    %% Select K points from W
    Distance = pdist2(W,W);
    Distance(logical(eye(length(Distance)))) = inf;
    Del = false(1,size(W,1));
    while sum(~Del) > K
        Remain   = find(~Del);
        Temp     = sort(Distance(Remain,Remain),2);
        [~,Rank] = sortrows(Temp);
        Del(Remain(Rank(1))) = true;
    end
    Dis = Dis(:,~Del);
    
    if false
        %% Hungarian method based selection
        Choose = Assignmentoptimal(Dis'-min(Dis(:)));
    else
        %% Greedy algorithm based selection (more efficient)
        Choose = false(1,size(Dis,1));
        for i = 1 : size(Dis,2)
            remain   = find(~Choose);
            [~,best] = min(Dis(remain,i));
            Choose(remain(best)) = true;
        end
    end
end