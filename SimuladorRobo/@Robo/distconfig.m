function D = distconfig(obj,q1,q2)
%Calcula a distância entre duas configurações,
%considerando a topologia

 n=length(q1);
 D = 0;
 
 for i = 1:n
   if obj.info_links.tipo(i)==0
     D = D+ 2*abs( 1 - cos( q1(i)-q2(i) ) );  
   else
     D = D+(q1(i)-q2(i))^2;  
   end
 end
 D = sqrt(D);
end