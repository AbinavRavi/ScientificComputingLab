%Function for Method of Heun (Second Order)
function y = Heun(fy,y0,dt,tEnd)
%Initialise time vector with steps
global t
t = 0:dt:tEnd;
y = zeros(1,size(t,2));
%Set initial value
y(1) = y0;
for i=1:size(t,2)-1
    y(i+1) = y(i)+(0.5*dt*(fy(y(i))+fy(y(i)+(dt*fy(y(i))))));
end
end