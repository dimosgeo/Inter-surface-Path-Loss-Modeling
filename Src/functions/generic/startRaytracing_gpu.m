function raysArray=startRaytracing_gpu(Tx,Rx,P1,P2,rays,showTRxLines,showMirrorsLines)
    Txpos=Tx.Position;
    Rxpos=Rx.Position;
    q=P1.Quads;
    s=P1.Size/q;
    vecs=[];
    all_quads=[];
    
    xs=linspace(-s/2+s/(2*rays),s/2-s/(2*rays),rays);
    zs=linspace(-s/2+s/(2*rays),s/2-s/(2*rays),rays);
    
    txpos=reshape(Txpos,1,1,3);
    for r=1:q
        for c=1:q
            mirror1=P1.Mirrors{r,c};
            [X,Y,Z]=mirror1.getQuadrilaterals();
            quads=[X',Y',Z'];
            quads=quads(1:4,:);
            quads=reshape(quads',1,[]);
            all_quads=[all_quads,quads];
            
            v_hor=mirror1.V_horizontal;
            v_vert=mirror1.V_vertical;
            x_s=repmat(reshape(v_hor,1,1,3),rays,rays).*xs;
            z_s=repmat(reshape(v_vert,1,1,3),rays,rays).*zs';
            pos=reshape(mirror1.Position,1,1,3);
            hitPoint=pos+x_s+z_s;      
            vec=hitPoint-txpos;
            vec=reshape(vec,[],size(hitPoint,3),1);
            vecs=[vecs;vec];

            mirror2=P2.Mirrors{r,c};
            [X,Y,Z]=mirror2.getQuadrilaterals();
            quads=[X',Y',Z'];
            quads=quads(1:4,:);
            quads=reshape(quads',1,[]);
            all_quads=[all_quads,quads];
        end
    end
    all_quads=reshape(all_quads,[],q*q*8)';
    As=all_quads(1:4:end,:);
    Bs=all_quads(2:4:end,:);
    Cs=all_quads(3:4:end,:);
    Ds=all_quads(4:4:end,:);

    vecs=vecs./sqrt(sum(vecs.^2,2));

    Txpos=repmat(Txpos,size(vecs,1),1);
    
    idxs=(1:size(vecs,1))';
    
    raysArray=cell(1,size(vecs,1));
    for i=1:size(vecs,1)
        raysArray{i}=RayPath();
    end
    
    raysArray=startRaytrace(raysArray,idxs,gpuArray(Txpos),gpuArray(vecs),gpuArray(As),gpuArray(Bs),gpuArray(Cs),gpuArray(Ds),1,3,Rxpos);

    if(showMirrorsLines)
        for i=1:length(raysArray)
            ray=raysArray{i};
            if(length(ray.Rays)==3)
                ray1=ray.Rays{1};
                ray2=ray.Rays{2};
                ray3=ray.Rays{3};
                if(showTRxLines)
                    plotRay(ray1);
                    plotRay(ray3);
                end
                plotRay(ray2);
            end
        end
    end
end

function raysArray=startRaytrace(raysArray,idxs,startPosition,vecs,As,Bs,Cs,Ds,currentBounce,maxBounce,endPosition)
    if(currentBounce>maxBounce)
        return
    end
    
    [inter_x,inter_y,inter_z,t,bx,by,bz]=arrayfun(@rayPlaneIntersection_gpu,startPosition(:,1),startPosition(:,2),startPosition(:,3),...
                    vecs(:,1),vecs(:,2),vecs(:,3),...
                    As(:,1)',As(:,2)',As(:,3)',...
                    Bs(:,1)',Bs(:,2)',Bs(:,3)',...
                    Cs(:,1)',Cs(:,2)',Cs(:,3)', ...
                    Ds(:,1)',Ds(:,2)',Ds(:,3)');  
    
    startPosition=gather(startPosition); 
    vecs=gather(vecs);
    t=gather(t);
    if(currentBounce==maxBounce)
        for i=1:size(vecs,1)
            t_rx=rayRxIntersection(startPosition(i,:),vecs(i,:),endPosition);
            if(t_rx==Inf)
                continue
            end
            d = min(t(i,:));
            if(d<t_rx)
                continue;
            end
            
            raysArray{idxs(i)}.Rays{end+1}=Ray(startPosition(i,:),endPosition,t_rx);
        end
        return
    else
        inter_x=gather(inter_x);
        inter_y=gather(inter_y);
        inter_z=gather(inter_z);
        bx=gather(bx);
        by=gather(by);
        bz=gather(bz);

        new_idxs=[];
        newVectors=[];
        newPositions=[];

        for i=1:size(vecs,1)
            row_flags=sum(t(i,:)~=Inf);
            if(row_flags==0)
                continue;
            end
            [d,c] = min(t(i,:));

            raysArray{idxs(i)}.Rays{end+1}=Ray(startPosition(i,:),[inter_x(i,c),inter_y(i,c),inter_z(i,c)],d);

            new_idxs=[new_idxs,idxs(i)];

            newVectors=[newVectors;bx(i,c),by(i,c),bz(i,c)];
            newPositions=[newPositions;inter_x(i,c),inter_y(i,c),inter_z(i,c)];
        end
    end

    raysArray=startRaytrace(raysArray,new_idxs,gpuArray(newPositions),gpuArray(newVectors),As,Bs,Cs,Ds,currentBounce+1,maxBounce,endPosition);
end

function plotRay(ray)
    s=ray.StartPosition;
    e=ray.HitPosition;
    plot3([s(1),e(1)],[s(2),e(2)],[s(3),e(3)],'Color','#EDB120');
end

function [inter_x,inter_y,inter_z,t,bx,by,bz] = rayPlaneIntersection_gpu ( ox,oy,oz,...
                                                                                dx,dy,dz,...
                                                                                p0x,p0y,p0z,...
                                                                                p1x,p1y,p1z,...
                                                                                p2x,p2y,p2z,...
                                                                                p3x,p3y,p3z)   
    epsilon=0.00001;

    % e1 = p1-p0;
    e1x = p1x-p0x;
    e1y = p1y-p0y;
    e1z = p1z-p0z;
    % e2 = p2-p0;
    e2x = p2x-p0x;
    e2y = p2y-p0y;
    e2z = p2z-p0z;
    
    % p = (p0+p2)/2;
    px=(p0x+p2x)/2;
    py=(p0y+p2y)/2;
    pz=(p0z+p2z)/2;

    % Normal
    [nx,ny,nz] = cross_product(e1x,e1y,e1z,e2x,e2y,e2z);
    [nx,ny,nz] = normalize_vector(nx,ny,nz);

    % denominator = dot(n,r);
    denominator=nx*dx+ny*dy+nz*dz;

    %Stop if parallel
    if(abs(denominator)<epsilon)
        t=Inf;
        inter_x=ox;
        inter_y=oy;
        inter_z=oz;
        bx=dx;
        by=dy;
        bz=dz;
        return;
    end 

    % po = o-p
    opx=ox-px;
    opy=oy-py;
    opz=oz-pz;
    
    % numerator = dot(n,op)
    numerator=nx*opx+ny*opy+nz*opz;
    
    t=-numerator/denominator;
    
    % inter = o+t.*d
    inter_x=ox+t*dx;
    inter_y=oy+t*dy;
    inter_z=oz+t*dz;

    area1=norm_product(e1x,e1y,e1z);
    area1=area1*area1;

    area2=sum_areas(    p0x,p0y,p0z,...
                        p1x,p1y,p1z,...
                        p2x,p2y,p2z,...
                        p3x,p3y,p3z,...
                        inter_x,inter_y,inter_z);
    %Stop if outside
    if(area2>area1+epsilon)
        t=Inf;
        inter_x=ox;
        inter_y=oy;
        inter_z=oz;
        bx=dx;
        by=dy;
        bz=dz;
        return;
    end

    %If hits same position
    if(t<epsilon)
        t=Inf;
        inter_x=ox;
        inter_y=oy;
        inter_z=oz;
        bx=dx;
        by=dy;
        bz=dz;
        return;        
    end
    
    % b = d-2*dot(d,n)*n
    bx=dx-2*denominator*nx;
    by=dy-2*denominator*ny;
    bz=dz-2*denominator*nz; 
    
    nb=norm_product(bx,by,bz);
    bx=bx/nb;
    by=by/nb;
    bz=bz/nb;
end

function k=sum_areas(   p0x,p0y,p0z,...
                        p1x,p1y,p1z,...
                        p2x,p2y,p2z,...
                        p3x,p3y,p3z,...
                        px,py,pz)
    v0x=p0x-px;
    v0y=p0y-py;
    v0z=p0z-pz;

    v1x=p1x-px;
    v1y=p1y-py;
    v1z=p1z-pz;

    v2x=p2x-px;
    v2y=p2y-py;
    v2z=p2z-pz;

    v3x=p3x-px;
    v3y=p3y-py;
    v3z=p3z-pz;

    [k0x,k0y,k0z]=cross_product(v0x,v0y,v0z,v1x,v1y,v1z);
    [k1x,k1y,k1z]=cross_product(v1x,v1y,v1z,v2x,v2y,v2z);
    [k2x,k2y,k2z]=cross_product(v2x,v2y,v2z,v3x,v3y,v3z);
    [k3x,k3y,k3z]=cross_product(v3x,v3y,v3z,v0x,v0y,v0z);

    k0=norm_product(k0x,k0y,k0z);
    k1=norm_product(k1x,k1y,k1z);
    k2=norm_product(k2x,k2y,k2z);
    k3=norm_product(k3x,k3y,k3z);
    
    k=(k0+k1+k2+k3)/2;
end

function n=norm_product(u1,u2,u3)
    n=sqrt(u1*u1+u2*u2+u3*u3);
end

function [w1,w2,w3] = cross_product(u1,u2,u3,v1,v2,v3)
    w1 = u2*v3 - u3*v2;
    w2 = u3*v1 - u1*v3;
    w3 = u1*v2 - u2*v1;
end

function [w1,w2,w3] = normalize_vector(u1,u2,u3)
    n=sqrt(u1*u1+u2*u2+u3*u3);
    w1=u1/n;
    w2=u2/n;
    w3=u3/n;
end

function t = rayRxIntersection (origin,direction,rx)
    v=rx-origin;

    costheta=dot(direction,v)/(norm(direction)*norm(v));
    d=norm(v)*sqrt(complex(1-costheta*costheta));
    if(d>0.1)
        t=Inf;
        return
    end

    t=norm(v);
end