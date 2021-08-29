function T=rot(eixo,theta)
%Função que retorna a matriz de transformação homogênea da rotação no eixo
%'eixo' por um ângulo de theta
%O eixo pode ser 'x', 'y', 'z' ou um vetor (ex
%eixo=[1;2;3])

 if eixo=='z'
   T= [ cos(theta) -sin(theta) 0 0; sin(theta) cos(theta) 0 0; 0 0 1 0; 0 0 0 1];  
 end
 
 if eixo=='y'
   T= [ cos(theta) 0 sin(theta) 0; 0 1 0 0; -sin(theta) 0 cos(theta) 0; 0 0 0 1];  
 end
 
 
 if eixo=='x'
   T= [  1 0 0 0; 0 cos(theta) -sin(theta) 0; 0 sin(theta) cos(theta) 0; 0 0 0 1 ];  
 end
 
 if isa(eixo,'double')
   T = [expm( theta*Robo.matrizprodv(eixo/(norm(eixo)+0.00001))) zeros(3,1); zeros(1,3) 1];  
 end
 
end