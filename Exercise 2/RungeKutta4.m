%Function for Runge Kutta-4 (Fourth Order)
function opVec = RungeKutta4(fy,y0,dt,tEnd)
%Initialise time vector with steps
t = 0:dt:tEnd;
opVec = zeros(1,size(t,2));
%Set initial value
opVec(1) = y0;
for i=1:size(t,2)-1
Y1 = fy(opVec(i));
Y2 = fy(opVec(i)+0.5*dt*Y1);
Y3 = fy(opVec(i)+0.5*dt*Y2);
Y4 = fy(opVec(i)+dt*Y3);
opVec(i+1) = opVec(i)+((dt/6)*(Y1+(2*Y2)+(2*Y3)+Y4));
end
end