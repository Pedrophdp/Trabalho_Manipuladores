function C = caminhoconfig(obj,q1,q2,nopontos)
%Calcula a distância entre duas configurações,
%considerando a topologia

 n=length(q1);
 C=zeros(n,nopontos);
 
 for i = 1:n
   if obj.info_links.tipo(i)==0
     t1=mod(q1(i),2*pi);
     t2=mod(q2(i),2*pi);
     
     if abs(t1-t2)>pi
        if abs(t1+2*pi-t2)<=pi
          t1=t1+2*pi;
        else
          t1=t1-2*pi;  
        end
     end
     C(i,:) = t1 + (t2-t1)*(0:nopontos-1)/(nopontos-1);  
   else
     C(i,:) = q1(i) + (q2(i)-q1(i))*(0:nopontos-1)/(nopontos-1);
   end
 end

end