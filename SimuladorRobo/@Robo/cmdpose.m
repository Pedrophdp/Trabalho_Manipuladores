function [Q,dotQ,Tor,t] = cmdpose(obj,Tref,q0,dotq0,dur_t)
%Fornece a sa�da de configura��o Q (juntos com os tempos associados em t) e momento generalizado P pela aplica��o do 
%velocidade de refer�ncia Tref = Tref(t) durante dur_t unidades de tempo
%e com condi��es iniciais q=q0 e dotq=dotq0
%Controlador PI com compensa��o de torque gravitacional e coriolis
%com erro de 'obj.Controlador.errodinam'  no modelo

[Q,dotQ,Tor,t] = cmdvelocidade(obj, @(t,q) qdot_des(obj,t,q,Tref),q0,dotq0,dur_t);

end

function v = qdot_des(obj,t,q,Tref)
%Fun��o que fornece a velocidade para controlar para a pose alvo

    n=length(q);
    kp=obj.controlador.kppose;

    [er,J_erq]=obj.erropose(q,Tref(t));
    dt=0.01;
    J_ert = (obj.erropose(q,Tref(t+dt))-er)/dt;
    
    %Tempor�rio
    er=er(1:3,:);
    J_erq=J_erq(1:3,:);
    J_ert=J_ert(1:3,:);
    %%%%%
    
    damp_J_erq = (J_erq'*J_erq+0.01*eye(n))\(J_erq');
    
    v =  damp_J_erq*(-kp*er-J_ert);
end