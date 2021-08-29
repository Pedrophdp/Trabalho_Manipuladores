classdef InfoLinks < handle
%Informa��es dos links

   properties 
       %Par�metros de Denavit Hartenberg
       alfa %Lista dos par�metros DH alfa
       d  %Lista dos par�metros DH d
       a  %Lista dos par�metros DH a
       theta %Lista dos par�metros DH theta
       
       desl %Deslocamento do eixo de rota��o/transla��o
            %com rela��o ao eixo z
       
       %Limites de juntas, velocidades, torques
       limites_q   %Limite de juntas
       limites_dotq %Limite de acelera��o
       limites_torque %Limites de torque
       
       %Outras informa��es
       tipo %Tipo das juntas
       raio %Raio das juntas
       altura %Altura das juntas
       cor_links %Cor dos links (Matriz nx3 em que cada linha � RGB)
       cor_eixos %Cor dos eixos (Matriz nx3 em que cada linha � RGB)
       densidade  %densidade de cada link
       friccao %Matriz de fric��o cin�tica das juntas
       
       %Se tipo=0, junta rotativa. Nesse caso, theta � a configura��o
       %e o valor dado � s� o valor inicial (ir� mudar com o tempo)
       
       %Se tipo=1, junta prism�tica. Nesse caso, d � a configura��o
       %e o valor dado � s� o valor inicial (ir� mudar com o tempo)
       
   end
   
   methods
       
       function obj=InfoLinks(alfa_in,d_in,a_in,theta_in,desl_in,raio_in,altura_in,cor_links_in,cor_eixos_in,densidade_in,tipo_in,limites_qin,limites_dotqin,limites_torquein,friccao_in)
       %Cria as informa��es dos links
           obj.alfa=alfa_in;
           obj.d=d_in;
           obj.a=a_in;
           obj.theta=theta_in;
           obj.desl=desl_in;
           obj.raio = raio_in;
           obj.altura = altura_in;
           obj.cor_links=cor_links_in;
           obj.cor_eixos=cor_eixos_in;
           obj.densidade=densidade_in;
           obj.tipo=tipo_in;
           obj.limites_q=limites_qin;
           obj.limites_dotq=limites_dotqin;
           obj.limites_torque=limites_torquein;
           obj.friccao=friccao_in;
       end
       
       function q=retconfig(obj)
       %Retorna a configura��o baseado no tipo de junta
       n=length(obj.alfa); 
       q=zeros(n,1);
        
        for i = 1:n
          if obj.tipo(i)==0
          %Cil�ndrica 
           q(i)=obj.theta(i);
          end
          
          if obj.tipo(i)==1
          %Prism�tica   
           q(i)=obj.d(i);
          end
          
        end
       end
       
       function []=colocaconfig(obj,q)
       %Coloca uma configura��o baseado no tipo de junta
       n=length(obj.alfa); 
       
        for i = 1:n
          if obj.tipo(i)==0
          %Cil�ndrica 
           obj.theta(i)=q(i);
          end
          
          if obj.tipo(i)==1
          %Prism�tica   
           obj.d(i)=q(i);
          end
          
        end
       end
       
   end
   
end