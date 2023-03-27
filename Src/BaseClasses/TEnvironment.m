classdef (ConstructOnLoad=true) TEnvironment
    %Defines a lab environment comprised of 
        %One TNode Sender
        %One TNode Receiver
        %One Plane Plane1
        %One Plane Plane2
        %One TMedium Medium
    properties 
        Sender;
        Receiver;
        Plane1;
        Plane2;
        Medium;
    end
    
    methods
        function obj=TEnvironment %SHOULD NOT TAKE ARGUMENTS
        end
    end
end




