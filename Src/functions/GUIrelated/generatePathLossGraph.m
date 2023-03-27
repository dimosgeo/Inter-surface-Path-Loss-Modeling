function [distance_array,pathloss_array]=generatePathLossGraph(environment,l,rays,label)
    Tx=environment.Sender;
    Rx=environment.Receiver;
    P1=environment.Plane1;
    P2=environment.Plane2;
   
    tx=Tx.Position;
    rx=Rx.Position;
    p1=P1.Position;
    p2=P2.Position;

    s=(0:0.25:40);
    txt='Busy, "Start Ray Tracing"';
    label.Text=txt;
    pathloss_array=zeros(1,length(s));
    distance_array=zeros(1,length(s));
    ls=length(s);
    for k=1:ls
        P1.Position=p1+[0,s(k)/2,0];
        P2.Position=p2+[0,-s(k)/2,0];
        Tx.Position=tx+[0,s(k)/2,0];
        Rx.Position=rx+[0,-s(k)/2,0];

        P1.fill_plane();
        P2.fill_plane();
        place_mirrors(P1,P2);
        P1.set_mirrors(Tx);
        P2.set_mirrors(Rx);
        pathloss_db=get_pl(Tx,Rx,P1,P2,l,rays,environment);
        pathloss_array(k)=pathloss_db;
        distance_array(k)=norm(P2.Position-P1.Position);
        label.Text=[txt,', ',num2str(round(100*k/ls,2)),'%'];
        pause(0);
    end
    csvwrite('output_files/distance',distance_array);
    csvwrite('output_files/pathloss',pathloss_array);
end