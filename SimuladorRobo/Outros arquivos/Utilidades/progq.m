function x = progq(H,f,A,b,x0,itermax)

if nargin == 4
    itermax=10;
    x0=zeros(length(f),1);
end
if nargin == 5
    itermax=10;
end

x=x0;

k=1;
terminou=0;

if max(A*x-b)>0
    %Não é factível... corrige
    d=1;
    
    while (max(A*x*d-b)>0)&&(~terminou)
        d=0.9*d;
        k=k+1;
        if k > 10
            terminou=1;
        end
    end
    x=x*d;
    
end

if ~terminou
    fim=0;
    acs = find( abs(A*x-b+0.01)<=0.01);
    
    n=size(b,1);
    zero=zeros(n,1);
    
    i=1;
    while ~fim
        Aw=A(acs,:);
        bw=b(acs,:);
        [p,lambdap] =progqn(H,H*x+f,Aw,zero(acs,:));
        
        if norm(p)<=0.01
            if min(lambdap)>=0
                fim=1;
            else
                [~,ind] = min(lambdap);
                acs = setdiff(acs,acs(ind));
            end
        else
            r = A*p;
            delta = b-A*x;
            
            
            
            ind = setdiff(find(r>=0),acs);
            
            if length(ind)>0
                alfa = min(min(delta(ind)./r(ind)),1);
            else
                alfa=1;
            end
            
            if min(b-A*(x+alfa*p))<-0.1
                gh=1;
            end
            
            x=x+alfa*p;
            
            
            acsnovo = find( abs(A*x-b+0.0001)<=0.0001);
            acs = union(acs,acsnovo);
        end
        
        i=i+1;
        if i>itermax
            fim=1;
        end
    end
    
else
    
    x=[];
    lambda=[];
end

end

function [x,lambda] =progqn(H,f,A,b)
%Resolve o problema
% min x'H'x/2 + f'x sujeito a Mx=0

op.SYM=true;
n=size(A,1);
m=size(A,2);
M = [H A'; A zeros(n,n)];
M = M + 0.00001*eye(size(M,1));
g = [-f; b];
v = linsolve(M,g,op);
x = v(1:m);
lambda=v(m+1:end);
end

