function plotSettlement(xPoint, yPoint, color)

% Plots the shape of a settlement on specified coordinates
% 
% Niall McKinnon, s05

x = [xPoint, xPoint-.5, xPoint-.5, xPoint+.5, xPoint+.5, xPoint];
y = [yPoint+1, yPoint+.5, yPoint-.5, yPoint-.5, yPoint+.5, yPoint+1];

fill(x, y, color); %<SM:PLOT>   