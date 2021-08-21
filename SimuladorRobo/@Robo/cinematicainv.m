function q_s = cinematicainv(obj,T_des,iter_max,tol)
%Tenta resolver o problema de encontrar q tal que a cinemática
%direta do efetuador é T_des
%Se não conseguir encontrar, devolve []


n = length(obj.q);
iter=0;
ok=0;
dt=0.05;



while (iter<=iter_max) && (~ok)
    
   %Sorteia uma configuração no limite das juntas
   q_rand =  obj.info_links.limites_q(:,1)+ (obj.info_links.limites_q(:,2)-obj.info_links.limites_q(:,1)).*rand(n,1);
   
   %Tenta encontrar a partir dela
   q=q_rand;
   iter_local=0;
   q_ant=q+0.5;
   while (norm(q-q_ant)>=0.001) && (iter_local<=1000)
      [er,J]=obj.erropose(q,T_des);
      q_ant=q;
      q = q+ (J'*J+0.00001*eye(n))\(J'*(-0.5*er))*dt;
      iter_local=iter_local+1;
   end
   
   if max(diag([1 1 1 0.5 0.5 0.5])*abs(er))<=tol
     ok=1;
     q_s=q;
   end
   iter=iter+iter_local;
   
end

if iter>iter_max
   q_s=[]; 
end




end