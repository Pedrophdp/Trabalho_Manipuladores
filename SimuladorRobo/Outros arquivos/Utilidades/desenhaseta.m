function []=desenhaseta(x,y,z,u,v,w,cor)
%Desenha uma seta
  plot3([x x+0.95*u],[y y+0.95*v],[z z+0.95*w],'linewidth',2,'Color',cor); 
end