-- ROLLBACK: Revertir Migraciones de Formularios Públicos
-- Fecha: 2026-03-13
-- Descripción: Este script revierte TODAS las migraciones relacionadas
--              con formularios públicos. Usar con precaución.
-- 
-- ADVERTENCIA: Este script eliminará:
--              - Todos los campos agregados para formularios públicos
--              - La tabla public_form_submissions
--              - Las configuraciones de estilos landscape
--              - NO eliminará las solicitudes existentes

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ============================================================================
-- 1. ELIMINAR TABLA DE SEGUIMIENTO PÚBLICO
-- ============================================================================

DROP TABLE IF EXISTS `public_form_submissions`;

-- ============================================================================
-- 2. REVERTIR CAMBIOS EN TABLA APPLICATIONS
-- ============================================================================

-- Eliminar índices agregados (MySQL 5.7 compatible)
SET @exist := (SELECT COUNT(*) FROM INFORMATION_SCHEMA.STATISTICS WHERE table_schema = DATABASE() AND table_name = 'applications' AND index_name = 'idx_public_token');
SET @sqlstmt := IF(@exist > 0, 'ALTER TABLE `applications` DROP INDEX `idx_public_token`', 'SELECT "Index idx_public_token does not exist"');
PREPARE stmt FROM @sqlstmt;
EXECUTE stmt;

SET @exist := (SELECT COUNT(*) FROM INFORMATION_SCHEMA.STATISTICS WHERE table_schema = DATABASE() AND table_name = 'applications' AND index_name = 'idx_is_public_submission');
SET @sqlstmt := IF(@exist > 0, 'ALTER TABLE `applications` DROP INDEX `idx_is_public_submission`', 'SELECT "Index idx_is_public_submission does not exist"');
PREPARE stmt FROM @sqlstmt;
EXECUTE stmt;

SET @exist := (SELECT COUNT(*) FROM INFORMATION_SCHEMA.STATISTICS WHERE table_schema = DATABASE() AND table_name = 'applications' AND index_name = 'idx_applicant_email');
SET @sqlstmt := IF(@exist > 0, 'ALTER TABLE `applications` DROP INDEX `idx_applicant_email`', 'SELECT "Index idx_applicant_email does not exist"');
PREPARE stmt FROM @sqlstmt;
EXECUTE stmt;

-- Eliminar columnas agregadas (MySQL 5.7 compatible)
SET @exist := (SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS WHERE table_schema = DATABASE() AND table_name = 'applications' AND column_name = 'public_token');
SET @sqlstmt := IF(@exist > 0, 'ALTER TABLE `applications` DROP COLUMN `public_token`', 'SELECT "Column public_token does not exist"');
PREPARE stmt FROM @sqlstmt;
EXECUTE stmt;

SET @exist := (SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS WHERE table_schema = DATABASE() AND table_name = 'applications' AND column_name = 'is_public_submission');
SET @sqlstmt := IF(@exist > 0, 'ALTER TABLE `applications` DROP COLUMN `is_public_submission`', 'SELECT "Column is_public_submission does not exist"');
PREPARE stmt FROM @sqlstmt;
EXECUTE stmt;

SET @exist := (SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS WHERE table_schema = DATABASE() AND table_name = 'applications' AND column_name = 'preferred_contact');
SET @sqlstmt := IF(@exist > 0, 'ALTER TABLE `applications` DROP COLUMN `preferred_contact`', 'SELECT "Column preferred_contact does not exist"');
PREPARE stmt FROM @sqlstmt;
EXECUTE stmt;

SET @exist := (SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS WHERE table_schema = DATABASE() AND table_name = 'applications' AND column_name = 'applicant_phone');
SET @sqlstmt := IF(@exist > 0, 'ALTER TABLE `applications` DROP COLUMN `applicant_phone`', 'SELECT "Column applicant_phone does not exist"');
PREPARE stmt FROM @sqlstmt;
EXECUTE stmt;

