%Function for Euler's Method (First Order)
function y = ExplicitEuler(f,y0,dt,tEnd)
%Initialise time vector with steps
global t
t = 0:dt:tEnd;
%Initialise output vector for efficiency
y = zeros(1,size(t,2));
%Set initial value
y(1) = y0;
for i=1:size(t,2)-1
    y(i+1) = y(i)+(dt*f(y(i)));
end
end