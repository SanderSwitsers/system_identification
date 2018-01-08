function [ varargout ] = preprocess( varargin )
%PREPROCESS Preprocesses the data
%   y_preprocessed = preprocess(y_raw)
%   !! output vector slightly shorter due to delay correction !!
%
%System Identification & Modeling
%
%Author:
%HENRI DE PLAEN
%r0681349
%KULeuven
%
%Date:
%6-1-2018 (new version after crash)

%% parameters
offset = 14.95 ;
delay = 15 ;
w_c = .1 ;
butter_order = 2 ;

%% init
assert(nargin==1,'Too much input arguments: only one required') ;
assert(nargout==1,'Too much output arguments: only one required') ;
y_raw = varargin{1} ;

%% preprocess

%offset
y_1 = y_raw - offset ;

%peak shaving
y_2 = pkshave(y_1,[-2 2],false) ;

%frequency
[filter_b, filter_a] = butter(butter_order,w_c,'high') ;
y_3 = filter(filter_b, filter_a,y_2) ;

%delay
y_4 = y_3(delay:end) ;

%% finalize
varargout{1} = y_4 ;

end

