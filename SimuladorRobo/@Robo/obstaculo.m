function [D,JD,pmp_obj,pmp_lista] = obstaculo(obj,q,lista_obj,tol)
%Calcula as distâncias com relação a uma coleção de objetos
%obj_lista e retorna também as jacobianas da função distância em uma
%configuração genérica q. Só retorna se a distância for maior que
%tol

D=[];
JD=[];

ret=0;
if norm(q-obj.q)>=0.01
qant=obj.q;
obj.config(q);
ret=1;
end

n=length(q);

D = zeros(length(lista_obj)*(n+3),1);
JD = zeros(length(lista_obj)*(n+3),length(q));
pmp_obj = zeros(3,length(lista_obj)*(n+3));
pmp_lista = zeros(3,length(lista_obj)*(n+3));



if length(lista_obj)==1
 lt=lista_obj;
 lista_obj=cell(1);
 lista_obj{1}=lt;
end

num=1;
for i = 1: length(lista_obj)
    for j = 1: n
        [Dist,pmp1,pmp2] = obj.obj_links(j).calcdistanciarap(lista_obj{i},tol);
        if Dist<tol
            D(num)=Dist;
            [~,J] = obj.cinematicadirgen(q,q,pmp1);
            JD(num,:)= (pmp1-pmp2)'*J/(norm(pmp1-pmp2)+0.01);
            pmp_obj(:,num) = pmp1;
            pmp_lista(:,num) = pmp2;
            num=num+1;
        end
    end
    
    [Dist,pmp1,pmp2] = obj.obj_efetuador.calcdistanciarap(lista_obj{i},tol);
    if Dist<tol
        D(num)=Dist;
        [~,J] = obj.cinematicadirgen(q,q,pmp1);
        JD(num,:)= (pmp1-pmp2)'*J/(norm(pmp1-pmp2)+0.01);
        pmp_obj(:,num) = pmp1;
        pmp_lista(:,num) = pmp2;
        num=num+1;
    end
    
    [Dist,pmp1,pmp2] = obj.obj_link_efetuador.calcdistanciarap(lista_obj{i},tol);
    if Dist<tol
        D(num)=Dist;
        [~,J] = obj.cinematicadirgen(q,q,pmp1);
        JD(num,:)= (pmp1-pmp2)'*J/(norm(pmp1-pmp2)+0.01);
        pmp_obj(:,num) = pmp1;
        pmp_lista(:,num) = pmp2;
        num=num+1;
    end    
    
    [Dist,pmp1,pmp2] = obj.obj_base.calcdistanciarap(lista_obj{i},tol);
    if Dist<tol
        D(num)=Dist;
        [~,J] = obj.cinematicadirgen(q,q,pmp1);
        JD(num,:)= (pmp1-pmp2)'*J/(norm(pmp1-pmp2)+0.01);
        pmp_obj(:,num) = pmp1;
        pmp_lista(:,num) = pmp2;        
        num=num+1;
    end
    
end

%Apaga quem não foi utilizado
D(num:end)=[];
JD(num:end,:)=[];
pmp_obj(:,num:end)=[];
pmp_lista(:,num:end)=[];

if ret==1
%Volta para a configuração anterior
obj.config(qant);
end

end