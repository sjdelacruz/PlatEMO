function W = UpdatePoints(fit,currentW)

%Join of reference points and the points based on the current population
R = [currentW;fit];

%Compute size of references points and the set joined
[nCurrentW,~] = size(currentW);

%% Non-dominated sorting based on the fitness computed
[FrontNo,MaxFNo] = NDSort(R,nCurrentW);
Next = FrontNo < MaxFNo;

%% Calculate the crowding distance of each solution
CrowdDis = CrowdingDistance(fit,FrontNo);

%% Select the solutions in the last front based on their crowding distances
Last     = find(FrontNo==MaxFNo);
[~,Rank] = sort(CrowdDis(Last),'descend');
Next(Last(Rank(1:N-sum(Next)))) = true;

end