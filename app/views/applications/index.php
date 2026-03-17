<?php 
$title = 'Envíos de Formularios';
ob_start(); 
$isAsesorRole = $_SESSION['user_role'] === ROLE_ASESOR;
?>

<div class="mb-4 md:mb-6 flex flex-col md:flex-row justify-between items-start md:items-center gap-4">
    <div>
        <h2 class="text-2xl md:text-3xl font-bold text-gray-800">Envíos de Formularios</h2>
        <p class="text-sm md:text-base text-gray-600">Solicitudes recibidas desde formularios públicos y del sistema</p>
    </div>
</div>

<!-- Filtros -->
<div class="bg-white rounded-lg shadow p-4 mb-4 md:mb-6">
    <form method="GET" action="<?= BASE_URL ?>/solicitudes" class="grid grid-cols-1 md:grid-cols-4 gap-4">
        <div>
            <label class="block text-sm font-medium text-gray-700 mb-2">Formulario</label>
            <select name="form_id" class="w-full border border-gray-300 rounded-lg px-3 md:px-4 py-2 text-sm md:text-base">
                <option value="">Todos los formularios</option>
                <?php foreach ($forms as $form): ?>
                    <option value="<?= $form['id'] ?>" <?= $formId == $form['id'] ? 'selected' : '' ?>>
                        <?= htmlspecialchars($form['name']) ?>
                    </option>
                <?php endforeach; ?>
            </select>
        </div>
        
        <div>
            <label class="block text-sm font-medium text-gray-700 mb-2">Estatus</label>
            <select name="status" class="w-full border border-gray-300 rounded-lg px-3 md:px-4 py-2 text-sm md:text-base">
                <option value="">Todos los estatus</option>
                <option value="nuevo" <?= $status === 'nuevo' ? 'selected' : '' ?>>Nuevo</option>
                <option value="en_proceso" <?= $status === 'en_proceso' ? 'selected' : '' ?>>En Proceso</option>
                <option value="completado" <?= $status === 'completado' ? 'selected' : '' ?>>Completado</option>
                <option value="cerrado" <?= $status === 'cerrado' ? 'selected' : '' ?>>Cerrado</option>
            </select>
        </div>
        
        <div>
            <label class="block text-sm font-medium text-gray-700 mb-2">Buscar</label>
            <input type="text" 
                   name="search" 
                   value="<?= htmlspecialchars($search) ?>"
                   placeholder="Nombre, email o folio"
                   class="w-full border border-gray-300 rounded-lg px-3 md:px-4 py-2 text-sm md:text-base">
        </div>
        
        <div class="flex items-end">
            <button type="submit" class="w-full bg-gray-600 text-white px-4 md:px-6 py-2 rounded-lg hover:bg-gray-700 transition text-sm md:text-base">
                <i class="fas fa-search mr-2"></i>Filtrar
            </button>
        </div>
    </form>
</div>

