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



## Objetivo transversal del repositorio

Este repositorio permite facilitar la reproducibilidad, trazabilidad y consulta estructurada de los desarrollos computacionales y resultados experimentales asociados a la tesis que acompaña. Para ello, se organizan los códigos en  scripts y notebooks, conjuntos de datos y resultados generados a lo largo de la investigación, siguiendo una estructura por capítulos coherente con el contenido de la memoria. Esta organización permite identificar con claridad los recursos vinculados a cada aportación metodológica y reproducir los experimentos desarrollados en el marco de la tesis.

Asimismo, en el repositorio se documenta el entorno computacional empleado, incluyendo los lenguajes de programación, versiones de software, paquetes y dependencias necesarios para ejecutar los experimentos implementados en *MATLAB*, *R* y *Python*. Con ello, se busca favorecer la comparabilidad de los resultados, facilitar su validación y proporcionar una base reutilizable para futuras investigaciones en detección de comunidades en redes dirigidas.



## Herramientas

El trabajo se apoya en dos herramientas fundamentales:

- *Flow Capacity Measure (FCM)* — *medida borrosa del flujo*.
- *Flow Extended Fuzzy Graph (FEFG)* — *grafo borroso extendido de flujo*.


## Reproducibilidad

Cada capítulo incluye los scripts/notebooks necesarios para reproducir los experimentos y generar los resultados presentados en la tesis.

Flujo típico:
1. Instalar dependencias (librerías o paquetes).
2. Ejecutar el pipeline del código.
3. Revisar resultados generados.

Control de aleatoriedad (semilla = 123)

Para garantizar resultados reproducibles, fija la semilla antes de ejecutar cada experimento.

Para replicar los análisis, usa las siguientes versiones de software:
- *MATLAB: R2024a Update 4 (24.1.0.2628055)*
- *R: Version 4.4.0*
- *RStudio: 2024.04.1 (Build 748)*
- *Python: 3.11.7*
- *Jupyter Notebook: 7.0.8*


Instalar los paquetes necesarios:

- R:
   ```r
  install.packages(c("igraph", "readr", "ggplot2"))
  ```

- Python 3:
  ```bash
  pip install numpy pandas networkx igraph matplotlib surprisememore scikit-learn tensorflow xgboost 
  ```
 



---------------------------------------------------------------------------------------------------
## Contenido del repositorio por capítulos

### [CAPÍTULO 2](./CAP%C3%8DTULO%202/) 
En este capítulo se incluyen los códigos de los algoritmos de detección de comunidades empleados a lo largo de la tesis:
- **Fast Greedy** (R) 
- **Infomap** (R) 
- **Leiden** (R) 
- **Louvain** (R)
- **Walktrap** (R)
- **Louvain dirigido** (MATLAB)
- **Surprise** (Python)
  
Además, se incluyen los modelos de *machine learning* y *deep learning* utilizados en los experimentos (en formato notebook de Python `.ipynb`):
- **Regresión logística** 
- **Redes neuronales** 
- **Random Forest** 
- **XGBoost** 
- **CSEA** 


### [CAPÍTULO 3](./CAP%C3%8DTULO%203/)
En este capítulo se incluyen los códigos empleados para el cálculo de la matriz de interacción del flujo, disponibles en dos implementaciones:
- **Python**: Jupyter notebook para el cálculo de la matriz.
- **MATLAB**: implementación equivalente en formato script.
 

