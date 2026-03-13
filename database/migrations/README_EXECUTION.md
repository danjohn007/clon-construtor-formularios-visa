# 🚀 Instrucciones de Ejecución - Migración de Formularios Públicos

## 📋 Archivos Disponibles

### 1. **001_MANUAL_EXECUTE.sql** (⚡ RECOMENDADO)
- **Propósito:** Ejecutar manualmente en phpMyAdmin
- **Ventajas:** 
  - Paso a paso con explicaciones
  - Incluye queries de verificación
  - Fácil de debuggear si algo falla
  
### 2. **001_add_public_forms_support.sql**
- **Propósito:** Migración automatizada completa
- **Cuándo usar:** Para ejecutar toda la migración de una sola vez

---

## ⚡ OPCIÓN 1: Ejecución Manual (RECOMENDADA)

### Paso 1: Abrir phpMyAdmin
1. Acceder a cPanel
2. Abrir phpMyAdmin
3. Seleccionar base de datos: `landscap_testing`

### Paso 2: Ejecutar el SQL Manual
1. Abrir el archivo: `database/migrations/001_MANUAL_EXECUTE.sql`
2. Copiar **TODO** el contenido
3. En phpMyAdmin:
   - Ir a la pestaña **SQL**
   - Pegar el código completo
   - Click en **"Go"** o **"Continuar"**

### Paso 3: Verificar los Resultados
Al final del script hay queries de verificación que mostrarán:
- ✅ Campos agregados en `applications`
- ✅ Campos agregados en `forms`
- ✅ Si los campos son nullable correctamente

---

## 🔧 OPCIÓN 2: Ejecución de Migración Completa

### Ejecutar 001_add_public_forms_support.sql
```sql
-- En phpMyAdmin, ejecutar todo el archivo:
database/migrations/001_add_public_forms_support.sql
```

---

## 📊 ¿Qué se Agrega?

### Tabla `applications`:
| Campo | Tipo | Descripción |
|-------|------|-------------|
| `applicant_name` | varchar(200) | Nombre del solicitante |
| `applicant_email` | varchar(100) | Email del solicitante |
| `applicant_phone` | varchar(20) | Teléfono del solicitante |
| `preferred_contact` | enum | 'Text' o 'Email' |
| `is_public_submission` | tinyint(1) | 1=público, 0=admin |
| **`created_by`** | int(11) **NULL** | ⚠️ Ahora permite NULL |

### Tabla `forms`:
| Campo | Tipo | Descripción |
|-------|------|-------------|
| `allow_public_submissions` | tinyint(1) | Permitir acceso público |
| `public_url_slug` | varchar(100) | URL amigable (único) |
| `success_message` | text | Mensaje al enviar |
| `notification_email` | varchar(255) | Email para notificar |
| `custom_css` | text | CSS personalizado |
| `embed_enabled` | tinyint(1) | Permitir iframe embed |

### Tabla `documents`:
| Campo | Cambio | Descripción |
|-------|--------|-------------|
| **`uploaded_by`** | **NOW NULL** | ⚠️ Permite uploads públicos |

---

## ✅ Verificación Post-Ejecución

### Verificar que todo funcionó:
```sql
-- En phpMyAdmin, ejecutar:

-- 1. Verificar campos en applications
SHOW COLUMNS FROM applications LIKE 'applicant_%';
SHOW COLUMNS FROM applications LIKE 'is_public_submission';

-- 2. Verificar campos en forms
SHOW COLUMNS FROM forms LIKE 'allow_public%';
SHOW COLUMNS FROM forms LIKE 'embed_enabled';

-- 3. Verificar que created_by es nullable
SELECT IS_NULLABLE 
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'applications' 
  AND COLUMN_NAME = 'created_by'
  AND TABLE_SCHEMA = 'landscap_testing';
-- Debe retornar: YES

-- 4. Verificar usuario sistema creado
SELECT * FROM users WHERE username = 'sistema_publico';
```

---

## ❌ Si Algo Sale Mal

### Error: "Duplicate column name"
**Causa:** El campo ya existe  
**Solución:** El campo ya está agregado, puedes ignorar ese error y continuar

### Error: "Can't DROP foreign key"
**Causa:** La foreign key tiene otro nombre  
**Solución:** 
```sql
-- Ver las foreign keys actuales
SHOW CREATE TABLE applications;

-- Eliminar la foreign key con el nombre correcto
ALTER TABLE applications DROP FOREIGN KEY nombre_real_de_la_fk;
```

### Error: "Column not found: appointment_date"
**Causa:** La tabla applications no tiene el campo appointment_date del schema.sql  
**Solución:** Ejecutar primero el schema.sql completo o agregar manualmente:
```sql
ALTER TABLE applications 
  ADD COLUMN appointment_date datetime DEFAULT NULL AFTER consular_payment_confirmed;
```

---

## 🔄 Rollback (Deshacer Cambios)

Si necesitas revertir todos los cambios:
```sql
-- Ejecutar el archivo de rollback:
database/migrations/rollback_public_forms.sql
```

---

## 📝 Siguientes Pasos Después de la Migración

1. ✅ **Crear PublicFormController.php**
   - Manejar envíos públicos sin autenticación
   
2. ✅ **Crear vistas públicas**
   - `app/views/public/form.php`
   - `app/views/public/form_success.php`
   
3. ✅ **Actualizar Router.php**
   - Agregar rutas: `/public/form/{id}`, `/public/form/{slug}`
   
4. ✅ **Aplicar estilos landscape**
   - Ejecutar: `002_landscape_theme_styles.sql`

---

## 📞 Contacto y Soporte

Si encuentras algún error durante la ejecución:
1. Copia el mensaje de error completo
2. Identifica en qué línea/sección falló
3. Verifica que la base de datos sea `landscap_testing`
4. Revisa que tengas permisos de ALTER TABLE

---

## 🎯 Resultado Final

Después de ejecutar la migración:
- ✅ Formularios pueden ser enviados sin login
- ✅ Sistema admin sigue funcionando normal
- ✅ Soporte para formularios embebidos (iframe)
- ✅ Tracking de envíos públicos
- ✅ CSS personalizable por formulario
- ✅ URLs amigables: `/public/form/visa-primera-vez`

---

**Última actualización:** 13-03-2026  
**MySQL Version:** 5.7.23-23  
**Database:** landscap_testing
