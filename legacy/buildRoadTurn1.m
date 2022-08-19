function [canBuildRoad, canBuildSettlement] = buildRoadTurn1(matrixMap, canBuildRoad, canBuildSettlement, xNumberMap, yNumberMap, loop5, oppositeTeam, color)

%
%
%

roadLength = 5;

flag2 = true;
while flag2 == true
    
    flag3 = true;
    while flag3 == true
        title(sprintf('Player %d Select Road Starting Point', loop5));
        
        [xStart, yStart, rStart, cStart] = closestClick(xNumberMap, yNumberMap);
        
        
        if canBuildRoad(rStart, cStart) == loop5 || canBuildRoad(rStart, cStart) == 3 %strcmp(matrixMap(rStart, cStart), sprintf('%dS', loop5))
            
            flag3 = false;
            
        else
            
            waitfor(msgbox(sprintf('Invalid start point!\nRoads must start at settlements, cities, or other roads.\nTry again.')));
            
        end
    end
            
    title(sprintf('Player %d Select Road Ending Point', loop5));
    
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
            
            canBuildSettlement(rEnd, cEnd) = loop5;
        end
        
        if strcmp(matrixMap{rEnd, cEnd}, sprintf('%dS', oppositeTeam)) || strcmp(matrixMap{rEnd, cEnd}, sprintf('%dC', oppositeTeam))
            
            % do nothing
            
        elseif ~isnan(canBuildRoad(rEnd, cEnd))
            
            canBuildRoad(rEnd, cEnd) = 3;
            
        else
            
            canBuildRoad(rEnd, cEnd) = loop5;
            
        end
        
        plot(xRoad, yRoad, color, 'LineWidth', 3);
        
        % Cover road start with existing buildings(preserve layers)
        
        switch matrixMap{rStart, cStart}
            
            case sprintf('%dS', loop5)
                
                plotSettlement(xStart, yStart, color);
                
            case sprintf('%dC', loop5)
                
                % plot city - to be added later                
        end
        
        % Cover road end with existing buildings(preserve layers)
        
        switch matrixMap{rEnd, cEnd}
            
            case sprintf('%dS', loop5)
                
                plotSettlement(xEnd, yEnd, color);
                
            case sprintf('%dC', loop5)
                
                % plot city - to be added later
                
            case sprintf('%dS', oppositeTeam)
                
                plotSettlement(xEnd, yEnd, color);
                
            case sprintf('%dC', oppositeTeam)
                
                % plot enemy city - to be added later                
        end
        
        flag2 = false;
        
    else
        waitfor(msgbox('Incorrect road length! Try again.'));
    end
end