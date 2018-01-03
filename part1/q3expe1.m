%Author: HENRI DE PLAEN
%r0681349
%KULeuven
%
%EXERCISES - SYSTEM ID. & MOD.
%Part Schoukens - Q3 (AIC)
%
%!! Works only on Matlab R2016b or later !!


%% PRELIMINARIES
Nest = 1000 ;
Nval = 10000 ;
su0 = 1 ;
sny = [.5 .05] ;
[b,a] = cheby1(3,.5,[2*.15 2*.3]) ;
order=0:100 ;

expeestls = zeros(size(order,2),size(sny,2)) ;
expeestaic = zeros(size(order,2),size(sny,2)) ;
expevalls = zeros(size(order,2),size(sny,2)) ;
costvalls = zeros(size(order,2),size(sny,2)) ;
%% EXPERIMENT
for iexpe=1:size(sny,2)
    %EST
    u0est=su0*randn(Nest,1);
    y0est=filter(b,a,u0est);
    nyest=sny(iexpe)*randn(Nest,1);
    yest=y0est+nyest;
    
    %VAL
    u0val=su0*randn(Nval,1);
    y0val=filter(b,a,u0val);
    nyval=sny(iexpe)*randn(Nval,1);
    yval=y0val+nyval;
    
    for iorder=1:size(order,2)
        %EST
        [g,lsest,aicest] = g_estimator(yest,u0est,order(iorder)) ;
        expeestls(iorder,iexpe) = lsest/sny(iexpe)^2 ;
        expeestaic(iorder,iexpe) = aicest/sny(iexpe)^2 ;
        
        %VAL
        expevalls(iorder,iexpe) = cost_ls(yval, u0val, g)/sny(iexpe)^2 ;
        costvalls(iorder,iexpe) = sqrt(cost_ls(y0val, u0val, g)/sny(iexpe)^2) ;
    end
end

%% PLOTS
figure ; set(0,'DefaultTextInterpreter','Latex') ; hold on ;
subplot(2,2,1) ; hold on ; title('Noisy Data') ;
plot(order,expeestls(:,1),'--k','LineWidth',1) ;
plot(order,expevalls(:,1),'-.k','LineWidth',1) ;
plot(order,expeestaic(:,1),'-k','LineWidth',1) ;
axis([0 100 .7 1.2]) ; xlabel('Order') ; ylabel('Cost') ;
legend('Estimation','Validation','AIC','Location','southeast') ;

subplot(2,2,3) ; hold on ;
plot(order,expeestls(:,2),'--k','LineWidth',1) ;
plot(order,expevalls(:,2),'-.k','LineWidth',1) ;
plot(order,expeestaic(:,2),'-k','LineWidth',1) ;
axis([0 100 .7 1.2]) ; xlabel('Order') ; ylabel('Cost') ;
legend('Estimation','Validation','AIC','Location','southeast') ;

subplot(2,2,2) ; hold on ; title('Noiseless Data') ;
plot(order,costvalls(:,1),'-k','LineWidth',1) ;
axis([0 100 0 1]) ; xlabel('Order') ; ylabel('Normalized RMS') ;
legend('V_0') ;

subplot(2,2,4) ; hold on ;
plot(order,costvalls(:,2),'-k','LineWidth',1) ;
axis([0 100 0 1]) ; xlabel('Order') ; ylabel('Normalized RMS') ;
legend('V_0') ;

hold off ;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function cost = cost_ls(y, u, g)

N= size(u,1) ; yhat = filter(g,1,u) ;
cost = 1/N*sum((y-yhat).^2) ;
end
