-- =====================================================
-- Parte 1 - Base de datos MariaDB
-- Mini sistema de registro y seguimiento de inscripciones
-- =====================================================

-- Este script contiene:
-- 1. Creación de base de datos
-- 2. Creación de tablas principales
-- 3. Definición de relaciones
-- 4. Índices básicos para consultas frecuentes

-- =====================================================
-- 1. Creación de base de datos
-- =====================================================

DROP DATABASE IF EXISTS inscripciones_db;
CREATE DATABASE inscripciones_db
    CHARACTER SET utf8mb4
    COLLATE utf8mb4_unicode_ci;

USE inscripciones_db;

-- =====================================================
-- 2. Creación de tablas
-- =====================================================

-- Tabla: alumnos
-- Guarda los datos principales del alumno.
CREATE TABLE alumnos (
    id_alumno INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    empresa VARCHAR(100) NOT NULL,
    fecha_ingreso DATE NOT NULL
);

-- Tabla: programas
-- Catálogo de programas académicos disponibles.
CREATE TABLE programas (
    id_programa INT AUTO_INCREMENT PRIMARY KEY,
    nombre_programa VARCHAR(100) NOT NULL UNIQUE
);

-- Tabla: inscripciones
-- Relaciona alumnos con programas y guarda el estatus actual.
CREATE TABLE inscripciones (
    id_inscripcion INT AUTO_INCREMENT PRIMARY KEY,
    id_alumno INT NOT NULL,
    id_programa INT NOT NULL,
    estatus_actual ENUM(
        'activo',
        'baja_empresa',
        'baja_programa',
        'inscrito',
        'suspendido',
        'reingreso',
        'egresado'
    ) NOT NULL,
    fecha_inscripcion DATE NOT NULL,

    CONSTRAINT fk_inscripciones_alumnos
        FOREIGN KEY (id_alumno)
        REFERENCES alumnos(id_alumno),

    CONSTRAINT fk_inscripciones_programas
        FOREIGN KEY (id_programa)
        REFERENCES programas(id_programa),

    CONSTRAINT uq_alumno_programa
        UNIQUE (id_alumno, id_programa)
);

-- Tabla: historial_estatus
-- Registra cada cambio de estatus de una inscripción.
CREATE TABLE historial_estatus (
    id_historial INT AUTO_INCREMENT PRIMARY KEY,
    id_inscripcion INT NOT NULL,
    estatus_anterior ENUM(
        'activo',
        'baja_empresa',
        'baja_programa',
        'inscrito',
        'suspendido',
        'reingreso',
        'egresado'
    ),
    estatus_nuevo ENUM(
        'activo',
        'baja_empresa',
        'baja_programa',
        'inscrito',
        'suspendido',
        'reingreso',
        'egresado'
    ) NOT NULL,
    fecha_cambio DATE NOT NULL,
    motivo VARCHAR(255) NOT NULL,

    CONSTRAINT fk_historial_inscripciones
        FOREIGN KEY (id_inscripcion)
        REFERENCES inscripciones(id_inscripcion)
);

-- =====================================================
-- 3. Índices para consultas frecuentes
-- =====================================================

CREATE INDEX idx_alumnos_empresa
    ON alumnos(empresa);

CREATE INDEX idx_programas_nombre
    ON programas(nombre_programa);

CREATE INDEX idx_inscripciones_estatus
    ON inscripciones(estatus_actual);

CREATE INDEX idx_inscripciones_programa
    ON inscripciones(id_programa);

CREATE INDEX idx_historial_fecha_cambio
    ON historial_estatus(fecha_cambio);

CREATE INDEX idx_historial_inscripcion
    ON historial_estatus(id_inscripcion);

CREATE INDEX idx_historial_estatus_nuevo
    ON historial_estatus(estatus_nuevo);

-- =====================================================
-- 4. Carga de datos desde CSV
-- =====================================================

-- El archivo alumnos_muestra.csv contiene el estado actual de los alumnos.
-- Se utiliza una tabla temporal para importar el CSV y luego distribuir
-- los datos en las tablas normalizadas del modelo.

CREATE TEMPORARY TABLE staging_alumnos_csv (
    id_alumno INT,
    nombre VARCHAR(100),
    empresa VARCHAR(100),
    programa VARCHAR(100),
    estatus VARCHAR(30),
    fecha_inscripcion VARCHAR(20)
);

-- IMPORTANTE:
-- Este comando espera que el script se ejecute desde la raíz del proyecto,
-- donde existe la carpeta data/alumnos_muestra.csv.
LOAD DATA LOCAL INFILE 'data/alumnos_muestra.csv'
INTO TABLE staging_alumnos_csv
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(id_alumno, nombre, empresa, programa, estatus, fecha_inscripcion);

