classdef ObjetosFisicos < ObjetosDesenhaveis & handle
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Classe abstrata de Objetos Fisicos em que � poss�vel tocar/colidir
% Autor: Vinicius Mariano Gon�alves
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    properties
       mth %Matriz de transforma��o homog�nea da base  
       densidade %Densidade do objeto
    end
    
  
   methods(Abstract)
   %M�todos abstratos
   
   
   %Massa do objeto
   M = massa(obj)
   %Matriz de inercia
   In = matrizdeinercia(obj)
   %Calcula a dist�ncia at� um ponto p e retorna o ponto mais pr�ximo
   %no objeto
   [pmp_obj,Dist] = calcdistponto(obj,p)
   %Calcula a dist�ncia entre dois objetos e retorna os pontos mais
   %pr�ximos em cada um deles
   [Dist,pmp_obj,pmp_obj2] =calcdistancia(obj,obj2,pinit)
   %Calcula a dist�ncia r�pida entre dois objetos e retorna os pontos mais
   %pr�ximos em cada um deles
   [Dist,pmp_obj,pmp_obj2] =calcdistanciarap(obj,obj2,dtol,pinit)   
   %Calcula o centro e o raio de uma esfera que cobre o objeto
   [c,r] = esfera(obj)
   end
end