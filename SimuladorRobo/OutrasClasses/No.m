classdef No <handle
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Classe No Arvore RRT
% Autor: Vinicius Mariano Gon�alves
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    properties
       config  %coordenadas da configura��o
       pai     %n� pai
       filhos  %filhos
       valor   %qualidade do n�
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