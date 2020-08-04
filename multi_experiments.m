clc;
clear all;

dataset = 'chess'; 
DATA = importdata(['D:\myDataSets\paperUSE\',dataset,'_left_1or0.txt']); 
Wght = importdata(['D:\myDataSets\paperUSE\',dataset,'_right.txt']);  
PW = sum(diag(DATA'*Wght)); 
    
N = 50; % Population size
max_evaluations = 200*N; % maximum number of evaluations   
D = size(DATA,2); 
proC = 1;
proM = 1/D; 

problems = 'mySOU'; 
M = 3;   % number of objectives
times = 20; 

A_HVs = zeros(times,1); 
save_objs = [];

[maxItemSup,maxItemTWU,item_support,item_TWU] = beforeRepair(DATA,Wght,D);

global eval;
for k = 1:times      
    eval = 0;    
    %Population = InitStrategy(DATA,N,D);
	Population = InitStrategy2(DATA,N,D,item_support,item_TWU); 
    for i=1:N
        Population(i,D+1:D+M) = object_fun(Population(i,1:D),DATA,Wght,problems,D,maxItemSup,maxItemTWU);        
    end
    
    [Population,save_obj,save_can_appear_items_num] = NSGAII(maxItemSup,maxItemTWU,item_support,item_TWU,max_evaluations,Population, N, D, M, DATA,Wght,PW,problems);
    
    save(['.\Result\can_appear_items_num\',dataset,'\',num2str(k,'%01d')], 'save_can_appear_items_num');
    save(['.\Result\Objs\',dataset,'\',num2str(k,'%01d')], 'save_obj');
    
    PopObj = Population(:,D+1:D+M);
    NonDominated = NDSort(PopObj,1) == 1;
    fmax_use = 1; 
    [Score,~] = HV(PopObj(NonDominated,:),fmax_use);
    A_HVs(k,1) = Score;  
    save(['.\Result\HVs\',dataset,'\',num2str(k,'%01d')], 'Score');
    
    fprintf('%d \n',k)
end

fprintf('Average HV of %d independent experiments = %f \n', times,mean(A_HVs));