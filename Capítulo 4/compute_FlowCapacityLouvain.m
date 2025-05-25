% Iplementation : Antoine Scherrer
% antoine.scherrer@ens-lyon.fr
% Apply clustering after :
% "Fast unfolding of community hierarchies in large networks"
% Vincent D. Blondel, Jean-Loup Guillaume, Renaud Lambiotte,
% Etienne Lefebvre
% http://arxiv.org/abs/0803.0476
%
% 
% FULL MATLAB VERSION (SLOWER)
%
% Inputs : 
% M : weight matrix directed
% I : interaction matrix (flow)
% s : 1 = Recursive computation
%   : 0 = Just one level computation
% self : 1 = Use self weights
%        0 = Do not use self weights
% debug   : 1 = outputs some debug messages
% verbose : 1 = outputs some messages
%
% Output :
% COMTY, structure with the following information
% for each level i :
%   COMTY.COM{i} : vector of community IDs (sorted by community sizes)
%   COMTY.SIZE{i} : vector of community sizes
%   COMTY.MOD(i) : modularity of clustering
%   COMTY.Niter(i) : Number of iteration before convergence
%
function [COMTY, ending] = compute_FlowCapacityLouvain(M,I,alpha,s,self,debug,verbose)
%I sera la matriz de las relaciones, que consideramos la matriz de flujo
%nargin es el numero de argumentos de entrada de la funcion
%nargin, debug, verbose son de matlab  

if nargin < 1
  error('not enough argument');
end

if nargin < 4
  s = 1; %en este caso se ejecutara de forma recursiva
end

if nargin < 5
  self = 1; %en este caso usara pesos propios (no se los damos como argumento)
end
 
if nargin < 6
  debug = 0; %no muestra mensajes de depuracion
end

if nargin < 7
  verbose = 0; %no mostrara ningun mensaje
end


%M es la matriz de pesos, es asimétrica
S = size(M); %tamaño de la matriz de pesos (numFilas, numColumnas)
N = S(1); %numero de filas de la matriz de peso, que no es otra cosa que el numero de nodos
%N

ddebug = 0;
ending = 0;


MT = M'; %matriz traspuesta
MS = M + M'; %matriz simétrica para buscar vecinos es necesaria

IT = I'; %matriz traspuesta


%el elemento (N+1) es el primer elemento de la 2 fila
%.* multiplica elemento a elemento
MS((N+1).*[0:N-1]+1) = 0; %la diagonal principal de la matriz simétrica que uso para buscar los vecinos de pesos vale 0



%fprintf('matriz M antes calcular m'); 

m = sum(sum(M)); %numero de aristas (es capaz de considerar pesos!)
m_I = sum(sum(I));

Niter = 1; %num iteraciones


fprintf('valor m');


if m==0 | N == 1 %cuando m==0 (todos los pesos valen 0, pues la suma de todos los pesos de la matriz es nula) o N==1 (solo queda un nodo) no se puede descomponer mas
  fprintf('No more possible decomposition\n');
  ending = 1; %acaba el algoritmo
  COMTY = 0;
  return;
end

% Main loop
Kin = sum(M); %número de aristas entrantes en i, es el grado in del nodo i
Kout = sum(MT); %número de aristas salientes en i, es el grado out del nodo i
SumTotin = sum(M); %se inicializa de modo que SumTot(i) es el grado-in del nodo i, pero llevara el grado del cluster, se inicialia como el grado del nodo porque al empezar cada cluster tiene un solo nodo
SumTotout = sum(MT); %se inicializa de modo que SumTot(i) es el grado-out del nodo i, pero llevara el grado del cluster, se inicialia como el grado del nodo porque al empezar cada cluster tiene un solo nodo
%SumIn(i) es la suma de los pesos arcos en el cluster i
SumIn = diag(M); % Sum of weight inside community i EXTRAE LA DIAGONAL PRINCIPAL DE M, inicialmente el numero de arcos de cada cluster es 0, aqui vamos guardando los arcos dentro de cada cluster 

