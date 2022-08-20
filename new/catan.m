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

radius = 5;
xSpacing = 2 * (sqrt(3)/2 * radius);
ySpacing = radius + radius / 2;

% radiusOcean = 25;
% theta = linspace(0, 360, 7);
% xCircle = radiusOcean * cosd(theta) + 3 * xSpacing;
% yCircle = radiusOcean * sind(theta);
% fill(xCircle, yCircle, [255 0 0]/255, Parent=map);

map.Toolbar.Visible = "off";
axis(map, "off");
hold(map, "on");
axis(map, "equal");

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Define dimensions of grid:
hexesPerRow = [3, 4, 5, 4, 3];
xStartPoint = [xSpacing, xSpacing/2, 0, xSpacing/2, xSpacing];
yStartPoint = [ySpacing * 2, ySpacing, 0, -ySpacing, -ySpacing * 2];

% matrixMap keeps track of roads and settlements:
matrixMap = readcell('map.csv');

% x/y NumberMaps store the graph coordinates:
xNumberMap = NaN(23, 21);
yNumberMap = NaN(23, 21);

% diceMap stores hex roll values:
diceMap = NaN(23, 21);

% canBuild arrays keep track of where things can be built:
canBuildRoad = NaN(23, 21);
canBuildSettlement = NaN(23, 21);

% victoryPoints stores the victory points of each player:
victoryPoints = zeros(1, 2);

% resourceScoreboard keeps track of the players' resources:
resourceScoreboard = zeros(2, 6);

% TODO: These variables can be improved
% Determine dimensions of data hexes:
xSpacingData = 4;
xStartData = [7, 5, 3, 5, 7];
yStartData = [4, 8, 12, 16, 20];

% Total available resources/numbers (to be assigned to hexes):
resources = {'grain',  'grain',  'grain',  'grain',...
             'lumber', 'lumber', 'lumber', 'lumber',...
             'wool',   'wool',   'wool',   'wool',...
             'ore',    'ore',    'ore',...
             'brick',  'brick',  'brick',  'gold'};
numbers = [2 3 3 4 4 5 5 6 6 7 8 8 9 9 10 10 11 11 12];

% Plot "hexagons":

for loop1 = 1:size(hexesPerRow, 2) %<SM:FOR>
    
    for loop2 = 1:hexesPerRow(1, loop1) %<SM:FOR> %<SM:NEST>
        
        tileName = 'placeholder';
        while strcmp(tileName, 'placeholder') %<SM:NEST>
            
            marker = randi([1 size(resources, 2)]); %<SM:RANDGEN>
            randomResource = resources{1, marker}; %<SM:RANDUSE>
            resources{1, marker} = 0;
            
            switch randomResource  %<SM:SWITCH> %<SM:NEST>
                case 'grain'
                    color = [240 230 140]/255;
                    tileName = 'Grain';
                    tileResource = 'GRN';
                    
                case 'lumber'
                    color = [34 139 34]/255;
                    tileName = 'Lumber';
                    tileResource = 'LBR';
                    
                case 'wool'
                    color = [119 221 119]/255;
                    tileName = 'Wool';
                    tileResource = 'WOL';
                    
                case 'ore'
                    color = [169 169 169]/255;
                    tileName = 'Ore';
                    tileResource = 'ORE';
                    
                case 'brick'
                    color = [210 105 30]/255;
                    tileName = 'Brick';
                    tileResource = 'BRK';
                    
                case 'gold'
                    color = [255 215 0]/255;
                    tileName = 'Gold';
                    tileResource = 'GLD';
            end
        end
        
        %{
        KEY:
        
        GRN - Grain
        LBR - Lumber
        WOL - Wool
        ORE - Ore
        BRK - Brick
        GLD - Gold
        
        %}
        
        tileNumber = 0;
        while tileNumber == 0 %<SM:WHILE>
            
            marker = randi([1 size(numbers, 2)]);
            randomNumber = numbers(1, marker);
            numbers(:, marker) = [];
            
            if randomNumber ~= 0 %<SM:IF>
                tileNumber = randomNumber;
            end
            
        end
        
        % Plot individual hexes:
        
        theta = linspace(90,450,7);
        xCircle = radius * cosd(theta) + xStartPoint(1, loop1) + loop2 * xSpacing;
        yCircle = radius * sind(theta) + yStartPoint(1, loop1);
        
        
        if tileNumber == 6 || tileNumber == 8
            textColor = 'r';
        else
            textColor = 'k';
        end
        
        
        fill(xCircle, yCircle, color, Parent=map);
        text(xStartPoint(1, loop1) + loop2 * xSpacing, yStartPoint(1, loop1), sprintf('%d\n%s', tileNumber, tileName), 'HorizontalAlignment', 'center', Parent=map);
        
        %axis equal off;
        
        % Insert resource type into data map:
        
        row = yStartData(1, loop1);
        column = xStartData(1, loop1) + (loop2-1) * xSpacingData;
        
        matrixMap{row, column} = tileResource;
        diceMap(row, column) = tileNumber; %<SM:REF>
        
        
        for loop3 = 1:6 %<SM:FOR>
            switch loop3
                
                case 1
                    xNumberMap(row-3, column) = xCircle(1, 1);
                    yNumberMap(row-3, column) = yCircle(1, 1);
                    
                case 2
                    xNumberMap(row-1, column-2) = xCircle(1, 2);
                    yNumberMap(row-1, column-2) = yCircle(1, 2);
                    
                case 3
                    xNumberMap(row+1, column-2) = xCircle(1, 3);
                    yNumberMap(row+1, column-2) = yCircle(1, 3);
                    
                case 4
                    xNumberMap(row+3, column) = xCircle(1, 4);
                    yNumberMap(row+3, column) = yCircle(1, 4);
                    
                case 5
                    xNumberMap(row+1, column+2) = xCircle(1, 5);
                    yNumberMap(row+1, column+2) = yCircle(1, 5);
                    
                case 6
                    xNumberMap(row-1, column+2) = xCircle(1, 6);
                    yNumberMap(row-1, column+2) = yCircle(1, 6);
            end
        end
    end
end
