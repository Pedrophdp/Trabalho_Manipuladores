function Rb = Cria_KukaKR5(T_in)
%Cria um Kuka kr5 Sixx R650

if nargin==0
  T_in=eye(4);    
end

%Limites de configuração de juntas
% 1: -170 a 170 graus
% 2: -190 a 45 graus
% 3: -119 a 166 graus
% 4: -190 a 190 graus
% 5: -120 a 120 graus
% 6: -350 a 350 graus
%Velocidades máximas das juntas
% 1,2,3: 2*pi rad/s
% 4,5: 2.2*pi rad/s
% 6: 3.6*pi rad/s
% Massa total: 28 kg
%Torque máximo 1000Nm
%Parâmetros de Denavit Hartenberg
%[-pi/2 .335 .075; 0 0 .270; pi/2 0 .09; -pi/2 -.295 0; pi/2 0 0; pi -.080 0]

%Parâmetros de Denavit-Hartenberg
% DH=[-pi/2 .335 .075; 0 0 .270; pi/2 0 .09; -pi/2 -.295 0; pi/2 0 0; pi -.080 0];
% DH = [DH(:,2) DH(:,3) DH(:,1)];

alfa = [-pi/2 0 pi/2 -pi/2 pi/2 pi];
d = [.335 0 0 -.295 0 -.08];
a = [.075 .27 .09 0 0 0];
theta=[pi/2 -pi/2 0 0 0 0];
R = 0.12*ones(6,1);
h = [0.3433 0.27 0.09 0.295 0 0.08];
tipo =[0 0 0 0 0 0];
CorLinks=repmat([0.8 0.8 0.8],6,1);
CorEixos=repmat([1.0000 0.5490 0],6,1);
rho=578*ones(6,1);
desl = zeros(7,1);

limites_q = (pi/180)*[-170 170; -190 45; -119 60; -190 190; -120 120; -350 350];
limites_dotq = (pi/180)*[-360 360; -360 360; -360 360; -432 432; -432 432; -648 648];
limites_torque=[-(500)*ones(6,1)  (500)*ones(6,1)];
friccao=0.8*eye(6);

ilinks = InfoLinks(alfa,d,a,theta,desl,R,h,CorLinks,CorEixos,rho,tipo,limites_q,limites_dotq,limites_torque,friccao);


%Configurações do efetuador
efetuador = Efetuador(eye(4),0,0,[0 0 0],0.05,0.1,[0.2 0.2 0.2]);

%Transformação base
Tbase=eye(4);
Tbase(3,4)=0.06;

%Parâmetros de controlador
errodinam=0.05;
kpv=50;
kiv=(kpv/2)^2;
kpq=2;
kppose=3;
kdcg=1;
Cont=ControladorRobo(errodinam,kpv,kiv,kpq,kppose,kdcg);

%Cor da base
CBase=[1.0000 0.5490 0];

%Cria o robô
Rb = Robo('KukaKR5',ilinks,efetuador,T_in,Tbase,Cont,CBase);


end