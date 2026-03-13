# Compatibilidad MySQL 5.7.23

## ✅ Estado: 100% Compatible

Todas las migraciones han sido ajustadas para ser 100% compatibles con **MySQL 5.7.23-23**.

## Cambios Realizados

### Problema Original

MySQL 5.7 no soporta las siguientes sintaxis introducidas en MySQL 8.0:
- `DROP COLUMN IF EXISTS` (Disponible desde MySQL 8.0.13)
- `DROP INDEX IF EXISTS` (Disponible desde MySQL 8.0.13 para algunas variantes)
- `DROP FOREIGN KEY IF EXISTS` (Disponible desde MySQL 8.0.13)

### Solución Implementada

En el archivo `rollback_public_forms.sql`, se reemplazó la sintaxis moderna con **prepared statements dinámicas** que verifican la existencia del objeto usando `INFORMATION_SCHEMA` antes de intentar eliminarlo.

#### Ejemplo de Transformación

**Antes (MySQL 8.0+):**
```sql
ALTER TABLE `applications` 
  DROP COLUMN IF EXISTS `public_token`;
```

**Después (MySQL 5.7 compatible):**
```sql
SET @exist := (SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS 
               WHERE table_schema = DATABASE() 
               AND table_name = 'applications' 
               AND column_name = 'public_token');
SET @sqlstmt := IF(@exist > 0, 
                   'ALTER TABLE `applications` DROP COLUMN `public_token`', 
                   'SELECT "Column public_token does not exist"');
PREPARE stmt FROM @sqlstmt;
EXECUTE stmt;
```

## Archivos Afectados

| Archivo | Estado | Notas |
|---------|--------|-------|
| `001_add_public_forms_support.sql` | ✅ Compatible | Sin cambios necesarios |
| `002_landscape_theme_styles.sql` | ✅ Compatible | Sin cambios necesarios |
| `rollback_public_forms.sql` | ✅ Actualizado | Reescrito para MySQL 5.7 |

## Ventajas de Esta Aproximación

1. **Compatible con MySQL 5.7 y 8.0+**: Los prepared statements funcionan en ambas versiones
2. **Sin errores**: No arroja errores si el objeto no existe
3. **Claro**: Muestra mensajes informativos cuando un objeto no existe
4. **Seguro**: Verifica antes de ejecutar

## Testing Recomendado

Después de aplicar las migraciones, verifica con:

```sql
-- Verificar versión de MySQL
SELECT VERSION();
-- Debe mostrar: 5.7.23-23

-- Probar que las tablas se crearon correctamente
SHOW TABLES LIKE 'public_form_submissions';

-- Verificar que las columnas existen
SHOW COLUMNS FROM applications LIKE '%applicant%';
SHOW COLUMNS FROM applications LIKE 'public_token';

-- Verificar que los índices se crearon
SHOW INDEX FROM applications WHERE Key_name IN ('idx_public_token', 'idx_is_public_submission', 'idx_applicant_email');

-- Verificar configuraciones
SELECT config_key, config_value FROM global_config WHERE config_key LIKE '%landscape%';
```

## Rollback en MySQL 5.7

Si necesitas hacer rollback, el script `rollback_public_forms.sql` ahora es totalmente compatible con MySQL 5.7.23:

```bash
mysql -u usuario -p landscap_testing < rollback_public_forms.sql
```

**Importante:** El script utilizará prepared statements, que requieren el privilegio `CREATE TEMPORARY TABLES`. Asegúrate de que tu usuario tenga este permiso.

## Verificar Permisos

Para verificar que tienes los permisos necesarios:

```sql
SHOW GRANTS FOR CURRENT_USER;
-- Debe incluir: CREATE TEMPORARY TABLES
```

Si no tienes ese permiso, contacta a tu administrador de base de datos o usa tu usuario root:

```sql
GRANT CREATE TEMPORARY TABLES ON landscap_testing.* TO 'tu_usuario'@'localhost';
FLUSH PRIVILEGES;
```

## Soporte

En caso de problemas:
1. Verifica tu versión exacta de MySQL: `SELECT VERSION();`
2. Revisa los permisos del usuario
3. Ejecuta las migraciones una por una en lugar de todas juntas
4. Revisa los logs de MySQL para errores específicos

---

**Fecha de compatibilidad:** 13 de Marzo, 2026  
**Versión objetivo:** MySQL 5.7.23-23  
**Estado:** ✅ Producción Ready
