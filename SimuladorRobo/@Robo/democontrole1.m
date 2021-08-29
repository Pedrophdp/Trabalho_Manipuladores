function [] = democontrole1()

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Demonstra��o de controle 1
% Autor: Vinicius Mariano Gon�alves
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



clc;
clf;

disp('DEMONSTRA��O DE CONTROLE 1');
disp('O rob� KukaKR5 deve desenhar uma circunfer�ncia em um quadro branco');
disp('Para isso ele deve usar uma caneta que est� em seu efetuador');
disp('Note que n�o s� devemos controlar a posi��o x,y,z do efetuador');
disp('mas tamb�m a orienta��o do efetuador, que deve ser paralela � do quadro');
disp('Obs: Controle puramente cinem�tico, sem considerar a din�mica do rob�');
disp('colis�es, limite de juntas, etc...');


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Cria o cen�rio
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%Cria rob� KukaKR5
Rb= Robo.Cria_KukaKR5();


%Cria um quadro
T=eye(4);
T(1:3,4)=[0.6;0;0.5];
Quadro = Paralelepipedo(T,[0.05 0.9 0.8],[0.9 0.9 0.9],1);
Quadro.estatico=1;
%Cria uma nuvem de pontos que vai ser desenhada, inicialmente vazia
Npontos = NuvemPontos([],[],[],[128 0 128]/255,'-');

%Cria um cen�rio com o rob�
C = Cenario(Rb);
%Adiciona o quadro
C.adicionaobjetos(Quadro);
%Adiciona a nuvem de pontos
C.adicionaobjetos(Npontos);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Controle para desenhar um c�rculo
% no quadro
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%Par�metros do c�rculo paralelo ao eixo yz
%pc=0.5;
pc=[0.6; 0; 0.5]; 
r=0.25;
t=0;
dt=0.04; %dt=0.02;
w=0.02;
t=0;

%Par�metros do controlador: ganho proporcional
kp=2;

%Inicializa��es
errox_hist=[];
erroraio_hist=[];
erroenagulo_hist=[];
t_hist=[];
i=1;

while t<100
    
    %Vari�vel auxiliar que guarda a configura��o atual
    q=Rb.q;
    
    %Computa algumas informa��es �teis
    
    %Vetor operacional com a cinem�tica direta
    [vop,CD] = Rb.vetorop(q);
    %Jacobiana geom�trica
    J_geo =  Rb.jacobianageo(q,'efetuador');
  
    %Calcula a velocidade (x,y,z) do efetuador desejada
    ved = campovetorial(vop(1:3),pc,r);
    %Captura a jacobiana da posi��o na jacobiana geom�trica
    J_p = J_geo(1:3,:);
    
    %Calcula o erro de alinhamento do eixo z do efetuador com o eixo
    %x de refer�ncia (x0). Tamb�m retorna a jacobiana
    [ea,J_ea] = erro_angulo(CD,J_geo);
    
    %As equa��es s�o J_p*dotq = v, J_ea*dotq=-kp*ea
    %ou J dotq = v_total
    J = [J_p; J_ea];
    v_total = [ved; -kp*ea];


    %Calcula a velocidade no espa�o de configura��o usando
    %a pseudoinversa amortecida da jacobiana
    dotq=(J'*J+0.01*eye(6))\(J'*v_total);
    
    %Guarda os hist�ricos
    errox_hist(i)= vop(1)-pc(1);
    erroraio_hist(i)=sqrt( (vop(2)-pc(2))^2+(vop(3)-pc(3))^2 )-r;
    erroenagulo_hist(i)=180*acos(max(min(1-ea^2,1),-1))/pi;
    t_hist(i)=t;

    %Integra a velocidade
    q=q+dotq*dt;
    

    
    t=t+dt;
    i=i+1;
    
    %Desenha e pega algumas informa��es, mas s� de 0.5 em 0.5 segundos
    if mod(i,floor(0.2/dt))==0
        %Adiciona na nuvem de pontos a trajet�ria do efetuador, mas s�
        %se tiver perto do quadro (simula a caneta no efetuador)       
        if abs(vop(1)-pc(1))<=0.01
         C.lst_obj_desenhaveis{end}.adicionapontos(vop(1)-0.03,vop(2),vop(3));
        end
    
        %Desenha o rob�
        Rb.config(q);
        C.desenha();
              
        %Movie=getframe();
        drawnow;
    end
end

clf;
%Desenha as estat�sticas
subplot(3,1,1);
plot(t_hist,errox_hist,'b','linewidth',2);
xlabel('Tempo (s)');
title('x-0.6 (m)')
ylabel('Erro');
axis([0 100 -0.5 0.5]);

subplot(3,1,2);
plot(t_hist,erroraio_hist,'r','linewidth',2);
xlabel('Tempo (s)');
title('sqrt(y^2+(z-0.5)^2)-0.3(m)');
ylabel('Erro');
axis([0 100 -0.5 0.5]);

subplot(3,1,3);
plot(t_hist,erroenagulo_hist,'g','linewidth',2);
xlabel('Tempo (s)');
title('angulo x0 e z (grau)');
ylabel('Erro');
axis([0 100 -20 20]);




function v = campovetorial(p,pc,r)
 %Campo vetorial dp/dt = v(p) para seguir um c�rculo
 %de centro pc=[xc;yc;zc] e raio r no plano yz
 

 alfa1 = norm(p-pc)-r;
 alfa2 = p(1)-pc(1);
 gradalfa1 = (p-pc)/norm( (p-pc)+0.001);
 gradalfa2 = [1; 0; 0];
 

 v_conv = -alfa1*gradalfa1-alfa2*gradalfa2;
 v_conv = v_conv/(norm(v_conv)+0.001);
 
 v_tan = cross(gradalfa1,gradalfa2);
 v_tan = v_tan/(norm(v_tan)+0.001);
 
 v = 0.5*(0.4*v_conv+v_tan)/sqrt(2);
end 

function [ea,J_ea] = erro_angulo(CD,J_geo)
%Erro de alinhamento ea e a respectiva jacobiana Jea
%ea = sqrt(1 - cos(theta)), em que theta � o �ngulo entre o eixo z do
%efetuador e x de refer�ncia
%Retorna tamb�m outras informa��es que ser�o �teis posteriormente

  z_atual = CD(1:3,3,end);
  S = [0 -z_atual(3) z_atual(2); 0 0 -z_atual(1); 0 0 0];
  S = S-S';  
  ea=sqrt(1.0001-CD(1,3,end));
  x0=[1;0;0];
  J_ea= x0'*S*J_geo(4:6,:)/(2*ea);
  
end

end
