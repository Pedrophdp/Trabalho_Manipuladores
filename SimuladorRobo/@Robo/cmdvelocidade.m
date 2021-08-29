function [Q,dotQ,Tor,t] = cmdvelocidade(obj,dotqref,q0,dotq0,dur_t)
%Fornece a sa�da de configura��o Q (juntos com os tempos associados em t) e a velocidade dotQ pela aplica��o do 
%velocidade de refer�ncia dotqref = dotqref(t,q) durante dur_t unidades de tempo
%e com condi��es iniciais q=q0 e dotq=dotq0
%Controlador PI com compensa��o de torque gravitacional e coriolis
%com erro de 'obj.controlador.errodinam'  no modelo

tau_in=@(t,q,dotq,s) torque(obj,t,q,dotq,s,dotqref);
mem_in=@(t,q,dotq,s) dotqref(t,q)-dotq;

[Q,dotQ,Tor,t] = obj.cmdtorque(tau_in,mem_in,q0,dotq0,dur_t);

end

function tau = torque(obj,t,q,dotq,s,dotqref)
%Fun��o que fornece o torque para controlar para a velocidade de refer�ncia

    M=obj.matrizdeinercia(q);
    dVdq=obj.torquegravitacional(q);
    [~,dKdq,~]=obj.torquecc(q,dotq);
    errodotq=(dotqref(t,q)-dotq);  
    
    dt=0.01;
    ff = (dotqref(t+dt,q)-dotqref(t-dt,q))/(2*dt);
    
    
    erron = 1+obj.controlador.errodinam;
    kp=obj.controlador.kpv;
    ki=obj.controlador.kiv;
    tau = erron*(dKdq+dVdq+obj.info_links.friccao*dotq)+erron*M*(kp*errodotq+ki*s+ff);
    
    %Robo.dsp('errodotq',abs(errodotq));
    %Robo.dsp('s',s);
end