# Cargar la librería
library(igraph)

# Cargar el grafo de Zachary's Karate Club
g <- make_graph("Zachary")

# Aplicar el algoritmo de Louvain
FastGreedy <- cluster_fast_greedy(g)

# Imprimir el número de comunidades detectadas
cat("Número de comunidades:", length(FastGreedy), "\n")

# Imprimir la membresía de los nodos
print(membership(FastGreedy))

# Visualizar el grafo con las comunidades
plot(g,
     vertex.color = membership(FastGreedy),
     vertex.label = V(g)$name,
     vertex.size = 20,
     main = "Comunidades detectadas con FastGreedy (Zachary's Karate Club)")
