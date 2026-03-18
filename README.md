# Constructor de Formularios Dinámicos

Sistema reutilizable de construcción y gestión de formularios dinámicos con interfaz visual drag & drop, lógica condicional entre campos, paginación, gestión de solicitudes, roles y módulo financiero.

Diseñado para integrarse con **cualquier sitio web** que necesite un formulario dinámico embebido.

> ### 📌 Dos vías de integración independientes
>
> El sistema ofrece **dos formas de usar un formulario**, ambas escriben a la misma tabla `applications` sin conflicto:
>
> | | Iframe embebible | Sitio principal (cURL) |
> |---|---|---|
> | **URL** | `/public/form/{id}?embed=1` | `get-published-form.php` API |
> | **Controlador** | `PublicFormController::submit()` | `send_quote.php` del sitio externo |
> | **Identifica form por** | `form_id` del URL | El único con `is_published = 1` |
> | **Independencia** | Cualquier formulario, sin importar si está "publicado" | Solo el formulario publicado |
>
> Cada submission genera su propio folio (`FORM-YYYY-NNNNNN`) y se inserta como registro independiente. **No se pisan ni se sobrescriben entre sí.** Puedes tener múltiples formularios recibiendo datos por iframe al mismo tiempo que el sitio principal recibe por su lado — todo diferenciado por `form_id`.

## 🚀 Características Principales

### ✨ Constructor de Formularios
- Interfaz visual drag & drop (tipo JotForm)
- Múltiples tipos de campos: texto, email, teléfono, número, fecha, selección (radio buttons), casilla, área de texto, archivo, encabezado
- **Lógica condicional (showWhen)**: muestra/oculta campos según el valor de un campo de selección
- **Paginación**: divide el formulario en secciones navegables
- **Agrupación automática por secciones**: los encabezados actúan como separadores — todos los campos condicionales entre dos encabezados se consolidan en la misma página
- Versionado automático de formularios
- Publicar/Despublicar formularios

### 📋 Gestión de Solicitudes
- Folios únicos automáticos (FORM-YYYY-NNNNNN)
- Seguimiento completo por estatus
- Historial detallado de cambios
- Archivos adjuntos con visualización y descarga
- Notas e indicaciones por solicitud

### 👥 Sistema de Roles y Permisos
- **Administrador**: Control total del sistema
- **Gerente**: Gestión operativa y financiera
- **Asesor**: Captura de nuevas solicitudes (sin acceso a finalizadas)

### 💰 Módulo Financiero
- Registro de costos por solicitud
- Control de pagos múltiples
- Estados financieros (Pendiente, Parcial, Pagado)

### 📊 Dashboard y Reportes
- Estadísticas en tiempo real
- Exportación a Excel, CSV, PDF

---

## 📋 Requisitos del Sistema

- **PHP**: 7.4 o superior
- **MySQL**: 5.7 o superior
- **Servidor Web**: Apache con mod_rewrite
- **cPanel** (recomendado) o cualquier hosting con PHP + MySQL
- **Extensiones PHP**: PDO, pdo_mysql, json, mbstring, openssl, curl

---

## 🛠️ Instalación y Despliegue

### Estructura esperada en el servidor

```
public_html/                    ← Raíz del dominio (sitio principal)
├── index.php                   ← Tu sitio web
├── contact.php                 ← Página que embebe el formulario
├── includes/
│   └── dynamic_form.php        ← Renderizador del formulario embebido
├── send_quote.php              ← Procesador de submissions
└── sistema/                    ← Constructor de formularios (este proyecto)
    ├── public/
    │   ├── index.php           ← Punto de entrada del constructor
    │   ├── api/
    │   │   └── get-published-form.php  ← API que sirve el formulario
    │   ├── js/
    │   │   └── form-builder.js
    │   └── uploads/
    ├── app/
    │   ├── controllers/
    │   ├── views/
    │   └── ...
    └── config/
        ├── config.php          ← Credenciales BD y configuración
        └── database.php        ← Conexión PDO
```

> **Importante**: El constructor vive en `/sistema/` dentro de la raíz del dominio. El sitio que consume el formulario vive en la raíz (`/public_html/`).

### Paso 1: Subir el constructor

1. Sube la carpeta completa del proyecto a `/public_html/sistema/`
2. El punto de entrada del constructor será: `https://tudominio.com/sistema/public/`

### Paso 2: Configurar la Base de Datos

1. Crea una base de datos MySQL desde cPanel
2. Importa `database/schema.sql`
3. Edita `/sistema/config/config.php`:

```php
define('DB_HOST', 'localhost');
define('DB_NAME', 'tu_base_de_datos');
define('DB_USER', 'tu_usuario');
define('DB_PASS', 'tu_contraseña');
```

### Paso 3: Permisos

```bash
chmod -R 755 sistema/public/uploads
```

### Paso 4: Acceder al constructor

```
https://tudominio.com/sistema/
```

---

## 🔌 Cómo embeber el formulario en tu sitio

El constructor expone una **API REST** que tu sitio consume para obtener la definición del formulario publicado.

### Mecanismo de integración

