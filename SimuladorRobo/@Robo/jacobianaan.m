function [Ja,CD] = jacobianaan(obj,q)
%Calcula a matriz jacobiana analitica em uma configuração q
%retorna também a cinemática direta para o efetuador

[Jg,CD] = obj.jacobianageo(q,'efetuador');
R = CD(1:3,1:3);
[x,y,z] = Robo.angulosdeeuler(R);

%Matrizes de produto vetorial
Sz = Robo.matrizprodv([0 0 1]);
Sy = Robo.matrizprodv([0 1 0]);
Sx = Robo.matrizprodv([1 0 0]);


%para um ponto p, dp/dt = - p x w = -Sp*w = -Sp*Jw*dq/dt = G*dq/dt, em que Jw é o jacobiano geometrico
%da velocidade angular
%Fazendo p igual aos três eixos principais x,y,z, temos as três matrizes G

Gx=-Sx*Jg(4:6,:,end);
Gy=-Sy*Jg(4:6,:,end);
Gz=-Sz*Jg(4:6,:,end);
G=[Gx;Gy;Gz];

%mas p = Rz*Ry*Rx*p0, em que (x,y,z) são os ângulos de Euler então
%dp/dt = Sz*p*(dz/dt) + Rz*Sy*Rz'*p (dy/dt) +
%Rz*Ry*Sx*Ry'*Rz'*p (dx/dt) = H dg/dt, em que g=[x;y;z] são os ângulos de
%euler
%Fazendo p igual aos três eixos principais x,y,z, temos as três matrizes G

Rz = Robo.rot('z',z);
Rz=Rz(1:3,1:3);
Ry = Robo.rot('y',y);
Ry=Ry(1:3,1:3);
Mz=Sz;
My=Rz*Sy*(Rz');
Mx=Rz*Ry*Sx*(Ry')*(Rz');

Hx=[Mx(:,1) My(:,1) Mz(:,1)];
Hy=[Mx(:,2) My(:,2) Mz(:,2)];
Hz=[Mx(:,3) My(:,3) Mz(:,3)];

H = [Hx;Hy;Hz];

%Igualando as duas, G*dq/dt =  H dg/dt  -> dg/dt = H\G*dq/dt = L dq/dt
%e encontramos a matriz jacobiana com relação aos ângulos de euler: L

Ja=[Jg(1:3,:,end);H\G]; 

%Jat = Robo.calcjacobiano(@(y) obj.vetorop(y) ,q);

end