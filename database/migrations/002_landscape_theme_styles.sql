-- Migración 002: Configuración de Estilos para Formularios Landscape
-- Fecha: 2026-03-13
-- Descripción: Agrega estilos y configuración específica para el tema
--              de Texas Sprinkler & Landscape (verde, diseño moderno)

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ============================================================================
-- 1. CONFIGURACIÓN GLOBAL DE ESTILOS PARA FORMULARIOS PÚBLICOS
-- ============================================================================

INSERT INTO `global_config` (`config_key`, `config_value`, `config_type`) VALUES
-- Colores del tema Landscape (verde brillante)
('public_form_primary_color', '#6FCF20', 'text'),
('public_form_secondary_color', '#000000', 'text'),
('public_form_text_color', '#37474F', 'text'),
('public_form_bg_color', '#F5F5F5', 'text'),

-- Tipografía
('public_form_font_family', 'system-ui, -apple-system, "Segoe UI", Roboto, sans-serif', 'text'),
('public_form_font_size', '16px', 'text'),

-- Configuración de marca (Landscape)
('landscape_site_name', 'Texas Sprinkler & Landscape', 'text'),
('landscape_phone_main', '512.259.2771', 'text'),
('landscape_phone_direct', '512.233.8827', 'text'),
('landscape_email', '1txlandscape@gmail.com', 'text'),
('landscape_consultation_text', 'SCHEDULE YOUR FREE CONSULTATION', 'text'),

-- Mensajes predeterminados
('public_form_step_prefix', 'STEP', 'text'),
('public_form_continue_button', 'CONTINUE', 'text'),
('public_form_back_button', 'BACK', 'text'),
('public_form_submit_button', 'SUBMIT REQUEST', 'text')
ON DUPLICATE KEY UPDATE `config_value` = VALUES(`config_value`);

-- ============================================================================
-- 2. CSS PERSONALIZADO PARA FORMULARIOS LANDSCAPE
-- ============================================================================

UPDATE `forms` 
SET `custom_css` = '
/* Estilos Landscape - Verde Brillante Theme */
:root {
  --landscape-green: #6FCF20;
  --landscape-green-hover: #5BB818;
  --landscape-black: #000000;
  --landscape-gray: #37474F;
  --landscape-light-gray: #F5F5F5;
  --landscape-border: #E0E0E0;
}

body {
  font-family: system-ui, -apple-system, "Segoe UI", Roboto, sans-serif;
  background-color: var(--landscape-light-gray);
  color: var(--landscape-gray);
  line-height: 1.6;
  margin: 0;
  padding: 0;
}

.form-container {
  max-width: 1400px;
  margin: 0 auto;
  padding: 40px 20px;
  display: flex;
  gap: 40px;
  flex-wrap: wrap;
}

/* Panel Izquierdo - Info de Contacto */
.contact-panel {
  flex: 0 0 500px;
  background-color: var(--landscape-black);
  color: white;
  padding: 60px 40px;
  border-radius: 20px;
}

.contact-panel h1 {
  font-size: 48px;
  font-weight: 700;
  margin: 0 0 10px 0;
  color: white;
}

.contact-panel h1 .custom {
  color: var(--landscape-green);
  font-style: italic;
}

.contact-panel .underline {
  width: 100px;
  height: 4px;
  background-color: var(--landscape-green);
  margin: 20px 0 40px 0;
}

.contact-section {
  margin-bottom: 50px;
}

.contact-section-title {
  font-size: 12px;
  font-weight: 600;
  letter-spacing: 2px;
  color: var(--landscape-green);
  text-transform: uppercase;
  margin-bottom: 20px;
}

.phone-item {
  display: flex;
  align-items: center;
  gap: 20px;
  margin-bottom: 25px;
}

.phone-icon {
  width: 50px;
  height: 50px;
  background-color: rgba(111, 207, 32, 0.1);
  border: 2px solid var(--landscape-green);
  border-radius: 12px;
  display: flex;
  align-items: center;
  justify-content: center;
  color: var(--landscape-green);
  font-size: 24px;
}

.phone-number {
  font-size: 28px;
  font-weight: 600;
  color: white;
  text-decoration: none;
}

.phone-label {
  font-size: 12px;
  color: #999;
  text-transform: uppercase;
  letter-spacing: 1px;
  margin-top: 5px;
}

.email-link {
  color: white;
  font-size: 20px;
  text-decoration: none;
  display: inline-block;
  margin-left: 70px;
}

.email-link:hover {
  color: var(--landscape-green);
}

.consultation-box {
  background-color: rgba(111, 207, 32, 0.05);
  border: 2px solid rgba(111, 207, 32, 0.3);
  border-radius: 15px;
  padding: 30px;
  margin-top: 40px;
}

.consultation-box .icon {
  color: var(--landscape-green);
  font-size: 32px;
  margin-bottom: 15px;
}

.consultation-box h3 {
  font-size: 18px;
  font-weight: 700;
  color: white;
  margin: 0 0 10px 0;
}

.consultation-box p {
  font-size: 14px;
  color: #ccc;
  line-height: 1.7;
  margin: 0;
}

/* Panel Derecho - Formulario */
.form-panel {
  flex: 1 1 600px;
  background-color: white;
  padding: 60px;
  border-radius: 20px;
  box-shadow: 0 4px 20px rgba(0, 0, 0, 0.08);
}

.step-label {
  font-size: 12px;
  font-weight: 600;
  letter-spacing: 2px;
  color: var(--landscape-green);
  text-transform: uppercase;
  margin-bottom: 10px;
}

.form-title {
  font-size: 32px;
  font-weight: 700;
  color: var(--landscape-black);
  margin: 0 0 40px 0;
  text-transform: uppercase;
}

