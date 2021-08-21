function V = energiapotencialgrav(obj,q)
%Calcula a energia potencial gravitacional na configuração q

n=length(obj.obj_links);
C = obj.cinematicadir(q,'centro');

V=0;
%Gravidade é 8.8 m/s^2
g=9.8;

for i = 1: n
 M=obj.obj_links(i).massa();   
 V = V + M*g*C(3,4,i);
end



end