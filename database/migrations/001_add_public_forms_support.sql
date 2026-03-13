-- Migración 001: Soporte para Formularios Públicos
-- Fecha: 2026-03-13
-- Descripción: Agrega campos faltantes en applications y forms para soporte completo
--              de formularios públicos sin autenticación.
-- Base de datos: landscap_testing
-- MySQL: 5.7.23-23

USE `landscap_testing`;

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ============================================================================
-- 1. AGREGAR CAMPOS FALTANTES EN TABLA APPLICATIONS
-- ============================================================================

-- Agregar campos para información de contacto del solicitante público
ALTER TABLE `applications` 
  ADD COLUMN `applicant_name` varchar(200) DEFAULT NULL COMMENT 'Nombre del solicitante (formulario público)',
  ADD COLUMN `applicant_email` varchar(100) DEFAULT NULL COMMENT 'Email del solicitante (formulario público)',
  ADD COLUMN `applicant_phone` varchar(20) DEFAULT NULL COMMENT 'Teléfono del solicitante (formulario público)',
  ADD COLUMN `preferred_contact` enum('Text','Email') DEFAULT 'Email' COMMENT 'Método de contacto preferido',
  ADD COLUMN `is_public_submission` tinyint(1) DEFAULT 0 COMMENT '1=Enviado por formulario público, 0=Creado por usuario del sistema';

-- Agregar índices para campos públicos
ALTER TABLE `applications` 
  ADD INDEX `idx_is_public_submission` (`is_public_submission`),
  ADD INDEX `idx_applicant_email` (`applicant_email`);

-- ============================================================================
-- 2. HACER NULLABLE EL CAMPO created_by EN APPLICATIONS
-- ============================================================================

-- Eliminar foreign key actual
ALTER TABLE `applications` DROP FOREIGN KEY `applications_ibfk_2`;

-- Modificar columna para permitir NULL
ALTER TABLE `applications` 
  MODIFY COLUMN `created_by` int(11) DEFAULT NULL COMMENT 'Usuario del sistema que creó la solicitud (NULL para públicas)';

-- Recrear foreign key con ON DELETE SET NULL
ALTER TABLE `applications` 
  ADD CONSTRAINT `applications_ibfk_2` 
  FOREIGN KEY (`created_by`) REFERENCES `users` (`id`) 
  ON DELETE SET NULL;

-- ============================================================================
-- 3. AGREGAR CAMPOS A LA TABLA FORMS PARA CONFIGURACIÓN PÚBLICA
-- ============================================================================

ALTER TABLE `forms`
  ADD COLUMN `allow_public_submissions` tinyint(1) DEFAULT 0 COMMENT 'Permitir envíos públicos sin autenticación',
  ADD COLUMN `public_url_slug` varchar(100) DEFAULT NULL COMMENT 'Slug único para URL pública del formulario',
  ADD COLUMN `success_message` text COMMENT 'Mensaje personalizado al enviar el formulario',
  ADD COLUMN `notification_email` varchar(255) DEFAULT NULL COMMENT 'Email para notificar nuevas solicitudes públicas',
  ADD COLUMN `custom_css` text COMMENT 'CSS personalizado para el formulario público',
  ADD COLUMN `embed_enabled` tinyint(1) DEFAULT 1 COMMENT 'Permitir embeber en otros sitios';

-- Agregar índices
ALTER TABLE `forms`
  ADD UNIQUE KEY `idx_public_url_slug` (`public_url_slug`),
  ADD INDEX `idx_allow_public` (`allow_public_submissions`, `is_published`);

-- ============================================================================
-- 4. ACTUALIZAR TABLA DOCUMENTS PARA SOPORTAR UPLOADS PÚBLICOS
-- ============================================================================

-- Eliminar foreign key actual
ALTER TABLE `documents` DROP FOREIGN KEY `documents_ibfk_2`;

-- Hacer nullable el campo uploaded_by
ALTER TABLE `documents`
  MODIFY COLUMN `uploaded_by` int(11) DEFAULT NULL COMMENT 'Usuario que subió (NULL para públicos)';

