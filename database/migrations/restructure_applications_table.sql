-- =====================================================
-- MIGRACIÓN: Reestructuración de tabla applications
-- Fecha: 17 de marzo de 2026
-- Propósito: Convertir tabla de visas a tabla genérica de formularios
-- =====================================================

-- PASO 1: Crear backup de datos existentes
CREATE TABLE IF NOT EXISTS `applications_backup_20260317` LIKE `applications`;
INSERT INTO `applications_backup_20260317` SELECT * FROM `applications`;

-- PASO 2: Eliminar columnas específicas de visas que NO se usan
ALTER TABLE `applications`
  DROP COLUMN IF EXISTS `type`,
  DROP COLUMN IF EXISTS `subtype`,
  DROP COLUMN IF EXISTS `form_version`,
  DROP COLUMN IF EXISTS `is_canadian_visa`,
  DROP COLUMN IF EXISTS `canadian_tipo`,
  DROP COLUMN IF EXISTS `canadian_modalidad`,
  DROP COLUMN IF EXISTS `canadian_docs_uploaded_portal`,
  DROP COLUMN IF EXISTS `canadian_application_number`,
  DROP COLUMN IF EXISTS `canadian_biometric_appointment_generated`,
  DROP COLUMN IF EXISTS `canadian_biometric_date`,
  DROP COLUMN IF EXISTS `canadian_biometric_location`,
  DROP COLUMN IF EXISTS `canadian_client_attended_biometrics`,
  DROP COLUMN IF EXISTS `canadian_biometric_attended_date`,
  DROP COLUMN IF EXISTS `canadian_visa_result`,
  DROP COLUMN IF EXISTS `canadian_resolution_date`,
  DROP COLUMN IF EXISTS `canadian_guide_number`,
  DROP COLUMN IF EXISTS `canadian_final_observations`,
  DROP COLUMN IF EXISTS `form_link_id`,
  DROP COLUMN IF EXISTS `form_link_status`,
  DROP COLUMN IF EXISTS `form_link_sent_at`,
  DROP COLUMN IF EXISTS `official_application_done`,
  DROP COLUMN IF EXISTS `consular_fee_sent`,
  DROP COLUMN IF EXISTS `consular_payment_confirmed`,
  DROP COLUMN IF EXISTS `appointment_date`,
  DROP COLUMN IF EXISTS `office_appointment_date`,
  DROP COLUMN IF EXISTS `office_appointment_modality`,
  DROP COLUMN IF EXISTS `appointment_confirmation_file`,
  DROP COLUMN IF EXISTS `client_attended`,
  DROP COLUMN IF EXISTS `client_attended_date`,
  DROP COLUMN IF EXISTS `appointment_confirmed_day_before`,
  DROP COLUMN IF EXISTS `dhl_tracking`,
  DROP COLUMN IF EXISTS `delivery_date`,
  DROP COLUMN IF EXISTS `ds160_confirmation_number`,
  DROP COLUMN IF EXISTS `current_page`,
  DROP COLUMN IF EXISTS `progress_percentage`,
  DROP COLUMN IF EXISTS `is_draft`,
  DROP COLUMN IF EXISTS `last_saved_at`,
  DROP COLUMN IF EXISTS `appointment_reminder_sent`,
  DROP COLUMN IF EXISTS `biometric_reminder_sent`;

-- PASO 3: Modificar columnas existentes
ALTER TABLE `applications`
  MODIFY COLUMN `folio` VARCHAR(100) NOT NULL COMMENT 'Folio único del envío',
  MODIFY COLUMN `form_id` INT(11) NOT NULL COMMENT 'ID del formulario usado',
  MODIFY COLUMN `status` VARCHAR(60) NOT NULL DEFAULT 'nuevo' COMMENT 'nuevo, en_proceso, completado, cerrado',
  MODIFY COLUMN `client_name` VARCHAR(200) NULL COMMENT 'Nombre del solicitante (extraído de data_json)',
  MODIFY COLUMN `data_json` LONGTEXT NOT NULL COMMENT 'Datos del formulario en JSON',
  MODIFY COLUMN `created_by` INT(11) NULL COMMENT 'Usuario del sistema (NULL si es envío público)';

