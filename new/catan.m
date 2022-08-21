clc;
clear;
rng shuffle;

% Create a UI window:
windowWidth = 800;
window = uifigure(Name="Catan", Units="pixels", Position=[100, 100, windowWidth, windowWidth]);

% Create panel for the game board:
boardWidth = windowWidth / 2;
board = uipanel(Parent=window, Units="pixels", Position=[0, boardWidth, boardWidth, boardWidth], BackgroundColor=[0 191 255]/255);

% Create a plot for the map:
map = uiaxes(Parent=board, Position=[-8, 0, boardWidth, boardWidth]);

% Adjust plot settings:
map.Toolbar.Visible = "off";
map.Interactions = dataTipInteraction;
axis(map, "off");
hold(map, "on");
axis(map, "equal");

% map.Position = [0, 0, boardWidth, boardWidth];
[matrixMap, xNumberMap, yNumberMap, diceMap] = plotMap(map);

setappdata(0, "matrixMap", matrixMap);

setappdata(0, "test", 0);

% canBuild arrays keep track of where things can be built:
canBuildRoad = NaN(23, 21);
canBuildSettlement = NaN(23, 21);

% victoryPoints stores the victory points of each player:
victoryPoints = zeros(1, 2);

% resourceScoreboard keeps track of the players' resources:
resourceScoreboard = zeros(2, 6);

% Panel for player actions:
actions = uipanel(Parent=window, Position=[boardWidth, 0, boardWidth, boardWidth]);

% Get the number of players from user input:
% nPlayers = inputdlg("Enter number of players:");
nPlayers = 2; % DEBUG

% Create an array of players:
players = player.empty(0, nPlayers);
for idx = 1:nPlayers
%     players(end+1) = player(idx)
    players(idx) = player(idx);
end



testButton = uibutton(Parent=actions,...
                      Position=[100, 100, 100, 50],...
                      ButtonPushedFcn=@(testButton, event) testButtonCallback(testButton));

function testButtonCallback(~)

    setappdata(0, "test", getappdata(0, "test")+1);
    fprintf("%d", getappdata(0, "test"));
end



% catan();