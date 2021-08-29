function Rb = Cria_RoboAula3A(T_in)
%Cria o robô da aula 3

if nargin==0
  T_in=eye(4);    
end



theta=[0 0 0];
d=[0.5 0 0];
alfa=[pi/2 0 -pi/2];
a = [0 0.3 0.3];

R = 0.07*ones(3,1);
h = [0.5 0.3 0.3];
tipo =[0 0 0];
CorLinks=repmat([0.29 0.59 0.82],3,1);
CorEixos=repmat([0 1 0],3,1);
rho=578*ones(3,1);

limites_q = [-pi pi; -pi pi; -pi pi];
limites_dotq = [-1 1; -1 1; -1 1];
limites_torque=[-(500)*ones(3,1)  (500)*ones(3,1)];
friccao=0.8*eye(3);

desl=zeros(1,4);

ilinks = InfoLinks(alfa,d,a,theta,desl,R,h,CorLinks,CorEixos,rho,tipo,limites_q,limites_dotq,limites_torque,friccao);


%Tamanho do efetuador
efetuador = Efetuador(Robo.rot('y',pi/2),0,0,[0 0 0],0.03,0.03,[0.2 0.2 0.2]);

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
Rb = Robo('Antropomórfico (Aula3)',ilinks,efetuador,T_in,Tbase,Cont,CBase);


end