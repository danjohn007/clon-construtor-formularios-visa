-- ============================================================
-- MIGRACIÓN: Cambiar campo 'type' de ENUM a VARCHAR
-- Base de datos: landscap_testing
-- Tabla: forms
-- MySQL Version: 5.7
-- Fecha: 2026-03-17
-- ============================================================

-- Paso 1: Ver estructura actual (opcional, para referencia)
-- SHOW COLUMNS FROM forms LIKE 'type';

-- Paso 2: Modificar el campo type de ENUM a VARCHAR(100)
-- Esto preserva los datos existentes automáticamente
ALTER TABLE `forms` 
MODIFY COLUMN `type` VARCHAR(100) NULL DEFAULT 'formulario' 
COMMENT 'Tipo de formulario';

-- Paso 3: Actualizar registros que tengan 'Visa' o 'Pasaporte' a 'formulario' (opcional)
-- Descomenta si quieres limpiar los datos antiguos:
-- UPDATE `forms` SET `type` = 'formulario' WHERE `type` IN ('Visa', 'Pasaporte');

-- Paso 4: Verificar el cambio
SELECT 
    COLUMN_NAME,
    COLUMN_TYPE,
    IS_NULLABLE,
    COLUMN_DEFAULT
FROM INFORMATION_SCHEMA.COLUMNS 
WHERE TABLE_SCHEMA = 'landscap_testing' 
  AND TABLE_NAME = 'forms' 
  AND COLUMN_NAME = 'type';

-- ============================================================
-- NOTAS:
-- - Si el campo tiene restricciones NOT NULL, MySQL las mantiene
-- - Los valores existentes se preservan automáticamente
-- - El cambio es instantáneo en tablas pequeñas
-- - Para tablas grandes (>1M filas), ejecutar en horario de bajo tráfico
-- ============================================================
