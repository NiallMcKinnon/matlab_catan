function [matrixMap, canBuildRoad, canBuildSettlement, victoryPoints, resourceScoreboard] = buildSettlement(victoryPoints, matrixMap, canBuildRoad, canBuildSettlement, xNumberMap, yNumberMap, teamNumber, color, resourceScoreboard) %<SM:PDF> %<SM:PDF_PARAM> %<SM:PDF_RETURN>

% Generates a settlement on the coordinates specified by a user click,
% while checking for incorrect inputs
% 
% Niall McKinnon, s05

flag = true;
while flag == true %<SM:WHILE>
    
    title(sprintf('Player %d Place Settlement', teamNumber)); %<SM:STRING>
    [xPoint, yPoint, rPoint, cPoint] = closestClick(xNumberMap, yNumberMap);
    
    if canBuildSettlement(rPoint, cPoint) == teamNumber || canBuildSettlement(rPoint, cPoint) == 3 %<SM:IF> %<SM:BOP>
        %matrixMap{rPoint, cPoint} == loop5 || matrixMap{rPoint, cPoint} == 0
        
        plotSettlement(xPoint, yPoint, color);
        
        matrixMap{rPoint, cPoint} = sprintf('%dS', teamNumber); %<SM:STRING>
        
        rAdjacent = [rPoint-2, rPoint-2, rPoint+2, rPoint+2, rPoint+2, rPoint-2];
        cAdjacent = [cPoint, cPoint-2, cPoint-2, cPoint, cPoint+2, cPoint+2];
        
        canBuildRoad(rPoint, cPoint) = teamNumber; %<SM:REF> 
        canBuildSettlement(rPoint, cPoint) = 4;
        
        for loop6 = 1:length(rAdjacent)
            try
                if ~cellfun(@isnan, matrixMap(rAdjacent(1, loop6), cAdjacent(1, loop6))) %<SM:IF>
                    
                    canBuildSettlement(rAdjacent(1, loop6), cAdjacent(1, loop6)) = 4;
                    
                end
            catch
                % do nothing
            end
        end
        
        victoryPoints(1, teamNumber) = victoryPoints(1, teamNumber) + 1;
        
        resourceScoreboard(teamNumber, 1) = resourceScoreboard(teamNumber, 1) - 1;
        resourceScoreboard(teamNumber, 2) = resourceScoreboard(teamNumber, 2) - 1;
        resourceScoreboard(teamNumber, 3) = resourceScoreboard(teamNumber, 3) - 1;
        resourceScoreboard(teamNumber, 5) = resourceScoreboard(teamNumber, 5) - 1;
        
        flag = false;
        
    else
        
        waitfor(msgbox('Too close to another settlement! Pick a diffent spot!'));  %<SM:NEWFUN>
    end
end