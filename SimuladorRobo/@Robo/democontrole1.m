function [] = democontrole1()

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Demonstração de controle 1
% Autor: Vinicius Mariano Gonçalves
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



clc;
clf;

disp('DEMONSTRAÇÃO DE CONTROLE 1');
disp('O robô KukaKR5 deve desenhar uma circunferência em um quadro branco');
disp('Para isso ele deve usar uma caneta que está em seu efetuador');
disp('Note que não só devemos controlar a posição x,y,z do efetuador');
disp('mas também a orientação do efetuador, que deve ser paralela à do quadro');
disp('Obs: Controle puramente cinemático, sem considerar a dinâmica do robô');
disp('colisões, limite de juntas, etc...');


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Cria o cenário
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%Cria robô KukaKR5
Rb= Robo.Cria_KukaKR5();


%Cria um quadro
T=eye(4);
T(1:3,4)=[0.6;0;0.5];
Quadro = Paralelepipedo(T,[0.05 0.9 0.8],[0.9 0.9 0.9],1);
Quadro.estatico=1;
%Cria uma nuvem de pontos que vai ser desenhada, inicialmente vazia
Npontos = NuvemPontos([],[],[],[128 0 128]/255,'-');

%Cria um cenário com o robô
C = Cenario(Rb);
%Adiciona o quadro
C.adicionaobjetos(Quadro);
%Adiciona a nuvem de pontos
C.adicionaobjetos(Npontos);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Controle para desenhar um círculo
% no quadro
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%Parâmetros do círculo paralelo ao eixo yz
%pc=0.5;
pc=[0.6; 0; 0.5]; 
r=0.25;
t=0;
dt=0.04; %dt=0.02;
w=0.02;
t=0;

%Parâmetros do controlador: ganho proporcional
kp=2;

%Inicializações
errox_hist=[];
erroraio_hist=[];
erroenagulo_hist=[];
t_hist=[];
i=1;

while t<100
    
    %Variável auxiliar que guarda a configuração atual
    q=Rb.q;
    
    %Computa algumas informações úteis
    
    %Vetor operacional com a cinemática direta
    [vop,CD] = Rb.vetorop(q);
    %Jacobiana geométrica
    J_geo =  Rb.jacobianageo(q,'efetuador');
  
    %Calcula a velocidade (x,y,z) do efetuador desejada
    ved = campovetorial(vop(1:3),pc,r);
    %Captura a jacobiana da posição na jacobiana geométrica
    J_p = J_geo(1:3,:);
    
    %Calcula o erro de alinhamento do eixo z do efetuador com o eixo
    %x de referência (x0). Também retorna a jacobiana
    [ea,J_ea] = erro_angulo(CD,J_geo);
    
    %As equações são J_p*dotq = v, J_ea*dotq=-kp*ea
    %ou J dotq = v_total
    J = [J_p; J_ea];
    v_total = [ved; -kp*ea];


    %Calcula a velocidade no espaço de configuração usando
    %a pseudoinversa amortecida da jacobiana
    dotq=(J'*J+0.01*eye(6))\(J'*v_total);
    
    %Guarda os históricos
    errox_hist(i)= vop(1)-pc(1);
    erroraio_hist(i)=sqrt( (vop(2)-pc(2))^2+(vop(3)-pc(3))^2 )-r;
    erroenagulo_hist(i)=180*acos(max(min(1-ea^2,1),-1))/pi;
    t_hist(i)=t;

    %Integra a velocidade
    q=q+dotq*dt;
    

    
    t=t+dt;
    i=i+1;
    
    %Desenha e pega algumas informações, mas só de 0.5 em 0.5 segundos
    if mod(i,floor(0.2/dt))==0
        %Adiciona na nuvem de pontos a trajetória do efetuador, mas só
        %se tiver perto do quadro (simula a caneta no efetuador)       
        if abs(vop(1)-pc(1))<=0.01
         C.lst_obj_desenhaveis{end}.adicionapontos(vop(1)-0.03,vop(2),vop(3));
        end
    
        %Desenha o robô
        Rb.config(q);
        C.desenha();
              
        %Movie=getframe();
        drawnow;
    end
end

clf;
%Desenha as estatísticas
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
 %Campo vetorial dp/dt = v(p) para seguir um círculo
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
%ea = sqrt(1 - cos(theta)), em que theta é o ângulo entre o eixo z do
%efetuador e x de referência
%Retorna também outras informações que serão úteis posteriormente

  z_atual = CD(1:3,3,end);
  S = [0 -z_atual(3) z_atual(2); 0 0 -z_atual(1); 0 0 0];
  S = S-S';  
  ea=sqrt(1.0001-CD(1,3,end));
  x0=[1;0;0];
  J_ea= x0'*S*J_geo(4:6,:)/(2*ea);
  
end

end
