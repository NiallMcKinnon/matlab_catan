function [canBuildRoad, canBuildSettlement, resourceScoreboard] = buildRoad(matrixMap, canBuildRoad, canBuildSettlement, xNumberMap, yNumberMap, teamNumber, oppositeTeam, color, resourceScoreboard) %<SM:PDF> %<SM:PDF_PARAM> %<SM:PDF_RETURN>

% Plots a road from a valid start point to an end point of the user's
% discretion
%
% Niall McKinnon, s05

roadLength = 5;

flag2 = true;
while flag2 == true %<SM:WHILE>
    
    flag3 = true;
    while flag3 == true
        title(sprintf('Player %d Select Road Starting Point', teamNumber));
        
        [xStart, yStart, rStart, cStart] = closestClick(xNumberMap, yNumberMap);
        
        
        if canBuildRoad(rStart, cStart) == teamNumber || canBuildRoad(rStart, cStart) == 3 %<SM:IF>
            
            flag3 = false;
            
        else
            
            waitfor(msgbox(sprintf('Invalid start point!\nRoads must start at settlements, cities, or other roads.\nTry again.')));
            
        end
    end
            
    title(sprintf('Player %d Select Road Ending Point', teamNumber));
    
    [xEnd, yEnd, rEnd, cEnd] = closestClick(xNumberMap, yNumberMap);
    
    xRoad = [xStart, xEnd];
    yRoad = [yStart, yEnd];
    
    wantedLength = round(sqrt((xEnd - xStart)^2 + (yEnd - yStart)^2));
    
    if wantedLength == roadLength
        
        if canBuildSettlement(rEnd, cEnd) == 4
            
            % do nothing
            
        elseif canBuildSettlement(rEnd, cEnd) == oppositeTeam
            
            canBuildSettlement(rEnd, cEnd) = 3;
            
        else
            
            canBuildSettlement(rEnd, cEnd) = teamNumber;
        end
        
        if strcmp(matrixMap{rEnd, cEnd}, sprintf('%dS', oppositeTeam)) || strcmp(matrixMap{rEnd, cEnd}, sprintf('%dC', oppositeTeam))
            
            % do nothing
            
        elseif ~isnan(canBuildRoad(rEnd, cEnd))
            
            canBuildRoad(rEnd, cEnd) = 3;
            
        else
            
            canBuildRoad(rEnd, cEnd) = teamNumber;
            
        end
        
        plot(xRoad, yRoad, color, 'LineWidth', 3); %<SM:PLOT>   
        
        % Cover road start with existing buildings(preserve layers)
        
        switch matrixMap{rStart, cStart}
            
            case sprintf('%dS', teamNumber)
                
                plotSettlement(xStart, yStart, color);
                
            case sprintf('%dC', teamNumber)
                
                plotCity(xStart, yStart, color);                
        end
        
        % Cover road end with existing buildings(preserve layers)
        
        switch matrixMap{rEnd, cEnd}
            
            case sprintf('%dS', teamNumber)
                
                plotSettlement(xEnd, yEnd, color);
                
            case sprintf('%dC', teamNumber)
                
                % plot city - to be added later
                
            case sprintf('%dS', oppositeTeam)
                
                plotSettlement(xEnd, yEnd, color);
                
            case sprintf('%dC', oppositeTeam)
                
                % plot enemy city - to be added later                
        end
        
        resourceScoreboard(teamNumber, 2) = resourceScoreboard(teamNumber, 2) - 1;
        resourceScoreboard(teamNumber, 5) = resourceScoreboard(teamNumber, 5) - 1;
        
        flag2 = false;
        
    else
        waitfor(msgbox('Incorrect road length! Try again.'));
    end
end