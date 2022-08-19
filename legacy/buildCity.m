function [matrixMap, victoryPoints, resourceScoreboard] = buildCity(victoryPoints, matrixMap, xNumberMap, yNumberMap, teamNumber, color, resourceScoreboard) %<SM:PDF> %<SM:PDF_PARAM> %<SM:PDF_RETURN>

% Generates a settlement on the coordinates specified by a user click,
% while checking for incorrect inputs
% 
% Niall McKinnon, s05

flag = true;
while flag == true %<SM:WHILE>
    
    title(sprintf('Player %d Place City', teamNumber)); %<SM:STRING>
    [xPoint, yPoint, rPoint, cPoint] = closestClick(xNumberMap, yNumberMap);
    
    if strcmp(matrixMap{rPoint, cPoint}, sprintf('%dS', teamNumber))
        
        plotCity(xPoint, yPoint, color);
        
        matrixMap{rPoint, cPoint} = sprintf('%dC', teamNumber); %<SM:STRING>
        
        victoryPoints(1, teamNumber) = victoryPoints(1, teamNumber) + 1;
        
        resourceScoreboard(teamNumber, 1) = resourceScoreboard(teamNumber, 1) - 2;
        resourceScoreboard(teamNumber, 4) = resourceScoreboard(teamNumber, 4) - 3;
        
        flag = false;
        
    else
        
        waitfor(msgbox('Invalid spot! Pick a diffent spot!'));  %<SM:NEWFUN>
    end
end