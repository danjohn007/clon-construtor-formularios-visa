<?php
$title = 'Detalle de Solicitud - ' . $application['folio'];
ob_start();

$role = $_SESSION['user_role'];
$isAdmin = in_array($role, [ROLE_ADMIN, ROLE_GERENTE]);
$status = $application['status'];

// Status colors
$statusColors = [
    'nuevo' => 'bg-blue-100 text-blue-800',
    'en_proceso' => 'bg-yellow-100 text-yellow-800',
    'completado' => 'bg-green-100 text-green-800',
    'cerrado' => 'bg-gray-100 text-gray-800'
];
$statusClass = $statusColors[$status] ?? 'bg-gray-100 text-gray-800';
?>

<div class="mb-6">
    <div class="flex justify-between items-center flex-wrap gap-3">
        <div>
            <h2 class="text-3xl font-bold text-gray-800"><?= htmlspecialchars($application['folio']) ?></h2>
            <p class="text-gray-600"><?= htmlspecialchars($application['form_display_name'] ?? 'Formulario') ?></p>
        </div>
        <div class="flex space-x-3 flex-wrap gap-2">
            <a href="<?= BASE_URL ?>/solicitudes" class="bg-gray-500 text-white px-6 py-3 rounded-lg hover:bg-gray-600 transition">
                <i class="fas fa-arrow-left mr-2"></i>Volver
            </a>
        </div>
    </div>
</div>