### [CAPÍTULO 4](./CAP%C3%8DTULO%204/)
Este capítulo contiene el conjunto de 4 redes analizadas y los resultados obtenidos empleando el nuevo algoritmo desarrollado en la tesis:  
*Flow Capacity Louvain (FCL)*, implementado en *MATLAB*.
La estructura del capítulo es la siguiente:
#### 1) Conjunto de matrices
La carpeta `1) CONJUNTO DE MATRICES/` incluye las matrices de entrada para cada una de las cuatro redes estudiadas (`G_1`, `G_2`, `G_3`, `G_4`).
Para cada red se proporcionan:
- Matriz de adyacencia — `Ad_G_X.csv`
- Matriz de interacción del flujo — `Id_G_X.csv`
donde `X ∈ {1, 2, 3, 4}` identifica la red correspondiente.
#### 2) Resultados
La carpeta `2) RESULTADOS/` contiene los resultados generados mediante *FCL* para cada red (`G_1`, `G_2`, `G_3`, `G_4`), incluyendo:
- Representaciones gráficas de las particiones obtenidas con el algoritmo de Louvain clásico.
- Representaciones gráficas de las particiones obtenidas con el algoritmo *FCL*.
- Ficheros con las particiones y valores de modularidad asociados.
#### 3) Scripts
Se incluyen los códigos en *MATLAB* necesarios para la ejecución del algoritmo y el cálculo de métricas:
- `FlowCapacityLouvain.m` — implementación del algoritmo *FCL*.
- `compute_DirectLouvain.m` — ejecución del algoritmo de Louvain dirigido.
- `compute_FlowCapacityLouvain.m` — ejecución del algoritmo sobre las matrices de entrada.
- `compute_modularity_dir.m` — cálculo de la modularidad para redes dirigidas.


### [CAPÍTULO 5](./CAP%C3%8DTULO%205/)
Este capítulo se organiza en varias carpetas y archivos, que cubren el proceso completo del enfoque supervisado propuesto para la mejora de los problemas de detección de comunidades mediante el algoritmo *FCL*, desde la selección del parámetro *α* hasta la validación de resultados y el análisis de complejidad.
La estructura del capítulo es la siguiente:
#### 1) Ejemplo
Contiene los resultados completos del ejemplo que motiva la metodología desarrollada en el capítulo.
#### 2) Técnica supervisada
La carpeta `2) TÉCNICA SUPERVISADA/` contiene las redes utilizadas para el desarrollo del enfoque supervisado. Se divide a su vez en:
##### La carpeta **1) REDES POPULARES/**: 
incluye el archivo que contiene redes de referencia empleadas en la literatura para evaluar los algoritmos de detección de comunidades.
##### La carpeta **2) REDES FASE ENTRENAMIENTO/**:
Contiene las redes utilizadas durante la fase de entrenamiento del procedimiento supervisado y que ejecutan el algoritmo *FCL*. Esta carpeta se organiza en dos subcarpetas:
- `Ad` — matrices de adyacencia de las redes de entrenamiento.
- `Id` — matrices de interacción del flujo correspondientes.

En esta fase se evalúan distintos valores del parámetro *α*, obteniendo para cada red la partición resultante y etiquetando su modularidad asociada. El objetivo es identificar el valor de *α* que proporciona el mejor comportamiento del algoritmo *FCL* en el conjunto de entrenamiento.
##### La carpeta **3) REDES FASE TEST/**:
Contiene las redes empleadas para la fase de test. Al igual que en la fase de entrenamiento, se organiza en:
- `Ad` — matrices de adyacencia de las redes de test.
- `Id` — matrices de interacción del flujo correspondientes.

Estas redes permiten comprobar si el valor de *α* seleccionado durante el entrenamiento mantiene su rendimiento sobre datos no utilizados en el ajuste, evaluando así la capacidad de generalización del enfoque supervisado.
#### 3) Scripts
Se incluyen los códigos en *MATLAB* necesarios para la ejecución de los algoritmos de detección de comunidades y la obtención de las etiquetas para el enfoque supervisado.
#### 4) Contraste de hipótesis
La carpeta `4) CONTRASTE DE HIPÓTESIS/` está dedicada a la validación estadística de los resultados obtenidos. Incluye los archivos:
- `Wilcoxon.m` — implementación en *MATLAB* del test de Wilcoxon.
- `datosalfa77.dat` — datos de modularidad asociados al algoritmo *FCL* con el valor de *α* seleccionado en redes de test.
- `datoslouvain.dat` — datos de modularidad asociados al algoritmo de Louvain dirigido utilizado como referencia en redes de test.

