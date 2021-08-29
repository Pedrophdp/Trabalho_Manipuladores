classdef ControladorRobo
   properties
      
       %ERRO DE COMPENSAÇÃO DE DINÂMICA (0=perfeito)
       errodinam 
       
       %CONTROLADOR DE VELOCIDADE DE CONFIGURAÇÃO
       kpv %Matriz de ganho proporcional velocidade
       kiv %Matriz de ganho integral de velocidade
       
       %CONTROLADOR DE CONFIGURAÇÃO
       kpq %Matriz de ganho proporcional configuração
       
       %CONTROLADOR DE POSE
       kppose %Matriz de ganho proporcional de pose
       
       %CONTROLADOR POR COMPENSAÇÃO DE GRAVIDADE
       kdcg;

               
   end
   
   methods
       
       
       function obj =ControladorRobo(errodinam_in,kpv_in,kiv_in,kpq_in,kppose_in,kdcg_in)
           %Construtor da classe ControladorRobo
           obj.errodinam=errodinam_in;
           obj.kpv=kpv_in;
           obj.kiv=kiv_in;
           obj.kpq=kpq_in;
           obj.kppose=kppose_in;
           obj.kdcg=kdcg_in;
       end
       
   end
       
       
end