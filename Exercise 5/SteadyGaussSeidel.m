function x = SteadyGaussSeidel(b,Nx,Ny)
% This function solves the 2D poisson equation with a rectangular boundary
% with fixed value of 0 at all boundaries. It uses the Gauss Seidel iteration technique
% using an intial guess(zer0 in this case). The iteration stops when the
% residual reduces to the required accuracy.

x=ones(Ny+2,Nx+2); %Initial condition
% Boundary conditions
x(1,:) = 0; x(Ny+2,:) = 0; 
x(:,1) = 0; x(:,Nx+2) = 0; 

% Space step in x and y directions
hx=1/(Nx+1);
hy=1/(Ny+1);
%initialize residual and iteration number
res=1;
while res>1e-15
    
    % Iterate for all elements
    for i=2:Ny+1
        for j=2:Nx+1
            %Find an element using the approximate values of other elements
            %using gauss seidel iteration technique.
            x(i,j)=(b(i,j)-x(i,j-1)/hy^2 -x(i-1,j)/hx^2 -x(i+1,j)/hx^2 -x(i,j+1)/hy^2)/(-2*(1/hx^2+1/hy^2));
        end
    end
    
    %Finding residual
    res=0;
    for i=2:Ny+1
        for j=2:Nx+1
            res=res+(b(i,j)-x(i,j-1)/hy^2 -x(i-1,j)/hx^2 +x(i,j)*2*(1/hx^2+1/hy^2) -x(i+1,j)/hx^2 -x(i,j+1)/hy^2)^2;
        end
    end
    res=sqrt(res/(Nx*Ny));
end

end