classdef Texto < ObjetosDesenhaveis
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Objeto Texto
% Autor: Vinicius Mariano Gonçalves
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% T = Texto('Hello world',[1 1 1]',[1 0 0])
% cria um texto 'Hello world' no ponto [1 1 1]
% em cor vermelha
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

   properties
      str_texto %String texto
      pos_texto %Posiçao do texto
      cor_texto %Cor do texto
      cor_fundo %Cor do fundo
      %limites_desenho %Limites de desenho (Implementado na classa abstrata)
      %estatico; %Se o objeto é estático ou não (Implementado na classe abstrata)
   end
   methods
       
       function obj = Texto(str_texto_in,pos_texto_in,cor_texto_in,cor_fundo_in)
        %Construtor da classe texto
        obj.str_texto = str_texto_in; %String texto
        obj.pos_texto = pos_texto_in; %Posiçao do texto
        obj.cor_texto = cor_texto_in; %Cor do texto
        obj.cor_fundo = cor_fundo_in; %Cor de fundo
        obj.limites_desenho=obj.calculalimites();
        obj.estatico=0;
       end
       
      function [Dados,indices_saida,Handleout] =desenha(obj,Handlein,indices)
      %Desenha os eixos
      if nargin==1
          Handlein=[];
          indices=0;
      end
      
      if isempty(Handlein)
          if isempty(obj.cor_fundo)
              text(obj.pos_texto(1),obj.pos_texto(2),obj.pos_texto(3),obj.str_texto,'Color',obj.cor_texto);
          else
              text(obj.pos_texto(1),obj.pos_texto(2),obj.pos_texto(3),obj.str_texto,'Color',obj.cor_texto,'BackgroundColor',obj.cor_fundo);
          end
      else
          if ~obj.estatico
              set(Handlein.CurrentAxes.Children(indices), 'Position',obj.pos_texto');
              set(Handlein.CurrentAxes.Children(indices), 'String',obj.str_texto);
              indices=indices-1;
          else
              indices=indices-1;
          end
      end

       indices_saida=indices;
       Dados=[];
       Handleout=Handlein;
       
      end
      
      function Limites = calculalimites(obj)
         x=obj.pos_texto(1);
         y=obj.pos_texto(2);
         z=obj.pos_texto(3);
         Limites=[x-0.05 x+0.5 y-0.05 y+0.05 z-0.05 z+0.05];
      end
      
   end
end