function [T3,delta] = framealinhado(T1,T2,h,tipo)
%Desloca um frame para desenhar

delta=(T2(1:3,4)-T1(1:3,4));

if tipo==0
    %Junta rotativa
    if norm(delta)~=0
        deltan=delta/(norm(delta));
        R=[null(deltan') deltan];
        
        if det(R)<0
            R(1:3,1:2)=R(1:3,2:-1:1);
        end
    else
        R=T2(1:3,1:3);
    end
    
    T3 = [ R  T1(1:3,4); 0 0 0 1];
end

if tipo==1
    %Junta prismática
    T3=T1;
    if ~isempty(h)
     T3(1:3,4)=T3(1:3,4)+T3(1:3,3)*(norm(delta)-h);
    end
end

end