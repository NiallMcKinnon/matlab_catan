function plotCity(xPoint, yPoint, color)

% Plots the shape of a city on specified coordinates
% 
% Niall McKinnon, s05

x = [xPoint, xPoint-1, xPoint-1, xPoint+1, xPoint+1, xPoint];
y = [yPoint+2, yPoint+1, yPoint-1, yPoint-1, yPoint+1, yPoint+2];

fill(x, y, color);