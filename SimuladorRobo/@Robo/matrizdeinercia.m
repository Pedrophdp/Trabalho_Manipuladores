function In=matrizdeinercia(obj,q)
%Calcula a matriz de inercia do rob� na configura��o
%q com rela��o ao eixo de refer�ncia

n=length(obj.obj_links);
In=zeros(n,n);
[Jg,~] = obj.jacobianageo(q,'centro');


for i = 1: n
 D=Jg(4:6,:,i)'*obj.obj_links(i).matrizdeinercia()*Jg(4:6,:,i);
 H=D+obj.obj_links(i).massa()*Jg(1:3,:,i)'*Jg(1:3,:,i);
 In = In+H;
end



end