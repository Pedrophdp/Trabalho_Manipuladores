function [x,y,z] = angulosdeeuler(R)
%Dada uma matriz de rotação R, extrai os angulos de
% Euler (zyx)

sy = sqrt( R(1,1)^2+R(2,1)^2);

if abs(sy)>0.01
    x = atan2(R(3,2) , R(3,3));
    y = atan2(-R(3,1), sy);
    z = atan2(R(2,1), R(1,1));
else
    x = atan2(-R(2,3), R(2,2));
    y = atan2(-R(3,1), sy);
    z = 0;
end

end