-- Carga de programas únicos desde el CSV.
INSERT INTO programas (nombre_programa)
SELECT DISTINCT TRIM(programa)
FROM staging_alumnos_csv
WHERE programa IS NOT NULL
  AND TRIM(programa) <> '';

-- Carga de alumnos.
-- Como el CSV no incluye una fecha_ingreso separada, se toma fecha_inscripcion
-- como fecha de ingreso inicial del alumno.
INSERT INTO alumnos (id_alumno, nombre, empresa, fecha_ingreso)
SELECT
    id_alumno,
    TRIM(nombre),
    TRIM(empresa),
    STR_TO_DATE(fecha_inscripcion, '%d/%m/%Y') AS fecha_ingreso
FROM staging_alumnos_csv;

-- Carga de inscripciones.
-- Relaciona cada alumno con su programa y conserva el estatus actual del CSV.
INSERT INTO inscripciones (
    id_alumno,
    id_programa,
    estatus_actual,
    fecha_inscripcion
)
SELECT
    s.id_alumno,
    p.id_programa,
    s.estatus,
    STR_TO_DATE(s.fecha_inscripcion, '%d/%m/%Y') AS fecha_inscripcion
FROM staging_alumnos_csv s
INNER JOIN programas p
    ON p.nombre_programa = TRIM(s.programa);

-- =====================================================
-- 5. Carga de historial plausible de cambios de estatus
-- =====================================================

-- El CSV contiene únicamente el estatus actual de cada alumno.
-- Para poder analizar cambios en el tiempo, se generan movimientos plausibles.
-- Las fechas se calculan con CURDATE() para que algunas consultas, como
-- "cambios en los últimos 30 días", sigan funcionando al momento de evaluar.

-- Alumno 1001: caso de reingreso desde baja_empresa hacia activo.
-- Estatus actual en inscripciones: activo.
INSERT INTO historial_estatus (
    id_inscripcion,
    estatus_anterior,
    estatus_nuevo,
    fecha_cambio,
    motivo
)
SELECT
    i.id_inscripcion,
    'inscrito',
    'activo',
    DATE_SUB(CURDATE(), INTERVAL 120 DAY),
    'Inicio regular del programa'
FROM inscripciones i
WHERE i.id_alumno = 1001;

INSERT INTO historial_estatus (
    id_inscripcion,
    estatus_anterior,
    estatus_nuevo,
    fecha_cambio,
    motivo
)
SELECT
    i.id_inscripcion,
    'activo',
    'baja_empresa',
    DATE_SUB(CURDATE(), INTERVAL 25 DAY),
    'Cambio laboral reportado por la empresa'
FROM inscripciones i
WHERE i.id_alumno = 1001;

INSERT INTO historial_estatus (
    id_inscripcion,
    estatus_anterior,
    estatus_nuevo,
    fecha_cambio,
    motivo
)
SELECT
    i.id_inscripcion,
    'baja_empresa',
    'activo',
    DATE_SUB(CURDATE(), INTERVAL 5 DAY),
    'Reingreso autorizado por reincorporación laboral'
FROM inscripciones i
WHERE i.id_alumno = 1001;


-- Alumno 1007: baja por empresa.
-- Estatus actual en inscripciones: baja_empresa.
INSERT INTO historial_estatus (
    id_inscripcion,
    estatus_anterior,
    estatus_nuevo,
    fecha_cambio,
    motivo
)
SELECT
    i.id_inscripcion,
    'inscrito',
    'activo',
    DATE_SUB(CURDATE(), INTERVAL 90 DAY),
    'Activación inicial de inscripción'
FROM inscripciones i
WHERE i.id_alumno = 1007;

INSERT INTO historial_estatus (
    id_inscripcion,
    estatus_anterior,
    estatus_nuevo,
    fecha_cambio,
    motivo
)
SELECT
    i.id_inscripcion,
    'activo',
    'baja_empresa',
    DATE_SUB(CURDATE(), INTERVAL 12 DAY),
    'Finalización de relación laboral con la empresa'
FROM inscripciones i
WHERE i.id_alumno = 1007;


-- Alumno 1005: baja del programa.
-- Estatus actual en inscripciones: baja_programa.
INSERT INTO historial_estatus (
    id_inscripcion,
    estatus_anterior,
    estatus_nuevo,
    fecha_cambio,
    motivo
)
SELECT
    i.id_inscripcion,
    'inscrito',
    'activo',
    DATE_SUB(CURDATE(), INTERVAL 180 DAY),
    'Inicio de cursada'
