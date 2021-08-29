function []=democontrole2()
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Demonstração de controle 2
% Autor: Vinicius Mariano Gonçalves
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clc;
clear all;
clf;

disp('DEMONSTRAÇÃO DE CONTROLE 2');
disp('Dois robôs Jaco devem cooperar para transportar uma placa de vidro');
disp('de um lugar para outro.');
disp('Há duas tarefas a serem realizadas: (i) manter o vidro sem quebrar ');
disp('(mínimo de forças de compressão, tensão e torsão) e (ii) transportar');
disp('o vidro.');

disp('O controle é feito com a primeira tarefa com prioridade absoluta sobre');
disp('a primeira usando a técnica de projeção no espaço nulo.');
disp('O controle é centralizado: os dois robôs compartilham suas configurações');
disp('uns com os outros');
disp('Obs: Controle puramente cinemático, sem considerar a dinâmica do robô');
disp('colisões, limite de juntas, etc...');


global dados;


Rj1 = Robo.Cria_Jaco(Robo.desl([0;-0.6;0.2]));
Rj2 = Robo.Cria_Jaco(Robo.desl([0; 0.6;0.2])*Robo.rot('z',pi));
C1 = Paralelepipedo(Robo.desl([0.4;0;0.1]),[0.2 0.4 0.2],[1 1 1],1);
C1b = Paralelepipedo(Robo.desl([0;-0.6;0.1]),[0.4 0.4 0.2],0.5*[1 1 1],1);
C2 = Paralelepipedo(Robo.desl([-0.4;0;0.1]),[0.2 0.4 0.2],[1 1 1],1);
C2b = Paralelepipedo(Robo.desl([0; 0.6;0.1]),[0.4 0.4 0.2],0.5*[1 1 1],1);

C1.estatico=1;
C1b.estatico=1;
C2.estatico=1;
C2b.estatico=1;

B1 = Paralelepipedo(Robo.desl([0.4;0;0.225]),[0.1 0.6 0.05],[0.67 0.8 0.84],1);


C = Cenario([]);
C.adicionaobjetos(Rj1);
C.adicionaobjetos(Rj2);
C.adicionaobjetos(C1);
C.adicionaobjetos(C1b);
C.adicionaobjetos(C2);
C.adicionaobjetos(C2b);
C.adicionaobjetos(B1);


%Os dois robos pegarao o objeto
T1=Robo.desl([0.4;-0.3;  0.225])*Robo.rot('x',-pi/2);
T2=Robo.desl([0.4; 0.3;  0.225])*Robo.rot('x', pi/2);

Q1=Rj1.q;
Q2=Rj2.q;

dt=0.01;
erp=1;

while erp>=0.01
    Q1ant=Q1(:,end);
    Q2ant=Q2(:,end);
    [Q1,t1]=Robo.rk4( @(q,t) fc1(Rj1,q,T1),dt,Rj1.q,0.01);
    [Q2,t2]=Robo.rk4( @(q,t) fc1(Rj2,q,T2),dt,Rj2.q,0.01);
    
    erp=max(norm(Q1(:,end)-Q1ant),norm(Q2(:,end)-Q2ant));
    Rj1.config(Q1(:,end));
    Rj2.config(Q2(:,end));
    C.desenha();
    drawnow;
end


%Transporta o objeto

Rj1.grudaobjeto(B1);
C.retiraobjeto(B1);


Tc1 = Rj1.cinematicadir(Rj1.q,'efetuador');
Tc2 = Rj2.cinematicadir(Rj2.q,'efetuador');

Treldes = Tc2\Tc1;
Ttmeddes = Tc2*Robo.raizmth(Treldes,2);
Qmeddes = Ttmeddes(1:3,1:3);
dz =  0.5*(Tc1(3,4)+Tc2(3,4));
Tmeddes = [Qmeddes [0;0;dz+0.3]; 0 0 0 1];

dt=0.01;
erp=1;
Qt=[Rj1.q; Rj2.q];

tempo(1)=0;

while erp>=0.02;
    Q1ant=Qt(1:6,end);
    Q2ant=Qt(7:12,end);
    [Qt,tt]=Robo.rk4( @(qt,t) fc2(Rj1,Rj2,qt,Treldes,Tmeddes),dt,[Rj1.q; Rj2.q],0.01);
    
    erp=max(norm(Qt(1:6,end)-Q1ant),norm(Qt(7:12,end)-Q2ant));
    dt=min(0.003/erp,0.2); %0.003

    Rj1.config(Qt(1:6,end));
    Rj2.config(Qt(7:12,end));
    tempo =[tempo tt+tempo(end)] ;    
    C.desenha();
    drawnow;
end

Tmeddes = [Qmeddes [-0.4;0;dz]; 0 0 0 1];

erp=1;

while erp>=0.01
    Q1ant=Qt(1:6,end);
    Q2ant=Qt(7:12,end);
    [Qt,tt]=Robo.rk4( @(qt,t) fc2(Rj1,Rj2,qt,Treldes,Tmeddes),dt,[Rj1.q; Rj2.q],0.01);
    
    erp=max(norm(Qt(1:6,end)-Q1ant),norm(Qt(7:12,end)-Q2ant));
    dt=min(0.003/erp,0.2);
    
    Rj1.config(Qt(1:6,end));
    Rj2.config(Qt(7:12,end));
    C.desenha();
    tempo =[tempo tt+tempo(end)] ;  
    drawnow;
end


clf;
%Desenha as estatísticas

d = 1000*dados(1,1:4:end);
phi = dados(2,1:4:end);
n = min(length(d),length(tempo));


subplot(2,1,1);
plot(tempo(1:n),d(1:n),'b','linewidth',2);
xlabel('Tempo (s)');
title('Tração e compressão')
ylabel('Valor (mm)');


subplot(2,1,2);
plot(tempo(1:n),phi(1:n),'r','linewidth',2);
xlabel('Tempo (s)');
title('Torsão');
ylabel('Ângulo (graus)');



end

function u = fc1(Rb,q,Tdes)
 n=length(q);
 
   [er,J]=Rb.erropose(q,Tdes);
   u = pia(J,0.05)*(-3*er);
   
end

function u = fc2(Rb1,Rb2,qt,Treldes,Tmeddes)

global dados;

 n =length(qt)/2;
 
[er,J] = Robo.errocoop(Rb1,Rb2,qt(1:n),qt(n+1:2*n),Treldes,Tmeddes);

erel=er(1:6);
Jrel=J(1:6,:);
emed=er(7:12);
Jmed=J(7:12,:);

S = null(Jrel);
u_rel = pia(Jrel,0.08)*(-3*erel(1:6));
v = pia(Jmed*S,0.08)*(-3*emed-Jmed*u_rel);

u =  u_rel+S*v;

CD1 = Rb1.cinematicadir(qt(1:n),'efetuador');
CD2 = Rb2.cinematicadir(qt(n+1:2*n),'efetuador');

n = size(dados,2);
dados(1,n+1) = norm(CD1(1:3,4)-CD2(1:3,4))-norm(CD2(1:3,1:3)*Treldes(1:3,4));
dados(2,n+1) = 180*acos(1-erel(6)^2)/pi;
end

function Ji = pia(J,f)
%Pseudo inversa amortecida
   n=size(J,2);
   Ji = (J'*J+f*eye(n))\J';
end