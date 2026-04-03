##################################################################
#                  CARGA DE LIBRERIAS NECESARIAS                 #
################################################################## 
library(readxl)
library(dplyr)
library(stringr)
library(purrr)
library(readr)
library(parallel)
library(Matrix)

##################################################################
#                  RUTA DE TRABAJO                               #
################################################################## 

# Carpeta base donde están las carpetas "Enero 2021", ..., "Diciembre 2021"
ruta_base <- "C:/movilidad_cotidiana_enero_noviembre_2021"  # COlocar la carpeta de los ficheros de movilidad

meses_2021 <- c(
  "Enero 2021", "Febrero 2021", "Marzo 2021", "Abril 2021",
  "Mayo 2021", "Junio 2021", "Julio 2021", "Agosto 2021",
  "Septiembre 2021", "Octubre 2021", "Noviembre 2021", "Diciembre 2021"
)

# Mes a procesar: (Elegir el mes a analizar, aquí se elige Abril 2021)
mes_objetivo <-  meses_2021[4]

# Ruta al archivo de equivalencias
ruta_codigos <- file.path(ruta_base, "CodigoAreaMovilidad.csv")

ruta_trabajo <- file.path(ruta_base, mes_objetivo)

if (!dir.exists(ruta_trabajo)) {
  stop("No existe la carpeta: ", ruta_trabajo)
}

if (!file.exists(ruta_codigos)) {
  stop("No existe el archivo de equivalencias: ", ruta_codigos)
}


##################################################################
# LEER TABLA DE EQUIVALENCIAS                                    #
#    - columna CodigoArea = código original del área             #
#    - columna nodos      = número final (1 a 3124)              #             
################################################################## 

equiv <- read_csv2(file = ruta_codigos, locale = locale(encoding = "UTF-8"), 
                   show_col_types = FALSE, trim_ws = TRUE ) %>%
  select(CodigoArea, Nodos) %>%
  mutate(
    CodigoArea = as.character(CodigoArea),
    Nodos = as.integer(Nodos)
  )

##################################################################################
#  LOCALIZAR ARCHIVOS EXCEL DEL MES                                              #
#   Ficheros tipo:                                                               #
#    "Tabla 1.3 Movilidad Cotidiana-Flujos Origen-Destino +15 personas_dddd.xlsx"#
##################################################################################

patron_excel <- "^Tabla 1\\.3 Movilidad Cotidiana-Flujos Origen-Destino \\+15 personas_\\d{4}\\.xlsx$"

archivos_excel <- list.files(
  path = ruta_trabajo,
  pattern = patron_excel,
  full.names = TRUE
)

leer_y_limpiar_excel <- function(fichero, equiv) {
  
  df <- read_excel(fichero)
  
  # Seleccionar columnas exactas
  df <- df %>%
    select(
      `Código área de residencia`,
      `Código área de destino`,
      `Flujo origen-destino (nº de personas)`
    ) %>%
    rename(
      nod_sal = `Código área de residencia`,
      nod_ent = `Código área de destino`,
      cap     = `Flujo origen-destino (nº de personas)`
    ) %>%
    mutate(
      nod_sal = as.character(nod_sal),
      nod_ent = as.character(nod_ent),
      cap = as.numeric(cap)
    )
  
  # Eliminar filas con "OTRO" en destino
  df <- df %>%
    filter(
      !str_detect(str_to_lower(nod_ent), "otro")
    )
  
  # Eliminar filas donde origen = destino
  df <- df %>%
    filter(nod_sal != nod_ent)
  
  # Convertir códigos de área a nodos numéricos usando la tabla de equivalencias
  df <- df %>%
    left_join(equiv, by = c("nod_sal" = "CodigoArea")) %>%
    rename(nod_sal_num = Nodos) %>%
    left_join(equiv, by = c("nod_ent" = "CodigoArea")) %>%
    rename(nod_ent_num = Nodos)
  
  # Quedarse solo con las filas con equivalencia válida
  df <- df %>%
    filter(!is.na(nod_sal_num), !is.na(nod_ent_num)) %>%
    transmute(
      nod_sal = as.integer(nod_sal_num),
      nod_ent = as.integer(nod_ent_num),
      cap = cap
    )
  
  return(df)
}


AD_dias <- archivos_excel %>%
  set_names(
    paste0(
      "AD_",
      stringr::str_extract(basename(.), "\\d{4}(?=\\.xlsx$)")
    )
  ) %>%
  purrr::map(leer_y_limpiar_excel, equiv = equiv)

#################################################################################
#        obtener las matrices de adyacencia de cada red dirigida de días        #
#################################################################################

crear_matriz_AD <- function(AD_mat) {
  
  # Determinar el número de nodos
  n_nodos <- max(c(AD_mat$nod_sal, AD_mat$nod_ent), na.rm = TRUE)
  
  # Inicializar matriz de adyacencia
  AD <- matrix(0, nrow = n_nodos, ncol = n_nodos)
  
  # Rellenar matriz
  for (i in seq_len(nrow(AD_mat))) {
    fila <- AD_mat[i, ]
    AD[fila$nod_sal, fila$nod_ent] <- fila$cap
  }
  
  return(AD)
}

