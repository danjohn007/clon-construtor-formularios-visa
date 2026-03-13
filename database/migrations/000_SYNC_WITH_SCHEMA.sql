-- ============================================================================
-- SINCRONIZACIÓN COMPLETA CON SCHEMA.SQL
-- Este script agrega TODOS los campos que están en schema.sql 
-- pero que probablemente faltan en tu DB actual
-- Base de datos: landscap_testing
-- MySQL 5.7.23-23
-- ============================================================================


SET FOREIGN_KEY_CHECKS = 0;

-- ============================================================================
-- TABLA APPLICATIONS - CAMPOS COMPLETOS SEGÚN SCHEMA.SQL
-- ============================================================================

-- Estos son TODOS los campos que deberían existir en applications
-- Si alguno ya existe, MySQL dará error "Duplicate column" (puedes ignorarlo)

ALTER TABLE `applications`
  ADD COLUMN `appointment_date` datetime DEFAULT NULL COMMENT 'Fecha y hora de cita consular',
  ADD COLUMN `office_appointment_date` datetime DEFAULT NULL COMMENT 'Fecha y hora de cita a oficinas para indicaciones previas',
  ADD COLUMN `office_appointment_modality` enum('Zoom','Presencial') DEFAULT NULL COMMENT 'Modalidad de la cita a oficinas',
  ADD COLUMN `appointment_confirmation_file` varchar(500) DEFAULT NULL COMMENT 'Archivo de confirmación de cita',
  ADD COLUMN `client_attended` tinyint(1) DEFAULT 0 COMMENT 'Cliente asistió a la cita',
  ADD COLUMN `client_attended_date` date DEFAULT NULL COMMENT 'Fecha en que asistió',
  ADD COLUMN `appointment_confirmed_day_before` tinyint(1) DEFAULT 0 COMMENT 'Se confirmó cita un día antes',
  ADD COLUMN `dhl_tracking` varchar(100) DEFAULT NULL COMMENT 'Número de rastreo DHL',
  ADD COLUMN `delivery_date` date DEFAULT NULL COMMENT 'Fecha de entrega',
  ADD COLUMN `ds160_confirmation_number` varchar(100) DEFAULT NULL COMMENT 'Número de confirmación DS-160',
  ADD COLUMN `client_name` varchar(200) DEFAULT NULL COMMENT 'Nombre completo del solicitante para búsqueda rápida',
  ADD COLUMN `current_page` int(11) DEFAULT 1 COMMENT 'Página actual si el formulario tiene paginación',
  ADD COLUMN `progress_percentage` decimal(5,2) DEFAULT 0.00 COMMENT 'Porcentaje de completado',
  ADD COLUMN `is_draft` tinyint(1) DEFAULT 0 COMMENT 'Es borrador/incompleto',
  ADD COLUMN `last_saved_at` timestamp NULL DEFAULT NULL COMMENT 'Última vez que se guardó (auto-save)',
  ADD COLUMN `appointment_reminder_sent` tinyint(1) DEFAULT 0 COMMENT 'Email de recordatorio enviado (cita consular)',
  ADD COLUMN `biometric_reminder_sent` tinyint(1) DEFAULT 0 COMMENT 'Email de recordatorio enviado (cita biométrica)';

