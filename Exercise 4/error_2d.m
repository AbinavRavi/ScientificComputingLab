function E = error_2d(x_approx, x_exact)
% This function finds the 2 norm error for a 2D matrix approxiamte values
%as compared to the exact values

E=0; %initialize error
for i=1:size(x_approx,1)
    for j=1:size(x_approx,2)
       E = E + (x_approx(i,j) - x_exact(i,j))^2;
    end
end
E=sqrt(E/(size(x_approx,1)*size(x_approx,2)));
end