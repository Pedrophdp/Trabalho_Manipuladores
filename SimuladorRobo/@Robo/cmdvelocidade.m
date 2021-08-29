function [Q,dotQ,Tor,t] = cmdvelocidade(obj,dotqref,q0,dotq0,dur_t)
%Fornece a saída de configuração Q (juntos com os tempos associados em t) e a velocidade dotQ pela aplicação do 
%velocidade de referência dotqref = dotqref(t,q) durante dur_t unidades de tempo
%e com condições iniciais q=q0 e dotq=dotq0
%Controlador PI com compensação de torque gravitacional e coriolis
%com erro de 'obj.controlador.errodinam'  no modelo

tau_in=@(t,q,dotq,s) torque(obj,t,q,dotq,s,dotqref);
mem_in=@(t,q,dotq,s) dotqref(t,q)-dotq;

[Q,dotQ,Tor,t] = obj.cmdtorque(tau_in,mem_in,q0,dotq0,dur_t);

end

function tau = torque(obj,t,q,dotq,s,dotqref)
%Função que fornece o torque para controlar para a velocidade de referência

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