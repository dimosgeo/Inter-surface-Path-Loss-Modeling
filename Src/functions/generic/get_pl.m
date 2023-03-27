function pl = get_pl(Tx,Rx,P1,P2,l,rays,environment)
    pl=pl_old(Tx,Rx,P1,P2,l,rays,environment);
end

function pl=pl_old(Tx,Rx,P1,P2,l,rays,environment)
    power1=0;
    power2=0;
    raysArray=startRaytracing_gpu(Tx,Rx,P1,P2,rays,0,0);
    for i=1:length(raysArray)
        ray=raysArray{i};
        if(length(ray.Rays)==3)
            ray1=ray.Rays{1};
            v1=ray1.HitPosition-ray1.StartPosition;
            v2=[v1(1),v1(2),0];
            angle=deg2rad((acosd(dot(v1,v2)/(norm(v1)*norm(v2)))));
            powerc=Tx.Antenna.PowerAtPoint(ray1.D,0,pi/2-angle,environment);
            power1=power1+powerc;
            ray2=ray.Rays{2};
            power2=power2+(powerc*l*l)/((4*pi*ray2.D)^2);            
        end
    end
    pl=10*log10(power1/power2);
end