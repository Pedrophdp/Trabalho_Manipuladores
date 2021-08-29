function Rb = Cria_Jaco(T_in)
%Cria um robô Jaco

if nargin==0
  T_in=eye(4);    
end

%Cria informações dos links
%d=16.38*[15.43 7.57 -3.93 12.99 0 5.31]/1000;
%a=16.38*[0 0 15.74 0 0 0]/1000;
%alfa=[0 -pi/2 0 -pi/2 pi/2 0]; 
%theta=[pi/2 -pi/2 0 0 0 0];

D1=0.2755;
D2=0.4100;
D3=0.2073;
D4=0.0743;
D5=0.0743;
D6=0.1687;
e2=0.0098;
aa = 11*pi/72;
ca = cos(aa);
sa = sin(aa);
c2a = cos(2*aa);
s2a = sin(2*aa);
d4b = D3+(sa/s2a)*D4;
d5b=(sa/s2a)*D4 + (sa/s2a)*D5 ;
d6b=(sa/s2a)*D5 + D6 ;

d=[D1 0 -e2 -d4b -d5b -d6b ];
a=[0 D2 0 0 0 0];
alfa=[pi/2 pi pi/2 2*aa 2*aa pi]; 
theta=[0 0 0 0 0 0];


R = 0.05*ones(6,1);
h = [0.3 0.45 0 0.3 0.1 0.22];
CorLinks=repmat([0.2 0.2 0.1],6,1);
CorEixos=repmat([0.9 0.9 0.9],6,1);
rho=578*ones(6,1);
tipo =[0 0 0 0 0 0];

limites_q=(pi/180)*[-170 170; -190 45; -119 166; -190 190; -120 120; -350 350];
limites_dotq=[-(2*pi)*ones(6,1)  (2*pi)*ones(6,1)];
limites_torque=[-(500)*ones(6,1)  (500)*ones(6,1)];
friccao=0.8*eye(6);
desl=zeros(1,7);

DH = InfoLinks(alfa,d,a,theta,desl,R,h,CorLinks,CorEixos,rho,tipo,limites_q,limites_dotq,limites_torque,friccao);

%Configurações do efetuador
efetuador = Efetuador(eye(4),0,0,[0 0 0],0.02,0.05,[0.6 0.6 0.6]);

%Transformação base
Tbase=eye(4);
Tbase(3,4)=0.03;
Tbase=Tbase;


%Parâmetros de controlador
errodinam=0.05;
kpv=100;
kiv=(kpv/2)^2;
kpq=2;
kppose=3;
kdcg=1;
Cont=ControladorRobo(errodinam,kpv,kiv,kpq,kppose,kdcg);

%Cor da base
CBase=[0.9 0.9 0.9];

%Cria o robô
Rb = Robo('Jaco',DH,efetuador,T_in,Tbase,Cont,CBase);
end