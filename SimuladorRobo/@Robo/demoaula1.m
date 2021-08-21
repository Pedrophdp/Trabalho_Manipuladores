function []=demoaula1(eixo,theta)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Demonstração de um paralelepípedo girando em um eixo
% Autor: Vinicius Mariano Gonçalves
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clc;


eixo=eixo/(norm(eixo)+0.001);

eixostr=[ num2str(eixo(1)) ' '  num2str(eixo(2)) ' '  num2str(eixo(3))];
disp('DEMONSTRAÇÃO DE AULA 1');
disp(['Demonstração da rotação de um paralelepípedo no eixo w=[' eixostr '] com ângulo variando']);
disp('Matriz de rotação:');
Q=Robo.rot(eixo,theta);
disp(Q(1:3,1:3));

P = Paralelepipedo(eye(4),0.2*[1 2 3],[0 1 1],1);
E = Eixo(eye(4),1,{'x1','y1','z1'});
r = Vetor([0;0;0],eixo,[0.2 0.6 1],'w');
Vx = Vetor([0;0;0],0.8*[1 0 0],[0.4 0.4 0.4],'x0');
Vy = Vetor([0;0;0],0.8*[0 1 0],[0.4 0.4 0.4],'y0');
Vz = Vetor([0;0;0],0.8*[0 0 1],[0.4 0.4 0.4],'z0');


C= Cenario(P);
C.adicionaobjetos(E);
C.adicionaobjetos(r);
C.adicionaobjetos(Vx);
C.adicionaobjetos(Vy);
C.adicionaobjetos(Vz);
C.chao.cor=[];
C.limites_desenho(5)=-1;
C.eixoref.d=0.01;
C.eixoref.nomes={'','',''};

theta_temp=0;
dt=0.05;

while theta_temp<theta
    T=Robo.rot(eixo,theta_temp);
      
    
    P.mth=T;
    E.mth=T;

    C.desenha();
    drawnow;
    theta_temp=theta_temp+dt;
end

end