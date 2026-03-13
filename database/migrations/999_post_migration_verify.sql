-- Verificación Post-Migración
-- Ejecuta este script DESPUÉS de aplicar las migraciones 001 y 002

USE `landscap_testing`;

SET @results = '';

-- ============================================================================
-- 1. VERIFICAR TABLA PUBLIC_FORM_SUBMISSIONS
-- ============================================================================
SELECT '1. Verificando tabla public_form_submissions...' as '';

SELECT 
    CASE 
        WHEN COUNT(*) = 1 THEN '✓ Tabla creada correctamente'
        ELSE '✗ ERROR: Tabla no existe'
    END as status
FROM INFORMATION_SCHEMA.TABLES 
WHERE TABLE_SCHEMA = DATABASE() 
AND TABLE_NAME = 'public_form_submissions';

-- Verificar estructura de la tabla
SELECT 
    COLUMN_NAME,
    DATA_TYPE,
    IS_NULLABLE,
    COLUMN_KEY,
    COLUMN_COMMENT
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = DATABASE()
AND TABLE_NAME = 'public_form_submissions'
ORDER BY ORDINAL_POSITION;

-- ============================================================================
-- 2. VERIFICAR NUEVAS COLUMNAS EN APPLICATIONS
-- ============================================================================
SELECT '' as '';
SELECT '2. Verificando columnas nuevas en applications...' as '';

SELECT 
    COLUMN_NAME,
    DATA_TYPE,
    IS_NULLABLE,
    COLUMN_DEFAULT
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = DATABASE()
AND TABLE_NAME = 'applications'
AND COLUMN_NAME IN ('applicant_name', 'applicant_email', 'applicant_phone', 'preferred_contact', 'is_public_submission', 'public_token')
ORDER BY ORDINAL_POSITION;

-- Verificar conteo
SELECT 
    CASE 
        WHEN COUNT(*) = 6 THEN '✓ Las 6 columnas fueron creadas'
        ELSE CONCAT('✗ ERROR: Solo ', COUNT(*), ' de 6 columnas creadas')
    END as status
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = DATABASE()
AND TABLE_NAME = 'applications'
AND COLUMN_NAME IN ('applicant_name', 'applicant_email', 'applicant_phone', 'preferred_contact', 'is_public_submission', 'public_token');

-- ============================================================================
-- 3. VERIFICAR ÍNDICES EN APPLICATIONS
-- ============================================================================
SELECT '' as '';
SELECT '3. Verificando índices en applications...' as '';

SELECT 
    INDEX_NAME,
    COLUMN_NAME,
    SEQ_IN_INDEX,
    NON_UNIQUE
FROM INFORMATION_SCHEMA.STATISTICS
WHERE TABLE_SCHEMA = DATABASE()
AND TABLE_NAME = 'applications'
AND INDEX_NAME IN ('idx_public_token', 'idx_is_public_submission', 'idx_applicant_email')
ORDER BY INDEX_NAME, SEQ_IN_INDEX;

-- Verificar conteo
SELECT 
    CASE 
        WHEN COUNT(DISTINCT INDEX_NAME) = 3 THEN '✓ Los 3 índices fueron creados'
        ELSE CONCAT('✗ ERROR: Solo ', COUNT(DISTINCT INDEX_NAME), ' de 3 índices creados')
    END as status
FROM INFORMATION_SCHEMA.STATISTICS
WHERE TABLE_SCHEMA = DATABASE()
AND TABLE_NAME = 'applications'
AND INDEX_NAME IN ('idx_public_token', 'idx_is_public_submission', 'idx_applicant_email');

-- ============================================================================
-- 4. VERIFICAR QUE CREATED_BY ES NULLABLE
-- ============================================================================
SELECT '' as '';
SELECT '4. Verificando que applications.created_by es nullable...' as '';

SELECT 
    IS_NULLABLE,
    CASE 
        WHEN IS_NULLABLE = 'YES' THEN '✓ created_by es nullable correctamente'
        ELSE '✗ ERROR: created_by sigue siendo NOT NULL'
    END as status
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = DATABASE()
AND TABLE_NAME = 'applications'
AND COLUMN_NAME = 'created_by';

-- ============================================================================
-- 5. VERIFICAR NUEVAS COLUMNAS EN FORMS
-- ============================================================================
SELECT '' as '';
SELECT '5. Verificando columnas nuevas en forms...' as '';

SELECT 
    COLUMN_NAME,
    DATA_TYPE,
    IS_NULLABLE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = DATABASE()
AND TABLE_NAME = 'forms'
AND COLUMN_NAME IN ('allow_public_submissions', 'public_url_slug', 'success_message', 'notification_email', 'custom_css', 'embed_enabled')
ORDER BY ORDINAL_POSITION;

-- Verificar conteo
SELECT 
    CASE 
        WHEN COUNT(*) = 6 THEN '✓ Las 6 columnas fueron creadas en forms'
        ELSE CONCAT('✗ ERROR: Solo ', COUNT(*), ' de 6 columnas creadas')
    END as status
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = DATABASE()
AND TABLE_NAME = 'forms'
AND COLUMN_NAME IN ('allow_public_submissions', 'public_url_slug', 'success_message', 'notification_email', 'custom_css', 'embed_enabled');

-- ============================================================================
-- 6. VERIFICAR SLUGS EN FORMULARIOS
-- ============================================================================
SELECT '' as '';
SELECT '6. Verificando que los formularios tienen slugs...' as '';

