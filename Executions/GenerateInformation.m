function table = GenerateInformation(experiments,algorithms,results,QIs)
global whatAnalyze
nExperiments=length(results);

%For each experiment extract information in rows structures
for i=1: nExperiments
    Current = results{i};
    if ~isempty(Current)
        row.id = i;
        [row.answer,convI] = processExperiment(Current,QIs,experiments(i),algorithms);
        table(i) = row;
    end
    name = strcat('Convergence_', func2str(experiments(i).mop),'_',func2str(QIs{whatAnalyze}));
    GeneralConvergence(convI(1,:),convI(2,:), name);
    
end
end

%Group data by indicator by experiment, and generate figures of pareto
%front and convergence
%Consider to do in two methods
function [data,convergence] = processExperiment(RowsExperiment,QIs,experiment,algorithm)
global path_figures;
global save_figures;
global whatAnalyze;

if ~exist(path_figures,'dir')
    mkdir(path_figures)
end

nRows=length(RowsExperiment);
nIndicators=length(QIs);

%Structure to save the results
data = cell(1,nIndicators);
convergence = cell(1,nRows);
algorithmsName = cell(1,nRows);
indicatorsName= strings(1,nIndicators);
%Assign name of the desired indicators

for ind=1:nIndicators
    data{ind}.name= func2str(QIs{ind});
    indicatorsName(ind) = data{ind}.name;
    data{ind}.stadistics = [];
    
end

%For each row algorithm with indicator values row, separate results in
%groups do
for row = 1 : nRows
    
    stadistics = RowsExperiment(row).stadistics;
    [~,calculateds] = size(stadistics);
    problem = experiment.mop(experiment.m, experiment.d,algorithm.n,experiment.maxEvals);
    
    %Check the results of the row to classify them
    for r=1 : calculateds
        
        %Check the indicador value row to what indicator belong
        indicator = find( stadistics(r).indicator == indicatorsName);
        rowResult.algorithm = RowsExperiment(row).algorithm;
        rowResult.mean = stadistics(r).mean;
        rowResult.min = stadistics(r).min;
        rowResult.max = stadistics(r).max;
        rowResult.std = stadistics(r).std;
        rowResult.factibles=stadistics(r).feasibleRuns;
        rowResult.runtime= stadistics(r).runtime;
        
        %Assign to the structure of the indicator evaluated
        data{indicator}.stadistics{end+1} = rowResult;
        cad=strcat(RowsExperiment(row).name,'_', rowResult.algorithm, '_',  data{indicator}.name);
        
        if save_figures
            GenerateFront(stadistics(r).cpf,cad);
            %if the indicator that i want to analyze is equal to the
            %current
            if whatAnalyze == indicator
                convergence{row} = GenerateConvergence(stadistics(r).history,QIs{indicator},cad,problem);
                algorithmsName{row} = rowResult.algorithm;
            else
                GenerateConvergence(stadistics(r).history,QIs{indicator},cad,problem);
            end
        end
    end
end

for ind=1:nIndicators
    conversion = cell2mat(data{ind}.stadistics);
    data{ind}.stadistics = conversion;
end
convergence = [convergence;algorithmsName];
end

function GenerateFront(Front,name)
global path_figures

[~,dimensions] = size(Front);
f = figure('visible','off');
if dimensions == 2
    scatter(Front(:,1),Front(:,2));
elseif dimensions == 3
   scatter3(Front(:,1),Front(:,2),Front(:,3));
end

title(name,'Interpreter','latex');
saveas(f,strcat(path_figures,'\',name,'.png'));
end

function convergence = GenerateConvergence(history,QI,name,problem)
global path_figures

[n,~] = size(history);
generations = zeros(n,1);
values=zeros(n,1);

for i=1: n
    generations(i,1) = history{i,1};
    values(i,1) = QI(history{i,2},problem.optimum);
end
f = figure('visible','off');
plot(generations,values);
title(name,'Interpreter','latex');
saveas(f,strcat(path_figures,'\','Conv_',name,'.png'));

convergence=[generations,values];
end

function GeneralConvergence(listHistories,etiquetas,name)
global path_figures

s = length(listHistories);
f = figure('visible','off');
all_marks = {'+','*','.','x','s','d','^','v','>','<','p','h','o'};
hold on
for i=1:s
    local= listHistories{i};
    %plot(local(:,1), local(:,2),'LineStyle','none','Marker',all_marks{i});
    plot(local(:,1), local(:,2),'LineWidth',1.5);
end
legend(etiquetas);
xlabel('Generations') 
ylabel('Indicator values') 
hold off
saveas(f,strcat(path_figures,'\General',name,'.png'));
end