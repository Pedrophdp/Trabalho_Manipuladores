function CD = cinematicadir(obj,q,ponto)
%Calcula a cinematica direta do robô em uma configuração q
%ponto = 'topo' pontos nos topos dos cilindros
%ponto = 'centro' pontos nos centros dos cilindros
%ponto = 'efetuador' o único ponto no efetuador

CD = zeros(4,4,length(obj.info_links.d)+1);
CD(:,:,1)=obj.mth*obj.mth_baserobo;
for i = 1: length(obj.info_links.d)
    d=obj.info_links.d(i);
    a=obj.info_links.a(i);
    alfa=obj.info_links.alfa(i);
    theta=obj.info_links.theta(i);
    tipo=obj.info_links.tipo(i);
    if tipo==0
    %Junta rotativa
     CD(:,:,i+1)=CD(:,:,i)*Robo.rot('z',q(i))*Robo.desl([0;0;d])*Robo.rot('x',alfa)*Robo.desl([a;0;0]);
    end
    
    if tipo==1
    %Junta prismática
     CD(:,:,i+1)=CD(:,:,i)*Robo.rot('z',theta)*Robo.desl([0;0;q(i)])*Robo.rot('x',alfa)*Robo.desl([a;0;0]);
    end
    
end


if strcmp(ponto,'centro')
    CDt=CD;
    for i = 1: length(obj.info_links.d)
     CD(1:3,4,i)  = 0.5*(CDt(1:3,4,i+1)+CDt(1:3,4,i));
    end
    CD(:,:,end)=[];
end    


if strcmp(ponto,'efetuador')
    CD = CD(:,:,end)*obj.efetuador.mth_fim_ef*Robo.desl([0;0;obj.efetuador.h_link+obj.efetuador.h_ponta]);
end

end