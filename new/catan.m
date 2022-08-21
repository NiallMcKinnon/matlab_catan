clc;
clear;
rng shuffle;

% Get the number of players from user input:
% nPlayers = inputdlg("Enter number of players:");
nPlayers = 6; % DEBUG

% Create an array of players:
players = player.empty(0, nPlayers);
for idx = 1:nPlayers
    players(idx) = player(idx);
end
setappdata(0, "players", players);

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

% Store current player, initialize as player 1:
temp = getappdata(0, "players");
setappdata(0, "currentPlayer", temp(1, 1));

% Panel for player actions:
actions = uipanel(Parent=window, Position=[0, 0, boardWidth*2, boardWidth]);

% Panel for scoreboard:
scoreboard = uipanel(Parent=window, Position=[boardWidth, boardWidth, boardWidth, boardWidth]);
setappdata(0, "scoreboard", scoreboard);

% Heading for actions panel:
actionHeading = uilabel(Parent=actions,...
                         Text=sprintf("Player %d Turn %d", 1, 1),...
                         HorizontalAlignment='center',...
                         Position=[(actions.Position(1, 3)/2), 100, 100, 25]);
setappdata(0, "actionHeading", actionHeading);

testButton = uibutton(Parent=actions,...
                      Position=[200, 50, 100, 50],...
                      ButtonPushedFcn=@(testButton, event) endTurnCallback(testButton),...
                      Text="End Turn");

function refreshActionPanel()
    
    % Get currentPlayer:
    currentPlayer = getappdata(0, "currentPlayer");
    
    % Update heading to the current player:
    actionHeading = getappdata(0, "actionHeading");
    actionHeading.Text = sprintf("Player %d Turn %d", currentPlayer.number, currentPlayer.turn);
    setappdata(0, "actionHeading", actionHeading);

end

function endTurnCallback(~)

    % Get currentPlayer and players from appdata:
    currentPlayer = getappdata(0, "currentPlayer");
    players = getappdata(0, "players");

    % Move currentPlayer to next turn:
    currentPlayer.turn = currentPlayer.turn + 1;
    
    % Get the next player:
    if currentPlayer.number < length(players)
        nextPlayer = players(1, (currentPlayer.number+1));

    else
        nextPlayer = players(1, 1);
    end
    
    % Update players with new data:
    players(1, currentPlayer.number) = currentPlayer;
    setappdata(0, "players", players);
    
    % Update currentPlayer:
    setappdata(0, "currentPlayer", nextPlayer);

    refreshActionPanel();

end



% catan();