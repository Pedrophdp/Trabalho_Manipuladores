classdef Efetuador < handle
   properties
      
       mth_fim_ef  %Matriz de transf. homogênea !constante! do último link
                   %para um frame em que a ponta do efetuador está alinhada
                   %com z
       r_link      %Raio do link do efetuador
       h_link      %Altura do link do efetuador
       cor_link    %Cor do link do efetuador
       r_ponta     %Raio da ponta do efetuador
       h_ponta     %Altura da ponta do efetuador
       cor_ponta   %Cora da ponta do efetuador

               
   end
   
   methods
       
       
       function obj =Efetuador(mth_fim_ef_in,r_link_in,h_link_in,cor_link_in,r_ponta_in,h_ponta_in,cor_ponta_in)
           %Construtor da classe Efetuador
           obj.mth_fim_ef=mth_fim_ef_in;
           obj.r_link=r_link_in;
           obj.h_link=h_link_in;
           obj.cor_link=cor_link_in;
           obj.r_ponta=r_ponta_in;
           obj.h_ponta=h_ponta_in;
           obj.cor_ponta=cor_ponta_in; 
       end
       
   end
       
       
end