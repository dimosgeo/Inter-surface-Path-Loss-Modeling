classdef Mirror < handle
    properties
        Position;
        Row;
        Column;
        Picked=0;
        Space;
        Opposite_Mirror;
        V_horizontal;
        V_vertical;
        V_normal;
    end
    
    methods
        function obj = Mirror(position,r,c,space) %Initialize Mirror
            obj.Position=position;
            obj.Row=r;
            obj.Column=c;
            obj.Space=space;
        end
        
        function set_mirror_in_place(obj,TRx)
            point=obj.Position;
            mirror_plate=obj.Opposite_Mirror.Position;

            %Vector Tx-Point
            v1=TRx.Position-point;
            v1=v1/norm(v1);

            %Vector Rx-Point
            v2=mirror_plate-point;
            v2=v2/norm(v2);

            look_at_v=v1+v2;
            look_at_v=look_at_v/norm(look_at_v);
            obj.V_normal=look_at_v;

            %Vertical helpful vector 
            temp_vert=[0,0,1];

            %Horizontal vector
            horiz_v=cross(look_at_v,temp_vert);
            horiz_v=horiz_v/norm(horiz_v);
            obj.V_horizontal=horiz_v;

            %Vertical vector
            vert_v=cross(horiz_v,look_at_v);
            vert_v=vert_v/norm(vert_v);
            obj.V_vertical=vert_v;    
        end

        function [X,Y,Z]=getQuadrilaterals(obj)
            vert_v_matrix=[1;-1;-1;1;1]*obj.V_vertical;            
            horiz_v_matrix=[1;1;-1;-1;1]*obj.V_horizontal;
            points=[1;1;1;1;1]*obj.Position;

            mirror_plate=(points+(obj.Space/2)*(vert_v_matrix+horiz_v_matrix))';
            X=mirror_plate(1,:);
            Y=mirror_plate(2,:);
            Z=mirror_plate(3,:);
        end
    end
end