FROM inscripciones i
WHERE i.id_alumno = 1005;

INSERT INTO historial_estatus (
    id_inscripcion,
    estatus_anterior,
    estatus_nuevo,
    fecha_cambio,
    motivo
)
SELECT
    i.id_inscripcion,
    'activo',
    'baja_programa',
    DATE_SUB(CURDATE(), INTERVAL 20 DAY),
    'Baja voluntaria solicitada por el alumno'
FROM inscripciones i
WHERE i.id_alumno = 1005;


-- Alumno 1002: suspensión temporal.
-- Estatus actual en inscripciones: suspendido.
INSERT INTO historial_estatus (
    id_inscripcion,
    estatus_anterior,
    estatus_nuevo,
    fecha_cambio,
    motivo
)
SELECT
    i.id_inscripcion,
    'inscrito',
    'activo',
    DATE_SUB(CURDATE(), INTERVAL 75 DAY),
    'Alumno habilitado para cursar'
FROM inscripciones i
WHERE i.id_alumno = 1002;

INSERT INTO historial_estatus (
    id_inscripcion,
    estatus_anterior,
    estatus_nuevo,
    fecha_cambio,
    motivo
)
SELECT
    i.id_inscripcion,
    'activo',
    'suspendido',
    DATE_SUB(CURDATE(), INTERVAL 10 DAY),
    'Suspensión temporal por documentación pendiente'
FROM inscripciones i
WHERE i.id_alumno = 1002;


-- Alumno 1003: egreso.
-- Estatus actual en inscripciones: egresado.
INSERT INTO historial_estatus (
    id_inscripcion,
    estatus_anterior,
    estatus_nuevo,
    fecha_cambio,
    motivo
)
SELECT
    i.id_inscripcion,
    'inscrito',
    'activo',
    DATE_SUB(CURDATE(), INTERVAL 300 DAY),
    'Inicio del trayecto académico'
FROM inscripciones i
WHERE i.id_alumno = 1003;

INSERT INTO historial_estatus (
    id_inscripcion,
    estatus_anterior,
    estatus_nuevo,
    fecha_cambio,
    motivo
)
SELECT
    i.id_inscripcion,
    'activo',
    'egresado',
    DATE_SUB(CURDATE(), INTERVAL 40 DAY),
    'Finalización satisfactoria del programa'
FROM inscripciones i
WHERE i.id_alumno = 1003;


-- Alumno 1024: caso con estatus actual reingreso.
-- Estatus actual en inscripciones: reingreso.
INSERT INTO historial_estatus (
    id_inscripcion,
    estatus_anterior,
    estatus_nuevo,
    fecha_cambio,
    motivo
)
SELECT
    i.id_inscripcion,
    'inscrito',
    'activo',
    DATE_SUB(CURDATE(), INTERVAL 200 DAY),
    'Activación inicial de inscripción'
FROM inscripciones i
WHERE i.id_alumno = 1024;

INSERT INTO historial_estatus (
    id_inscripcion,
    estatus_anterior,
    estatus_nuevo,
    fecha_cambio,
    motivo
)
SELECT
    i.id_inscripcion,
    'activo',
    'baja_empresa',
    DATE_SUB(CURDATE(), INTERVAL 60 DAY),
    'Pausa por cambio de condiciones laborales'
FROM inscripciones i
WHERE i.id_alumno = 1024;

INSERT INTO historial_estatus (
    id_inscripcion,
    estatus_anterior,
    estatus_nuevo,
    fecha_cambio,
    motivo
)
SELECT
    i.id_inscripcion,
    'baja_empresa',
    'reingreso',
    DATE_SUB(CURDATE(), INTERVAL 18 DAY),
    'Reingreso al programa autorizado por coordinación'
FROM inscripciones i
WHERE i.id_alumno = 1024;

-- =====================================================
-- 6. Consultas requeridas
-- =====================================================

-- -----------------------------------------------------
-- 6.1 Alumnos activos por programa
-- -----------------------------------------------------
-- Cuenta la cantidad de alumnos cuyo estatus actual es 'activo',
-- agrupados por programa académico.

SELECT
    p.nombre_programa,
    COUNT(i.id_inscripcion) AS total_alumnos_activos
FROM inscripciones i
INNER JOIN programas p
    ON i.id_programa = p.id_programa
WHERE i.estatus_actual = 'activo'
GROUP BY p.nombre_programa
ORDER BY total_alumnos_activos DESC;


-- -----------------------------------------------------
-- 6.2 Alumnos que tuvieron al menos un cambio de estatus
--     en los últimos 30 días
-- -----------------------------------------------------
-- Usa la tabla historial_estatus, ya que los cambios de estado
-- se registran como eventos históricos.

