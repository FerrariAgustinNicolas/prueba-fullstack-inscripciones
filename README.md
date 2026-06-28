# Mini sistema de registro y análisis de inscripciones

Proyecto desarrollado como resolución de una prueba técnica Fullstack Jr.

El objetivo es construir un mini-sistema para registrar, consultar y analizar inscripciones de alumnos a programas educativos. La solución está dividida en cuatro partes principales:

1. Base de datos en MariaDB.
2. Análisis de datos con Python y Pandas.
3. Interfaz web en Angular.
4. Preguntas conceptuales y documentación.

---

## Estructura del proyecto

```text
prueba-fullstack-inscripciones/
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
```

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

Desde la raíz del proyecto, ejecutar:

```bash
mariadb --local-infile=1 -u TU_USUARIO -p < sql/01_schema_seed_queries.sql
```

El script crea la base de datos `inscripciones_db`, define las tablas principales, carga datos desde `data/alumnos_muestra.csv`, genera movimientos plausibles de historial, ejecuta las consultas requeridas, calcula un indicador de negocio y crea un stored procedure para registrar cambios de estatus.

El script está preparado para ejecutarse desde cero. Por ese motivo, al inicio elimina y vuelve a crear la base de datos:

```sql
DROP DATABASE IF EXISTS inscripciones_db;
CREATE DATABASE inscripciones_db;
```

Esto permite reproducir la solución de forma limpia, pero también implica que cualquier cambio manual realizado después de ejecutar el script se pierde si el script se vuelve a correr completo.

---

### Verificación básica de la base de datos

Luego de ejecutar el script, se puede ingresar a MariaDB con:

```bash
mariadb -u TU_USUARIO -p
```

Y verificar:

```sql
USE inscripciones_db;

SHOW TABLES;

SELECT COUNT(*) AS total_alumnos FROM alumnos;
SELECT COUNT(*) AS total_programas FROM programas;
SELECT COUNT(*) AS total_inscripciones FROM inscripciones;
SELECT COUNT(*) AS total_historial FROM historial_estatus;

SHOW PROCEDURE STATUS
WHERE Db = 'inscripciones_db';
```

---

### Decisiones de diseño SQL

* Se utilizó un esquema relacional simple con cuatro tablas principales: `alumnos`, `programas`, `inscripciones` e `historial_estatus`.
* La tabla `alumnos` almacena los datos generales del alumno.
* La tabla `programas` funciona como catálogo de programas académicos.
* La tabla `inscripciones` relaciona alumnos con programas y almacena el estatus actual de cada inscripción.
* La tabla `historial_estatus` registra los cambios de estatus en el tiempo, permitiendo trazabilidad y análisis histórico.
* Los estatus se implementaron con `ENUM`, ya que la consigna define una lista cerrada de valores posibles.
* Se agregó una restricción `UNIQUE (id_alumno, id_programa)` para evitar duplicar la inscripción de un mismo alumno en el mismo programa.
* Se agregaron índices básicos sobre columnas utilizadas en filtros, joins y consultas frecuentes, como `estatus_actual`, `id_programa`, `id_inscripcion` y `fecha_cambio`.

---

### Supuestos tomados

* El archivo `alumnos_muestra.csv` representa un snapshot del estado actual de los alumnos.
* El CSV no contiene historial real de cambios de estatus, por lo que se generaron movimientos plausibles de muestra.
* Como el CSV no incluye una fecha de ingreso separada, se utilizó `fecha_inscripcion` como `fecha_ingreso` inicial del alumno.
* Se conservaron los estatus normalizados en formato técnico, por ejemplo `baja_empresa`, `baja_programa` y `reingreso`.
* El historial generado tiene fines de prueba y permite resolver las consultas, el indicador y los análisis solicitados.
* El stored procedure `sp_registrar_cambio_estatus` representa la operación principal del sistema para registrar cambios de estado de una inscripción.

---

### Probar el stored procedure

El stored procedure creado se llama:

```sql
sp_registrar_cambio_estatus
```

Recibe tres parámetros:

```sql
p_id_inscripcion
p_nuevo_estatus
p_motivo
```

Primero se puede consultar una inscripción existente:

```sql
USE inscripciones_db;

SELECT
    id_inscripcion,
    id_alumno,
    estatus_actual
FROM inscripciones
LIMIT 5;
```

Luego se puede ejecutar un cambio de estatus. Por ejemplo, si la inscripción `1` tiene estatus `activo`, se puede cambiar a `suspendido`:

```sql
CALL sp_registrar_cambio_estatus(
    1,
    'suspendido',
    'Prueba de cambio de estatus desde stored procedure'
);
```

El procedimiento actualiza el estatus actual en la tabla `inscripciones` e inserta el movimiento correspondiente en `historial_estatus`.

Para verificar el cambio:

```sql
SELECT
    id_inscripcion,
    id_alumno,
    estatus_actual
FROM inscripciones
WHERE id_inscripcion = 1;
```

Para verificar el historial generado:

```sql
SELECT
    id_historial,
    id_inscripcion,
    estatus_anterior,
    estatus_nuevo,
    fecha_cambio,
    motivo
FROM historial_estatus
WHERE id_inscripcion = 1
ORDER BY id_historial DESC;
```

También se puede probar el manejo de errores con una inscripción inexistente:

```sql
CALL sp_registrar_cambio_estatus(
    999999,
    'activo',
    'Prueba con inscripción inexistente'
);
```

En ese caso, el procedimiento devuelve un error controlado indicando que la inscripción no existe.

También valida que no se registre un cambio si el nuevo estatus es igual al estatus actual:

```sql
CALL sp_registrar_cambio_estatus(
    1,
    'suspendido',
    'Prueba repetida con el mismo estatus'
);
```

Si la inscripción ya está en `suspendido`, el procedimiento devuelve un error controlado indicando que el nuevo estatus es igual al estatus actual.

### Ejecutar notebook Python

Pendiente.

### Ejecutar Angular

Pendiente.

---

## Estado del desarrollo

* [x] Estructura inicial del proyecto.
* [x] Archivo CSV agregado.
* [x] Base de datos MariaDB.
* [ ] Análisis con Python/Pandas.
* [ ] Interfaz Angular.
* [ ] Preguntas conceptuales.
* [ ] README final con instrucciones completas.
