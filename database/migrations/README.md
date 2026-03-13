# Migraciones de Base de Datos - Formularios Públicos

Este directorio contiene las migraciones SQL para habilitar el soporte de formularios públicos en el sistema CRM de Visas.

## � Compatibilidad

**MySQL 5.7.23** ✅ Totalmente compatible

Todas las migraciones han sido probadas y optimizadas para MySQL 5.7.23-23. El script de rollback utiliza prepared statements dinámicas para compatibilidad total con MySQL 5.7.x (ya que `DROP COLUMN IF EXISTS` solo está disponible desde MySQL 8.0.13).

## �📋 Índice de Migraciones
### 0. `000_pre_migration_test.sql` 🔍
**Propósito:** Script de pre-validación (ejecutar ANTES de las migraciones)

**Qué verifica:**
- ✅ Versión de MySQL
- ✅ Permisos del usuario
- ✅ Existencia de la base de datos
- ✅ Tablas que serán modificadas
- ✅ Soporte de prepared statements
- ✅ Charset UTF8MB4
- ✅ No hay conflictos de nombres
- ✅ Sugiere comando de backup

**Cuándo usarlo:** Antes de aplicar cualquier migración para asegurar que el entorno es compatible.

---
### 1. `001_add_public_forms_support.sql`
**Propósito:** Agregar soporte para formularios públicos sin autenticación

**Cambios principales:**
- ✅ Hace nullable el campo `created_by` en tabla `applications`
- ✅ Agrega campos de contacto del solicitante (`applicant_name`, `applicant_email`, `applicant_phone`)
- ✅ Agrega campo `is_public_submission` para diferenciar solicitudes públicas
- ✅ Agrega `public_token` para consultas de estatus sin login
- ✅ Crea tabla `public_form_submissions` para tracking
- ✅ Agrega campos de configuración en tabla `forms`:
  - `allow_public_submissions` - Permitir envíos públicos
  - `public_url_slug` - URL amigable del formulario
  - `success_message` - Mensaje personalizado al enviar
  - `notification_email` - Email para notificaciones
  - `custom_css` - Estilos personalizados
  - `embed_enabled` - Permitir iframe embeds
- ✅ Crea usuario "Sistema Público" para tracking interno

**Compatibilidad:**
- ✅ **100% compatible** con el sistema existente
- ✅ Las solicitudes existentes mantienen su `created_by`
- ✅ El sistema administrativo sigue funcionando igual
- ✅ Solo formularios con `allow_public_submissions=1` son públicos

---

### 2. `002_landscape_theme_styles.sql`
**Propósito:** Aplicar estilos y configuración del tema Texas Sprinkler & Landscape

**Cambios principales:**
- ✅ Agrega configuraciones globales para colores landscape:
  - Verde principal: `#6FCF20`
  - Negro para panel de contacto: `#000000`
  - Gris para textos: `#37474F`
- ✅ Inserta CSS completo para formularios públicos
- ✅ Configura información de contacto de landscape
- ✅ Establece mensajes predeterminados en inglés

**Estilos incluidos:**
- Panel izquierdo negro con información de contacto
- Panel derecho blanco con formulario
- Inputs redondeados con fondo gris claro
- Botones verdes brillantes con hover effects
- Diseño responsive (mobile-first)
- Checkboxes y radios estilizados
- Área de "Consultation Efficiency" destacada

---

### 3. `rollback_public_forms.sql`
**Propósito:** Revertir TODAS las migraciones de formularios públicos

⚠️ **ADVERTENCIA:** Este script revierte completamente los cambios. Usar solo si necesitas volver al estado original.

**Qué hace:**
- ❌ Elimina tabla `public_form_submissions`
- ❌ Elimina todos los campos agregados en `applications`, `forms`, `documents`
- ❌ Restaura constraints originales
- ❌ Elimina configuraciones de landscape
- ⚠️ Asigna usuario "sistema_publico" a solicitudes con `created_by` NULL antes de revertir

**Optimización:** Usa prepared statements dinámicas para compatibilidad con MySQL 5.7.23.

---

### 999. `999_post_migration_verify.sql` ✅
**Propósito:** Script de verificación post-migración (ejecutar DESPUÉS de las migraciones)

**Qué verifica:**
- ✅ Tabla `public_form_submissions` creada
- ✅ Columnas nuevas en `applications` (6 columnas)
- ✅ Índices en `applications` (3 índices)
- ✅ Campo `created_by` es nullable
- ✅ Columnas nuevas en `forms` (6 columnas)
- ✅ Formularios tienen slugs asignados
- ✅ Configuraciones landscape creadas (14+ registros)
- ✅ Usuario `sistema_publico` existe
- ✅ Foreign keys actualizadas
- ✅ Integridad de datos existentes

