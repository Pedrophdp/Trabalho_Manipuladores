classdef ObjetosDesenhaveis<handle
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Classe abstrata de objetos desenhaveis
% Autor: Vinicius Mariano Gonçalves
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    properties (Hidden=true)
        %Propriedades escondidas
        limites_desenho %Limites para desenhar
        estatico        %Se o objeto é estático (não muda de posição) ou não
    end
   
   methods(Abstract)
   %Métodos abstratos
      [Dados,indices_saida,Handleout] = desenha(obj,HandleIn,indices)
      Limites = calculalimites(obj)
   end
end