classdef TMeasurement   
    % Defines a measurement that is to be visualized by the paintMeasurement function 
    % Interface to be inherited by any custom measurement impementation.
    properties
        Description='';  % A description text - user notes..
        W=10;            % plane Y width
        D=10;            % plane X length
        Points;          % {1}-> point , {2} {3} line points, {4} plane center point
        f=0;             % plane lift
        th=0;            % plane tilt        
    end
    
    methods (Abstract)   %MUST CHECK FOR PROPER INPUTS AND ACT ACCORDINGLY                     
        paint1D(obj, environment);  % a single point
        paint2D(obj, environment); % a cell with two points defining a line
        paint3D(obj, environment); % a plane center point, plane tilt, plane lift 
    end
    
end



