clear all
format long

%% Initialise output tables
ExpEulArr = zeros(4,4);
HeunArr  = zeros(4,4);
RK4Arr = zeros(4,4);

dt = 1;
tEnd=5;
p0=1; 

%% Loop for each input set. Time Steps of 1, 1/2, 1/4, 1/8 
for i=1:4  
%% Exact(analytical) solution of Differential Equation
t=0:dt:tEnd; %Time Vector
p_a = 10./(1+(9*exp(-t))); %Vector with exact solution points  
figure
plot(t,p_a,'b');
title("Plot of Function p(t) against Time(t). Time Step (dt) = " + num2str(dt));
xlabel("Time(t)");
ylabel("p(t)");
legend("Exact Solution",'Location','southeast');

f = @(p)(1-(p/10))*p; %Function holding given differential equation  

%% Numerical solutions using: 
% Explicit Euler
p_e = ExplicitEuler(f,p0,dt,tEnd);
figure
plot(t,p_a,'b',t,p_e,'r');
title("Explicit Euler + Exact Solution of p(t). Time Step (dt) = " + num2str(dt));
xlabel("Time(t)");
ylabel("p(t)");
legend("Exact Solution","Explicit Euler",'Location','southeast');

% Method of Heun
p_h = Heun(f,p0,dt,tEnd);   
figure
plot(t,p_a,'b',t,p_h,'r');
title("Method of Heun + Exact Solution of p(t). Time Step (dt) = " + num2str(dt));
xlabel("Time(t)");
ylabel("p(t)");
legend("Exact Solution","Method of Heun",'Location','southeast');

% Runge Kutta-4
p_rk4 = RungeKutta4(f,p0,dt,tEnd);
figure
plot(t,p_a,'b',t,p_rk4,'r');
title("Runge Kutta-4 + Exact Solution of p(t). Time Step (dt) = " + num2str(dt));
xlabel("Time(t)");
ylabel("p(t)");
legend("Exact Solution","Runge Kutta-4",'Location','southeast');

%% Approximation Error relative to Exact Solution (Answer c of Worksheet2)

AE_e = sqrt((dt/tEnd)*sum((p_a(:)-p_e(:)).^2)); %Explicit Euler
AE_h = sqrt((dt/tEnd)*sum((p_a(:)-p_h(:)).^2)); %Method of Heun
AE_rk4 = sqrt((dt/tEnd)*sum((p_a(:)-p_rk4(:)).^2)); %Runge Kutta-4

%% Determining the Best Approximation 
dt_best = 1/8; %Best case time step
t_best = 0:dt_best:tEnd; %Corresponding best time vector

% Best Approximations at all points for best case time step (dt_best) 
p1_e = ExplicitEuler(f,p0,dt_best,tEnd);%Explicit Euler
p1_h = Heun(f,p0,dt_best,tEnd); %Method of Heun
p1_rk4 = RungeKutta4(f,p0,dt_best,tEnd); %Runge Kutta-4

% Extract Best Approximations at points relevent to the current time step(dt)
p_e_best = interp1(t_best,p1_e,t); %Explicit Euler
p_h_best = interp1(t_best,p1_h,t); %Method of Heun
p_rk4_best = interp1(t_best,p1_rk4,t); %Runge Kutta-4

%% Error relative to best numerical approximation

AE2_e = sqrt((dt/tEnd)*sum((p_e(:)-p_e_best(:)).^2)); %Explicit Euler
AE2_h = sqrt((dt/tEnd)*sum((p_h(:)-p_h_best(:)).^2)); %Method of Heun
AE2_rk4 = sqrt((dt/tEnd)*sum((p_rk4(:)-p_rk4_best(:)).^2)); %Runge Kutta-4

%% Populate Output Tables as per WorkSheet
if i==1
    ExpEulArr(i,:) = [dt AE_e 0 AE2_e];
    HeunArr (i,:) = [dt AE_h 0 AE2_h];
    RK4Arr (i,:) = [dt AE_rk4 0 AE2_rk4];
else
    %% Error Reduction Percentage Calcs
    EulErrRed = ExpEulArr(i-1,2)-AE_e/ExpEulArr(i-1,2)*100;
    HeunErrRed = HeunArr(i-1,2)-AE_h/HeunArr(i-1,2)*100;
    RK4ErrRed = RK4Arr(i-1,2)-AE_rk4/RK4Arr(i-1,2)*100;
    %%
    ExpEulArr(i,:) = [dt AE_e EulErrRed AE2_e];
    HeunArr (i,:) = [dt AE_h HeunErrRed AE2_h];
    RK4Arr (i,:) = [dt AE_rk4 RK4ErrRed AE2_rk4];
end

dt = dt/2;
end
ExplicitEulerTable = array2table(ExpEulArr,'VariableNames',{'dt','Error_E','ErrorReduction','ErrorApproximated_E2'})
HeunTable = array2table(HeunArr,'VariableNames',{'dt','Error_E','ErrorReduction','ErrorApproximated_E2'})
RungeKutta4Table = array2table(RK4Arr,'VariableNames',{'dt','Error_E','ErrorReduction','ErrorApproximated_E2'})