**Resultado:** Muestra un resumen final con ✅ o ❌ indicando si todo se aplicó correctamente.

---

### 📄 `MYSQL_57_COMPATIBILITY.md`
Documentación técnica sobre los cambios realizados para compatibilidad con MySQL 5.7.23. Incluye ejemplos de transformación de sintaxis y comandos de testing.

---

## 🚀 Cómo Aplicar las Migraciones

### ⚠️ IMPORTANTE: Antes de Empezar

1. **Hacer backup de la base de datos:**
```bash
mysqldump -u usuario -p landscap_testing > backup_$(date +%Y%m%d_%H%M%S).sql
```

2. **Ejecutar test de pre-validación:**
```bash
mysql -u usuario -p landscap_testing < 000_pre_migration_test.sql
```
Revisa los resultados y asegúrate de que no hay errores.

---

### Opción 1: phpMyAdmin (Recomendado para cPanel)

1. Accede a phpMyAdmin desde cPanel
2. Selecciona la base de datos `landscap_testing`
3. **Test previo:** Ve a SQL y pega `000_pre_migration_test.sql` → Ejecutar
4. Si todo está OK, ve a SQL y pega `001_add_public_forms_support.sql` → Ejecutar
5. Verifica que no haya errores
6. Ve a SQL y pega `002_landscape_theme_styles.sql` → Ejecutar
7. **Verificación:** Ve a SQL y pega `999_post_migration_verify.sql` → Ejecutar
8. Revisa el resumen final para confirmar que todo se aplicó correctamente

### Opción 2: Línea de comandos

```bash
# 1. Test previo
mysql -u usuario -p landscap_testing < 000_pre_migration_test.sql

# 2. Revisar resultados del test y si todo OK, continuar

# 3. Aplicar migración 001
mysql -u usuario -p landscap_testing < 001_add_public_forms_support.sql

# 4. Aplicar migración 002
mysql -u usuario -p landscap_testing < 002_landscape_theme_styles.sql

# 5. Verificar que todo se aplicó correctamente
mysql -u usuario -p landscap_testing < 999_post_migration_verify.sql
```

### Opción 3: Desde archivo PHP

```php
<?php
// aplicar_migraciones.php
require_once 'config/database.php';

$db = getDB();

try {
    // Test previo
    echo "=== Ejecutando test de pre-validación ===\n";
    $sql000 = file_get_contents(__DIR__ . '/database/migrations/000_pre_migration_test.sql');
    $db->exec($sql000);
    echo "Revisa los resultados arriba. Presiona ENTER para continuar o Ctrl+C para cancelar...\n";
    readline();
    
    // Leer y ejecutar migración 001
    echo "\n=== Aplicando migración 001 ===\n";
    $sql001 = file_get_contents(__DIR__ . '/database/migrations/001_add_public_forms_support.sql');
    $db->exec($sql001);
    echo "✓ Migración 001 aplicada\n";

    // Leer y ejecutar migración 002
    echo "\n=== Aplicando migración 002 ===\n";
    $sql002 = file_get_contents(__DIR__ . '/database/migrations/002_landscape_theme_styles.sql');
    $db->exec($sql002);
    echo "✓ Migración 002 aplicada\n";
    
    // Verificación post-migración
    echo "\n=== Ejecutando verificación post-migración ===\n";
    $sql999 = file_get_contents(__DIR__ . '/database/migrations/999_post_migration_verify.sql');
    $db->exec($sql999);

    echo "\n✅ Todas las migraciones aplicadas correctamente\n";
    echo "Revisa los resultados de verificación arriba\n";
    
} catch (PDOException $e) {
    echo "❌ Error: " . $e->getMessage() . "\n";
    echo "Revisa el error y considera hacer rollback si es necesario\n";
}
?>
```

---

## 🔍 Verificar que las Migraciones se Aplicaron Correctamente

### Opción Rápida: Script Automático

Ejecuta el script de verificación post-migración:

```bash
mysql -u usuario -p landscap_testing < 999_post_migration_verify.sql
```

Este script verifica automáticamente todos los componentes y muestra un resumen con ✅ o ❌.

### Opción Manual: Consultas Individuales

Si prefieres verificar manualmente, ejecuta estas consultas:

