%Function for Euler's Method (First Order)
function opVec = ExplicitEuler(fy,y0,dt,tEnd)
%Initialise time vector with steps
t = 0:dt:tEnd;
%Initialise output vector for efficiency
opVec = zeros(1,size(t,2));
%Set initial value
opVec(1) = y0;
for i=1:size(t,2)-1
    opVec(i+1) = opVec(i)+(dt*fy(opVec(i)));
end
end