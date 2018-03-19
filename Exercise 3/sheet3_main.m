clear all
format long
%% Given input conditions
dt = 1/2;
tEnd=5;
p0=20; 
counter=1;

%% Initialise output tables
ExpEulArr = zeros(5,3);
HeunArr  = zeros(5,3);
ImpEulArr = zeros(5,3);
AdaMoulMetArr = zeros(5,3);
Lin1AdaMoulMetArr = zeros(5,3);
Lin2AdaMoulMetArr = zeros(5,3);
StabilityArr = strings(5,7);

%% Exact(analytical) solution of Ordinary Differential Equation
global LegendString p_a t_a
t_a = 0:(1/32):5; %Time Vector
p_a = 200./(20-(10*exp(-(7*t_a)))); %Vector with exact solution points  
figure
plot(t_a,p_a,'k');
PlotLabels("Plot of Exact Solution p(t) against Time(t)","Exact Solution",tEnd,0,20);

%% Create function handles for ODE and its First Derivative
syms p;
f = @(p)7*(1-(p/10))*p; %Function handle for given differential equation   
df = matlabFunction(diff(f,p)); %Derivative of ODE

%% Numerical solutions using explicit schemes:
% Start Explicit Euler
figure
while dt>=(1/32)    
    p_e = ExplicitEuler(f,p0,dt,tEnd);
    MultiPlot(dt,p_e)
    if any(isnan(p_e))||any(isinf(p_e))
        ExpEulArr(counter,:) = [dt 0 0];
        arrStability="Unstable";
    else
        ExpEulArr(counter,:) = ApproxErrCalc(dt,tEnd,p_e,ExpEulArr(),counter);
        arrStability="Stable";
    end
    
    StabilityArr(counter,1) = rats(dt); %One Time assignment of dt values to Stabiity Table
    StabilityArr(counter,2) = arrStability;
    counter=counter+1;    
    dt = dt/2;
end
PlotLabels("Explicit Euler",LegendString,tEnd,0,20);
dt=1/2;
counter=1;
% End Explicit Euler

% Start Method of Heun
figure
while dt>=(1/32)
    p_h = Heun(f,p0,dt,tEnd);
    MultiPlot(dt,p_h)
    if any(isnan(p_h))||any(isinf(p_h))
     HeunArr(counter,:) = [dt 0 0];
     arrStability="Unstable";
    else
     HeunArr(counter,:) = ApproxErrCalc(dt,tEnd,p_h,HeunArr(),counter);
     arrStability="Stable";
    end
      
    StabilityArr(counter,3) = arrStability;
    counter=counter+1;    
    dt = dt/2;
end
PlotLabels("Method of Heun",LegendString,tEnd,0,20);
dt=1/2;
counter=1;
% End Method of Heun

%% Numerical solutions using implicit schemes:
% Start Implicit Euler
figure
while dt>=(1/32)    
    p_eI = Implicit_Euler(f,df,p0,dt,tEnd);
    MultiPlot(dt,p_eI)
    if any(isnan(p_eI))||any(isinf(p_eI))
        ImpEulArr(counter,:) = [dt 0 0];
        arrStability="Unstable";
    else
        ImpEulArr(counter,:) = ApproxErrCalc(dt,tEnd,p_eI,ImpEulArr(),counter);
        arrStability="Stable";
    end
       
    StabilityArr(counter,4) = arrStability;
    counter=counter+1;  
    dt = dt/2;
end
PlotLabels("Implicit Euler",LegendString,tEnd,0,20);
dt=1/2;
counter=1;
% End Implicit Euler

% Start Adams Moulton Method
figure
while dt>=(1/32)    
    p_AM = AdamsMoulton(f,df,p0,dt,tEnd);
    MultiPlot(dt,p_AM)
    if any(isnan(p_AM))||any(isinf(p_AM))
        AdaMoulMetArr(counter,:) = [dt 0 0];
        arrStability="Unstable";
    else
        AdaMoulMetArr(counter,:) = ApproxErrCalc(dt,tEnd,p_AM,AdaMoulMetArr(),counter);
        arrStability="Stable";
    end
       
    StabilityArr(counter,5) = arrStability;
    counter=counter+1;    
    dt = dt/2;
end
PlotLabels("Adams Moulton Method (2nd Order)",LegendString,tEnd,0,20);
dt=1/2;
counter=1;
% End Adams Moulton Method

% Start Linearisation-1: Adams Moulton Method
figure
while dt>=(1/32)    
    p_L1am = AM_linear1(p0,dt,tEnd);
    MultiPlot(dt,p_L1am)
    if any(isnan(p_L1am))||any(isinf(p_L1am))
        arrStability="Unstable";
        Lin1AdaMoulMetArr(counter,:) = [dt 0 0];
    else
        arrStability="Stable";
        Lin1AdaMoulMetArr(counter,:) = ApproxErrCalc(dt,tEnd,p_L1am,Lin1AdaMoulMetArr(),counter);
    end
     
    StabilityArr(counter,6) = arrStability;
    counter=counter+1;  
    dt = dt/2;
end
PlotLabels("Linearisation-1: Adams Moulton Method",LegendString,tEnd,0,20);
dt=1/2;
counter=1;
% End Linearisation-1: Adams Moulton Method

% Start Linearisation-2: Adams Moulton Method
figure
while dt>=(1/32)    
    p_L2am = AM_linear2(p0,dt,tEnd);
    MultiPlot(dt,p_L2am)
    if any(isnan(p_L2am))||any(isinf(p_L2am))
        arrStability="Unstable";
        Lin2AdaMoulMetArr(counter,:) = [dt 0 0];
    else
        arrStability="Stable";
        Lin2AdaMoulMetArr(counter,:) = ApproxErrCalc(dt,tEnd,p_L2am,Lin2AdaMoulMetArr(),counter);
    end
      
    StabilityArr(counter,7) = arrStability;
    counter=counter+1; 
    dt = dt/2;
end
PlotLabels("Linearisation-2: Adams Moulton Method",LegendString,tEnd,0,20);
dt=1/2;
counter=1;
% End Linearisation-2: Adams Moulton Method

%% Print Output Tables
ExplicitEulerTable = array2table(ExpEulArr,'VariableNames',{'dt','Error_AE','ErrorRed_Factor'})
HeunTable = array2table(HeunArr,'VariableNames',{'dt','Error_AE','ErrorRed_Factor'})
ImplicitEulerTable = array2table(ImpEulArr,'VariableNames',{'dt','Error_AE','ErrorRed_Factor'})
AdamsMoultonTable = array2table(AdaMoulMetArr,'VariableNames',{'dt','Error_AE','ErrorRed_Factor'})
Linearisation1AdamsMoultonTable = array2table(Lin1AdaMoulMetArr,'VariableNames',{'dt','Error_AE','ErrorRed_Factor'})
Linearisation2AdamsMoultonTable = array2table(Lin2AdaMoulMetArr,'VariableNames',{'dt','Error_AE','ErrorRed_Factor'})
StabilityArr = array2table(StabilityArr,'VariableNames',{'dt','ExplicitEuler','Heun','ImplicitEuler','AdamsMoulton','AdamsMoultonL1','AdamsMoultonL2'})
