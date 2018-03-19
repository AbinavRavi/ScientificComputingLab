function x = ImplicitEulerStep(Nx,Ny,ht,T_old)
% This function solves the 2D poisson equation with a rectangular boundary
% with fixed value of 0 at all boundaries. It uses the Gauss Seidel iteration technique
% using an intial guess(zer0 in this case). The iteration stops when the
% residual reduces to the required accuracy.
%Solution to part d)

x=T_old; %Initial Guess

% Boundary conditions
x(1,:) = 0; x(Ny+2,:) = 0; 
x(:,1) = 0; x(:,Nx+2) = 0;
% Space step in x and y directions
hx=1/(Nx+1);
hy=1/(Ny+1);
A=ht/hx^2;
B=ht/hy^2;
C=1 + 2*ht/hx^2 + 2*ht/hy^2;
%initialize residual and iteration number
res=1;
while res>1e-6
    
    % Iterate for all elements
    for i=2:Ny+1
        for j=2:Nx+1
            %Find an element using the approximate values of other elements
            %using gauss seidel iteration technique.
            x(i,j)=(T_old(i,j)+A*(x(i-1,j)+x(i+1,j))+B*(x(i,j-1)+x(i,j+1)))/C;
        end
    end

    %Finding residual
    res=0;
    for i=2:Ny+1
        for j=2:Nx+1
            res=res+(-T_old(i,j)-A*(x(i-1,j)+x(i+1,j))-B*(x(i,j-1)+x(i,j+1))+C*x(i,j))^2;
        end
    end
    res=sqrt(res/(Nx*Ny));

end
end