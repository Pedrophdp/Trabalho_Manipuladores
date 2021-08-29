function Rb = Cria_RoboAula3B(T_in)
%Cria o robô da aula 3

if nargin==0
  T_in=eye(4);    
end



theta=[pi/2 pi/2 pi];
d=[0.6 0.2 0.3];
alfa=[pi/2 pi/2 pi/2];
a = [0.2 0 0];

R = 0.06*ones(3,1);
h = [0.7 sqrt(0.2^2+0.3^2) 0];
tipo =[0 0 0];
CorLinks=repmat([0.8 0.8 0.8],3,1);
CorEixos=repmat([0 1 0],3,1);
rho=578*ones(3,1);

limites_q = [-pi pi; -pi pi; -pi pi];
limites_dotq = [-1 1; -1 1; -1 1];
limites_torque=[-(500)*ones(3,1)  (500)*ones(3,1)];
friccao=0.8*eye(3);

desl=[0 0 0.3 0];

ilinks = InfoLinks(alfa,d,a,theta,desl,R,h,CorLinks,CorEixos,rho,tipo,limites_q,limites_dotq,limites_torque,friccao);


%Efetuador
efetuador = Efetuador(eye(4),0.07,0.15,[0.8 0.8 0.8],0.03,0.03,[0.2 0.2 0.2]);

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
Rb = Robo('Robô Exemplo DH (Aula3)',ilinks,efetuador,T_in,Tbase,Cont,CBase);


end