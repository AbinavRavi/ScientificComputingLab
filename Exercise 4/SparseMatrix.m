function S = SparseMatrix(Nx,Ny)
% This function creates the sparse matrix for a 2D poisson equation using
% values of Nx and Ny(no. of elements in x and y directions)

%Create the sparse tridiagonal matrix of size Nx by Nx
triDiag = spdiags([-2*((Nx+1)^2 +(Ny+1)^2)*ones(Nx,1),(Nx+1)^2*ones(Nx,1),(Nx+1)^2*ones(Nx,1)],[0,-1,1],Nx,Nx);

% Tensor product of sparse identity matrix of size Ny by Ny with sparse tridiagonal
% matrix. This gives another sparse tridiaginal matrix of size Nx*Ny by Nx*Ny
S1 = kron(speye(Ny), triDiag);

% Create the sparse diagonal matrix with 2 far off diagonals on either side
% of span line offset by Nx. This gives a sparse matrix of size Nx*Ny by
% Nx*Ny.
diag2 = spdiags([ones(Nx*Ny,1)*(1+Ny)^2,ones(Nx*Ny,1)*(1+Ny)^2],[-Nx Nx],Nx*Ny,Nx*Ny);

% Add the two sparse matrices to obtain the pentadiagonal sparse matrix
S  = S1+diag2;

end