SELECT DISTINCT
    a.id_alumno,
    a.nombre,
    a.empresa,
    p.nombre_programa,
    h.estatus_anterior,
    h.estatus_nuevo,
    h.fecha_cambio,
    h.motivo
FROM historial_estatus h
INNER JOIN inscripciones i
    ON h.id_inscripcion = i.id_inscripcion
INNER JOIN alumnos a
    ON i.id_alumno = a.id_alumno
INNER JOIN programas p
    ON i.id_programa = p.id_programa
WHERE h.fecha_cambio >= DATE_SUB(CURDATE(), INTERVAL 30 DAY)
ORDER BY h.fecha_cambio DESC;


-- -----------------------------------------------------
-- 6.3 Tasa de baja por programa
-- -----------------------------------------------------
-- Fórmula:
-- tasa_baja = alumnos con estatus actual de baja / total de inscripciones
--
-- Se consideran bajas los estatus:
-- - baja_empresa
-- - baja_programa

SELECT
    p.nombre_programa,
    COUNT(i.id_inscripcion) AS total_inscripciones,
    SUM(
        CASE
            WHEN i.estatus_actual IN ('baja_empresa', 'baja_programa')
            THEN 1
            ELSE 0
        END
    ) AS total_bajas,
    ROUND(
        SUM(
            CASE
                WHEN i.estatus_actual IN ('baja_empresa', 'baja_programa')
                THEN 1
                ELSE 0
            END
        ) / COUNT(i.id_inscripcion) * 100,
        2
    ) AS tasa_baja_porcentaje
FROM inscripciones i
INNER JOIN programas p
    ON i.id_programa = p.id_programa
GROUP BY p.nombre_programa
ORDER BY tasa_baja_porcentaje DESC;


-- -----------------------------------------------------
-- 6.4 Historial completo de un alumno específico
-- -----------------------------------------------------
-- JOIN de las 4 tablas principales:
-- alumnos, inscripciones, programas e historial_estatus.
--
-- Para esta consulta se utiliza como ejemplo el alumno con id_alumno = 1001.
-- Este valor puede reemplazarse por cualquier otro id_alumno existente.

SELECT
    a.id_alumno,
    a.nombre,
    a.empresa,
    a.fecha_ingreso,
    p.nombre_programa,
    i.estatus_actual,
    i.fecha_inscripcion,
    h.estatus_anterior,
    h.estatus_nuevo,
    h.fecha_cambio,
    h.motivo
FROM alumnos a
INNER JOIN inscripciones i
    ON a.id_alumno = i.id_alumno
INNER JOIN programas p
    ON i.id_programa = p.id_programa
LEFT JOIN historial_estatus h
    ON i.id_inscripcion = h.id_inscripcion
WHERE a.id_alumno = 1001
ORDER BY h.fecha_cambio ASC;

-- -----------------------------------------------------
-- 6.5 Alumnos que pasaron de baja_empresa a activo
-- -----------------------------------------------------
-- Identifica reinscripciones o reincorporaciones donde el alumno
-- pasó desde una baja por empresa hacia el estatus activo.

SELECT
    a.id_alumno,
    a.nombre,
    a.empresa,
    p.nombre_programa,
    h.estatus_anterior,
    h.estatus_nuevo,
    h.fecha_cambio,
    h.motivo
FROM historial_estatus h
INNER JOIN inscripciones i
    ON h.id_inscripcion = i.id_inscripcion
INNER JOIN alumnos a
    ON i.id_alumno = a.id_alumno
INNER JOIN programas p
    ON i.id_programa = p.id_programa
WHERE h.estatus_anterior = 'baja_empresa'
  AND h.estatus_nuevo = 'activo'
ORDER BY h.fecha_cambio DESC;

-- =====================================================
-- 7. Propuesta de indicador de negocio
-- =====================================================

-- Nombre del indicador:
-- Índice de continuidad académica por programa
--
-- Definición:
-- Mide el porcentaje de alumnos que se mantienen en un estado favorable
-- dentro de cada programa académico.
--
-- Fórmula:
-- índice_continuidad =
--     alumnos con estatus activo, inscrito, reingreso o egresado
--     / total de inscripciones del programa * 100
--
-- Justificación:
-- Este indicador permite identificar qué programas logran mantener mayor
-- continuidad académica. Es útil para detectar programas con mayor riesgo
-- de abandono, suspensión o baja, y permite priorizar acciones de seguimiento
-- sobre los programas con menor continuidad.

