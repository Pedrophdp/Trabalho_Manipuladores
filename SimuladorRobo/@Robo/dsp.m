function []=dsp(nome,valor)
%Mostra uma variável na tela

  n=size(valor,1);
  r=[nome ': '];
  for i = 1: n
   r = [r ' ' num2str(valor(i)) ];    
  end

  
 disp(r);
end