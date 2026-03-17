-- Script para verificar el estado del sistema de publicación de formularios

-- 1. Verificar que existe el campo published_to_production
SHOW COLUMNS FROM forms LIKE 'published_to_production';

-- 2. Ver todos los formularios y su estado de publicación
SELECT 
    id,
    name,
    type,
    is_published,
    published_to_production,
    public_enabled,
    created_at
FROM forms
ORDER BY published_to_production DESC, created_at DESC;

-- 3. Ver qué formulario está actualmente publicado en producción
SELECT 
    id,
    name,
    description,
    type,
    published_to_production
FROM forms
WHERE published_to_production = 1
LIMIT 1;

-- 4. Contar formularios por estado
SELECT 
    COUNT(*) as total_forms,
    SUM(CASE WHEN is_published = 1 THEN 1 ELSE 0 END) as published_forms,
    SUM(CASE WHEN published_to_production = 1 THEN 1 ELSE 0 END) as production_forms,
    SUM(CASE WHEN public_enabled = 1 THEN 1 ELSE 0 END) as public_forms
FROM forms;

-- 5. Despublicar todos los formularios de producción (USAR CON CUIDADO)
-- UPDATE forms SET published_to_production = 0;

-- 6. Publicar un formulario específico en producción (reemplaza ID)
-- UPDATE forms SET published_to_production = 0; -- Despublicar todos primero
-- UPDATE forms SET published_to_production = 1, is_published = 1, public_enabled = 1 WHERE id = YOUR_FORM_ID;
