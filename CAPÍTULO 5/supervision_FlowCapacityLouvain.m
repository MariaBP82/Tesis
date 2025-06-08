folder = 'Redes';  % Carpeta con los archivos
files = dir(fullfile(folder, '*.csv'));

% Parámetros generales
s = 1;
self = 1;
debug = 0;
verbose = 0;
alphas = 0:0.01:1;
outputFile = 'ResultadosFCL_Total.xlsx';

% Ajuste de tipo de red (true = dirigida, false = no dirigida)
dirigida = true;

for f = 1:length(files)
    % Leer archivo CSV actual
    filename = fullfile(folder, files(f).name);
    fprintf('Procesando archivo: %s\n', files(f).name);

    edges = readmatrix(filename);  % Formato: origen, destino, peso

    % Crear grafo y matriz de adyacencia según el tipo de red
    if dirigida
        G = digraph(edges(:,1), edges(:,2), edges(:,3));
        AD = adjacency(G, 'weighted');  % Matriz dirigida
    else
        G = graph(edges(:,1), edges(:,2), edges(:,3));
        AD = adjacency(G, 'weighted');
        AD = max(AD, AD');  % Simetrizar
    end

    n = size(AD, 1);
    ID = zeros(n, n);

    % Usar digraph para cálculo de flujo, incluso si la red es no dirigida
    H = digraph(AD);

    % Calcular matriz de capacidades por flujo máximo
    for i = 1:n
        for j = i+1:n
            flujo_ij = maxflow(H, i, j);
            if dirigida
                flujo_ji = maxflow(H, j, i);
                ID(i,j) = flujo_ij;
                ID(j,i) = flujo_ji;
            else
                ID(i,j) = flujo_ij;
                ID(j,i) = flujo_ij;  % Simétrico
            end
        end
    end

    % Inicialización de resultados
    particiones = zeros(n, length(alphas));
    mod_AD = zeros(length(alphas), 1);
   
   
    for i = 1:length(alphas)
        alpha = alphas(i);
        fprintf('  Alpha = %.2f\n', alpha);

        [COMTY, ~] = compute_FlowCapacityLouvain(AD, ID, alpha, s, self, debug, verbose);

        nivel_final = length(COMTY.MOD);
        particion = COMTY.COM{nivel_final};

        particiones(:, i) = particion;
        mod_AD(i) = COMTY.mod(nivel_final);

       end

    % Formato de salida
    alphas_out = flip(alphas)';
    mod_AD_out = flip(mod_AD);
    particiones_out = flip(particiones, 2);

    particiones_texto = strings(length(alphas), 1);
    for i = 1:length(alphas)
        particion_i = particiones_out(:, i)';
        particiones_texto(i) = strjoin(string(particion_i), ',');
    end

    resultados = table(alphas_out, mod_AD_out, particiones_texto, ...
        'VariableNames', {'Alpha', 'Modularidad_Dirigida', 'Particion'});

    % Guardar hoja por red
    [~, sheetName, ~] = fileparts(files(f).name);
    writetable(resultados, outputFile, 'Sheet', sheetName);
end

fprintf('Proceso completado. Resultados guardados en %s\n', outputFile);