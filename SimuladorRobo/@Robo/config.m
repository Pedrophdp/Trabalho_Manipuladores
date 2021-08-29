function [] = config(obj,q)
%Coloca o robô em uma configuração q

CD = obj.cinematicadir(q,'topo');
obj.q=q;
obj.info_links.colocaconfig(q);

if isempty(obj.obj_links)
%Cria os links
    for i = 1: size(CD,3)-1
        Li=CD(:,:,i)*Robo.desl([0;0;obj.info_links.desl(i)]);
        Lip=CD(:,:,i+1)*Robo.desl([0;0;obj.info_links.desl(i+1)]);
        [Tc,~] = Robo.framealinhado(Li,Lip,obj.info_links.altura(i),obj.info_links.tipo(i));
        obj.obj_links=[obj.obj_links Cilindro(Tc,obj.info_links.raio(i),obj.info_links.altura(i),obj.info_links.cor_links(i,:),obj.info_links.densidade(i))];        
        %Cria os objetos Eixos (Sempre cilindros)
        L=Li;
        L(1:3,4)=L(1:3,4)-1.3*obj.info_links.raio(i)*L(1:3,3);
        obj.obj_eixos=[obj.obj_eixos Cilindro(L,0.3*obj.info_links.raio(i),2.6*obj.info_links.raio(i),obj.info_links.cor_eixos(i,:),0)];
    end 
    
else
%Só atualiza    
    for i = 1: size(CD,3)-1
        Li=CD(:,:,i)*Robo.desl([0;0;obj.info_links.desl(i)]);
        Lip=CD(:,:,i+1)*Robo.desl([0;0;obj.info_links.desl(i+1)]);        
        [Tc,~] = Robo.framealinhado(Li,Lip,obj.info_links.altura(i),obj.info_links.tipo(i));
        %Só atualiza
        obj.obj_links(i).mth = Tc;
        %Só atualiza
        L=Li;
        L(1:3,4)=L(1:3,4)-1.3*obj.info_links.raio(i)*L(1:3,3);
        obj.obj_eixos(i).mth = L;
    end
    
end

Tefetuador=CD(:,:,end)*obj.efetuador.mth_fim_ef*Robo.desl([0;0;obj.efetuador.h_link]) ;
Tlinkefetuador=CD(:,:,end)*obj.efetuador.mth_fim_ef;

if isempty(obj.obj_efetuador)
    %Cria o objeto efetuador e seu link
    obj.obj_link_efetuador = Cilindro(Tlinkefetuador,obj.efetuador.r_link,obj.efetuador.h_link,obj.efetuador.cor_link,0);
    obj.obj_efetuador = Cilindro(Tefetuador,obj.efetuador.r_ponta,obj.efetuador.h_ponta,obj.efetuador.cor_ponta,0);
    d = 2*obj.efetuador.h_ponta;
    obj.obj_eixoefetuador = Eixo(Tefetuador*Robo.desl([0;0;obj.efetuador.h_ponta]),d,[]);
else
    %Só atualiza
    obj.obj_link_efetuador.mth = Tlinkefetuador;
    obj.obj_efetuador.mth = Tefetuador;
    obj.obj_eixoefetuador.mth = Tefetuador*Robo.desl([0;0;obj.efetuador.h_ponta]);
end

if isempty(obj.obj_base)
    %Cria a base
    lados = [4.5*obj.info_links.raio(1); 4.5*obj.info_links.raio(1); 1*obj.info_links.raio(1)];
    Tt=obj.mth;
    Tt(3,4)=Tt(3,4)+obj.info_links.raio(1)/2;
    obj.obj_base = Paralelepipedo(Tt,lados,obj.cor_base,0);
else
    Tt=obj.mth;
    Tt(3,4)=Tt(3,4)+obj.info_links.raio(1)/2;
    obj.obj_base.mth=Tt;
  
end


%Atualiza os objetos grudados no efetuador
for i = 1: length(obj.obj_noefetuador)
    obj.obj_noefetuador{i}.mth = obj.obj_eixoefetuador.mth*obj.mth_objefetuador{i};
end

end