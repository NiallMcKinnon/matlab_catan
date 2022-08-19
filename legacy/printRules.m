function printRules()

% Displays the rules of Catan.
%
% Niall McKinnon, s05

fprintf('\nCATAN RULES:')
fprintf('\n - Settlements can be placed on intersections between tiles.');
fprintf('\n - Roads are placed on lines, between two points.');
fprintf('\n - Settlements can not be placed on adjacent corners from one another.');
fprintf('\n - Cities can be placed on existing settlements.');
fprintf('\n - Resources are collected from tiles adjacent to settlements/cities,\n   but only when the die roll equals the tile''s number');
fprintf('\n - Settlements collect one resource, and cities collect two.');
fprintf('\n - The first player to obtain ten VICTORY POINTS is the winner.');
fprintf('\n - Settlements are worth one V.P., and cities are worth 2.\n');