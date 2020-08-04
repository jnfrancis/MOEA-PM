function [Population,FrontNo,CrowdDis] = EnvironmentalSelection(Population,N,M)
% The environmental selection of NSGA-II

    Population_objs = Population(:,end-M+1:end);
   
    %% Delete duplicate individuals in the combined population
    [Population_objs,uni] = unique(Population_objs,'rows');
    Population = Population(uni,:);
    N = min(N,size(Population,1));     
    
    %% Non-dominated sorting
    [FrontNo,MaxFNo] = NDSort(Population_objs,N);
    Next = FrontNo < MaxFNo;
    
    %% Calculate the crowding distance of each solution
    CrowdDis = CrowdingDistance(Population_objs,FrontNo); 
    
    %% Select the solutions in the last front based on their crowding distances
    Last     = find(FrontNo==MaxFNo);
    [~,Rank] = sort(CrowdDis(Last),'descend');
    Next(Last(Rank(1:N-sum(Next)))) = true;
    
    %% Population for next generation
    Population = Population(Next,:);
    
    FrontNo    = FrontNo(Next);
    CrowdDis   = CrowdDis(Next);
end