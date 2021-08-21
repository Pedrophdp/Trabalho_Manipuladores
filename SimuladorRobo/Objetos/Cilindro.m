classdef Cilindro < ObjetosFisicos & handle
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Objeto Cilindro
% Autor: Vinicius Mariano Gonçalves
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% P = Cilindro(eye(4),1,3,[1 0 0],1)
% cria um cilindro com o centro da circunferencia da base
% em [0;0;0] com eixos [1;0;0], [0;1;0] e [0;0;1]
% com raio 1 e altura 3 com cor vermelha e densidade 1
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

   properties
       
      %mth % Matriz de transformação homogênea da base do cilindro (Implementado na classe abstrata) 
      %densidade %Densidade do cilindro (Implementado na classe abstrata)  
      %estatico; %Se o objeto é estático ou não (Implementado na classe abstrata)

      raio % Raio da base
      altura % Altura do cilindro
      cor %Cor do cilindro
      
   end
   properties (Hidden=true)
       %Propriedades escondidas
       %limites_desenho  Limites para desenhar (Implementado na classe abstrata)
   end
   
   methods
       
       function obj =Cilindro(T_in,R_in,h_in,Cor_in,Densidade_in)
        %Construtor da classe cilindro
         obj.mth=T_in;
         obj.raio=R_in;
         obj.altura=h_in;
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
           r=obj.raio;
           h=obj.altura;
           M=obj.densidade*pi*h*r*r;
       end
       
      function In = matrizdeinercia(obj)
       %Calcula a matriz de inercia do objeto com um eixo alinhado com
       %o eixo principal e com o centro no centro de massa do
       % objeto
       r=obj.raio;
       h=obj.altura;
       M=obj.densidade*pi*h*r*r;
       Ii = diag([(1/12)*M*h^2+(1/4)*M*r^2   (1/12)*M*h^2+(1/4)*M*r^2  (1/2)*M*r^2]);
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
       
       for i = 1: 10
          theta=2*pi*(i-1)/10;
          R=obj.raio+0.5;
          p1= obj.mth*[R*cos(theta);R*sin(theta);0;1];
          p2= obj.mth*([R*cos(theta);R*sin(theta);0;1]+1.2*obj.altura*obj.mth(:,3));
          
         xmin=min(xmin,p1(1));
         xmin=min(xmin,p2(1));
         ymin=min(ymin,p1(2));
         ymin=min(ymin,p2(2));
         zmin=min(zmin,p1(3));
         zmin=min(zmin,p2(3));
         
         xmax=max(xmax,p1(1));
         xmax=max(xmax,p2(1));
         ymax=max(ymax,p1(2));
         ymax=max(ymax,p2(2));
         zmax=max(zmax,p1(3));
         zmax=max(zmax,p2(3));
         
       end
       Limites=[xmin xmax ymin ymax zmin zmax];
      end
         
       function [pmp_obj,Dist] = calcdistpontosuave(obj,p,n)
          
        %Calcula as coordenadas locais
        s = [obj.mth(1:3,1:3)' -(obj.mth(1:3,1:3)')*obj.mth(1:3,4); 0 0 0 1]*[p;1];
        h=obj.altura;
        r=obj.raio;
        alpha = 1/sqrt((s(1)/r)^2+(s(2)/r)^2+(abs(s(3)/h))^(2*n));
        sr=[alpha*s(1);alpha*s(2);alpha^(1/n)*s(3)];
        
        if alpha>=1
         Dist=norm(s-sr);
        else
         Dist = 0;   
        end
        %Calcula o ponto mais proximo nas coordenadas
        pmp_obj = obj.mth*[sr;1];
        pmp_obj = pmp_obj(1:3);
        
      end
      
      function [pmp_obj,Dist] = calcdistponto(obj,p)
      %Calcula a distância até um ponto p e retorna o ponto mais próximo
      %no objeto    
     
        %Calcula as coordenadas locais
        s = [obj.mth(1:3,1:3)' -(obj.mth(1:3,1:3)')*obj.mth(1:3,4); 0 0 0 1]*[p;1];
        h=obj.altura;
        r=obj.raio;

        
        %Calcula a distancia nas coordenadas locais
        z=s(3);
        rs=norm(s(1:2));
        
        if (z<=h)&&(z>=0)
           if rs<= r
              Dist=0; 
              sr=s(1:3);
           else
              Dist=rs-r;
              sr=[r*s(1:2)/norm(s(1:2)); z];
           end
        else
           if rs<= r
              if z>h
                Dist=z-h;
                sr=[s(1:2);h];
              else
                Dist=-z;
                sr=[s(1:2);0];
              end
           else
              if z>h
                Dist=sqrt((z-h)^2+(rs-r)^2);
                sr=[r*s(1:2)/norm(s(1:2));h];
              else
                Dist=sqrt((z^2+(rs-r)^2));
                sr=[r*s(1:2)/norm(s(1:2));0];
              end    
           end
        end

        %Calcula o ponto mais proximo nas coordenadas
        pmp_obj = obj.mth*[sr;1];
        pmp_obj = pmp_obj(1:3);
      end 
      
      function [c,r] = esfera(obj)
      %Centro e raio da esfera que cobre o objeto
         c = obj.mth(1:3,4)+0.5*obj.altura*obj.mth(1:3,3);
         r = sqrt(obj.raio^2 + 0.25*obj.altura^2);
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
              [x,y,z]=cylinder(obj.raio,10);
              z(2,:)=obj.altura*z(2,:);
              P1 = [x(1,:);y(1,:);z(1,:); ones(1,length(z))];
              P1 = obj.mth*P1;
              P2 = [x(2,:);y(2,:);z(2,:); ones(1,length(z))];
              P2 = obj.mth*P2;
              x = [P1(1,:); P2(1,:)];
              y = [P1(2,:); P2(2,:)];
              z = [P1(3,:); P2(3,:)];
              
              C(:,:,1) = obj.cor(1)*ones(size(x));
              C(:,:,2) = obj.cor(2)*ones(size(x));
              C(:,:,3) = obj.cor(3)*ones(size(x));
              
              d=(0:0.2:2*pi);
              C1=obj.mth*[obj.raio*cos(d); obj.raio*sin(d); zeros(1,length(d));   ones(1,length(d))];
              C2=obj.mth*[obj.raio*cos(d); obj.raio*sin(d); obj.altura*ones(1,length(d));  ones(1,length(d))];
              
              Dados{1}=x;
              Dados{2}=y;
              Dados{3}=z;
              Dados{4}=C1(1:3,:)';
              Dados{5}=C2(1:3,:)';
          end
          
          if isempty(Handlein)
              Handle=surface(x,y,z,C,'EdgeColor',0.6*obj.cor,'FaceLighting','phong','MeshStyle','both');
              f1=patch(C1(1,:),C1(2,:),C1(3,:),obj.cor,'EdgeColor',0.6*obj.cor);
              f2=patch(C2(1,:),C2(2,:),C2(3,:),obj.cor,'EdgeColor',0.6*obj.cor);
          else
              if ~obj.estatico
                  set(Handlein.CurrentAxes.Children(indices), 'XData', Dados{1}, 'YData', Dados{2}, 'ZData', Dados{3});
                  indices=indices-1;
                  set(Handlein.CurrentAxes.Children(indices), 'Vertices', Dados{4});
                  indices=indices-1;
                  set(Handlein.CurrentAxes.Children(indices), 'Vertices', Dados{5});
                  indices=indices-1;
              else
                  indices=indices-3;
              end
          end
          

      end
      
      indice_saida=indices;
      Handleout=Handlein;
      
      end
      
   end
end