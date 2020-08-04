function f = object_fun(newpoint,DATA,Wght,problems,D,maxItemSup,maxItemTWU)

global eval;
eval = eval + 1;

if size(newpoint,2) > D
    fprintf('error£¡\n');
    return;
end

if strcmp(problems,'mySOU')
    %--------f1 support----------
        if sum(newpoint)==0
          support=0;
        else
          newpoint = logical(newpoint);
          Tnewpoint = all(DATA(:,newpoint),2);
          support = sum(Tnewpoint);
        end
	
    if support>0 
        %-------f2 occupancy---------
        occupancy = mean(sum(newpoint)./sum(DATA(Tnewpoint,:),2));        
        if occupancy>0
            %--------f3 utility--------
            a=size(DATA,2);
            m=0;
            record=find(newpoint(1,1:a)==1);
            B1=DATA(:,record);
            C1=Wght(:,record);
            A1=sum(B1(:,1:length(record)),2); 
            n=find(A1==length(record)); 
            B2=B1(n,:);
            C2=C1(n,:);
            m=sum(diag(B2'*C2));

            utility = m/maxItemTWU;
        else % Occupancy = 0 means this pattern is Nonsense
            utility=0;
        end
    else % Support = 0 means this pattern is Nonsense
        occupancy=0;
        utility=0;
    end
    
    f1=support/maxItemSup;
    f2=occupancy; 
    f3=utility;
    
    f=[1.0000-f1,1.0000-f2,1.0000-f3];
end

end