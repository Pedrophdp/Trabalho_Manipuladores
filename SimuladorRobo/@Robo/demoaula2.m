function []=demoaula2()
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Demonstra��o de transforma��o de frames
% Autor: Vinicius Mariano Gon�alves
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clc;
clear all;
clf;

Robo.dispmod('DEMONSTRA��O DE AULA 2');
Robo.dispmod('Demonstra��o de transforma��es r�gidas. ');
Robo.dispmod('Considere a transforma��o T=Ad*Ar*Bd*Br*Cd*Cr*Dd*Dr formada por deslocamentos (d) seguido de rota��es (r)');
Robo.dispmod('Vamos mostrar que h� duas maneiras de interpretar esse produto, com o mesmo resultado no final...');


Robo.dispmod('Vamos interpret�-la primeiro da esquerda para direita');

Robo.dispmod('                                   ');
Robo.dispmod('INTERPRETANDO DA ESQUERDA PARA A DIREITA');
Robo.dispmod('Ent�o ser� a transforma��o Ad primeiro, Ar depois, etc...');
Robo.dispmod('!!!!!!!Preste aten��o em como cada transforma��o de um frame para o outro usa o frame ATUAL como refer�ncia!!!!!');
Robo.dispmod('Exemplo: na transforma��o do Frame 2 para o Frame 3, a rota��o no eixo y � feita no eixo y2, N�O no eixo y0!');



Robo.dispmod('Pressione qualquer tecla para continuar...');
pause;
for i = 1: 5
E{i} = Eixo(eye(4),1,{' ',' ',' '});
end
T(:,:,1)=Robo.desl([3;0;0])*Robo.rot('z',pi/2);
T(:,:,2)=Robo.desl([0;0;2])*Robo.rot('x',pi/2);
T(:,:,3)=Robo.desl([3;0;0])*Robo.rot('y',-pi/2);
T(:,:,4)=Robo.desl([-3;0;0])*Robo.rot('z',-pi/3);

C = Cenario(E);

C.chao.cor=[];
C.limites_desenho=[-3 4 -3 5 -3 3];
C.eixoref.d=0.01;
C.eixoref.nomes={'','',''};

str{1} = {'O pr�ximo eixo, E1, � obtido a partir de E0 deslocando 3 unidades em x0 (Ad) e rodando 90 graus no sentido positivo (anti-hor�rio) eixo z0 (Ar) '};
mat{1} = {'Ad = Robo.desl([3;0;0]), Ar=Robo.rot([0;0;1],pi/2)'};
str{2} = {'O pr�ximo eixo, E2, � obtido a partir de E1 deslocando 2 unidades em z1 (Bd) e rodando 90 graus no sentido positivo (anti-hor�rio) eixo x1 (Br)'};
mat{2} = {'Bd = Robo.desl([0;0;2]), Br=Robo.rot([1;0;0],pi/2)'};
str{3} = {'O pr�ximo eixo, E3, � obtido a partir de E2 deslocando 3 unidades em x2 (Cd) e rodando -90 graus no sentido positivo (anti-hor�rio) eixo y2 (Cr)'};
mat{3} = {'Cd = Robo.desl([3;0;0]), Cr=Robo.rot([0;1;0],-pi/2)'};
str{4} = {'O pr�ximo eixo, E4, � obtido a partir de E3 deslocando -3 unidades em x3 (Dd) e rodando -60 graus no sentido positivo (anti-hor�rio) eixo z3 (Dr)'};
mat{4} = {'Dd = Robo.desl([-3;0;0]), Dr=Robo.rot([0;0;1],-pi/3)'};

N=10;

E{1}.nomes={'x0','y0','z0'};

for j = 1: 4


Robo.dispmod('-------------------------------------------');
Robo.dispmod(' ');
Robo.dispmod(str{j});
Robo.dispmod('Matriz de transforma��o homog�nea:');
Robo.dispmod(mat{j});


Robo.dispmod('Aperte uma tecla para transladar');
pause;

%Transla��o
for i = 1: N
E{j+1}.mth(1:3,4) = E{j+1}.mth(1:3,4) + E{j}.mth(1:3,1:3)*T(1:3,4,j)/N;
C.desenha();
drawnow;
end

Robo.dispmod('Aperte uma tecla para rodar');
pause;

%Rota��o
Tref=E{j+1}.mth;


for i = 1: N
Q = real(expm((i-1)*logm(T(1:3,1:3,j))/(N-1)));
Ts = [Q zeros(3,1); zeros(1,3) 1];
E{j+1}.mth = Tref*Ts;
C.desenha();
drawnow;
end

for i = j+2:5
E{i}.mth = E{j+1}.mth;
end

%Desenha
E{j+1}.nomes ={['x' num2str(j)],['y' num2str(j)],['z' num2str(j)]};
C.desenha();

Robo.dispmod(' ');
end



Robo.dispmod('-------------------------------------------');
Robo.dispmod('Terminou a primeira parte! Aperte uma tecla para continuar!');
pause;



