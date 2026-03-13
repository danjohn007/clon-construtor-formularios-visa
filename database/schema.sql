-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Servidor: localhost:3306
-- Tiempo de generación: 13-03-2026 a las 15:24:42
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
-- Base de datos: `recursos_visas`
--

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `applications`
--

CREATE TABLE `applications` (
  `id` int(11) NOT NULL,
  `folio` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'VISA-YYYY-NNNNNN',
  `form_id` int(11) DEFAULT NULL COMMENT 'NULL para tramites especializados como Visa Canadiense',
  `form_version` int(11) NOT NULL,
  `type` enum('Visa','Pasaporte') COLLATE utf8mb4_unicode_ci NOT NULL,
  `subtype` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `is_canadian_visa` tinyint(1) DEFAULT '0' COMMENT 'Flujo especializado Visa Canadiense',
  `canadian_tipo` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Visa Canadiense o ETA Canadiense',
  `canadian_modalidad` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Primera vez o Renovacion',
  `canadian_docs_uploaded_portal` tinyint(1) DEFAULT '0' COMMENT 'Documentos cargados en portal Canada',
  `canadian_application_number` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Numero de aplicacion canadiense (opcional)',
  `canadian_biometric_appointment_generated` tinyint(1) DEFAULT '0' COMMENT 'Cita para biometricos generada',
  `canadian_biometric_date` datetime DEFAULT NULL COMMENT 'Fecha y hora de biometricos',
  `canadian_biometric_location` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Lugar de la cita de biometricos',
  `canadian_client_attended_biometrics` tinyint(1) DEFAULT '0' COMMENT 'Cliente asistio a biometricos',
  `canadian_biometric_attended_date` date DEFAULT NULL COMMENT 'Fecha de asistencia a biometricos',
  `canadian_visa_result` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'aprobada o negada',
  `canadian_resolution_date` date DEFAULT NULL COMMENT 'Fecha de resolucion de la visa canadiense',
  `canadian_guide_number` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Numero de guia (si aplica)',
  `canadian_final_observations` text COLLATE utf8mb4_unicode_ci COMMENT 'Observaciones finales de la resolucion',
  `status` varchar(60) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'Nuevo' COMMENT 'Estados: Nuevo(gris), Listo para solicitud(rojo), En espera de pago consular(amarillo), Cita programada(azul), En espera de resultado(morado), Trámite cerrado(verde)',
  `data_json` longtext COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Datos del formulario en JSON',
  `form_link_id` int(11) DEFAULT NULL COMMENT 'ID del formulario enviado al cliente',
  `form_link_status` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'pendiente, enviado, completado',
  `form_link_sent_at` timestamp NULL DEFAULT NULL,
  `official_application_done` tinyint(1) DEFAULT '0',
  `consular_fee_sent` tinyint(1) DEFAULT '0',
  `consular_payment_confirmed` tinyint(1) DEFAULT '0',
  `appointment_date` datetime DEFAULT NULL,
  `office_appointment_date` datetime DEFAULT NULL COMMENT 'Fecha y hora de cita a oficinas para indicaciones previas a consulado/biométrica',
  `office_appointment_modality` enum('Zoom','Presencial') COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Modalidad de la cita a oficinas: Zoom o Presencial',
  `appointment_confirmation_file` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `client_attended` tinyint(1) DEFAULT '0',
  `client_attended_date` date DEFAULT NULL,
  `appointment_confirmed_day_before` tinyint(1) DEFAULT '0',
  `dhl_tracking` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `delivery_date` date DEFAULT NULL,
  `ds160_confirmation_number` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Número de confirmación DS-160 (opcional)',
  `client_name` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Nombre completo del solicitante para búsqueda rápida',
  `current_page` int(11) DEFAULT '1' COMMENT 'Current page if form has pagination',
  `progress_percentage` decimal(5,2) DEFAULT '0.00' COMMENT 'Completion percentage',
  `is_draft` tinyint(1) DEFAULT '0' COMMENT 'Is this a draft/incomplete submission',
  `last_saved_at` timestamp NULL DEFAULT NULL COMMENT 'Last auto-save timestamp',
  `created_by` int(11) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `appointment_reminder_sent` tinyint(1) DEFAULT '0' COMMENT 'Flag: email de recordatorio enviado para cita consular',
  `biometric_reminder_sent` tinyint(1) DEFAULT '0' COMMENT 'Flag: email de recordatorio enviado para cita biométrica (Canadiense)'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `application_notes`
--

CREATE TABLE `application_notes` (
  `id` int(11) NOT NULL,
  `application_id` int(11) NOT NULL,
  `note_text` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `is_important` tinyint(1) DEFAULT '0' COMMENT 'Marcar como importante',
  `created_by` int(11) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
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
-- Estructura de tabla para la tabla `customer_journey`
--

CREATE TABLE `customer_journey` (
  `id` int(11) NOT NULL,
  `application_id` int(11) NOT NULL,
  `touchpoint_type` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'email, call, meeting, status_change, payment, document_upload, etc',
  `touchpoint_title` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL,
  `touchpoint_description` text COLLATE utf8mb4_unicode_ci,
  `contact_method` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'email, phone, in-person, online',
  `user_id` int(11) DEFAULT NULL COMMENT 'User who performed the action',
  `metadata_json` text COLLATE utf8mb4_unicode_ci COMMENT 'Additional data in JSON format',
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
  `doc_type` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT 'adicional' COMMENT 'pasaporte_vigente, visa_anterior, ficha_pago_consular, adicional',
  `file_path` varchar(500) COLLATE utf8mb4_unicode_ci NOT NULL,
  `file_type` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `file_size` int(11) NOT NULL,
  `version` int(11) DEFAULT '1',
  `is_validated` tinyint(1) DEFAULT '0',
  `validation_comment` text COLLATE utf8mb4_unicode_ci,
  `uploaded_by` int(11) NOT NULL,
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


CREATE TABLE `forms` (
  `id` int(11) NOT NULL,
  `name` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` text COLLATE utf8mb4_unicode_ci,
  `type` enum('Visa','Pasaporte') COLLATE utf8mb4_unicode_ci NOT NULL,
  `subtype` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Primera vez, Renovación, etc',
  `version` int(11) DEFAULT '1',
  `is_published` tinyint(1) DEFAULT '0',

  `fields_json` longtext COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Estructura del formulario en JSON',

  `cost` decimal(10,2) DEFAULT '0.00',
  `paypal_enabled` tinyint(1) DEFAULT '0' COMMENT 'Enable PayPal payment for this form',

  `pagination_enabled` tinyint(1) DEFAULT '0' COMMENT 'Enable pagination/sections in form',
  `pages_json` longtext COLLATE utf8mb4_unicode_ci COMMENT 'Page structure in JSON format if pagination enabled',

  `public_token` varchar(64) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Unique token for public form access',
  `public_enabled` tinyint(1) DEFAULT '0' COMMENT 'Allow public access to this form',

  `allow_public_submissions` tinyint(1) DEFAULT 0 COMMENT 'Permitir envíos públicos sin autenticación',
  `public_url_slug` varchar(150) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Slug único para URL pública del formulario',
  `success_message` text COLLATE utf8mb4_unicode_ci COMMENT 'Mensaje personalizado al enviar el formulario',
  `notification_email` varchar(150) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Email para notificar nuevas solicitudes públicas',
  `custom_css` longtext COLLATE utf8mb4_unicode_ci COMMENT 'CSS personalizado para el formulario público',
  `embed_enabled` tinyint(1) DEFAULT 0 COMMENT 'Permitir embeber en otros sitios',

  `created_by` int(11) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP

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
-- Estructura de tabla para la tabla `information_sheets`
--

CREATE TABLE `information_sheets` (
  `id` int(11) NOT NULL,
  `application_id` int(11) NOT NULL,
  `entry_date` date NOT NULL COMMENT 'Fecha de ingreso',
  `residence_place` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Ciudad, Estado, País',
  `address` text COLLATE utf8mb4_unicode_ci,
  `client_email` varchar(150) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `embassy_email` varchar(150) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `amount_paid` decimal(10,2) DEFAULT NULL,
  `observations` text COLLATE utf8mb4_unicode_ci,
  `created_by` int(11) NOT NULL,
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
  `form_id` int(11) NOT NULL,
  `application_id` int(11) DEFAULT NULL COMMENT 'Linked application if converted',
  `submission_data` longtext COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Form data in JSON',
  `progress_percentage` decimal(5,2) DEFAULT '0.00',
  `current_page` int(11) DEFAULT '1',
  `is_completed` tinyint(1) DEFAULT '0',
  `ip_address` varchar(45) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `user_agent` text COLLATE utf8mb4_unicode_ci,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
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
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `applications`
--
ALTER TABLE `applications`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `folio` (`folio`),
  ADD KEY `form_id` (`form_id`),
  ADD KEY `created_by` (`created_by`),
  ADD KEY `status` (`status`),
  ADD KEY `idx_applications_created_by_status` (`created_by`,`status`),
  ADD KEY `idx_applications_created_at` (`created_at`);

--
-- Indices de la tabla `application_notes`
--
ALTER TABLE `application_notes`
  ADD PRIMARY KEY (`id`),
  ADD KEY `application_id` (`application_id`),
  ADD KEY `created_by` (`created_by`),
  ADD KEY `created_at` (`created_at`);

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
-- Indices de la tabla `customer_journey`
--
ALTER TABLE `customer_journey`
  ADD PRIMARY KEY (`id`),
  ADD KEY `application_id` (`application_id`),
  ADD KEY `user_id` (`user_id`),
  ADD KEY `touchpoint_type` (`touchpoint_type`),
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
  ADD UNIQUE KEY `idx_forms_public_token` (`public_token`),
  ADD KEY `created_by` (`created_by`);

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
-- Indices de la tabla `information_sheets`
--
ALTER TABLE `information_sheets`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `application_id` (`application_id`),
  ADD KEY `created_by` (`created_by`);

--
-- Indices de la tabla `notification_reads`
--
ALTER TABLE `notification_reads`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `unique_read` (`user_id`,`application_id`,`notification_type`),
  ADD KEY `user_id` (`user_id`),
  ADD KEY `application_id` (`application_id`);

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
  ADD KEY `form_id` (`form_id`),
  ADD KEY `application_id` (`application_id`),
  ADD KEY `is_completed` (`is_completed`);

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
-- AUTO_INCREMENT de la tabla `application_notes`
--
ALTER TABLE `application_notes`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `audit_trail`
--
ALTER TABLE `audit_trail`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `customer_journey`
--
ALTER TABLE `customer_journey`
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
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `hikvision_devices`
--
ALTER TABLE `hikvision_devices`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `information_sheets`
--
ALTER TABLE `information_sheets`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `notification_reads`
--
ALTER TABLE `notification_reads`
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
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `applications`
--
ALTER TABLE `applications`
  ADD CONSTRAINT `applications_ibfk_1` FOREIGN KEY (`form_id`) REFERENCES `forms` (`id`),
  ADD CONSTRAINT `applications_ibfk_2` FOREIGN KEY (`created_by`) REFERENCES `users` (`id`);

--
-- Filtros para la tabla `application_notes`
--
ALTER TABLE `application_notes`
  ADD CONSTRAINT `application_notes_ibfk_1` FOREIGN KEY (`application_id`) REFERENCES `applications` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `application_notes_ibfk_2` FOREIGN KEY (`created_by`) REFERENCES `users` (`id`);

--
-- Filtros para la tabla `audit_trail`
--
ALTER TABLE `audit_trail`
  ADD CONSTRAINT `audit_trail_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE SET NULL;

--
-- Filtros para la tabla `customer_journey`
--
ALTER TABLE `customer_journey`
  ADD CONSTRAINT `customer_journey_ibfk_1` FOREIGN KEY (`application_id`) REFERENCES `applications` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `customer_journey_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE SET NULL;

--
-- Filtros para la tabla `documents`
--
ALTER TABLE `documents`
  ADD CONSTRAINT `documents_ibfk_1` FOREIGN KEY (`application_id`) REFERENCES `applications` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `documents_ibfk_2` FOREIGN KEY (`uploaded_by`) REFERENCES `users` (`id`);

--
-- Filtros para la tabla `financial_costs`
--
ALTER TABLE `financial_costs`
  ADD CONSTRAINT `financial_costs_ibfk_1` FOREIGN KEY (`application_id`) REFERENCES `applications` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `financial_costs_ibfk_2` FOREIGN KEY (`created_by`) REFERENCES `users` (`id`);

--
-- Filtros para la tabla `financial_status`
--
ALTER TABLE `financial_status`
  ADD CONSTRAINT `financial_status_ibfk_1` FOREIGN KEY (`application_id`) REFERENCES `applications` (`id`) ON DELETE CASCADE;

--
-- Filtros para la tabla `forms`
--
ALTER TABLE `forms`
  ADD CONSTRAINT `forms_ibfk_1` FOREIGN KEY (`created_by`) REFERENCES `users` (`id`);

--
-- Filtros para la tabla `information_sheets`
--
ALTER TABLE `information_sheets`
  ADD CONSTRAINT `information_sheets_ibfk_1` FOREIGN KEY (`application_id`) REFERENCES `applications` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `information_sheets_ibfk_2` FOREIGN KEY (`created_by`) REFERENCES `users` (`id`);

--
-- Filtros para la tabla `notification_reads`
--
ALTER TABLE `notification_reads`
  ADD CONSTRAINT `notification_reads_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `notification_reads_ibfk_2` FOREIGN KEY (`application_id`) REFERENCES `applications` (`id`) ON DELETE CASCADE;

--
-- Filtros para la tabla `payments`
--
ALTER TABLE `payments`
  ADD CONSTRAINT `payments_ibfk_1` FOREIGN KEY (`application_id`) REFERENCES `applications` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `payments_ibfk_2` FOREIGN KEY (`registered_by`) REFERENCES `users` (`id`);

--
-- Filtros para la tabla `public_form_submissions`
--
ALTER TABLE `public_form_submissions`
  ADD CONSTRAINT `public_form_submissions_ibfk_1` FOREIGN KEY (`form_id`) REFERENCES `forms` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `public_form_submissions_ibfk_2` FOREIGN KEY (`application_id`) REFERENCES `applications` (`id`) ON DELETE SET NULL;

--
-- Filtros para la tabla `status_history`
--
ALTER TABLE `status_history`
  ADD CONSTRAINT `status_history_ibfk_1` FOREIGN KEY (`application_id`) REFERENCES `applications` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `status_history_ibfk_2` FOREIGN KEY (`changed_by`) REFERENCES `users` (`id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
