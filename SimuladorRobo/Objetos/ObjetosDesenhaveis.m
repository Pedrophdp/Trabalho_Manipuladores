classdef ObjetosDesenhaveis<handle
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Classe abstrata de objetos desenhaveis
% Autor: Vinicius Mariano Gon�alves
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    properties (Hidden=true)
        %Propriedades escondidas
        limites_desenho %Limites para desenhar
        estatico        %Se o objeto � est�tico (n�o muda de posi��o) ou n�o
    end
   
   methods(Abstract)
   %M�todos abstratos
      [Dados,indices_saida,Handleout] = desenha(obj,HandleIn,indices)
      Limites = calculalimites(obj)
   end
end