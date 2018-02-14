%-------------------------------------------------------------------------%
%                main function: fitNormLengthVsTime                           %
%-------------------------------------------------------------------------%
% This function allows to compute the fit of the bacteria length  versus
% time 
%
% The input of the function are:
% - l (length of the cell)
% - t (time)
% The output of the function are the fitting parameters
% - kL: dacay constant 
% - l0: length at birth


function [kL, l0, fitOut]  = fitNormLengthVsTime(t, wl)

kLg = 0.008; % initial guess for kL [1/min]
wl0g = wl(1); % initial guess for length at birth [nm]

%Ag = 2000;
% p0 = [kLg, l0g, Ag];
p0 = [kLg, wl0g];

% Lower bound for the parameters p0
% pLB =[0, 1, 1000];
pLB =[0, 0];

% Upper bounds
% pUB =[20, 40, 3000];
pUB =[2, 1];

% Options definition
options = optimset('Display','iter-detailed');

% Solve nonlinear curve-fitting (data-fitting) problems in least-squares sense
p = lsqcurvefit(@growthModel, p0, t, wl, pLB, pUB, options);

kL = p(1);
l0 = p(2);

tFit = unique(sort(t));
lFit = growthModel(p, tFit);
fitOut = [tFit(:), lFit(:)];
end

%----------------------
function lOut = growthModel(p, t)

kL = p(1);
l0 = p(2);

%lOut = l0.*exp(-kL.*t) + A;
lOut = l0.*exp(kL.*t);


%fic

%3 conditions
%1. (t<tc), w=wMax
%2. (tc<t<tg), w=linear constriction
%3. (t>tg) w = 0;

% wOut = 0.*t;
% 
% %1. (t<tc), w=wMax
% isPreDiv = t<0;
% wOut(isPreDiv) = wMax;
% %wOut(isPreDiv)=1;
% 
% %2. (tc<t<tg),w=linear constriction
% %passes through points
% %(tc,wMax), (tg,0);
% isDiv = (t>=tc & t<tg);
% tDiv = t(isDiv);
% wOut(isDiv) = wMax.*sqrt( 1 - 1/(tg-tc).*(tDiv-tc) );
% 
% 
% 
% %3. (t>tg) w = 0;
% isPostDiv= (t>=tg);
% wOut(isPostDiv)=0;
end

