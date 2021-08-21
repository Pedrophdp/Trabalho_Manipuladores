function [taucc,dKdq,C]=torquecc(obj,q,dotq)
%Calcula o torque de coriolis/cent�fugo gerado nas juntas em uma configura��o
%q e em uma velocidade qdot
%Tamb�m calcula dKdq = grad_q K = grad_q(dotq*M*dotqq/2)

n=length(q);
[C,dM] = obj.simbolochristoffel(q);

 taucc=zeros(n,1);
 dKdq = zeros(n,1);
 
for k = 1: n
  taucc(k,1) = dotq'*C(:,:,k)*dotq;  
  dKdq(k,1) = -dotq'*dM(:,:,k)*dotq/2;
end

end