matrices_AD <- purrr::map(AD_dias, crear_matriz_AD)

# Para obtener las matrices individuales
list2env(matrices_AD, envir = .GlobalEnv)


#################################################################################
#        obtener las matrices de interacción de cada red dirigida de días      #
#################################################################################
if (!requireNamespace("igraph", quietly = TRUE)) {
  install.packages("igraph")
}
library(igraph)

crear_matriz_ID_aprox_desde_df <- function(df_arcos, nombre = NA_character_, n_nodos = NULL, usar_sparse = FALSE) {
  
  cat("Empezando", nombre, "\n")
  inicio <- Sys.time()
  
  # Limpiar y consolidar arcos
  AD <- df_arcos %>%
    select(nod_sal, nod_ent, cap) %>%
    mutate(
      nod_sal = as.integer(nod_sal),
      nod_ent = as.integer(nod_ent),
      cap = as.numeric(cap)
    ) %>%
    filter(!is.na(nod_sal), !is.na(nod_ent), !is.na(cap), cap > 0) %>%
    group_by(nod_sal, nod_ent) %>%
    summarise(cap = sum(cap), .groups = "drop")
  
  if (is.null(n_nodos)) {
    n_nodos <- max(c(AD$nod_sal, AD$nod_ent), na.rm = TRUE)
  }
  
  cat("Arcos:", nrow(AD), "\n")
  cat("Calculando kout y kin...\n")
  
  # Grado de salida: nº de destinos distintos por origen
  kout <- AD %>%
    count(nod_sal, name = "kout")
  
  # Grado de entrada: nº de orígenes distintos por destino
  kin <- AD %>%
    count(nod_ent, name = "kin")
  
  cat("Combinando grados...\n")
  
  I_df <- AD %>%
    left_join(kout, by = "nod_sal") %>%
    left_join(kin, by = "nod_ent") %>%
    mutate(
      kout = coalesce(kout, 0L),
      kin  = coalesce(kin, 0L),
      min_k = pmin(kout, kin)
    ) %>%
    select(nod_sal, nod_ent, min_k)
  
  cat("Construyendo matriz...\n")
  
  if (usar_sparse) {
    ID_est <- sparseMatrix(
      i = I_df$nod_sal,
      j = I_df$nod_ent,
      x = I_df$min_k,
      dims = c(n_nodos, n_nodos)
    )
  } else {
    ID_est <- matrix(0, nrow = n_nodos, ncol = n_nodos)
    ID_est[cbind(I_df$nod_sal, I_df$nod_ent)] <- I_df$min_k
  }
  
  fin <- Sys.time()
  
  cat(
    "Terminada", nombre,
    "- tiempo:",
    round(as.numeric(fin - inicio, units = "secs"), 2),
    "segundos\n"
  )
  
  return(ID_est)
}


matrices_ID <- purrr::imap(
  AD_dias,
  ~ crear_matriz_ID_aprox_desde_df(
    df_arcos = .x,
    nombre = .y,
    n_nodos = 3214,
    usar_sparse = FALSE
  )
)

# Para obtener las matrices individuales
names(matrices_ID) <- sub("^AD_", "ID_", names(matrices_ID))

list2env(matrices_ID, envir = .GlobalEnv)

# Volver a renombarlas para el preprocesamiento
names(matrices_ID) <- sub("^ID_", "AD_", names(matrices_ID))


####################################################################


set.seed(123)  # Se fija semilla para que los resultados sean reproducibles



##################################################################
##################################################################
#                        PREPROCESAMIENTO                        #
################################################################## 
##################################################################

alpha <- seq(from = 1, to = 0, by = -0.01)

# Carpeta donde quieres guardar los Excel
ruta_salida <- "C:/movilidad_cotidiana_enero_noviembre_2021/Resultados"

if (!dir.exists(ruta_salida)) {
  dir.create(ruta_salida, recursive = TRUE)
}


##################################################################
#                FUNCION DE MODULARIDAD EN AD                    #
##################################################################

calcular_modularidad <- function(communities, Ma, k_out, k_in, m) {
  Q <- 0
  n <- nrow(Ma)
  
  for (i in seq_len(n)) {
    for (j in seq_len(n)) {
      if (communities[i] == communities[j]) {
        Q <- Q + (Ma[i, j] - (k_out[i] * k_in[j] / m))
      }
    }
  }
  
  Q / m
}


# FUNCIÓN PREPROCESAMIENTO:

