function [Q,dotQ,Torq,t] = cmdtorque(obj,tau,mem,q0,dotq0,dur_t)
%Função tau = tau(t,q,dotq,s)
%Função mem = mem(t,q,dotq,s)

%global Tor;
%global Tem;

%Tor=[];
%Tem=[];

n=length(obj.q);

%O estado x=[q;p;s] (q=config, qdot=vel. config e s=memória)
x0 = [q0;dotq0;zeros(n,1)];

%opts = odeset('RelTol',0.01,'AbsTol',0.01);

[t,xout] = ode45(@(t,x) dinam(obj,t,x,tau,mem),[0 dur_t],x0);
xout=xout';
t=t';
Q=xout(1:n,:);
dotQ=xout(n+1:2*n,:);
S=xout(2*n+1:3*n,:);

% Torq=reamostra(Tor,Tem,t);
for k = 1: size(Q,2)
  Torq(:,k) =  tau(t(k),Q(:,k),dotQ(:,k),S(:,k)); 
end

end   

function y2 = reamostra(y1,x1,x2)

  n=length(x2);
  y2=zeros(size(y1,1),n);
  
  for i = 1:n
    [indinf]=find(x1<=x2(i));
    [indsup]=find(x1>x2(i));
    
    if isempty(indsup)
      indsup=indinf(end);  
    end
    
    x_init=x1(indinf(end));
    x_fim=x1(indsup(1));
    
    if x_init>x_fim
      temp=x_fim;
      x_fim=x_init;
      x_init=temp;
    end
    x_med=x2(i);
    
    alpha=(x_fim-x_med)/(x_fim-x_init+0.001);
    y2(:,i) =  alpha*y1(:,indinf(end))+(1-alpha)*y1(:,indsup(1)); 
  end
  
  
end

function dotx = dinam(obj,t,x,tauin,mein)
%Fornece a variação de estado
    
    global Tor;
    global Tem;

    
    n=length(obj.q);
    q=x(1:n);
    dotq=x(n+1:2*n);
    s=x(2*n+1:3*n);
    
    
    M=obj.matrizdeinercia(q)+0.001*eye(n);
    dVdq=obj.torquegravitacional(q);
    [~,dKdq,~]=obj.torquecc(q,dotq);
    
    tau=tauin(t,q,dotq,s);
    tau_max=obj.info_links.limites_torque(:,2);
    tau_min=obj.info_links.limites_torque(:,1);
    
    
    tau = min(max(tau,tau_min),tau_max);
    
    
    %Torque para fazer limitar a configuração
    qmin = obj.info_links.limites_q(:,1);
    qmax = obj.info_links.limites_q(:,2);
    
%     tres=zeros(n,1);
%     ind = intersect(find(q-qmax>0),find(dotq>0));
%     tres(ind)=-800*dotq(ind);
%     ind = intersect(find(qmin-q>0),find(dotq<0));
%     tres(ind)=-800*dotq(ind);
%     
%     disp(tres');
    tres=0*dotq;
    dotdotq=M\(tau-dVdq-dKdq-obj.info_links.friccao*dotq+tres);
    dots=mein(t,q,dotq,s);
    dotx=[dotq;dotdotq;dots];
    
    %Tor=[Tor tau];
    %Tem=[Tem t];
    disp(t);
end