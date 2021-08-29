function [D,pmp1,pmp2] = calcdistanciarap(obj,obj2,dtol,pinit)
%Calcula  a distância entre o robô e um objeto
%Tenta calcular uma distância rápida (distância entre esferas)
%antes de calcular a distância mais precisa
%tol é a tolerância com relação à distância das esferas
%(se for menor que ela, tem que calcular uma distância mais precisa)


   if nargin==2
    dtol=0.1;
    pinit=rand(3,1);  
   end      
   if nargin==3
    pinit=rand(3,1);  
   end           
           
%Distância entre a esfera global do robô e a esfera do objeto
[cR,rR] = obj.esfera();
[cO,rO] = obj2.esfera();
[D,pmp1,pmp2] = calcv(cR,cO,rR,rO);
ok = (D>=dtol);

if ~ok
%Distancia é pequena...
%calcula a distância entre as esferas dos objetos do robô e a esfera do objeto  

    n=length(obj.obj_links);

    i=1;
    ok=0;
    while i<=n && ~ok
        [cO,rO] = obj.obj_links(i).esfera();
        [D,pmp1,pmp2] = calcv(cR,cO,rR,rO);
        ok = (D>=dtol);
        i=i+1;
    end

    if ~ok
        [cO,rO] = obj.obj_base.esfera();
        [D,pmp1,pmp2] = calcv(cR,cO,rR,rO);
        ok = (D>=dtol);
    end
    if ~ok
        [cO,rO] = obj.obj_efetuador.esfera();
        [D,pmp1,pmp2] = calcv(cR,cO,rR,rO);
        ok = (D>=dtol);
    end
    if ~ok
        [cO,rO] = obj.obj_link_efetuador.esfera();
        [D,pmp1,pmp2] = calcv(cR,cO,rR,rO);
        ok = (D>=dtol);
    end
    
    if ~ok
    %Distancia é pequena...        
    %Tem que calcular a distância precisa...    
      [D,pmp1,pmp2] = obj.calcdistancia(obj2,pinit);  
    end
end

end

function [D,pmp1,pmp2] = calcv(cR,cO,rR,rO)
    D = max(norm(cR-cO)-rR-rO,0);
    delta = cR-cO;
    delta=delta/(norm(delta)+0.001);
    pmp1 = cR-delta*rR;
    pmp2 = cO+delta*rO;
end