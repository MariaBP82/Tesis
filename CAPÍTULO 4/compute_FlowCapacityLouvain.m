% Implementation : Antoine Scherrer
% antoine.scherrer@ens-lyon.fr
% Apply clustering after :
% "Fast unfolding of community hierarchies in large networks"
% Vincent D. Blondel, Jean-Loup Guillaume, Renaud Lambiotte,
% Etienne Lefebvre
% http://arxiv.org/abs/0803.0476
%
% FULL MATLAB VERSION (SLOWER)
%
% Inputs : 
% AD : weight matrix directed (matriz de adyacencia dirigida)
% ID : interaction matrix (flow) (matriz de flujos)
% s : 1 = Recursive computation
%   : 0 = Just one level computation
% self : 1 = Use self weights
%        0 = Do not use self weights
% debug   : 1 = outputs some debug messages
% verbose : 1 = outputs some messages
%
% Output :
% COMTY, estructura con la siguiente información por cada nivel i:
%   COMTY.COM{i} : vector de IDs de comunidad (ordenados por tamaño)
%   COMTY.SIZE{i} : vector con los tamaños de las comunidades
%   COMTY.MOD(i) : modularidad de la partición con AD
%   COMTY.MOD_I(i) : modularidad de la partición con ID
%   COMTY.Niter(i) : número de iteraciones hasta convergencia

function [COMTY, ending] = compute_FlowCapacityLouvain(AD,ID,alpha,s,self,debug,verbose)
% AD será la matriz de adyacencia dirigida
% ID será la matriz de las relaciones, considerada la matriz de flujo

if nargin < 1
  error('not enough argument'); % verificar que haya al menos un argumento
end

if nargin < 4
  s = 1; % valor por defecto: ejecutar recursivamente
end

if nargin < 5
  self = 1; % valor por defecto: usar pesos propios (autoconexiones)
end
 
if nargin < 6
  debug = 0; % valor por defecto: sin mensajes de depuración
end

if nargin < 7
  verbose = 0; % valor por defecto: sin mensajes informativos
end

% AD es la matriz de pesos, es asimetrica
% Inicialización
S = size(AD);       % tamaño de la matriz AD (numFilas, numColumnas)
N = S(1);          % número de nodos (filas de AD)

ddebug = 0;        % bandera para depuración profunda
ending = 0;        % bandera que indica si se termina la ejecución

AT = AD';           % matriz traspuesta de AD
AS = AD + AD';       % matriz simétrica para encontrar vecinos

IT = ID';           % matriz traspuesta de flujos

AS((N+1).*[0:N-1]+1) = 0; % pone a 0 la diagonal de la matriz simétrica

m = sum(sum(AD));     % suma total de pesos (número de aristas en A)
m_I = sum(sum(ID));   % suma total de flujos

Niter = 1;           % contador de iteraciones

fprintf('valor m');

if m==0 || N == 1 %cuando m==0 (todos los pesos valen 0, pues la suma de todos los pesos de la matriz es nula) o N==1 (solo queda un nodo) no se puede descomponer mas.
  fprintf('No more possible decomposition\n');
  ending = 1;
  COMTY = 0;
  return;
end

% Preparar variables de grado y suma para AD
Kin = sum(AD);        % grado de entrada de cada nodo en AD
Kout = sum(AT);      % grado de salida de cada nodo en AD
SumTotin = sum(AD);   % suma total de entradas por comunidad
SumTotout = sum(AT); % suma total de salidas por comunidad
SumIn = diag(AD);     % suma de pesos internos (diagonal de AD)

% Preparar variables equivalentes para la matriz de flujo I
Kin_I = sum(ID); %numero de aristas entrantes en i, es el grado in del nodo i
Kout_I = sum(IT); %numero de aristas salientes en i, es el grado out del nodo i
SumTotin_I = sum(ID); %se inicializa de modo que SumTot(i) es e grado-in del nodo i, pero llevara el grado del cluster, se inicialia como el grado del nodo porque al empezar cada cluster tiene un solo nodo
SumTotout_I = sum(IT); %se inicializa de modo que SumTot(i) es e grado-out del nodo i, pero llevara el grado del cluster, se inicialia como el grado del nodo porque al empezar cada cluster tiene un solo nodo
SumIn_I = diag(ID);

% Inicializar comunidades: cada nodo en su propia comunidad
COM = 1:S(1);         
for k=1:N
  Neighbor{k} = find(AS(k,:)); % lista de vecinos del nodo k
end

% Variables de control para iteración de optimización
sCost = 10;
gain = 1;

