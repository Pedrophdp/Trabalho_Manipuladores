function [] = plota(t,X,titulo,nomeeixo,nomevar)

if length(t)==1
 dt=t;
 t = dt*(0:(size(X,2)-1));
end

if ~iscell(nomeeixo)==1
 nomey=nomeeixo;
 nomeeixo = {};
 nomeeixo{1} = 'Tempo (seg)';
 nomeeixo{2} = nomey;
end

if ~iscell(nomevar)
nomebase=nomevar;
nomevar = {};
 for i = 1: size(X,1)
  nomevar{i} = strrep(nomebase,'*',['{' num2str(i) '}']);   
 end
end

db=[20 43 140]/255;

plot(t,X','linewidth',2);
title(titulo,'Color',db);
xlabel(nomeeixo{1},'Color',db);
ylabel(nomeeixo{2},'Color',db);
grid on;
set(gcf,'color','w');
set(gca, 'XColor', db);
set(gca, 'YColor', db);
legend(nomevar);
set(get(gca,'Legend'),'TextColor',db);
set(get(gca,'Legend'),'EdgeColor',db);


end