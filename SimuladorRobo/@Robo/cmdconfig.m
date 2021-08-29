function [Q,dotQ,Tor,t] = cmdconfig(obj,qref,q0,dotq0,dur_t)
%Fornece a saída de configuração Q (juntos com os tempos associados em t) e momento generalizado P pela aplicação do 
%velocidade de referência qref = qref(t) durante dur_t unidades de tempo
%e com condições iniciais q=q0 e dotq=dotq0
%Controlador PI com compensação de torque gravitacional e coriolis
%com erro de 'obj.controlador.errodinam'  no modelo

[Q,dotQ,Tor,t] = cmdvelocidade(obj, @(t,q) qdot_des(obj,t,q,qref),q0,dotq0,dur_t);

end

function v = qdot_des(obj,t,q,qref_in)
%Função que fornece a velocidade para controlar para a configuração alvo

    kp=obj.controlador.kpq;
    dt=0.01;
    ff=(qref_in(t+dt)-qref_in(t))/dt;
    v = kp*(qref_in(t)-q)+ff;
    Robo.dsp('erroq',qref_in(t)-q);
end