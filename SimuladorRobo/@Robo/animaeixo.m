function [] = animaeixo(C,Einit,T,N)
%Anima de um eixo Einit com uma transformação T
%á direita para um cenário C

L=logm(T);

T0 = cell(length(Einit),1);

if length(Einit)==1
  Einitt=Einit;
  Einit=cell(1);
  Einit{1}=Einitt;
end

for j = 1: length(Einit)
T0{j} = Einit{j}.mth;
end

for i = 1: N
    Tt = real(expm((i-1)*L/(N-1)));
    for j = 1: length(Einit)
        Einit{j}.mth = T0{j}*Tt;
    end
    C.desenha();
    drawnow;
end

end