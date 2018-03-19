clc
% clear all
format long

%% Steady State Temperature
stabilityCheck=strings(5,8);
stabilityCheck(:,:)="Stable";
stabilityCheck(:,1)=["Nx=Ny" 3 7 15 31];
stabilityCheck(1,2:8)=["dt=1/64" "dt=1/128" "dt=1/256" "dt=1/512" "dt=1/1024" "dt=1/2048" "dt=1/4096"];
Nx=31;Ny=31;
x=0:1/(Nx+1):1;
y=0:1/(Ny+1):1;
b=zeros(Nx+2);
T_steady=SteadyGaussSeidel(b,Nx,Ny);
figure('Name','Solution a)')
surf(x,y,T_steady); title('Solution a). Temperature profile near steady state');
hold off
fprintf('Solution a). Teperature approaches 0 over all nodes.\n \n');

%% Explicit Euler
Nx=3;
Ny=3;
cntr=1; %Counter to assign subplot positions
h=figure('Visible', 'off');
table_row_count=2;
while Nx<=31
    x=0:1/(Nx+1):1;
    y=0:1/(Ny+1):1;
    ht=1/64; %Reset Time step dt
    table_column_count=2;
    hx=1/(Nx+1);
    %For the Selected Nx, Ny, find solution for all ht
    while ht>=1/4096
        T=ones(Ny+2,Nx+2); %Matrix of Temps initialisation
        t=0;
        while t<=0.5
            T= ExplicitEulerStep(Nx,Ny,ht,T);
            if (mod(t,0.125)==0)&&(t~=0)
                set(0,'CurrentFigure',h);
                fileName=strcat('ExplicitTime_',num2str(t),'_NxNy_',num2str(Nx),'_dt_',num2str(ht),'.jpg');
                sPlot=surf(x,y,T);
                title(strcat("N=",num2str(Nx)," dt=",num2str(strtrim(rats(ht)))),'Fontsize',20);
                xlabel('x','Fontsize',30)
                ylabel('y','Fontsize',30)
                zlabel('z','Fontsize',30)
                set(gca,'Fontsize',30)
                saveas(h,fileName);
                Larr=isnan(T);
                if (ht>0.25*hx^2)||any(T(:)>1)||any(T(:)<0)||any(isinf(T(:)))||all(T(:)==0)
                    stabilityCheck(table_row_count,table_column_count)='Unstable';
                end
            end
            t=t+ht;
        end
        ht=ht/2;
        table_column_count =table_column_count+1;
    end
    %Change Nx, Ny for next round of iteration
    Nx=2*Nx+1;
    Ny=2*Ny+1;
    table_row_count=table_row_count+1;
end
tReq=0.125;n=2;
while tReq<=0.5
    Nreq=3;
    cntr=1;
    fileNames{28}=[];
    while Nreq<=31
        htReq=1/64;
        while htReq>=(1/4096)
            fileName=char(strcat('ExplicitTime_',num2str(tReq),'_NxNy_',num2str(Nreq),'_dt_',num2str(htReq),".jpg"));
            fileNames{cntr} = fileName;
            htReq=htReq/2;
            cntr=cntr+1;
        end
        Nreq=2*Nreq+1;
    end
    figure
    montage(fileNames, 'Size', [4 7]);
    title(char(strcat("Explicit Euler: Temperature at time ",num2str(tReq))),'Fontsize',20)
    set(gcf,'Position',get(0,'Screensize'));
    tReq=tReq+0.125;
    n=n+1;
end

%% Implicit Euler
Nx=3;
Ny=3;
ht=1/64;
while Nx<=31
    x=0:1/(Nx+1):1;
    y=0:1/(Ny+1):1;
    T=ones(Ny+2,Nx+2);
    t=0;
    while t<=0.5
        T= ImplicitEulerStep(Nx,Ny,ht,T);
            if mod(t,0.125)==0&&(t>0)
                set(0,'CurrentFigure',h);
                fileName=strcat('ImplicitTime_',num2str(t),'_NxNy_',num2str(Nx),'_dt_',num2str(ht),'.jpg');
                sPlot=surf(x,y,T);
                title(strcat("N=",num2str(Nx)," dt=",num2str(strtrim(rats(ht)))),'Fontsize',10);
                xlabel('x','Fontsize',20)
                ylabel('y','Fontsize',20)
                zlabel('z','Fontsize',20)
                set(gca,'Fontsize',20)
                saveas(h,fileName);
            end
    t=t+ht;
    end
    Nx=2*Nx+1;
    Ny=2*Ny+1;
end
tReq=0.125;n=6;
fileNames(:)=[];
while tReq<=0.5
    Nreq=3;
    cntr=1;
    fileNames{4}=[];
    while Nreq<=31
        htReq=1/64;
        fileName=char(strcat('ImplicitTime_',num2str(tReq),'_NxNy_',num2str(Nreq),'_dt_',num2str(htReq),'.jpg'));
        fileNames{cntr} = fileName;
        htReq=htReq/2;
        cntr=cntr+1;
        Nreq=2*Nreq+1;
    end
    figure
    montage(fileNames, 'Size', [2 2]);
    title(char(strcat("Implicit Euler: Temperature at time ",num2str(tReq))),'Fontsize',30)
    set(gcf,'Position',get(0,'Screensize'));
    tReq=tReq+0.125;
    n=n+1;
end

% Print Stability table
stabilityCheck
