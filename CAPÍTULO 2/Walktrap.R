# Cargar la librería
library(igraph)

# Cargar el grafo de Zachary's Karate Club
g <- make_graph("Zachary")

# Aplicar el algoritmo de Louvain
Walktrap <- cluster_walktrap(g)

# Imprimir el número de comunidades detectadas
cat("Número de comunidades:", length(Walktrap), "\n")

# Imprimir la membresía de los nodos
print(membership(Walktrap))

# Visualizar el grafo con las comunidades
plot(g,
     vertex.color = membership(Walktrap),
     vertex.label = V(g)$name,
     vertex.size = 20,
     main = "Comunidades detectadas con Walktrap (Zachary's Karate Club)")
