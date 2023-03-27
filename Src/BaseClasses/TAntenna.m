classdef TAntenna
    %Class interface to be inherited by any type of Antenna.
    %All coordinates refer to the Antenna-centric coordinate system (see Documentation)
    
    methods (Abstract)
        Bool=isPointInFarField(obj, r, Environment); %True if point [r,f,th] is in Fraunhofer region
        [Er Ef Eth Hr Hf Hth]=fieldAt(obj, r, f, th, Environment);          
        G=Gain(obj, r, f, th, Environment);
        D=Directivity(obj, r, f, th, Environment);                           
        Ra=AntennaResistance(obj, wavelength, Environment);         % Pt=(Ra/(Ra+Rin))*Io^2
        Pp=PowerAtPoint(obj, r, f, th, Environment);% at specific point
        Pm=PowerAtMesh(obj, r, F, TH, Environment); % for given r, and MATLAB meshes F,TH
        Wr=RadialPowerDensity(obj, r, f, th, Environment)
    end
        
end

