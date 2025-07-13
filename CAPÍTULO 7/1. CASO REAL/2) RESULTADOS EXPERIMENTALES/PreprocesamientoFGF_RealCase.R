##################################################################
#                        LECTURA DE MATRICES                     #
################################################################## 
if (!requireNamespace("readr", quietly = TRUE)) {
  install.packages("readr")
}
library(readr)
AD_mat <-read_delim("National_mobility.csv", delim = ";", col_names = TRUE)
ID <-read_delim("National_mobility_flujo.csv", delim = ";", col_names = FALSE)

# Asegurarse de que las columnas tienen nombres estándar
colnames(AD_mat) <- c("nod_sal", "nod_ent", "cap")

# Determinar el número de nodos 
n_nodos <- max(c(AD_mat$nod_sal, AD_mat$nod_ent))

# Inicializar matriz de adyacencia con ceros
AD <- matrix(0, nrow = n_nodos, ncol = n_nodos)

# Rellenar la matriz con las capacidades (asumido como peso)
for (i in 1:nrow(AD_mat)) {
  fila <- AD_mat[i, ]
  AD[fila$nod_sal, fila$nod_ent] <- fila$cap
}

# Convertir a matriz numérica
ID <- as.matrix(ID)
ID <- apply(ID, 2, as.numeric)


####################################################################
if (!requireNamespace("igraph", quietly = TRUE)) {
  install.packages("igraph")
}
library(igraph)

set.seed(123)  # Se fija semilla para que los resultados sean reproducibles


##################################################################
#                        PREPROCESAMIENTO                        #
################################################################## 
alpha <- seq(from = 1, to = 0, by = -0.01)

comunidades_lou = c()
comunidades_lei = c()


for (i in alpha) {
  if (i==1) {
    M = i*AD 
    Msim = M+t(M)
    g = graph_from_adjacency_matrix(
      Msim,
      mode = c("undirected"),
      weighted = TRUE,
    )
    
    # Louvain (1)
    louvain <- cluster_louvain(g)
    comunidades_lou = rbind(comunidades_lou, membership(louvain))
    # Leiden (2)
    leiden <- cluster_leiden(g, objective_function = "modularity")
    comunidades_lei = rbind(comunidades_lei, membership(leiden))
  }else {
    M = i*AD + (1-i)*ID
    Msim = M+t(M)
    g = graph_from_adjacency_matrix(
      Msim,
      mode = c("undirected"),
      weighted = TRUE,
    )
    # Louvain (1)
    louvain <- cluster_louvain(g)
    comunidades_lou = rbind(comunidades_lou, membership(louvain))
    # Leiden (2)
    leiden <- cluster_leiden(g, objective_function = "modularity")
    comunidades_lei = rbind(comunidades_lei, membership(leiden))
  }
}


rownames(comunidades_lou) <- alpha
rownames(comunidades_lei) <- alpha


##################################################################
#             CÁLCULO DE MODULARIDADES EN AD                    #
################################################################## 

# Calculo modularidad
# Definir número total de enlaces
m <- sum(AD) 

# Calcular grados de entrada y salida
k_out <- rowSums(AD)
k_in <- colSums(AD)

# Función para calcular la modularidad de una partición
calcular_modularidad <- function(communities, Ma, k_out, k_in, m) {
  Q <- 0
  n <- nrow(AD)  # Número de nodos
  for (i in 1:n) {
    for (j in 1:n) {
      if (communities[i] == communities[j]) {
        Q <- Q + (Ma[i, j] - (k_out[i] * k_in[j] / m))
      }
    }
  }
  return(Q / m)
}

# Calcular modularidades para comunidades_lou
mod_lou <- apply(comunidades_lou, 1, calcular_modularidad, Ma = AD, k_out = k_out, k_in = k_in, m = m)
comunidades_lou <- cbind(comunidades_lou, mod_lou)
comunidades_lou <- rbind(c(max(comunidades_lou[, "mod_lou"]), rep(NA, ncol(comunidades_lou) - 1)),
                         c(comunidades_lou[1, "mod_lou"] < max(comunidades_lou[, "mod_lou"]), rep(NA, ncol(comunidades_lou) - 1)),comunidades_lou
)

# Calcular modularidades para comunidades_lei
mod_lei <- apply(comunidades_lei, 1, calcular_modularidad, Ma = AD, k_out = k_out, k_in = k_in, m = m)
comunidades_lei <- cbind(comunidades_lei, mod_lei)
comunidades_lei <- rbind(
  c(max(comunidades_lei[, "mod_lei"]), rep(NA, ncol(comunidades_lei) - 1)), 
  c(comunidades_lei[1, "mod_lei"] < max(comunidades_lei[, "mod_lei"]), rep(NA, ncol(comunidades_lei) - 1)),
  comunidades_lei
)



##################################################################
#                        GUARDAR RESULTADOS                      #
################################################################## 
# Instalar si no lo tienes
if (!requireNamespace("openxlsx", quietly = TRUE)) {
  install.packages("openxlsx")
}
library(openxlsx)

nombre_entrada <- "National_mobility"

# Crear un nuevo libro Excel
wb <- createWorkbook()

# Agregar hojas al libro con los distintos resultados
addWorksheet(wb, "louvain")
writeData(wb, "louvain", comunidades_lou)

addWorksheet(wb, "leiden")
writeData(wb, "leiden", comunidades_lei)

# Guardar el archivo
saveWorkbook(wb, file = paste0("comunidades_",
                               sub("\\.csv$", "", nombre_entrada),
                               ".xlsx"),
             overwrite = TRUE)




