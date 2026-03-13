<?php 
$title = 'Editar Formulario';
ob_start(); 
?>

<div class="mb-6">
    <div class="flex items-center space-x-4 mb-4">
        <a href="<?= BASE_URL ?>/formularios" class="text-primary hover:underline">
            <i class="fas fa-arrow-left"></i> Volver
        </a>
        <h2 class="text-3xl font-bold text-gray-800">Editar Formulario</h2>
    </div>
</div>

<div class="bg-white rounded-lg shadow p-6">
    <form method="POST" action="<?= BASE_URL ?>/formularios/actualizar/<?= $form['id'] ?>">
        <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
            <div class="md:col-span-2">
                <label class="block text-sm font-medium text-gray-700 mb-2">
                    Nombre del Formulario <span class="text-red-500">*</span>
                </label>
                <input type="text" name="name" required value="<?= htmlspecialchars($form['name']) ?>"
                       class="w-full border border-gray-300 rounded-lg px-4 py-2 focus:ring-2 focus:ring-blue-500">
            </div>
            
            <div class="md:col-span-2">
                <label class="block text-sm font-medium text-gray-700 mb-2">Descripción</label>
                <textarea name="description" rows="2"
                          class="w-full border border-gray-300 rounded-lg px-4 py-2 focus:ring-2 focus:ring-blue-500"><?= htmlspecialchars($form['description'] ?? '') ?></textarea>
            </div>
            
            <!-- Hidden fields para mantener compatibilidad con BD -->
            <input type="hidden" name="type" value="<?= htmlspecialchars($form['type'] ?? '') ?>">
            <input type="hidden" name="subtype" value="<?= htmlspecialchars($form['subtype'] ?? '') ?>">
            <input type="hidden" name="cost" value="<?= htmlspecialchars($form['cost'] ?? 0) ?>">
            
            <!-- Pagination Section -->
            <div class="md:col-span-2 border-t pt-6">
                <div class="flex items-center justify-between mb-4">
                    <div>
                        <label class="block text-sm font-medium text-gray-700 mb-1">
                            Paginación del Formulario
                        </label>
                        <p class="text-xs text-gray-500">
                            Divide el formulario en secciones para guardar el avance
                        </p>
                    </div>
                    <input type="checkbox" name="pagination_enabled" id="pagination_enabled" value="1"
                           <?= $form['pagination_enabled'] ? 'checked' : '' ?>
                           class="w-5 h-5 text-blue-600 rounded focus:ring-blue-500">
                </div>
            </div>
            
            <div class="md:col-span-2">
                <div class="flex justify-between items-center mb-2">
                    <label class="block text-sm font-medium text-gray-700">
                        Campos del Formulario <span class="text-red-500">*</span>
                    </label>
                    <span class="text-sm text-gray-500">Versión actual: v<?= $form['version'] ?></span>
                </div>
                
                <!-- Visual Form Builder -->
                <div id="form-builder-container" 
                     data-initial-data="<?= htmlspecialchars($form['fields_json']) ?>"
                     data-initial-pages="<?= htmlspecialchars($form['pages_json'] ?? '') ?>"></div>
                
                <!-- Hidden field to store JSON -->
                <input type="hidden" name="fields_json" id="fields_json_hidden" required value="<?= htmlspecialchars($form['fields_json']) ?>">
                
                <p class="text-sm text-yellow-600 mt-2">
                    <i class="fas fa-exclamation-triangle"></i> Al guardar, la versión se incrementará automáticamente
                </p>
            </div>
        </div>
        
        <div class="mt-6 flex justify-end space-x-4">
            <a href="<?= BASE_URL ?>/formularios" class="px-6 py-2 border border-gray-300 rounded-lg hover:bg-gray-50">
                Cancelar
            </a>
            <button type="submit" class="btn-primary text-white px-6 py-2 rounded-lg hover:opacity-90">
                <i class="fas fa-save mr-2"></i>Actualizar Formulario
            </button>
        </div>
    </form>
</div>

<script src="<?= BASE_URL ?>/js/form-builder.js?v=<?= time() ?>"></script>

<?php 
$content = ob_get_clean();
require ROOT_PATH . '/app/views/layouts/main.php';
?>