SET @exist := (SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS WHERE table_schema = DATABASE() AND table_name = 'applications' AND column_name = 'applicant_email');
SET @sqlstmt := IF(@exist > 0, 'ALTER TABLE `applications` DROP COLUMN `applicant_email`', 'SELECT "Column applicant_email does not exist"');
PREPARE stmt FROM @sqlstmt;
EXECUTE stmt;

SET @exist := (SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS WHERE table_schema = DATABASE() AND table_name = 'applications' AND column_name = 'applicant_name');
SET @sqlstmt := IF(@exist > 0, 'ALTER TABLE `applications` DROP COLUMN `applicant_name`', 'SELECT "Column applicant_name does not exist"');
PREPARE stmt FROM @sqlstmt;
EXECUTE stmt;

-- Restaurar created_by como NOT NULL (requiere valor por defecto)
-- NOTA: Si hay registros con created_by NULL, asignarlos al usuario sistema
UPDATE `applications` 
SET `created_by` = (SELECT `id` FROM `users` WHERE `username` = 'sistema_publico' LIMIT 1)
WHERE `created_by` IS NULL;

ALTER TABLE `applications` 
  MODIFY COLUMN `created_by` int(11) NOT NULL;

-- Restaurar constraint original
SET @exist := (SELECT COUNT(*) FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE table_schema = DATABASE() AND table_name = 'applications' AND constraint_name = 'applications_ibfk_2');
SET @sqlstmt := IF(@exist > 0, 'ALTER TABLE `applications` DROP FOREIGN KEY `applications_ibfk_2`', 'SELECT "FK applications_ibfk_2 does not exist"');
PREPARE stmt FROM @sqlstmt;
EXECUTE stmt;

ALTER TABLE `applications` 
  ADD CONSTRAINT `applications_ibfk_2` 
  FOREIGN KEY (`created_by`) REFERENCES `users` (`id`);

-- ============================================================================
-- 3. REVERTIR CAMBIOS EN TABLA FORMS
-- ============================================================================

-- Eliminar índices (MySQL 5.7 compatible)
SET @exist := (SELECT COUNT(*) FROM INFORMATION_SCHEMA.STATISTICS WHERE table_schema = DATABASE() AND table_name = 'forms' AND index_name = 'public_url_slug');
SET @sqlstmt := IF(@exist > 0, 'ALTER TABLE `forms` DROP INDEX `public_url_slug`', 'SELECT "Index public_url_slug does not exist"');
PREPARE stmt FROM @sqlstmt;
EXECUTE stmt;

SET @exist := (SELECT COUNT(*) FROM INFORMATION_SCHEMA.STATISTICS WHERE table_schema = DATABASE() AND table_name = 'forms' AND index_name = 'idx_allow_public');
SET @sqlstmt := IF(@exist > 0, 'ALTER TABLE `forms` DROP INDEX `idx_allow_public`', 'SELECT "Index idx_allow_public does not exist"');
PREPARE stmt FROM @sqlstmt;
EXECUTE stmt;

-- Eliminar columnas (MySQL 5.7 compatible)
SET @exist := (SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS WHERE table_schema = DATABASE() AND table_name = 'forms' AND column_name = 'embed_enabled');
SET @sqlstmt := IF(@exist > 0, 'ALTER TABLE `forms` DROP COLUMN `embed_enabled`', 'SELECT "Column embed_enabled does not exist"');
PREPARE stmt FROM @sqlstmt;
EXECUTE stmt;

SET @exist := (SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS WHERE table_schema = DATABASE() AND table_name = 'forms' AND column_name = 'custom_css');
SET @sqlstmt := IF(@exist > 0, 'ALTER TABLE `forms` DROP COLUMN `custom_css`', 'SELECT "Column custom_css does not exist"');
PREPARE stmt FROM @sqlstmt;
EXECUTE stmt;

SET @exist := (SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS WHERE table_schema = DATABASE() AND table_name = 'forms' AND column_name = 'notification_email');
SET @sqlstmt := IF(@exist > 0, 'ALTER TABLE `forms` DROP COLUMN `notification_email`', 'SELECT "Column notification_email does not exist"');
PREPARE stmt FROM @sqlstmt;
EXECUTE stmt;

