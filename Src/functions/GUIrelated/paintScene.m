function paintScene(environment,showLines,showTRx,showMirrors,showVectors,rays)
    Tx=environment.Sender;
    Rx=environment.Receiver;
    P1=environment.Plane1;
    P2=environment.Plane2;

    P1.fill_plane();
    P2.fill_plane();

    place_mirrors(P1,P2);

    P1.set_mirrors(Tx);
    P2.set_mirrors(Rx);

    q=P1.Quads;
    figure;
    hold on;

    for r=1:q
        for c=1:q
            mirror1=P1.Mirrors{r,c};
            mirror2=P2.Mirrors{r,c};
            if(showMirrors)        
                text(P1.Position(1),P1.Position(2),P1.Position(3)+(P1.Size/2)+1,'Surface1','FontSize', 14);
                [X,Y,Z]=mirror1.getQuadrilaterals();
                fill3(X,Y,Z,[0.7 0.8 1]);

                text(P2.Position(1),P2.Position(2),P2.Position(3)+(P2.Size/2)+1,'Surface2','FontSize', 14);
                [X,Y,Z]=mirror2.getQuadrilaterals();
                fill3(X,Y,Z,[0.7 0.8 1]);
            end
            if(showTRx)
                scatter3(Tx.Position(1),Tx.Position(2),Tx.Position(3),100,'filled','g');
                text(Tx.Position(1),Tx.Position(2),Tx.Position(3)+1,'Tx','FontSize', 14);
                
                scatter3(Rx.Position(1),Rx.Position(2),Rx.Position(3),100,'filled','r');
                text(Rx.Position(1),Rx.Position(2),Rx.Position(3)+1,'Rx','FontSize', 14);
            end
            if(showVectors && showMirrors)
                quiver3(mirror1.Position(1),mirror1.Position(2),mirror1.Position(3),mirror1.V_normal(1),mirror1.V_normal(2),mirror1.V_normal(3),norm(mirror1.V_normal),'g');
                quiver3(mirror1.Position(1),mirror1.Position(2),mirror1.Position(3),mirror1.V_horizontal(1),mirror1.V_horizontal(2),mirror1.V_horizontal(3),norm(mirror1.V_horizontal),'g');
                quiver3(mirror1.Position(1),mirror1.Position(2),mirror1.Position(3),mirror1.V_vertical(1),mirror1.V_vertical(2),mirror1.V_vertical(3),norm(mirror1.V_vertical),'g');
                
                quiver3(mirror2.Position(1),mirror2.Position(2),mirror2.Position(3),mirror2.V_normal(1),mirror2.V_normal(2),mirror2.V_normal(3),norm(mirror2.V_normal),'g');
                quiver3(mirror2.Position(1),mirror2.Position(2),mirror2.Position(3),mirror2.V_horizontal(1),mirror2.V_horizontal(2),mirror2.V_horizontal(3),norm(mirror2.V_horizontal),'g');
                quiver3(mirror2.Position(1),mirror2.Position(2),mirror2.Position(3),mirror2.V_vertical(1),mirror2.V_vertical(2),mirror2.V_vertical(3),norm(mirror2.V_vertical),'g');
            end
        end
    end
    if(showLines && showMirrors)
        if(showTRx)
            startRaytracing_gpu(Tx,Rx,P1,P2,rays,1,1);
        else
            startRaytracing_gpu(Tx,Rx,P1,P2,rays,0,1);
        end
    end
    axis vis3d
    xlabel('x')
    ylabel('y')
    zlabel('z')
    axis equal
    light('Position',Tx.Position,'Style','local','Color','#ccd7ff');
    light('Position',Rx.Position,'Style','local','Color','#ccd7ff');
    material metal;
    hold off;
    savefig('output_files/schematic.fig'); 
end