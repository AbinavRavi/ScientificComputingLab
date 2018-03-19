%Function for Method of Heun (Second Order)
function opVec = Heun(fy,y0,dt,tEnd)
%Initialise time vector with steps
t = 0:dt:tEnd;
opVec = zeros(1,size(t,2));
%Set initial value
opVec(1) = y0;
for i=1:size(t,2)-1
opVec(i+1) = opVec(i)+(0.5*dt*(fy(opVec(i))+fy(opVec(i)+(dt*fy(opVec(i))))));
end
end