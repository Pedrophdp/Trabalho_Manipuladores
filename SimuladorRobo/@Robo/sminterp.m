function f = sminterp(x)

N = length(x);
xn=x;
xn(end+1)=x(1);


t = (0:N);

A=zeros(3*N,4*N);
b=zeros(3*N,1);

%Igualdade nos pontos iniciais
for p = 1: N
  A(p,mapa(N,p,0))=t(p)^0;
  A(p,mapa(N,p,1))=t(p)^1;
  A(p,mapa(N,p,2))=t(p)^2;
  A(p,mapa(N,p,3))=t(p)^3;
  b(p) = xn(p);
end
%Igualdade nos pontos finais
for p = 1: N
  A(N+p,mapa(N,p,0))=1;
  A(N+p,mapa(N,p,1))=t(p+1);
  A(N+p,mapa(N,p,2))=t(p+1)^2;
  A(N+p,mapa(N,p,3))=t(p+1)^3;
  b(N+p) = xn(p+1);
end
%Igualdade de derivada nos pontos iniciais
for p = 1: N
  if p~=N
  A(2*N+p,mapa(N,p,0))=0;
  A(2*N+p,mapa(N,p,1))=1;
  A(2*N+p,mapa(N,p,2))=2*t(p+1);
  A(2*N+p,mapa(N,p,3))=3*t(p+1)^2;
  A(2*N+p,mapa(N,p+1,0))=-0;
  A(2*N+p,mapa(N,p+1,1))=-1;
  A(2*N+p,mapa(N,p+1,2))=-2*t(p+1);
  A(2*N+p,mapa(N,p+1,3))=-3*t(p+1)^2;
  else
  A(2*N+p,mapa(N,p,0))=0;
  A(2*N+p,mapa(N,p,1))=1;
  A(2*N+p,mapa(N,p,2))=2*t(p+1);
  A(2*N+p,mapa(N,p,3))=3*t(p+1)^2;
  A(2*N+p,mapa(N,1,0))=-0;
  A(2*N+p,mapa(N,1,1))=-1;
  A(2*N+p,mapa(N,1,2))=-2*t(1); 
  A(2*N+p,mapa(N,1,3))=-3*t(1)^2; 
  end
end

%Cria a função objetivo
H = [];
for p = 1: N
    
 M = [0 0 0 0; 0 0 0 0; 0 0 4 6*(p^2-(p-1)^2); 0 0 6*(p^2-(p-1)^2) 12*(p^3-(p-1)^3)]; 
 n=size(H,1);
 H = [H zeros(n,4); zeros(4,n) M];
end

 G= [H A'; A zeros(size(A,1),size(A,1))];
 g = [zeros(size(A,2),1); b];
 y = G\g;
 c = y(1:size(H,1),1);
f = @(t) intaux(t,N,c);

% ts=0:0.001:1;
% plot(ts,f(ts));
% hold on;
% plot(t/N,xn,'ro');
% hold off;
end

function xi = intaux(t,N,c)
 for i = 1: length(t)
   xi(i) = intauxsimp(t(i),N,c);
 end
end

function xi = intauxsimp(t,N,c)
tn = N*mod(t,1);
ti = floor(tn);
coef = c(4*ti+1:4*(ti+1));
xi = coef(1)+coef(2)*tn+coef(3)*tn^2+coef(4)*tn^3;
end

function ind = mapa(N,i,j)

if i>0
 ind =4*(i-1)+(j+1);
else
 ind =4*(N-1)+(j+1);   
end

end