.form-row {
  display: flex;
  gap: 20px;
  margin-bottom: 30px;
}

.form-group {
  flex: 1;
}

.form-group.full-width {
  width: 100%;
}

.form-input {
  width: 100%;
  padding: 18px 20px;
  font-size: 16px;
  border: 2px solid var(--landscape-border);
  border-radius: 10px;
  background-color: var(--landscape-light-gray);
  transition: all 0.3s ease;
  font-family: inherit;
}

.form-input:focus {
  outline: none;
  border-color: var(--landscape-green);
  background-color: white;
}

.form-input::placeholder {
  color: #999;
}

.radio-group {
  display: flex;
  gap: 30px;
  align-items: center;
  margin-top: 10px;
}

.radio-label {
  display: flex;
  align-items: center;
  gap: 10px;
  cursor: pointer;
  font-size: 16px;
  color: var(--landscape-gray);
}

.radio-label input[type="radio"] {
  width: 20px;
  height: 20px;
  accent-color: var(--landscape-green);
  cursor: pointer;
}

.checkbox-group {
  display: grid;
  grid-template-columns: repeat(2, 1fr);
  gap: 20px;
  margin-top: 20px;
}

.checkbox-item {
  display: flex;
  align-items: center;
  gap: 15px;
  padding: 20px;
  border: 2px solid var(--landscape-border);
  border-radius: 10px;
  cursor: pointer;
  transition: all 0.3s ease;
}

.checkbox-item:hover {
  border-color: var(--landscape-green);
  background-color: rgba(111, 207, 32, 0.02);
}

.checkbox-item input[type="radio"],
.checkbox-item input[type="checkbox"] {
  width: 22px;
  height: 22px;
  accent-color: var(--landscape-green);
  cursor: pointer;
}

.checkbox-item label {
  font-size: 16px;
  font-weight: 500;
  color: var(--landscape-gray);
  cursor: pointer;
  text-transform: uppercase;
  letter-spacing: 0.5px;
}

.button-group {
  display: flex;
  gap: 20px;
  margin-top: 50px;
}

.btn {
  padding: 18px 40px;
  font-size: 16px;
  font-weight: 600;
  border: none;
  border-radius: 50px;
  cursor: pointer;
  transition: all 0.3s ease;
  text-transform: uppercase;
  letter-spacing: 1px;
  font-family: inherit;
}

.btn-primary {
  background-color: var(--landscape-green);
  color: white;
  flex: 1;
}

.btn-primary:hover {
  background-color: var(--landscape-green-hover);
  transform: translateY(-2px);
  box-shadow: 0 6px 20px rgba(111, 207, 32, 0.3);
}

.btn-secondary {
  background-color: var(--landscape-light-gray);
  color: var(--landscape-gray);
  padding: 18px 30px;
}

.btn-secondary:hover {
  background-color: #E0E0E0;
}

.file-upload-area {
  border: 3px dashed var(--landscape-border);
  border-radius: 10px;
  padding: 40px;
  text-align: center;
  cursor: pointer;
  transition: all 0.3s ease;
}

.file-upload-area:hover {
  border-color: var(--landscape-green);
  background-color: rgba(111, 207, 32, 0.02);
}

.file-upload-icon {
  font-size: 48px;
  color: var(--landscape-green);
  margin-bottom: 10px;
}

/* Área de texto */
textarea.form-input {
  min-height: 150px;
  resize: vertical;
}

/* Select personalizado */
select.form-input {
  cursor: pointer;
  appearance: none;
  background-image: url("data:image/svg+xml,%3Csvg xmlns=\'http://www.w3.org/2000/svg\' width=\'12\' height=\'6\'%3E%3Cpath d=\'M0 0l6 6 6-6z\' fill=\'%2337474F\'/%3E%3C/svg%3E");
  background-repeat: no-repeat;
  background-position: right 20px center;
  padding-right: 50px;
}

/* Responsive */
@media (max-width: 1024px) {
  .form-container {
    flex-direction: column;
  }
  
  .contact-panel {
    flex: 1 1 auto;
  }
  
  .checkbox-group {
    grid-template-columns: 1fr;
  }
}

@media (max-width: 640px) {
  .form-panel {
    padding: 30px 20px;
  }
  
  .contact-panel {
    padding: 40px 30px;
  }
  
  .form-row {
    flex-direction: column;
  }
  
  .radio-group {
    flex-direction: column;
    align-items: flex-start;
  }
}
'
WHERE `allow_public_submissions` = 1;

-- ============================================================================
-- 3. ACTUALIZAR MENSAJES DE ÉXITO PARA FORMULARIOS LANDSCAPE
-- ============================================================================

UPDATE `forms` 
SET `success_message` = 'Thank you for your request! We have received your information and will contact you soon to schedule your free consultation.'
WHERE `allow_public_submissions` = 1;

SET FOREIGN_KEY_CHECKS = 1;

-- ============================================================================
-- NOTAS DE CONFIGURACIÓN
-- ============================================================================
-- 
-- Colores aplicados:
-- - Verde principal: #6FCF20 (botones, acentos, iconos)
-- - Negro: #000000 (panel izquierdo)
-- - Gris: #37474F (textos)
-- - Gris claro: #F5F5F5 (fondos de inputs)
-- 
-- Componentes estilizados:
-- ✓ Panel de contacto oscuro con información
-- ✓ Formulario en panel blanco con inputs redondeados
-- ✓ Botones verdes con efecto hover
-- ✓ Checkboxes/radios estilizados
-- ✓ Diseño responsive
-- ✓ Área de consulta gratuita destacada
-- 
