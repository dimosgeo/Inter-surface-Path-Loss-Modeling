classdef (ConstructOnLoad=true) TNode  < handle
    % Either the Sender or the Receiver. 
    % Node includes:
    %   1. Geometrical data defining position 
    %   2. Driving Signal (null if Node is a Receiver)
    %   3. Antenna Type (class TAntenna)
    properties 
        Antenna=TFiniteHalfDipoleAntenna;
        Position=[0,0,0];
        Signal=TSignal;                  
        Height=0;     %  \
        Direction=0;  %   -> See documentation for coordinate sytem definition
        Tilt=0;       %  /    
        HorDistanceFromSender=0; %(if 0 its a Sender!)
    end
    methods       
        function obj=TNode %SHOULD NOT TAKE ARGUMENTS
        end      
    end
end