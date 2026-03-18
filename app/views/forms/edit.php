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
            
            <!-- Consideraciones -->
            <div class="md:col-span-2 border-t pt-6">
                <details class="bg-amber-50 border border-amber-200 rounded-lg">
                    <summary class="px-4 py-3 cursor-pointer text-sm font-semibold text-amber-800 flex items-center hover:bg-amber-100 rounded-lg transition">
                        <i class="fas fa-exclamation-circle mr-2"></i>
                        Consideraciones importantes al construir el formulario
                    </summary>
                    <div class="px-4 pb-4 space-y-3 text-sm text-gray-700">
                        
                        <div class="flex items-start gap-2 bg-white rounded p-3 border border-amber-100">
                            <i class="fas fa-heading text-blue-500 mt-0.5 flex-shrink-0"></i>
                            <div>
                                <strong class="text-gray-900">Encabezado = Separador de sección</strong>
                                <p class="text-xs text-gray-600 mt-1">
                                    Los campos tipo <strong>"Encabezado"</strong> actúan como separadores de sección. 
                                    Cuando usas paginación con campos condicionales, todos los campos que estén 
                                    debajo de un encabezado (con la misma condición) se agruparán automáticamente 
                                    en la misma página. <em>Cada nuevo encabezado inicia una sección distinta.</em>
                                </p>
                            </div>
                        </div>
                        
                        <div class="flex items-start gap-2 bg-white rounded p-3 border border-amber-100">
                            <i class="fas fa-link text-purple-500 mt-0.5 flex-shrink-0"></i>
                            <div>
                                <strong class="text-gray-900">Campos condicionales (showWhen)</strong>
                                <p class="text-xs text-gray-600 mt-1">
                                    Un campo condicional solo se muestra cuando otro campo de tipo <strong>"Selección"</strong> 
                                    tiene un valor específico. Por ejemplo: mostrar campos de "Landscaping" solo 
                                    cuando el usuario seleccione "Landscaping" en el campo de servicio. 
                                    Usa el botón <i class="fas fa-link text-blue-500"></i> de cada campo para configurarlo.
                                </p>
                            </div>
                        </div>
                        
                        <div class="flex items-start gap-2 bg-white rounded p-3 border border-amber-100">
                            <i class="fas fa-layer-group text-green-500 mt-0.5 flex-shrink-0"></i>
                            <div>
                                <strong class="text-gray-900">Paginación y agrupación automática</strong>
                                <p class="text-xs text-gray-600 mt-1">
                                    Al habilitar paginación, los campos condicionales de una misma sección 
                                    (entre dos encabezados) se consolidarán automáticamente en una sola página, 
                                    sin importar en qué página estén asignados manualmente. 
                                    Esto evita que un grupo de campos quede disperso en múltiples páginas.
                                </p>
                            </div>
                        </div>
                        
                        <div class="flex items-start gap-2 bg-white rounded p-3 border border-amber-100">
                            <i class="fas fa-list text-orange-500 mt-0.5 flex-shrink-0"></i>
                            <div>
                                <strong class="text-gray-900">Campo "Selección" se renderiza como radio buttons</strong>
                                <p class="text-xs text-gray-600 mt-1">
                                    Los campos de tipo <strong>"Selección"</strong> se muestran como botones de radio 
                                    en el formulario público (no como dropdown). Separa las opciones con comas.
                                </p>
                            </div>
                        </div>
                        
                        <div class="flex items-start gap-2 bg-white rounded p-3 border border-amber-100">
                            <i class="fas fa-sort-amount-down text-red-500 mt-0.5 flex-shrink-0"></i>
                            <div>
                                <strong class="text-gray-900">El orden de los campos importa</strong>
                                <p class="text-xs text-gray-600 mt-1">
                                    El orden en que aparecen los campos en el constructor es el orden en que se 
                                    renderizan en el formulario público. Coloca los encabezados <strong>antes</strong> 
                                    de los campos que pertenecen a esa sección.
                                </p>
                            </div>
                        </div>
                        
                    </div>
                </details>
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
