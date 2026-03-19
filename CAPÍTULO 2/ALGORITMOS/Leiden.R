# Cargar la librería
library(igraph)

# Crear el grafo de Zachary
g <- make_graph("Zachary")

# Aplicar Leiden directamente con igraph
Leiden <- cluster_leiden(g,objective_function = "modularity")

# Número de comunidades detectadas
cat("Número de comunidades:", length(Leiden), "\n")

# Mostrar la asignación de comunidades
print(membership(Leiden))

# Visualizar el grafo con las comunidades
plot(g,
     vertex.color = membership(Leiden),
     vertex.label = V(g)$name,
     vertex.size = 20,
     main = "Comunidades detectadas con Leiden (Zachary's Karate Club)")
