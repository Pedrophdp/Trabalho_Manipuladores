function pdes=h_aux(tau,F,raio,v_hat,h_hat,L,pc,po)
    vh=F(tau);
    h=vh(1);
    v=vh(2);
    
    Pp=po+L*h*h_hat+L*v*v_hat;
    pdes= pc+(raio*(Pp-pc)/norm(Pp-pc)); %Ponto que se quer chegar
end