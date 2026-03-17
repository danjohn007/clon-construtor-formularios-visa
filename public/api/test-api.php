<?php
/**
 * Script de diagnóstico para verificar el sistema de publicación
 */

header('Content-Type: application/json');

$diagnostics = [];

// 1. Verificar que existen los archivos de configuración
$diagnostics['config_file_exists'] = file_exists(__DIR__ . '/../../config/config.php');
$diagnostics['database_file_exists'] = file_exists(__DIR__ . '/../../config/database.php');

try {
    // 2. Cargar configuración
    require_once __DIR__ . '/../../config/config.php';
    require_once __DIR__ . '/../../config/database.php';
    $diagnostics['config_loaded'] = true;
    
    // 3. Verificar constantes de base de datos
    $diagnostics['db_constants'] = [
        'DB_HOST' => defined('DB_HOST') ? DB_HOST : 'NOT DEFINED',
        'DB_NAME' => defined('DB_NAME') ? DB_NAME : 'NOT DEFINED',
        'DB_USER' => defined('DB_USER') ? 'DEFINED' : 'NOT DEFINED',
    ];
    
    // 4. Intentar conectar a la base de datos
    try {
        $db = Database::getInstance()->getConnection();
        $diagnostics['database_connection'] = 'SUCCESS';
        
        // 5. Verificar si existe la tabla forms
        $tableCheck = $db->query("SHOW TABLES LIKE 'forms'")->fetch();
        $diagnostics['forms_table_exists'] = $tableCheck ? true : false;
        
        if ($tableCheck) {
            // 6. Verificar estructura de la tabla
            $columns = $db->query("SHOW COLUMNS FROM forms")->fetchAll(PDO::FETCH_ASSOC);
            $columnNames = array_column($columns, 'Field');
            $diagnostics['forms_columns'] = $columnNames;
            
            // 7. Verificar si existe la columna is_published (debe existir)
            $diagnostics['is_published_exists'] = in_array('is_published', $columnNames);
            
            // 8. Verificar si existe la columna public_enabled
            $diagnostics['public_enabled_exists'] = in_array('public_enabled', $columnNames);
            
            // 9. Contar formularios
            $count = $db->query("SELECT COUNT(*) FROM forms")->fetchColumn();
            $diagnostics['total_forms'] = (int)$count;
            
            // 10. Verificar formularios publicados
            if ($diagnostics['is_published_exists']) {
                $publishedCount = $db->query("
                    SELECT COUNT(*) FROM forms 
                    WHERE is_published = 1
                ")->fetchColumn();
                $diagnostics['published_forms_count'] = (int)$publishedCount;
                
                // 11. Obtener detalles del formulario publicado
                if ($publishedCount > 0) {
                    $publishedForm = $db->query("
                        SELECT id, name, is_published, public_enabled
                        FROM forms 
                        WHERE is_published = 1
                        ORDER BY updated_at DESC
                        LIMIT 1
                    ")->fetch(PDO::FETCH_ASSOC);
                    $diagnostics['published_form_details'] = $publishedForm;
                }
            }
        }
        
    } catch (PDOException $e) {
        $diagnostics['database_connection'] = 'ERROR';
        $diagnostics['database_error'] = $e->getMessage();
    }
    
} catch (Exception $e) {
    $diagnostics['config_loaded'] = false;
    $diagnostics['config_error'] = $e->getMessage();
}

// Resultado del diagnóstico
$diagnostics['timestamp'] = date('Y-m-d H:i:s');

echo json_encode($diagnostics, JSON_PRETTY_PRINT);
