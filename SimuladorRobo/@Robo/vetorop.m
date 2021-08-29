function [r,CD] = vetorop(obj,q)
%Retorna o vetor r 6x1 com as posições (x,y,z) e os ângulos de Euler (zyx)
%do efetuador em uma dada configuração q

CD = obj.cinematicadir(q,'efetuador');
p = CD(1:3,4);
R = CD(1:3,1:3);

[x,y,z]=Robo.angulosdeeuler(R);

r=[p;x;y;z];

end
          
