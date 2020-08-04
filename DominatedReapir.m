function Offspring = DominatedReapir(last_generation_F1,Offspring,D,item_support,item_TWU,N)

% Repair the individuals that are still dominated 
% by the individuals of the previous generation

last_non_dominate_indivs = unique(last_generation_F1,'rows'); 
for n = 1:size(last_non_dominate_indivs,1)
    temp_non_dominate_point = last_non_dominate_indivs(n,:);
	s = temp_non_dominate_point(1,D+1);
	u = temp_non_dominate_point(1,D+2); 
	for p = 1:N
        now_i = Offspring(p,:);
        for m = 1:D                    
            if now_i(1,m) == 1 && item_support(1,m) <= 1.0000 - s && item_TWU(1,m) <= 1.0000 - u                                    
                Offspring(p,m) = 0; 
            end    
        end
	end            
end








end

