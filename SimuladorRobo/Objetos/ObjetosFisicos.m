classdef ObjetosFisicos < ObjetosDesenhaveis & handle
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Classe abstrata de Objetos Fisicos em que é possível tocar/colidir
% Autor: Vinicius Mariano Gonçalves
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    properties
       mth %Matriz de transformação homogênea da base  
       densidade %Densidade do objeto
    end
    
  
   methods(Abstract)
   %Métodos abstratos
   
   
   %Massa do objeto
   M = massa(obj)
   %Matriz de inercia
   In = matrizdeinercia(obj)
   %Calcula a distância até um ponto p e retorna o ponto mais próximo
   %no objeto
   [pmp_obj,Dist] = calcdistponto(obj,p)
   %Calcula a distância entre dois objetos e retorna os pontos mais
   %próximos em cada um deles
   [Dist,pmp_obj,pmp_obj2] =calcdistancia(obj,obj2,pinit)
   %Calcula a distância rápida entre dois objetos e retorna os pontos mais
   %próximos em cada um deles
   [Dist,pmp_obj,pmp_obj2] =calcdistanciarap(obj,obj2,dtol,pinit)   
   %Calcula o centro e o raio de uma esfera que cobre o objeto
   [c,r] = esfera(obj)
   end
end