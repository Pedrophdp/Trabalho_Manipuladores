function [] = demoaula3(theta1,theta2,theta3)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Demonstração dos eixos no robô dependendo da configuração
% Deve-se dizer quais são os três ângulos
% Autor: Vinicius Mariano Gonçalves
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

q=[theta1;theta2;theta3];

Robo.dispmod('DEMONSTRAÇÃO DE AULA 3');
disp('A configuração escolhida foi:');
disp(['theta1: ' num2str(q(1))]);
disp(['theta2: ' num2str(q(2))]);
disp(['theta3: ' num2str(q(3))]);

Rb= Robo.Cria_RoboAula3A();
Rb.info_links.cor_links = repmat([0.95 0.95 0.95],3,1);
Rb.info_links.cor_eixos = repmat([0.5 0.5 0.5],3,1);
Rb.cor_base = [0.5 0.5 0.5];
Rb.obj_links=[];
Rb.obj_eixos=[];
Rb.obj_base=[];
Rb.config(q);

C = Cenario(Rb);
CD = Rb.cinematicadir(Rb.q,'base');

Rb.obj_eixoefetuador.d=0.001;
Rb.obj_eixoefetuador.nomes={'','',''};


E1 = Eixo(CD(:,:,2),0.2,{'x1','y1','z1'});
E2 = Eixo(CD(:,:,3),0.2,{'x2','y2','z2'});
Ee = Eixo(CD(:,:,4),0.2,{'xe','ye','ze'});

C.adicionaobjetos(E1);
C.adicionaobjetos(E2);
C.adicionaobjetos(Ee);

C.desenha();
alpha(0.1);

disp('Eixo 1');
disp(CD(:,:,2));

disp('Eixo 2');
disp(CD(:,:,3));

disp('Eixo e');
disp(CD(:,:,4));

end
