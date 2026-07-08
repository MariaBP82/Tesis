# Aportaciones a problemas de detección de comunidades en redes dirigidas. Definiciones de grupo

Este repositorio acompaña a la tesis **“Aportaciones a problemas de detección de comunidades en redes dirigidas. Definiciones de grupo”** de María Barroso Pérez, dirigida por Daniel Gómez e Inmaculada Gutiérrez.


## Objetivos de la tesis

En el marco de la detección de comunidades en redes dirigidas, esta tesis plantea los siguientes objetivos generales y específicos.

### Objetivo 1. Diseñar y caracterizar una herramienta de representación para redes dirigidas que integre la estructura del grafo con información dada por una medida borrosa

- Formalizar un instrumento avanzado para representar redes dirigidas, definiendo la medida borrosa basada en la capacidad de flujo, que permita incorporar de manera flexible información adicional sobre las interacciones entre los nodos y el flujo de la información.

- Definir el grafo asociado a la medida borrosa del flujo, proponiendo el índice de interacción como vía de cálculo para su construcción.

- Extender el marco de representación propuesto para construir nuevas herramientas aplicables a redes dirigidas que integren otras fuentes de información adicional, como las relaciones de co-citación, a través de medidas borrosas.


### Objetivo 2. Desarrollar un algoritmo capaz de detectar nuevos grupos en redes dirigidas

- Definir un nuevo concepto de grupo basado en flujo, apoyado en la herramienta de representación propuesta, que posibilite obtener particiones más coherentes con los objetivos y criterios propios de los problemas de detección de comunidades en redes dirigidas.

- Diseñar una función de calidad que combine la información de flujo y densidad presente en la red.

- Adaptar el algoritmo de Louvain haciendo uso de la nueva función de calidad para abordar la detección de comunidades desde una perspectiva basada en flujo, orientada a ofrecer soluciones más precisas y realistas en este tipo de problemas.

- Formular un nuevo problema de detección de comunidades para su aplicación a redes con relaciones de co-citación, incorporando dicha información mediante la herramienta de representación correspondiente, con el fin de identificar grupos basados en co-citación.


### Objetivo 3. Plantear mejoras para la resolución del problema clásico de detección de comunidades desde dos enfoques distintos

- Desarrollar una metodología basada en el nuevo algoritmo adaptado de Louvain, orientada a obtener particiones de mejor calidad atendiendo a la definición clásica de grupo. Para ello, se emplean técnicas supervisadas que permiten comparar las particiones generadas por el algoritmo propuesto con aquellas obtenidas mediante el algoritmo de Louvain, con el propósito de mitigar sus limitaciones asociadas a la convergencia hacia óptimos locales.

- Diseñar una metodología basada en el preprocesamiento de los datos de entrada para algoritmos de detección de comunidades, con el fin de incorporar información no estructural y favorecer la obtención de particiones de mayor calidad en términos de densidad. Esta metodología se basa en la construcción de una matriz resultante de combinar la matriz de adyacencia con una matriz asociada a la representación del flujo en la red.

- Optimizar la metodología de preprocesamiento propuesta para reducir el coste computacional y mejorar su escalabilidad, manteniendo un rendimiento competitivo en términos de calidad de partición.

- Evaluar de manera cuantitativa, mediante técnicas de *machine learning*, el impacto de ambos enfoques en el problema clásico de detección de comunidades.


### Objetivo 4. Aplicar la metodología de preprocesamiento propuesta a un caso de estudio real

- A partir de datos reales de movilidad en España, construir el grafo dirigido origen-destino y generar la herramienta de representación basada en flujo para incorporar la capacidad de comunicación entre los nodos.

- Aplicar los algoritmos de detección de comunidades de Louvain y Leiden al caso real de movilidad, comparando los resultados obtenidos a partir de la matriz de adyacencia y la matriz preprocesada propuesta como parámetro de entrada.

- Incorporar la visualización e interpretación de las comunidades detectadas, junto con una evaluación cuantitativa de la calidad de las particiones resultantes.



## Objetivo transversal del repositorio. 

