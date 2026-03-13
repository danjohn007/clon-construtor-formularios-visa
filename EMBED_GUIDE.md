# Guía de Embebido de Formularios

## 📋 Cómo Embeber Formularios en Otros Sitios

Los formularios ahora soportan dos modos de visualización:

### 1. **Modo Normal** (con sidebar)
Ideal para páginas dedicadas o landing pages.

```html
<iframe 
    src="https://tudominio.com/public/form/1" 
    width="100%" 
    height="800px" 
    frameborder="0"
    style="border: none; border-radius: 8px;">
</iframe>
```

### 2. **Modo Embebido** (sin sidebar, diseño compacto)
Perfecto para embeber en otros sitios web.

```html
<iframe 
    src="https://tudominio.com/public/form/1?embed=1" 
    width="100%" 
    height="600px" 
    frameborder="0"
    style="border: 1px solid #e5e7eb; border-radius: 8px;">
</iframe>
```

## 🎨 Personalización del Sidebar

Para personalizar la información del sidebar (teléfonos, email, etc.), edita directamente en:
`app/views/public/form.php` líneas 2-10

```php
$contactInfo = [
    'phone_main' => '512.259.2771',    // Teléfono principal
    'phone_direct' => '512.233.8827',   // Línea directa
    'email' => '1txlandscape@gmail.com', // Email de contacto
    'company' => 'Tu Empresa'            // Nombre de la empresa
];
```

## 📱 Responsive

Los formularios son completamente responsive y se adaptan a:
- Desktop (1024px+): Sidebar + Formulario
- Tablet (768-1023px): Sidebar arriba, formulario abajo
- Mobile (< 768px): Diseño vertical optimizado

## 🌐 Compartir Enlaces

### Link Directo:
```
https://tudominio.com/public/form/1
```

### Link para Embeber:
```
https://tudominio.com/public/form/1?embed=1
```

## 🔧 Características del Nuevo Diseño

- ✅ Sidebar negro con información de contacto destacada en verde
- ✅ Radio buttons personalizados con estilo moderno
- ✅ Sistema de pasos (STEP 01, STEP 02, etc.) para formularios paginados
- ✅ Barra de progreso visual
- ✅ Botones de navegación estilizados (BACK / CONTINUE)
- ✅ Autoguardado en localStorage
- ✅ Diseño profesional tipo "quote form"
- ✅ 100% responsive
- ✅ Listo para embeber en cualquier sitio

## 📝 Ejemplo de Uso en WordPress

```html
<!-- Agregar en un bloque HTML personalizado -->
<div style="max-width: 1200px; margin: 0 auto;">
    <iframe 
        src="https://tudominio.com/public/form/1?embed=1" 
        width="100%" 
        height="700px" 
        frameborder="0"
        style="border: 1px solid #e5e7eb; border-radius: 12px; box-shadow: 0 4px 6px rgba(0,0,0,0.1);">
    </iframe>
</div>
```

## 🎯 Ejemplo de Uso en HTML

```html
<!DOCTYPE html>
<html>
<head>
    <title>Formulario de Cotización</title>
</head>
<body>
    <h1>Solicita tu Cotización</h1>
    
    <!-- Modo embebido -->
    <iframe 
        src="https://landscapeinaustin.com/sistema/public/public/form/1?embed=1" 
        width="100%" 
        height="700px" 
        frameborder="0"
        allow="geolocation; camera"
        style="border: 1px solid #e5e7eb; border-radius: 8px;">
    </iframe>
</body>
</html>
```

## 🔐 Seguridad

### Headers HTTP Configurados

Los formularios están configurados para funcionar en **cualquier dominio** mediante los siguientes headers HTTP:

#### En `PublicFormController::show()`:
```php
header('X-Frame-Options: ALLOWALL');           // Permite iframes en cualquier dominio
header('Access-Control-Allow-Origin: *');       // Permite CORS desde cualquier origen
header('Access-Control-Allow-Methods: GET, POST'); // Métodos permitidos
header('Access-Control-Allow-Headers: Content-Type'); // Headers permitidos
```

#### En `PublicFormController::submit()`:
```php
header('Access-Control-Allow-Origin: *');       // Permite envíos desde cualquier origen
header('Access-Control-Allow-Methods: GET, POST');
header('Access-Control-Allow-Headers: Content-Type');
header('Content-Type: application/json');       // Respuestas en JSON
```

### Características de Seguridad:
- ✅ **Sin restricciones de dominio**: Los formularios pueden embeberse en cualquier sitio web
- ✅ **CORS habilitado**: Funciona correctamente en dominios externos
- ✅ **Validación del lado del servidor**: Todos los datos se validan antes de guardar
- ✅ **Protección CSRF integrada**: Token de sesión automático
- ✅ **Datos encriptados en tránsito**: Se recomienda usar HTTPS
- ✅ **No requiere autenticación**: Acceso completamente público por diseño

### Notas Importantes:
1. **Dominio cruzado**: El sistema permite embeber formularios desde cualquier dominio sin configuración adicional
2. **HTTPS recomendado**: Para producción, siempre usa HTTPS en tu servidor
3. **Sin tokens**: Los formularios son públicos por ID, no requieren tokens de acceso
4. **Completamente libre**: Sin restricciones de publicación (is_published) o autenticación

## 📊 Analytics

Para rastrear envíos de formularios embebidos, considera integrar:
- Google Analytics 4
- Facebook Pixel
- O tu herramienta de analytics preferida

Agrega el código de tracking en el archivo `form.php` dentro del `<head>`.

---

**💡 Tip:** El parámetro `?embed=1` oculta el sidebar negro y optimiza el formulario para embebido.
