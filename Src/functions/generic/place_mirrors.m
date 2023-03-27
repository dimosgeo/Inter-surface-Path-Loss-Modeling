function place_mirrors(P1,P2)
    q=P1.Quads;
    way1(P1,P2,q);
end

function way1(P1,P2,q)
    for c=1:q
        for r=1:q
            d_min=Inf;
            current_M=0;
            opposite_M=0;
            for k=1:q
                for l=1:q
                    if P1.Mirrors{k,l}.Picked==1
                        continue
                    end
                    for k2=1:q
                        for l2=1:q
                            if P2.Mirrors{k2,l2}.Picked==1
                                continue
                            end
                            d=norm(P1.Mirrors{k,l}.Position-P2.Mirrors{k2,l2}.Position);
                            if d<d_min
                                d_min=d;
                                current_M=P1.Mirrors{k,l};
                                opposite_M=P2.Mirrors{k2,l2};
                            end
                        end
                    end                 
                end
            end
            current_M.Picked=1;
            current_M.Opposite_Mirror=opposite_M;

            opposite_M.Picked=1;
            opposite_M.Opposite_Mirror=current_M;   
        end
    end
end

function way2(P1,P2,q)
    for c=1:q
        for r=1:q
            P1.Mirrors{c,r}.Opposite_Mirror=P2.Mirrors{c,r};
            P2.Mirrors{c,r}.Opposite_Mirror=P1.Mirrors{c,r};
        end
    end
end
