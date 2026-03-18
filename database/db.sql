-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Servidor: localhost:3306
-- Tiempo de generación: 18-03-2026 a las 16:08:31
-- Versión del servidor: 5.7.23-23
-- Versión de PHP: 8.1.34

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de datos: `landscap_testing`
--

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `applications`
--

CREATE TABLE `applications` (
  `id` int(11) NOT NULL,
  `folio` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Folio único del envío',
  `form_id` int(11) DEFAULT NULL,
  `form_name` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Nombre del formulario (para búsquedas)',
  `status` varchar(60) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'nuevo' COMMENT 'nuevo, en_proceso, completado, cerrado',
  `applicant_name` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `applicant_email` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Email del solicitante',
  `applicant_phone` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Teléfono del solicitante',
  `is_public_submission` tinyint(1) DEFAULT '1' COMMENT '1=Formulario público, 0=Sistema interno',
  `form_data` json DEFAULT NULL,
  `attachments_json` text COLLATE utf8mb4_unicode_ci COMMENT 'Información de archivos adjuntos en JSON',
  `ip_address` varchar(45) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'IP desde donde se envió',
  `user_agent` text COLLATE utf8mb4_unicode_ci COMMENT 'Navegador usado',
  `source` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT 'web' COMMENT 'Fuente: web, api, sistema',
  `created_by` int(11) DEFAULT NULL COMMENT 'Usuario del sistema (NULL si es envío público)',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `audit_trail`
--

CREATE TABLE `audit_trail` (
  `id` int(11) NOT NULL,
  `user_id` int(11) DEFAULT NULL,
  `user_name` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `user_email` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `action` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'login, logout, create, update, delete, etc',
  `module` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'usuarios, solicitudes, formularios, etc',
  `description` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `ip_address` varchar(45) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `user_agent` text COLLATE utf8mb4_unicode_ci,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `documents`
--

CREATE TABLE `documents` (
  `id` int(11) NOT NULL,
  `application_id` int(11) NOT NULL,
  `name` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL,
  `file_path` varchar(500) COLLATE utf8mb4_unicode_ci NOT NULL,
  `file_type` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `file_size` int(11) NOT NULL,
  `version` int(11) DEFAULT '1',
  `is_validated` tinyint(1) DEFAULT '0',
  `validation_comment` text COLLATE utf8mb4_unicode_ci,
  `uploaded_by` int(11) DEFAULT NULL COMMENT 'Usuario que subió (NULL para públicos)',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `financial_costs`
--

CREATE TABLE `financial_costs` (
  `id` int(11) NOT NULL,
  `application_id` int(11) NOT NULL,
  `concept` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Honorarios, Derechos, Servicios adicionales',
  `amount` decimal(10,2) NOT NULL,
  `created_by` int(11) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `financial_status`
--

CREATE TABLE `financial_status` (
  `id` int(11) NOT NULL,
  `application_id` int(11) NOT NULL,
  `total_costs` decimal(10,2) DEFAULT '0.00',
  `total_paid` decimal(10,2) DEFAULT '0.00',
  `balance` decimal(10,2) DEFAULT '0.00',
  `status` enum('Pendiente','Parcial','Pagado') COLLATE utf8mb4_unicode_ci DEFAULT 'Pendiente',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `forms`
--

CREATE TABLE `forms` (
  `id` int(11) NOT NULL,
  `name` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` text COLLATE utf8mb4_unicode_ci,
  `type` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT 'formulario' COMMENT 'Tipo de formulario',
  `subtype` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Primera vez, Renovación, etc',
  `version` int(11) DEFAULT '1',
  `is_published` tinyint(1) DEFAULT '0',
  `published_to_production` tinyint(1) DEFAULT '0' COMMENT 'Si está publicado en el sitio principal (contact.php)',
  `fields_json` longtext COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Estructura del formulario en JSON',
  `created_by` int(11) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `allow_public_submissions` tinyint(1) DEFAULT '0' COMMENT 'Permitir envíos públicos sin autenticación',
  `public_url_slug` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Slug único para URL pública del formulario',
  `success_message` text COLLATE utf8mb4_unicode_ci COMMENT 'Mensaje personalizado al enviar el formulario',
  `notification_email` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Email para notificar nuevas solicitudes públicas',
  `custom_css` text COLLATE utf8mb4_unicode_ci COMMENT 'CSS personalizado para el formulario público',
  `embed_enabled` tinyint(1) DEFAULT '1' COMMENT 'Permitir embeber en otros sitios',
  `cost` decimal(10,2) DEFAULT '0.00',
  `paypal_enabled` tinyint(1) DEFAULT '0' COMMENT 'Enable PayPal payment for this form',
  `pagination_enabled` tinyint(1) DEFAULT '0' COMMENT 'Enable pagination/sections in form',
  `pages_json` longtext COLLATE utf8mb4_unicode_ci COMMENT 'Page structure in JSON format if pagination enabled',
  `public_token` varchar(64) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Unique token for public form access',
  `public_enabled` tinyint(1) DEFAULT '0' COMMENT 'Allow public access to this form'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `global_config`
--

CREATE TABLE `global_config` (
  `id` int(11) NOT NULL,
  `config_key` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `config_value` text COLLATE utf8mb4_unicode_ci,
  `config_type` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT 'text' COMMENT 'text, json, file',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `global_config`
--

INSERT INTO `global_config` (`id`, `config_key`, `config_value`, `config_type`, `updated_at`) VALUES
(1, 'site_name', 'Landscape in Austin', 'text', '2026-03-13 22:00:33'),
(2, 'site_logo', '', 'file', '2026-03-13 19:20:45'),
(3, 'email_from', '', 'text', '2026-03-17 20:49:00'),
(4, 'contact_phone', '', 'text', '2026-03-17 20:49:00'),
(5, 'contact_phone_2', '', 'text', '2026-03-17 20:49:00'),
(6, 'business_hours', '', 'text', '2026-03-17 20:49:00'),
(7, 'primary_color', '#1c2a3f', 'text', '2026-03-17 20:49:00'),
(8, 'secondary_color', '#dde0e9', 'text', '2026-03-17 20:49:00'),
(9, 'paypal_client_id', '', 'text', '2026-03-13 19:20:45'),
(10, 'paypal_secret', '', 'text', '2026-03-13 19:20:45'),
(11, 'qr_api_key', '', 'text', '2026-03-13 19:20:45'),
(12, 'qr_api_url', '', 'text', '2026-03-13 19:20:45'),
(13, 'smtp_user', '', 'text', '2026-03-17 20:49:00'),
(14, 'smtp_password', '', 'text', '2026-03-13 19:20:45'),
(15, 'smtp_host', '', 'text', '2026-03-17 20:49:00'),
(16, 'smtp_port', '587', 'text', '2026-03-13 19:20:45'),
(17, 'smtp_imap_port', '993', 'text', '2026-03-13 19:20:45'),
(18, 'smtp_pop3_port', '995', 'text', '2026-03-13 19:20:45'),
(19, 'public_form_primary_color', '#6FCF20', 'text', '2026-03-13 20:05:12'),
(20, 'public_form_secondary_color', '#000000', 'text', '2026-03-13 20:05:12'),
(21, 'public_form_text_color', '#37474F', 'text', '2026-03-13 20:05:12'),
(22, 'public_form_bg_color', '#F5F5F5', 'text', '2026-03-13 20:05:12'),
(23, 'public_form_font_family', 'system-ui, -apple-system, \"Segoe UI\", Roboto, sans-serif', 'text', '2026-03-13 20:05:12'),
(24, 'public_form_font_size', '16px', 'text', '2026-03-13 20:05:12'),
(25, 'landscape_site_name', 'Texas Sprinkler & Landscape', 'text', '2026-03-13 20:05:12'),
(26, 'landscape_phone_main', '512.259.2771', 'text', '2026-03-13 20:05:12'),
(27, 'landscape_phone_direct', '512.233.8827', 'text', '2026-03-13 20:05:12'),
(28, 'landscape_email', '1txlandscape@gmail.com', 'text', '2026-03-13 20:05:12'),
(29, 'landscape_consultation_text', 'SCHEDULE YOUR FREE CONSULTATION', 'text', '2026-03-13 20:05:12'),
(30, 'public_form_step_prefix', 'STEP', 'text', '2026-03-13 20:05:12'),
(31, 'public_form_continue_button', 'CONTINUE', 'text', '2026-03-13 20:05:12'),
(32, 'public_form_back_button', 'BACK', 'text', '2026-03-13 20:05:12'),
(33, 'public_form_submit_button', 'SUBMIT REQUEST', 'text', '2026-03-13 20:05:12');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `hikvision_devices`
--

CREATE TABLE `hikvision_devices` (
  `id` int(11) NOT NULL,
  `name` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `ip_address` varchar(45) COLLATE utf8mb4_unicode_ci NOT NULL,
  `port` int(11) DEFAULT '80',
  `username` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `password` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `model` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `location` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `is_active` tinyint(1) DEFAULT '1',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `notification_reads`
--

CREATE TABLE `notification_reads` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `application_id` int(11) NOT NULL,
  `notification_type` enum('appointment','biometric') COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'appointment = generic flow, biometric = Canadian visa flow',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `payments`
--

CREATE TABLE `payments` (
  `id` int(11) NOT NULL,
  `application_id` int(11) NOT NULL,
  `amount` decimal(10,2) NOT NULL,
  `payment_method` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Efectivo, Transferencia, Tarjeta, PayPal',
  `reference` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `notes` text COLLATE utf8mb4_unicode_ci,
  `registered_by` int(11) NOT NULL,
  `payment_date` date NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `public_form_submissions`
--

CREATE TABLE `public_form_submissions` (
  `id` int(11) NOT NULL,
  `application_id` int(11) NOT NULL,
  `form_id` int(11) NOT NULL,
  `submission_token` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Token único para seguimiento',
  `ip_address` varchar(45) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `user_agent` text COLLATE utf8mb4_unicode_ci,
  `submission_source` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'URL del sitio desde donde se envió',
  `notified` tinyint(1) DEFAULT '0' COMMENT 'Si se ha enviado email de confirmación',
  `last_viewed_at` timestamp NULL DEFAULT NULL COMMENT 'Última vez que consultaron su estatus',
  `view_count` int(11) DEFAULT '0' COMMENT 'Cuántas veces han visto su estatus',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `shelly_devices`
--

CREATE TABLE `shelly_devices` (
  `id` int(11) NOT NULL,
  `name` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `device_id` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `auth_key` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `device_type` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `location` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `is_active` tinyint(1) DEFAULT '1',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `status_history`
--

CREATE TABLE `status_history` (
  `id` int(11) NOT NULL,
  `application_id` int(11) NOT NULL,
  `previous_status` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `new_status` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `comment` text COLLATE utf8mb4_unicode_ci,
  `changed_by` int(11) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `users`
--

CREATE TABLE `users` (
  `id` int(11) NOT NULL,
  `username` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `email` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `password` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `full_name` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `role` enum('Administrador','Gerente','Asesor') COLLATE utf8mb4_unicode_ci NOT NULL,
  `phone` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `is_active` tinyint(1) DEFAULT '1',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `users`
--

INSERT INTO `users` (`id`, `username`, `email`, `password`, `full_name`, `role`, `phone`, `is_active`, `created_at`, `updated_at`) VALUES
(2, 'abel', 'abel@email.com', '$2a$10$dvOYZWrwCh/Z0WaiuEkLTuLBHf3U7Fs21Vb1THjJPLJj.sPdQjXnS', 'Abel Pintor', 'Administrador', '4141408134', 1, '2026-03-13 19:20:45', '2026-03-18 16:42:26'),
(5, 'sistema_publico', 'sistema@crmvisas.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'Sistema Público', 'Asesor', NULL, 0, '2026-03-13 20:04:49', '2026-03-13 20:04:49'),
(6, 'landscape', 'landscape@email.com', '$2a$10$C7eSYPNNvWbSAmDksCcDq.6gw2zqHe8x30t2DmNffSTH8VQmgdTia', 'Landscape in Austin', 'Administrador', '4425986318', 1, '2026-03-13 22:03:21', '2026-03-18 04:11:55'),
(7, 'landscape_admin', 'landscape_admin@email.com', '$2y$10$sYSfsY8jvVphcP/zibDMsei6EBqemdtz2CKuURIXVRLJY0e6UziPu', 'Landscape in Austin', 'Administrador', '', 1, '2026-03-18 20:17:10', '2026-03-18 20:57:29');

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `applications`
--
ALTER TABLE `applications`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_applications_form_id` (`form_id`),
  ADD KEY `idx_applications_status` (`status`),
  ADD KEY `idx_applications_created_at` (`created_at`),
  ADD KEY `idx_applications_email` (`applicant_email`),
  ADD KEY `idx_applications_public` (`is_public_submission`),
  ADD KEY `idx_applications_folio` (`folio`),
  ADD KEY `applications_ibfk_2` (`created_by`),
  ADD KEY `idx_form_id` (`form_id`);

--
-- Indices de la tabla `audit_trail`
--
ALTER TABLE `audit_trail`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_id` (`user_id`),
  ADD KEY `action` (`action`),
  ADD KEY `module` (`module`),
  ADD KEY `created_at` (`created_at`);

--
-- Indices de la tabla `documents`
--
ALTER TABLE `documents`
  ADD PRIMARY KEY (`id`),
  ADD KEY `application_id` (`application_id`),
  ADD KEY `uploaded_by` (`uploaded_by`);

--
-- Indices de la tabla `financial_costs`
--
ALTER TABLE `financial_costs`
  ADD PRIMARY KEY (`id`),
  ADD KEY `application_id` (`application_id`),
  ADD KEY `created_by` (`created_by`);

--
-- Indices de la tabla `financial_status`
--
ALTER TABLE `financial_status`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `application_id` (`application_id`);

--
-- Indices de la tabla `forms`
--
ALTER TABLE `forms`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `public_url_slug` (`public_url_slug`),
  ADD KEY `created_by` (`created_by`),
  ADD KEY `idx_allow_public` (`allow_public_submissions`,`is_published`);

--
-- Indices de la tabla `global_config`
--
ALTER TABLE `global_config`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `config_key` (`config_key`);

--
-- Indices de la tabla `hikvision_devices`
--
ALTER TABLE `hikvision_devices`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `payments`
--
ALTER TABLE `payments`
  ADD PRIMARY KEY (`id`),
  ADD KEY `application_id` (`application_id`),
  ADD KEY `registered_by` (`registered_by`),
  ADD KEY `idx_payments_payment_date` (`payment_date`);

--
-- Indices de la tabla `public_form_submissions`
--
ALTER TABLE `public_form_submissions`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `submission_token` (`submission_token`),
  ADD KEY `application_id` (`application_id`),
  ADD KEY `form_id` (`form_id`);

--
-- Indices de la tabla `shelly_devices`
--
ALTER TABLE `shelly_devices`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `device_id` (`device_id`);

--
-- Indices de la tabla `status_history`
--
ALTER TABLE `status_history`
  ADD PRIMARY KEY (`id`),
  ADD KEY `application_id` (`application_id`),
  ADD KEY `changed_by` (`changed_by`),
  ADD KEY `idx_status_history_created_at` (`created_at`);

--
-- Indices de la tabla `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `username` (`username`),
  ADD UNIQUE KEY `email` (`email`);

--
-- AUTO_INCREMENT de las tablas volcadas
--

--
-- AUTO_INCREMENT de la tabla `applications`
--
ALTER TABLE `applications`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `audit_trail`
--
ALTER TABLE `audit_trail`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `documents`
--
ALTER TABLE `documents`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `financial_costs`
--
ALTER TABLE `financial_costs`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `financial_status`
--
ALTER TABLE `financial_status`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `forms`
--
ALTER TABLE `forms`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `global_config`
--
ALTER TABLE `global_config`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=51;

--
-- AUTO_INCREMENT de la tabla `hikvision_devices`
--
ALTER TABLE `hikvision_devices`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `payments`
--
ALTER TABLE `payments`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `public_form_submissions`
--
ALTER TABLE `public_form_submissions`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `shelly_devices`
--
ALTER TABLE `shelly_devices`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `status_history`
--
ALTER TABLE `status_history`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `users`
--
ALTER TABLE `users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `applications`
--
ALTER TABLE `applications`
  ADD CONSTRAINT `applications_ibfk_2` FOREIGN KEY (`created_by`) REFERENCES `users` (`id`) ON DELETE SET NULL;

--
-- Filtros para la tabla `audit_trail`
--
ALTER TABLE `audit_trail`
  ADD CONSTRAINT `audit_trail_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE SET NULL;

--
-- Filtros para la tabla `documents`
--
ALTER TABLE `documents`
  ADD CONSTRAINT `documents_ibfk_2` FOREIGN KEY (`uploaded_by`) REFERENCES `users` (`id`) ON DELETE SET NULL;

--
-- Filtros para la tabla `financial_costs`
--
ALTER TABLE `financial_costs`
  ADD CONSTRAINT `financial_costs_ibfk_2` FOREIGN KEY (`created_by`) REFERENCES `users` (`id`);

--
-- Filtros para la tabla `forms`
--
ALTER TABLE `forms`
  ADD CONSTRAINT `forms_ibfk_1` FOREIGN KEY (`created_by`) REFERENCES `users` (`id`);

--
-- Filtros para la tabla `payments`
--
ALTER TABLE `payments`
  ADD CONSTRAINT `payments_ibfk_2` FOREIGN KEY (`registered_by`) REFERENCES `users` (`id`);

--
-- Filtros para la tabla `public_form_submissions`
--
ALTER TABLE `public_form_submissions`
  ADD CONSTRAINT `public_form_submissions_ibfk_2` FOREIGN KEY (`form_id`) REFERENCES `forms` (`id`);

--
-- Filtros para la tabla `status_history`
--
ALTER TABLE `status_history`
  ADD CONSTRAINT `status_history_ibfk_2` FOREIGN KEY (`changed_by`) REFERENCES `users` (`id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
