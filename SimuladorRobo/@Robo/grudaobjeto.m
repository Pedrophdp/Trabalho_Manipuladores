function [] = grudaobjeto(obj,obj_grudar)
%Gruda um objeto no efetuador

   obj.obj_noefetuador{end+1} = obj_grudar;
   obj.mth_objefetuador{end+1}=obj.obj_eixoefetuador.mth\obj_grudar.mth;
   
   %Apaga os objetos e forca a redesenhar
   obj.obj_links=[];
   obj.obj_efetuador=[];
   obj.obj_base=[];
   obj.config(obj.q);
end