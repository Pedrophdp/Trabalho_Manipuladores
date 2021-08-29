function Rb = Cria_Snake(m,T_in)
%Cria um Kuka kr5 Sixx R650

if nargin==1
  T_in=eye(4);    
end

n = 3*floor(m);


for i = 1: n

theta(i)=pi/2;
alfa(i)=pi/2;

if mod(i,3)==0
  a(i)=0;
  d(i)=3/n;
  R(i)=0.05;
  h(i)=d(i);
  tipo(i)=0;
else
  a(i)=0.0001;
  d(i)=0.0001;
  R(i)=0.05;
  h(i)=d(i);
  tipo(i)=0;    
end
    
end
theta(2)=pi;

cors=[0.6 0.6 0.9];
CorLinks=repmat([1 1 1],n,1);
CorEixos=repmat(cors,n,1);
rho=578*ones(n,1);
desl = zeros(n+1,1);


limites_q = 100*[-ones(n,1) ones(n,1)];
limites_dotq = 100*[-ones(n,1) ones(n,1)];
limites_torque=[-(500)*ones(n,1)  (500)*ones(n,1)];
friccao=0.8*eye(n);

ilinks = InfoLinks(alfa,d,a,theta,desl,R,h,CorLinks,CorEixos,rho,tipo,limites_q,limites_dotq,limites_torque,friccao);


%Configurações do efetuador
efetuador = Efetuador(Robo.rot('x',-pi/2),0.05,0.01,[1 1 1],0.01,0.2,[0.4 0.8 0.4]); %;

%Transformação base
Tbase=Robo.rot('x',pi/2);
Tbase=eye(4);
Tbase(3,4)=0.06;

%Parâmetros de controlador
errodinam=0.05;
kpv=120;
kiv=(kpv/2)^2;
kpq=0.5;
kppose=3;
kdcg=1;
Cont=ControladorRobo(errodinam,kpv,kiv,kpq,kppose,kdcg);

%Cor da base
CBase=cors;

%Cria o robô
Rb = Robo('Snake',ilinks,efetuador,T_in,Tbase,Cont,CBase);


end