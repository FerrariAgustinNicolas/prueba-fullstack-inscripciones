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