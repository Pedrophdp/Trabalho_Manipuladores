function [] = dispmod(str)
%Mostra texto na tela sem "quebra-la"


try
str=str{1};
catch
    
end

n=length(str);
h = 60;

indfinal=h;
indinicial=1;

while indinicial <= n
   indout = quebra(str,indinicial,min(indfinal,n));
   disp(str(indinicial:indout));
   
   indinicial=indfinal+1-(indfinal-indout);
   indfinal = indfinal+indout;
end

end

function [indout] = quebra(str,indinicial,indfinal)
 indout=indfinal;
 
 if str(indfinal)~= ' '
  if length(str)>indfinal
    if str(indfinal+1) ~= ' '
     %Vai quebrar uma palavra. Descobre quando essa palavra se inicia
      k=indfinal-1;
      while (str(k)~=' ') && (k>=indinicial)
        k=k-1;  
      end
      indout=k;
    end
  end
 end

end