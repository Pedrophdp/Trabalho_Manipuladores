classdef Paralelepipedo < ObjetosFisicos & handle
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Objeto Paralelepípedo
% Autor: Vinicius Mariano Gonçalves
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% P = Paralelepipedo(eye(4),[1 2 3],[1 0 0],1)
% cria um paralelepípedo com centro [0;0;0]
% com eixos [1;0;0], [0;1;0] e [0;0;1]
% de lados 1,2 e 3, respectivamente
% com cor vermelha
% e densidade 1
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

   properties
     %T % Matriz de transformação homogênea do centro do objeto (Implementado na classe abstrata)
     %densidade; %Densidade do paralelelepipedo (Implementado na classe abstrata)
     %estatico; %Se o objeto é estático ou não (Implementado na classe abstrata)
     
     lados %Lados do paralelepipedo;
     cor; %Cor do paralelepipedo
     
   end
   properties (Hidden = true)
     %limites_desenho; Limites para desenhar (Implementado na classe abstrata)
   end
   
   methods
       
       function obj =Paralelepipedo(T_in,lados_in,Cor_in,Densidade_in)
        %Construtor da classe paralelepípedo
         obj.mth=T_in;
         obj.lados=lados_in;
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
           M=prod(obj.lados)*obj.densidade;
       end
       
      function In = matrizdeinercia(obj)
       %Calcula a matriz de inercia do objeto com um eixo alinhado com
       %o eixo principal e com o centro no centro de massa do
       % objeto
       dx=obj.lados(1);
       dy=obj.lados(2);
       dz=obj.lados(3);
       M=obj.massa();
       Ii = diag((1/12)*M*[dy^2+dz^2  dx^2+dz^2  dx^2+dy^2]);
       Rm=obj.mth(1:3,1:3);
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

        
       %Calcula as coordenadas locais r
        r = [obj.mth(1:3,1:3)' -(obj.mth(1:3,1:3)')*obj.mth(1:3,4); 0 0 0 1]*[p;1];
        r = r(1:3);
        
      %Calcula a distância e o ponto mais próximo 
        L = [ abs(r(1))-0.5*obj.lados(1)  abs(r(2))-0.5*obj.lados(2) abs(r(3))-0.5*obj.lados(3)];
        L = max(L,0);
        Dist = norm(L);
 
        rmp_obj=r;
        for i=1:3
           if r(i)>=0.5*obj.lados(i)
              rmp_obj(i) = 0.5*obj.lados(i);  
           end
           if r(i)<=-0.5*obj.lados(i)
              rmp_obj(i) = -0.5*obj.lados(i);   
           end
        end
        
     
        
        pmp_obj=obj.mth*[rmp_obj;1];
        pmp_obj=pmp_obj(1:3);
        
        
      end
   
      function [c,r] = esfera(obj)
      %Centro e raio da esfera que cobre o objeto
         c = obj.mth(1:3,4);
         r = norm(obj.lados)/2;
      end
      
       function [Dados,indices_saida,Handleout] = desenha(obj,Handlein,indices)
       %Desenha o objeto
       
        Dados={};
        if ~isempty(obj.cor)
            if nargin==1
                Handlein=[];
                indices=0;
            end
          
            if isempty(Handlein) || ~obj.estatico
                %Atributos auxiliares
                vetorA = 0.5*obj.lados(1)*obj.mth(1:3,1);
                vetorB = 0.5*obj.lados(2)*obj.mth(1:3,2);
                vetorC = 0.5*obj.lados(3)*obj.mth(1:3,3);
                centro = obj.mth(1:3,4);
                
                if nargin==1
                    Handlein=[];
                    indices=0;
                end
                
                X = 2*[0 0 0 0 0 1; 1 0 1 1 1 1; 1 0 1 1 1 1; 0 0 0 0 0 1]-1;
                Y = 2*[0 0 0 0 1 0; 0 1 0 0 1 1; 0 1 1 1 1 1; 0 0 1 1 1 0]-1;
                Z = 2*[0 0 1 0 0 0; 0 0 1 0 0 0; 1 1 1 0 1 1; 1 1 1 0 1 1]-1;
                
                
                Tmod = [vetorA vetorB vetorC centro; zeros(1,3) 1];
                
                Xd=zeros(4,6);
                Yd=zeros(4,6);
                Zd=zeros(4,6);
                
                for j = 1: 6
                    temp=Tmod*[X(:,j)' ; Y(:,j)' ; Z(:,j)' ;  1 1 1 1];
                    Xd(:,j)=temp(1,:)';
                    Yd(:,j)=temp(2,:)';
                    Zd(:,j)=temp(3,:)';
                    Dados{j} = temp(1:3,:);
                end
                
            end
           
           if isempty(Handlein)
            fill3(Xd,Yd,Zd,obj.cor,'FaceAlpha',1,'EdgeColor',0.6*obj.cor); 
           else
                   if ~obj.estatico
                   for j = 1: 6
                       set(Handlein.CurrentAxes.Children(indices), 'Vertices', Dados{j}');
                       indices=indices-1;
                   end
                   else
                       indices=indices-6;
                   end
           end
        end
           
           indices_saida=indices;
           Handleout=Handlein;

       end
   end
end