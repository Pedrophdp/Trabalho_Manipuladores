function []=demoaula4(Robod)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Demonstração dos parâmetros de Denavit-Hartenberg
% Deve-se especificar qual o Robô (Robod) que se quer visualisar
% Autor: Vinicius Mariano Gonçalves
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clc;
clf;

if nargin==0
    %Nenhum robô especificado... pega o Robô da Aula 3B
    Robod = Robo.Cria_RoboAula3B();
end

Robo.dispmod('DEMONSTRAÇÃO DE AULA 4');
Robo.dispmod('Mostra as transformações rígidas advindas dos parâmetros do Denavit-Hartenberg');
Robo.dispmod('para o robô escolhido');
Robo.dispmod('Aperte enter para fazer as transformações...');

pause;

C=Cenario(Robod);

Emundo = Eixo(eye(4),0.2*C.eixoref.d,{'x0','y0','z0'});
Eefetuador = Eixo(eye(4),0.2*C.eixoref.d,{'','',''});
E{1} = Eixo(eye(4),0.2*C.eixoref.d,{'','',''});

CorLinkH = [];
CorEixosH = [];
CorEfetuadorH=[];
CorBaseH=[];


C.adicionaobjetos(E{1});
C.adicionaobjetos(Emundo);
C.adicionaobjetos(Eefetuador);

for i = 1: length(Robod.info_links.alfa)
    dabs=abs(Robod.info_links.d(i));
    aabs=abs(Robod.info_links.a(i));
    tam = max(0.5*min(dabs,aabs),0.1);
    E{i+1} = Eixo(eye(4),tam,{' ',' ',' '}); %Robod.mth_baserobo
    C.adicionaobjetos(E{i+1});
    CorLinkH(i,:)=Robod.obj_links(i).cor;
    CorEixosH(i,:)=Robod.obj_eixos(i).cor;
    Robod.obj_links(i).cor=[1 1 1];
    Robod.obj_eixos(i).cor=[0.9 0.9 0.9];
end

CorEfetuadorH = Robod.obj_efetuador.cor;
CorBaseH = Robod.obj_base.cor;

Robod.obj_efetuador.cor=[0.9 0.9 0.9];
Robod.obj_base.cor=[0.9 0.9 0.9];
Robod.obj_eixoefetuador.d=0.000000001;

C.eixoref.d=0.00001;
C.eixoref.nomes={'','',''};
C.limites_desenho = pl(C.limites_desenho);
C.desenha();
alpha(0.1);


%Transforma do eixo 0 para o mundo
Robo.dispmod('----------------------------------------------------------');
Robo.dispmod(['Transformação do eixo 0 (referência) para o eixo ER0' ]);
Robo.dispmod('----------------------------------------------------------');
Robo.dispmod('     ');


pause;

T=Robod.mth*Robod.mth_baserobo;
disp(T);
N=10;


Ex=cell(length(Robod.info_links.alfa)+3,1);
for j = 1: length(Robod.info_links.alfa)+1
   Ex{j}=E{j};
end
Ex{end-1}=  Emundo;  
Ex{end}=  Eefetuador;  

Robo.animaeixo(C,Ex,T,N);
Emundo.nomes={'','',''};
E{1}.nomes={'x0R','y0R','z0R'};
C.desenha();

pause;


