format shortE

%% Initialize Output Variables for Tables
N_x=[7;15;31;63];
runtime_full=zeros(4,1);
storage_full=zeros(4,1);
runtime_sparse=zeros(4,1);
storage_sparse=zeros(4,1);
runtime_gs=zeros(4,1);
storage_gs=zeros(4,1);
err=zeros(5,1);
err_red=zeros(5,1);

%% Initialize Domain discretization
Nx=7; Ny=7;
n=1; % Simulation number

while Nx<=127
% create arrays in x and y dimensions based on descretization
x=0:1/(Nx+1):1;
y=0:1/(Ny+1):1;

% Right hand side source function in the PDE
f_source = @(x,y) -2*(pi^2)*sin(pi*x)*sin(pi*y);

%% Estimation of b(in the linear system Ax = b)
b=zeros(Ny+2,Nx+2);
for i=1:Ny+2
    for j=1:Nx+2
        b(i,j) =f_source(x(j),y(i));
    end
end
%Stretch b matrix into a vector bv
bv=zeros(Nx*Ny,1);
for i=1:Ny
    for j=1:Nx
            bv((i-1)*Nx+j)= b(i+1,j+1);
    end
end

%% Analytical Solution
T_an=zeros(Ny+2,Nx+2);
for i=1:Ny+2
    for j=1:Nx+2
        T_an(i,j) = sin(pi*x(j))*sin(pi*y(i));
    end
end

%% Gauss Seidel Method
if Nx<=63
    tic
end
% Solving Ax = b using Gauss Seidel function(iterate till residual<1e-4)
T_gs=Gauss_seidel(b,Nx,Ny);

if Nx<=63
    % find storage requirement
    storage_gs(n)= num_entries(T_gs)+num_entries(b);
    % Find runtime required to solve the system using gauss seidel
    runtime_gs(n)= toc; 
end
% Calculates the 2 norm error as compared to the analytical solution using error_2d function 
err(n) = error_2d(T_gs, T_an);
if n==1
    err_red(n)=1;
else
    err_red(n)=err(n-1)/err(n); % Calculating error reduction factor
end

if Nx<=63
%% Using Matrix division on full matrix
 tic
 % Create/Store the matrix A in linear system Ax=b in it's full form.
 A_full=full_matrix(Nx,Ny);
 % Solve the linear system A_full*Tv_full = bv to get Tv_full
 Tv_full=A_full\bv;

 T_full=zeros(Ny+2,Nx+2); 
for i=2:Ny+1
    for j=2:Nx+1
        %Convert vector Tv_full into 2D matrix T_full
        T_full(i,j)=Tv_full((i-2)*Nx+j-1);
    end
end
% Find runtime required to solve the system using full matrix form
runtime_full(n)= toc;
% find storage requirement
storage_full(n)= num_entries(Tv_full)+num_entries(T_full)+num_entries(A_full)+num_entries(bv);

%% Using matrix division on sparse matrix
 tic
 % Create/Store the matrix A in linear system Ax=b in it's full form.
 A_sparse = SparseMatrix(Nx,Ny);
 % Solve the linear system A_sparse*Tv_sparse = bv to get Tv_sparse
 Tv_sparse = A_sparse\bv;
 T_sparse=zeros(Ny+2,Nx+2);
for i=2:Ny+1
    for j=2:Nx+1
        %Convert vector Tv_sparse into 2D matrix T_sparse
        T_sparse(i,j)=Tv_sparse((i-2)*Nx+j-1);
    end
end
% Find runtime required to solve the system using sparse matrix form
runtime_sparse(n)= toc;
% find storage requirement
storage_sparse(n)= num_entries(Tv_sparse)+num_entries(T_sparse)+num_entries(A_sparse)+num_entries(bv);

%% Plot Temperature as a surface(in 3D)
figure_name = "Temperature Surface (Nx = "+num2str(Nx)+")";
figure('Name',figure_name,'Units','Normalized','OuterPosition',[0 0 1 1]),
subplot(2,2,1),surf(x,y,T_an),colorbar,title(['Analytical Soln, Nx=',num2str(Nx)]),xlabel('x'),ylabel('y'), zlabel('Temperature'),zlim([0 1.2])
subplot(2,2,2),surf(x,y,T_gs),colorbar,title(['Gauss Seidel, Nx=',num2str(Nx)]),xlabel('x'),ylabel('y'), zlabel('Temperature'),zlim([0 1.2])
subplot(2,2,3),surf(x,y,T_full),colorbar,title(['Full Matrix, Nx=',num2str(Nx)]),xlabel('x'),ylabel('y'), zlabel('Temperature'),zlim([0 1.2])
subplot(2,2,4),surf(x,y,T_sparse),colorbar,title(['Sparse Matrix, Nx=',num2str(Nx)]),xlabel('x'),ylabel('y'), zlabel('Temperature'),zlim([0 1.2])

% Plot Temperature as a contour(in 2D)
figure_name = "Temperature Contour (Nx = "+num2str(Nx)+")";
figure('Name',figure_name,'Units','Normalized','OuterPosition',[0 0 1 1])
subplot(2,2,1),contour(x,y,T_an),colorbar,title(['Analytical Soln, Nx=',num2str(Nx)]),xlabel('x'),ylabel('y'),zlim([0 1.2])
subplot(2,2,2),contour(x,y,T_gs),colorbar,title(['Gauss Seidel, Nx=',num2str(Nx)]),xlabel('x'),ylabel('y'),zlim([0 1.2])
subplot(2,2,3),contour(x,y,T_full),colorbar,title(['Full Matrix, Nx=',num2str(Nx)]),xlabel('x'),ylabel('y'),zlim([0 1.2])
subplot(2,2,4),contour(x,y,T_sparse),colorbar,title(['Sparse Matrix, Nx=',num2str(Nx)]),xlabel('x'),ylabel('y'),zlim([0 1.2])

end
n=n+1; %Increment the simulation number
Nx=2*Nx+1;Ny=2*Ny+1; %Move to the next level of descretization
end

%Output Tables comparing runtime and storage for different levels of
%descretization for full matrix, sparse matrix and gauss seidel method
Table_FullMatrix = table(N_x,runtime_full,storage_full)
Table_SparseMatrix = table(N_x,runtime_sparse,storage_sparse)
Table_GaussSeidel = table(N_x,runtime_gs,storage_gs)

% Output table showing error and error reduction factor for gauss seidel 
%method for different levels of descretization 
N_x=[7;15;31;63;127];
Table_Error_GaussSeidel = table(N_x,err, err_red)
