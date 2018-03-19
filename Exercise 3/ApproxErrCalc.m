function OutputRow=ApproxErrCalc(dt,tEnd,p_any,AnyArr,cntr)
global t_a p_a 
%Retrieves only relevant values of the exact solution
p_a_req = p_a(1:(dt*32):(size(t_a,2)));

%Calculate Approx Error
AE = sqrt((dt/tEnd)*sum((p_a_req(:)-p_any(:)).^2)); 

%Calc ErrRed
if cntr>1
    PrevErr=AnyArr((cntr-1),2);
    if isnan(PrevErr)==0 && isinf(PrevErr)==0
        ErrRed=PrevErr/AE;
    else
        ErrRed=1;
    end
else
    ErrRed=1;
end

%Add row to respective matrix
OutputRow=[dt AE ErrRed];
end