<div class="grid grid-cols-1 lg:grid-cols-3 gap-6">
    <!-- COLUMNA PRINCIPAL -->
    <div class="lg:col-span-2 space-y-6">

        <!-- Información General -->
        <div class="bg-white rounded-lg shadow p-6">
            <h3 class="text-xl font-bold text-gray-800 mb-4">Información General</h3>
            <div class="grid grid-cols-2 gap-4">
                <div>
                    <p class="text-sm text-gray-600">Folio</p>
                    <p class="text-lg font-semibold"><?= htmlspecialchars($application['folio']) ?></p>
                </div>
                <div>
                    <p class="text-sm text-gray-600">Formulario</p>
                    <p class="text-lg font-semibold"><?= htmlspecialchars($application['form_name'] ?? 'N/A') ?></p>
                </div>
                <div>
                    <p class="text-sm text-gray-600">Estatus</p>
                    <span class="px-3 py-1 text-sm rounded-full font-medium <?= $statusClass ?>">
                        <?= htmlspecialchars(ucfirst(str_replace('_', ' ', $status))) ?>
                    </span>
                </div>
                <div>
                    <p class="text-sm text-gray-600">Origen</p>
                    <p class="text-lg font-semibold">
                        <?php if (!empty($application['is_public_submission'])): ?>
                            <span class="px-2 py-1 text-xs bg-green-100 text-green-700 rounded-full">
                                <i class="fas fa-globe mr-1"></i>Web
                            </span>
                        <?php else: ?>
                            <span class="px-2 py-1 text-xs bg-blue-100 text-blue-700 rounded-full">
                                <i class="fas fa-desktop mr-1"></i>Sistema
                            </span>
                        <?php endif; ?>
                    </p>
                </div>
                <?php if (!empty($application['creator_name'])): ?>
                <div>
                    <p class="text-sm text-gray-600">Creado por</p>
                    <p class="text-lg font-semibold"><?= htmlspecialchars($application['creator_name']) ?></p>
                </div>
                <?php endif; ?>
                <div>
                    <p class="text-sm text-gray-600">Fecha de Creación</p>
                    <p class="text-lg font-semibold"><?= date('d/m/Y H:i', strtotime($application['created_at'])) ?></p>
                </div>
                <?php if (!empty($application['ip_address'])): ?>
                <div>
                    <p class="text-sm text-gray-600">IP</p>
                    <p class="text-sm text-gray-700"><?= htmlspecialchars($application['ip_address']) ?></p>
                </div>
                <?php endif; ?>
                <?php if (!empty($application['source'])): ?>
                <div>
                    <p class="text-sm text-gray-600">Fuente</p>
                    <p class="text-sm text-gray-700"><?= htmlspecialchars($application['source']) ?></p>
                </div>
                <?php endif; ?>
            </div>
        </div>

        <!-- Datos del Solicitante -->
        <?php
        $formData = json_decode($application['form_data'] ?? '{}', true) ?: [];
        ?>
        <div class="bg-white rounded-lg shadow p-6">
            <h3 class="text-xl font-bold text-gray-800 mb-4">Datos del Solicitante</h3>
            <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                <?php if (!empty($application['applicant_name'])): ?>
                <div class="border-l-4 border-blue-500 pl-4">
                    <p class="text-sm text-gray-600">Nombre</p>
                    <p class="text-lg font-semibold"><?= htmlspecialchars($application['applicant_name']) ?></p>
                </div>
                <?php endif; ?>
                <?php if (!empty($application['applicant_email'])): ?>
                <div class="border-l-4 border-blue-500 pl-4">
                    <p class="text-sm text-gray-600">Email</p>
                    <p class="text-lg font-semibold">
                        <a href="mailto:<?= htmlspecialchars($application['applicant_email']) ?>" class="text-blue-600 hover:text-blue-800">
                            <?= htmlspecialchars($application['applicant_email']) ?>
                        </a>
                    </p>
                </div>
                <?php endif; ?>
                <?php if (!empty($application['applicant_phone'])): ?>
                <div class="border-l-4 border-blue-500 pl-4">
                    <p class="text-sm text-gray-600">Teléfono</p>
                    <p class="text-lg font-semibold">
                        <a href="tel:<?= htmlspecialchars($application['applicant_phone']) ?>" class="text-blue-600 hover:text-blue-800">
                            <?= htmlspecialchars($application['applicant_phone']) ?>
                        </a>
                    </p>
                </div>
                <?php endif; ?>
            </div>
        </div>

        <!-- Datos del Formulario -->
        <?php if (!empty($formData)): ?>
        <div class="bg-white rounded-lg shadow p-6">
            <h3 class="text-xl font-bold text-gray-800 mb-4">Datos del Formulario</h3>
            <div class="space-y-3">
                <?php foreach ($formData as $key => $value): ?>
                    <?php if (is_string($value) || is_numeric($value)): ?>
                    <div class="border-b border-gray-200 pb-3">
                        <p class="text-sm font-medium text-gray-600 mb-1">
                            <?= htmlspecialchars(ucfirst(str_replace('_', ' ', $key))) ?>
                        </p>
                        <p class="text-gray-800"><?= htmlspecialchars($value) ?></p>
                    </div>
                    <?php elseif (is_array($value)): ?>
                    <div class="border-b border-gray-200 pb-3">
                        <p class="text-sm font-medium text-gray-600 mb-1">
                            <?= htmlspecialchars(ucfirst(str_replace('_', ' ', $key))) ?>
                        </p>
                        <p class="text-gray-800"><?= htmlspecialchars(implode(', ', $value)) ?></p>
                    </div>
                    <?php endif; ?>
                <?php endforeach; ?>
            </div>
        </div>
        <?php endif; ?>

        <!-- Documentos Adjuntos -->
        <?php if (!empty($documents)): ?>
        <div class="bg-white rounded-lg shadow p-6">
            <h3 class="text-xl font-bold text-gray-800 mb-4">
                <i class="fas fa-paperclip text-blue-600 mr-2"></i>Documentos Adjuntos
            </h3>
            <div class="space-y-3">
                <?php foreach ($documents as $doc): ?>
                <div class="flex items-center justify-between p-3 bg-gray-50 rounded-lg hover:bg-gray-100 transition">
                    <div class="flex items-center space-x-3">
                        <?php
                        $extension = strtolower(pathinfo($doc['file_path'], PATHINFO_EXTENSION));
                        $iconClass = 'fa-file';
                        $iconColor = 'text-gray-600';
                        if (in_array($extension, ['pdf'])) {
                            $iconClass = 'fa-file-pdf';
                            $iconColor = 'text-red-600';
                        } elseif (in_array($extension, ['jpg', 'jpeg', 'png', 'gif'])) {
                            $iconClass = 'fa-file-image';
                            $iconColor = 'text-blue-600';
                        } elseif (in_array($extension, ['doc', 'docx'])) {
                            $iconClass = 'fa-file-word';
                            $iconColor = 'text-blue-700';
                        } elseif (in_array($extension, ['xls', 'xlsx'])) {
                            $iconClass = 'fa-file-excel';
                            $iconColor = 'text-green-600';
                        }
                        ?>
                        <i class="fas <?= $iconClass ?> <?= $iconColor ?> text-2xl"></i>
                        <div>
                            <p class="font-medium text-gray-800"><?= htmlspecialchars($doc['name'] ?? 'Documento sin nombre') ?></p>
                            <p class="text-xs text-gray-500">
                                Subido: <?= date('d/m/Y H:i', strtotime($doc['created_at'])) ?>
                                <?php if (!empty($doc['uploaded_by_name'])): ?>
                                    por <?= htmlspecialchars($doc['uploaded_by_name']) ?>
                                <?php endif; ?>
                            </p>
                        </div>
                    </div>
                    <a href="<?= BASE_URL ?>/solicitudes/descargar-documento/<?= $doc['id'] ?>"
                       class="bg-blue-600 text-white px-4 py-2 rounded-lg hover:bg-blue-700 transition text-sm">
                        <i class="fas fa-download mr-1"></i>Descargar
                    </a>
                </div>
                <?php endforeach; ?>
            </div>
        </div>
        <?php endif; ?>

        <!-- Archivos del Formulario (desde attachments_json) -->
        <?php
        $attachments = json_decode($application['attachments_json'] ?? '[]', true) ?: [];
        ?>
        <?php if (!empty($attachments)): ?>
        <div class="bg-white rounded-lg shadow p-6">
            <h3 class="text-xl font-bold text-gray-800 mb-4">
                <i class="fas fa-images text-green-600 mr-2"></i>Archivos Enviados por el Cliente
            </h3>
            <div class="space-y-3">
                <?php foreach ($attachments as $att): ?>
                <?php
                    $ext = strtolower($att['type'] ?? '');
                    $aIcon = 'fa-file'; $aColor = 'text-gray-600';
                    if (in_array($ext, ['jpg', 'jpeg', 'png', 'gif'])) { $aIcon = 'fa-file-image'; $aColor = 'text-blue-600'; }
                    elseif ($ext === 'pdf') { $aIcon = 'fa-file-pdf'; $aColor = 'text-red-600'; }
                    elseif (in_array($ext, ['doc', 'docx'])) { $aIcon = 'fa-file-word'; $aColor = 'text-blue-700'; }
                    
                    // Match attachment to document record by filename
                    $matchedDoc = null;
                    if (!empty($documents)) {
                        foreach ($documents as $doc) {
                            if (str_contains($doc['name'] ?? '', $att['filename'] ?? '__none__')) {
                                $matchedDoc = $doc;
                                break;
                            }
                        }
                    }
                    $isPreviewable = in_array($ext, ['jpg', 'jpeg', 'png', 'gif', 'pdf']);
                ?>
                <div class="flex items-center justify-between p-3 bg-gray-50 rounded-lg hover:bg-gray-100 transition">
                    <div class="flex items-center space-x-3">
                        <i class="fas <?= $aIcon ?> <?= $aColor ?> text-2xl"></i>
                        <div>
                            <p class="font-medium text-gray-800"><?= htmlspecialchars($att['filename'] ?? 'Archivo') ?></p>
                            <p class="text-xs text-gray-500">
                                Campo: <?= htmlspecialchars($att['field'] ?? '-') ?>
                                &middot; <?= round(($att['size'] ?? 0) / 1024, 1) ?> KB
                            </p>
                        </div>
                    </div>
                    <?php if ($matchedDoc): ?>
                    <div class="flex items-center space-x-2">
                        <?php if ($isPreviewable): ?>
                        <a href="<?= BASE_URL ?><?= htmlspecialchars($matchedDoc['file_path']) ?>" 
                           target="_blank"
                           class="bg-green-600 text-white px-3 py-2 rounded-lg hover:bg-green-700 transition text-sm"
                           title="Ver archivo">
                            <i class="fas fa-eye mr-1"></i>Ver
                        </a>
                        <?php endif; ?>
                        <a href="<?= BASE_URL ?>/solicitudes/descargar-documento/<?= $matchedDoc['id'] ?>"
                           class="bg-blue-600 text-white px-3 py-2 rounded-lg hover:bg-blue-700 transition text-sm"
                           title="Descargar archivo">
                            <i class="fas fa-download mr-1"></i>Descargar
                        </a>
                    </div>
                    <?php endif; ?>
                </div>
                <?php endforeach; ?>
            </div>
        </div>
        <?php endif; ?>

        <!-- Notas/Indicaciones -->
        <div class="bg-white rounded-lg shadow p-6">
            <div class="flex justify-between items-center mb-4">
                <h3 class="text-xl font-bold text-gray-800">
                    <i class="fas fa-sticky-note text-yellow-500 mr-2"></i>Notas e Indicaciones
                </h3>
                <button onclick="document.getElementById('addNoteModal').classList.remove('hidden')"
                        class="bg-yellow-500 text-white px-4 py-2 rounded-lg hover:bg-yellow-600 transition text-sm">
                    <i class="fas fa-plus mr-1"></i>Agregar Nota
                </button>
            </div>
            <?php if (!empty($notes)): ?>
            <div class="space-y-3">
                <?php foreach ($notes as $note): ?>
                <div class="p-4 rounded-lg <?= $note['is_important'] ? 'bg-red-50 border-l-4 border-red-500' : 'bg-gray-50' ?>">
                    <div class="flex justify-between items-start mb-2">
                        <p class="font-semibold text-gray-800">
                            <?php if ($note['is_important']): ?>
                            <i class="fas fa-exclamation-triangle text-red-600 mr-2"></i>
                            <?php endif; ?>
                            <?= htmlspecialchars($note['created_by_name'] ?? 'Usuario') ?>
                        </p>
                        <span class="text-xs text-gray-500"><?= date('d/m/Y H:i', strtotime($note['created_at'])) ?></span>
                    </div>
                    <p class="text-gray-700 whitespace-pre-wrap"><?= htmlspecialchars($note['note']) ?></p>
                </div>
                <?php endforeach; ?>
            </div>
            <?php else: ?>
            <p class="text-gray-500 text-center py-8">No hay notas registradas</p>
            <?php endif; ?>
        </div>

        <!-- Historial de Cambios -->
        <?php if (!empty($history)): ?>
        <div class="bg-white rounded-lg shadow p-6">
            <h3 class="text-xl font-bold text-gray-800 mb-4">
                <i class="fas fa-history text-purple-600 mr-2"></i>Historial de Cambios
            </h3>
            <div class="space-y-3">
                <?php foreach ($history as $h): ?>
                <div class="flex items-start space-x-3 p-3 bg-gray-50 rounded-lg">
                    <i class="fas fa-circle text-purple-500 text-xs mt-1.5"></i>
                    <div class="flex-1">
                        <p class="text-sm text-gray-800">
                            <strong><?= htmlspecialchars($h['changed_by_name'] ?? 'Sistema') ?></strong>
                            cambió el estatus a
                            <strong class="text-purple-700"><?= htmlspecialchars($h['new_status']) ?></strong>
                        </p>
                        <p class="text-xs text-gray-500"><?= date('d/m/Y H:i', strtotime($h['created_at'])) ?></p>
                        <?php if (!empty($h['notes'])): ?>
                        <p class="text-sm text-gray-600 mt-1 italic"><?= htmlspecialchars($h['notes']) ?></p>
                        <?php endif; ?>
                    </div>
                </div>
                <?php endforeach; ?>
            </div>
        </div>
        <?php endif; ?>

    </div>

    <!-- COLUMNA LATERAL -->
    <div class="space-y-6">

        <!-- Cambiar Estatus -->
        <?php if ($isAdmin): ?>
        <div class="bg-white rounded-lg shadow p-6">
            <h3 class="text-lg font-bold text-gray-800 mb-4">Cambiar Estatus</h3>
            <form method="POST" action="<?= BASE_URL ?>/solicitudes/cambiar-estatus/<?= $application['id'] ?>">
                <div class="mb-4">
                    <label class="block text-sm font-medium text-gray-700 mb-2">Nuevo Estatus</label>
                    <select name="new_status" required
                            class="w-full border border-gray-300 rounded-lg px-3 py-2 focus:outline-none focus:ring-2 focus:ring-blue-500">
                        <option value="">-- Seleccionar --</option>
                        <option value="nuevo" <?= $status === 'nuevo' ? 'selected' : '' ?>>Nuevo</option>
                        <option value="en_proceso" <?= $status === 'en_proceso' ? 'selected' : '' ?>>En Proceso</option>
                        <option value="completado" <?= $status === 'completado' ? 'selected' : '' ?>>Completado</option>
                        <option value="cerrado" <?= $status === 'cerrado' ? 'selected' : '' ?>>Cerrado</option>
                    </select>
                </div>
                <div class="mb-4">
                    <label class="block text-sm font-medium text-gray-700 mb-2">Notas (opcional)</label>
                    <textarea name="notes" rows="3"
                              class="w-full border border-gray-300 rounded-lg px-3 py-2 focus:outline-none focus:ring-2 focus:ring-blue-500"
                              placeholder="Motivo del cambio..."></textarea>
                </div>
                <button type="submit"
                        class="w-full bg-blue-600 text-white px-4 py-2 rounded-lg hover:bg-blue-700 transition">
                    <i class="fas fa-exchange-alt mr-2"></i>Actualizar Estatus
                </button>
            </form>
        </div>
        <?php endif; ?>

        <!-- Subir Documento -->
        <div class="bg-white rounded-lg shadow p-6">
            <h3 class="text-lg font-bold text-gray-800 mb-4">Subir Documento</h3>
            <form method="POST" action="<?= BASE_URL ?>/solicitudes/subir-documento/<?= $application['id'] ?>"
                  enctype="multipart/form-data">
                <div class="mb-4">
                    <label class="block text-sm font-medium text-gray-700 mb-2">Archivo</label>
                    <input type="file" name="document" required accept=".pdf,.jpg,.jpeg,.png,.doc,.docx"
                           class="w-full border border-gray-300 rounded-lg px-3 py-2 text-sm focus:outline-none focus:ring-2 focus:ring-blue-500">
                    <p class="text-xs text-gray-500 mt-1">PDF, JPG, PNG, DOC (máx 10MB)</p>
                </div>
                <div class="mb-4">
                    <label class="block text-sm font-medium text-gray-700 mb-2">Descripción (opcional)</label>
                    <input type="text" name="description"
                           class="w-full border border-gray-300 rounded-lg px-3 py-2 text-sm focus:outline-none focus:ring-2 focus:ring-blue-500"
                           placeholder="Descripción del documento">
                </div>
                <button type="submit"
                        class="w-full bg-green-600 text-white px-4 py-2 rounded-lg hover:bg-green-700 transition">
                    <i class="fas fa-upload mr-2"></i>Subir Documento
                </button>
            </form>
        </div>

    </div>
