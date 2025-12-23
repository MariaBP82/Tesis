# Aportaciones a problemas de detección de comunidades en redes dirigidas: definiciones de grupo

Este repositorio acompaña a la tesis **“Aportaciones a problemas de detección de comunidades en redes dirigidas. Definiciones de grupo”** de **María Barrosos Pérez**, dirigida por **Daniel Gómez** e **Inmaculada Gutiérrez**.

Aquí encontrarás **código reproducible**, **conjuntos de datos** y **resultados** organizados **por capítulos**, en correspondencia con el contenido de la tesis.

## Objetivo de la tesis

La tesis aborda problemas de **detección de comunidades** en redes, con énfasis en el caso de **redes dirigidas**. En concreto, se estudian dos líneas principales:

### 1) Detección de comunidades con una nueva definición de grupo basada en flujo

Se propone y analiza una definición alternativa de “grupo” en redes dirigidas basada en el flujo, con el objetivo de obtener comunidades más realistas desde este enfoque.

### 2) Mejora del enfoque clásico de detección de comunidades basado en densidad

Se investiga cómo mejorar el planteamiento clásico (basado en densidad) en redes dirigidas mediante dos metodologías:

- **Adaptación del algoritmo de Louvain**, modificando su función de optimización, y comparando los resultados del método adaptado frente a la versión original.
- **Preprocesamiento de las matrices de entrada** empleadas por algoritmos de detección de comunidades, analizando y comparando los resultados con y sin preprocesamiento.

En ambas metodologías, la evaluación de las particiones se realiza mediante la modularidad como función de calidad, utilizando la matriz de adyacencia como representación de la red.

## Herramientas

El trabajo se apoya en dos herramientas fundamentales:

- **Flow Capacity Measure (FCM)** — *medida borrosa del flujo*.
- **Flow Extended Fuzzy Graph (FEFG)** — *grafo borroso extendido de flujo*.

## Estructura del repositorio

El contenido está organizado por capítulos. En la raiz se encuentra:
- [CAPÍTULO 2](./CAP%C3%8DTULO%202/)
- [CAPÍTULO 3](./CAP%C3%8DTULO%203/)
- [CAPÍTULO 4](./CAP%C3%8DTULO%204/)
- [CAPÍTULO 5](./CAP%C3%8DTULO%205/)
- [CAPÍTULO 6](./CAP%C3%8DTULO%206/)
- [CAPÍTULO 7](./CAP%C3%8DTULO%207/)


## Reproducibilidad

Cada capítulo incluye los scripts/notebooks necesarios para reproducir los experimentos y generar los resultados presentados en la tesis.

Flujo típico:
1. Instalar dependencias.
2. Ejecutar el pipeline del capítulo.
3. Revisar resultados generados (tablas/figuras).

Para replicar los análisis, usa las siguientes versiones de software:
- *Matlab: R2024a Update 4 (24.1.0.2628055)*
- *R: Version 4.4.0*
- *RStudio: 2024.04.1 (Build 748)*
- *Python: 3.11.7*
- *Jupyter Notebook: 7.0.8*


----------------------------------------------------
Contenido del repositorio por Capítulos: 

Capítulo 2: Estado del arte

Reproducible Code: Scripts to implement the described methodology.
Data and Examples: Test cases and datasets for applying the approach to standard and real-world networks.
Results: Benchmark analyses and a case study on tourist movements in Spain.
Folder Structure
Codes/: Scripts for running the methodology.
Metrics/: Summaries and statistics for various steps in the methodology.
Results/: Outputs for all combinations of evaluated networks. Here is stored individually the results which are input for Table 1 (among the rest of networks).
Case study/: Input files and scripts for constructing and analyzing the real-world network case study.
clean_graph_data.csv: Pre-processed data used to define the network structure.
real case graph creation.ipynb: Jupyter notebook that constructs the network from the clean dataset.
calculo_redes_real_case.R: R script for applying community detection and computing modularity.
monthly partitions.xlsx: Output file containing monthly partitioning results for community detection.

Install required R packages:

install.packages(c("igraph", "rvest", "readr", "hydra", "dplyr", "ggplot2", "tidyr", "randomForest", "xgboost", "Metrics", "caret", "doParallel", "arrow", "visNetwork", "combinat", "igraphdata"))
For Jupyter Notebooks:

pip install jupyter pandas networkx matplotlib
Usage
Key Scripts
analisis_redes.R

Reads modularity results from multiple CSV files and computes performance metrics for different algorithms.
bernoulli_v2.R

Computes confidence intervals for algorithm performance based on Bernoulli distributions.
calculo_redes_nuevo.R

Iterates over multiple networks, precomputes adjacency matrices, and applies different clustering algorithms.
calculo_redes_real_case.R

Processes a real-world network dataset, applying modularity-based community detection methods.
Nodes and Edges.R

Computes the number of nodes and edges in given .graphml network files.
plots heatmap.R

Generates heatmaps and computational time comparison plots for different algorithms.
synthetic network.R

Generates synthetic hierarchical networks and saves them as .graphml files.
modelo ampliado (variable importance).R

Trains multiple machine learning models to predict network modularity improvement and extracts variable importance.
syntethic networks.ipynb

Notebook related t
All experiments were conducted with a fixed random seed (123) for consistent results.






## Cita

Si utilizas este repositorio o el contenido de la tesis en tu trabajo, por favor cita la tesis:

```bibtex
@thesis{barrosos_perez_tesis,
  title  = {Aportaciones a problemas de detección de comunidades en redes dirigidas. Definiciones de grupo},
  author = {Barrosos P{\'e}rez, Mar{\'i}a},
  year   = {2026},
  publisher = {Universidad Complutense de Madrid}
}


