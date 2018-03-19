%Ensure that a new figure is created at some point before calling this Function
function MultiPlot(dt,p_any)
global LegendString p_a t_a t

if ishold==0 
    plot(t_a,p_a,'k');
    hold on
    LegendString="Exact Solution";
end 
switch dt
    case 1/2
        plot(t,p_any,'r*--');
        LegendString=LegendString+"_dt = 1/2";
    case 1/4
        plot(t,p_any,'mx--');
        LegendString=LegendString+"_dt = 1/4";
    case 1/8
        plot(t,p_any,'bd--');
        LegendString=LegendString+"_dt = 1/8";
    case 1/16
        plot(t,p_any,'cs-');
        LegendString=LegendString+"_dt = 1/16";
    case 1/32
        plot(t,p_any,'g-');  
        LegendString=LegendString+"_dt = 1/32";
end
end