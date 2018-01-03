%% PRELIMINARIES
N = 5000;
R0 = 1000 ;
fgen = .1 ;
fnoise = [ .999, .95, .6 ] ;
sigma_i0 = .1 ;
sigma_ni = .1 ;
sigma_nu = 1 ;

expeset_size = 1000 ;
maxlag = 10 ;
%prealloc
expe_ls = zeros(expeset_size,size(fnoise,2)) ;
expe_iv = zeros(expeset_size,size(fnoise,2)) ;

%% GENERATING EXPERIMENTS
set(0,'DefaultTextInterpreter','Latex')
figure ; hold on ;

h = waitbar(0) ;
for inoise = 1:size(expe_ls,2)
    for iexpe = 1:expeset_size
        e1=randn(N,1);
        [bgen,agen] = butter(1,fgen);
        i0 = filter(bgen,agen,e1);
        i0 = sigma_i0/std(i0)*i0 ; %rescaling
        
        e2=randn(N,1);
        [bnoise,anoise] = butter(2,fnoise(inoise));
        ni = filter(bnoise,anoise,e2);
        ni = sigma_ni/std(ni)*ni ; %rescaling
        
        u0 = R0*i0 ;
        nu = sigma_nu*randn(N,1) ; %rescaling
        
        i = i0 + ni ;
        u = u0 + nu ;
        
        expe_ls(iexpe,inoise) = r_estimator(u,i,'ls') ;
        expe_iv(iexpe,inoise) = r_estimator(u,i,'iv',1) ;
        
        waitbar(((inoise-1)*expeset_size + iexpe)/3000, h) ;
    end
    
    %% PLOT
    subplot(3,3,[1 2 3]) ; axis([400 1200 0 .06]) ; hold on ;
    [f,xi] = ksdensity(expe_ls(:,inoise)) ; plot(xi,f) ;
    [f,xi] = ksdensity(expe_iv(:,inoise)) ; plot(xi,f) ;
    ylabel('PDF($R$)') ;
    
    subplot(3,3,3+1) ; ylabel('Auto-correlation') ; hold on ;
    subplot(3,3,3+inoise) ; hold on ; xlabel('Lag') ;
    [i0_corr, i0_lags] = xcorr(i0,maxlag,'unbiased') ; 
    [ni_corr, ni_lags] = xcorr(ni,maxlag,'unbiased') ;
    plot(i0_lags(maxlag+1:end),i0_corr(maxlag+1:end), ...
        '-+b', ni_lags(maxlag+1:end), ni_corr(maxlag+1:end), '-+r') ;
    plot(i0_lags(maxlag+2),i0_corr(maxlag+2), ...
        'ob', ni_lags(maxlag+2), ni_corr(maxlag+2), 'or') ;
    axis([0 10 -.002 0.011]);
    
    subplot(3,3,2*3+1) ; ylabel('Filter [db]') ; hold on ;
    subplot(3,3,2*3+inoise) ; hold on ; xlabel('$f/f_s$') ;
    [hz,w] = freqz(bgen,agen,8192) ; plot(w/2/pi,20*log10(abs(hz))) ;
    [hz,w] = freqz(bnoise,anoise,8192) ; plot(w/2/pi,20*log10(abs(hz))) ;
    axis([0 .5 -30 10]) ;
end

close(h) ; hold off ;