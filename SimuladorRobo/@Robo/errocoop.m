function [ecoop,Jecoop] = errocoop(R1,R2,q1,q2,T_rel_des,T_med_des)
%Calcula o erro cooperativo (erro relativo e médio) e as jacobianas


%Pre-calculos
n1=length(q1);
n2=length(q2);

[J1,CD1]=R1.jacobianageo(q1,'efetuador');
[J2,CD2]=R2.jacobianageo(q2,'efetuador');

R1 = map(J1,CD1);
R2 = map(J2,CD2);


%ERRO RELATIVO
H=CD2\CD1;
Jtemp = zeros(6,n1+n2);
pHpi = zeros(4,4,n1+n2);

for i = 1: n1
 pHpi(:,:,i) = CD2\R1(:,:,i);
 Jtemp(:,i) = imap(pHpi(:,:,i),H);
end
for i = 1: n2
 pHpi(:,:,i+n1) = -CD2\R2(:,:,i)*H;
 Jtemp(:,i+n1) = imap(pHpi(:,:,i+n1),H);
end

%Posicao relativa
ep_rel=H(1:3,4)-T_rel_des(1:3,4);
Jep_rel = Jtemp(1:3,:);

%Orientacao relativa
eo_rel = sqrt(1.001-diag(T_rel_des(1:3,1:3)'*H(1:3,1:3)));
Jeo_rel(1,:) = T_rel_des(1:3,1)'*Robo.matrizprodv(H(1:3,1))*Jtemp(4:6,:)/(2*eo_rel(1));
Jeo_rel(2,:) = T_rel_des(1:3,2)'*Robo.matrizprodv(H(1:3,2))*Jtemp(4:6,:)/(2*eo_rel(2));
Jeo_rel(3,:) = T_rel_des(1:3,3)'*Robo.matrizprodv(H(1:3,3))*Jtemp(4:6,:)/(2*eo_rel(3));


%ERRO MÉDIO
F=Robo.raizmth(H,2);
M = CD2*F;

pFpi = zeros(4,4,n1+n2);
for i = 1: n1+n2 
pFpi(:,:,i) = resolveeq(F,pHpi(:,:,i));
end

Jtemp = zeros(6,n1+n2);
for i = 1: n1
 S = CD2*pFpi(:,:,i);
 Jtemp(:,i) = imap(S,M);    
end
for i = 1: n2
 S= CD2*pFpi(:,:,i+n1) + R2(:,:,i)*F;
 Jtemp(:,i+n1) = imap(S,M); 
end

G = M(1:3,1:3)-T_med_des(1:3,1:3);

%Posicao media
ep_med=0.5*(CD1(1:3,4)+CD2(1:3,4))-T_med_des(1:3,4);
Jep_med = [0.5*J1(1:3,:) 0.5*J2(1:3,:)];

%Orientacao media
eo_med = sqrt(1.001-diag(T_med_des(1:3,1:3)'*M(1:3,1:3)));
Jeo_med(1,:) = T_med_des(1:3,1)'*Robo.matrizprodv(M(1:3,1))*Jtemp(4:6,:)/(2*eo_med(1));
Jeo_med(2,:) = T_med_des(1:3,2)'*Robo.matrizprodv(M(1:3,2))*Jtemp(4:6,:)/(2*eo_med(2));
Jeo_med(3,:) = T_med_des(1:3,3)'*Robo.matrizprodv(M(1:3,3))*Jtemp(4:6,:)/(2*eo_med(3));

%Junta no final
ecoop = [ep_rel;eo_rel; ep_med; eo_med];
Jecoop = [Jep_rel; Jeo_rel; Jep_med; Jeo_med];

end

function R = map(J,CD)

  n = size(J,2);
  Q = CD(1:3,1:3);
  R = zeros(4,4,n);
  for i = 1: n
   Jpi = J(1:3,i);
   Jwi = J(4:6,i);
   R(:,:,i) = [ Robo.matrizprodv(Jwi)*Q Jpi; 0 0 0 0];   
  end
  
end

function J = imap(T,H)


J = zeros(6,1);

J(1:3) = T(1:3,4);
L = T(1:3,1:3)*(H(1:3,1:3)');
J(4:6) = [-L(2,3); L(1,3); L(2,1)];

end

function X=resolveeq(A,B)
%Resolve a equação XA+AX=B para X
n=size(A,1);
F=(kron(A',eye(n))+kron(eye(n),A));
x=F\reshape(B,n*n,1);
X=reshape(x,n,n);

end

