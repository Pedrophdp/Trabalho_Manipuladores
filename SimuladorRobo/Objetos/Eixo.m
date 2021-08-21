classdef Eixo < ObjetosDesenhaveis & handle
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Objeto Eixo
% Autor: Vinicius Mariano Gonçalves
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% P = Eixo(eye(4),4,{'x','y','z'})
% cria um eixo com centro [0;0;0]
% e vetores [1;0;0], [0;1;0] e [0;0;1]
% com tamanho dos eixos igual a 4
% e com nomes de eixos 'x','y','z' (colocar [] não plota o nome dos eixos)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

   properties
      mth % Matriz de transformação homogênea do eixo
      d %Tamanho dos eixos
      nomes %Nomes dos eixos
      %estatico; %Se o objeto é estático ou não (Implementado na classe abstrata)

   end
   properties (Hidden=true)
     %Limites  Limites para desenhar (Implementado na classe abstrata)
   end
   
   methods
       
       function obj =Eixo(T_in,d_in,nome_in)
        %Construtor da classe eixo
              
         obj.mth=T_in;
         obj.d=d_in;
         
         if ~isempty(nome_in)
             obj.nomes=nome_in;
         else
             obj.nomes{1}=' '; 
             obj.nomes{2}=' ';
             obj.nomes{3}=' ';
         end
         obj.limites_desenho=obj.calculalimites();
         obj.estatico=0;
       end
       
      function [Dados,indices_saida,Handleout] =desenha(obj,Handlein,indices)
      %Desenha os eixos
      hold on;
      
      if nargin==1
          Handlein=[];
          indices=0;
      end
          
      if isempty(Handlein) || ~obj.estatico
          xt=obj.mth(1:3,4)+1.05*obj.d*obj.mth(1:3,1);
          yt=obj.mth(1:3,4)+1.05*obj.d*obj.mth(1:3,2);
          zt=obj.mth(1:3,4)+1.05*obj.d*obj.mth(1:3,3);
      end
        
       if isempty(Handlein)
           
           X=obj.mth(1,4);
           Y=obj.mth(2,4);
           Z=obj.mth(3,4);
       
           desenhaseta(X,Y,Z,obj.d*obj.mth(1,1),obj.d*obj.mth(2,1),obj.d*obj.mth(3,1),[1 0 0]);
           desenhaseta(X,Y,Z,obj.d*obj.mth(1,2),obj.d*obj.mth(2,2),obj.d*obj.mth(3,2),[0 1 0]);
           desenhaseta(X,Y,Z,obj.d*obj.mth(1,3),obj.d*obj.mth(2,3),obj.d*obj.mth(3,3),[0 0 1]);
           
           text(xt(1),xt(2),xt(3),obj.nomes{1},'Color',[1 0 0]);
           text(yt(1),yt(2),yt(3),obj.nomes{2},'Color',[0 1 0]);
           text(zt(1),zt(2),zt(3),obj.nomes{3},'Color',[0 0 1]);

       else
           if ~obj.estatico
               x=obj.mth(1,4);
               y=obj.mth(2,4);
               z=obj.mth(3,4);
               
               u=obj.d*obj.mth(1,1);
               v=obj.d*obj.mth(2,1);
               w=obj.d*obj.mth(3,1);
               set(Handlein.CurrentAxes.Children(indices), 'XData',[x x+u],'YData',[y y+v],'ZData',[z z+w]);
               indices=indices-1;
               
               u=obj.d*obj.mth(1,2);
               v=obj.d*obj.mth(2,2);
               w=obj.d*obj.mth(3,2);
               set(Handlein.CurrentAxes.Children(indices), 'XData',[x x+u],'YData',[y y+v],'ZData',[z z+w]);
               indices=indices-1;
               
               u=obj.d*obj.mth(1,3);
               v=obj.d*obj.mth(2,3);
               w=obj.d*obj.mth(3,3);
               set(Handlein.CurrentAxes.Children(indices), 'XData',[x x+u],'YData',[y y+v],'ZData',[z z+w]);
               indices=indices-1;
               
               set(Handlein.CurrentAxes.Children(indices), 'Position',xt');
               set(Handlein.CurrentAxes.Children(indices), 'String',obj.nomes{1});
               indices=indices-1;
               set(Handlein.CurrentAxes.Children(indices), 'Position',yt');
               set(Handlein.CurrentAxes.Children(indices), 'String',obj.nomes{2});
               indices=indices-1;
               set(Handlein.CurrentAxes.Children(indices), 'Position',zt');
               set(Handlein.CurrentAxes.Children(indices), 'String',obj.nomes{3});
               indices=indices-1;
           else
               indices=indices-6;
           end
           
       end
       indices_saida=indices;
       Dados=[];
       Handleout=Handlein;

      end
      
      function Limites = calculalimites(obj)
          %Calcula os limites Limites=[xmin xmax ymin ymax zmin zmax]
          %em que o objeto com certeza está contido
          xmin=Inf;
          xmax=-Inf;
          ymin=Inf;
          ymax=-Inf;
          zmin=Inf;
          zmax=-Inf;
          c=obj.mth(1:3,4);
          x=obj.d*obj.mth(1:3,1);
          y=obj.d*obj.mth(1:3,2);
          z=obj.d*obj.mth(1:3,3);
          
          p(:,1) = c-x-y-z;
          p(:,2) = c-x-y+z;
          p(:,3) = c-x+y-z;
          p(:,4) = c-x+y+z;
          p(:,5) = c+x-y-z;
          p(:,6) = c+x-y+z;
          p(:,7) = c+x+y-z;
          p(:,8) = c+x+y+z;
          
          for i = 1: 8
              xmin=min(xmin,p(1,i));
              ymin=min(ymin,p(2,i));
              zmin=min(zmin,p(3,i));
              xmax=max(xmax,p(1,i));
              ymax=max(ymax,p(2,i));
              zmax=max(zmax,p(3,i));
          end
          Limites=[xmin xmax ymin ymax zmin zmax];
      end
      

      
   end
end