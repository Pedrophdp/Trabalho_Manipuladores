function [pmp_obj,Dist] = calcdistponto(obj,p)
%Calcula a dist�ncia com rela��o a um ponto (rob�)

 %N�mero de dist�ncias a serem calculadas
 %Pega todos os links mais a base e efetuador
 nl=length(obj.obj_links);
 
 pmp_temp =zeros(3,nl+3);
 D_temp = zeros(1,nl+3);
 
 %Calcula a dist�ncia para a base 
 [pmp_temp(:,1),D_temp(1)]=obj.obj_base.calcdistponto(p); 
 %Percorre todos os links
 for i = 1: nl
  [pmp_temp(:,i+1),D_temp(i+1)]=obj.obj_links(i).calcdistponto(p);   
 end
 %Calcula a dist�ncia para o efetuador
 [pmp_temp(:,nl+2),D_temp(nl+2)]=obj.obj_efetuador.calcdistponto(p); 
  %Calcula a dist�ncia para o link do efetuador
 [pmp_temp(:,nl+3),D_temp(nl+3)]=obj.obj_link_efetuador.calcdistponto(p);
 
 [Dist,ind]=min(D_temp);
 pmp_obj =  pmp_temp(:,ind);
 
end