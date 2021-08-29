classdef InfoLinks < handle
%Informações dos links

   properties 
       %Parâmetros de Denavit Hartenberg
       alfa %Lista dos parâmetros DH alfa
       d  %Lista dos parâmetros DH d
       a  %Lista dos parâmetros DH a
       theta %Lista dos parâmetros DH theta
       
       desl %Deslocamento do eixo de rotação/translação
            %com relação ao eixo z
       
       %Limites de juntas, velocidades, torques
       limites_q   %Limite de juntas
       limites_dotq %Limite de aceleração
       limites_torque %Limites de torque
       
       %Outras informações
       tipo %Tipo das juntas
       raio %Raio das juntas
       altura %Altura das juntas
       cor_links %Cor dos links (Matriz nx3 em que cada linha é RGB)
       cor_eixos %Cor dos eixos (Matriz nx3 em que cada linha é RGB)
       densidade  %densidade de cada link
       friccao %Matriz de fricção cinética das juntas
       
       %Se tipo=0, junta rotativa. Nesse caso, theta é a configuração
       %e o valor dado é só o valor inicial (irá mudar com o tempo)
       
       %Se tipo=1, junta prismática. Nesse caso, d é a configuração
       %e o valor dado é só o valor inicial (irá mudar com o tempo)
       
   end
   
   methods
       
       function obj=InfoLinks(alfa_in,d_in,a_in,theta_in,desl_in,raio_in,altura_in,cor_links_in,cor_eixos_in,densidade_in,tipo_in,limites_qin,limites_dotqin,limites_torquein,friccao_in)
       %Cria as informações dos links
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
       %Retorna a configuração baseado no tipo de junta
       n=length(obj.alfa); 
       q=zeros(n,1);
        
        for i = 1:n
          if obj.tipo(i)==0
          %Cilíndrica 
           q(i)=obj.theta(i);
          end
          
          if obj.tipo(i)==1
          %Prismática   
           q(i)=obj.d(i);
          end
          
        end
       end
       
       function []=colocaconfig(obj,q)
       %Coloca uma configuração baseado no tipo de junta
       n=length(obj.alfa); 
       
        for i = 1:n
          if obj.tipo(i)==0
          %Cilíndrica 
           obj.theta(i)=q(i);
          end
          
          if obj.tipo(i)==1
          %Prismática   
           obj.d(i)=q(i);
          end
          
        end
       end
       
   end
   
end