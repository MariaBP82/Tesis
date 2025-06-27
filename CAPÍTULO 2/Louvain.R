# Cargar la librería
library(igraph)

# Cargar el grafo de Zachary's Karate Club
g <- make_graph("Zachary")

# Aplicar el algoritmo de Louvain
Louvain <- cluster_louvain(g)

# Imprimir el número de comunidades detectadas
cat("Número de comunidades:", length(Louvain), "\n")

# Imprimir la membresía de los nodos
print(membership(Louvain))

# Visualizar el grafo con las comunidades
plot(g,
     vertex.color = membership(Louvain),
     vertex.label = V(g)$name,
     vertex.size = 20,
     main = "Comunidades detectadas con Louvain (Zachary's Karate Club)")
