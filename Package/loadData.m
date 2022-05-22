%Output: population (next if is necessary extract the UPF or CPF), the
%gistory and the runtime.

%Cell of each population belogging to each run 
%for each cell, containg all intervals of population belogging to each run
%(convergence history)
% fr feasible ratio
% rw random walk
function [lastPopulations, history,fr,wr,SearchProcess] = loadData(generalCad, runs)

lastPopulations = cell(1,runs);
history = cell(1,runs);
fr= cell(1,runs);
wr = cell(1,runs);
SearchProcess = cell(1,runs);

for r=1 : runs
    %Load all data
    str= generalCad + num2str(r) + ".mat";
    popRun= load(str);
    
    %Collecting results
    lastPopulations{1,r} = popRun.result{end,2};
    history{1,r} = popRun.result;
    fr{1,r} = popRun.f;
    wr{1,r} = popRun.r;
    SearchProcess{1,r} = popRun.SearchProcess;
end 
end

