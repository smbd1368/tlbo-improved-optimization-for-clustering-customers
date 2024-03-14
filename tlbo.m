clc;
clear;
close all;

%% Problem Definition

%read1=load('data.mat')
%x=read1.RFM;
%X=x';
X=load('lrfmp.mat');
X=X.X;
k = 3;
tic
CostFunction=@(m) ClusteringCost(m, X);     % Cost Function

VarSize=[k size(X,2)];  % Decision Variables Matrix Size

nVar=prod(VarSize);     % Number of Decision Variables

VarMin= repmat(min(X),k,1);      % Lower Bound of Variables
VarMax= repmat(max(X),k,1);      % Upper Bound of Variables

%% DE Parameters

MaxIt=400;      % Maximum Number of Iterations

nPop=10;        % Population Size

%% Initialization 

% Empty Structure for Individuals
empty_individual.Position = [];
empty_individual.Cost = [];

% Initialize Population Array
pop = repmat(empty_individual, nPop, 1);

% Initialize Best Solution
BestSol.Cost = inf;

% Initialize Population Members
for i=1:nPop
    pop(i).Position = unifrnd(VarMin, VarMax, VarSize);
    pop(i).Cost = CostFunction(pop(i).Position);
    
    if pop(i).Cost < BestSol.Cost
        BestSol = pop(i);
    end
end

% Initialize Best Cost Record
BestCosts = zeros(MaxIt,1);

%% TLBO Main Loop

for it=1:MaxIt
    
    % Calculate Population Mean
    Mean = 0;
    for i=1:nPop
        Mean = Mean + pop(i).Position;
    end
    Mean = Mean/nPop;
    
    % Select Teacher
    Teacher = pop(1);
    for i=2:nPop
        if pop(i).Cost < Teacher.Cost
            Teacher = pop(i);
        end
    end
    
    % Teacher Phase
    for i=1:nPop
        % Create Empty Solution
        newsol = empty_individual;
        
        % Teaching Factor
        TF = rand();
        
        % Teaching (moving towards teacher)
        newsol.Position = pop(i).Position ...
            + rand(VarSize).*(Teacher.Position - TF*Mean);
        
        % Clipping
        newsol.Position = max(newsol.Position, VarMin);
        newsol.Position = min(newsol.Position, VarMax);
        
        % Evaluation
        newsol.Cost = CostFunction(newsol.Position);
        
        % Comparision
        if newsol.Cost<pop(i).Cost
            
                        pop(i).Cost = newsol.Cost;
            pop(i).Position = newsol.Position;
            %pop(i).Out= newsol.Out;
            if pop(i).Cost < BestSol.Cost
                BestSol = pop(i);
            end
        end
    end
    
    % Learner Phase
    for i=1:nPop
        
        A = 1:nPop;
        A(i)=[];
        j = A(randi(nPop-1));
        
        Step = pop(i).Position - pop(j).Position;
        if pop(j).Cost < pop(i).Cost
            Step = -Step;
        end
        
        % Create Empty Solution
        newsol = empty_individual;
        
        % Teaching (moving towards teacher)
        newsol.Position = pop(i).Position + randn(VarSize).*Step;
        
        % Clipping
        newsol.Position = max(newsol.Position, VarMin);
        newsol.Position = min(newsol.Position, VarMax);
        
        % Evaluation
        newsol.Cost = CostFunction(newsol.Position);
        [newsol.Cost, newsol.Out] = CostFunction(newsol.Position);
        % Comparision
        if newsol.Cost<pop(i).Cost
            pop(i).Cost = newsol.Cost;
            pop(i).Position = newsol.Position;
            pop(i).Out= newsol.Out;
            if pop(i).Cost < BestSol.Cost
                BestSol = pop(i);
                
            end
        end
    end
    
    % Store Record for Current Iteration
    BestCosts(it) = BestSol.Cost;

        % Plot Solution
    
    % Show Iteration Information
    disp(['Iteration ' num2str(it) ': Best Cost = ' num2str(BestCosts(it))]);
% if (toc>=2 & toc<=2.2 )
%     javab=BestCosts(it)
%    end

end

%% Results

figure;
%plot(BestCosts, 'LineWidth', 2);
semilogy(BestCosts, 'LineWidth', 2);
xlabel('Iteration');
ylabel('Best Cost');
grid on;
toc

