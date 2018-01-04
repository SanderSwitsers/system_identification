r_number = 0681349 ;
r_value = 49 ; %Last two numbers of r_number

%% signal
N = 20+floor(r_value/10*6);
L = 20*N ;
y = randn(L,1);

%% cos and sin of wanted frequency
ts = 1/N;
t = 0:ts:ts*(N-1);
f_cos = repmat(cos(t*2*pi),[1 20]);
f_sin = repmat(sin(t*2*pi),[1 20]);

% %plot
% plot(f_cos) ; hold on ;
% plot(y) ;