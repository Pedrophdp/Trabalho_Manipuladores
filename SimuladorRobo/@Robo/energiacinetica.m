function K = energiacinetica(obj,q,dotq)
%Calcula a energia cinética no estado [q,dotq] atual

In=matrizdeinercia(obj,q);
K = 0.5*dotq'*In*dotq;

end