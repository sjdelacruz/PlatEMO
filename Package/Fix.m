
A= results(1:2,54);
[r,c] = size(A);

result= cell(r/2,2);
row=1;
for i=1: 2 : r
    result{row,1} = cell2mat(A(i));
    result{row,2} = cell2mat(A(i+1));
    row=row+1;
end

% result= zeros(r/2,2);
% row=1;
% for i=1: 2 : r
%     result(row,1) = cell2mat(A{i,1});
%     result(row,2) = cell2mat(A{i+1,1});
%     row=row+1;
% end

GeneralConvergence2([result{1},result{1,2}],'C3-DTLZ4')



% 
% A= cell2mat(results(7:8,9));
% [r,c] = size(A);
% 
% result= zeros(r/2,2);
% row=1;
% for i=1: 2 : r
%     result(row,1) = round(A(i) * 100);
%     result(row,2) = round(A(i+1) * 100);
%     row=row+1;
% end
% 
% GeneralConvergence(result,'C3-DTLZ4')


function GeneralConvergence(listHistories,name)
global path_figures

[rows,columns] = size(listHistories);
f = figure('visible','on');
all_marks = {'+','*','.','x','s','d','^','v','>','<','p','h','o'};

hold all 
delete=[];
for i=1:columns
    local= listHistories(:,2);
    if ~isempty(local)
        
        %plot(local(:,1), local(:,2),'LineStyle','none','Marker',all_marks{i});
        plot(listHistories(:,1), local,'LineWidth',1);
    end
end

title(name);
etiquetas = {'MaOEAIGDDR','MaOEAIGDAR'};
legend(etiquetas,'Interpreter','latex');
xlabel('Generations') 
ylabel('Number of feasible solutions') 
hold off
saveas(f,strcat(path_figures,'/Convergence_', name,'.png'));
end

function GeneralConvergence2(listHistories,name)
global path_figures

[rows,columns] = size(listHistories);
f = figure('visible','on');
all_marks = {'+','*','.','x','s','d','^','v','>','<','p','h','o'};

hold all 
delete=[];
for i=1:columns
    local= listHistories(:,i);
    if ~isempty(local)
        
        %plot(local(:,1), local(:,2),'LineStyle','none','Marker',all_marks{i});
        plot(1:rows, local,'LineWidth',1);
    end
end

title(name);
etiquetas = {'MaOEAIGDDR','MaOEAIGDAR'};
legend(etiquetas,'Interpreter','latex');
xlabel('Generations') 
ylabel('Number of feasible solutions') 
hold off
saveas(f,strcat(path_figures,'/Convergence_', name,'.png'));
end
% function adjustedData = adjust(Result)
% 
% Gen = cell2mat(Result{1,1}{1,1});
% 
% [r,m] = size(Gen);
% 
% for i=1 : r
%     @HV(Result{1,1}{1,2});
% end
% 
% end