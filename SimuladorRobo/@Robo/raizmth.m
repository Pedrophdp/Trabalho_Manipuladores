function Tr = raizmth(T,n)

%Calcula a n-ésima raiz de uma mth T

%Calcula a raiz de uma matriz de transformacao homogenea
Q = T(1:3,1:3);
[w,theta] = Robo.retornaeixo(Q);
Qr = Robo.rot(w,theta/n);
Qr = Qr(1:3,1:3);

H = eye(3);
I=eye(3);
for i = 1: n-1
H = Qr*H+I;    
end
a = H\T(1:3,4);

Tr = [Qr a; 0 0 0 1];


end