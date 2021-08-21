function [er,J]=erropose(obj,q,Tdes)
%Calcula um vetor de erro entre a pose do robô no efetuador em uma configuração q e uma
%pose Tdes
%Retorna a respectiva matriz jacobiana

[Jg,CD] = obj.jacobianageo(q,'efetuador');


%Posição
ep = CD(1:3,4)-Tdes(1:3,4);
Jep = Jg(1:3,:);

%Orientação
eo = sqrt(1.001-diag(Tdes(1:3,1:3)'*CD(1:3,1:3)));
n=length(q);
Jeo = zeros(1,n);

Jeo(1,:) = Tdes(1:3,1)'*Robo.matrizprodv(CD(1:3,1))*Jg(4:6,:)/(2*eo(1));
Jeo(2,:) = Tdes(1:3,2)'*Robo.matrizprodv(CD(1:3,2))*Jg(4:6,:)/(2*eo(2));
Jeo(3,:) = Tdes(1:3,3)'*Robo.matrizprodv(CD(1:3,3))*Jg(4:6,:)/(2*eo(3));

er=[ep;eo];
J=[Jep;Jeo];

end