E4 = Eixo(E{5}.mth,1,{'x4','y4','z4'});
C.adicionaobjetos(E4);
C.chao.cor=[];
C.limites_desenho=[-3 4 -3 5 -3 3];
C.eixoref.d=0.01;
C.eixoref.nomes={'','',''};
for i = 2:5
E{i}.mth = eye(4);
E{i}.nomes ={' ',' ',' '};
end
C.desenha();
C.desenha();

Robo.dispmod('                                   ');

Robo.dispmod('Vamos interpretar T=T=Ad*Ar*Bd*Br*Cd*Cr*Dd*Dr da direita ');
Robo.dispmod('para a esquerda');
Robo.dispmod('Vamos manter o frame 4 pois ao final das transforma��es ');
Robo.dispmod('temos que chegar no MESMO frame');





str{4} = {'O pr�ximo eixo, E4 (o MESMO do caso anterior!) � obtido a partir de E3_int  rodando 90 graus no sentido positivo (anti-hor�rio) eixo z0 (Ar)e  deslocando 3 unidades em x0 (Ad)'};
mat{4} = {'Ar=Robo.rot([0;0;1],pi/2) , Ad = Robo.desl([3;0;0])'};
str{3} = {'O pr�ximo eixo, E3_int, � obtido a partir de E2_int  rodando 90 graus no sentido positivo (anti-hor�rio) eixo x0 (Br) e deslocando 2 unidades em z0 (Bd)'};
mat{3} = {'Br=Robo.rot([1;0;0],pi/2) , Bd = Robo.desl([0;0;2])'};
str{2} = {'O pr�ximo eixo, E2_int, � obtido a partir de E1_int rodando -90 graus no sentido positivo (anti-hor�rio) eixo y0 (Cr)  e deslocando 3 unidades em x0 (Cd)'};
mat{2} = {'Cr=Robo.rot([0;1;0],-pi/2), Cd = Robo.desl([3;0;0])'};
str{1} = {'O pr�ximo eixo, E1_int, � obtido a partir de E0  rodando -60 graus no sentido positivo (anti-hor�rio) eixo z0 (Dr) e deslocando -3 unidades em x0 (Dd)'};
mat{1} = {'Dr=Robo.rot([0;0;1],-pi/3), Dd = Robo.desl([-3;0;0])'};

Robo.dispmod('Aperte uma tecla para continuar!');
pause;



Robo.dispmod('                                   ');
Robo.dispmod('INTERPRETANDO DA DIREITA PARA A ESQUERDA');
Robo.dispmod('Ent�o ser� transforma��o Dr primeiro, Dd depois, etc...');
Robo.dispmod('!!!!!!!Preste aten��o em como cada transforma��o de um frame para o outro usa o frame ORIGINAL ( 0 ) como refer�ncia!!!!');
Robo.dispmod('Exemplo: na transforma��o do Frame 2 para o Frame 3, a rota��o no eixo x � feita no eixo x0, N�O no eixo x2!');



for j = 1: 4


Robo.dispmod('-------------------------------------------');
Robo.dispmod(' ');
Robo.dispmod(str{j});
Robo.dispmod('Matriz de transforma��o homog�nea:');
Robo.dispmod(mat{j});


Robo.dispmod('Aperte uma tecla para rodar');
pause;


%Rota��o
Tref=E{j+1}.mth;

for i = 1: N
Q = real(expm((i-1)*logm(T(1:3,1:3,5-j))/(N-1)));
Ts = [Q zeros(3,1); zeros(1,3) 1];
E{j+1}.mth = Ts*Tref;
C.desenha();
drawnow;
end

Robo.dispmod('Aperte uma tecla para transladar');
pause;

%Transla��o
for i = 1: N
E{j+1}.mth(1:3,4) = E{j+1}.mth(1:3,4) + T(1:3,4,5-j)/N;
C.desenha();
drawnow;
end

for i = j+2:5
E{i}.mth = E{j+1}.mth;
end


%Desenha
if j<4
E{j+1}.nomes ={['x' num2str(j) 'int'],['y' num2str(j) 'int'],['z' num2str(j) 'int']};
else
 E{5}.nomes ={'x4','y4','z4'};   
end
C.desenha();

Robo.dispmod(' ');
end

Robo.dispmod('!!!!!!!!!!!! Perceba que deu na mesma!!! S�o s� interpreta��es diferentes!!!!!!!!!!');
Robo.dispmod('      ');

Robo.dispmod('-------------------------------------------');
Robo.dispmod('Ent�o a transforma��o do frame 0 para o 4 �dada por T=Ad*Ar*Bd*Br*Cd*Cr*Dd*Dr');
Robo.dispmod('O valor dessa matriz �');
disp(T(:,:,1)*T(:,:,2)*T(:,:,3)*T(:,:,4));
Robo.dispmod('Perceba que a primeira coluna dessa matriz (tirando o 0) � o vetor x4 escrito nas coordenadas do frame 0');
Robo.dispmod('Perceba que a segunda coluna dessa matriz (tirando o 0) � o vetor y4 escrito nas coordenadas do frame 0');
Robo.dispmod('Perceba que a terceira coluna dessa matriz (tirando o 0) � o vetor z4 escrito nas coordenadas do frame 0');
Robo.dispmod('Perceba que a quarta coluna dessa matriz (tirando o 1) � o centro do frame 4 escrito nas coordenadas do frame 0');

end
