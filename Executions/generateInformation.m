function Table = generateInformation(Results,QIs,Experiments)

nExperiments=length(Results);
datos=[];

%For each experiment extract rows of the general table
for i=1: nExperiments
    Current = Results{i};
    if ~isempty(Current)
        answer = generateTable(Current,QIs,Experiments(i));
        Exp.id = i;
        Exp.answer = answer;
        Table(i) = Exp;
    end
end
end

function listaTablas = generateTable(Experiment,QIs,Configuration)
global path_figures

nAlgorithms=length(Experiment);
nInd=length(QIs);

%Para cada indicador juntar todos los respecto a este
for str = 1: nInd
    Tabla.nombre= func2str(QIs{str});
    
    %Para cada algoritmo
    for i=1:nAlgorithms
        stadistics = Experiment(i).stadistics;
        [ren,l] = size(stadistics);
        
        for r=1 : l
            if strcmp(convertCharsToStrings(stadistics(r).Indicator), convertCharsToStrings(Tabla.nombre))
                Renglon.algoritmo = Experiment(i).algorithm;
                Renglon.promedio = stadistics(r).Promedio;
                Renglon.min = stadistics(r).Min;
                Renglon.max = stadistics(r).Max;
                Renglon.std = stadistics(r).std;
                Renglon.factibles=stadistics(r).FeasibleRuns;
                Renglon.runtime= stadistics(r).RunTime;
                Renglones(i) = Renglon;
                
                cad=strcat(Renglon.algoritmo, '_', Experiment(i).nExp,'_', Tabla.nombre);
                generateFront(stadistics(r).PopObj,cad,cad);
                generateConvergence(stadistics(r).History,QIs{str},cad,cad,Configuration);
                break;
            end
        end         
    end
    Tabla.renglones= Renglones;
    listaTablas(str) = Tabla;
    clearvars Tabla
end
end

function generateFront(Population,Tit,name)
global path_figures

Front = Population.best.objs;
[~,dimensions] = size(Front);

if dimensions == 2
    scatter(Front(:,1),Front(:,2));
elseif dimensions == 3
   scatter3(Front(:,1),Front(:,2),Front(:,3));
end

title(Tit,'Interpreter','latex');
saveas(gcf,strcat(path_figures,'\',name,'.png'));
end

function  generateConvergence(History,QI,Tit,name,Configuration)
global path_figures

[n,~] = size(History);
Generations = zeros(1,n);
Values=zeros(1,n);
Problem = Configuration.MOP(Configuration.M, Configuration.D);
for i=1: n
    Generations(i) = History{i,1};
    Values(i) = QI(History{i,2},Problem.optimum);
end

Values(isnan(Values)) =0;
plot(Generations,Values);
title(Tit,'Interpreter','latex');
saveas(gcf,strcat(path_figures,'\','Conv_',name,'.png'));
end