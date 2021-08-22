clear 
clc
close all

E= Elipsoide(Robo.desl([0;0;0]),[0.7 0.7 0.7],[0.5 0 0],1);
R= Robo.Cria_Snake(4, Robo.desl([0;-1.3; 0]));
C = Cenario(R);
C.adicionaobjetos(E);
C.desenha();

X = 0;
Y = 0;

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