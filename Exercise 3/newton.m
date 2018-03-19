%Takes parameters as Function to be Solved(G), 1st Derivative of G(i.e. dG)
%and an Initial guess (x0)
function X = newton(G,dG,x0,Acc_Reqd,N_iter) 
x_old=x0;                   %Initial Guess for X
Error=1;                %Initialize error
n=0;                        %Initialize number of Iterations

%Iterate till the error is reduced to required accuracy(err) or reaches
%iteration limit
while Error>Acc_Reqd      
    if (dG(x_old)~=0)&&(n<N_iter)
       x_new = x_old - (G(x_old)/dG(x_old)); %Find the next guess from linear extrapolation 
                                             %Uses slope at current guess       
       Error=abs(x_new-x_old);  %Find the new error 
       x_old = x_new;       
       n=n+1;                       %Increment the step
    else
       x_new=NaN;
       break
    end
end
X=x_new;                            %The solution within required accuracy
end