<!-- Tabla de Envíos -->
<div class="bg-white rounded-lg shadow overflow-hidden">
    <div class="overflow-x-auto">
        <table class="w-full">
            <thead class="bg-gray-50 border-b">
                <tr>
                    <th class="px-3 md:px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Folio</th>
                    <th class="px-3 md:px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Solicitante</th>
                    <th class="px-3 md:px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Formulario</th>
                    <th class="px-3 md:px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Contacto</th>
                    <th class="px-3 md:px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Estatus</th>
                    <th class="px-3 md:px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider hidden md:table-cell">Origen</th>
                    <th class="px-3 md:px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Fecha</th>
                    <th class="px-3 md:px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Acciones</th>
                </tr>
            </thead>
            <tbody class="divide-y divide-gray-200">
                <?php foreach ($applications as $app):
                    // Status color class
                    $statusColors = [
                        'nuevo' => 'bg-blue-100 text-blue-800',
                        'en_proceso' => 'bg-yellow-100 text-yellow-800',
                        'completado' => 'bg-green-100 text-green-800',
                        'cerrado' => 'bg-gray-100 text-gray-800'
                    ];
                    $statusClass = $statusColors[$app['status']] ?? 'bg-gray-100 text-gray-800';
                    
                    // Parse data JSON for additional info
                    $data = json_decode($app['form_data'] ?? '{}', true) ?: [];
                    
                    // Origen badge
                    $isPublic = !empty($app['is_public_submission']);
                    $originBadge = $isPublic ? 
                        '<span class="px-2 py-1 text-xs bg-green-100 text-green-700 rounded-full"><i class="fas fa-globe mr-1"></i>Web</span>' : 
                        '<span class="px-2 py-1 text-xs bg-blue-100 text-blue-700 rounded-full"><i class="fas fa-user-shield mr-1"></i>Sistema</span>';
                ?>
                <tr class="hover:bg-gray-50">
                    <td class="px-3 md:px-6 py-4">
                        <span class="font-mono text-xs text-gray-600"><?= htmlspecialchars($app['folio']) ?></span>
                    </td>
                    <td class="px-3 md:px-6 py-4">
                        <div class="flex flex-col">
                            <span class="font-medium text-gray-900 text-sm">
                                <?= htmlspecialchars($app['applicant_name'] ?: '-') ?>
                            </span>
                        </div>
                    </td>
                    <td class="px-3 md:px-6 py-4">
                        <span class="text-sm text-gray-700">
                            <?= htmlspecialchars($app['form_display_name'] ?: 'N/A') ?>
                        </span>
                    </td>
                    <td class="px-3 md:px-6 py-4">
                        <div class="flex flex-col text-xs text-gray-600">
                            <?php if (!empty($app['applicant_email'])): ?>
                                <span title="Email"><i class="fas fa-envelope mr-1 text-gray-400"></i><?= htmlspecialchars($app['applicant_email']) ?></span>
                            <?php endif; ?>
                            <?php if (!empty($app['applicant_phone'])): ?>
                                <span title="Teléfono"><i class="fas fa-phone mr-1 text-gray-400"></i><?= htmlspecialchars($app['applicant_phone']) ?></span>
                            <?php endif; ?>
                        </div>
                    </td>
                    <td class="px-3 md:px-6 py-4">
                        <span class="px-2 py-1 text-xs rounded-full font-medium <?= $statusClass ?>">
                            <?= htmlspecialchars(ucfirst(str_replace('_', ' ', $app['status']))) ?>
                        </span>
                    </td>
                    <td class="px-3 md:px-6 py-4 hidden md:table-cell">
                        <?= $originBadge ?>
                    </td>
                    <td class="px-3 md:px-6 py-4 text-sm text-gray-500">
                        <?= date('d/m/Y H:i', strtotime($app['created_at'])) ?>
                    </td>
                    <td class="px-3 md:px-6 py-4">
                        <div class="flex items-center gap-2">
                            <a href="<?= BASE_URL ?>/solicitudes/ver/<?= $app['id'] ?>"
                               class="text-blue-600 hover:text-blue-800 text-sm font-medium"
                               title="Ver detalles">
                                <i class="fas fa-eye mr-1"></i>Ver
                            </a>
                            <?php if ($_SESSION['user_role'] === ROLE_ADMIN): ?>
                            <form method="POST" 
                                  action="<?= BASE_URL ?>/solicitudes/eliminar/<?= $app['id'] ?>"
                                  class="inline" 
                                  onsubmit="return confirm('¿Eliminar este envío? Esta acción no se puede deshacer.')">
                                <button type="submit" 
                                        class="text-red-600 hover:text-red-800" 
                                        title="Eliminar">
                                    <i class="fas fa-trash"></i>
                                </button>
                            </form>
                            <?php endif; ?>
                        </div>
                    </td>
                </tr>
                <?php endforeach; ?>
                
                <?php if (empty($applications)): ?>
                <tr>
                    <td colspan="8" class="px-6 py-12 text-center text-gray-500">
                        <i class="fas fa-inbox text-4xl mb-3 text-gray-300 block"></i>
                        <p class="text-lg font-medium mb-1">No se encontraron envíos</p>
                        <p class="text-sm">Los formularios enviados aparecerán aquí</p>
                    </td>
                </tr>
                <?php endif; ?>
            </tbody>
        </table>
    </div>
    
    <!-- Paginación -->
    <?php if ($totalPages > 1): ?>
    <div class="bg-gray-50 px-4 py-3 border-t flex items-center justify-between sm:px-6">
        <div class="flex-1 flex justify-between sm:hidden">
            <?php if ($page > 1): ?>
                <a href="?page=<?= $page - 1 ?>&status=<?= urlencode($status) ?>&form_id=<?= urlencode($formId) ?>&search=<?= urlencode($search) ?>" 
                   class="relative inline-flex items-center px-4 py-2 border border-gray-300 text-sm font-medium rounded-md text-gray-700 bg-white hover:bg-gray-50">
                    Anterior
                </a>
            <?php endif; ?>
            <?php if ($page < $totalPages): ?>
                <a href="?page=<?= $page + 1 ?>&status=<?= urlencode($status) ?>&form_id=<?= urlencode($formId) ?>&search=<?= urlencode($search) ?>" 
                   class="ml-3 relative inline-flex items-center px-4 py-2 border border-gray-300 text-sm font-medium rounded-md text-gray-700 bg-white hover:bg-gray-50">
                    Siguiente
                </a>
            <?php endif; ?>
        </div>
        <div class="hidden sm:flex-1 sm:flex sm:items-center sm:justify-between">
            <div>
                <p class="text-sm text-gray-700">
                    Mostrando página <span class="font-medium"><?= $page ?></span> de <span class="font-medium"><?= $totalPages ?></span>
                    (Total: <span class="font-medium"><?= $total ?></span> envíos)
                </p>
            </div>
            <div>
                <nav class="relative z-0 inline-flex rounded-md shadow-sm -space-x-px">
                    <?php if ($page > 1): ?>
                        <a href="?page=<?= $page - 1 ?>&status=<?= urlencode($status) ?>&form_id=<?= urlencode($formId) ?>&search=<?= urlencode($search) ?>" 
                           class="relative inline-flex items-center px-2 py-2 rounded-l-md border border-gray-300 bg-white text-sm font-medium text-gray-500 hover:bg-gray-50">
                            <i class="fas fa-chevron-left"></i>
                        </a>
                    <?php endif; ?>
                    
                    <?php
                    $start = max(1, $page - 2);
                    $end = min($totalPages, $page + 2);
                    for ($i = $start; $i <= $end; $i++):
                    ?>
                        <a href="?page=<?= $i ?>&status=<?= urlencode($status) ?>&form_id=<?= urlencode($formId) ?>&search=<?= urlencode($search) ?>" 
                           class="relative inline-flex items-center px-4 py-2 border border-gray-300 bg-white text-sm font-medium <?= $i === $page ? 'text-blue-600 bg-blue-50' : 'text-gray-700 hover:bg-gray-50' ?>">
                            <?= $i ?>
                        </a>
                    <?php endfor; ?>
                    
                    <?php if ($page < $totalPages): ?>
                        <a href="?page=<?= $page + 1 ?>&status=<?= urlencode($status) ?>&form_id=<?= urlencode($formId) ?>&search=<?= urlencode($search) ?>" 
                           class="relative inline-flex items-center px-2 py-2 rounded-r-md border border-gray-300 bg-white text-sm font-medium text-gray-500 hover:bg-gray-50">
                            <i class="fas fa-chevron-right"></i>
                        </a>
                    <?php endif; ?>
                </nav>
            </div>
        </div>
    </div>
    <?php endif; ?>
</div>

<?php
$content = ob_get_clean();
include ROOT_PATH . '/app/views/layouts/main.php';
?>
