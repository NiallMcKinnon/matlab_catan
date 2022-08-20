clc;
clear;
rng shuffle;

% Create a UI window:
windowWidth = 800;
window = uifigure(Name="Catan", Units="pixels", Position=[0, 0, windowWidth, windowWidth]);

% Create panel for the game board:
boardWidth = windowWidth / 2;
board = uipanel(window, Units="pixels", Position=[0, boardWidth, boardWidth, boardWidth], BackgroundColor=[0 191 255]/255);

% Create a plot for the map:
map = uiaxes(Parent=board);

% radius = 5;
% xSpacing = 2 * (sqrt(3)/2 * radius);
% ySpacing = radius + radius / 2;

% radiusOcean = 25;
% theta = linspace(0, 360, 7);
% xCircle = radiusOcean * cosd(theta) + 3 * xSpacing;
% yCircle = radiusOcean * sind(theta);
% fill(xCircle, yCircle, [255 0 0]/255, Parent=map);

map.Toolbar.Visible = "off";
axis(map, "off");
hold(map, "on");
axis(map, "equal");

[matrixMap, xNumberMap, yNumberMap, diceMap] = plotMap(map);

% canBuild arrays keep track of where things can be built:
canBuildRoad = NaN(23, 21);
canBuildSettlement = NaN(23, 21);

% victoryPoints stores the victory points of each player:
victoryPoints = zeros(1, 2);

% resourceScoreboard keeps track of the players' resources:
resourceScoreboard = zeros(2, 6);