-- Campos de visa canadiense
ALTER TABLE `applications`
  ADD COLUMN `is_canadian_visa` tinyint(1) DEFAULT 0 COMMENT 'Flujo especializado Visa Canadiense',
  ADD COLUMN `canadian_tipo` varchar(50) DEFAULT NULL COMMENT 'Visa Canadiense o ETA Canadiense',
  ADD COLUMN `canadian_modalidad` varchar(50) DEFAULT NULL COMMENT 'Primera vez o Renovacion',
  ADD COLUMN `canadian_docs_uploaded_portal` tinyint(1) DEFAULT 0 COMMENT 'Documentos cargados en portal Canada',
  ADD COLUMN `canadian_application_number` varchar(100) DEFAULT NULL COMMENT 'Numero de aplicacion canadiense',
  ADD COLUMN `canadian_biometric_appointment_generated` tinyint(1) DEFAULT 0 COMMENT 'Cita para biometricos generada',
  ADD COLUMN `canadian_biometric_date` datetime DEFAULT NULL COMMENT 'Fecha y hora de biometricos',
  ADD COLUMN `canadian_biometric_location` varchar(200) DEFAULT NULL COMMENT 'Lugar de la cita de biometricos',
  ADD COLUMN `canadian_client_attended_biometrics` tinyint(1) DEFAULT 0 COMMENT 'Cliente asistio a biometricos',
  ADD COLUMN `canadian_biometric_attended_date` date DEFAULT NULL COMMENT 'Fecha de asistencia a biometricos',
  ADD COLUMN `canadian_visa_result` varchar(20) DEFAULT NULL COMMENT 'aprobada o negada',
  ADD COLUMN `canadian_resolution_date` date DEFAULT NULL COMMENT 'Fecha de resolucion de la visa canadiense',
  ADD COLUMN `canadian_guide_number` varchar(100) DEFAULT NULL COMMENT 'Numero de guia (si aplica)',
  ADD COLUMN `canadian_final_observations` text COMMENT 'Observaciones finales de la resolucion';

-- Campos para link de formulario enviado al cliente
ALTER TABLE `applications`
  ADD COLUMN `form_link_id` int(11) DEFAULT NULL COMMENT 'ID del formulario enviado al cliente',
  ADD COLUMN `form_link_status` varchar(20) DEFAULT NULL COMMENT 'pendiente, enviado, completado',
  ADD COLUMN `form_link_sent_at` timestamp NULL DEFAULT NULL COMMENT 'Cuándo se envió el link';

-- Flags de proceso
ALTER TABLE `applications`
  ADD COLUMN `official_application_done` tinyint(1) DEFAULT 0 COMMENT 'Solicitud oficial completada',
  ADD COLUMN `consular_fee_sent` tinyint(1) DEFAULT 0 COMMENT 'Pago consular enviado',
  ADD COLUMN `consular_payment_confirmed` tinyint(1) DEFAULT 0 COMMENT 'Pago consular confirmado';

-- Agregar índices importantes
ALTER TABLE `applications`
  ADD INDEX `idx_applications_created_by_status` (`created_by`, `status`),
  ADD INDEX `idx_applications_created_at` (`created_at`);

-- ============================================================================
-- TABLA FORMS - CAMPOS ADICIONALES DE PAGINACIÓN Y PAYPAL
-- ============================================================================

ALTER TABLE `forms`
  ADD COLUMN `cost` decimal(10,2) DEFAULT 0.00 COMMENT 'Costo del servicio/formulario',
  ADD COLUMN `paypal_enabled` tinyint(1) DEFAULT 0 COMMENT 'Habilitar pago por PayPal',
  ADD COLUMN `pagination_enabled` tinyint(1) DEFAULT 0 COMMENT 'Habilitar paginación/secciones',
  ADD COLUMN `pages_json` longtext COMMENT 'Estructura de páginas en JSON si pagination_enabled=1';

-- ============================================================================
-- TABLA APPLICATION_NOTES (si no existe)
-- ============================================================================

CREATE TABLE IF NOT EXISTS `application_notes` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `application_id` int(11) NOT NULL,
  `note_text` text NOT NULL,
  `is_important` tinyint(1) DEFAULT 0 COMMENT 'Marcar como importante',
  `created_by` int(11) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `application_id` (`application_id`),
  KEY `created_by` (`created_by`),
  KEY `created_at` (`created_at`),
  CONSTRAINT `application_notes_ibfk_1` FOREIGN KEY (`application_id`) REFERENCES `applications` (`id`) ON DELETE CASCADE,
  CONSTRAINT `application_notes_ibfk_2` FOREIGN KEY (`created_by`) REFERENCES `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================================================
-- TABLA CUSTOMER_JOURNEY (si no existe)
-- ============================================================================

CREATE TABLE IF NOT EXISTS `customer_journey` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `application_id` int(11) NOT NULL,
  `touchpoint_type` varchar(50) NOT NULL COMMENT 'email, call, meeting, status_change, payment, document_upload, etc',
  `touchpoint_title` varchar(200) NOT NULL,
  `touchpoint_description` text,
  `contact_method` varchar(50) DEFAULT NULL COMMENT 'email, phone, in-person, online',
  `user_id` int(11) DEFAULT NULL COMMENT 'User who performed the action',
  `metadata_json` text COMMENT 'Additional data in JSON format',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `application_id` (`application_id`),
  KEY `user_id` (`user_id`),
  KEY `touchpoint_type` (`touchpoint_type`),
  KEY `created_at` (`created_at`),
  CONSTRAINT `customer_journey_ibfk_1` FOREIGN KEY (`application_id`) REFERENCES `applications` (`id`) ON DELETE CASCADE,
  CONSTRAINT `customer_journey_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================================================
