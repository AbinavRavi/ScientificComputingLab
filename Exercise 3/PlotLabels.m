%Labels Plot and its Axes. 
%Sets Upper and Lower Limits of Axes
%Creates the Legend depending on Available Solutions
function PlotLabels(Title,LegendString_Passed,xAxis_UL,yAxis_LL,yAxis_UL)
title(Title);
xlabel("Time(t)"); ylabel("p(t)"); 
xlim([0,xAxis_UL]); ylim([yAxis_LL,yAxis_UL]);
LegendArray=regexp(LegendString_Passed,'_','split');
legend(LegendArray{:},'Location','southeast');
end