SELECT
    p.nombre_programa,
    COUNT(i.id_inscripcion) AS total_inscripciones,
    SUM(
        CASE
            WHEN i.estatus_actual IN ('activo', 'inscrito', 'reingreso', 'egresado')
            THEN 1
            ELSE 0
        END
    ) AS alumnos_en_continuidad,
    SUM(
        CASE
            WHEN i.estatus_actual IN ('baja_empresa', 'baja_programa', 'suspendido')
            THEN 1
            ELSE 0
        END
    ) AS alumnos_sin_continuidad,
    ROUND(
        SUM(
            CASE
                WHEN i.estatus_actual IN ('activo', 'inscrito', 'reingreso', 'egresado')
                THEN 1
                ELSE 0
            END
        ) / COUNT(i.id_inscripcion) * 100,
        2
    ) AS indice_continuidad_porcentaje
FROM inscripciones i
INNER JOIN programas p
    ON i.id_programa = p.id_programa
GROUP BY p.nombre_programa
ORDER BY indice_continuidad_porcentaje DESC;

-- =====================================================
-- 8. Stored Procedure
-- =====================================================

-- Stored Procedure: sp_registrar_cambio_estatus
--
-- Objetivo:
-- Registrar un cambio de estatus para una inscripción existente.
--
-- Operación:
-- 1. Recibe el id de la inscripción, el nuevo estatus y el motivo.
-- 2. Valida que la inscripción exista.
-- 3. Valida que el nuevo estatus sea uno de los permitidos.
-- 4. Actualiza el estatus actual en la tabla inscripciones.
-- 5. Inserta el cambio en historial_estatus.
-- 6. Devuelve una confirmación con datos del alumno, programa e historial.
--
-- Tablas involucradas:
-- - alumnos
-- - programas
-- - inscripciones
-- - historial_estatus

DELIMITER //

DROP PROCEDURE IF EXISTS sp_registrar_cambio_estatus//

CREATE PROCEDURE sp_registrar_cambio_estatus(
    IN p_id_inscripcion INT,
    IN p_nuevo_estatus VARCHAR(30),
    IN p_motivo VARCHAR(255)
)
BEGIN
    DECLARE v_estatus_actual VARCHAR(30);
    DECLARE v_existe_inscripcion INT DEFAULT 0;
    DECLARE v_id_historial INT;

    -- Verifica si la inscripción existe.
    SELECT COUNT(*)
    INTO v_existe_inscripcion
    FROM inscripciones
    WHERE id_inscripcion = p_id_inscripcion;

    IF v_existe_inscripcion = 0 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'La inscripción indicada no existe.';
    END IF;

    -- Valida que el nuevo estatus sea uno de los estatus permitidos.
    IF p_nuevo_estatus NOT IN (
        'activo',
        'baja_empresa',
        'baja_programa',
        'inscrito',
        'suspendido',
        'reingreso',
        'egresado'
    ) THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'El nuevo estatus no es válido.';
    END IF;

    -- Obtiene el estatus actual de la inscripción.
    SELECT estatus_actual
    INTO v_estatus_actual
    FROM inscripciones
    WHERE id_inscripcion = p_id_inscripcion;

    -- Evita registrar un cambio si el nuevo estatus es igual al actual.
    IF v_estatus_actual = p_nuevo_estatus THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'El nuevo estatus es igual al estatus actual.';
    END IF;

    -- Actualiza el estatus actual de la inscripción.
    UPDATE inscripciones
    SET estatus_actual = p_nuevo_estatus
    WHERE id_inscripcion = p_id_inscripcion;

    -- Inserta el movimiento en el historial.
    INSERT INTO historial_estatus (
        id_inscripcion,
        estatus_anterior,
        estatus_nuevo,
        fecha_cambio,
        motivo
    )
    VALUES (
        p_id_inscripcion,
        v_estatus_actual,
        p_nuevo_estatus,
        CURDATE(),
        p_motivo
    );

    SET v_id_historial = LAST_INSERT_ID();

    -- Devuelve una confirmación del cambio realizado.
    SELECT
        a.id_alumno,
        a.nombre,
        a.empresa,
        p.nombre_programa,
        i.id_inscripcion,
        h.estatus_anterior,
        h.estatus_nuevo,
        h.fecha_cambio,
        h.motivo
    FROM historial_estatus h
    INNER JOIN inscripciones i
        ON h.id_inscripcion = i.id_inscripcion
    INNER JOIN alumnos a
        ON i.id_alumno = a.id_alumno
    INNER JOIN programas p
        ON i.id_programa = p.id_programa
    WHERE h.id_historial = v_id_historial;
END//

DELIMITER ;