function A = full_matrix(Nx,Ny)
% This function creates a full matrix for a 2D poisson equation using
% values of Nx and Ny(no. of elements in x and y directions)

%initialize Matrix
A= zeros(Nx*Ny,Nx*Ny);

% Space step in x and y directions
hx=1/(Nx+1);
hy=1/(Ny+1);

for i=1:Nx*Ny
    %Diagnal Elements
    A(i,i)=-2*(1/hx^2+1/hy^2);
    
    % elements on the far left and right of diagonal
    if i<=Nx
        A(i,i+Nx)=1/hy^2;
    elseif i>=(Ny-1)*Nx+1
        A(i,i-Nx)=1/hy^2; 
    else
        A(i,i+Nx)=1/hy^2;
        A(i,i-Nx)=1/hy^2;
    end
    
    %elements adjacent to diagonal
    if mod(i,Nx)==1
        A(i,i+1)=1/hx^2;
    elseif mod(i,Nx)==0
        A(i,i-1)=1/hx^2;
    else
        A(i,i+1)=1/hx^2;
        A(i,i-1)=1/hx^2;
    end
end

end