function Rb= Cria_RoboPlanar(n,T_in)
%Robô planar de n links com juntas rotativas

if nargin==0
  n=6;
  T_in=eye(4);    
end

if nargin==1
  T_in=eye(4);    
end

%Cria informações dos links
theta=cumsum(rand(1,n)/n);
d=zeros(n,1);
alfa=zeros(n,1);
a=ones(n,1)/n;
R = 0.06*ones(n,1);
h = ones(n,1)/n;
CorLinks=repmat(rand(1,3),n,1);
CorEixos=repmat(rand(1,3),n,1);
rho=1000*ones(n,1);
tipo =zeros(1,n);

limites_q = [-pi/3*ones(n,1) (pi/3)*ones(n,1)];
limites_dotq = [-pi*ones(n,1) pi*ones(n,1)];
limites_torque = [-500*ones(n,1) 500*ones(n,1)];
friccao=0.8*eye(n);
desl = zeros(1,n+1);

ilinks = InfoLinks(alfa,d,a,theta,desl,R,h,CorLinks,CorEixos,rho,tipo,limites_q,limites_dotq,limites_torque,friccao);


%Tamanho do efetuador
efetuador = Efetuador(Robo.rot('y',pi/2),0,0,CorLinks(1,1:3),0.03,0.03,[0.2 0.2 0.2]);

%Transformação base
Tbase=[ [0; 0 ; 1] [1; 0; 0] [0; 1; 0] zeros(3,1); zeros(1,3) 1 ];



%Parâmetros de controlador
errodinam=0.05;
kpv=80;
kiv=(kpv/2)^2;
kpq=2;
kppose=3;
kdcg=1;
Cont=ControladorRobo(errodinam,kpv,kiv,kpq,kppose,kdcg);

%Cor da base
CBase=[1.0000 0.5490 0];

%Cria o robô
Rb = Robo(['Robô planar de ' num2str(n) ' juntas'],ilinks,efetuador,T_in,Tbase,Cont,CBase);

end