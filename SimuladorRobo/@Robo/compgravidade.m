function [Q,dotQ,Torq,t] = compgravidade(obj,V,q0,dotq0,dur_t)
%Implementa a compensação de gravidade com a função de tarefa
%V(q), com condição inicial de configuração q0, de velocidade
%dotq0 e durante dur_t unidades de tempo. Kd é o termo
%de fricção artificial

tau = @(t,q,dotq,s) torque(obj,V,q,dotq);
mem = @(t,q,dotq,s) [0;0;0;0;0;0];


[Q,dotQ,Torq,t] = obj.cmdtorque(tau,mem,q0,dotq0,dur_t);


end

function tau=torque(R,V,q,dotq)
%Calcula o torque para a compensação de gravidade
gradV= Robo.calcjacobiana(V,q);
tau= -gradV';
tau = tau-R.controlador.kdcg*dotq;
tau = tau+(1+R.controlador.errodinam)*R.torquegravitacional(q);

end