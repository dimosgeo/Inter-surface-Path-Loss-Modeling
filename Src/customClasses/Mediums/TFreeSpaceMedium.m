classdef TFreeSpaceMedium < TMedium
   
   properties (Constant)
        GUIName='Free Space'; %EVERY MEDIUM SHOULD DEFINE a GUINAME         
   end
    
   methods
        function obj=TFreeSpaceMedium %CONSTRUCTOR MUST NOT TAKE ARGUMENTS!
        end
        
        function L=Loss(obj, point, Environment)
            distance=point(1);
            frequency=Environment.Sender.Signal.F;
            L=(4*pi*distance*frequency/(obj.c))^2;
        end
   end
    
end

