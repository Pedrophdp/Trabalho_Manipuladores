function [Ja,CD] = jacobianaan(obj,q)
%Calcula a matriz jacobiana analitica em uma configura��o q
%retorna tamb�m a cinem�tica direta para o efetuador

[Jg,CD] = obj.jacobianageo(q,'efetuador');
R = CD(1:3,1:3);
[x,y,z] = Robo.angulosdeeuler(R);

%Matrizes de produto vetorial
Sz = Robo.matrizprodv([0 0 1]);
Sy = Robo.matrizprodv([0 1 0]);
Sx = Robo.matrizprodv([1 0 0]);


%para um ponto p, dp/dt = - p x w = -Sp*w = -Sp*Jw*dq/dt = G*dq/dt, em que Jw � o jacobiano geometrico
%da velocidade angular
%Fazendo p igual aos tr�s eixos principais x,y,z, temos as tr�s matrizes G

Gx=-Sx*Jg(4:6,:,end);
Gy=-Sy*Jg(4:6,:,end);
Gz=-Sz*Jg(4:6,:,end);
G=[Gx;Gy;Gz];

%mas p = Rz*Ry*Rx*p0, em que (x,y,z) s�o os �ngulos de Euler ent�o
%dp/dt = Sz*p*(dz/dt) + Rz*Sy*Rz'*p (dy/dt) +
%Rz*Ry*Sx*Ry'*Rz'*p (dx/dt) = H dg/dt, em que g=[x;y;z] s�o os �ngulos de
%euler
%Fazendo p igual aos tr�s eixos principais x,y,z, temos as tr�s matrizes G

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
%e encontramos a matriz jacobiana com rela��o aos �ngulos de euler: L

Ja=[Jg(1:3,:,end);H\G]; 

%Jat = Robo.calcjacobiano(@(y) obj.vetorop(y) ,q);

end