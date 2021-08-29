function [r,CD] = vetorop(obj,q)
%Retorna o vetor r 6x1 com as posi��es (x,y,z) e os �ngulos de Euler (zyx)
%do efetuador em uma dada configura��o q

CD = obj.cinematicadir(q,'efetuador');
p = CD(1:3,4);
R = CD(1:3,1:3);

[x,y,z]=Robo.angulosdeeuler(R);

r=[p;x;y;z];

end
          