-- Recrear foreign key
ALTER TABLE `documents` 
  ADD CONSTRAINT `documents_ibfk_2` 
  FOREIGN KEY (`uploaded_by`) REFERENCES `users` (`id`) 
  ON DELETE SET NULL;

-- ============================================================================
-- 5. CREAR USUARIO SISTEMA PARA SOLICITUDES PÚBLICAS (OPCIONAL)
-- ============================================================================

-- Crear usuario "Sistema Público" para tracking interno
INSERT IGNORE INTO `users` (`username`, `email`, `password`, `full_name`, `role`, `is_active`) 
VALUES ('sistema_publico', 'sistema@crmvisas.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'Sistema Público', 'Asesor', 0);

-- ============================================================================
-- 6. ACTUALIZAR FORMULARIOS EXISTENTES PARA PERMITIR ENVÍOS PÚBLICOS
-- ============================================================================

-- Habilitar envíos públicos en formularios existentes
UPDATE `forms` 
SET 
  `allow_public_submissions` = 1,
  `public_url_slug` = CONCAT('form-', `id`),
  `success_message` = 'Gracias por tu solicitud. Hemos recibido tu información y te contactaremos pronto.',
  `embed_enabled` = 1
WHERE `is_published` = 1;

SET FOREIGN_KEY_CHECKS = 1;

-- ============================================================================
-- NOTAS DE MIGRACIÓN
-- ============================================================================
-- 
-- CAMBIOS PRINCIPALES:
-- 1. applications.created_by ahora es nullable (permite solicitudes sin usuario)
-- 2. Nuevos campos en applications: applicant_name, applicant_email, applicant_phone, is_public_submission
-- 3. Nuevos campos en forms: allow_public_submissions, public_url_slug, success_message, custom_css, embed_enabled
-- 4. documents.uploaded_by ahora nullable (permite uploads públicos)
-- 5. Usuario "sistema_publico" creado para tracking interno
-- 
-- COMPATIBILIDAD:
-- ✓ Todas las solicitudes existentes mantienen su created_by
-- ✓ El sistema administrativo sigue funcionando igual
-- ✓ Solo los formularios marcados con allow_public_submissions=1 son públicos
-- ✓ Las tablas public_form_submissions y notification_reads ya existen en schema.sql
-- 
-- REQUISITOS PREVIOS:
-- ✓ MySQL 5.7.23-23
-- ✓ Base de datos: landscap_testing
-- ✓ Tablas existentes: users, applications, forms, documents
-- 
-- USO DESPUÉS DE LA MIGRACIÓN:
-- - Formularios públicos: /public/form/{slug} o /public/form/{id}
-- - Consulta de estatus: /public/status/{token}
-- - Para embeber: <iframe src="URL_FORMULARIO"></iframe>
-- 
-- ROLLBACK:
-- Para revertir, ejecutar: database/migrations/rollback_public_forms.sql
-- 


-- ============================================================================
-- NOTAS DE MIGRACIÓN
-- ============================================================================
-- 
-- CAMBIOS PRINCIPALES:
-- 1. applications.created_by ahora es nullable (permite solicitudes sin usuario)
-- 2. Nuevos campos en applications para datos del solicitante público
-- 3. Tabla public_form_submissions para tracking de envíos públicos
-- 4. Campos en forms para configuración de formularios públicos
-- 5. documents.uploaded_by ahora nullable
-- 
-- COMPATIBILIDAD:
-- ✓ Todas las solicitudes existentes mantienen su created_by
-- ✓ El sistema administrativo sigue funcionando igual
-- ✓ Solo los formularios marcados con allow_public_submissions=1 son públicos
-- 
-- USO:
-- - Formularios públicos: /public/form/{slug} o /public/form/{id}
-- - Consulta de estatus: /public/status/{token}
-- - Para embeber: <iframe src="URL_FORMULARIO"></iframe>
-- 
