classdef Ray
    properties
        StartPosition;
        HitPosition;
        D;
    end
    
    methods
        function obj = Ray(StartPosition,HitPosition,D)
            obj.StartPosition=StartPosition;
            obj.HitPosition=HitPosition;
            obj.D=D;
        end
    end
end