Kin_I = sum(I); %número de aristas entrantes en i, es el grado in del nodo i
Kout_I = sum(IT); %número de aristas salientes en i, es el grado out del nodo i
SumTotin_I = sum(I); %se inicializa de modo que SumTot(i) es e grado-in del nodo i, pero llevara el grado del cluster, se inicialia como el grado del nodo porque al empezar cada cluster tiene un solo nodo
SumTotout_I = sum(IT); %se inicializa de modo que SumTot(i) es e grado-out del nodo i, pero llevara el grado del cluster, se inicialia como el grado del nodo porque al empezar cada cluster tiene un solo nodo
SumIn_I = diag(I); 



%Genero una lista de comunidades. Como inicialmente cada nodo esta en su propia comunidad, habra tantas comunidades como nodos
COM = 1:S(1); % Community of node i, COM{j} sera la comunidad numero j COM es un vector de N elementos
for k=1:N
  Neighbor{k} = find(MS(k,:));  %encuentra los nodos vecinos de k (la funcion find busca indices y valores de elementos no nulos)
 %se queda con los indices de la fila k que no sean nulos, esto es, los
 %(guarda las posiciones, en este caso, la columna (la fila es k))
 %nodos vecinos a k
 %neighbor es un array
 end

sCost = 10;
gain = 1;
while (gain == 1) %mientras haya mejoras en la modularidad, itera
  Cost = zeros(1,N); %matriz de ceros de 1 fila y N columnas
  gain = 0;
  for i=1:N
    Ci = COM(i); %cluster numero i, Ci es un numero que representa el id del cluster correspondiente
    NB = Neighbor{i}; %nodos vecinos al nodo i con los que podria unirse
    G = zeros(1,N); % Gain vector %la posicion G(j) es la ganancia del nodo i si se une a j
    best_increase = -1; %al empezar la mejor mejora es negativa
    Cnew = Ci;   %al empezar, el cluster al que pertenece es el suyo propio
    COM(i) = -1;   %como voy a modificar el cluster que ocupa la posicion i, para marcarlo en la lista de clusters, lo pongo como -1
    %aqui calcula la modularidad del cluster Ci en caso de que se vaya el
    %nodo i
    SumTotin(Ci) = SumTotin(Ci) - Kin(i); %la columna i de K es la suma de todos los nodos conectados con i (el grado in de la comunidad i)
    SumTotout(Ci) = SumTotout(Ci) - Kout(i); %la columna i de K es la suma de todos los nodos que salen de i (el grado out de i)
    %Hago lo analogo para la matriz de flujos
    SumTotin_I(Ci) = SumTotin_I(Ci) - Kin_I(i); %la columna i de K es la suma de todos los nodos conectados con i (el grado in de la comunidad i)
    SumTotout_I(Ci) = SumTotout_I(Ci) - Kout_I(i); %la columna i de K es la suma de todos los nodos que salen de i (el grado out de i)
    
    CNj1 = find(COM==Ci); %busca en el vector de id de cluster la posicion de aquellos que tengan el mismo valor que Ci
    %la funcion find devuelve la posicion del elemento, numera las
    %posiciones de columna en columna
    %suma los arcos que hay dentro del cluster Ci, sin considerar el del
    %nodo i
    SumIn(Ci) = SumIn(Ci) - sum(M(i,CNj1)) - sum(MT(i,CNj1)) - M(i,i);
    
    SumIn_I(Ci) = SumIn_I(Ci) - sum(I(i,CNj1)) - sum(IT(i,CNj1)) - I(i,i);
   
    for j=1:length(NB) %recorre todos los nodos vecinos del nodo que se esta analizando, i
      Cj = COM(NB(j)); %cluster al que pertenece el nodo j, que es vecino a i  
      if (G(Cj) == 0) %si la ganancia al unirse al cluster Cj es 0
        CNj = find(COM==Cj); %encuentra aquellos cluster que tengan el mismo id que Cj (que es el cluster al que pertenece el nodo j)
        Ki_in = sum(M(i,CNj)) + sum(MT(i,CNj));
          %aqui hay que incluir el peso de la matriz de relaciones (flujos)
        Ki_in_I = sum(I(i,CNj)) + sum(IT(i,CNj));  
        %sumamos los numeros directamente de la relacion del nodo i con
        %todos los nodos que estan en la comunidad que estamos analizando
        G(Cj) = alpha*(Ki_in/m - (Kin(i)*SumTotout(Cj)+Kout(i)*SumTotin(Cj))/(m*m)) + (1-alpha)*(Ki_in_I/m_I - (Kin_I(i)*SumTotout_I(Cj)+Kout_I(i)*SumTotin_I(Cj))/(m_I*m_I)); %calcula la situacion del nodo si se mueve de comunidad ¿Como incluyo aqui la parte de relaciones?
        
        if (ddebug)
          fprintf('Gaim for comm %d => %g\n',Cj-1,G(Cj));
        end
        if G(Cj) > best_increase;
          best_increase = G(Cj); %si hay ganancia en la modularidad, cambia el cluster
          Cnew_t = Cj;
         end
       end
    end
    if best_increase > 0 %si ha habido mejora, actualiza el cluster
      Cnew = Cnew_t;
           
      if (debug)
        fprintf('Move %d => %d\n',i-1,Cnew-1);
      end
      Cost(i) = best_increase;
    end
   
    Ck = find(COM==Cnew);
    SumIn(Cnew) = SumIn(Cnew) + sum(M(i,Ck)) + sum(MT(i,Ck));
    SumTotin(Cnew) = SumTotin(Cnew) + Kin(i);
    SumTotout(Cnew) = SumTotout(Cnew) + Kout(i);
    
    SumIn_I(Cnew) = SumIn_I(Cnew) + sum(I(i,Ck)) + sum(IT(i,Ck));
    SumTotin_I(Cnew) = SumTotin_I(Cnew) + Kin_I(i);
    SumTotout_I(Cnew) = SumTotout_I(Cnew) + Kout_I(i);
    
   
    COM(i) = Cnew;
    if (Cnew ~= Ci)
      gain = 1;
    end
    
  end
 
  sCost = sum(Cost);
  [C2 S2] = reindex_com(COM);
  Nco = length(unique(COM));
  Nco2 = length(S2(S2>1));
  mod = compute_modularity(COM,M);
  mod_I = compute_modularity(COM,I); 
  if (debug)
    fprintf('It %d - Mod=%f %d com (%d non isolated)\n',Niter,mod,Nco,Nco2);
  end
  Niter = Niter + 1;
  
