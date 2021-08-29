clear all
clc

figure(2)
axis([-1 1 -1 1]);

set (gcf, 'WindowButtonMotionFcn', @mouseMove);

function [X,Y]= mouseMove (object, eventdata)
  
    C = get (gca, 'CurrentPoint');
    title(gca, ['(X,Y) = (', num2str(C(1,1)), ', ',num2str(C(1,2)),')']);
    X= C(1,1);
    Y= C(1,2);
    if X>1
        X=1;
    end
    if Y>1
        Y=1;
    end
    if X<-1
        X=-1;
    end
    if Y<-1
        Y=-1;
    end
    desenha(X,Y);
%         disp(x_hist)
%         disp(y_hist)
        
        %Aqui deve ser posto o filtro
       
        %//////////////////////////////////////////////
        
        
        %////////////////////////////////      
end

function desenha(X,Y)
    persistent x_hist;
    persistent y_hist;
    
    if length(x_hist)<100
        x_hist(length(x_hist)+1)=X;
        y_hist(length(y_hist)+1)=Y;
    end
    if length(x_hist)==100
        
        x_hist(1)=x_hist(1);
        y_hist(1)=y_hist(1);
        x_hist(2)=x_hist(100);
        y_hist(1)=y_hist(100);
       
        %x_ultimo=x_his(100);
   
%         x_hist=[];
%         y_hist=[];
        
        %Lógica de controle
        figure(1)
        E= Elipsoide(Robo.desl([0;0;0]),[0.7 0.7 0.7],[0.5 0 0],1);
        R= Robo.Cria_KukaKR5(Robo.desl([0;-1; 0])); 
        C = Cenario(R);
        C.adicionaobjetos(E);
       
%         if length(x_ultimo) ~= 0
%             R.config(rq);
%             x_his
%         end
        %Constantes
        K=1;
        dt = 0.005;

        %Inicializa os históricos
        q_hist=[];
        r_hist=[];
        u_hist=[];
        t=[];

        pc=[0;0;0]; %Ponto central da esfera
        r=0.7; %Raio esfera
        po =pc+r*[0;-cos(pi/4);sin(pi/4)]; %Ponto central da área mapeada
        h_hat=[1;0;0]; %vetor ortogonal
        v_hat=cross(po-pc,h_hat);
        v_hat=v_hat/norm(v_hat); %vetor ortogonal

        for cont=1:2
            h=x_hist(cont); %x
            v=y_hist(cont); %y
            L= 0.2; %Comprimento da tela
            Pp=po+L*h*h_hat+L*v*v_hat;
            pdes= pc+(r*(Pp-pc)/norm(Pp-pc)); %Ponto que se quer chegar
            xdes=v_hat;
            ydes=h_hat;
            zdes= cross(v_hat,h_hat);

            f= @(x)sign(x).*sqrt(abs(x));

            for k=1 : 4/dt

                %Guarda alguns históricos
                q_hist(:,k)= R.q;
                %rq=R.q;
                t(k) = (k-1)*dt;

                %Alguns cálculos
                Tef = R.cinematicadir(R.q, 'efetuador');
                Jgeo = R.jacobianageo(R.q, 'efetuador');
                pef = Tef(1:3,4);
                xef = Tef(1:3,1);
                yef = Tef(1:3,2);
                zef = Tef(1:3,3);
                Jp = Jgeo(1:3,:);
                Jw = Jgeo(4:6,:);

                rpos = pef-pdes;
                rorix = 1 - xdes'*xef;
                roriy = 1 - ydes'*yef;
                roriz = 1 - zdes'*zef;

                r = [rpos; rorix; roriy; roriz];
                Jrpos = Jp;
                Jrorix = xdes'*Robo.matrizprodv(xef)*Jw;
                Jroriy = ydes'*Robo.matrizprodv(yef)*Jw;
                Jroriz = zdes'*Robo.matrizprodv(zef)*Jw;

                Jr = [Jrpos; Jrorix; Jroriy; Jroriz];

                %Calcula a ação de controle
                u = Robo.pinvam(Jr(1:6,:), 0.001)*(-K*f(r(1:6)));

                %Guarda os outros históricos
                u_hist(:,k) = u;
                r_hist(:,k) = r(1:6);

                %Simula o movimento do robô
                qprox = R.q + u*dt;
                R.config(qprox);
                if mod(k,4)==0
                   C.desenha();
                   drawnow;
                end 
            end 
        end
    end
end