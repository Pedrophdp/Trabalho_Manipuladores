function [Dist,xmp_obj,xmp_obj2] =calcdistancia_base(obj,obj2,pinit)
%Função base para calcular a distância
%pinit: "chute" inicial para o ponto no primeiro objeto


 
if ~isa(obj2,'Robo')
    %Se não for o robô, é uma distância entre objetos convexos
    [Dist,xmp_obj,xmp_obj2] = distanciaconvexa(obj,obj2,pinit);
else
    %No caso dos robôs, calcula a distância entre os links, base
    % efetuador, e link do efetuador e pega a menor
    Dist=Inf;
    
    %Distância entre os links
    i=1;
    ok=0;

    while (i <= length(obj2.obj_links)) && ~ok
        [Dist_t,xmp_obj_t,xmp_obj2_t] = distanciaconvexa(obj,obj2.obj_links(i),pinit);
        if Dist_t<Dist
            Dist=Dist_t;
            xmp_obj=xmp_obj_t;
            xmp_obj2=xmp_obj2_t;
        end
        i=i+1;
        if Dist<0.01
            %Distância 0. Termina
            ok=1;
        end
    end
    
    %Distância entre o efetuador
    if ok==0
        [Dist_t,xmp_obj_t,xmp_obj2_t] = distanciaconvexa(obj,obj2.obj_efetuador,pinit);
        if Dist_t<Dist
            Dist=Dist_t;
            xmp_obj=xmp_obj_t;
            xmp_obj2=xmp_obj2_t;
            
            if Dist<0.01
                %Distância 0. Termina
                ok=1;
            end
        end
    end
    
    %Distância entre a base
    if ok==0
        [Dist_t,xmp_obj_t,xmp_obj2_t] = distanciaconvexa(obj,obj2.obj_base,pinit);
        if Dist_t<Dist
            Dist=Dist_t;
            xmp_obj=xmp_obj_t;
            xmp_obj2=xmp_obj2_t;
        end
    end
    
    %Distância entre o link do efetuador
    if ok==0
        [Dist_t,xmp_obj_t,xmp_obj2_t] = distanciaconvexa(obj,obj2.obj_link_efetuador,pinit);
        if Dist_t<Dist
            Dist=Dist_t;
            xmp_obj=xmp_obj_t;
            xmp_obj2=xmp_obj2_t;
        end
    end    
    
    if Dist<0.01
        Dist=0;
    end
    
end

end