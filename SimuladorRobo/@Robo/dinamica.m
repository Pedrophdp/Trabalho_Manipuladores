function [Q,P,t] = dinamica(obj,tau,q0,dotq0,dur_t)
%Fornece a saída de configuração Q e velocidade de configuração dotQ
%(juntos com os tempos associados em t) pela aplicação do torque **constante** tau durante dur_t unidades de tempo
%e com condições iniciais q=q0 e dotq=dotq0




%Inicializações
t(1)=0;
x(:,1)=[q0;dotq0];
j=1;
n=length(q0);
dt_base=0.01;
%DeltaE=0.01;
%opts = optimoptions('fmincon','Display','off');


while t(end)<=dur_t
    

       %Calcula a variação de energia desejada
       [xcand,E,erro,dt] = fluxohamiltoniano(obj,x(:,j),tau,dt_base);
       x(:,j+1)=xcand;
       disp('Erro');
       disp(erro);
    
   t(j+1)=t(j)+dt;
   j=j+1;
   
disp('Tempo');
disp(t(end));

end

Q=x(1:n,:);
P=x(n+1:2*n,:);



end



