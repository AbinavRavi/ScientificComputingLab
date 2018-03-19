%Function for Euler's Method (First Order)
function y = Implicit_Euler(f,df,y0,dt,tEnd)
global t
t = 0:dt:tEnd;           %Initialise time vector with steps
y = zeros(1,size(t,2));  %Initialise output vector for efficiency
y(1) = y0;               %Set initial value
Acc_Reqd = 1e-4;
N_iter=20;

dG_ImpEul = @(Y) 1-(dt*df(Y)); %Differentiation of G (i.e. dG)
for i=1:size(t,2)-1
    G_ImpEul = @(Y) Y-y(i)-(dt*f(Y));  %G for Newton's Method
    y(i+1) = newton(G_ImpEul,dG_ImpEul,y(i),Acc_Reqd,N_iter); %Further solutions

    %Neglect the current time step if Newton Iteration Failed
    if isnan(y(i+1))
        display("Newton's convergence failed for Implicit Euler Method at Time Step " + strtrim(rats(dt)));
        return
    end
end

