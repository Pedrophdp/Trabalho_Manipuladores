classdef Elipsoide < ObjetosFisicos & handle
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Objeto Elipsóide
% Autor: Vinicius Mariano Gonçalves
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% E = Elipsoide(eye(4),[1 2 3],[1 0 0],1)
% cria um paralelepípedo com centro [0;0;0]
% com eixos [1;0;0], [0;1;0] e [0;0;1]
% de lados 1,2 e 3, respectivamente
% com cor vermelha
% e densidade 1
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

   properties
      %mth % Matriz de transformação homogênea do centro do objeto (Implementado na classe abstrata) 
      %densidade %Densidade do objeto (Implementado na classe abstrata)  
      %estatico; %Se o objeto é estático ou não (Implementado na classe abstrata)
      
      lados %Lados da elipse
      cor %Cor do elipsoide
   end
   
   properties (Hidden=true)
       %Propriedades escondidas
       %limites_desenho  Limites para desenhar (Implementado na classe abstrata)
   end
    
   methods
       
       function obj =Elipsoide(T_in,lados_in,Cor_in,Densidade_in)
        %Construtor da classe Elipsoide
        if size(T_in,1)==4
            obj.mth=T_in;
        else
            obj.mth=Robo.desl(T_in);
        end

        if length(lados_in)==3
         obj.lados=lados_in;
        else
         obj.lados=lados_in*ones(1,3);
        end

         obj.cor=Cor_in;
         obj.densidade=Densidade_in;
         obj.limites_desenho=obj.calculalimites();
         obj.estatico=0;
       end


       
       function [Dist,xmp_obj,xmp_obj2] =calcdistancia(obj,obj2,pinit)
           %Função base para calcular a distância
           %pinit: "chute" inicial para o ponto no primeiro objeto
           if nargin==2
            pinit=rand(3,1);  
           end                   
           [Dist,xmp_obj,xmp_obj2] =calcdistancia_base(obj,obj2,pinit); 
       end
       
       function [Dist,pmp_obj,pmp_obj2] = calcdistanciarap(obj,obj2,dtol,pinit)
           %Calcula a distancia rapida
           
           if nargin==2
               dtol=0.1;
               pinit=rand(3,1);
           end
           if nargin==3
               pinit=rand(3,1);
           end
           
           [cR,rR]=obj.esfera();
           [cO,rO]=obj2.esfera();
           
           Dist=max(norm(cR-cO)-rR-rO,0);
           if  Dist>dtol
               delta = cR-cO;
               delta=delta/(norm(delta)+0.001);
               pmp_obj = cR-delta*rR;
               pmp_obj2 = cO+delta*rO;
           else
               [Dist,pmp_obj,pmp_obj2] = calcdistancia(obj,obj2,pinit);
           end
           
       end       
       
      function M = massa(obj)
       %Calcula a massa do objeto
           M=prod(obj.lados)*(4*pi/3);
       end
       
      function In = matrizdeinercia(obj)
       %Calcula a matriz de inercia do objeto com um eixo alinhado com
       %o eixo principal e com o centro no centro de massa do
       % objeto
       dx=obj.lados(1);
       dy=obj.lados(2);
       dz=obj.lados(3);
       M=prod(obj.lados)*(4*pi/3)
       Ii = diag((1/5)*M*[dy^2+dz^2  dx^2+dz^2  dx^2+dy^2]);
       Rm=obj.T(1:3,1:3);
       In=Rm*Ii*Rm';
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
          x=obj.lados(1)*obj.mth(1:3,1);
          y=obj.lados(2)*obj.mth(1:3,2);
          z=obj.lados(3)*obj.mth(1:3,3);
          
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
      
       function [pmp_obj,Dist] = calcdistponto(obj,p)
           %Calcula a distância até um ponto p e retorna o ponto mais próximo
           %no objeto
          
           
           %Calcula as coordenadas locais
           s = [obj.mth(1:3,1:3)' -(obj.mth(1:3,1:3)')*obj.mth(1:3,4); 0 0 0 1]*[p;1];
           s = s(1:3);
           
           d = obj.lados;
           
           if  norm(s./d')<=1
              %Dentro da elipse
              Dist=0;
              pmp_obj=p;
           else
           %Fora da elipse  
           %Calcula lambda
           d=d';
           linf = sqrt(sum(d.^2 .* s.^2.))-max(d.^2);
           lsup = sqrt(sum(d.^2 .* s.^2.))-min(d.^2)+0.01;
           lmed = (lsup+linf)/2;
           while abs(lsup-linf)>=0.01
              lmed = (lsup+linf)/2;
              A= sum( (d.^2 .* s.^2 )./((d.^2+lmed).^2))-1;
              if A > 0 
                  linf = lmed;
              else
                  lsup = lmed;
              end
           end
             D=diag(1./(d.^2));
             M = eye(3)+lmed*D;
             smp = M\s;
             Dist=norm(s-smp);
             pmp_obj=obj.mth*[smp;1];
             pmp_obj=pmp_obj(1:3);
           
           end 
       end

           function [c,r] = esfera(obj)
               %Centro e raio da esfera que cobre o objeto
               c = obj.mth(1:3,4);
               r = max(obj.lados);
           end
      
      function [Dados,indice_saida,Handleout] =desenha(obj,Handlein,indices)
      %Desenha o objeto
      
      Dados={};
      if ~isempty(obj.cor)
          if nargin==1
              Handlein=[];
              indices=0;
          end
          
          if isempty(Handlein) || ~obj.estatico
              [xt,yt,zt]=sphere(10);
              
              for i = 1: size(xt,1)
                  for j = 1: size(xt,2)
                      p = [xt(i,j); yt(i,j); zt(i,j)];
                      p = obj.mth(1:3,4)+obj.mth(1:3,1:3)*diag(obj.lados)*p;
                      x(i,j)=p(1);
                      y(i,j)=p(2);
                      z(i,j)=p(3);
                  end
              end
              
              C(:,:,1) = obj.cor(1)*ones(size(x));
              C(:,:,2) = obj.cor(2)*ones(size(x));
              C(:,:,3) = obj.cor(3)*ones(size(x));
              
              Dados{1}=x;
              Dados{2}=y;
              Dados{3}=z;
          end
          
          if isempty(Handlein)
              Handle=surface(x,y,z,C,'EdgeColor',0.6*obj.cor,'FaceLighting','phong','MeshStyle','both');
              
          else
              if ~obj.estatico
                  set(Handlein.CurrentAxes.Children(indices), 'XData', Dados{1}, 'YData', Dados{2}, 'ZData', Dados{3});
                  indices=indices-1;
              else
                  indices=indices-1;
              end
          end
          

      end
      indice_saida=indices;
      Handleout=Handlein;
      end
      
   end
end