classdef Robo< ObjetosFisicos & handle & matlab.mixin.CustomDisplay
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Objeto Robô
% Autor: Vinicius Mariano Gonçalves
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

   properties 
     
     %mth %Transformação homogenea do robô (Implementado na classe abstrata)
     %densidade %Densidade do robô  (Implementado na classe abstrata)
     %estatico; %Se o objeto é estático ou não (Implementado na classe abstrata)
     
     %Parâmetros de entrada
     nome %Nome do robô
     mth_baserobo %Transformação do mundo para base do robô
     info_links %Informações dos Links 
     efetuador %Informações do efetuador
     cor_base %Cor da base
     controlador %Controlador do robô 
     q; %Configuração atual do robô
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
           disp(['Robô "' obj.nome '"']);
           disp('Matriz de transformação homogênea');
           disp(obj.mth_baserobo);
           disp(['Número de links: ' num2str(length(obj.info_links.tipo))]);
           disp(['Número de juntas cilíndricas: ' num2str(length(find(obj.info_links.tipo==0)))]);
           disp(['Número de  Juntas prismáticas: ' num2str(length(find(obj.info_links.tipo==1)))]);
           disp('Configuração atual');
           disp(obj.q');
           disp('---------------------------------------------------------------------');
       end
       
       
   end   
   
   methods (Static)
       
       
       %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
       % ROBÔS PRÉ-CONSTRUÍDOS                    %
       %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
       
       Rb = Cria_KukaKR5(T_in)
       Rb = Cria_Jaco(T_in)
       Rb= Cria_RoboPlanar(n,T_in)
       Rb = Cria_Cartesiano(T_in)
       Rb = Cria_RoboAula3A(T_in)
       Rb = Cria_RoboAula3B(T_in)
       Rb = Cria_Snake(T_in,n)


       
       %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
       % DEMONSTRAÇÕES                            %
       %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
       
       %Demonstração de rotação de objeto
       []=demoaula1(eixo,theta)
       %Demonstração de transformação de eixos
       []=demoaula2()
       %Demonstração dos eixos no robô da Aula 3
       [] = demoaula3(theta1,theta2,theta3)
       %Demonstração do Denavit Hartenberg
       []=demoaula4(Robod)
       
       %Demonstração de controle 1
       [] = democontrole1()
       %Demonstração de controle 1
       [] = democontrole2()       


       %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
       % FUNÇÕES ESTÁTICAS                        %
       %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
       
       %CINEMÁTICA
       
       %Função para calcular o erro cooperativo
       [ecoop,Jecoop] = errocoop(R1,R2,q1,q2,T_rel_des,T_med_des)
       
       %FUNÇÕES AUXILIARES
       
       %Faz uma rotação nos eixos elementares (x,y,z)
       T=rot(eixo,theta)
       %Faz uma translação
       T=desl(d)
       %Calcula os angulos de euler (zyx)
       [a,b,c] = angulosdeeuler(R)
       %Mostra uma variável
       []=dsp(nome,valor);
       %Cria matriz de produto vetorial
       S = matrizprodv(a)
       %Cria um frame alinhado
       [T3,delta] = framealinhado(T1,T2,h,tipo)
       %Calcula a matriz jacobiana de uma função f(q)
       J = calcjacobiana(f,q)
       %Calcula um vetor de distância entre duas poses
       D=distpose(T1,T2)
       %Dada uma matriz de transformação homogênea, calcula o respectivo
       %eixo
       [w,theta] = retornaeixo(T);
       %Calcula a raiz n-esima de uma mth
       Tr = raizmth(T,n)
       %Mostra o texto sem quebrar a tela
       [] = dispmod(str);
       %Runge Kutta de quarta ordem
       [Q,t]=rk4(f,dur_t,Q0,dt)
       %Anima de um eixo até o outro
       [] = animaeixo(C,Einit,T,N)
       %Função para controle
       f = funcontrole(x,a,tol_e)
       %Função para calcular a pseudoinversa amortecida
       Jinv = pinvam(J,fat);
       %Gera uma curva parametrizada
       f = criacurva(param)
       %Faz uma interpolação baseado em pontos
       f = sminterp(x)
       %Plota curvas
       [] = plota(t,X,titulo,nomeeixo,nomevar);
        
   end
   
   methods
       
       function obj = Robo(nome_in,info_links_in,efetuador_in,T_in,Tbr_in,Controlador_in,CorBase_in)
       %Construtor da classe
 
         %Atribui as variáveis
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
         
         %Retorna a configuração inicial
         obj.q=obj.info_links.retconfig();
         
         %Não é um objeto estático
         obj.estatico=0;
         
         %Calcula os limites para poder desenhar
         obj.limites_desenho= obj.calculalimites();
         %Monta os objetos para desenhar
         obj.config(obj.q);
         
         %Calcula a densidade
         obj.densidade=obj.calculadensidade();
                 
       end
             
       %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
       % FUNÇÕES DA CLASSE                        %
       %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
       
       %FUNÇÕES GERAIS
       
       %Função para desenhar o robô e todos os objetos envolvidos
       [Dados,indice_saida,Handleout] =desenha(obj,Handlein,indices)
       %Função para colocar o robô em uma configuração q
       [] = config(obj,q)
       %Distância entre configurações
       D = distconfig(obj,q1,q2)
       %Caminho entre configurações com 'nopontos' pontos
       D = caminhoconfig(obj,q1,q2,nopontos)
       
       %CINEMÁTICA DIRETA NORMAL/DIFERENCIAL
       
       %Função para calcular o vetor operacional (posição e ângulos de
       %Euler) para o efetuador
       [r,CD] = vetorop(obj,q)
       %Função de cinemática direta para um ponto em um topo do
       %link, no centro do link ou no efetuador
       CD = cinematicadir(obj,q,ponto);
       %Função de cinemática inversa
       q_s = cinematicainv(obj,T_des,iter_max,tol)
       %Função para calcular a matriz jacobiana geometrica em um ponto no topo do
       %link, no centro do link ou no efetuador
       [Jg,CD] = jacobianageo(obj,q,ponto)
       %Função de cinemática direta para um ponto generico
       [ponto_novo,J] = cinematicadirgen(obj,q,qref,ponto)
       %Função para calcular a matriz jacobiana analítica do vetor
       %operacional
       [Ja,CD] = jacobianaan(obj,q)
       %Função para calcular o erro de pose do efetuador
       %com relação à uma pose Talvo. Retorna também a matriz jacobiana
       %para realizar controle
       [er,J]=erropose(obj,q,Tdes)
       %Calcula a distância com relação a um ponto
       [pmp_obj,Dist] = calcdistponto(obj,p)
       %Calcula a distância com relação a outro objeto
       [Dist,pmp_obj,pmp_obj2] = calcdistancia(obj,obj2,pinit);
       %Calcula a distância com relação a outro objeto em uma configuração
       %genérica q
       [Dist,xmp_obj,xmp_obj2] =calcdistanciagen(obj,obj2,q)
       %Calcula a distância rápida entre o robô e um objeto
       [D,pmp1,pmp2] = calcdistanciarap(obj,obj2,dtol,pinit)
       %Calcula as distâncias com relação a uma coleção de objetos
       %obj_lista e retorna também as jacobianas da função distância em uma
       %configuração genérica q. Só retorna se a distância for maior que
       %tol
       [D,JD,pmp_obj,pmp_lista] = obstaculo(obj,q,lista_obj,tol)

       
       
       %PARÂMETROS INERCIAIS/ENERGIA
       
       %Calcula a matriz de inercia do robô na configuração q
       In=matrizdeinercia(obj,q)
       %Calcula o torque devido a gravidade na configuração q
       taug=torquegravitacional(obj,q)
       %Calcula o torque de coriolis na configuração q e velocidade qdot
       [taucc,dKdq,C]=torquecc(obj,q,qdot);
       %Função para calcular o simbolo de Christoffel em uma configuração q
       [C,dMdq] = simbolochristoffel(obj,q)
       %Calcula a energia potencial gravitacional
       V = energiapotencialgrav(obj,q);
       %Calcula a energia cinética
       K = energiacinetica(obj,q,dotq);
       %Calcula a energia mecânica do sistema
       [E,K,V] = energiamecanica(obj,q,dotq)
       %Calcula a massa do robô
       M = massa(obj)
       
       
       
       %FUNÇÕES PARA CONTROLE
       
       %Simulador de entrada de torque
       [Q,dotQ,Tor,t] = cmdtorque(obj,tau,mem,q0,dotq0,dur_t)
       %Simulador de entrada de velocidade
       [Q,dotQ,Tor,t] = cmdvelocidade(obj,dotqref,q0,dotq0,dur_t)
       %Simulador de entrada de configuração
       [Q,dotQ,Tor,t] = cmdconfig(obj,qref,q0,dotq0,dur_t)
       %Simulador de entrada de pose
       [Q,dotQ,Tor,t] = cmdpose(obj,Tref,q0,dotq0,dur_t) 
       %Simulador de compensação de gravidade
       [Q,dotQ,Torq,t] = compgravidade(obj,V,q0,dotq0,dur_t)
       
       
       %INTERAÇÃO COM O AMBIENTE
       []=grudaobjeto(obj,obj_grudar)
       
       
       
       %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
       % FUNÇÕES AUXILIARES                       %
       %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
       Limites = calculalimites(obj)
       D = calculadensidade(obj)
    
   end
end