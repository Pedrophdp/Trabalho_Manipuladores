function [Dist,p1,p2] = distanciaconvexa(obj1,obj2,pinit)
%Calcula a distância entre dois objetos convexos obj1 e obj2 usando
% o algoritmo de projeção cíclica de Von Neumann

%pinit: chute inicial para ponto no o primeiro objeto

 if nargin==2
   p=rand(3,1);  
 else
   p=pinit;  
 end

  pant=p+1;

  while norm(pant-p)>=0.03
   pant=p;
   p=obj2.calcdistponto(obj1.calcdistponto(p));
  end


  p2=p;
  p1=obj1.calcdistponto(p2);
  Dist=norm(p1-p2); 
end