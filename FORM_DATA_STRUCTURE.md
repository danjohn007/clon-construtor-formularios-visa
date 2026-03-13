# 📋 Estructura de Datos del Formulario

## 🚀 Resumen Ejecutivo

Este documento describe cómo se envían los datos cuando un usuario hace **SUBMIT** en un formulario embebido.

### Comportamiento del Formulario:
- **SAVE DRAFT**: Solo guarda en `localStorage` (NO envía al servidor)
- **SUBMIT**: Envía todos los datos al servidor vía POST
- **Auto-guardado**: Solo guarda en `localStorage` cada 2 segundos de inactividad

---

## 📤 Endpoint de Envío

```
POST /public/form/{formId}/submit
```

### Ejemplo:
```
POST https://landscapeinaustin.com/sistema/public/public/form/6/submit
```

---

## 📦 Estructura de Datos Enviados

Los datos se envían como `FormData` (multipart/form-data) con la siguiente estructura:

### 1. Campo `formData` (JSON string)
Contiene todos los valores de los campos del formulario en formato JSON.

```json
{
    "nombre": "Juan Pérez",
    "email": "juan@example.com",
    "telefono": "555-1234",
    "tipo_servicio": "landscaping",
    "mensaje": "Necesito cotización para jardín",
    "direccion": "123 Main St, Austin TX",
    "fecha_preferida": "2026-03-20"
}
```

### 2. Campo `currentPage` (string)
Número de página actual si el formulario tiene paginación.

```
"1"
```

### 3. Campo `isCompleted` (boolean string)
Indica si el formulario está siendo enviado como completo o solo guardado.

```
"true"  // Para SUBMIT
"false" // Para auto-guardado (ya deshabilitado)
```

### 4. Campo `appId` (opcional, string)
ID de la aplicación asociada, si existe.

```
"123"
```

### 5. Campo `submissionId` (opcional, string)
ID de un envío previo, si el usuario está actualizando un formulario.

```
"456"
```

### 6. Archivos adjuntos (si existen)
Los archivos se envían como campos individuales con el nombre del campo del formulario.

```
photo: (binary file data)
document: (binary file data)
```

---

## 🔍 Ejemplo Completo de Request

### Headers:
```http
POST /public/form/6/submit HTTP/1.1
Host: landscapeinaustin.com
Content-Type: multipart/form-data; boundary=----WebKitFormBoundary...
```

### Body (FormData):
```
------WebKitFormBoundary...
Content-Disposition: form-data; name="formData"

{"nombre":"Juan Pérez","email":"juan@example.com","telefono":"555-1234","tipo_servicio":"landscaping","mensaje":"Necesito cotización para jardín"}
------WebKitFormBoundary...
Content-Disposition: form-data; name="currentPage"

1
------WebKitFormBoundary...
Content-Disposition: form-data; name="isCompleted"

true
------WebKitFormBoundary...
Content-Disposition: form-data; name="photo"; filename="garden.jpg"
Content-Type: image/jpeg

(binary data)
------WebKitFormBoundary...--
```

---

## 📥 Respuesta del Servidor

### Success Response (200 OK):
```json
{
    "success": true,
    "submissionId": "789",
    "progressPercentage": 100,
    "message": "Formulario enviado correctamente"
}
```

### Error Response (400/500):
```json
{
    "success": false,
    "error": "Error al guardar los datos"
}
```

---

## 🎯 Manejo en Sitio Embebido

### Escenario 1: Formulario Completo Único
```html
<iframe src="https://tudominio.com/public/form/6?embed=1" 
        width="100%" height="700px">
</iframe>
```

**Flujo:**
1. Usuario llena el formulario
2. Click en "SUBMIT"
3. POST a `/public/form/6/submit` con `isCompleted=true`
4. Servidor guarda en base de datos
5. Muestra mensaje de éxito

### Escenario 2: Formulario con Paginación
```html
<iframe src="https://tudominio.com/public/form/10?embed=1" 
        width="100%" height="700px">
</iframe>
```

**Flujo:**
1. Usuario llena Página 1 → Click "CONTINUE"
2. Usuario llena Página 2 → Click "CONTINUE"
3. Usuario llena Página 3 → Click "SUBMIT"
4. POST a `/public/form/10/submit` con `isCompleted=true` y **todos los datos de todas las páginas**
5. Servidor guarda en base de datos
6. Muestra mensaje de éxito

---

## 💾 LocalStorage (Solo Cliente)

### Key Format:
```
form_draft_{formId}
```

### Ejemplo:
```javascript
localStorage.getItem('form_draft_6')
```

### Contenido:
```json
{
    "nombre": "Juan",
    "email": "juan@example.com",
    "telefono": "555-1234"
}
```

### Comportamiento:
- ✅ Se guarda automáticamente cada 2 segundos de inactividad
- ✅ Se guarda al hacer click en "SAVE DRAFT"
- ✅ Se carga automáticamente al abrir el formulario
- ✅ Se elimina automáticamente al hacer SUBMIT exitoso
- ⚠️ **NUNCA se envía al servidor** (solo localStorage del navegador)

