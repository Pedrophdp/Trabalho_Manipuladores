function [Dist,xmp_obj,xmp_obj2] =calcdistancia(obj,obj2,pinit)
%Fun��o base para calcular a dist�ncia
%pinit: "chute" inicial para o ponto no primeiro objeto

 if nargin==2
   pinit=rand(3,1);  
 end

if ~isa(obj2,'Robo')
    %Se n�o for o rob�, � uma dist�ncia entre objetos convexos
    pinit=obj2.calcdistponto(pinit);
    [Dist,xmp_obj2,xmp_obj] = obj2.calcdistancia(obj,pinit);
else
    Dist=Inf;
    
    %Dist�ncia entre os links
    i=1;
    ok=0;
    
    while (i <= length(obj2.obj_links)) && ~ok
        [Dist_t,xmp_obj_t,xmp_obj2_t] = obj.calcdistancia(obj2.obj_links(i),pinit);
        if Dist_t<Dist
            Dist=Dist_t;
            xmp_obj=xmp_obj_t;
            xmp_obj2=xmp_obj2_t;
        end
        i=i+1;
        if Dist<0.01
            %Dist�ncia 0. Termina
            ok=1;
        end
    end
    
    %Dist�ncia entre o efetuador
    if ok==0
        [Dist_t,xmp_obj_t,xmp_obj2_t] = obj.calcdistancia(obj2.obj_efetuador,pinit);
        if Dist_t<Dist
            Dist=Dist_t;
            xmp_obj=xmp_obj_t;
            xmp_obj2=xmp_obj2_t;
            
            if Dist<0.01
                %Dist�ncia 0. Termina
                ok=1;
            end
        end
    end
    
    %Dist�ncia entre a base
    if ok==0
        [Dist_t,xmp_obj_t,xmp_obj2_t] = obj.calcdistancia(obj2.obj_base,pinit);
        if Dist_t<Dist
            Dist=Dist_t;
            xmp_obj=xmp_obj_t;
            xmp_obj2=xmp_obj2_t;
        end
    end
    
    %Dist�ncia entre o linkd do efetuador
    if ok==0
        [Dist_t,xmp_obj_t,xmp_obj2_t] = obj.calcdistancia(obj2.obj_link_efetuador,pinit);
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