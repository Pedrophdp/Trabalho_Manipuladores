clear 
clc
close all

E= Elipsoide(Robo.desl([0;0;0]),[0.7 0.7 0.7],[0.5 0 0],1);
R= Robo.Cria_Snake(4, Robo.desl([0;-1.3; 0]));
C = Cenario(R);
C.adicionaobjetos(E);
C.desenha();

Tef0 = R.cinematicadir(R.q, 'efetuador');
%Constantes
K=7;
dt = 0.01;

%Inicializa os históricos
q_hist=[];
r_hist=[];
u_hist=[];
t=[];

%ALTERAR DEPOIS
Tdes= Robo.desl([-0.2;0;-0.2])*Tef0*Robo.rot('x', pi/6)

%termina aqui
pdes = Tdes(1:3,4);
xdes = Tdes(1:3,1);
ydes = Tdes(1:3,2);
zdes = Tdes(1:3,3);

%Cria um objeto eixo
E= Eixo(Tdes, 0.2, {'xdes','ydes','zdes'});
C.adicionaobjetos(E);

pause;


for k=1 : 2/dt
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
    
    Jrpos = Jp;
    Jrorix = xdes'*Robo.matrizprodv(xef)*Jw;
    Jroriy = ydes'*Robo.matrizprodv(yef)*Jw;
    Jroriz = zdes'*Robo.matrizprodv(zef)*Jw;
    
    Jr = [Jrpos; Jrorix; Jroriy; Jroriz];
    
    %Calcula a ação de controle
    u = Robo.pinvam(Jr, 0.001)*(-K*r);
    
    %Guarda os outros históricos
    u_hist(:,k) = u;
    r_hist(:,k) = r;
    
    %Simula o movimento do robô
    qprox = R.q + u*dt;
    R.config(qprox);
    C.desenha();
    drawnow;
    
    
end 

figure(2)
axis([-1 1 -1 1]);
for k=1 : 2000
    set (gcf, 'WindowButtonMotionFcn', @mouseMove);
end
%Função para pegar os valores do mouse
function mouseMove (object, eventdata)
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
    X
    Y
end
