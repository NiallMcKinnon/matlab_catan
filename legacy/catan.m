%{

    Catan, in MATLAB!
    Created by: Niall McKinnon

    Run this file to play the game.
    
    This was originally a final project for an intro to MATLAB course in
    college. I have begun rafactoring and maintaining it in order to keep
    a working knowledge of MATLAB syntax.

    This is meant to be kind of silly, it's in no way an endorsement of
    using MATLAB for game development.

%}

clc;
clear;
close all;
format compact;
rng shuffle;

% Define dimensions of hexes:
radius = 5;
xSpacing = 2 * (sqrt(3)/2 * radius);
ySpacing = radius + radius / 2;

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

% Plot background:
radiusOcean = 25;
theta = linspace(0, 360, 7);
xCircle = radiusOcean * cosd(theta) + 3 * xSpacing;
yCircle = radiusOcean * sind(theta);
fill(xCircle, yCircle, [0 191 255]/255);
axis off;
hold on;
axis equal;

printRules();

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
        
        
        fill(xCircle, yCircle, color);
        text(xStartPoint(1, loop1) + loop2 * xSpacing, yStartPoint(1, loop1), sprintf('%d\n%s', tileNumber, tileName), 'HorizontalAlignment', 'center');
        
        axis equal off;
        
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

nPlayers = 2; % In future versions, could be changed via user input
orange = [255 140 0]/255;
colors = {'r', 'b'};

% Generate UI:


% Complete first turn:

for loop4 = 1:nPlayers
    
    for loop5 = 1:2
        
        if loop5 == 1 %<SM:BOP>
            oppositeLoop = 2;
        else
            oppositeLoop = 1;
        end
        
        % PLACE SETTLEMENT:
        
        [matrixMap, canBuildRoad, canBuildSettlement, victoryPoints] = buildSettlementTurn1(victoryPoints, matrixMap, canBuildRoad, canBuildSettlement, xNumberMap, yNumberMap, loop5, oppositeLoop, colors{1, loop5}); %<SM:PDF> %<SM:PDF_PARAM> %<SM:PDF_RETURN>
        
        % PLACE ROAD:
        
        [canBuildRoad, canBuildSettlement] = buildRoadTurn1(matrixMap, canBuildRoad, canBuildSettlement, xNumberMap, yNumberMap, loop5, oppositeLoop, colors{1, loop5});
    end
    
    % Gather Initial Resources:
    
    for gatheringLoop = 1:2
        
        iconToCheck = sprintf('%dS', gatheringLoop);
        
        [rInitialS, cInitialS] = find(strcmp(matrixMap, iconToCheck)); %<SM:SEARCH>
        
        for initialCollectLoop = 1:size(rInitialS, 1)
            
            rSettlement = rInitialS(initialCollectLoop, 1);
            cSettlement = cInitialS(initialCollectLoop, 1);
            
            rBorder = [rSettlement-3, rSettlement-1, rSettlement+1, rSettlement+3, rSettlement+1, rSettlement-1];
            cBorder = [cSettlement, cSettlement-2, cSettlement-2, cSettlement, cSettlement+2, cSettlement+2];
            
            for loopInitial2 = 1:6
                
                rPlaceToCheck = rBorder(1, loopInitial2);
                cPlaceToCheck = cBorder(1, loopInitial2);
                
                try
                placeToCheck = matrixMap{rPlaceToCheck, cPlaceToCheck};
                                
                switch placeToCheck
                    
                    case 'GRN'
                        
                         resourceScoreboard(gatheringLoop, 1) = resourceScoreboard(gatheringLoop, 1) + 1;
                        
                    case 'LBR'
                        
                        resourceScoreboard(gatheringLoop, 2) = resourceScoreboard(gatheringLoop, 2) + 1;
                        
                    case 'WOL'
                        
                        resourceScoreboard(gatheringLoop, 3) = resourceScoreboard(gatheringLoop, 3) + 1;
                        
                    case 'ORE'
                        
                        resourceScoreboard(gatheringLoop, 4) = resourceScoreboard(gatheringLoop, 4) + 1;
                        
                    case 'BRK'
                        
                        resourceScoreboard(gatheringLoop, 5) = resourceScoreboard(gatheringLoop, 5) + 1;
                        
                    case 'GLD'
                        
                        resourceScoreboard(gatheringLoop, 6) = resourceScoreboard(gatheringLoop, 6) + 1;
                    
                end
                
                catch
                end
            end
            
        end
    end
    
end

% TODO: Tie future actions to button clicks.


nTurns = 0;

victoryFlag = true;

