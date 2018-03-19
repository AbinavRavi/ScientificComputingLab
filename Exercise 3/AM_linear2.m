function y = AM_linear2(y0,dt,tEnd)
global t

t = 0:dt:tEnd;        %Initialise time vector with steps
y = zeros(1,size(t,2)); %initialise output vector
y(1) = y0;
Acc_Reqd = 1e-4;
N_iter = 20;
%Define Linearisation 2 Function
h = 1e-8;
for i = 1:size(t,2)-1
    lastY=y(i);
    G_L2_AM =@(Y) Y-lastY-((dt/2)*((7*(1-(lastY/10))*lastY)+(7*(1-(lastY/10))*Y)));
    dG_L2_AM = @(Y)(G_L2_AM(Y+h)-G_L2_AM(Y-h))/(2*h);
    y(i+1) = newton(G_L2_AM,dG_L2_AM,y(i),Acc_Reqd,N_iter); %Further solutions
   
%Neglect the current time step if Newton Iteration Failed
    if isnan(y(i+1))
        display("Newton's convergence failed for Adams Moulton Linearization-2 Method at Time Step " + strtrim(rats(dt)));
        return
    end
end


        
