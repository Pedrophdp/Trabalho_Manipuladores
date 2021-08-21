function [Q,t]=rk4(f,dur_t,Q0,dt)

Q=Q0;
t(1)=0;

while t(end)<= dur_t

q=Q(:,end);
ta=t(end);

k1 = f(q,ta);
k2 = f(q+k1*dt/2,ta+dt/2);
k3 = f(q+k2*dt/2,ta+dt/2);
k4 = f(q+k3*dt,ta+dt);
dotq = (k1+2*k2+2*k3+k4)/6;


Q(:,end+1)=q+dotq*dt;
t(end+1)=t(end)+dt;
end

end