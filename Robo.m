clear 
clc
close all

global xt 
global yt
FH=figure(1)
axis([-1 1 -1 1]);
set (FH, 'WindowButtonMotionFcn', @mouseMove);

E= Elipsoide(Robo.desl([0;0;0]),[0.7 0.7 0.7],[0.5 0 0],1);
%R= Robo.Cria_Snake(4, Robo.desl([0;-1; 0]));
R= Robo.Cria_KukaKR5(Robo.desl([0;-1; 0]));
C = Cenario(R);
C.adicionaobjetos(E);

Tef0 = R.cinematicadir(R.q, 'efetuador');
%Constantes
K=1;
dt = 0.005;

%Inicializa os históricos
q_hist=[];
r_hist=[];
u_hist=[];
t=[];

pc=[0;0;0] %Ponto central da esfera
r=0.7; %Raio esfera
po =pc+r*[0;-cos(pi/4);sin(pi/4)]; %Ponto central da área mapeada
h_hat=[1;0;0]; %vetor ortogonal
v_hat=cross(po-pc,h_hat);
v_hat=v_hat/norm(v_hat); %vetor ortogonal
h=1; %x
v=1; %y
L= 0.2; %Comprimento da tela
Pp=po+L*h*h_hat+L*v*v_hat;
pdes= pc+(r*(Pp-pc)/norm(Pp-pc)) %Ponto que se quer chegar
xdes=v_hat;
ydes=h_hat;
zdes= cross(v_hat,h_hat);

%Cria um objeto eixo
% E= Eixo(Tdes, 0.2, {'xdes','ydes','zdes'});
% C.adicionaobjetos(E);
% plot3(po(1),po(2),po(3), '.', 'markersize', 30,'color', 'y')
% hold on
pause;
f= @(x)sign(x).*sqrt(abs(x))


figure(2)
for k=1 : 4/dt
   
    %Guarda alguns históricos
    q_hist(:,k)= R.q;
    t(k) = (k-1)*dt;

    %Alguns cálculos
    Tef = R.cinematicadir(R.q, 'efetuador');
    Jgeo = R.jacobianageo(R.q, 'efetuador');
    pef = Tef(1:3,4);
    xef = Tef(1:3,1);
    yef = Tef(1:3,2);
    zef = Tef(1:3,3);
    Jp = Jgeo(1:3,:);
    Jw = Jgeo(4:6,:);
    
    rpos = pef-pdes;
    rorix = 1 - xdes'*xef;
    roriy = 1 - ydes'*yef;
    roriz = 1 - zdes'*zef;
    
    r = [rpos; rorix; roriy; roriz];
    %r= [rpos;roriz];
    Jrpos = Jp;
    Jrorix = xdes'*Robo.matrizprodv(xef)*Jw;
    Jroriy = ydes'*Robo.matrizprodv(yef)*Jw;
    Jroriz = zdes'*Robo.matrizprodv(zef)*Jw;
    
    Jr = [Jrpos; Jrorix; Jroriy; Jroriz];
    %Jr = [Jrpos; Jroriz];
    %Calcula a ação de controle
    u = Robo.pinvam(Jr(1:6,:), 0.001)*(-K*f(r(1:6)));
    
    %Guarda os outros históricos
    u_hist(:,k) = u;
    r_hist(:,k) = r(1:6);
    
    %Simula o movimento do robô
    qprox = R.q + u*dt;
    R.config(qprox);
    if mod(k,4)==0
       C.desenha();
       drawnow;
    end
    disp(xt)
   
    
end 


%Função para pegar os valores do mouse
function [X,Y]= mouseMove (object, eventdata)
    C = get (gca, 'CurrentPoint');
    title(gca, ['(X,Y) = (', num2str(C(1,1)), ', ',num2str(C(1,2)),')']);
    X= C(1,1);
    Y= C(1,2);
    if X>1
        X=1;
    end
    if Y>1
        Y=1;
    end
    if X<-1
        X=-1;
    end
    if Y<-1
        Y=-1;
    end
    xt=X;
    yt=Y;
    %disp(xt)
end
