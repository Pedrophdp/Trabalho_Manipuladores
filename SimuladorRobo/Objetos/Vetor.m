classdef Vetor < ObjetosDesenhaveis & handle
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Objeto Vetor
% Autor: Vinicius Mariano Gonçalves
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% P = Vetor([0 0 0]',[1 2 3]',[1 0 0],'w')
% cria um vetor [1 2 3]'  centrado em [0 0 0]
% de cor vermelha e nome 'w'
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

   properties
      p %ponto de partida do vetor
      v %vetor
      cor %Cor do vetor
      nome %Nome do vetor
      %estatico; %Se o objeto é estático ou não (Implementado na classe abstrata)
   end
   properties (Hidden = true)
     %limites_desenho % Implementado na classe abstrata
   end
   methods
       
       function obj = Vetor(p_in,v_in,Cor_in,Nome_in)
        %Construtor da classe vetor
         obj.p=p_in;
         obj.v=v_in;
         obj.cor=Cor_in;
         obj.nome=Nome_in;
         obj.limites_desenho=obj.calculalimites();
         obj.estatico=0;
       end
       
       function Limites = calculalimites(obj)
           %Calcula os limites Limites=[xmin xmax ymin ymax zmin zmax]
           %em que o objeto com certeza está contido
           xmin=min(obj.p(1)+obj.v(1),obj.p(1)-obj.v(1));
           xmax=max(obj.p(1)+obj.v(1),obj.p(1)-obj.v(1));
           ymin=min(obj.p(2)+obj.v(2),obj.p(2)-obj.v(2));
           ymax=max(obj.p(2)+obj.v(2),obj.p(2)-obj.v(2));
           zmin=min(obj.p(3)+obj.v(3),obj.p(3)-obj.v(3));
           zmax=max(obj.p(3)+obj.v(3),obj.p(3)-obj.v(3));
           Limites=[xmin xmax ymin ymax zmin zmax];
       end
       
      function [Dados,indices_saida,Handleout] =desenha(obj,Handlein,indices)
      %Desenha os eixos
      hold on;

       if nargin==1
              Handlein=[];
              indices=0;
       end
       h=[obj.p(1)+1.05*obj.v(1); obj.p(2)+1.05*obj.v(2) ; obj.p(3)+1.05*obj.v(3)];  
       if isempty(Handlein)
           desenhaseta(obj.p(1),obj.p(2),obj.p(3),obj.v(1),obj.v(2),obj.v(3),obj.cor);
           text(h(1),h(2),h(3),obj.nome,'Color',obj.cor);
       else
           if ~obj.estatico
               set(Handlein.CurrentAxes.Children(indices), 'XData',[obj.p(1) obj.p(1)+obj.v(1)],'YData',[obj.p(2) obj.p(2)+obj.v(2)],'ZData',[obj.p(3) obj.p(3)+obj.v(3)]);
               indices=indices-1;
               set(Handlein.CurrentAxes.Children(indices), 'Position',h');
               set(Handlein.CurrentAxes.Children(indices), 'String',obj.nome);
               indices=indices-1;
           else
               indices=indices-2;
           end
       end
       indices_saida=indices;
       Dados=[];
       Handleout=Handlein;
       
      end
      

      
   end
end