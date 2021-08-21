function [Q,dotQ,Torq,t] = compgravidade(obj,V,q0,dotq0,dur_t)
%Implementa a compensa��o de gravidade com a fun��o de tarefa
%V(q), com condi��o inicial de configura��o q0, de velocidade
%dotq0 e durante dur_t unidades de tempo. Kd � o termo
%de fric��o artificial

tau = @(t,q,dotq,s) torque(obj,V,q,dotq);
mem = @(t,q,dotq,s) [0;0;0;0;0;0];


[Q,dotQ,Torq,t] = obj.cmdtorque(tau,mem,q0,dotq0,dur_t);


end

function tau=torque(R,V,q,dotq)
%Calcula o torque para a compensa��o de gravidade
gradV= Robo.calcjacobiana(V,q);
tau= -gradV';
tau = tau-R.controlador.kdcg*dotq;
tau = tau+(1+R.controlador.errodinam)*R.torquegravitacional(q);

end