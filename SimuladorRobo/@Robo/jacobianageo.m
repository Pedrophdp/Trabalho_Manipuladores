function [Jg,CD] = jacobianageo(obj,q,ponto)
%Calcula a matriz jacobiana geometrica nos centros dos eixos
%em uma configuração q. Retorna também as matrizes de cinemática
%direta
%ponto = 'topo' pontos nos topos dos cilindros
%ponto = 'centro' pontos nos centros dos cilindros
%ponto = 'efetuador' o único ponto no efetuador

n=length(q);
CD = obj.cinematicadir(q,'topo');
Jg = zeros(6,n,n+1);


for j = 2: n+1
    for i = 1: j-1
        z=CD(1:3,3,i);
        p=CD(1:3,4,j);
        
        if obj.info_links.tipo(i)==0
        %É uma junta rotativa
         Jg(:,i,j) = [cross(z,p-CD(1:3,4,i));z];
        end 
        
                
        if obj.info_links.tipo(i)==1
        %É uma junta prismática
         Jg(:,i,j) = [z;zeros(3,1)];
        end 
         
    end
end

CDt=CD;
Jgt=Jg;
    
if strcmp(ponto,'centro')
    for j = 1: n
        CD(1:3,4,j) = 0.5*(CDt(1:3,4,j)+CDt(1:3,4,j+1));
        Jg(1:3,:,j) = 0.5*(Jgt(1:3,:,j)+Jgt(1:3,:,j+1));
        Jg(4:6,:,j) = Jgt(4:6,:,j+1);
    end
CD(:,:,end)=[];
Jg(:,:,end)=[];
end




if strcmp(ponto,'efetuador') 
    Jg=[];
    L=obj.efetuador.mth_fim_ef*Robo.desl([0;0;obj.efetuador.h_link+obj.efetuador.h_ponta]);
    r = CD(1:3,1:3,end)*L(1:3,end);
    Jg(1:3,:) = Jgt(1:3,:,end)-Robo.matrizprodv(r)*Jgt(4:6,:,end);
    Jg(4:6,:) = Jgt(4:6,:,end);
    CD = CD(:,:,end)*L;
end




end