%Compute modulartiy dirigida

function MOD = compute_modularity_dir(C,Mat) %calcula la modularidad del cluster c
%fprintf('Voy a calcular modularidad en esta comunidad: ')
m = sum(sum(Mat))
MOD = 0
COMu = unique(C)
for j=1:length(COMu)
    j
    Cj = find(C==COMu(j)) 
    Ec = sum(sum(Mat(Cj,Cj)))
    Et1 = sum(sum(Mat(Cj,:)))
    Et2 = sum(sum(Mat(:,Cj)))
    if Et1>0 | Et2>0
        MOD = MOD + Ec/m-((Et1*Et2)/(m*m))
    end
end    
end

