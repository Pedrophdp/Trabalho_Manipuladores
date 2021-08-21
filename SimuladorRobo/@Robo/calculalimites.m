function Limites = calculalimites(obj)
%Calcula os limites Limites=[xmin xmax ymin ymax zmin zmax]
%em que o objeto com certeza está contido
         
         xmin=Inf;
         xmax=-Inf;
         ymin=Inf;
         ymax=-Inf;
         zmax=-Inf;
         qmin=obj.info_links.limites_q(:,1);
         qmax=obj.info_links.limites_q(:,2);
         
         qinit=obj.q;
         for i = 1: 80
             
             if i > 1
              qrand= qmin+(qmax-qmin).*rand(length(obj.q),1);
             else
              qrand = obj.q;
             end
           obj.config(qrand);
           
           for j = 1: length(obj.obj_links);
             lim=obj.obj_links(j).calculalimites();
             xmin = min(xmin,lim(1));
             xmax = max(xmax,lim(2));
             ymin = min(ymin,lim(3));
             ymax = max(ymax,lim(4));
             zmax = max(zmax,lim(5));
           end
           
           lim = obj.obj_link_efetuador.calculalimites();
           xmin = min(xmin,lim(1));
           xmax = max(xmax,lim(2));
           ymin = min(ymin,lim(3));
           ymax = max(ymax,lim(4));
           zmax = max(zmax,lim(5));
           
           
           lim = obj.obj_eixoefetuador.calculalimites();
           xmin = min(xmin,lim(1));
           xmax = max(xmax,lim(2));
           ymin = min(ymin,lim(3));
           ymax = max(ymax,lim(4));
           zmax = max(zmax,lim(5));             
             
         end
         
         Deltax = xmax-xmin;
         Deltay = ymax-ymin;
         Deltaz = 1.4*zmax;
         
         A=[Deltax -2*Deltay 0; -2*Deltax Deltay 0; Deltax 0 -4*Deltaz; -4*Deltax 0 Deltaz];
         opts1=  optimset('display','off');
         p=quadprog(eye(3),zeros(3,1),A,zeros(4,1),[],[],ones(3,1),[],[],opts1);
         gammax=p(1)-1;
         gammay=p(2)-1;
         gammaz=p(3)-1;
         
         Limites(1) = xmin-gammax*Deltax;
         Limites(2) = xmax+gammax*Deltax;
         Limites(3) = ymin-gammay*Deltay;
         Limites(4) = ymax+gammay*Deltay;         
         Limites(5) = -0.4*zmax - gammaz*Deltaz;
         Limites(6) = zmax+gammaz*Deltaz; 
         
         obj.config(qinit);
         
end