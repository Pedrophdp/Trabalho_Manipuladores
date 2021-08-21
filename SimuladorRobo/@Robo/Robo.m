classdef Robo< ObjetosFisicos & handle & matlab.mixin.CustomDisplay
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Objeto Rob�
% Autor: Vinicius Mariano Gon�alves
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

   properties 
     
     %mth %Transforma��o homogenea do rob� (Implementado na classe abstrata)
     %densidade %Densidade do rob�  (Implementado na classe abstrata)
     %estatico; %Se o objeto � est�tico ou n�o (Implementado na classe abstrata)
     
     %Par�metros de entrada
     nome %Nome do rob�
     mth_baserobo %Transforma��o do mundo para base do rob�
     info_links %Informa��es dos Links 
     efetuador %Informa��es do efetuador
     cor_base %Cor da base
     controlador %Controlador do rob� 
     q; %Configura��o atual do rob�
     obj_noefetuador %Objetos contidos no efetuador
     
   end
   
   properties (Hidden=true)
    %Propriedades escondidas
    
    %limites_desenho %Limites para desenhar (Implementado na classe abstrata)
    obj_links; %Objetos "Cilindro" representando o link
    obj_eixos% Objetos "Cilindro" representando os eixos
    obj_base; %Objeto "Paralelepipedo" representando a base
    obj_link_efetuador %Objeto "Cilindro" representando o link antes do efetuador
    obj_efetuador %Objeto "Cilindro" representando o efetuador
    obj_eixoefetuador %Objeto "Eixo" representando o eixo do efetuador
    
    
    mth_objefetuador %mth com relacao ao efetuador de cada objeto
    
   end
   
   methods (Access=protected)
       
       function displayScalarObject(obj)
           disp('---------------------------------------------------------------------');
           disp(['Rob� "' obj.nome '"']);
           disp('Matriz de transforma��o homog�nea');
           disp(obj.mth_baserobo);
           disp(['N�mero de links: ' num2str(length(obj.info_links.tipo))]);
           disp(['N�mero de juntas cil�ndricas: ' num2str(length(find(obj.info_links.tipo==0)))]);
           disp(['N�mero de  Juntas prism�ticas: ' num2str(length(find(obj.info_links.tipo==1)))]);
           disp('Configura��o atual');
           disp(obj.q');
           disp('---------------------------------------------------------------------');
       end
       
       
   end   
   
   methods (Static)
       
       
       %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
       % ROB�S PR�-CONSTRU�DOS                    %
       %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
       
       Rb = Cria_KukaKR5(T_in)
       Rb = Cria_Jaco(T_in)
       Rb= Cria_RoboPlanar(n,T_in)
       Rb = Cria_Cartesiano(T_in)
       Rb = Cria_RoboAula3A(T_in)
       Rb = Cria_RoboAula3B(T_in)
       Rb = Cria_Snake(T_in,n)


       
       %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
       % DEMONSTRA��ES                            %
       %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
       
       %Demonstra��o de rota��o de objeto
       []=demoaula1(eixo,theta)
       %Demonstra��o de transforma��o de eixos
       []=demoaula2()
       %Demonstra��o dos eixos no rob� da Aula 3
       [] = demoaula3(theta1,theta2,theta3)
       %Demonstra��o do Denavit Hartenberg
       []=demoaula4(Robod)
       
       %Demonstra��o de controle 1
       [] = democontrole1()
       %Demonstra��o de controle 1
       [] = democontrole2()       


       %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
       % FUN��ES EST�TICAS                        %
       %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
       
       %CINEM�TICA
       
       %Fun��o para calcular o erro cooperativo
       [ecoop,Jecoop] = errocoop(R1,R2,q1,q2,T_rel_des,T_med_des)
       
       %FUN��ES AUXILIARES
       
       %Faz uma rota��o nos eixos elementares (x,y,z)
       T=rot(eixo,theta)
       %Faz uma transla��o
       T=desl(d)
       %Calcula os angulos de euler (zyx)
       [a,b,c] = angulosdeeuler(R)
       %Mostra uma vari�vel
       []=dsp(nome,valor);
       %Cria matriz de produto vetorial
       S = matrizprodv(a)
       %Cria um frame alinhado
       [T3,delta] = framealinhado(T1,T2,h,tipo)
       %Calcula a matriz jacobiana de uma fun��o f(q)
       J = calcjacobiana(f,q)
       %Calcula um vetor de dist�ncia entre duas poses
       D=distpose(T1,T2)
       %Dada uma matriz de transforma��o homog�nea, calcula o respectivo
       %eixo
       [w,theta] = retornaeixo(T);
       %Calcula a raiz n-esima de uma mth
       Tr = raizmth(T,n)
       %Mostra o texto sem quebrar a tela
       [] = dispmod(str);
       %Runge Kutta de quarta ordem
       [Q,t]=rk4(f,dur_t,Q0,dt)
       %Anima de um eixo at� o outro
       [] = animaeixo(C,Einit,T,N)
       %Fun��o para controle
       f = funcontrole(x,a,tol_e)
       %Fun��o para calcular a pseudoinversa amortecida
       Jinv = pinvam(J,fat);
       %Gera uma curva parametrizada
       f = criacurva(param)
       %Faz uma interpola��o baseado em pontos
       f = sminterp(x)
       %Plota curvas
       [] = plota(t,X,titulo,nomeeixo,nomevar);
        
   end
   
   methods
       
       function obj = Robo(nome_in,info_links_in,efetuador_in,T_in,Tbr_in,Controlador_in,CorBase_in)
       %Construtor da classe
 
         %Atribui as vari�veis
         obj.nome=nome_in;
         obj.info_links=info_links_in;
         obj.efetuador=efetuador_in;   
         obj.mth=T_in;
         obj.mth_baserobo=Tbr_in;
         obj.cor_base=CorBase_in;
         obj.controlador=Controlador_in;
         
         %Inicializa a lista de links e eixos
         obj.obj_links=[];
         obj.obj_eixos=[];
         
         %Retorna a configura��o inicial
         obj.q=obj.info_links.retconfig();
         
         %N�o � um objeto est�tico
         obj.estatico=0;
         
         %Calcula os limites para poder desenhar
         obj.limites_desenho= obj.calculalimites();
         %Monta os objetos para desenhar
         obj.config(obj.q);
         
         %Calcula a densidade
         obj.densidade=obj.calculadensidade();
                 
       end
             
       %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
       % FUN��ES DA CLASSE                        %
       %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
       
       %FUN��ES GERAIS
       
       %Fun��o para desenhar o rob� e todos os objetos envolvidos
       [Dados,indice_saida,Handleout] =desenha(obj,Handlein,indices)
       %Fun��o para colocar o rob� em uma configura��o q
       [] = config(obj,q)
       %Dist�ncia entre configura��es
       D = distconfig(obj,q1,q2)
       %Caminho entre configura��es com 'nopontos' pontos
       D = caminhoconfig(obj,q1,q2,nopontos)
       
       %CINEM�TICA DIRETA NORMAL/DIFERENCIAL
       
       %Fun��o para calcular o vetor operacional (posi��o e �ngulos de
       %Euler) para o efetuador
       [r,CD] = vetorop(obj,q)
       %Fun��o de cinem�tica direta para um ponto em um topo do
       %link, no centro do link ou no efetuador
       CD = cinematicadir(obj,q,ponto);
       %Fun��o de cinem�tica inversa
       q_s = cinematicainv(obj,T_des,iter_max,tol)
       %Fun��o para calcular a matriz jacobiana geometrica em um ponto no topo do
       %link, no centro do link ou no efetuador
       [Jg,CD] = jacobianageo(obj,q,ponto)
       %Fun��o de cinem�tica direta para um ponto generico
       [ponto_novo,J] = cinematicadirgen(obj,q,qref,ponto)
       %Fun��o para calcular a matriz jacobiana anal�tica do vetor
       %operacional
       [Ja,CD] = jacobianaan(obj,q)
       %Fun��o para calcular o erro de pose do efetuador
       %com rela��o � uma pose Talvo. Retorna tamb�m a matriz jacobiana
       %para realizar controle
       [er,J]=erropose(obj,q,Tdes)
       %Calcula a dist�ncia com rela��o a um ponto
       [pmp_obj,Dist] = calcdistponto(obj,p)
       %Calcula a dist�ncia com rela��o a outro objeto
       [Dist,pmp_obj,pmp_obj2] = calcdistancia(obj,obj2,pinit);
       %Calcula a dist�ncia com rela��o a outro objeto em uma configura��o
       %gen�rica q
       [Dist,xmp_obj,xmp_obj2] =calcdistanciagen(obj,obj2,q)
       %Calcula a dist�ncia r�pida entre o rob� e um objeto
       [D,pmp1,pmp2] = calcdistanciarap(obj,obj2,dtol,pinit)
       %Calcula as dist�ncias com rela��o a uma cole��o de objetos
       %obj_lista e retorna tamb�m as jacobianas da fun��o dist�ncia em uma
       %configura��o gen�rica q. S� retorna se a dist�ncia for maior que
       %tol
       [D,JD,pmp_obj,pmp_lista] = obstaculo(obj,q,lista_obj,tol)

       
       
       %PAR�METROS INERCIAIS/ENERGIA
       
       %Calcula a matriz de inercia do rob� na configura��o q
       In=matrizdeinercia(obj,q)
       %Calcula o torque devido a gravidade na configura��o q
       taug=torquegravitacional(obj,q)
       %Calcula o torque de coriolis na configura��o q e velocidade qdot
       [taucc,dKdq,C]=torquecc(obj,q,qdot);
       %Fun��o para calcular o simbolo de Christoffel em uma configura��o q
       [C,dMdq] = simbolochristoffel(obj,q)
       %Calcula a energia potencial gravitacional
       V = energiapotencialgrav(obj,q);
       %Calcula a energia cin�tica
       K = energiacinetica(obj,q,dotq);
       %Calcula a energia mec�nica do sistema
       [E,K,V] = energiamecanica(obj,q,dotq)
       %Calcula a massa do rob�
       M = massa(obj)
       
       
       
       %FUN��ES PARA CONTROLE
       
       %Simulador de entrada de torque
       [Q,dotQ,Tor,t] = cmdtorque(obj,tau,mem,q0,dotq0,dur_t)
       %Simulador de entrada de velocidade
       [Q,dotQ,Tor,t] = cmdvelocidade(obj,dotqref,q0,dotq0,dur_t)
       %Simulador de entrada de configura��o
       [Q,dotQ,Tor,t] = cmdconfig(obj,qref,q0,dotq0,dur_t)
       %Simulador de entrada de pose
       [Q,dotQ,Tor,t] = cmdpose(obj,Tref,q0,dotq0,dur_t) 
       %Simulador de compensa��o de gravidade
       [Q,dotQ,Torq,t] = compgravidade(obj,V,q0,dotq0,dur_t)
       
       
       %INTERA��O COM O AMBIENTE
       []=grudaobjeto(obj,obj_grudar)
       
       
       
       %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
       % FUN��ES AUXILIARES                       %
       %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
       Limites = calculalimites(obj)
       D = calculadensidade(obj)
    
   end
end