-- PASO 4: Agregar nuevas columnas necesarias
ALTER TABLE `applications`
  ADD COLUMN IF NOT EXISTS `form_name` VARCHAR(200) NULL COMMENT 'Nombre del formulario (para búsquedas)' AFTER `form_id`,
  ADD COLUMN IF NOT EXISTS `applicant_email` VARCHAR(200) NULL COMMENT 'Email del solicitante' AFTER `client_name`,
  ADD COLUMN IF NOT EXISTS `applicant_phone` VARCHAR(50) NULL COMMENT 'Teléfono del solicitante' AFTER `applicant_email`,
  ADD COLUMN IF NOT EXISTS `is_public_submission` TINYINT(1) DEFAULT 1 COMMENT '1=Formulario público, 0=Sistema interno' AFTER `applicant_phone`,
  ADD COLUMN IF NOT EXISTS `attachments_json` TEXT NULL COMMENT 'Información de archivos adjuntos en JSON' AFTER `data_json`,
  ADD COLUMN IF NOT EXISTS `ip_address` VARCHAR(45) NULL COMMENT 'IP desde donde se envió' AFTER `attachments_json`,
  ADD COLUMN IF NOT EXISTS `user_agent` TEXT NULL COMMENT 'Navegador usado' AFTER `ip_address`,
  ADD COLUMN IF NOT EXISTS `source` VARCHAR(50) DEFAULT 'web' COMMENT 'Fuente: web, api, sistema' AFTER `user_agent`;

-- PASO 5: Actualizar índices
ALTER TABLE `applications`
  DROP INDEX IF EXISTS `idx_applications_created_by_status`,
  DROP INDEX IF EXISTS `idx_applications_created_at`;

ALTER TABLE `applications`
  ADD INDEX `idx_applications_form_id` (`form_id`),
  ADD INDEX `idx_applications_status` (`status`),
  ADD INDEX `idx_applications_created_at` (`created_at`),
  ADD INDEX `idx_applications_email` (`applicant_email`),
  ADD INDEX `idx_applications_public` (`is_public_submission`),
  ADD INDEX `idx_applications_folio` (`folio`);

-- PASO 6: Actualizar foreign keys si existen
ALTER TABLE `applications`
  DROP FOREIGN KEY IF EXISTS `applications_ibfk_1`,
  DROP FOREIGN KEY IF EXISTS `applications_ibfk_2`;

ALTER TABLE `applications`
  ADD CONSTRAINT `applications_ibfk_1` 
    FOREIGN KEY (`form_id`) REFERENCES `forms` (`id`) ON DELETE RESTRICT,
  ADD CONSTRAINT `applications_ibfk_2` 
    FOREIGN KEY (`created_by`) REFERENCES `users` (`id`) ON DELETE SET NULL;

-- PASO 7: Actualizar datos existentes (si los hay)
-- Actualizar form_name desde forms
UPDATE `applications` a
INNER JOIN `forms` f ON a.form_id = f.id
SET a.form_name = f.name
WHERE a.form_name IS NULL;

-- Actualizar folio si es necesario (cambiar prefijo)
UPDATE `applications`
SET `folio` = REPLACE(`folio`, 'VISA-', 'FORM-')
WHERE `folio` LIKE 'VISA-%';

-- =====================================================
-- ROLLBACK (Si algo sale mal, ejecutar esto)
-- =====================================================
-- DROP TABLE IF EXISTS `applications`;
-- CREATE TABLE `applications` LIKE `applications_backup_20260317`;
-- INSERT INTO `applications` SELECT * FROM `applications_backup_20260317`;
-- =====================================================

-- PASO 8: Verificación
SELECT 
    COUNT(*) as total_registros,
    COUNT(DISTINCT form_id) as formularios_diferentes,
    COUNT(DISTINCT status) as estados_diferentes,
    MIN(created_at) as primer_registro,
    MAX(created_at) as ultimo_registro
FROM `applications`;

-- Ver estructura final
DESCRIBE `applications`;