SELECT 
    id,
    name,
    public_url_slug,
    allow_public_submissions,
    embed_enabled,
    CASE 
        WHEN public_url_slug IS NOT NULL THEN '✓'
        ELSE '✗ Sin slug'
    END as slug_status
FROM forms
WHERE is_published = 1;

-- ============================================================================
-- 7. VERIFICAR CONFIGURACIONES LANDSCAPE
-- ============================================================================
SELECT '' as '';
SELECT '7. Verificando configuraciones de Landscape...' as '';

SELECT 
    config_key,
    LEFT(config_value, 50) as config_value_preview,
    config_type
FROM global_config
WHERE config_key LIKE '%landscape%'
OR config_key LIKE 'public_form%'
ORDER BY config_key;

-- Verificar conteo de configs
SELECT 
    CASE 
        WHEN COUNT(*) >= 14 THEN CONCAT('✓ ', COUNT(*), ' configuraciones creadas')
        ELSE CONCAT('⚠ Solo ', COUNT(*), ' configuraciones (esperadas: 14+)')
    END as status
FROM global_config
WHERE config_key LIKE '%landscape%'
OR config_key LIKE 'public_form%';

-- ============================================================================
-- 8. VERIFICAR USUARIO SISTEMA PÚBLICO
-- ============================================================================
SELECT '' as '';
SELECT '8. Verificando usuario sistema_publico...' as '';

SELECT 
    id,
    username,
    email,
    full_name,
    role,
    is_active,
    CASE 
        WHEN username = 'sistema_publico' THEN '✓ Usuario creado'
        ELSE '✗ Usuario no encontrado'
    END as status
FROM users
WHERE username = 'sistema_publico';

-- ============================================================================
-- 9. VERIFICAR FOREIGN KEYS
-- ============================================================================
SELECT '' as '';
SELECT '9. Verificando foreign keys actualizadas...' as '';

SELECT 
    CONSTRAINT_NAME,
    TABLE_NAME,
    COLUMN_NAME,
    REFERENCED_TABLE_NAME,
    REFERENCED_COLUMN_NAME,
    DELETE_RULE,
    UPDATE_RULE
FROM INFORMATION_SCHEMA.KEY_COLUMN_USAGE
WHERE TABLE_SCHEMA = DATABASE()
AND CONSTRAINT_NAME IN ('applications_ibfk_2', 'documents_ibfk_2', 'public_form_submissions_ibfk_1', 'public_form_submissions_ibfk_2')
ORDER BY TABLE_NAME, CONSTRAINT_NAME;

-- ============================================================================
-- 10. VERIFICAR QUE NO HAY ERRORES EN LOS DATOS EXISTENTES
-- ============================================================================
SELECT '' as '';
SELECT '10. Verificando integridad de datos existentes...' as '';

-- Contar solicitudes existentes
SELECT 
    COUNT(*) as total_applications,
    SUM(CASE WHEN is_public_submission = 1 THEN 1 ELSE 0 END) as public_submissions,
    SUM(CASE WHEN created_by IS NULL THEN 1 ELSE 0 END) as without_creator
FROM applications;

-- Contar formularios
SELECT 
    COUNT(*) as total_forms,
    SUM(CASE WHEN is_published = 1 THEN 1 ELSE 0 END) as published_forms,
    SUM(CASE WHEN allow_public_submissions = 1 THEN 1 ELSE 0 END) as public_enabled_forms
FROM forms;

-- ============================================================================
-- RESUMEN FINAL
-- ============================================================================
SELECT '' as '';
SELECT '============================================' as '';
SELECT 'RESUMEN DE VERIFICACIÓN POST-MIGRACIÓN' as '';
SELECT '============================================' as '';

SELECT 
    (SELECT COUNT(*) FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'public_form_submissions') as 'Tabla nueva creada',
    (SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'applications' AND COLUMN_NAME IN ('applicant_name', 'applicant_email', 'applicant_phone', 'preferred_contact', 'is_public_submission', 'public_token')) as 'Columnas en applications',
    (SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'forms' AND COLUMN_NAME IN ('allow_public_submissions', 'public_url_slug', 'success_message', 'notification_email', 'custom_css', 'embed_enabled')) as 'Columnas en forms',
    (SELECT COUNT(*) FROM global_config WHERE config_key LIKE '%landscape%' OR config_key LIKE 'public_form%') as 'Configuraciones landscape',
    (SELECT COUNT(*) FROM users WHERE username = 'sistema_publico') as 'Usuario sistema';

SELECT '' as '';
SELECT CASE 
    WHEN (SELECT COUNT(*) FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'public_form_submissions') = 1
    AND (SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'applications' AND COLUMN_NAME IN ('applicant_name', 'applicant_email', 'applicant_phone', 'preferred_contact', 'is_public_submission', 'public_token')) = 6
    AND (SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'forms' AND COLUMN_NAME IN ('allow_public_submissions', 'public_url_slug', 'success_message', 'notification_email', 'custom_css', 'embed_enabled')) = 6
    THEN '✅ MIGRACIONES APLICADAS CORRECTAMENTE'
    ELSE '❌ HAY ERRORES - REVISAR RESULTADOS ARRIBA'
END as resultado_final;

SELECT '' as '';
SELECT 'Siguiente paso: Crear PublicFormController.php y vistas públicas' as next_step;
