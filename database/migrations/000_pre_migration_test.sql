-- Test de Compatibilidad MySQL 5.7.23
-- Ejecuta este script ANTES de aplicar las migraciones para verificar compatibilidad

-- ============================================================================
-- 1. VERIFICAR VERSIÓN DE MYSQL
-- ============================================================================
SELECT 
    VERSION() as mysql_version,
    CASE 
        WHEN VERSION() LIKE '5.7%' THEN '✓ Compatible con scripts'
        WHEN VERSION() LIKE '8.%' THEN '✓ Compatible con scripts'
        ELSE '✗ Versión no probada'
    END as compatibility_status;

-- ============================================================================
-- 2. VERIFICAR PERMISOS DEL USUARIO
-- ============================================================================
SHOW GRANTS FOR CURRENT_USER;

-- ============================================================================
-- 3. VERIFICAR QUE LA BASE DE DATOS EXISTE
-- ============================================================================
SELECT 
    SCHEMA_NAME,
    DEFAULT_CHARACTER_SET_NAME,
    DEFAULT_COLLATION_NAME
FROM INFORMATION_SCHEMA.SCHEMATA 
WHERE SCHEMA_NAME = 'landscap_testing';

-- ============================================================================
-- 4. VERIFICAR TABLAS EXISTENTES QUE SERÁN MODIFICADAS
-- ============================================================================
SELECT 
    TABLE_NAME,
    ENGINE,
    TABLE_ROWS,
    CREATE_TIME
FROM INFORMATION_SCHEMA.TABLES 
WHERE TABLE_SCHEMA = 'landscap_testing'
AND TABLE_NAME IN ('users', 'forms', 'applications', 'documents', 'global_config')
ORDER BY TABLE_NAME;

-- ============================================================================
-- 5. VERIFICAR SOPORTE DE PREPARED STATEMENTS (Necesario para rollback)
-- ============================================================================
-- Esto debe ejecutarse sin error
PREPARE test_stmt FROM 'SELECT 1 as test';
EXECUTE test_stmt;
DEALLOCATE PREPARE test_stmt;
SELECT '✓ Prepared statements funcionando correctamente' as status;

-- ============================================================================
-- 6. VERIFICAR CHARSET UTF8MB4 (Requerido por las migraciones)
-- ============================================================================
SHOW VARIABLES LIKE 'character_set%';

-- ============================================================================
-- 7. VERIFICAR QUE NO EXISTEN CONFLICTOS DE NOMBRES
-- ============================================================================
-- Verificar que no existe la tabla public_form_submissions
SELECT 
    CASE 
        WHEN COUNT(*) = 0 THEN '✓ No hay conflicto - tabla no existe'
        ELSE '✗ ADVERTENCIA: Tabla public_form_submissions ya existe'
    END as public_submissions_check
FROM INFORMATION_SCHEMA.TABLES 
WHERE TABLE_SCHEMA = 'landscap_testing' 
AND TABLE_NAME = 'public_form_submissions';

-- Verificar que no existen las columnas que se van a agregar
SELECT 
    TABLE_NAME,
    COLUMN_NAME,
    '⚠ Ya existe - migración podría fallar' as warning
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = 'landscap_testing'
AND (
    (TABLE_NAME = 'applications' AND COLUMN_NAME IN ('applicant_name', 'applicant_email', 'applicant_phone', 'preferred_contact', 'is_public_submission', 'public_token'))
    OR
    (TABLE_NAME = 'forms' AND COLUMN_NAME IN ('allow_public_submissions', 'public_url_slug', 'success_message', 'notification_email', 'custom_css', 'embed_enabled'))
);

-- ============================================================================
-- 8. BACKUP RECOMENDADO
-- ============================================================================
SELECT 
    CONCAT(
        'mysqldump -u ', CURRENT_USER(), ' -p landscap_testing > backup_',
        DATE_FORMAT(NOW(), '%Y%m%d_%H%i%s'),
        '.sql'
    ) as recommended_backup_command;

-- ============================================================================
-- 9. RESUMEN DE COMPATIBILIDAD
-- ============================================================================
SELECT '============================================' as '';
SELECT 'RESUMEN DE PRE-VALIDACIÓN' as '';
SELECT '============================================' as '';
SELECT 
    VERSION() as 'Versión MySQL',
    DATABASE() as 'Base de Datos Actual',
    CURRENT_USER() as 'Usuario Conectado',
    NOW() as 'Fecha de Test';
SELECT '============================================' as '';
SELECT '✓ Pre-validación completada' as status;
SELECT 'Si no hay errores arriba, puedes proceder con las migraciones' as next_step;
