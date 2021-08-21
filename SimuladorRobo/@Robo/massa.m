function M = massa(obj)
%Calcula a massa (robô)

   M=0;
  for i = 1: length(obj.obj_links)
   M=M+obj.obj_links(i).massa();   
  end

end