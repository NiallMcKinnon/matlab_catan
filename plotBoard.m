function [outputArg1,outputArg2] = untitled(inputArg1,inputArg2)
    %UNTITLED Summary of this function goes here
    %   Detailed explanation goes here
    radius = 5
    xSpacing = 2 * (sqrt(3)/2 * radius);
    ySpacing = radius + radius / 2;
    
    % Define dimensions of grid:
    
    hexesPerRow = [3, 4, 5, 4, 3];
    
    xStartPoint = [xSpacing, xSpacing/2, 0, xSpacing/2, xSpacing];
    yStartPoint = [ySpacing * 2, ySpacing, 0, -ySpacing, -ySpacing * 2];
    
end