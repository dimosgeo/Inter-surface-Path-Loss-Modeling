classdef Plane < handle
    
    properties
        Position;
        Quads;
        Size;
        Mirrors;
        Theta;
        Phi;
    end
    
    methods
        function obj=Plane()
        end
        
        function fill_plane(obj)
            q=obj.Quads;
            s=obj.Size;
            obj.Mirrors=cell(q,q);
            points_grid=zeros(q,q,3);
            x_s=linspace(-s/2,s/2,q+1);
            z_s=linspace(-s/2,s/2,q+1);
            space=(x_s(2)-x_s(1));
            x_s=x_s(1:end-1)+space/2;
            y_s=zeros(1,q);
            z_s=z_s(1:end-1)+space/2;
            
            points_grid(:,:,1) = repmat(x_s,q,1);
            points_grid(:,:,2) = repmat(y_s,q,1);
            points_grid(:,:,3) = repmat(z_s',1,q);
            rot_xyz=rotz(obj.Theta)*roty(0)*rotx(obj.Phi);
            for r=1:q
                for c=1:q
                    position=reshape(points_grid(r,c,:),1,[]);
                    position=position*rot_xyz;
                    position=position+obj.Position;
                    obj.Mirrors(r,c)={Mirror(position,r,c,space)};
                end
            end
        end
        
        function set_mirrors(obj,TRx)
            q=obj.Quads;
            for r=1:q
                for c=1:q
                    obj.Mirrors{r,c}.set_mirror_in_place(TRx);
                end
            end
        end
    end 
end

