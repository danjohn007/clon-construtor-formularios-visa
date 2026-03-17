<?php
/**
 * API para obtener el formulario publicado en producción
 * Este archivo es llamado desde codigo_principal/contact.php
 */

header('Content-Type: application/json');
header('Access-Control-Allow-Origin: *');

// Cargar configuración primero (define las constantes DB_HOST, DB_NAME, etc.)
require_once __DIR__ . '/../../config/config.php';
require_once __DIR__ . '/../../config/database.php';

try {
    $db = Database::getInstance()->getConnection();
    
    // Obtener el formulario publicado (usa is_published)
    $stmt = $db->prepare("
        SELECT id, name, description, fields_json, pagination_enabled, pages_json, 
               success_message, custom_css
        FROM forms 
        WHERE is_published = 1
        AND public_enabled = 1
        ORDER BY updated_at DESC
        LIMIT 1
    ");
    $stmt->execute();
    $form = $stmt->fetch();
    
    if ($form) {
        // Decodificar JSON
        $form['fields_json'] = json_decode($form['fields_json'], true);
        if ($form['pages_json']) {
            $form['pages_json'] = json_decode($form['pages_json'], true);
        }
        
        echo json_encode([
            'status' => 'success',
            'form' => $form,
            'hasPublishedForm' => true
        ]);
    } else {
        // No hay formulario publicado, usar el original
        echo json_encode([
            'status' => 'success',
            'hasPublishedForm' => false,
            'message' => 'No published form found, use original'
        ]);
    }
    
} catch (Exception $e) {
    error_log("Error getting published form: " . $e->getMessage());
    echo json_encode([
        'status' => 'error',
        'message' => 'Database error',
        'hasPublishedForm' => false
    ]);
}
