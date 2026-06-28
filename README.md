# Mini sistema de registro y análisis de inscripciones

Proyecto desarrollado como resolución de una prueba técnica Fullstack Jr.

El objetivo es construir un mini-sistema para registrar, consultar y analizar inscripciones de alumnos a programas educativos. La solución está dividida en cuatro partes principales:

1. Base de datos en MariaDB.
2. Análisis de datos con Python y Pandas.
3. Interfaz web en Angular.
4. Preguntas conceptuales y documentación.

---

## Estructura del proyecto


prueba-fullstack-inscripciones/
│
├── data/
│   └── alumnos_muestra.csv
│
├── sql/
│   └── 01_schema_seed_queries.sql
│
├── python/
│   ├── analisis_inscripciones.ipynb
│   └── requirements.txt
│
├── frontend/
│   └── academiaglobal-inscripciones/
│
├── docs/
│   └── preguntas_conceptuales.md
│
├── README.md
└── .gitignore


---

## Parte 1 — Base de datos MariaDB

Estado: pendiente de implementación.

Esta sección incluirá:

* Creación del esquema relacional.
* Carga de datos iniciales desde el archivo CSV.
* Poblado de historial de cambios de estatus.
* Consultas SQL requeridas.
* Propuesta de indicador de negocio.
* Stored procedure para registrar cambios de estatus.

---

## Parte 2 — Análisis de datos con Python/Pandas

Estado: pendiente de implementación.

Esta sección incluirá:

* Conexión a MariaDB.
* Carga de tablas en DataFrames de Pandas.
* Análisis de distribución de estatus por programa.
* Evolución mensual de bajas y alumnos activos.
* Cálculo de tasa de activos por programa.
* Identificación del motivo de baja más frecuente.
* Visualizaciones requeridas.

---

## Parte 3 — Interfaz Angular

Estado: pendiente de implementación.

Esta sección incluirá:

* Formulario de registro de nuevo alumno usando Reactive Forms.
* Tabla de alumnos con estatus actual visible.
* Filtros por estatus y por programa.
* Panel o modal para registrar cambios de estatus con motivo.
* Componente de resumen con conteos por estatus.
* Estado compartido mediante un service con BehaviorSubject.
* Persistencia inicial con mock data y/o localStorage.

La interfaz Angular se resolverá inicialmente con mock data y/o localStorage, tal como permite la consigna. Esta decisión permite cumplir primero los requisitos funcionales obligatorios. Luego, si el tiempo disponible lo permite, se evaluará reemplazar esta persistencia local por una conexión real a una API backend.

---

## Parte 4 — Preguntas conceptuales

Estado: pendiente de implementación.

Las respuestas conceptuales estarán documentadas en:

---

## Datos de entrada

El proyecto utiliza como punto de partida el archivo:

data/alumnos_muestra.csv

Este archivo contiene el estado actual de los alumnos, incluyendo datos como nombre, empresa, programa, estatus y fecha de inscripción.

El historial de cambios de estatus no viene incluido en el CSV, por lo que será generado como información de muestra plausible para poder resolver las consultas, análisis e interfaz solicitados.

---

## Supuestos iniciales

* El archivo CSV representa un snapshot del estado actual de los alumnos.
* El historial de cambios de estatus no viene incluido en el CSV, por lo que será generado con movimientos de muestra plausibles para poder resolver las consultas, análisis e interfaz solicitados.
* Un alumno puede estar asociado a un programa mediante una inscripción.
* El estatus actual del alumno dentro de un programa se almacenará en la tabla de inscripciones.
* Los cambios de estatus se registrarán en una tabla separada de historial para conservar trazabilidad.
* La interfaz Angular se resolverá inicialmente con mock data y/o localStorage, tal como permite la consigna. Una vez cumplidos los requisitos mínimos, si el tiempo lo permite, se evaluará implementar una API backend como extra deseable.

---

## Criterios de implementación iniciales

* Se mantendrá una estructura de carpetas separada por responsabilidad: datos, SQL, análisis en Python, frontend Angular y documentación.
* La base de datos se implementará en un único archivo SQL comentado, incluyendo DDL, DML, consultas requeridas, indicador y stored procedure.
* El análisis en Python se desarrollará en un Jupyter Notebook con celdas comentadas y pasos reproducibles.
* La interfaz Angular se organizará en componentes separados para registro, listado de alumnos, cambio de estatus y resumen.
* El estado compartido de la interfaz se manejará mediante un service, evitando duplicar lógica entre componentes.
* La primera versión priorizará cumplir los requisitos obligatorios de forma simple y funcional. Los extras se abordarán únicamente después de completar la solución mínima.

---

## Extras deseables considerados

Una vez completados los requisitos obligatorios de la prueba, se evaluará incorporar los siguientes extras deseables:

* Visualización del historial de cambios de estatus por alumno dentro de la interfaz Angular.
* Interfaz responsive para mejorar la experiencia de uso en distintos tamaños de pantalla.
* Conexión real a una API backend para reemplazar el uso inicial de mock data o localStorage.

El orden de prioridad propuesto para estos extras será:

1. Mostrar historial de cambios de estatus en la UI, ya que aprovecha la lógica de cambios de estatus ya implementada.
2. Mejorar la interfaz responsive con estilos simples, priorizando usabilidad y claridad visual.
3. Implementar una API backend real únicamente si el tiempo disponible lo permite, ya que no forma parte de los requisitos mínimos obligatorios.

---

## Instrucciones de ejecución

Las instrucciones se completarán a medida que se implemente cada parte.

### Ejecutar SQL

Pendiente.

### Ejecutar notebook Python

Pendiente.

### Ejecutar Angular

Pendiente.

---

## Estado del desarrollo

* [x] Estructura inicial del proyecto.
* [x] Archivo CSV agregado.
* [ ] Base de datos MariaDB.
* [ ] Análisis con Python/Pandas.
* [ ] Interfaz Angular.
* [ ] Preguntas conceptuales.
* [ ] README final con instrucciones completas.
