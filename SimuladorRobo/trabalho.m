clear all
clc
close all

F=Robo.criacurva();

%Lógica de controle
figure(1)
E= Elipsoide(Robo.desl([0;0;0]),[0.7 0.7 0.7],[0.5 0 0],1);
R= Robo.Cria_KukaKR5(Robo.desl([0;-1; 0]));
C = Cenario(R);
C.adicionaobjetos(E);

%Constantes
K=2*diag([2 2 2 4]);
dt = 0.005;

%Inicializa os históricos
q_hist=[];
r_hist=[];
u_hist=[];
vef_hist=[];
t=[];

L= 0.15; %Comprimento da tela
pc=[0;0;0]; %Ponto central da esfera
raio=0.7; %Raio esfera
po =pc+raio*[0;-cos(pi/4);sin(pi/4)]; %Ponto central da área mapeada
h_hat=[1;0;0]; %vetor ortogonal
v_hat=cross(po-pc,h_hat);
v_hat=v_hat/norm(v_hat); %vetor ortogonal
f= @(x)sign(x).*(abs(x).^(1));

H=@(tau) h_aux(tau,F,raio,v_hat,h_hat,L,pc,po);
rf=@(q,t) r_aux(q,t,R,H,pc);
r=1;
for k=1: 20/dt
    t(k) = (k-1)*dt;
   
    %Guarda alguns históricos
    q_hist(:,k)= R.q;
    
    [r,Jr,Jgeo,pdes]=rf(R.q, t(k));
    px=pdes(1);
    py=pdes(2);
    pz=pdes(3);
    nuvem= NuvemPontos(px,py,pz,[1 1 0],'.');
    adicionapontos(nuvem,px,py,pz);
    C.adicionaobjetos(nuvem);
    prpt= (rf(R.q, t(k)+dt)-rf(R.q, t(k)-dt))/(2*dt);
   % disp(prpt);
    %Calcula a ação de controle
    u = Robo.pinvam(Jr(1:4,:), 0.001)*(-K*f(r(1:4))-prpt);
    vef_hist(:,k)=Jgeo(1:3,:)*u;
    
    %Guarda os outros históricos
    u_hist(:,k) = u;
    r_hist(:,k) = r(1:4);
    
    %Simula o movimento do robô
    qprox = R.q + u*dt;
    R.config(qprox);
    if mod(k,4)==0
        C.desenha();
        drawnow;
    end 
end