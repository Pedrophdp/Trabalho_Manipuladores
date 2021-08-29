function J = calcjacobiana(f,q)
%Calcula a matriz jacobiana de uma função
m = size(q,1);
n = size(f(q),1);
%dt = 0.0001;
dt=0.0001;
J = [];

for i=1:m
    dq = zeros(m,1);
    dq(i) = dt;
    C = (f(q+dq) - f(q-dq))/(2*dt);
    J = [J C];
end

end