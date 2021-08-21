classdef No <handle
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Classe No Arvore RRT
% Autor: Vinicius Mariano Gonçalves
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    properties
       config  %coordenadas da configuração
       pai     %nó pai
       filhos  %filhos
       valor   %qualidade do nó
    end
    
    methods
       
        function obj = No(config,pai,filhos,valor)
           obj.config=config;
           obj.pai = pai;
           obj.filhos = filhos;
           obj.valor = valor;
        end
    end
    
end