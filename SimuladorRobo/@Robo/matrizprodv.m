function S = matrizprodv(a)
%Cria a matriz S(a) tal que a x b = S(a)b, em que 'x' é o produto vetorial

S = [0 -a(3) a(2); a(3) 0 -a(1); -a(2) a(1) 0];

end