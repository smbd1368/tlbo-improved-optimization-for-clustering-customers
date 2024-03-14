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


CostFunction=@(m) ClusteringCost(m, X);     % Cost Function

VarSize=[k size(X,2)];  % Decision Variables Matrix Size

nVar=prod(VarSize);     % Number of Decision Variables

VarMin= repmat(min(X),k,1);      % Lower Bound of Variables
VarMax= repmat(max(X),k,1);      % Upper Bound of Variables

%% DE Parameters

MaxIt=400;      % Maximum Number of Iterations

nPop=100;        % Population Size

%% Initialization 
tic
% Empty Structure for Individuals
empty_individual.Position = [];
empty_individual.Cost = [];
empty_individual.Out=[];
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
        TF = randi([1 2]);
        
        MaxIt = 100;    % Maximum Number of Iterations

nPop0 = 10;     % Initial Population Size
nPop = 10;     % Maximum Population Size

Smin = 0;       % Minimum Number of Seeds
Smax = 10;       % Maximum Number of Seeds

Exponent = 2;           % Variance Reduction Exponent
sigma_initial = 1;      % Initial Value of Standard Deviation
sigma_final = 0.002;	% Final Value of Standard Deviation
    
 sigma = ((MaxIt - it)/(MaxIt -1))^Exponent *(sigma_initial - sigma_final) + sigma_final;
            
        % Teaching (moving towards teacher)
        newsol.Position = pop(i).Position ...
            + randn(VarSize).*(Teacher.Position -sigma)/randn;
        
        % Clipping
        newsol.Position = max(newsol.Position, VarMin);
        newsol.Position = min(newsol.Position, VarMax);
        
        % Evaluation
        [newsol.Cost, particle(i).Out]= CostFunction(newsol.Position);
        
        % Comparision
        if newsol.Cost<pop(i).Cost
            pop(i) = newsol;
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
        
        Step = pop(i).Position - pop(j).Position*randn;
        if pop(j).Cost < pop(i).Cost
            Step = -Step;
        end
        
        % Create Empty Solution
        newsol = empty_individual;
        
        % Teaching (moving towards teacher)
        newsol.Position = pop(i).Position + rand(VarSize).*Step;
        
        % Clipping
        newsol.Position = max(newsol.Position, VarMin);
        newsol.Position = min(newsol.Position, VarMax);
        
        % Evaluation
        [newsol.Cost ] = CostFunction(newsol.Position);
        
        % Comparision
        if newsol.Cost<pop(i).Cost
            pop(i) = newsol;
            if pop(i).Cost < BestSol.Cost
                BestSol = pop(i);
            end
        end
    end
    
    % Store Record for Current Iteration
    BestCosts(it) = BestSol.Cost;
 
[newsol.Cost, newsol.Out]=CostFunction(newsol.Position);
         [datajavab]=newsol.Out;
    
    % Show Iteration Information
    disp(['Iteration ' num2str(it) ': Best Cost = ' num2str(BestCosts(it))]);
%    if (toc>=2 & toc<=2.2 )
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

%datajavab.ind


%in fintess cmeans
%datajavab.d=datajavab.d';
%in fintess kmeans
datajavab=datajavab;

[index1,minindex1]=min(datajavab.d(:,1));
[index2,minindex2]=min(datajavab.d(:,2));
[index3,minindex3]=min(datajavab.d(:,3));

center=[minindex1,minindex2,minindex3]
[minindex1,minindex2,minindex3]

%NUMBER OF CLUSTER
NUMBER0FCLUSTER=[size(find(datajavab.ind==1)),size(find(datajavab.ind==2)),size(find(datajavab.ind==3))]


%mean corrleation LRFMP
ccrr=mean(corr(X))

CLV1=mean(ccrr.*X(minindex1,:))
CLV2=mean(ccrr.*X(minindex2,:))
CLV3=mean(ccrr.*X(minindex3,:))



mean(X)
min(X)
max(X)