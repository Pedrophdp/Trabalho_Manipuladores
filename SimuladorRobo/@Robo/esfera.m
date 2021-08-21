function [c,r] = esfera(obj)
%Centro e raio da esfera que cobre o objeto

n=length(obj.obj_links);

C = zeros(3,n+3);
R = zeros(1,n+3);

for i = 1:n
    [c,r] = obj.obj_links(i).esfera();
    C(:,i) = c;
    R(i) = r;
end

[c,r] = obj.obj_base.esfera();
C(:,n+1) =c;
R(n+1)=r;

[c,r] = obj.obj_efetuador.esfera();
C(:,n+2) =c;
R(n+2)=r;

[c,r] = obj.obj_link_efetuador.esfera();
C(:,n+3) =c;
R(n+3)=r;

D=zeros(n+3,n+3);
tipo=zeros(n+3,n+3);
maximo=-Inf;
tipo=0;
for i = 1: n+3
    for j = i+1: n+3
        tipo(i,j)=0;
        D(i,j) = norm(C(:,i)-C(:,j))+R(i)+R(j);
        if D(i,j)<= 2*R(i)
            D(i,j)=2*R(i);
            tipo(i,j)=1;
        end
        if D(i,j) <= 2*R(j)
            D(i,j)=2*R(j);
            tipo(i,j)=2;
        end
        
        if D(i,j)>maximo
            maximo=D(i,j);
            indi=i;
            indj=j;
        end
    end
end

pi = C(:,indi);
pj = C(:,indj);
ri = R(indi);
rj = R(indj);

if tipo(indi,indj)==0
c = 0.5*(pi+pj) + 0.5*(ri-rj)*(pi-pj)/(norm(pi-pj)+0.001);
end
if tipo(indi,indj)==1
 c = pi; 
end
if tipo(indi,indj)==2
 c = pj; 
end

r=-Inf;
for i = 1: n+3
  r = max(r,norm(c-C(:,i))+R(i));
end





end