function D = calculadensidade(obj)
%Calcula a densidade (robô)

   M=0;
   V=0;
  for i = 1: length(obj.obj_links)
   M=M+obj.obj_links(i).massa();  
   V=V+obj.obj_links(i).massa()/(obj.obj_links(i).densidade+0.001);
  end
  
  D=M/V;

end