end
%fprintf('ANTES DE EMPEZAR SEGUNDA FASE //');
COM;

Niter = Niter - 1;

[COM COMSIZE] = reindex_com(COM);

COMTY.COM{1} = COM;
COMTY.SIZE{1} = COMSIZE;
COMTY.MOD(1) = compute_modularity(COM,M); %guardo la modularidad de M
COMTY.MOD_I(1) = compute_modularity(COM,I); %guardo la modularidad de I
COMTY.Niter(1) = Niter;
%fprintf('valor s antes 2 parte');
s;


%fprintf('valor COM antes 2 parte');
COM;
% Perform part 2 algoritmo Blondel
if (s == 1)
  %fprintf('He entrado a la segunda parte //')
  Mnew = M;
  Mold = Mnew;
  Inew = I;
  Iold = Inew;
   
  
  %inicializa con el vector de cluster que ha obtenido en la fase 1
  
  COMcur = COM;   %vector of community IDs (sorted by community sizes)
  COMfull = COM;  %vector of community IDs (sorted by community sizes)
  k = 2;
  
  
%fprintf('ya se ha empezado 2 valor com');
  if (debug)
    Nco2 = length(COMSIZE(COMSIZE>1));
   % fprintf('Pass number 1 - %d com (%d iterations)\n',Nco2,Niter);
  end
  while 1
    Mold = Mnew;
    S2 = size(Mold);
    Nnode = S2(1);
  
    Iold = Inew;
    S2_I = size(Iold);
    Nnode_I = S2_I(1);
       
    
    COMu = unique(COMcur);   %elimina los valores repetidos, para quedarse con cada cluster solo una vez
    Ncom = length(COMu);   %cantidad de clusters que se han formado en la fase 1
    ind_com = zeros(Ncom,Nnode);
    ind_com_full = zeros(Ncom,N);
   
    ind_com_I = zeros(Ncom,Nnode);
    ind_com_full_I = zeros(Ncom,N);
  
   %busca los nodos que forman cada supernodo, hay Ncom supernodos
    for p=1:Ncom
      ind = find(COMcur==p);
      ind_com(p,1:length(ind)) = ind;
    end
    for p=1:Ncom
      ind = find(COMfull==p);
      ind_com_full(p,1:length(ind)) = ind;
    end
    
    
    Mnew = zeros(Ncom,Ncom); %matriz M de super nodos
    Inew = zeros(Ncom,Ncom); %matriz I de super nodos
   
    for m=1:Ncom
      for n=1:Ncom 
        ind1 = ind_com(m,:);
        ind2 = ind_com(n,:);
        Mnew(m,n) = sum(sum(Mold(ind1(ind1>0),ind2(ind2>0))));
        Inew(m,n) = sum(sum(Iold(ind1(ind1>0),ind2(ind2>0))));
      end
    end
    
    
      %fprintf('matriz Mnew con la que llamo a la  funcion')
 Mnew;
 Inew;
    
    [COMt e] = compute_LOUVAIN_DIR_FLOW(Mnew,Inew,alpha,0,self,debug,verbose);
    %fprintf('valor e despues llamar funcion');
   % e

    if (e ~= 1) %e es el parametro que marca el final del algoritmo
     
   % fprintf('he entrado al condicional de e //');
      COMfull = zeros(1,N);
      COMcur = COMt.COM{1};
           
      for p=1:Ncom  
        ind1 = ind_com_full(p,:);
        COMfull(ind1(ind1>0)) = COMcur(p);
      end
   %  fprintf('antes de llamar a reindex')
     COMfull;
      [COMfull COMSIZE] = reindex_com(COMfull);
      COMTY.COM{k} = COMfull;
      COMTY.SIZE{k} = COMSIZE;
      COMTY.MOD(k) = compute_modularity(COMfull,M);
      COMTY.MOD_I(k) = compute_modularity(COMfull,I);
      COMTY.Niter(k) = COMt.Niter;
      Nco2 = length(COMSIZE(COMSIZE>1));
           
    % fprintf('comunidades despues llamada paso2 y reindex') %AQUI ya HA CAMBIADO COMfull
     COMfull;
      
      
      if (debug)   
       % fprintf('Pass number %d - %d com\n',k,Nco2);
      end
      Ind = (COMfull == COMTY.COM{k-1});
      if (sum(Ind) == length(Ind))
         if (debug)
         % fprintf('Identical segmentation => End\n');
        end
        return;
      end
    else
      if (debug)
       % fprintf('Empty matrix => End\n');
      end
      return;
    end %aqui acaba el condicional de e
    k = k + 1;
 
  end