---

## 🔧 Integración en Otros Sistemas

### Capturar el Envío desde el Iframe (Comunicación PostMessage)

Si necesitas capturar cuando el formulario se envió desde el sitio padre:

```javascript
// En el sitio que embebe el iframe
window.addEventListener('message', function(event) {
    // Verificar origen
    if (event.origin !== 'https://landscapeinaustin.com') return;
    
    if (event.data.type === 'formSubmitted') {
        console.log('Formulario enviado:', event.data.submissionId);
        // Ejecutar acción personalizada
        // Ejemplo: redireccionar, mostrar mensaje, etc.
    }
});
```

**Nota:** Actualmente el formulario NO envía postMessage. Si necesitas esta funcionalidad, se puede agregar fácilmente.

---

## 📊 Campos por Tipo

### Text Input:
```json
"nombre": "Juan Pérez"
```

### Email:
```json
"email": "juan@example.com"
```

### Number:
```json
"area": "500"
```

### Select (Dropdown):
```json
"tipo_servicio": "landscaping"
```

### Radio Buttons:
```json
"frecuencia": "semanal"
```

### Checkbox (Single):
```json
"acepta_terminos": "on"  // Si está marcado
// No aparece si no está marcado
```

### Textarea:
```json
"mensaje": "Texto largo\ncon saltos de línea"
```

### Date:
```json
"fecha": "2026-03-20"
```

### File Upload:
```json
"foto": "garden-photo.jpg"  // En formData JSON (nombre del archivo)
```
Y el archivo real se envía en el FormData multipart como campo separado.

---

## 🛡️ Validaciones

### Client-side (JavaScript):
- ✅ Campos requeridos (`required` attribute)
- ✅ Formatos de email, número, etc.
- ✅ Validación por página (en formularios paginados)

### Server-side (PHP):
- ✅ Validación de tipos de datos
- ✅ Sanitización de inputs
- ✅ Verificación de archivos (tamaño, tipo)
- ✅ Validación de campos requeridos

---

## 🎨 Personalización del Comportamiento

### Agregar Lógica al Envío Exitoso

Edita `app/views/public/form.php` línea ~650:

```javascript
if (isCompleted) {
    // Aquí puedes agregar lógica personalizada
    // Ejemplo: enviar a Google Analytics
    gtag('event', 'form_submission', {
        'form_id': FORM_ID,
        'form_name': '<?= addslashes($form["name"]) ?>'
    });
    
    // Ejemplo: redireccionar a página de gracias
    // window.location.href = '/thank-you';
    
    // Por defecto: mostrar mensaje de éxito
    form.style.display = 'none';
    successMessage.classList.remove('hidden');
}
```

### Interceptar Antes de Enviar

Edita línea ~458:

```javascript
form.addEventListener('submit', function(e) {
    e.preventDefault();
    
    // Tu lógica personalizada aquí
    if (confirm('¿Estás seguro de enviar el formulario?')) {
        saveFormData(true);
    }
});
```

---

## 📞 Soporte

Para modificaciones o integraciones personalizadas, edita:
- **Frontend**: `app/views/public/form.php`
- **Backend**: `app/controllers/PublicFormController.php` método `submit()`

### Headers CORS Configurados:
```php
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: GET, POST');
header('Access-Control-Allow-Headers: Content-Type');
```

Esto permite que el formulario funcione embebido en **cualquier dominio**.

---

## 🔄 Diagrama de Flujo

```
┌─────────────────┐
│ Usuario llena   │
│ formulario      │
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│ Auto-guardado   │────► localStorage
│ cada 2 seg      │      (NO servidor)
└─────────────────┘
         │
         ▼
┌─────────────────┐
│ Click "SUBMIT"  │
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│ Validación      │
│ client-side     │
└────────┬────────┘
         │ ✓ Valid
         ▼
┌─────────────────┐
│ POST al         │
│ servidor        │
│ FormData        │
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│ Servidor        │
│ procesa y       │
│ guarda en DB    │
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│ Respuesta JSON  │
└────────┬────────┘
         │
         ├─► ✓ Success: Muestra mensaje
         │           Elimina localStorage
         │           Muestra success screen
         │
         └─► ✗ Error: Muestra alert
                     Mantiene formulario
```

---

## ✅ Checklist para Integración

- [ ] Embeber iframe con URL correcta (`?embed=1` para sin sidebar)
- [ ] Configurar ancho/alto apropiado (mínimo 600px alto)
- [ ] Verificar que HTTPS está activo en producción
- [ ] (Opcional) Agregar listener de postMessage si necesitas feedback
- [ ] (Opcional) Personalizar mensaje de éxito
- [ ] (Opcional) Agregar tracking de analytics
- [ ] Probar envío completo end-to-end
- [ ] Verificar almacenamiento de datos en base de datos

---

**Última actualización:** 13 de Marzo, 2026
