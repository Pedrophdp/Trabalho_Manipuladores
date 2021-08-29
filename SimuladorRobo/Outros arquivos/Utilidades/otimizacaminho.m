function Q_otm = otimizacaminho(Q,obsf,dt)


Q_otm = Q;
indatual=1;


while indatual<size(Q_otm,2)
n=size(Q_otm,2);

ok=0;
while (ok==0) && (n>indatual)
 ok=caminholivre(Q_otm(:,indatual),Q_otm(:,n),obsf,dt);
 n=n-1;
end
  Q_otm(:,indatual+1:n-1)=[];
  indatual=indatual+1;
end
  
end

function result = caminholivre(qinit,qfinal,obsf,dt)
%Descobre se o caminho é livre entre dois pontos

 q_atual=qinit;

  while (obsf(q_atual)>0)&&( norm(q_atual-qfinal) >=dt)
     q_atual = q_atual + dt*(qfinal-qinit); 
  end
  
  if norm(q_atual-qfinal) <=dt
    result=1;  
  else
    result = 0;  
  end

  
end