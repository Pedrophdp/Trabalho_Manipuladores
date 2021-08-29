function [E,K,V] = energiamecanica(obj,q,dotq)
%Calcula a energia mec�nica E=K+V (K=cin�tica, V=potencial gravitacional) 
%no estado [q,dotq] atual

V = obj.energiapotencialgrav(q);
K = obj.energiacinetica(q,dotq);


E=K+V;

end