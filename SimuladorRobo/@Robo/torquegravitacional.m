function taug=torquegravitacional(obj,q)
%Calcula o torque gerado nas juntas devido a gravidade em uma configuração
%q


%Gravidade é 8.8 m/s^2
g=9.8;
%Jacobiana dos centros
Jg=obj.jacobianageo(q,'centro');
%Calcula a massa de cada um dos cilindros
%e a jacobiana da componente z
for i = 1: length(obj.obj_links)
M(i,1) = obj.obj_links(i).massa();
J(:,i) = Jg(3,:,i)';
end

%Calcula o torque gravitacional
taug = g*J*M;
end