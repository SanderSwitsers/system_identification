function [ varargout ] = preprocess( varargin )
%PROPROCESS Preprocesses the data to be analyzed
%function y_preprocessed = preprocess(y_raw)
%   !! preprocessed data is shorter due to delay correction
%
%System Identification and Modeling
%Exercise - Part 2
%
%HENRI DE PLAEN
%r0681349
%KULeuven
%
%Date: 1-5-2018

%% init
f_cut_rel = 0.1 ;
offset = 14.95 ;
delay = 15 ;

assert(nargin==1,'Too many input arguments') ;
y_raw = varargin{1} ;

%% peak shave
y_1 = pkshave(y_raw,[0.8 1.2]*offset,false)-offset ;

%% high pass filter
[b,a] = butter(4,f_cut_rel,'high') ;
y_2 = filter(b,a,y_1) ;

%% delay correction
y_preprocessed = y_2(delay:end) ;

%% out
varargout{1} = y_preprocessed ;

end