procesar_un_dia <- function(AD, ID, nombre_dia, alpha, ruta_salida) {
  
  cat("Empezando preprocesamiento de", nombre_dia, "\n")
  
  comunidades_lou <- NULL
  comunidades_lei <- NULL
  
  for (a in alpha) {
    
    if (a == 1) {
      M <- a * AD
    } else {
      M <- a * AD + (1 - a) * ID
    }
    
    Msim <- M + t(M)
    
    g <- graph_from_adjacency_matrix(
      Msim,
      mode = "undirected",
      weighted = TRUE,
      diag = FALSE
    )
    
    # Louvain
    louvain <- cluster_louvain(g, weights = E(g)$weight)
    comunidades_lou <- rbind(comunidades_lou, membership(louvain))
    
    # Leiden
    leiden <- cluster_leiden(
      g,
      objective_function = "modularity",
      weights = E(g)$weight
    )
    comunidades_lei <- rbind(comunidades_lei, membership(leiden))
  }
  
  rownames(comunidades_lou) <- alpha
  rownames(comunidades_lei) <- alpha
  
  ################################################################
  #          CALCULO DE MODULARIDADES SOBRE AD                    #
  ################################################################
  
  m <- sum(AD)
  k_out <- rowSums(AD)
  k_in  <- colSums(AD)
  
  mod_lou <- apply(
    comunidades_lou,
    1,
    calcular_modularidad,
    Ma = AD,
    k_out = k_out,
    k_in = k_in,
    m = m
  )
  
  mod_lei <- apply(
    comunidades_lei,
    1,
    calcular_modularidad,
    Ma = AD,
    k_out = k_out,
    k_in = k_in,
    m = m
  )
  
  ################################################################
  #        PASAR A DATAFRAME Y AÑADIR INFORMACION RESUMEN         #
  ################################################################
  
  df_lou <- as.data.frame(comunidades_lou)
  df_lei <- as.data.frame(comunidades_lei)
  
  colnames(df_lou) <- paste0("nodo_", seq_len(ncol(df_lou)))
  colnames(df_lei) <- paste0("nodo_", seq_len(ncol(df_lei)))
  
  df_lou <- cbind(alpha = alpha, mod_lou = mod_lou, df_lou)
  df_lei <- cbind(alpha = alpha, mod_lei = mod_lei, df_lei)
  
  resumen_lou <- data.frame(
    alpha_mejor = alpha[which.max(mod_lou)],
    modularidad_max = max(mod_lou),
    alpha_1_es_maximo = mod_lou[1] == max(mod_lou)
  )
  
  resumen_lei <- data.frame(
    alpha_mejor = alpha[which.max(mod_lei)],
    modularidad_max = max(mod_lei),
    alpha_1_es_maximo = mod_lei[1] == max(mod_lei)
  )
  
  
  ##################################################################
  #                        GUARDAR RESULTADOS                      #
  ################################################################## 
  # Instalar si no lo tienes
  if (!requireNamespace("openxlsx", quietly = TRUE)) {
    install.packages("openxlsx")
  }
  library(openxlsx)
  
  archivo_lou <- file.path(ruta_salida, paste0("Louvain_", nombre_dia, ".xlsx"))
  archivo_lei <- file.path(ruta_salida, paste0("Leiden_", nombre_dia, ".xlsx"))
  
  wb_lou <- createWorkbook()
  addWorksheet(wb_lou, "resumen")
  addWorksheet(wb_lou, "comunidades")
  writeData(wb_lou, "resumen", resumen_lou)
  writeData(wb_lou, "comunidades", df_lou)
  saveWorkbook(wb_lou, archivo_lou, overwrite = TRUE)
  
  wb_lei <- createWorkbook()
  addWorksheet(wb_lei, "resumen")
  addWorksheet(wb_lei, "comunidades")
  writeData(wb_lei, "resumen", resumen_lei)
  writeData(wb_lei, "comunidades", df_lei)
  saveWorkbook(wb_lei, archivo_lei, overwrite = TRUE)
  
  cat("Terminados los Excel de", nombre_dia, "\n")
  
  return(list(
    louvain = df_lou,
    leiden = df_lei,
    resumen_lou = resumen_lou,
    resumen_lei = resumen_lei
  ))
}



##################################################################
#       APLICAR A TODAS LAS MATRICES AD E ID POR CADA DIA        #
##################################################################

# Se asume que:
# names(matrices_AD) = c("AD_0404", "AD_0504", ...)
# names(matrices_I)  = c("AD_0404", "AD_0504", ...) <- Interacción asociada a esa matriz
# o al menos que tengan el mismo orden y correspondencia

resultados_dias <- imap(matrices_AD, function(AD, nombre_ad) {
  
  # Buscar la matriz ID correspondiente
  ID <- matrices_ID[[nombre_ad]]
  
  if (is.null(ID)) {
    stop(paste("No existe matriz ID para", nombre_ad))
  }
  
  procesar_un_dia(
    AD = AD,
    ID = ID,
    nombre_dia = nombre_ad,
    alpha = alpha,
    ruta_salida = ruta_salida
  )
})








