-- ============================================================================
-- FIX: Habilitar Acceso Público a Formularios
-- Ejecutar en: landscap_testing
-- Propósito: Agregar columnas necesarias para acceso público SIN TOKENS
-- ============================================================================

USE `landscap_testing`;

-- Agregar columna public_enabled si no existe
-- Esta columna determina si el formulario es accesible públicamente
-- Por defecto será 1 (público) para todos los formularios
ALTER TABLE `forms`
  ADD COLUMN IF NOT EXISTS `public_enabled` tinyint(1) DEFAULT 1 COMMENT 'Siempre público - sin restricciones';

-- Hacer que TODOS los formularios existentes sean públicos
UPDATE `forms` SET `public_enabled` = 1;

-- Verificar que se agregó correctamente
SELECT 
    COUNT(*) as total_forms,
    SUM(CASE WHEN public_enabled = 1 THEN 1 ELSE 0 END) as public_forms
FROM forms;

-- ============================================================================
-- ✅ RESULTADO ESPERADO:
-- Todos los formularios ahora son públicos por defecto
-- No se requieren tokens ni autenticación para acceder
-- ============================================================================