SET @exist := (SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS WHERE table_schema = DATABASE() AND table_name = 'forms' AND column_name = 'success_message');
SET @sqlstmt := IF(@exist > 0, 'ALTER TABLE `forms` DROP COLUMN `success_message`', 'SELECT "Column success_message does not exist"');
PREPARE stmt FROM @sqlstmt;
EXECUTE stmt;

SET @exist := (SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS WHERE table_schema = DATABASE() AND table_name = 'forms' AND column_name = 'public_url_slug');
SET @sqlstmt := IF(@exist > 0, 'ALTER TABLE `forms` DROP COLUMN `public_url_slug`', 'SELECT "Column public_url_slug does not exist"');
PREPARE stmt FROM @sqlstmt;
EXECUTE stmt;

SET @exist := (SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS WHERE table_schema = DATABASE() AND table_name = 'forms' AND column_name = 'allow_public_submissions');
SET @sqlstmt := IF(@exist > 0, 'ALTER TABLE `forms` DROP COLUMN `allow_public_submissions`', 'SELECT "Column allow_public_submissions does not exist"');
PREPARE stmt FROM @sqlstmt;
EXECUTE stmt;

-- ============================================================================
-- 4. REVERTIR CAMBIOS EN TABLA DOCUMENTS
-- ============================================================================

-- Actualizar registros con uploaded_by NULL
UPDATE `documents` 
SET `uploaded_by` = (SELECT `id` FROM `users` WHERE `username` = 'sistema_publico' LIMIT 1)
WHERE `uploaded_by` IS NULL;

ALTER TABLE `documents`
  MODIFY COLUMN `uploaded_by` int(11) NOT NULL;

-- Restaurar constraint original (MySQL 5.7 compatible)
SET @exist := (SELECT COUNT(*) FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE table_schema = DATABASE() AND table_name = 'documents' AND constraint_name = 'documents_ibfk_2');
SET @sqlstmt := IF(@exist > 0, 'ALTER TABLE `documents` DROP FOREIGN KEY `documents_ibfk_2`', 'SELECT "FK documents_ibfk_2 does not exist"');
PREPARE stmt FROM @sqlstmt;
EXECUTE stmt;

ALTER TABLE `documents` 
  ADD CONSTRAINT `documents_ibfk_2` 
  FOREIGN KEY (`uploaded_by`) REFERENCES `users` (`id`);

-- ============================================================================
-- 5. ELIMINAR CONFIGURACIONES GLOBALES DE LANDSCAPE
-- ============================================================================

DELETE FROM `global_config` 
WHERE `config_key` IN (
  'public_form_primary_color',
  'public_form_secondary_color',
  'public_form_text_color',
  'public_form_bg_color',
  'public_form_font_family',
  'public_form_font_size',
  'landscape_site_name',
  'landscape_phone_main',
  'landscape_phone_direct',
  'landscape_email',
  'landscape_consultation_text',
  'public_form_step_prefix',
  'public_form_continue_button',
  'public_form_back_button',
  'public_form_submit_button'
);

-- ============================================================================
-- 6. ELIMINAR USUARIO SISTEMA (OPCIONAL)
-- ============================================================================

-- Descomentar si deseas eliminar el usuario sistema
-- DELETE FROM `users` WHERE `username` = 'sistema_publico';

SET FOREIGN_KEY_CHECKS = 1;

-- ============================================================================
-- ROLLBACK COMPLETADO
-- ============================================================================
-- 
-- Se han revertido todos los cambios de las migraciones:
-- ✓ Tabla public_form_submissions eliminada
-- ✓ Campos de applications restaurados
-- ✓ Campos de forms restaurados
-- ✓ Campos de documents restaurados
-- ✓ Configuraciones de landscape eliminadas
-- 
-- La base de datos ha vuelto al estado previo a las migraciones.
-- 