while victoryFlag == true
    
    nTurns = nTurns + 1;
    
    for loopTurns = 1:2
        
        color = colors{1, loopTurns};
        
        if loopTurns == 1 %<SM:BOP>
            oppositeLoop = 2;
        else
            oppositeLoop = 1;
        end
        
        diceRoll = randi(6) + randi(6);
        
        fprintf("DEBUG: Roll: %d", diceRoll);
        
        
        [rGather, cGather] = find(diceRoll == diceMap);
        
        for gatherLoop = 1:size(rGather, 1)
            
            rTile = rGather(gatherLoop, 1);
            cTile = cGather(gatherLoop, 1);
            
            rBorder = [rTile-2, rTile-1, rTile+1, rTile+2, rTile+1, rTile-1];
            cBorder = [cTile, cTile-2, cTile-2, cTile, cTile+2, cTile+2];
            
            resourceToGather = matrixMap{rTile, cTile};
            fprintf("DEBUG: Resource: %s", resourceToGather);
            
            switch resourceToGather
                
                case 'GRN'
                    
                    cResource = 1;
                    
                case 'LBR'
                    
                    cResource = 2;
                    
                case 'WOL'
                    
                    cResource = 3;
                    
                case 'ORE'
                    
                    cResource = 4;
                    
                case 'BRK'
                    
                    cResource = 5;
                    
                case 'GLD'
                    
                    cResource = 6;
                    
            end
            
            for gatherLoop2 = 1:6
                
                
                checkSpot = matrixMap{rBorder(1, gatherLoop2), cBorder(1, gatherLoop2)};
                
                
                switch checkSpot
                    
                    case '1S'
                        
                        resourceScoreboard(1, cResource) = resourceScoreboard(1, cResource) + 1;
                        
                    case '1C'
                        
                        resourceScoreboard(1, cResource) = resourceScoreboard(1, cResource) + 2;
                        
                    case '2S'
                        
                        resourceScoreboard(2, cResource) = resourceScoreboard(2, cResource) + 1;
                        
                    case '2C'
                        
                        resourceScoreboard(2, cResource) = resourceScoreboard(2, cResource) + 2;
                end
                
            end
            
        end
        
        
        
        
        flag3 = true;
        while flag3 == true
            
            flag4 = true;
            while flag4 == true
                
                fprintf('\nPLAYER %d TURN %d:                                               (%d Victory Points)         Dice Roll: %d\n', loopTurns, nTurns, victoryPoints(1, loopTurns), diceRoll);
                
                fprintf('\nACTIONS:               COST:                                   AVAILABLE RESOURCES:');
                fprintf('\n');
                fprintf('\n1 - Build Settlement   (1 Grain, 1 Lumber, 1 Wool, 1 Brick)    GRAIN:  %d', resourceScoreboard(loopTurns, 1));
                fprintf('\n2 - Build Road         (1 Lumber, 1 Brick)                     LUMBER: %d', resourceScoreboard(loopTurns, 2));
                fprintf('\n3 - Build City         (2 Grain, 3 Ore)                        WOOL:   %d', resourceScoreboard(loopTurns, 3));
                fprintf('\n4 - Trade Resources                                            ORE:    %d', resourceScoreboard(loopTurns, 4));
                fprintf('\n5 - End Turn                                                   BRICK:  %d', resourceScoreboard(loopTurns, 5));
                fprintf('\n6 - Help                                                       GOLD:   %d', resourceScoreboard(loopTurns, 6));
                
                userChoice = input('\n\nSelect Action (1-6) > ');
                
                if userChoice ~= 1:6
                    fprintf('\nINVALID INPUT! Try again.');
                    
                else
                    flag4 = false;
                    
                end
            end
            
            switch userChoice
                
                case 1 % Build Settlement
                    
                    if ~isempty(find(canBuildSettlement == loopTurns | canBuildSettlement == 3, 1)) && resourceScoreboard(loopTurns, 1) >= 1 && resourceScoreboard(loopTurns, 2) >= 1 && resourceScoreboard(loopTurns, 3) >= 1  && resourceScoreboard(loopTurns, 5) >= 1 %<SM:SEARCH>
                        
                        [matrixMap, canBuildRoad, canBuildSettlement, victoryPoints, resourceScoreboard] = buildSettlement(victoryPoints, matrixMap, canBuildRoad, canBuildSettlement, xNumberMap, yNumberMap, loopTurns, color, resourceScoreboard);
                        
                    elseif isempty(find(canBuildSettlement == loopTurns | canBuildSettlement == oppositeLoop, 1)) %<SM:SEARCH>
                        
                        fprintf('\nNo places to build settlements! Try expanding your roads!\n');
                        
                    else
                        
                        fprintf('\nNot enough resources! Try a different action!\n');
                    end
                    
                case 2 % Build Road
                    
                    if resourceScoreboard(loopTurns, 2) >= 1 && resourceScoreboard(loopTurns, 5) >= 1 %<SM:ROP>
                        
                        [canBuildRoad, canBuildSettlement, resourceScoreboard] = buildRoad(matrixMap, canBuildRoad, canBuildSettlement, xNumberMap, yNumberMap, loopTurns, oppositeLoop, color, resourceScoreboard);
                        
                    else
                        
                        fprintf('\nNot enough resources! Try a different action!\n');
                        
                    end
                    
                case 3 % Build City
                    
                    if resourceScoreboard(loopTurns, 1) >= 2 && resourceScoreboard(loopTurns, 4) >= 3
                        
                        [matrixMap, victoryPoints, resourceScoreboard] = buildCity(victoryPoints, matrixMap, xNumberMap, yNumberMap, loopTurns, color, resourceScoreboard);
                        
                    else
                        
                        fprintf('\nNot enough resources! Try a different action!\n');
                        
                    end
                    
                case 4
                    % add trade mechanic in future version
                    
                    fprintf('\nTrade mechanics are coming in a future release!\n');
                    
                case 5                                        
                    
                    flag3 = false;
                    
                case 6
                    
                     printRules();
            end
            
        end
        
        if victoryPoints(1, loopTurns) >= 10
            fprintf('Congradulations Team %d, you win!', loopTurns);
            
            victoryFlag = false;
        end
        
    end
end

