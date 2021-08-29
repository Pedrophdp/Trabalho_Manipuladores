function [r,Jr,Jgeo,pdes]=r_aux(q,t,R,H,pc)

pdes=H(0.2*t);
zdes= -(pdes-pc)/norm(pdes-pc);

[Jgeo,Tef] = R.jacobianageo(q, 'efetuador');
pef = Tef(1:3,4);
zef = Tef(1:3,3);
Jp = Jgeo(1:3,:);
Jw = Jgeo(4:6,:);

rpos = pef-pdes;
roriz = 1 - zdes'*zef;

r = [rpos;  roriz];
Jrpos = Jp;
Jroriz = zdes'*Robo.matrizprodv(zef)*Jw;
Jr = [Jrpos; Jroriz];
end