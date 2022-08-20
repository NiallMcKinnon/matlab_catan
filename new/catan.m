clc;
clear;
rng shuffle;

% Create a UI window:
windowWidth = 800;
window = uifigure(Name="Catan", Units="pixels", Position=[100, 100, windowWidth, windowWidth]);

% Create panel for the game board:
boardWidth = windowWidth / 2;
board = uipanel(window, Units="pixels", Position=[0, boardWidth, boardWidth, boardWidth], BackgroundColor=[0 191 255]/255);

% Create a plot for the map:
map = uiaxes(Parent=board, Position=[-8, 0, boardWidth, boardWidth]);

% Adjust plot settings:
map.Toolbar.Visible = "off";
disableDefaultInteractivity(map); % This line may need to be removed
axis(map, "off");
hold(map, "on");
axis(map, "equal");

% map.Position = [0, 0, boardWidth, boardWidth];
[matrixMap, xNumberMap, yNumberMap, diceMap] = plotMap(map);

% canBuild arrays keep track of where things can be built:
canBuildRoad = NaN(23, 21);
canBuildSettlement = NaN(23, 21);

% victoryPoints stores the victory points of each player:
victoryPoints = zeros(1, 2);

% resourceScoreboard keeps track of the players' resources:
resourceScoreboard = zeros(2, 6);

