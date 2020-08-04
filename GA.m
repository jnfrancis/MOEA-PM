function Offspring = GA(Parent, can_appear_items)

    proC = 1;
    Parent1 = Parent(1:floor(end/2),:);
    Parent2 = Parent(floor(end/2)+1:floor(end/2)*2,:);
    
    [N,D]   = size(Parent1);
    %% Genetic operators for binary encoding
    % One point crossover
    k = repmat(1:D,N,1) > repmat(randi(D,N,1),1,D);
    k(repmat(rand(N,1)>proC,1,D)) = false; % proC is the probabilities of doing crossover
    Offspring1    = Parent1;
    Offspring2    = Parent2;
    Offspring1(k) = Parent2(k);
    Offspring2(k) = Parent1(k);
    Offspring     = [Offspring1;Offspring2];

    % Each individual always has a location to mutation
    location_of_1 = find(can_appear_items==1);
    for i = 1:2*N
        choosed = location_of_1(randperm(size(location_of_1,2),1));
        Offspring(i, choosed) = ~Offspring(i, choosed);
    end


end