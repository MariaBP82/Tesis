## Aportaciones a Problemas de Detección de Comunidades en Redes Dirigidas. Definiciones de Grupo.

Bienvenidos al repositorio de GitHub que acompaña a la tesis "Aportaciones a problemas de detección de comunidades en redes dirigidas. Definiciones de grupo" de María Barrosos Pérez, cuyos directores son Daniel Gómez e Inmaculada Gutiérrez.

Este repositorio contiene por capítulos el código reproducible, los conjuntos de datos, y los resutlados presentados estructurados por capítulos. La tesis intenta abordar resolver problemas en el campo de la detección de comunidades. Concretamente aborda dos problemas en el caso de las redes dirigidas, un primer problema de resolver problemas de detección de comunidades donde el objetivo es obtenter grupos con una nueva definición de grupo, que es el flujo, y un segundo problema, cuyo objetivo es mejor el problema de detección de comunidades clásico basado en densidad y todo eso con dos metodologías distintas, primero adaptando un algoritmo y comparando sus resultados medidos con la función de calidad de modularidad clásica en ambos algoritmos, el adaptado y el previo. segundo, usando un preprocesamiento de matrices de entrada en algoritmos de detección de comunidades y comparando resultados sin preprocesar. Todo el trabajo mencionado haciendo uso de dos herramientas básicas, la medida borrosa del flujo (Flow Capacity Measure, FCM) y el grafo borroso extendido de flujo (Flow Extended Fuzzy Graph, FEFG). 

----------------------------------------------------
Contenido del repositorio por Capítulos: 

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
Installation
To replicate the analyses, use the following software versions:

R: Version 3.4.2
Python: Version 3.11.0
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

Notebook related to synthetic network generation and analysis.
Results
Output Files
plot1_improvement_by_algorithm.pdf: Distribution of improvement percentages for each algorithm.
plot2_improvement_by_network.pdf: Histograms of improvement percentages for analyzed networks.
plot3_combined_improvement.pdf: Holistic visualization of improvements across networks and algorithms.
fast_greedy_heatmap.pdf: Heatmap showing improvement distribution for the Fast Greedy algorithm.
walktrap_heatmap.pdf: Heatmap showing improvement distribution for the Walktrap algorithm.
leiden_heatmap.pdf: Heatmap showing improvement distribution for the Leiden algorithm.
louvain_heatmap.pdf: Heatmap showing improvement distribution for the Louvain algorithm.
infomap_heatmap.pdf: Heatmap showing improvement distribution for the Infomap algorithm.
all_algorithms_heatmap.pdf: Aggregated heatmap comparing all algorithms.
time_plot.pdf: Visualization of computational time increase across different algorithms.
algorithm_improvement_distribution.pdf: Boxplot of improvement percentages across all tested algorithms.
monthly partitions.xlsx: Community detection results for different time periods.
networks_used.csv: List of networks used in this paper. All were downloaded from http://konect.cc/networks/
Reproducibility
All experiments were conducted with a fixed random seed (123) for consistent results.



