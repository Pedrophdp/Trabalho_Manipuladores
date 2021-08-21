function f = funcontrole(x,v,tol_e)

%v = velocidade de convergência (em erro/s)
%tol_e = tolerância de erro

if length(v)==1
   v = v*ones(size(x)); 
end
if length(tol_e)==1
   tol_e = tol_e*ones(size(x)); 
end


f = zeros(size(x));
a = 1./(tol_e.^6);

f = (2/pi)*sign(x).*v.*atan(a.*x.^6);

end