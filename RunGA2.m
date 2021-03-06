function out = RunGA2(problem, params)

    % Problem
    CostFunction = problem.CostFunction;
    nVar = problem.nVar;
    VarSize = [1, nVar];
    VarMin = problem.VarMin;
    VarMax = problem.VarMax;
    
    % Params
    MaxIt = params.MaxIt;
    nPop = params.nPop;
    beta = params.beta;
    pC = params.pC;
    nC = round(pC*nPop/2)*2;
    gamma = params.gamma;
    mu = params.mu;
    sigma = params.sigma;
    
    % Template for Empty Individuals
    empty_individual.Position = [];
    empty_individual.Cost = [];
    empty_individual1.Cost1 = [];
    
    % Best Solution Ever Found
    bestsol.Cost = inf;
    listCost=ones(MaxIt,nC); 
    listPosition=ones(MaxIt,nC,2);
    
    
    % Initialization
    pop = repmat(empty_individual, nPop, 1);
    pop1 = repmat(empty_individual1, nPop, 1);
    for i = 1:nPop
        
        % Generate Random Solution
        pop(i).Position = unifrnd(VarMin, VarMax, VarSize);
        
        % Evaluate Solution
        pop(i).Cost = CostFunction(pop(i).Position);
        pop1(i).Cost = CostFunction(pop(i).Position);
        
        % Compare Solution to Best Solution Ever Found
        if pop(i).Cost < bestsol.Cost
            bestsol = pop(i);
        end
        
    end
    
    % Best Cost of Iterations
    bestcost = nan(MaxIt, 1);
    
    % Main Loop
    for it = 1:MaxIt
        
        % Selection Probabilities
        c = [pop.Cost];
        avgc = mean(c);
        if avgc ~= 0
            c = c/avgc;
        end
        probs = exp(-beta*c);
        
        % Initialize Offsprings Population
        popc = repmat(empty_individual, nC/2, 2);
        
        
        % Crossover
        for k = 1:nC/2
            
            % Select Parents
            p1 = pop(RouletteWheelSelection(probs));
            p2 = pop(RouletteWheelSelection(probs));
            
            % Perform Crossover
            [popc(k, 1).Position, popc(k, 2).Position] = ...
                UniformCrossover(p1.Position, p2.Position, gamma);
            
        end
        
        % Convert popc to Single-Column Matrix
        popc = popc(:);
        
        
        % Mutation
        for l = 1:nC
            
            % Perform Mutation
            popc(l).Position = Mutate(popc(l).Position, mu, sigma);
            
            % Check for Variable Bounds
            popc(l).Position = max(popc(l).Position, VarMin);
            popc(l).Position = min(popc(l).Position, VarMax);
            
            % Evaluation
            
            popc(l).Cost=CostFunction(popc(l).Position);
            
            %
            listCost(it,l)=popc(l).Cost;
            listPosition(it,l,:)=[popc(l).Position];
            
            % Compare Solution to Best Solution Ever Found
            if (popc(l).Cost < bestsol.Cost)
                bestsol = popc(l);
            end
            
        end
        
        % Merge and Sort Populations
        pop = SortPopulation([pop; popc]);
        
        % Remove Extra Individuals
        pop = pop(1:nPop);
        
        % Update Best Cost of Iteration
        bestcost(it) = bestsol.Cost;

        % Display Itertion Information
        disp(['Iteration ' num2str(it) ': Best Cost = ' num2str(bestcost(it))]);
        
    end
    
    
    % Results
    out.pop = pop;
    out.listCost=listCost;
    out.listPosition=listPosition;
    
    out.bestsol = bestsol;
    out.bestcost = bestcost;
    
end