while (gain == 1) % mientras haya ganancia de modularidad
  Cost = zeros(1,N);
  gain = 0;
  for i=1:N
    Ci = COM(i); % comunidad actual del nodo i
    NB = Neighbor{i}; % vecinos del nodo i
    G = zeros(1,N); % vector de ganancia de modularidad
    best_increase = -1; % mejor ganancia encontrada
    Cnew = Ci; % comunidad destino por defecto: actual
    COM(i) = -1; % marcar que se moverá
    
    % Quitar nodo i de su comunidad actual
    SumTotin(Ci) = SumTotin(Ci) - Kin(i);
    SumTotout(Ci) = SumTotout(Ci) - Kout(i);
    SumTotin_I(Ci) = SumTotin_I(Ci) - Kin_I(i);
    SumTotout_I(Ci) = SumTotout_I(Ci) - Kout_I(i);
    
    CNj1 = find(COM==Ci); % nodos en la misma comunidad original
    SumIn(Ci) = SumIn(Ci) - sum(AD(i,CNj1)) - sum(AT(i,CNj1)) - AD(i,i);
    SumIn_I(Ci) = SumIn_I(Ci) - sum(ID(i,CNj1)) - sum(IT(i,CNj1)) - ID(i,i);

    for j=1:length(NB)
      Cj = COM(NB(j));
      if (G(Cj) == 0)
        CNj = find(COM==Cj);
        Ki_in = sum(AD(i,CNj)) + sum(AT(i,CNj));
        Ki_in_I = sum(ID(i,CNj)) + sum(IT(i,CNj));

        G(Cj) = alpha*(Ki_in/m - (Kin(i)*SumTotout(Cj)+Kout(i)*SumTotin(Cj))/(m*m)) ...
              + (1-alpha)*(Ki_in_I/m_I - (Kin_I(i)*SumTotout_I(Cj)+Kout_I(i)*SumTotin_I(Cj))/(m_I*m_I));
        
        if G(Cj) > best_increase
          best_increase = G(Cj);
          Cnew_t = Cj;
        end
      end
    end

    if best_increase > 0
      Cnew = Cnew_t;
      Cost(i) = best_increase;
    end

    % Añadir nodo a nueva comunidad
    Ck = find(COM==Cnew);
    SumIn(Cnew) = SumIn(Cnew) + sum(AD(i,Ck)) + sum(AT(i,Ck));
    SumTotin(Cnew) = SumTotin(Cnew) + Kin(i);
    SumTotout(Cnew) = SumTotout(Cnew) + Kout(i);

    SumIn_I(Cnew) = SumIn_I(Cnew) + sum(ID(i,Ck)) + sum(IT(i,Ck));
    SumTotin_I(Cnew) = SumTotin_I(Cnew) + Kin_I(i);
    SumTotout_I(Cnew) = SumTotout_I(Cnew) + Kout_I(i);

    COM(i) = Cnew;
    if (Cnew ~= Ci)
      gain = 1;
    end
  end

  sCost = sum(Cost);
  [C2 S2] = reindex_com(COM); % reindexar comunidades
  Nco = length(unique(COM));
  Nco2 = length(S2(S2>1));
  mod = compute_modularity(COM,AD);
  mod_I = compute_modularity(COM,ID);
  Niter = Niter + 1;
end

% Almacenar resultados de la primera fase
Niter = Niter - 1;
[COM COMSIZE] = reindex_com(COM);
COMTY.COM{1} = COM;
COMTY.SIZE{1} = COMSIZE;
COMTY.MOD(1) = compute_modularity(COM,AD);
COMTY.MOD_I(1) = compute_modularity(COM,ID);
COMTY.Niter(1) = Niter;

% Segunda fase: aplicar algoritmo a comunidades como supernodos
if (s == 1)
  Anew = AD;
  Inew = ID;
  COMcur = COM;
  COMfull = COM;
  k = 2;
  
  while 1
    Aold = Anew;
    Iold = Inew;
    S2 = size(Aold);
    Nnode = S2(1);

    COMu = unique(COMcur);
    Ncom = length(COMu);
    ind_com = zeros(Ncom,Nnode);
    ind_com_full = zeros(Ncom,N);

    for p=1:Ncom
      ind = find(COMcur==p);
      ind_com(p,1:length(ind)) = ind;
    end
    for p=1:Ncom
      ind = find(COMfull==p);
      ind_com_full(p,1:length(ind)) = ind;
    end

    Anew = zeros(Ncom,Ncom);
    Inew = zeros(Ncom,Ncom);
    for m=1:Ncom
      for n=1:Ncom
        ind1 = ind_com(m,:);
        ind2 = ind_com(n,:);
        Anew(m,n) = sum(sum(Aold(ind1(ind1>0),ind2(ind2>0))));
        Inew(m,n) = sum(sum(Iold(ind1(ind1>0),ind2(ind2>0))));
      end
    end

    [COMt e] = compute_LOUVAIN_DIR_FLOW(Anew,Inew,alpha,0,self,debug,verbose);

    if (e ~= 1)
      COMfull = zeros(1,N);
      COMcur = COMt.COM{1};
      for p=1:Ncom
        ind1 = ind_com_full(p,:);
        COMfull(ind1(ind1>0)) = COMcur(p);
      end
      [COMfull COMSIZE] = reindex_com(COMfull);
      COMTY.COM{k} = COMfull;
      COMTY.SIZE{k} = COMSIZE;
      COMTY.MOD(k) = compute_modularity(COMfull,AD);
      COMTY.MOD_I(k) = compute_modularity(COMfull,ID);
      COMTY.Niter(k) = COMt.Niter;
      Ind = (COMfull == COMTY.COM{k-1});
      if (sum(Ind) == length(Ind))
        return;
      end
    else
      return;
    end
    k = k + 1;
  end
end

end

% Reindexa IDs de comunidad en orden descendente de tamaño
function [C Ss] = reindex_com(COMold)
C = zeros(1,length(COMold));
COMu = unique(COMold);
S = zeros(1,length(COMu));
for l=1:length(COMu)
    S(l) = length(COMold(COMold==COMu(l)));
end
[Ss INDs] = sort(S,'descend');
for l=1:length(COMu)
    C(COMold==COMu(INDs(l))) = l;
end
end

% Calcula la modularidad de una partición
function MOD = compute_modularity(C,Mat)
m = sum(sum(Mat));
MOD = 0;
COMu = unique(C);
for j=1:length(COMu)
    Cj = find(C==COMu(j));
    Ec = sum(sum(Mat(Cj,Cj)));
    Et1 = sum(sum(Mat(Cj,:)));
    Et2 = sum(sum(Mat(:,Cj)));
    if Et1>0 || Et2>0
        MOD = MOD + Ec/m - ((Et1*Et2)/(m*m));
    end
end
end
