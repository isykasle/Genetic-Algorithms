clc;
clear;
close all;

%% Problem Definition

%change mFunction2D with an objective function that you wish
%to apply the genetic algorithm
problem.CostFunction = @(x)-mFunction2D(x);
problem.nVar = 2;

%define the intervals of the parameters that are the ones 
%with respect to which we perform the genetic algorithm
wmin=0.23;
wmax=0.285;
Lmin=0.635;
Lmax=0.70;


%lower bounds
problem.VarMin = [wmin Lmin];
%upper bounds
problem.VarMax = [wmax Lmax];

%% GA Parameters

%number of generations
params.MaxIt = 50;
%number of population
params.nPop = 100;
%a parameter to adjust the influence of selection operator
params.beta = 1;
%the percentage of crossover operator
params.pC = 0.7;
%a parameter to adjust the influence of crossover operator
params.gamma = 0.1;
%the percentage of mutation operator
params.mu = 0.5;
%a parameter to adjust the influence of mutation operator
params.sigma = 0.1;


%% Run GA

out = RunGA2(problem, params);


%% Results
out.bestcost=abs(out.bestcost);
out.listCost=abs(out.listCost);

%contour visualization of results

w2 = out.listPosition(:,:,1);
L2=out.listPosition(:,:,2);
figure; 
contour(1000*L2,1000*w2,out.listCost,100)
set(gca, 'fontsize', 16, 'fontname', 'times');
xlabel('\Lambda (nm)');
ylabel('w(nm)');
colorbar
title('m');
grid;




