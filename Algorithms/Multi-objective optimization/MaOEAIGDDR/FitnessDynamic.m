function fit = FitnessDynamic(PopObj,PopCon,c,beta,alfa,t)

fit   = zeros(size(PopObj));
[~,nColumn] = size(PopCon);

for j=1 : nColumn
    Column = PopCon(:,j);
    Column(Column <= 0) = 0;
    
    high=find(Column> 0);
    Column(high) = abs(Column(high));
    
    %Constraints normalization
    PopCon(:,j)= Column.^beta;
    maxCons = max(PopCon(:,j));
    PopCon(:,j)= max(0,PopCon(:,j)) ./ max(1,maxCons);
end

penalty = ((c * t)^alfa) * sum(PopCon,2);

for i = 1 : size(PopObj,2)
    fst =  abs(PopObj(:,i));
    snd = sum(PopObj(:,[1:i-1,i+1:end]).^2,2);
    fit(:,i) = fst + (100*snd);
    
    %Objective functions normalization
    znad = max(fit(:,i));
    zideal = min(fit(:,i));
    fit(:,i) = (fit(:,i) - zideal) ./ (znad - zideal);
    
    %Objectives + penalties
    fit(:,i) = fit(:,i) + penalty; 
end
end