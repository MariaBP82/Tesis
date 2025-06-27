# Cargar la librería
library(igraph)

# Cargar el grafo de Zachary's Karate Club
g <- make_graph("Zachary")

# Aplicar el algoritmo de Louvain
Infomap <- cluster_infomap(g)

# Imprimir el número de comunidades detectadas
cat("Número de comunidades:", length(Infomap), "\n")

# Imprimir la membresía de los nodos
print(membership(Infomap))

# Visualizar el grafo con las comunidades
plot(g,
     vertex.color = membership(Infomap),
     vertex.label = V(g)$name,
     vertex.size = 20,
     main = "Comunidades detectadas con Infomap (Zachary's Karate Club)")
