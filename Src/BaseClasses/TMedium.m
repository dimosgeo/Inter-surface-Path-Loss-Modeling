classdef (ConstructOnLoad=true) TMedium   
   % Base class to be inherited by any custom Medium 

   properties  % Standard EM medium properties (homogenous) 
    	m=1.2566e-006;     % the standard values for void space
	    e=8.8419e-012;
   end
   
   methods  
       function lightspeed=c(obj)
           lightspeed=1/sqrt(obj.m*obj.e);
       end
   end
   
   methods (Abstract)
        L=Loss(obj, point, Environment);  %defines the Loss at [r,f,th]
   end 
    
end