Esta parte permite contrastar si las diferencias observadas entre los métodos son estadísticamente significativas, comparando los valores de modularidad obtenidos por *FCL* frente al algoritmo de referencia.
####  5) Complejidad
Contiene el archivo que recoge la complejidad computacional del algoritmo *FCL*. 


### [CAPÍTULO 6](./CAP%C3%8DTULO%206/)
Este capítulo contiene los códigos, redes de referencia, matrices y resultados asociados a la metodología de preprocesamiento de matrices de entrada propuesta para mejorar el problema clásico de detección de comunidades en redes dirigidas.

#### 0) Ejemplo para el preprocesamiento
Contiene un ejemplo ilustrativo del procedimiento seguido para construir la matriz preprocesada a partir de la matriz de adyacencia y de la matriz de interacción del flujo.
#### 1) Conjunto de redes
Contiene las redes utilizadas para evaluar la metodología propuesta, incluyendo las matrices necesarias para trabajar con las redes originales y con sus correspondientes versiones preprocesadas, considerando distintos valores del parámetro *α*. 
#### 2) Resultados
Contiene los resultados obtenidos al aplicar la metodología FMF, empleando diversos algoritmos de detección de comunidades.

Los algoritmos se ejecutan comparando dos escenarios:

1. ejecución clásica, empleando la matriz de adyacencia como entrada;
2. ejecución con preprocesamiento, empleando la matriz obtenida al incorporar información de flujo.

#### 3) Scripts
Contiene los códigos empleados para ejecutar los experimentos del capítulo.

#### 4) Complejidad
Contiene un archivo relacionado con el análisis de la complejidad computacional de la metodología.

#### 5) Machine Learning
Se incluyen un notebook y un archivo destinados a evaluar la capacidad de distintos modelos de aprendizaje automático para predecir cuándo la metodología de preprocesamiento produce una mejora en la modularidad dirigida.

#### 6) CSEA
Contiene los archivos asociados al modelo CSEA, utilizado para complementar el análisis predictivo de la metodología propuesta.
El objetivo es analizar si las particiones generadas por esta metodología pueden utilizarse como inicialización del modelo de deep learning y mejorar la modularidad dirigida frente a la inicialización basada en los algoritmos clásicos.
 
### [CAPÍTULO 7](./CAP%C3%8DTULO%207/)
Este capítulo contiene los códigos, redes de referencia, matrices, resultados y métodos asociados a la optimización de la metodología de preprocesamiento presentada en el Capítulo 6.

El objetivo principal es reducir el coste computacional de la metodología basada en medidas borrosas de flujo, manteniendo un rendimiento competitivo en términos de modularidad dirigida.

Para ello, se proponen dos adaptaciones del preprocesamiento:

- *FEF* (*Fuzzy Edges Flow*): preprocesamiento de arcos borrosos de flujo;
- *FFEF* (*Fast Fuzzy Edges Flow*): preprocesamiento rápido de arcos borrosos de flujo.

