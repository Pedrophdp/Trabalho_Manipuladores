function [C,dMdq] = simbolochristoffel(obj,q)
%Calcula os simbolos de christoffel em uma dada configuração q
%Também retorna dM = dM/dq

n=length(obj.q);
delta=0.0001;
M=obj.matrizdeinercia(q);
dMdq = zeros(n,n,n);
for i = 1: n
    ei = zeros(n,1);
    ei(i)=delta;
    Mip = obj.matrizdeinercia(q+ei);
    dMdq(:,:,i) = (Mip-M)/(delta);
end

C=0.5*(permute(dMdq,[3 2 1])+permute(dMdq,[3 1 2])-dMdq);


end