Este repositorio permite facilitar la reproducibilidad, trazabilidad y consulta estructurada de los desarrollos computacionales y resultados experimentales asociados a la tesis que acompaña. Para ello, se organizan los códigos en  scripts y notebooks, conjuntos de datos y resultados generados a lo largo de la investigación, siguiendo una estructura por capítulos coherente con el contenido de la memoria. Esta organización permite identificar con claridad los recursos vinculados a cada aportación metodológica y reproducir los experimentos desarrollados en el marco de la tesis.

Asimismo, en el repositorio se documenta el entorno computacional empleado, incluyendo los lenguajes de programación, versiones de software, paquetes y dependencias necesarios para ejecutar los experimentos implementados en *MATLAB*, *R* y *Python*. Con ello, se busca favorecer la comparabilidad de los resultados, facilitar su validación y proporcionar una base reutilizable para futuras investigaciones en detección de comunidades en redes dirigidas.



## Herramientas

El trabajo se apoya en dos herramientas fundamentales:

- **Flow Capacity Measure (FCM)** — *medida borrosa del flujo*.
- **Flow Extended Fuzzy Graph (FEFG)** — *grafo borroso extendido de flujo*.


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
 



---------------------------------------------------------------------------------------------------
## Contenido del repositorio por capítulos

### [CAPÍTULO 2](./CAP%C3%8DTULO%202/) — Estado del arte 
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
- **Redes Neuronales** 
- **Random Forest** 
- **XGBoost** 
- **CSEA** 


### [CAPÍTULO 3](./CAP%C3%8DTULO%203/)
En este capítulo se incluyen los códigos empleados para el cálculo de la matriz de interacción del flujo, disponibles en dos implementaciones:
- **MATLAB**: script para el cálculo de la matriz.
- **Python**: implementación equivalente en formato notebook.


### [CAPÍTULO 4](./CAP%C3%8DTULO%204/)
Este capítulo contiene el conjunto de 4 redes analizadas y los resultados obtenidos empleando el nuevo algoritmo desarrollado en la tesis:  
**Flow Capacity Louvain (FCL)**, implementado en *MATLAB*.
La estructura del capítulo es la siguiente:
#### 1) Conjunto de matrices
La carpeta `1) CONJUNTO DE MATRICES/` incluye las matrices de entrada para cada una de las cuatro redes estudiadas (`G_1`, `G_2`, `G_3`, `G_4`).
Para cada red se proporcionan:
- **Matriz de adyacencia** — `Ad_G_X.csv`
- **Matriz de interacción del flujo** — `Id_G_X.csv`
donde `X ∈ {1, 2, 3, 4}` identifica la red correspondiente.
#### 2) Resultados
La carpeta `2) RESULTADOS/` contiene los resultados generados mediante FCL para cada red (`G_1`, `G_2`, `G_3`, `G_4`), incluyendo:
- Particiones obtenidas con Louvain clásico.
- Particiones obtenidas con el algoritmo Flow Capacity Louvain (FCL).
- Ficheros con las particiones y valores de modularidad asociados.
#### 3) Código del algoritmo
En el directorio del capítulo se incluyen los scripts en **MATLAB** necesarios para la ejecución del algoritmo y el cálculo de métricas:
- `FlowCapacityLouvain.m` — implementación del algoritmo FCL.
- `compute_FlowCapacityLouvain.m` — ejecución del algoritmo sobre las matrices de entrada.
- `compute_modularity_dir.m` — cálculo de la modularidad para redes dirigidas.


### [CAPÍTULO 5](./CAP%C3%8DTULO%205/)
Este capítulo se organiza en varias carpetas y archivos, que cubren el proceso completo del enfoque supervisado introducido para la mejora de los problemas de detección de comunidades, desde la selección del parámetro *α* hasta la validación de resultados y el análisis de complejidad.
#### Contraste de hipótesis
Carpeta dedicada a la validación estadística de los resultados, que incluye la implementación del test de Wilcoxon en MATLAB para comparar el rendimiento (modularidad) entre algoritmos.
#### Fase de entrenamiento
Carpeta con las redes empleadas para entrenar el algoritmo FCL.  
En esta fase se obtienen valores de α etiquetados con la modularidad de la partición resultante, con el objetivo de seleccionar el parámetro que produce el mejor desempeño.
#### Fase de test
Carpeta con las redes utilizadas para verificar el valor de α seleccionado en el entrenamiento, evaluando si los resultados de modularidad se mantienen (o mejoran) en datos no utilizados durante el ajuste.
#### Archivos adicionales
En el directorio principal del capítulo se incluyen archivos sueltos con:
- la **ejecución del proceso de supervisión** 
- el análisis de la **complejidad computacional** del algoritmo FCL.


