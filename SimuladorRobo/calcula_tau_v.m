function [tau_v,t_v]=calcula_tau_v(H,beta)
    dt = 0.005;
    tau_v(1)=0;
    t_v(1)=0;
    while tau_v(end)<1
        H_linha= (H(tau_v(end)+dt)-H(tau_v(end)-dt))/(2*dt);
        N=norm(H_linha);
        tau_v(end+1)=tau_v(end)+dt*beta/N;
        t_v(end+1)=t_v(end)+dt;
        
    end
end