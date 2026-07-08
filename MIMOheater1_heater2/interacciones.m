
load IdentifiedSystem

%G(s=0) 
A=[0.6247, 0.2426;  0.2705, 0.5599]
% calculo de matriz de gamnacias relativas de bristol
Aintra= (inv(A))'

Ganre= [A(1,1) * Aintra(1,1), A(1,2) * Aintra(1,2) ;A(2,1) * Aintra(2,1), A(2,2) * Aintra(2,2)]
% calculo desacoplador
D = [1, -sys12p/sys11p; -sys21p/sys22p, 1]



save interacciones D