end %aqui acaba el condicional de s==1
 

end

% Re-index community IDs
function [C Ss] = reindex_com(COMold)

C = zeros(1,length(COMold)); %general una matriz de 0 de una fila y length(COMold) columnas
COMu = unique(COMold); %pone en una sola columna todos los elementos sin repeticiones de COMolf (esto es, no pone las repeticiones)

S = zeros(1,length(COMu));   %genera una matriz de 0 de una fila y length(COMold) columnas
for l=1:length(COMu)
    S(l) = length(COMold(COMold==COMu(l)));
   
end
[Ss INDs] = sort(S,'descend');

for l=1:length(COMu)
    C(COMold==COMu(INDs(l))) = l;
    
end


end
    


%Compute modulartiy
function MOD = compute_modularity(C,Mat) %calcula la modularidad del cluster c
%fprintf('Voy a calcular modularidad en esta comunidad: ')
m = sum(sum(Mat));
MOD = 0;
COMu = unique(C);
for j=1:length(COMu)
    Cj = find(C==COMu(j));
    Ec = sum(sum(Mat(Cj,Cj)));
    Et1 = sum(sum(Mat(Cj,:)));
    Et2 = sum(sum(Mat(:,Cj)));
    if Et1>0 | Et2>0
        MOD = MOD + Ec/m-((Et1*Et2)/(m*m));
    end
end
    
end



