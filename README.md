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

Control de aleatoriedad (semilla = 123)
Para garantizar resultados reproducibles, fija la semilla antes de ejecutar cada experimento/notebook.

Para replicar los análisis, usa las siguientes versiones de software:
- *Matlab: R2024a Update 4 (24.1.0.2628055)*
- *R: Version 4.4.0*
- *RStudio: 2024.04.1 (Build 748)*
- *Python: 3.11.7*
- *Jupyter Notebook: 7.0.8*

R: Instala los paquetes necesarios con:
install.packages(c("igraph", "readr", "ggplot2"))

Python 3:
pip install numpy pandas networkx scikit-learn tensorflow python-louvain xgboost surprisememore
 



================================================================================================
## Contenido del repositorio por capítulos

### Capítulo 2 — Estado del arte

En este capítulo se incluyen los códigos de los algoritmos de detección de comunidades empleados a lo largo de la tesis:

- **Fast Greedy** (R) 
- **Infomap** (R) 
- **Leiden** (R) 
- **Louvain** (R)
- **Walktrap** (R)
- **Louvain dirigido** (MATLAB)
- **Surprise** (Python, notebook) 

Además, se incluyen los modelos de *machine learning* y *deep learning* utilizados en los experimentos (en formato notebook `.ipynb`):

- **Regresión logística** 
- **Redes Neurolaes** 
- **Random Forest** 
- **XGBoost** 
- **CSEA** 


Capítulo 2: Estado del arte

Aparecen incluidos los códigos de los distintos algoritmos usados a lo largo de la tesis:
Louvain (R), Louvain Dirigido (matlab), Leiden (R), Walktrap (R), Infomap (R), Fast Greedy (R) y Surprise (python)

Así como los métodos me *machine learning* y *deep learning* usados:
LogisticRgres












## Cita

Si utilizas este repositorio o el contenido de la tesis en tu trabajo, por favor cita la tesis:

```bibtex
@thesis{mariabp_tesis,
  title  = {Aportaciones a problemas de detección de comunidades en redes dirigidas. Definiciones de grupo},
  author = {Barrosos P{\'e}rez, Mar{\'i}a},
  year   = {2026},
  publisher = {Universidad Complutense de Madrid}
}