```sql
-- 1. Verificar que existe la tabla public_form_submissions
SHOW TABLES LIKE 'public_form_submissions';

-- 2. Verificar nuevos campos en applications
DESCRIBE applications;
-- Deberías ver: applicant_name, applicant_email, applicant_phone, 
--               preferred_contact, is_public_submission, public_token

-- 3. Verificar nuevos campos en forms
DESCRIBE forms;
-- Deberías ver: allow_public_submissions, public_url_slug, success_message,
--               notification_email, custom_css, embed_enabled

-- 4. Verificar configuraciones de landscape
SELECT * FROM global_config WHERE config_key LIKE '%landscape%';

-- 5. Verificar que formularios tienen slugs
SELECT id, name, public_url_slug, allow_public_submissions FROM forms;
```

---

## 📊 Impacto en Tablas Existentes

| Tabla | Cambios | Datos Afectados | Compatibilidad |
|-------|---------|-----------------|----------------|
| `applications` | +6 campos, modified `created_by` | Ninguno (nullable) | ✅ 100% |
| `forms` | +6 campos | Actualiza slugs | ✅ 100% |
| `documents` | modified `uploaded_by` | Ninguno (nullable) | ✅ 100% |
| `global_config` | +14 registros | Nuevas configs | ✅ 100% |
| `users` | +1 registro | Usuario sistema | ✅ 100% |
| *nuevo* `public_form_submissions` | Tabla nueva | N/A | ✅ N/A |

---

## 🔄 Cómo Revertir (Rollback)

Si necesitas deshacer todos los cambios:

```bash
mysql -u usuario -p landscap_testing < rollback_public_forms.sql
```

⚠️ **Antes de hacer rollback:**
1. Haz backup de la base de datos
2. Verifica que no haya solicitudes públicas importantes
3. Asegúrate de que no hay formularios embebidos en producción

---

## 🎯 Próximos Pasos

Después de aplicar las migraciones:

1. **Actualizar archivos PHP:**
   - Crear `PublicFormController.php` para manejar solicitudes públicas
   - Modificar `FormController.php` para incluir configuración de formularios públicos
   - Crear vistas para formularios públicos con estilos landscape

2. **Crear rutas públicas:**
   ```php
   // En Router.php
   '/public/form/:slug' => 'PublicFormController@show',
   '/public/form/:id' => 'PublicFormController@showById', 
   '/public/submit' => 'PublicFormController@submit',
   '/public/status/:token' => 'PublicFormController@status'
   ```

3. **Configurar formularios:**
   - Ir a Admin → Formularios
   - Editar formulario deseado
   - Marcar "Permitir envíos públicos"
   - Configurar slug, mensaje de éxito, etc.

4. **Embeber en landscape site:**
   ```html
   <iframe 
     src="https://tusitio.com/visas/public/form/custom-quote-form"
     width="100%" 
     height="1200px" 
     frameborder="0"
   ></iframe>
   ```

---

## 📝 Notas Importantes

### Seguridad
- Los formularios públicos NO requieren autenticación
- Implementar rate limiting para evitar spam
- Validar todos los inputs en el servidor
- Sanitizar archivos subidos
- Implementar CAPTCHA si es necesario

### Performance
- Los tokens públicos están indexados para búsqueda rápida
- Las consultas de estatus son eficientes
- Considera cache para formularios frecuentemente accedidos

### SEO
- Usar slugs descriptivos (`visa-americana-primera-vez`)
- Implementar meta tags apropiados
- Asegurar que la página sea crawler-friendly

---

## 🆘 Troubleshooting

### Error: "Unknown column 'applicant_name'"
**Solución:** La migración 001 no se aplicó correctamente. Vuelve a ejecutarla.

### Error: "Duplicate entry for key 'public_url_slug'"
**Solución:** Ya existe un formulario con ese slug. Ejecuta:
```sql
UPDATE forms SET public_url_slug = CONCAT('form-', id, '-', UNIX_TIMESTAMP());
```

### Los estilos no se aplican
**Solución:** Verifica que:
1. La migración 002 se ejecutó correctamente
2. El formulario tiene `custom_css` poblado
3. La vista pública incluye el CSS inline o lo carga desde `global_config`

### Error: SQL Syntax en rollback
**Solución:** Este rollback ha sido optimizado para MySQL 5.7.23. Si experimentas errores, verifica:
1. Que tu versión de MySQL sea 5.7.x o superior
2. Que el usuario tenga permisos para crear prepared statements
3. Que la base de datos permita variables de sesión

---

## 📞 Contacto

Para dudas sobre las migraciones o el sistema:
- Revisar documentación en `/README.md`
- Consultar logs de migración
- Verificar integridad de la base de datos

---

**Última actualización:** 13 de Marzo, 2026  
**Versión:** 1.0.0  
**Base de datos objetivo:** `landscap_testing`  
**MySQL compatible:** 5.7.23-23 ✅
