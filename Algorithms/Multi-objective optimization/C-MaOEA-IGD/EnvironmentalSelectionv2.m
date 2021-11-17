function [Population,Rank,Dis] = EnvironmentalSelectionv2(Population,W,N)
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
    DomCount = 0;
    
    %Constraint violation sum of each individual
    CVS = sum(max(0,Population.cons),2);
    
    for i = 1 : length(Population)
        
        %Compare the current individual with all the reference points
        temp = repmat(Population(i).obj,size(W,1),1);
        
        %Determine if the solution dominates a reference point or if it is 
        % worse than some reference points
        domi = any(temp<W,2) - any(temp>W,2);
      
        %If the solution is feasible and dominates at least one reference
        %point
        if CVS(i) <= 0 && any(domi==1)
            Rank(i)  = 1;
            Dis(i,:) = -sqrt(sum((temp-W).^2,2))';
        %if the solution is feasible and if its nondominated by a part of reference points  
        elseif CVS(i) <= 0 && any(domi==0)
            Rank(i)  = 2;
            Dis(i,:) = sqrt(sum(max(temp-W,0).^2,2))';
            
            DomCount_ = sum(domi);
            if DomCount_ > DomCount
                DomCount = DomCount_;
            end
        %if the solution is non feasible but dominates all reference points    
        elseif all(domi==1) 
            Rank(i)  = 3;
            Dis(i,:) = -sqrt(sum((temp-W).^2,2))';
        %if the solution ins non feasible but dominates at least one
        %reference point
        elseif any(domi==1)
            Rank(i)  = 4;
            Dis(i,:) = -sqrt(sum((temp-W).^2,2))';
        %if the solutions are dominad by a part of reference points   
        elseif any(domi==-1)
            Rank(i)  = 6;
            Dis(i,:) = sqrt(sum((temp-W).^2,2))';
        %if the solutions  is nondominated by reference points any(domi==0)
        else
            Rank(i)  = 5;
            Dis(i,:) = sqrt(sum(max(temp-W,0).^2,2))';
        end
    end

    %% Select the solutions in the first fronts
    MaxFNo = find(cumsum(hist(Rank,1:6))>=N,1);
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