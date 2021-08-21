function [w,theta] = retornaeixo(T)
%Dado uma matriz de transforma��o homog�nea T, retorna o
%respectivo eixo de rota��o, w, e o �ngulo

Q= T(1:3,1:3);
[V,D]=eig(Q);

theta = abs(log(D(2,2)));
ind = find( abs(diag(D)-1)<=0.001 ); 
w = real(V(1:3,ind(1)));

j=sqrt(-1);

if abs(det(V)-j)>=0.01
  w=-w;  
end


end