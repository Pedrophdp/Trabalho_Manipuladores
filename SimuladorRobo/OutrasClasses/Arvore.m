classdef Arvore <handle
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Classe Arvore RRT
% Autor: Vinicius Mariano Gonçalves
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    properties
       nos %Nós
    end
    
    methods
       
        function obj = Arvore(qinicial,valor)
            
           if nargin==0
            obj.nos = cell(0);
           else
            obj.nos = cell(1);
            obj.nos{1} = No(qinicial,[],cell(0),valor);
           end
        end
        
        function [] = desenha(obj)
            
            figure;
            hold on;
            for i = 1: length(obj.nos)
                plot3(obj.nos{i}.config(1),obj.nos{i}.config(2),obj.nos{i}.config(3),'ro');
                for j = 1: length(obj.nos{i}.filhos)
                    x=[obj.nos{i}.config(1) obj.nos{i}.filhos{j}.config(1)];
                    y=[obj.nos{i}.config(2) obj.nos{i}.filhos{j}.config(2)];
                    z=[obj.nos{i}.config(3) obj.nos{i}.filhos{j}.config(3)];
                   plot3(x,y,z,'b');
                end
            end
            hold off;
            
        end
    end
    
end