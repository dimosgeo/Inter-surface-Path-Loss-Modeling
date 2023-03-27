classdef (ConstructOnLoad=true) TFiniteHalfDipoleAntenna < TAntenna
    % Half Wavelength dipole.
    % This implementation demonstrates generic code usage, as opposed to
    % TDlDipoleAntenna, where the code is inline and antenna specific in order to improve speed.
    % isPointInFarField, FieldAt and AntennaResistance are the only antenna-specific functions used.
    
    % Even AntennaResistance can be replaced by generic calculations on
    % fieldAt results, but the overhead would be tremendous for MATLAB.
    
    properties % Specific Properties
%       length=1;    % Dipole Legth in meters
        Rin=0;      % Circuit resistance (before the antenna)        
    end
    properties (Constant)
        GUIName='0.5 Wavelength Dipole'; %EVERY ANTENNA SHOULD DEFINE a GUINAME (see TAntenna)        
    end
    
    methods        
        function obj=TFiniteHalfDipoleAntenna   %CONSTRUCTOR MUST NOT TAKE ARGUMENTS!   
        end
        
        function Bool=isPointInFarField(obj, r, Environment)
            %Calculate prerequisites
            Medium=Environment.Medium;
            Signal=Environment.Sender.Signal;
            lamda=Medium.c/Signal.F;
            l=0.5*lamda;
            %For dipole, r > (2*l^2)/lamda
            if r>(2*l^2)/lamda
                Bool=true;
            else
                Bool=false;
            end
        end

        function [Er Ef Eth Hr Hf Hth]=fieldAt(obj, r, ~, th, Environment)
            %Calculate prerequisites
            Medium=Environment.Medium;
            Signal=Environment.Sender.Signal;
            lamda=Medium.c/Signal.F;
            Z=Medium.c*Medium.m;
            Io=Signal.Io(obj.Rin+AntennaResistance(obj, lamda, Environment));
            k=2*pi/lamda;
            
            l=0.5*lamda;
            
            %Calculate E,H at the Antenna-centric coordinate system (see documentation)
            Er=0;
            Eth=(1i*Z*Io*exp(-1i*k*r)/(2*pi*r))*((cos(0.5*k*l*cos(th))-cos(0.5*k*l))/sin(th));
            if isnan(Eth)
                Eth=0;
            end
            Ef=0;
            Hr=0;
            Hf=(1i*Io*exp(-1i*k*r)/(2*pi*r))*((cos(0.5*k*l*cos(th))-cos(0.5*k*l))/sin(th));
            if isnan(Hf)
                Hf=0;
            end
            Hth=0;            
        end   

        function Ra=AntennaResistance(obj, wavelength, Environment)           
            Medium=Environment.Medium;
            Z=Medium.c*Medium.m;
            
            Ra=73*Z/377;
        end
        
        % From here and on, everthing relies on 
        % fieldAt, AntennaResistance functions. 
        % Code is generic for every possible Antenna.
        
        
        function G=Gain(obj, r, f, th, Environment)
            %Calculate prerequisites

            Medium=Environment.Medium;
            Signal=Environment.Sender.Signal;
            lamda=Medium.c/Signal.F;
            Ra=AntennaResistance(obj, lamda, Environment);
            Io=Signal.Io(obj.Rin+Ra);
            Pin=0.5*Ra*((Io)^2);
            
            [Er Ef Eth Hr Hf Hth]=fieldAt(obj, r, f, th, Environment);
            E=[Er Eth Ef];
            H=[Hr Hth Hf];
            
            Wav=  sqrt(sum( (0.5*real(cross(E,conj(H)))).^2 ));
            U=Wav*(r^2);
            G=4*pi*U/Pin;
        end
        
        function D=Directivity(obj, r, f, th, Environment)
            [Er Ef Eth Hr Hf Hth]=fieldAt(obj, r, f, th, Environment);
            E=[Er Eth Ef];
            H=[Hr Hth Hf];
            
            Wav=  sqrt(sum( (0.5*real(cross(E,conj(H)))).^2 ));
            U=Wav*(r^2);

            Medium=Environment.Medium;
            Signal=Environment.Sender.Signal;
            lamda=Medium.c/Signal.F;
            Ra=AntennaResistance(obj, lamda, Environment);
            Io=Signal.Io(obj.Rin+Ra);
            Pin=0.5*Ra*((Io)^2);
            
            D=4*pi*U/Pin;
        end
               
        function Pp=PowerAtPoint(obj, r, f, th, Environment)
            %Calculate prerequisites
            Medium=Environment.Medium;
            Signal=Environment.Sender.Signal;
            lamda=Medium.c/Signal.F;
            Ra=AntennaResistance(obj, lamda, Environment);
            Io=Signal.Io(obj.Rin+Ra);
            Pin=0.5*Ra*((Io)^2);

            %Using Pp=Pin*G/L, L is the space loss (see TMedium)
            G=Gain(obj, r, f, th, Environment); 
            L=Medium.Loss([r f th], Environment);
            
            Pp=Pin*G/L;
        end
        
        function Pm=PowerAtMesh(obj, r, F, TH, Environment)
            %optimized for speed: some functions are inline.
            %Calculate prerequisites
            Pm=zeros(size(F));
            [I,J]=size(F);
            N=size(F,2);

            Medium=Environment.Medium;
            Signal=Environment.Sender.Signal;
            lamda=Medium.c/Signal.F;
            Ra=AntennaResistance(obj, lamda, Environment);
            Io=Signal.Io(obj.Rin+Ra);
            Pin=0.5*Ra*((Io)^2);
            
            for i=1:I
                myTemp=zeros(1,N);
                myTH=TH(i,:);
                myF=F(i,:);
                for j=1:J
                    th=myTH(j);
                    f=myF(j);
                    [Er Ef Eth Hr Hf Hth]=fieldAt(obj, r, f, th, Environment);
                    E=[Er Eth Ef];
                    H=[Hr Hth Hf];
                    Wav=  sqrt(sum( (0.5*real(cross(E,conj(H)))).^2 ));
                    U=Wav*(r^2);
                    G=4*pi*U/Pin;
                    L=Medium.Loss([r f th], Environment);
                    myTemp(j)= Pin*G/L;
                end
                Pm(i,:)=myTemp;
            end
        end      
        
        function Wr=RadialPowerDensity(obj, r, f, th, Environment)
            %Calculate prerequisites
            [Er Ef Eth Hr Hf Hth]=fieldAt(obj, r, f, th, Environment);
            E=[Er Eth Ef];
            H=[Hr Hth Hf];
            
            WavVect=0.5*real(cross(E,conj(H)));
            Wr=WavVect(1);
        end

    end
    
end

