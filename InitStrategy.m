function Population = InitStrategy(DATA,N,D)

    part1_size = round(N/2);    
    part2_size = N - part1_size;    
    
    % Part1
    part1 = zeros(part1_size,D);
    if D < part1_size
        for i = 1:D
            part1(i,i) = 1;
        end
        for j = i+1:part1_size
            r = randperm(D,1); 
            part1(j,r) = 1;
        end
    else
        for i1 = 1:part1_size
            part1(i1,i1) = 1;
        end        
    end
    
    % Part2
    TransPattern = DATA(randperm(size(DATA,1),part2_size),:);
    for t1 = 1:part2_size
        now_row = TransPattern(t1,:);
        one_index = find(now_row == 1);
        k = floor(rand * size(one_index,2)); 
        kindex = one_index(randperm(size(one_index,2),k));
        now_row(1,kindex) = 0;
        TransPattern(t1,:) = now_row;
    end
    part2 = TransPattern;
    
Population = [part1; part2];
rowrank = randperm(N); 
Population = Population(rowrank, :);

end

