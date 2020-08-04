function [maxItemSup,maxItemTWU,item_support,item_TWU] = beforeRepair(DATA,Wght,D)

item_support = sum(DATA);
maxItemSup = max(item_support); 
item_support = item_support/maxItemSup;

item_TWU = zeros(1,D);
for j = 1:D
    sum_TWU = 0;
    for i = 1:size(DATA,1)
        if DATA(i,j) == 1
            sum_TWU = sum_TWU + sum(Wght(i,:));
        end
    end
    item_TWU(1,j) = sum_TWU;
end

maxItemTWU = max(item_TWU);
item_TWU = item_TWU/maxItemTWU;

end

