function T_next= ExplicitEulerStep(Nx,Ny,ht,T)
%Solution to part b)
hx=1/(Nx+1);
hy=1/(Ny+1);

% Boundary Conditions
T_next(:,1)=0;T_next(:,Nx+2)=0;
T_next(1,:)=0;T_next(Ny+2,:)=0;

a=ht/hx^2;
b=ht/hy^2;
c=1 -2*ht/hx^2 -2*ht/hy^2;

for j=2:Ny+1
    for i=2:Nx+1
        T_next(i,j) = a*(T(i-1,j)+T(i+1,j))+ b*(T(i,j-1)+T(i,j+1))+ c*T(i,j);
    end
end

end