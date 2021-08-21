classdef Cenario<handle
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Classe Cenário
% Autor: Vinicius Mariano Gonçalves
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    properties
       lst_obj_desenhaveis %Lista de objetos que podem ser desenhados
       lst_obj_fisicos  %Lista de objetos que existem fisicamente
       handle_desenho %Handle de desenho  

    end
    
    properties (Hidden=true)
        %Propriedades escondidas
        limites_desenho %Limites para desenhar  
        chao %Paralelepipedo do chão
        eixoref %Eixo de referência
    end
   
  
   methods
     
       function obj = Cenario(lst_obj_desenhaveis_in)
           %Construtor da classe cenário
           obj.limites_desenho =[-1 1 -1 1 -1 1];
           obj.handle_desenho=[];
           obj.lst_obj_desenhaveis={};
           obj.lst_obj_fisicos={};
           
           if length(lst_obj_desenhaveis_in)==1
             obj.adicionaobjetos(lst_obj_desenhaveis_in);  
           else
               for i = 1: length(lst_obj_desenhaveis_in)
                   obj.adicionaobjetos(lst_obj_desenhaveis_in{i});
               end
           end
           obj.criachaoeixo();
           
       end
       
       
       function [] = criachaoeixo(obj)
         %Cria chão e eixo de referência para o cenário
         
         lim=obj.limites_desenho;
         cx= (lim(1)+lim(2))/2;
         cy= (lim(3)+lim(4))/2;
         cz=-0.05;
         dx= (lim(2)-lim(1));
         dy= (lim(4)-lim(3));
         dz=0.1;

         
         lados = [dx; dy; dz];
         T=eye(4);
         T(1:3,4)=[cx;cy;cz];
         obj.chao = Paralelepipedo(T,lados,[63 122 77]/255,0);
         obj.chao.estatico=1;
         obj.eixoref = Eixo(eye(4,4),0.2*min(dx,dy),{'x0','y0','z0'});
         obj.eixoref.estatico=1;
       end
       
      
       function [] = adicionaobjetos(obj,obj_add_t)
           %Adiciona objetos ao cenário
           
           if length(obj_add_t)==1
              obj_add = cell(1);
              obj_add{1}=obj_add_t;
           else
             obj_add =obj_add_t; 
           end
           
           for i = 1: length(obj_add)
               %Adiciona na lista de desenhaveis
               obj.lst_obj_desenhaveis{end+1}=obj_add{i};
               
               %Se ele for físico, adiciona também na lista de objetos físicos
               if isa(obj_add{i},'ObjetosFisicos')
                   obj.lst_obj_fisicos{end+1}=obj_add{i};
               end
               
               %Atualiza os limites
               l=obj.limites_desenho;
               
               obj.limites_desenho(1)=min(obj_add{i}.limites_desenho(1),l(1));
               obj.limites_desenho(2)=max(obj_add{i}.limites_desenho(2),l(2));
               obj.limites_desenho(3)=min(obj_add{i}.limites_desenho(3),l(3));
               obj.limites_desenho(4)=max(obj_add{i}.limites_desenho(4),l(4));
               obj.limites_desenho(5)=-0.1;
               obj.limites_desenho(6)=max(obj_add{i}.limites_desenho(6),l(6));
           end
           
           %Recria o eixo
           obj.criachaoeixo();
           
           %Reseta o handle de desenho
           obj.handle_desenho=[];
           
           %Apaga a figura
           clf;
                     
       end
       
       function [] = retiraobjeto(obj,obj_rem)
           %Retira um objeto do cenario
           

           i=1;
           ok=0;
           while ~ok && (i<=length(obj.lst_obj_fisicos))
               if obj_rem==obj.lst_obj_fisicos{i}
                   obj.lst_obj_fisicos(i)=[];
                   ok=1;
               end
               i=i+1;
           end

           i=1;
           ok=0;
           while ~ok && (i<=length(obj.lst_obj_desenhaveis))
               if obj_rem==obj.lst_obj_desenhaveis{i}
                   obj.lst_obj_desenhaveis(i)=[];
                   ok=1;
               end
               i=i+1;
           end
           
           %Recria o eixo
           obj.criachaoeixo();
           
           %Reseta o handle de desenho
           obj.handle_desenho=[];
           
           %Apaga a figura
           clf;
           
       end
            
       function [] = desenha(obj)
           %Desenha o cenário
           
           persp=0;
           if ~isempty(obj.handle_desenho)
               if ~isvalid(obj.handle_desenho)
                   obj.handle_desenho=[];
                   k=0;
                   persp=1;
               else
                   k=length(obj.handle_desenho.CurrentAxes.Children);
               end
           else
               k=0;
               persp=1;
           end
           
           hold on;
           %Desenha o chão e o eixo de referência
           [~,k,obj.handle_desenho] = obj.chao.desenha(obj.handle_desenho,k);
           [~,k,obj.handle_desenho] = obj.eixoref.desenha(obj.handle_desenho,k);
           
           %Desenha todos os objetos
           for i = 1: length(obj.lst_obj_desenhaveis)
               [~,k,obj.handle_desenho] = obj.lst_obj_desenhaveis{i}.desenha(obj.handle_desenho,k);
           end
           hold off;
           
           %Atualiza o handle desenho
           if isempty(obj.handle_desenho)
               obj.handle_desenho=gcf;
           end
           
           %Coloca o eixo
           axis(obj.limites_desenho);
           %Coloca os textos
           xlabel('x');
           ylabel('y');
           zlabel('z');

           
           box on;
           grid on;
           %set(gcf, 'Units', 'Normalized', 'OuterPosition', [0, 0.04, 1, 0.96]);
           
           if persp==1
               view(3);
           end
           
       end
      
      
   end
end