function [ponto_novo,J] = cinematicadirgen(obj,q,qref,ponto)
%Fun��o de cinem�tica direta para um ponto generico
%Esse ponto, que est� "grudado" no rob�, � identificado pelo ponto 3D
%p e a configura��o q_ref, que significa que na configura��o q_ref do 
%rob� o ponto desejado ser� p. Ent�o, calcula-se a cinem�tica direta desse
%ponto para uma outra configura��o gen�rica q. Retorna tamb�m a jacobiana
%da posi��o naquele ponto 
%Note que Rb.cinematicadirgen(q,q,ponto) retorna ponto_novo=ponto
%Se o ponto n�o estiver no objeto retorna ponto_novo=[];    


%Guarda a configura��o atual
qant=obj.q;

%Primeiro descobre se o ponto est� no objeto

%PROCURA EM CADA UM DOS LINKS


obj.config(qref);
i=1;
tipo='';
while isempty(tipo) && i<=length(obj.obj_links)
    [~,Dist] = obj.obj_links(i).calcdistponto(ponto);
    if Dist<=0.01
        ok = 1;
        ind = i;
        tipo = 'link';
    end
    i=i+1;
end

%V� SE EST� NA BASE
if isempty(tipo)
  [~,Dist] = obj.obj_base.calcdistponto(ponto);  
  if Dist<=0.01
      tipo = 'base';
  end
end

%V� SE EST� NO LINK DO EFETUADOR
if isempty(tipo)
    [~,Dist] = obj.obj_link_efetuador.calcdistponto(ponto);
    if Dist<=0.01
        tipo = 'link';
        ind = length(obj.obj_links);
    end
end

%V� SE EST� NO EFETUADOR
if isempty(tipo)
    [~,Dist] = obj.obj_efetuador.calcdistponto(ponto);
    if Dist<=0.01
        tipo = 'link';
        ind = length(obj.obj_links);
    end
end

%Volta o rob� para sua configura��o anterior
obj.config(qant);

%Calcula o novo ponto
if isempty(tipo)
 %O ponto n�o est� no rob� 
 ponto_novo=[];
 J=[];
else
  
    if strcmp(tipo,'link')
     %Est� no link, ou no link do efetuador ou no efetuador
     CDref = obj.cinematicadir(qref,'topo');
     [J_geoh,CD] = obj.jacobianageo(q,'topo');
     
     L=CD(:,:,ind+1)/CDref(:,:,ind+1);
     ponto_novo = L*[ponto;1];
     ponto_novo = ponto_novo(1:3);
     J = J_geoh(1:3,:,ind+1) - Robo.matrizprodv(ponto_novo-CD(1:3,4,ind+1))*J_geoh(4:6,:,ind+1);
    end

    if strcmp(tipo,'base')
      %Est� na base
      ponto_novo = ponto;
      J = zeros(3,length(obj.q));        
    end
    

end

 
end