function  Offspringi = JudgeAndExecut(Offspringi, can_appear_items, cannot_appear_items_Occu, D)
% Judgment and execution of repair operation

if ~isempty(find((can_appear_items - Offspringi(1,1:D)) < 0))
    occupancy = Offspringi(1,end-1);   
    for m = 1:D
        if occupancy < cannot_appear_items_Occu(1,m)
            Offspringi(1,m) = 0;
        end
    end
    
end



