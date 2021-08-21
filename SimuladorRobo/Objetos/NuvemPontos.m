classdef NuvemPontos < ObjetosDesenhaveis & handle
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Objeto Nuvem de Pontos
% Autor: Vinicius Mariano Gonçalves
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% P = NuvemPontos(1:10,2*(1:10),3*(1:10),[0 0 1],'o')
% cria um objeto nuvem de pontos com 10 pontos com coordenadas
% px = 1:10, py =  2*(1:10) e pz = 3*(1:10), com cor azul
% e plotando como 'o'
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

   properties
      px %coordenadas do x
      py %coordenadas do y
      pz %coordenadas do z
      cor %cor do objeto
      tipo %tipo de linha na hora de desenhar ('o','x','d','-', etc...)
      %estatico; %Se o objeto é estático ou não (Implementado na classe abstrata)
      
   end
   properties (Hidden=true)
       %Propriedades escondidas
       %limites_desenho %Limites para desenhar
   end
   
   methods
       
       function obj =NuvemPontos(px_in,py_in,pz_in,Cor_in,tipo_in)
        %Construtor da classe cilindro
         obj.px=px_in;
         obj.py=py_in;
         obj.pz=pz_in;
         obj.cor=Cor_in;
         obj.tipo=tipo_in;
         obj.limites_desenho=obj.calculalimites();
         obj.estatico=0;
       end
       
      
      function Limites = calculalimites(obj)
       %Calcula os limites Limites=[xmin xmax ymin ymax zmin zmax]
       %em que o objeto com certeza está contido
       xmin=min(obj.px)-0.1;
       xmax=max(obj.px)+0.1;
       ymin=min(obj.py)-0.1;
       ymax=max(obj.py)+0.1;
       zmin=min(obj.pz)-0.1;
       zmax=max(obj.pz)+0.1;
       Limites=[xmin xmax ymin ymax zmin zmax];
       if isempty(Limites)
        Limites=[0 0 0 0 0 0];   
       end
      end
         
      function adicionapontos(obj,px_n,py_n,pz_n)
      %Adiciona novos pontos
        obj.px=[obj.px px_n];
        obj.py=[obj.py py_n];
        obj.pz=[obj.pz pz_n];
        %Recalcula o limite
        obj.limites_desenho=obj.calculalimites();
        
      end
      
      function [Dados,indice_saida,Handleout] =desenha(obj,Handlein,indices)
      %Desenha o objeto
          
          
          Dados{1}=obj.px;
          Dados{2}=obj.py;
          Dados{3}=obj.pz;
          
          if isempty(Handlein)
              if ~isempty(obj.px)
               plot3(obj.px,obj.py,obj.pz,obj.tipo,'Linewidth',2,'Color',obj.cor);
              else
               plot3(0,0,0,obj.tipo,'Linewidth',2,'Color',obj.cor);   
              end
          else
               if ~isempty(obj.px) && ~obj.estatico
                set(Handlein.CurrentAxes.Children(indices), 'XData', Dados{1}, 'YData', Dados{2}, 'ZData', Dados{3});
               end
               indices=indices-1;
               
          end
          
       indice_saida=indices;
       Handleout=Handlein;
          
      end
      
   end
end