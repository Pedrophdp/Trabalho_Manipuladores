function [Dist,xmp_obj,xmp_obj2] =calcdistanciagen(obj,obj2,q)

qant=obj.q;
obj.config(q);
[Dist,xmp_obj,xmp_obj2] =obj.calcdistancia(obj2);
obj.config(qant);

end