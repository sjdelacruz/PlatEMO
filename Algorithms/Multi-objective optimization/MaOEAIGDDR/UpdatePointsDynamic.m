function W = UpdatePointsDynamic(currentW,Population,c,beta,alfa,counterGen)

%Compute the fitness of the solutions based on the normalization of
%objectives and constraints functions
fit  = FitnessDynamic(Population.objs, Population.cons, c, beta, alfa, counterGen);

%Join of reference points and the points based on the current population
R = [currentW;fit];

%Compute size of references points and the set joined
[nRPoints,~] = size(R);
[nCurrentW,~] = size(currentW);

[FrontNo,MaxFNo] = NDSort(R,nRPoints);

counter=0;
Last = 0;
W=[];
for i=1 : MaxFNo
    
    aux = FrontNo == i;
    front = R(aux,:);
    [wRwos,~] = size(front);
    
    pivot = counter+wRwos;
    
    if pivot < nCurrentW
        W = [W;front];
        counter = pivot;
    else
        Last=i;
        break;
    end
end

LastFront = FrontNo == Last;
LastFronti = R(LastFront,:);
[~,Rank] =  sort(CrowdingDistance(LastFronti),'descend');
Selected = Rank(1:nCurrentW-counter);
W = [W; R(Selected,:)];
end