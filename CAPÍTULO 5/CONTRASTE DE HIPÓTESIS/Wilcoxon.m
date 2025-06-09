%% Ingresar valores de "x" y de "y"
load datoslouvain.dat
x = datoslouvain; 

load datosalfa77.dat
y = datosalfa77; 


%% Prueba de hipótesis de Wilcoxon

[p,h,stats] = signrank(x,y)
if h==0;
    disp('No se rechaza H0 (Las medias son iguales)');
else
    disp('Se rechaza H0 (Las medias no son iguales)');
end
    

%%%%%%%%%%%%%%%%%%%
% Realiza la prueba de Wilcoxon
[p, ~, stats] = signrank(x, y);

% Calcula el intervalo de confianza mediante bootstrap
rng('default');  % Configura la semilla para reproducibilidad
num_bootstrap_samples = 10000;
diff_medians_bootstrap = zeros(1, num_bootstrap_samples);

for i = 1:num_bootstrap_samples
    % Muestra con reemplazo
    x_bootstrap = randsample(x, length(x), true);
    z_bootstrap = randsample(z, length(z), true);
    
    % Calcula la diferencia de medianas
    diff_medians_bootstrap(i) = median(x_bootstrap) - median(z_bootstrap);
end

% Calcula los percentiles para obtener el intervalo de confianza
alpha = 0.0125;
lower_bound = prctile(diff_medians_bootstrap, alpha/2 * 100);
upper_bound = prctile(diff_medians_bootstrap, (1 - alpha/2) * 100);

% Muestra el resultado
disp(['Intervalo de confianza para la diferencia de medianas: [', num2str(lower_bound), ', ', num2str(upper_bound), ']']);



%%%%%%%%%%%%%%%%%%%% PARA LA MEDIA DE ALPHA
% Calcula el intervalo de confianza mediante bootstrap
load alfas_test.dat
alpha = alfas_test;

% Nivel de confianza (por ejemplo, 95%)
confidence_level = 0.9875;

% Calcula la media de alpha
alpha_mean = mean(alpha);

% Realiza la prueba de Wilcoxon
[p, ~, stats] = signrank(alpha);

% Número de observaciones
n = length(alpha);

% Grados de libertad para la distribución t
df = n - 1;

% Valor crítico de t
t_critical = tinv((1 + confidence_level) / 2, df);

% Error estándar de la media
se = std(alpha) / sqrt(n);

% Calcula el intervalo de confianza
confidence_interval = alpha_mean + t_critical * se * [-1, 1];

fprintf('Intervalo de confianza del %.2f%% para la media de alpha: [%.4f, %.4f]\n', confidence_level * 100, confidence_interval);