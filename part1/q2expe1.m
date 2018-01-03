%% PRELIMINARIES
N = 5000;
R0 = 1000 ;
sigma_i0 = .01 ;
sigma_ni = .001 ;
sigma_nu = 1 ;

expeset_size = 1000 ;
%prealloc
expe = zeros(expeset_size,2) ;

%% EXPERIMENTS
for iexpe = 1:expeset_size
    i0=sigma_i0*randn(N,1) ; ni=sigma_ni*randn(N,1) ;
    u0 = R0*i0 ; nu = sigma_nu*randn(N,1) ;
    i = i0 + ni ; u = u0 + nu ;
    
    expe(iexpe,1) = r_estimator(u,i,'ls') ;
    expe(iexpe,2) = r_estimator(u,i,'eiv',sigma_nu,sigma_ni) ;
end

%% PLOTS
figure ; hold on ; 
[f1,xi1] = ksdensity(expe(:,1)) ; plot(xi1,f1,'-k') ;
[f2,xi2] = ksdensity(expe(:,2)) ; plot(xi2,f2,'-r') ;
set(0,'DefaultTextInterpreter','Latex') ;
ylabel('PDF($R$)') ; xlabel('$R$') ;
axis([980 1010 0 0.25]) ; legend('LS','EIV') ;