function [Population,save_obj,save_can_appear_items_num] = NSGAII(maxItemSup,maxItemTWU,item_support,item_TWU,max_evaluations,Population, N, D, M, DATA,Wght,PW,problems)
% N: population size
% D: dimension
% M: number of obj
%--------------------------------------------------------------------------    
    [~,FrontNo,CrowdDis] = EnvironmentalSelection(Population,N,M);     
    save_obj = [];
    save_can_appear_items_num = zeros(max_evaluations,2);

    can_appear_items = ones(1,D);
    cannot_appear_items_Occu = zeros(1,D);
    
    %% Optimization
    global eval;    
    while eval <= max_evaluations        
        save_can_appear_items_num(eval,:) = [eval, sum(can_appear_items)];
        MatingPool = TournamentSelection(2,N,FrontNo,-CrowdDis);
        
        p = Population(MatingPool,:);
        tempPOP = [];
        GAPOP = [];
        for i = 1:N
            pi_temp = p(i,1:D);
            p(i,:) = JudgeAndExecut(p(i,:), can_appear_items, cannot_appear_items_Occu, D);
            if sum(pi_temp) - sum(p(i,1:D)) > 0 
                tempPOP = [tempPOP; p(i,:)];
            else
                GAPOP = [GAPOP; p(i,:)];
            end
        end
        
        if mod(size(GAPOP,1),2) ~= 0 
            GAPOP = [GAPOP; tempPOP(1,:)];
        end
        
        Offspring = GA(GAPOP, can_appear_items);
        if size([Offspring; tempPOP],1) > N
            Offspring = [Offspring; tempPOP(1:end-1,:)];
        else
            Offspring = [Offspring; tempPOP];
        end
                      
        for i = 1:N
            Offspring(i,D+1:D+M) = object_fun(Offspring(i,1:D),DATA,Wght,problems,D,maxItemSup,maxItemTWU);   
        end             
        [Population,FrontNo,CrowdDis] = EnvironmentalSelection([Population;Offspring],N,M); 
        [~, last_generation_F1_index] = find(FrontNo == 1);   
        now_F1_indivs = Population(last_generation_F1_index,:);
        
        %------------------------------------------------------------------         
            now_non_dominate_indivs = unique(now_F1_indivs,'rows'); 
            for n = 1:size(now_non_dominate_indivs,1)
                temp_non_dominate_point = now_non_dominate_indivs(n,:);
                s = 1.0000 - temp_non_dominate_point(1,D+1); 
                u = 1.0000 - temp_non_dominate_point(1,end); 
                for m = 1:D
                    if item_support(1,m) < s && item_TWU(1,m) < u
                        can_appear_items(1,m) = 0; 
                        o = 1.0000 - temp_non_dominate_point(1,D+2);                
                        cannot_appear_items_Occu (1,m) = max(o,cannot_appear_items_Occu (1,m));
                    end
                end
            end
        %------------------------------------------------------------------ 
        temp1 = zeros(size(now_F1_indivs,1),1) + eval;
        temp2 = [now_F1_indivs(:,(D+1):(D+M)),temp1];      
        save_obj = [save_obj;temp2];          
    end
end