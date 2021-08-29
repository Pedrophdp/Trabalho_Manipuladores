function [] = RRT(limites,arvore,obsf,desf,graddesf,nopontos)



  for i = 1: nopontos
  
       
       if rand()<=0.95
           %Sorteia uma configuração completamente aleatoria
           qsample = sorteia(limites,obsf);
           %Acha o ponto mais próximo na árvore
           D = zeros(1,length(arvore.nos));
           for j = 1: length(arvore.nos)
               D(j) = norm(qsample-arvore.nos{j}.config);
           end
           [~,ind] = min(D);
       else
           %Sorteia uma configuracao proxima do alvo
           D = zeros(1,length(arvore.nos));
           for j = 1: length(arvore.nos)
               D(j) = arvore.nos{j}.valor;
           end
           [~,ind] = min(D);
           qsample= arvore.nos{ind}.config;
           qsample = qsample-graddesf(qsample)*0.3*rand();
           qsample = min(max(qsample,limites(:,1)),limites(:,2));
       end
       
       %Acha a configuração livre mais próxima
       qultimo = caminholivre(obsf,arvore.nos{ind}.config,qsample,0.01);
       N = No(qultimo,arvore.nos{ind},cell(0),desf(qultimo));
       arvore.nos{ind}.filhos{end+1} = N;
       arvore.nos{end+1} = N;
  end





end

function qultimo = caminholivre(obsf,q1,q2,ds)

   delta = ds*(q2-q1)/(norm(q2-q1)+0.0001);
   
   qultimo=q1;

   while (norm(q2-qultimo)>=ds) && (sign(obsf(qultimo))==1)
     qultimo=qultimo+delta;  
   end
   qultimo=qultimo-delta; 
end


function qsample = sorteia(limites,obsf)

    n= size(limites,1);
    
    qsample1 = limites(:,1) + (limites(:,2)-limites(:,1)).*rand(n,1);
    qsample2 = qsample1 + 0.2*(limites(:,2)-limites(:,1)).*randn(n,1);
    qsample2 = min(max(qsample2,limites(:,1)),limites(:,2));
    while sign(obsf(qsample1)) ==sign(obsf(qsample2))
        qsample1 = limites(:,1) + (limites(:,2)-limites(:,1)).*rand(n,1);
        qsample2 = qsample1 + 0.2*(limites(:,2)-limites(:,1)).*randn(n,1);
        qsample2 = min(max(qsample2,limites(:,1)),limites(:,2));
    end
    
    if obsf(qsample2)==1
        qsample=qsample2;
    else
        qsample=qsample1;
    end

    
end