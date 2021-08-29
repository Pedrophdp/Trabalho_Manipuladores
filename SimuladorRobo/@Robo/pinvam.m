function Jinv = pinvam(J,fat)
%Calcula a pseudoinversa amortecida com fato 'fat'

n=size(J,2);

Jinv = inv(fat*eye(n)+J'*J)*J';

end