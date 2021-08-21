function Rb = Cria_Cartesiano(T_in)
%Cria um robô cartesiano 

if nargin==0
  T_in=eye(4);    
end

%Cria informações dos links
theta=[pi/2 pi/2 pi/2];
d=[0.5 0.5 0.5];
alfa=[pi/2 pi/2 0];
a=[0 0 0];
R = 0.09*ones(3,1);
h = [1 1 1];
CorLinks=repmat([1 0.3 0.3],6,1);
CorEixos=repmat([0.3 1 0.3],6,1);
rho=1000*ones(6,1);

tipo =[1 1 1];

limites_q = [0.2*ones(3,1) 0.8*ones(3,1)];
limites_dotq = [-pi*ones(3,1) pi*ones(3,1)];
limites_torque = [-500*ones(3,1) 500*ones(3,1)];
friccao=0.8*eye(3);
desl=[0 0 0 0];

ilinks = InfoLinks(alfa,d,a,theta,desl,R,h,CorLinks,CorEixos,rho,tipo,limites_q,limites_dotq,limites_torque,friccao);

%Tamanho do efetuador
%Configurações do efetuador
efetuador = Efetuador(eye(4),0,0,[0 0 0],0.02,0.05,[0.2 0.2 0.2]);


%Densidade dos links
rho=578*ones(3,1);

%Transformação base
Tbase=eye(4);
Tbase(3,4)=0.06;


%Parâmetros de controlador
errodinam=0.05;
kpv=50;
kiv=(kpv/2)^2;
kpq=1;
kppose=3;
kdcg=1;
Cont=ControladorRobo(errodinam,kpv,kiv,kpq,kppose,kdcg);

%Cor da base
CBase=[0.1 0.1 0.1];

%Cria o robô
Rb = Robo('Cartesiano',ilinks,efetuador,T_in,Tbase,Cont,CBase);



end