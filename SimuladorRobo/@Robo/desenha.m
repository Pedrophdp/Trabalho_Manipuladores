function [Dados,indice_saida,Handleout] =desenha(obj,Handlein,indices)
%Desenha o objeto (robô) na configuração atual setada na função 'config'

      if nargin==1
          Handlein=[];
          indices=0;
      end
      
%Inicializações
d = 0.2*max(obj.limites_desenho(2),obj.limites_desenho(4));
k=indices;
Dados={};
hold on;
%Desenha os links
for i = 1: length(obj.obj_links)
    if obj.obj_links(i).altura*obj.obj_links(i).raio>0
    [Dados{end+1},k,Handlein]=obj.obj_links(i).desenha(Handlein,k);
    end
    [Dados{end+1},k,Handlein]=obj.obj_eixos(i).desenha(Handlein,k);
end
%Desenha a base
[Dados{end+1},k,Handlein]=obj.obj_base.desenha(Handlein,k);
%Desenha o efetuador
[Dados{end+1},k,Handlein]=obj.obj_efetuador.desenha(Handlein,k);
[Dados{end+1},k,Handlein]=obj.obj_link_efetuador.desenha(Handlein,k);
%Desenha os eixos do efetuador
[Dados{end+1},k,Handlein]=obj.obj_eixoefetuador.desenha(Handlein,k);
%Desenha os objetos que estao grudados no efetuador
for i = 1: length(obj.obj_noefetuador)
 [Dados{end+1},k,Handlein]=obj.obj_noefetuador{i}.desenha(Handlein,k); 
end


%Atribui as saidas
indice_saida=k;
Handleout=Handlein;

end

