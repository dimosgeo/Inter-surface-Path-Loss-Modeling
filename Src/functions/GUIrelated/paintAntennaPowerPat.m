function paintAntennaPowerPat(axes_handle2D,axes_handle3D,antenna, Environment)
    phi = (-pi):pi/30:(pi);
    theta = 0:pi/30:pi;
    
    [phi2,theta2] = meshgrid(phi,theta);
    
    %make sure the patterns are drawn as in free space medium
    environment=Environment;
    environment.Medium=TFreeSpaceMedium;
    
    R = antenna.PowerAtMesh(1, phi2, theta2, environment);
    [XX,YY,ZZ] = sph2cart(phi2,pi/2-theta2,R);   %MATLAB coordinates differ from classic! see 'doc sph2cart'.
    surf(axes_handle3D,XX,YY,ZZ, 'EdgeAlpha',0);
    colormap(axes_handle3D, winter);
    xlabel(axes_handle3D,'$X$','Interpreter','latex');
    ylabel(axes_handle3D,'$Y$','Interpreter','latex');
    zlabel(axes_handle3D,'$Z$','Interpreter','latex');            
    set(axes_handle3D,'xtick',[]) ; 
    set(axes_handle3D,'ytick',[]) ;
    set(axes_handle3D,'ztick',[]) ;
    set(axes_handle3D,'DataAspectRatio',[1 1 1]) ;
    
    phi=0;
    theta = (-pi):pi/120:(pi);
    [phi2,theta2] = meshgrid(phi,theta);
    R = antenna.PowerAtMesh(1, phi2, theta2, environment);
    [XX,~,ZZ] = sph2cart(phi2,pi/2-theta2,R);   %MATLAB coordinates differ from classic! see 'doc sph2cart'.
    plot(axes_handle2D, XX,ZZ);
    xlabel(axes_handle2D,'$X$','Interpreter','latex');
    ylabel(axes_handle2D,'$Z$','Interpreter','latex');            
    set(axes_handle2D,'xtick',[]) ; 
    set(axes_handle2D,'ytick',[]) ;
    set(axes_handle2D,'ztick',[]) ;
    set(axes_handle2D,'DataAspectRatio',[1 1 1]) ;            
end