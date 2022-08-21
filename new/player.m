classdef player
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here

    properties
        number;
        turn;
        victoryPoints;

        grain;
        lumber;
        wool;
        ore;
        brick;
        gold;
    end

    methods
        function obj = player(n)
            % initialize a new player
            obj.number = n;
            obj.turn = 1;
        end
% 
%         function outputArg = method1(obj,inputArg)
%             %METHOD1 Summary of this method goes here
%             %   Detailed explanation goes here
%             outputArg = obj.Property1 + inputArg;
%         end
    end
end