### [CAPÍTULO 6](./CAP%C3%8DTULO%206/)
Este capítulo contiene los códigos, matrices, redes de referencia y resultados asociados a la metodología de **preprocesamiento de matrices de entrada** propuesta para mejorar el problema clásico de detección de comunidades en redes dirigidas.

La metodología se basa en la construcción de una nueva matriz de entrada, obtenida a partir de la combinación entre:

- la **matriz de adyacencia** de la red dirigida;
- la **matriz de interacción del flujo**, derivada del grafo borroso extendido de flujo.

Esta matriz preprocesada se utiliza como parámetro de entrada en distintos algoritmos de detección de comunidades, con el objetivo de evaluar si la incorporación de información de flujo permite obtener particiones con mayor modularidad dirigida.

#### 1) Redes de referencia

Se incluyen las redes utilizadas para evaluar la metodología de preprocesamiento. Para cada red se proporcionan las matrices necesarias para ejecutar los algoritmos con y sin preprocesamiento.

En particular, se consideran:

- matrices de adyacencia originales;
- matrices de interacción del flujo;
- matrices combinadas/preprocesadas para distintos valores del parámetro `α`.

#### 2) Algoritmos de detección de comunidades

El capítulo incluye la aplicación de distintos algoritmos de detección de comunidades sobre las matrices originales y preprocesadas:

- **Louvain**
- **Leiden**
- **Walktrap**
- **Infomap**
- **Fast Greedy**
- **Surprise**

Los algoritmos se ejecutan comparando dos escenarios:

1. ejecución clásica, empleando la matriz de adyacencia como entrada;
2. ejecución con preprocesamiento, empleando la matriz obtenida al incorporar información de flujo.

#### 3) Resultados

La carpeta de resultados contiene las particiones obtenidas para cada red, algoritmo y valor del parámetro `α`, junto con los valores de modularidad dirigida asociados.

Los resultados permiten comparar:

- la modularidad obtenida sin preprocesamiento;
- la modularidad obtenida con la metodología basada en flujo;
- la mejora o empeoramiento producido por la incorporación de la matriz preprocesada;
- el comportamiento de la metodología para distintos valores de `α`.

#### 4) Evaluación del parámetro α

Se incluyen los experimentos realizados para analizar la influencia del parámetro `α`, que regula el peso relativo entre la información estructural de la red y la información procedente de la medida borrosa de flujo.

#### 5) Complejidad computacional

El capítulo contiene también los archivos empleados para analizar los tiempos de ejecución de los algoritmos con y sin preprocesamiento.

#### 6) Técnicas de machine learning y deep learning

Se incluyen notebooks destinados a evaluar la capacidad de distintos modelos para predecir cuándo la metodología de preprocesamiento produce una mejora en la modularidad dirigida.

Los modelos considerados son:

- **Regresión logística**
- **Redes neuronales**
- **Random Forest**
- **XGBoost**
- **CSEA**

Estos modelos permiten estudiar la relación entre las características de las redes, el valor del parámetro `α` y la mejora obtenida en la función de calidad.

 
### [CAPÍTULO 7](./CAP%C3%8DTULO%207/)


### [CAPÍTULO 8](./CAP%C3%8DTULO%208/)


## Cita

Si utilizas este repositorio o el contenido de la tesis en tu trabajo, por favor cita la tesis:

```bibtex
@thesis{mariabp_tesis,
  title  = {Aportaciones a problemas de detección de comunidades en redes dirigidas. Definiciones de grupo},
  author = {Barroso P{\'e}rez, Mar{\'i}a},
  year   = {2026},
  publisher = {Universidad Complutense de Madrid}
}