for j = 1: length(Robod.info_links.alfa)
    alfa = Robod.info_links.alfa(j);
    d = Robod.info_links.d(j);
    a = Robod.info_links.a(j);
    theta = Robod.info_links.theta(j);
    
    Robo.dispmod('----------------------------------------------------------');
    Robo.dispmod(['Transformação do eixo ER' num2str(j-1) ' para o eixo ER' num2str(j) ]);
    Robo.dispmod('----------------------------------------------------------');
    Robo.dispmod('     ');
    
    %Rotação por z
    Robo.dispmod(['Começamos com uma rotação em torno do eixo z' num2str(j-1) ' de theta = ' num2str(180*theta/3.14) ' graus']);
    if Robod.info_links.tipo(j)==0
        Robo.dispmod('OBS: Essa junta do robô é rotativa, então ela muda de acordo com a configuração!!!');
    end
    
    Robo.dispmod(['Aperte uma tecla para rodar em z' num2str(j-1)]);
    pause;
    Robo.animaeixo(C,E{j+1},Robo.rot('z',theta),ceil(abs(theta)/0.1)+2);
    
    %Deslocamento por d
    Robo.dispmod('     ');
    Robo.dispmod(['Prosseguimos com um deslocamento no eixo z' num2str(j-1) ' de d = ' num2str(d) ' metros']);
    if Robod.info_links.tipo(j)==1
        Robo.dispmod('OBS: Essa junta do robô é prismática, então ela muda de acordo com a configuração!!!');
    end
    
    Robo.dispmod(['Aperte uma tecla para transladar em z' num2str(j-1)]);
    pause;
    Robo.animaeixo(C,E{j+1},Robo.desl([0;0;d]),ceil(abs(d)/0.1)+2);
    C.desenha();
    
    %Rotação em x
    Robo.dispmod('     ');
    Robo.dispmod(['Prosseguimos com uma rotação no eixo x' num2str(j) ' de alfa = ' num2str(180*alfa/3.14) ' graus']);
    
    Robo.dispmod(['Aperte uma tecla para rodar em x' num2str(j)]);
    pause;
    Robo.animaeixo(C,E{j+1},Robo.rot('x',alfa),ceil(abs(alfa)/0.1)+2);
    
    pause;
    Robo.dispmod('     ');
    Robo.dispmod(['Terminamos com um deslocamento no eixo x' num2str(j) ' de a = ' num2str(a) ' m']);
    Robo.dispmod(['Aperte uma tecla para deslocar em x' num2str(j)]);
    pause;
    Robo.animaeixo(C,E{j+1},Robo.desl([a;0;0]),ceil(abs(a)/0.1)+2);
    
    %Coloca o novo nome nele
    E{j+1}.nomes ={['xR' num2str(j)],['yR' num2str(j)],['zR' num2str(j)]};
        
    for i = j+2:length(Robod.info_links.alfa)+1
        E{i}.mth = E{j+1}.mth;
    end
    
    C.desenha();
    drawnow;
    Robo.dispmod('     ');
end


for i = 1: length(Robod.info_links.alfa)
    Robod.obj_links(i).cor=CorLinkH(i,:);
    Robod.obj_eixos(i).cor=CorEixosH(i,:);
end
Robod.obj_efetuador.cor=CorEfetuadorH;
Robod.obj_base.cor=CorBaseH;

    
Robo.dispmod('----------------------------------------------------------');
Robo.dispmod(['Transformação do eixo final para o eixo do efetuador' ]);
Robo.dispmod('----------------------------------------------------------');
Robo.dispmod('     ');
pause;

def=Robod.efetuador.h_link+Robod.efetuador.h_ponta;
T=Robod.efetuador.mth_fim_ef*Robo.desl([0;0;def]);
disp(T);

Eefetuador.mth=E{end}.mth;
Eefetuador.nomes={'','',''};

Robo.animaeixo(C,Eefetuador,T,10);
Eefetuador.nomes={'xef','yef','zef'};
C.desenha();


Robo.dispmod('FIM!');


end


function LimNovo=pl(Lim)
    cx = 0.5*(Lim(1)+Lim(2));
    cy = 0.5*(Lim(3)+Lim(4));
    cz = 0.5*(Lim(5)+Lim(6));
    dx = 0.5*(-Lim(1)+Lim(2));
    dy = 0.5*(-Lim(3)+Lim(4));
    dz = 0.5*(-Lim(5)+Lim(6));

    LimNovo(1) = cx -0.7*dx;
    LimNovo(2) = cx +0.7*dx;
    LimNovo(3) = cy -0.7*dy;
    LimNovo(4) = cy +0.7*dy;
    LimNovo(5) = cz -dz;
    LimNovo(6) = cz +dz;


end