```
Tu sitio (raíz)                         Constructor (/sistema/)
─────────────────                       ─────────────────────────
contact.php                              
  └─ includes/dynamic_form.php          
       │                                
       ├── [GET] cURL ──────────────►  /sistema/public/api/get-published-form.php
       │       ◄──── JSON ──────────   (devuelve campos, páginas, paginación)
       │                                
       └── Renderiza HTML/JS            
           del formulario               
                                        
Usuario llena y envía                   
  └─ fetch('send_quote.php') ──►  send_quote.php
       │                            ├── Guarda en BD (misma del constructor)
       │                            ├── Envía email de confirmación
       │                            └── Retorna { success, folio }
```

### Qué cambiar en `dynamic_form.php` (tu sitio)

La URL de la API está en la línea ~12. Cámbiala a tu dominio:

```php
// ANTES (hardcodeado)
$apiUrl = 'https://landscapeinaustin.com/sistema/public/api/get-published-form.php';

// DESPUÉS (tu dominio)
$apiUrl = 'https://tudominio.com/sistema/public/api/get-published-form.php';
```

### Qué cambiar en `send_quote.php` (tu sitio)

Este archivo carga la configuración del constructor para guardar en la misma BD:

```php
// Línea ~17-18: Ruta al config del constructor
$configPath = __DIR__ . '/sistema/config/config.php';
$databasePath = __DIR__ . '/sistema/config/database.php';
```

> Si tu constructor está en otra ruta, ajusta estas líneas.

### Archivos necesarios en tu sitio (raíz)

| Archivo | Propósito |
|---------|-----------|
| `includes/dynamic_form.php` | Renderiza el formulario dinámico (cURL + HTML/JS) |
| `send_quote.php` | Procesa el envío: guarda en BD + envía email |

Estos dos archivos son los únicos que conectan tu sitio con el constructor.

---

## ⚠️ Consideraciones para el Constructor de Formularios

### Encabezado = Separador de sección
Los campos tipo **"Encabezado"** actúan como separadores de sección. Con paginación y campos condicionales, todos los campos debajo de un encabezado (con la misma condición `showWhen`) se agrupan automáticamente en la misma página. Cada nuevo encabezado inicia una sección distinta.

### Campos condicionales (showWhen)
Un campo condicional solo se muestra cuando otro campo de tipo "Selección" tiene un valor específico. Se configura con el botón de enlace (🔗) en cada campo.

### Paginación y agrupación automática
Al habilitar paginación, los campos condicionales de una misma sección se consolidan en una sola página, sin importar la asignación manual en `pages_json`. Esto evita que un grupo de campos quede disperso.

### Campo "Selección" se renderiza como radio buttons
En el formulario público, los campos de selección se muestran como radio buttons, no como dropdown.

### El orden importa
Los encabezados deben ir **antes** de los campos que pertenecen a su sección.

---

## 🎨 Tecnologías

- **Backend**: PHP puro (MVC, sin frameworks)
- **Base de Datos**: MySQL 5.7+
- **Frontend**: HTML5, Tailwind CSS, JavaScript vanilla
- **Iconos**: Font Awesome 6
- **Gráficas**: Chart.js

## 📁 Estructura del Proyecto

```
constructor-formularios/
├── app/
│   ├── controllers/        # Router, FormController, PublicFormController, etc.
│   └── views/
│       ├── forms/           # create.php, edit.php (constructor visual)
│       ├── applications/    # show.php (ver solicitudes)
│       ├── public/          # form.php (preview del formulario)
│       └── layouts/         # main.php (layout base)
├── config/
│   ├── config.php           # BD, URL base, timezone
│   └── database.php         # Conexión PDO
├── database/
│   └── schema.sql           # Estructura completa
├── public/
│   ├── index.php            # Entry point
│   ├── api/
│   │   └── get-published-form.php  # API REST del formulario
│   ├── js/
│   │   └── form-builder.js  # Constructor visual drag & drop
│   └── uploads/             # Archivos subidos por usuarios
└── README.md
```

## 🔒 Seguridad

- Autenticación con `password_hash()` / `password_verify()`
- Sesiones seguras (HTTPOnly cookies)
- PDO Prepared Statements (protección SQL injection)
- Sanitización de entradas
- Validación de permisos por rol en cada endpoint
- Protección contra listado de directorios

## 👤 Usuarios por Defecto

| Usuario | Contraseña | Rol |
|---------|-----------|-----|
| admin | password123 | Administrador |
| gerente01 | password123 | Gerente |
| asesor01 | password123 | Asesor |

> Cambia las contraseñas inmediatamente después de instalar.

## 🐛 Resolución de Problemas

| Problema | Solución |
|----------|----------|
| Error de conexión a BD | Verificar credenciales en `/config/config.php` |
| URLs 404 | Habilitar `mod_rewrite` en Apache, verificar `.htaccess` |
| No se suben archivos | Permisos en `public/uploads/`, `upload_max_filesize` en php.ini |
| Formulario embebido no carga | Verificar la URL del API en `dynamic_form.php` |
| Campos condicionales en páginas incorrectas | Asegurarse de que cada grupo tenga un Encabezado antes de sus campos |

---

## 📄 Licencia

Código abierto bajo licencia MIT.

---

Desarrollado con ❤️ — Constructor de Formularios Dinámicos