</div>

<!-- Modal: Agregar Nota -->
<div id="addNoteModal" class="hidden fixed inset-0 bg-gray-900 bg-opacity-50 flex items-center justify-center z-50">
    <div class="bg-white rounded-lg shadow-xl p-6 w-full max-w-md">
        <h3 class="text-xl font-bold text-gray-800 mb-4">Agregar Nota</h3>
        <form method="POST" action="<?= BASE_URL ?>/solicitudes/agregar-nota/<?= $application['id'] ?>">
            <div class="mb-4">
                <label class="block text-sm font-medium text-gray-700 mb-2">Nota</label>
                <textarea name="note" rows="4" required
                          class="w-full border border-gray-300 rounded-lg px-3 py-2 focus:outline-none focus:ring-2 focus:ring-blue-500"></textarea>
            </div>
            <div class="mb-4">
                <label class="flex items-center">
                    <input type="checkbox" name="is_important" value="1" class="mr-2">
                    <span class="text-sm text-gray-700">Marcar como importante</span>
                </label>
            </div>
            <div class="flex space-x-3">
                <button type="button" onclick="document.getElementById('addNoteModal').classList.add('hidden')"
                        class="flex-1 bg-gray-500 text-white px-4 py-2 rounded-lg hover:bg-gray-600 transition">
                    Cancelar
                </button>
                <button type="submit"
                        class="flex-1 bg-yellow-500 text-white px-4 py-2 rounded-lg hover:bg-yellow-600 transition">
                    Guardar
                </button>
            </div>
        </form>
    </div>
</div>

<?php
$content = ob_get_clean();
require __DIR__ . '/../layouts/main.php';
?>
