# Preguntas conceptuales

## SQL / MariaDB

### Pregunta 1

**Tu tabla historial_estatus crece rápido. ¿Qué harías para que las consultas de historial no se vuelvan lentas con el tiempo?**

Agregaría índices a las columnas más consultadas, por ejemplo `id_inscripcion`, `fecha_cambio` y `estatus_nuevo`.
También evitaría traer todo el historial completo sin filtros, usando rangos de fechas o paginación.

---

### Pregunta 2

**Un alumno aparece dos veces con estatus activo seguido en el historial, sin una baja intermedia. ¿Cómo detectarías ese problema y cómo lo evitarías desde el diseño?**

Lo detectaría comparando cada movimiento con el movimiento anterior usando una consulta con `LAG()` por inscripción ordenada por fecha.
Si `estatus_nuevo` y el estatus anterior son ambos `activo`, sería un caso inconsistente.
Para evitarlo, centralizaría los cambios en un stored procedure que valide que el nuevo estatus sea distinto al actual.

---

## Python / Pandas

### Pregunta 3

**Tienes un DataFrame con 50,000 registros de movimientos. Al hacer un groupby por programa y mes, algunos meses no aparecen para ciertos programas. ¿Qué causa eso y cómo lo resuelves?**

Eso ocurre porque `groupby` solo devuelve combinaciones existentes en los datos.
Lo resolvería creando un rango completo de meses y programas, y luego usando `reindex` con un `MultiIndex`.

---

### Pregunta 4

**¿Cuál es la diferencia entre usar merge y join en pandas? ¿Cuándo usarías cada uno?**

`merge` permite unir DataFrames usando columnas específicas, parecido a un `JOIN` de SQL.
`join` suele usarse para unir por índice, aunque también permite algunas variantes.
Usaría `merge` cuando tengo claves explícitas como `id_alumno` o `id_programa`.
Usaría `join` cuando los DataFrames ya están indexados por la clave de unión.

---

## Angular

### Pregunta 5

**Tu componente de tabla de alumnos re-renderiza completo cada vez que cambias el estatus de uno solo. ¿Qué causaría eso y cómo lo optimizarías?**

Puede ocurrir porque al actualizar el estado se emite una nueva lista completa desde el service.
Angular vuelve a evaluar el `*ngFor` y puede re-renderizar más de lo necesario.
Lo optimizaría usando `trackBy` en el listado para identificar cada alumno por su `id`.
También podría usar `ChangeDetectionStrategy.OnPush` para reducir detecciones innecesarias.

---

### Pregunta 6

**¿Dónde guardarías el estatus actual de los alumnos en una app Angular sin backend: en el componente directamente, en un Service compartido, o en localStorage? Justifica tu elección.**

Guardaría el estado principal en un Service compartido, como `AlumnoService`, porque varios componentes necesitan acceder a los mismos alumnos.  
El componente no debería ser la fuente central del estado, sino consumir datos y disparar acciones.  
Usaría `BehaviorSubject` para emitir cambios y actualizar tabla, resumen e historial automáticamente.  
Además, persistiría en `localStorage` para conservar los datos al recargar la página en una app sin backend.