#### 1) Conjunto de redes
Se incluyen las redes utilizadas para evaluar las adaptaciones de la metodología de preprocesamiento. Para cada red se proporcionan las matrices necesarias para ejecutar los algoritmos con y sin preprocesamiento, permitiendo comparar el comportamiento de las variantes propuestas frente al enfoque clásico.
#### 2) Resultados
La carpeta de resultados contiene las particiones obtenidas para cada red, algoritmo, variante de preprocesamiento y valor del parámetro *α*.
#### 3) Scripts
Contiene los códigos empleados para ejecutar los experimentos del capítulo.
Estos scripts permiten aplicar los algoritmos de detección de comunidades sobre las matrices originales y sobre las matrices preprocesadas mediante *FEF* y *FFEF*.
#### 4) Complejidad
Contiene un archivo relacionado con el análisis de la complejidad computacional de las variantes de preprocesamiento propuestas.
Este análisis permite estudiar la reducción del coste computacional asociada a *FEF* y *FFEF*, especialmente frente al preprocesamiento completo del Capítulo 6.
#### 5) Machine Learning
Se incluyen notebooks destinados a evaluar la capacidad de distintos modelos para predecir cuándo las adaptaciones de la metodología producen una mejora en la modularidad dirigida.
#### 6) CSEA
Contiene los archivos asociados al modelo CSEA, utilizado para complementar el análisis predictivo de la metodología propuesta y aplicado a las particiones obtenidas mediante las variantes *FEF* y *FFEF*.
El objetivo es analizar si las particiones generadas por estas adaptaciones pueden utilizarse como inicialización del modelo de deep learning y mejorar la modularidad dirigida frente a la inicialización basada en los algoritmos clásicos.
#### 7) Redes tamaño grande
Se incluyen los experimentos realizados sobre redes de gran tamaño utilizando la variante *FFEF*, seleccionada por su menor coste computacional.

Estos experimentos permiten analizar la escalabilidad de la metodología optimizada y comprobar su viabilidad en redes con un número elevado de nodos y arcos.

En este caso se consideran los algoritmos:

- *Louvain*
- *Leiden*

### [CAPÍTULO 8](./CAP%C3%8DTULO%208/)
Este capítulo contiene los datos, matrices, scripts y resultados asociados al caso de estudio real sobre redes de movilidad construidas a partir de datos de telefonía móvil. El objetivo es aplicar la metodología de preprocesamiento *FMF* a redes origen-destino de movilidad y analizar su efecto sobre la detección de comunidades basadas en densidad.

El caso de estudio parte de la matriz de movilidad cotidiana publicada por el Instituto Nacional de Estadística, en la que se recogen desplazamientos medios diarios entre áreas de residencia y áreas de destino. A partir de esta información se construyen dos grafos dirigidos valorados:

- red nacional de movilidad en España;
- red regional centrada en la Comunidad de Madrid, incorporando también áreas limítrofes conectadas con la región.

La estructura del capítulo es la siguiente:
#### 1) Caso real
La carpeta `1) CASO REAL/` contiene los archivos correspondientes al análisis principal presentado en la memoria. Se organiza en:
##### 1) Datos
Contiene los datos empleados para construir la red de movilidad del caso real.
##### 2) Resultados experimentales
Contiene los resultados obtenidos al aplicar la metodología de preprocesamiento *FMF* sobre la red de movilidad nacional y regional.
##### 3) Representaciones
Contiene las representaciones gráficas de las particiones obtenidas en el caso real, utilizadas para visualizar e interpretar las comunidades detectadas.

#### 2) Análisis adicionales
La carpeta `2) ANÁLISIS ADICIONALES/` contiene el material complementario empleado para ampliar el análisis de movilidad. Se organiza en:
##### 1) Códigos
Incluye los códigos necesarios para el tratamiento de los datos, la construcción de matrices, la ejecución del preprocesamiento y la obtención de resultados adicionales.
##### 2) Resultados comunidades
Contiene los resultados de comunidades obtenidos en los análisis adicionales.

Además, se incluye el archivo comprimido:

- `movilidad_cotidiana_enero_noviembre_2021.rar`





## Cita

Si utilizas este repositorio o el contenido de la tesis en tu trabajo, por favor cita la tesis:

```bibtex
@thesis{mariabp_tesis,
  title  = {Aportaciones a problemas de detección de comunidades en redes dirigidas. Definiciones de grupo},
  author = {Barroso P{\'e}rez, Mar{\'i}a},
  year   = {2026},
  publisher = {Universidad Complutense de Madrid}
}


