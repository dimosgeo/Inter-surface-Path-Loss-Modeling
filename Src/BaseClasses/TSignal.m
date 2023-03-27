classdef (ConstructOnLoad=true) TSignal
    % A sinusoidal signal fed at the antenna. 
    % Io (Amperes)
    % F Hz
    % P Watt
    properties
        F=10000000;  
        P=10;  
    end
    
    methods
        function obj=TSignal
        end
        
        function current=Io(obj, Rtotal)
            current=sqrt(obj.P/Rtotal);
        end
    end
    
end

