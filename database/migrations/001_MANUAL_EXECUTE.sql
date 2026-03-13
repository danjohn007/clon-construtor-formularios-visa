-- ============================================================================
-- SQL MANUAL PARA AGREGAR CAMPOS FALTANTES
-- Ejecutar en phpMyAdmin en la base de datos: landscap_testing
-- MySQL 5.7.23-23
-- Fecha: 2026-03-13
-- ============================================================================

USE `landscap_testing`;

-- ============================================================================
-- PASO 1: AGREGAR CAMPOS FALTANTES EN APPLICATIONS
-- ============================================================================

-- Agregar campos para formularios públicos
ALTER TABLE `applications` 
  ADD COLUMN `applicant_name` varchar(200) DEFAULT NULL COMMENT 'Nombre del solicitante (formulario público)',
  ADD COLUMN `applicant_email` varchar(100) DEFAULT NULL COMMENT 'Email del solicitante (formulario público)',
  ADD COLUMN `applicant_phone` varchar(20) DEFAULT NULL COMMENT 'Teléfono del solicitante (formulario público)',
  ADD COLUMN `preferred_contact` enum('Text','Email') DEFAULT 'Email' COMMENT 'Método de contacto preferido',
  ADD COLUMN `is_public_submission` tinyint(1) DEFAULT 0 COMMENT '1=Enviado por formulario público';

-- Agregar índices
ALTER TABLE `applications` 
  ADD INDEX `idx_is_public_submission` (`is_public_submission`),
  ADD INDEX `idx_applicant_email` (`applicant_email`);

-- ============================================================================
-- PASO 2: HACER NULLABLE EL CAMPO created_by EN APPLICATIONS
-- ============================================================================

-- Primero eliminar la foreign key existente
ALTER TABLE `applications` DROP FOREIGN KEY `applications_ibfk_2`;

-- Modificar el campo para permitir NULL
ALTER TABLE `applications` 
  MODIFY COLUMN `created_by` int(11) DEFAULT NULL COMMENT 'Usuario del sistema (NULL para públicas)';

-- Recrear la foreign key con ON DELETE SET NULL
ALTER TABLE `applications` 
  ADD CONSTRAINT `applications_ibfk_2` 
  FOREIGN KEY (`created_by`) REFERENCES `users` (`id`) 
  ON DELETE SET NULL;

-- ============================================================================
-- PASO 3: AGREGAR CAMPOS EN TABLA FORMS
-- ============================================================================

ALTER TABLE `forms`
  ADD COLUMN `allow_public_submissions` tinyint(1) DEFAULT 0 COMMENT 'Permitir envíos públicos sin autenticación',
  ADD COLUMN `public_url_slug` varchar(100) DEFAULT NULL COMMENT 'Slug único para URL pública',
  ADD COLUMN `success_message` text COMMENT 'Mensaje al enviar formulario',
  ADD COLUMN `notification_email` varchar(255) DEFAULT NULL COMMENT 'Email para notificaciones',
  ADD COLUMN `custom_css` text COMMENT 'CSS personalizado',
  ADD COLUMN `embed_enabled` tinyint(1) DEFAULT 1 COMMENT 'Permitir embeber';

-- Agregar índices únicos
ALTER TABLE `forms`
  ADD UNIQUE KEY `idx_public_url_slug` (`public_url_slug`),
  ADD INDEX `idx_allow_public` (`allow_public_submissions`, `is_published`);

-- ============================================================================
-- PASO 4: ACTUALIZAR DOCUMENTS PARA SOPORTAR UPLOADS PÚBLICOS
-- ============================================================================

-- Eliminar foreign key existente
ALTER TABLE `documents` DROP FOREIGN KEY `documents_ibfk_2`;

-- Hacer nullable uploaded_by
ALTER TABLE `documents`
  MODIFY COLUMN `uploaded_by` int(11) DEFAULT NULL COMMENT 'Usuario que subió (NULL para públicos)';

-- Recrear foreign key  
ALTER TABLE `documents` 
  ADD CONSTRAINT `documents_ibfk_2` 
  FOREIGN KEY (`uploaded_by`) REFERENCES `users` (`id`) 
  ON DELETE SET NULL;

-- ============================================================================
-- PASO 5: CREAR USUARIO SISTEMA (OPCIONAL)
-- ============================================================================

INSERT IGNORE INTO `users` (`username`, `email`, `password`, `full_name`, `role`, `is_active`) 
VALUES ('sistema_publico', 'sistema@crmvisas.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'Sistema Público', 'Asesor', 0);

-- ============================================================================
-- PASO 6: ACTUALIZAR FORMULARIOS EXISTENTES (OPCIONAL)
-- ============================================================================

-- Habilitar envíos públicos en formularios publicados
UPDATE `forms` 
SET 
  `allow_public_submissions` = 1,
  `public_url_slug` = CONCAT('form-', `id`),
  `success_message` = 'Gracias por tu solicitud. Te contactaremos pronto.',
  `embed_enabled` = 1
WHERE `is_published` = 1;

-- ============================================================================
-- VERIFICACIÓN
-- ============================================================================

-- Verificar que los campos se agregaron correctamente
SELECT 
    COLUMN_NAME, 
    DATA_TYPE, 
    IS_NULLABLE,
    COLUMN_COMMENT
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = 'landscap_testing' 
  AND TABLE_NAME = 'applications'
  AND COLUMN_NAME IN ('applicant_name', 'applicant_email', 'applicant_phone', 'is_public_submission', 'created_by')
ORDER BY ORDINAL_POSITION;

-- Verificar campos en forms
SELECT 
    COLUMN_NAME, 
    DATA_TYPE, 
    IS_NULLABLE,
    COLUMN_COMMENT
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = 'landscap_testing' 
  AND TABLE_NAME = 'forms'
  AND COLUMN_NAME IN ('allow_public_submissions', 'public_url_slug', 'custom_css', 'embed_enabled')
ORDER BY ORDINAL_POSITION;

-- ============================================================================
-- ✅ LISTO! 
-- Si todas las queries se ejecutaron sin errores, el sistema está actualizado
-- ============================================================================
