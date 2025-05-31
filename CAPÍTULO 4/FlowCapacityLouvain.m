% Cargar matrices desde archivos CSV
AD = readmatrix('AD.csv');  % Matriz de adyacencia A^D
ID = readmatrix('ID.csv');  % Matriz de adyacencia I^D

% Parámetros
alpha = 0.5;      % Peso relativo entre estructura y flujo (toma valores entre 0 y 1)
s = 1;            % Recursividad (1 = sí)
self = 1;         % Incluir pesos propios
debug = 0;        % No mostrar mensajes de depuración
verbose = 0;      % No mostrar mensajes

% Llamar a la función
[COMTY, ending] = compute_FlowCapacityLouvain(AD, ID, alpha, s, self, debug, verbose);

% Mostrar resultado
disp('Comunidades detectadas:');
disp(COMTY);