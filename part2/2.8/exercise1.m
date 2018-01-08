prompt = 'Choose a sample system [1-30]: ';
sample = input(prompt);

sampledir = '/freeware/env/matlab/hb81/samples/';
load([sampledir,'sample',num2str(sample)]);

% Build idpoly
syspoly = idpoly(a,b,[],[],1,0,1,'nk',nk);

clearvars -except syspoly