-- TABLA STATUS_HISTORY (si no existe)
-- ============================================================================

CREATE TABLE IF NOT EXISTS `status_history` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `application_id` int(11) NOT NULL,
  `previous_status` varchar(50) DEFAULT NULL,
  `new_status` varchar(50) NOT NULL,
  `comment` text,
  `changed_by` int(11) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `application_id` (`application_id`),
  KEY `changed_by` (`changed_by`),
  KEY `idx_status_history_created_at` (`created_at`),
  CONSTRAINT `status_history_ibfk_1` FOREIGN KEY (`application_id`) REFERENCES `applications` (`id`) ON DELETE CASCADE,
  CONSTRAINT `status_history_ibfk_2` FOREIGN KEY (`changed_by`) REFERENCES `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================================================
-- TABLA INFORMATION_SHEETS (si no existe)
-- ============================================================================

CREATE TABLE IF NOT EXISTS `information_sheets` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `application_id` int(11) NOT NULL,
  `entry_date` date NOT NULL COMMENT 'Fecha de ingreso',
  `residence_place` varchar(200) DEFAULT NULL COMMENT 'Ciudad, Estado, País',
  `address` text,
  `client_email` varchar(150) DEFAULT NULL,
  `embassy_email` varchar(150) DEFAULT NULL,
  `amount_paid` decimal(10,2) DEFAULT NULL,
  `observations` text,
  `created_by` int(11) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `application_id` (`application_id`),
  KEY `created_by` (`created_by`),
  CONSTRAINT `information_sheets_ibfk_1` FOREIGN KEY (`application_id`) REFERENCES `applications` (`id`) ON DELETE CASCADE,
  CONSTRAINT `information_sheets_ibfk_2` FOREIGN KEY (`created_by`) REFERENCES `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

SET FOREIGN_KEY_CHECKS = 1;

-- ============================================================================
-- VERIFICACIÓN COMPLETA
-- ============================================================================

SELECT 'VERIFICANDO COLUMNAS EN APPLICATIONS...' AS status;

SELECT 
    COLUMN_NAME, 
    COLUMN_TYPE,
    IS_NULLABLE,
    COLUMN_DEFAULT,
    COLUMN_COMMENT
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = 'landscap_testing' 
  AND TABLE_NAME = 'applications'
  AND COLUMN_NAME IN (
    'appointment_date', 
    'canadian_biometric_date',
    'applicant_name',
    'is_public_submission',
    'created_by'
  )
ORDER BY ORDINAL_POSITION;

SELECT 'VERIFICANDO COLUMNAS EN FORMS...' AS status;

SELECT 
    COLUMN_NAME, 
    COLUMN_TYPE,
    IS_NULLABLE,
    COLUMN_COMMENT
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = 'landscap_testing' 
  AND TABLE_NAME = 'forms'
  AND COLUMN_NAME IN (
    'cost',
    'pagination_enabled',
    'allow_public_submissions',
    'custom_css'
  )
ORDER BY ORDINAL_POSITION;

SELECT 'SINCRONIZACIÓN COMPLETA!' AS status;

-- ============================================================================
-- ✅ SI VES ESTE MENSAJE, LA SINCRONIZACIÓN FUE EXITOSA
-- ============================================================================
