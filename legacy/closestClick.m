 function [x, y, row, column] = closestClick(xMatrix, yMatrix)

% USE AS: [x, y, row, column] = closestClick(xMatrix, yMatrix)
% Returns the closest data point to the user click, as well as the
%   coordinates within the matrix
% Niall McKinnon, s05

[xClick, yClick] = ginput(1);
distances = sqrt((xClick-xMatrix).^2 + (yClick-yMatrix).^2);
minDistance = min(min(distances));

[row, column] = find(distances == minDistance);

x = xMatrix(row, column);
y = yMatrix(row, column);