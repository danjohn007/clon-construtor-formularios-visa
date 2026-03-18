<?php 
// Determinar si es modo embebido
$isEmbedded = isset($_GET['embed']) && $_GET['embed'] == '1';
// Obtener información de contacto de configuración global
$contactInfo = [
    'phone_main' => '512.259.2771',
    'phone_direct' => '512.233.8827',
    'email' => '1txlandscape@gmail.com',
    'company' => htmlspecialchars($form['creator_name'] ?? 'Landscape in Austin')
];
?>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><?= htmlspecialchars($form['name']) ?></title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        :root {
            --primary-green: #7CFC00;
            --primary-dark: #1a1a1a;
            --secondary-dark: #2d2d2d;
        }
        
        body {
            font-family: 'Inter', 'system-ui', -apple-system, sans-serif;
        }
        
        .form-field-required:after {
            content: "*";
            color: #ff4444;
            margin-left: 4px;
        }
        
        /* Custom styling for radio buttons */
        .custom-radio {
            appearance: none;
            -webkit-appearance: none;
            width: 16px;
            height: 16px;
            border: 2px solid #d1d5db;
            border-radius: 50%;
            outline: none;
            cursor: pointer;
            position: relative;
            transition: all 0.2s ease;
            flex-shrink: 0;
        }
        
        .custom-radio:checked {
            border-color: var(--primary-green);
            background-color: transparent;
        }
        
        .custom-radio:checked::after {
            content: '';
            position: absolute;
            width: 8px;
            height: 8px;
            background-color: var(--primary-green);
            border-radius: 50%;
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%);
        }
        
        /* Button styles */
        .btn-primary {
            background: var(--primary-green);
            color: #000;
            font-weight: 600;
            transition: all 0.3s ease;
        }
        
        .btn-primary:hover {
            background: #6cd800;
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(124, 252, 0, 0.3);
        }
        
        .btn-secondary {
            background: transparent;
            border: 2px solid #e5e7eb;
            color: #6b7280;
            font-weight: 600;
        }
        
        .btn-secondary:hover {
            border-color: #d1d5db;
            background: #f9fafb;
        }
        
        /* Input styles */
        .form-input {
            border: 2px solid #e5e7eb;
            border-radius: 6px;
            padding: 10px 14px;
            font-size: 13px;
            transition: all 0.2s ease;
        }
        
        .form-input:focus {
            outline: none;
            border-color: var(--primary-green);
            box-shadow: 0 0 0 3px rgba(124, 252, 0, 0.1);
        }
        
        /* Form container with scroll */
        .form-scroll-container {
            max-height: calc(100vh - 2rem);
            overflow-y: auto;
            padding-right: 8px;
        }
        
        /* Custom scrollbar */
        .form-scroll-container::-webkit-scrollbar {
            width: 8px;
        }
        
        .form-scroll-container::-webkit-scrollbar-track {
            background: #f1f1f1;
            border-radius: 4px;
        }
        
        .form-scroll-container::-webkit-scrollbar-thumb {
            background: #888;
            border-radius: 4px;
        }
        
        .form-scroll-container::-webkit-scrollbar-thumb:hover {
            background: #555;
        }
        
        /* Sidebar */
        .sidebar {
            background: var(--primary-dark);
            color: white;
        }
        
        .sidebar-highlight {
            color: var(--primary-green);
        }
        
        /* Step indicator */
        .step-badge {
            color: var(--primary-green);
            font-weight: 700;
            font-size: 12px;
            letter-spacing: 1px;
        }
        
        /* Progress bar */
        .progress-bar-fill {
            background: var(--primary-green);
            transition: width 0.3s ease;
        }
        
        /* Embedded mode adjustments */
        .embedded-mode {
            max-width: 100%;
            padding: 0;
        }
        
        .embedded-mode .sidebar {
            display: none;
        }
    </style>
</head>
<body class="<?= $isEmbedded ? 'bg-white' : 'bg-gray-50' ?>">
    <div class="<?= $isEmbedded ? 'embedded-mode' : 'min-h-screen flex' ?>">
        
        <?php if (!$isEmbedded): ?>
        <!-- Sidebar -->
        <div class="sidebar w-full lg:w-96 p-8 flex flex-col justify-between">
            <div>
                <div class="mb-12">
                    <h2 class="text-2xl font-bold mb-2">
                        GET YOUR <span class="sidebar-highlight">CUSTOM QUOTE</span>
                    </h2>
                    <div class="w-16 h-1 bg-white"></div>
                </div>
                
                <!-- Contact Information -->
                <div class="space-y-6 mb-12">
                    <div>
                        <p class="sidebar-highlight text-sm mb-3 uppercase tracking-wider">Call for a Free Quote</p>
                        
                        <div class="space-y-3">
                            <div class="flex items-center space-x-3">
                                <i class="fas fa-phone sidebar-highlight"></i>
                                <div>
                                    <p class="text-2xl font-bold"><?= $contactInfo['phone_main'] ?></p>
                                    <p class="text-gray-400 text-sm">MAIN OFFICE</p>
                                </div>
                            </div>
                            
                            <div class="flex items-center space-x-3">
                                <i class="fas fa-mobile-alt sidebar-highlight"></i>
                                <div>
                                    <p class="text-2xl font-bold"><?= $contactInfo['phone_direct'] ?></p>
                                    <p class="text-gray-400 text-sm">DIRECT LINE</p>
                                </div>
                            </div>
                        </div>
                    </div>
                    
                    <div>
                        <p class="sidebar-highlight text-sm mb-3 uppercase tracking-wider">Email Us</p>
                        <div class="flex items-center space-x-3">
                            <i class="fas fa-envelope sidebar-highlight"></i>
                            <a href="mailto:<?= $contactInfo['email'] ?>" class="text-lg hover:text-green-400 transition">
                                <?= $contactInfo['email'] ?>
                            </a>
                        </div>
                    </div>
                </div>
                
                <!-- Consultation Notice -->
                <div class="bg-gray-800 bg-opacity-50 rounded-lg p-4 border border-gray-700">
                    <div class="flex items-start space-x-3">
                        <i class="fas fa-lightbulb sidebar-highlight text-xl mt-1"></i>
                        <div>
                            <p class="font-bold mb-1 sidebar-highlight">CONSULTATION EFFICIENCY</p>
                            <p class="text-gray-300 text-sm">
                                Email us <span class="sidebar-highlight">photos, survey or a sketch</span> of your 
                                property to make the process faster and more efficient.
                            </p>
                        </div>
                    </div>
                </div>
            </div>
            
            <!-- Footer Badge -->
            <div class="mt-8 pt-6 border-t border-gray-700">
                <div class="flex items-center space-x-3 mb-2">
                    <span class="bg-green-500 text-black px-3 py-1 rounded text-xs font-bold">LI#20334</span>
                    <span class="text-gray-400 text-sm">LICENSED IRRIGATOR</span>
                </div>
                <p class="text-gray-400 text-sm">FAMILY OWNED & OPERATED</p>
                <p class="text-white font-bold text-sm">FULLY INSURED FOR YOUR PROTECTION</p>
            </div>
        </div>
        <?php endif; ?>
        
        <!-- Main Form Content -->
        <div class="flex-1 <?= $isEmbedded ? 'p-4' : 'p-6 lg:p-10' ?>">
            <div class="form-scroll-container">
            <?php if (!empty($alreadyCompleted)): ?>
            <!-- Already completed message -->
            <div class="bg-green-50 border-l-4 border-green-500 p-6 mb-6 rounded-lg max-w-4xl mx-auto">
                <div class="flex items-center">
                    <i class="fas fa-check-circle text-green-500 text-3xl mr-4"></i>
                    <div>
                        <h3 class="text-lg font-bold text-green-800">¡Formulario completado!</h3>
                        <p class="text-green-700">Gracias por completar este formulario.</p>
                    </div>
                </div>
            </div>
            <?php else: ?>
            
            <div class="max-w-4xl mx-auto">
                <!-- Step Indicator -->
                <?php if ($form['pagination_enabled'] && $pages): ?>
                <div class="mb-6">
                    <p class="step-badge mb-2">STEP <span id="current-step-number">01</span></p>
                    <h1 class="text-2xl font-bold text-gray-900 mb-3" id="step-title">
                        <?= htmlspecialchars($pages[0]['name'] ?? $form['name']) ?>
                    </h1>
                    
                    <!-- Progress Bar -->
                    <div class="w-full bg-gray-200 rounded-full h-2 mb-6">
                        <div id="progress-bar" class="progress-bar-fill h-2 rounded-full" style="width: 0%"></div>
                    </div>
                </div>
                <?php else: ?>
                <div class="mb-6">
                    <h1 class="text-2xl font-bold text-gray-900 mb-2"><?= htmlspecialchars($form['name']) ?></h1>
                    <?php if (!empty($form['description'])): ?>
                    <p class="text-sm text-gray-600"><?= htmlspecialchars($form['description']) ?></p>
                    <?php endif; ?>
                </div>
                <?php endif; ?>
                
                <!-- Success Message -->
                <div id="success-message" class="hidden bg-green-50 border-l-4 border-green-500 p-6 mb-6 rounded-lg">
                    <div class="flex items-center">
                        <i class="fas fa-check-circle text-green-500 text-3xl mr-4"></i>
                        <div>
                            <h3 class="text-lg font-bold text-green-800">¡Formulario Enviado Exitosamente!</h3>
                            <p class="text-green-700">Gracias por completar el formulario. Te contactaremos pronto.</p>
                        </div>
                    </div>
                </div>
                
                <!-- Form -->
                <form id="public-form" class="space-y-4">
                    <!-- Campos ocultos sin name para que no se envíen en la validación -->
                    <input type="hidden" id="submission-id" value="">
                    <input type="hidden" id="current-page" value="1">
                    
                    <?php foreach ($fields['fields'] as $field): ?>
                    <?php
                        // Preparar atributos para campos condicionales
                        $showWhenAttr = '';
                        $conditionalStyle = '';
                        if (isset($field['showWhen']) && !empty($field['showWhen']['fieldId'])) {
                            $showWhenAttr = sprintf(
                                'data-show-when=\'%s\'',
                                htmlspecialchars(json_encode($field['showWhen']), ENT_QUOTES, 'UTF-8')
                            );
                            // Ocultar por defecto los campos condicionales
                            $conditionalStyle = 'style="display: none;"';
                        }
                    ?>
                    <div class="form-field" data-field-id="<?= htmlspecialchars($field['id']) ?>" data-field-label="<?= htmlspecialchars($field['label'] ?? $field['id']) ?>" <?= $showWhenAttr ?> <?= $conditionalStyle ?> data-page="<?php
                        // Find which page this field belongs to
                        $pageAssigned = false;
                        if (!empty($form['pagination_enabled']) && !empty($pages)) {
                            foreach ($pages as $page) {
                                if (in_array($field['id'], $page['fieldIds'])) {
                                    echo $page['id'];
                                    $pageAssigned = true;
                                    break;
                                }
                            }
                            if (!$pageAssigned) {
                                echo '1';
                            }
                        } else {
                            echo '1';
                        }
                    ?>">
                        <?php if ($field['type'] === 'label'): ?>
                            <!-- Encabezado/Separador de sección -->
                            <h3 class="text-base font-bold text-gray-900 mb-3 pb-2 border-b border-gray-300 flex items-center uppercase tracking-wide">
                                <i class="fas fa-bookmark text-green-500 mr-2 text-sm"></i>
                                <?= htmlspecialchars($field['label']) ?>
                            </h3>
                        <?php else: ?>
                            <label class="block text-xs font-semibold text-gray-600 mb-1.5 <?= !empty($field['required']) ? 'form-field-required' : '' ?>">
                                <?= htmlspecialchars($field['label']) ?>
                            </label>
                        
                            <?php if ($field['type'] === 'text' || $field['type'] === 'email' || $field['type'] === 'tel'): ?>
                                <input type="<?= htmlspecialchars($field['type']) ?>" 
                                       name="<?= htmlspecialchars($field['id']) ?>"
                                       id="field_<?= htmlspecialchars($field['id']) ?>"
                                       data-label="<?= htmlspecialchars($field['label']) ?>"
                                       <?= !empty($field['required']) ? 'required' : '' ?>
                                       class="form-input w-full"
                                       placeholder="">
                            
                            <?php elseif ($field['type'] === 'number'): ?>
                                <input type="number" 
                                       name="<?= htmlspecialchars($field['id']) ?>"
                                       id="field_<?= htmlspecialchars($field['id']) ?>"
                                       data-label="<?= htmlspecialchars($field['label']) ?>"
                                       <?= !empty($field['required']) ? 'required' : '' ?>
                                       class="form-input w-full">
                            
                            <?php elseif ($field['type'] === 'date'): ?>
                                <input type="date" 
                                       name="<?= htmlspecialchars($field['id']) ?>"
                                       id="field_<?= htmlspecialchars($field['id']) ?>"
                                       data-label="<?= htmlspecialchars($field['label']) ?>"
                                       <?= !empty($field['required']) ? 'required' : '' ?>
                                       class="form-input w-full">
                            
                            <?php elseif ($field['type'] === 'textarea'): ?>
                                <textarea name="<?= htmlspecialchars($field['id']) ?>"
                                          id="field_<?= htmlspecialchars($field['id']) ?>"
                                          data-label="<?= htmlspecialchars($field['label']) ?>"
                                          <?= !empty($field['required']) ? 'required' : '' ?>
                                          rows="4"
                                          class="form-input w-full resize-none"
                                          placeholder="<?= htmlspecialchars($field['label']) ?>"></textarea>
                            
                            <?php elseif ($field['type'] === 'select'): ?>
                                <div class="grid grid-cols-1 md:grid-cols-2 gap-3">
                                    <?php foreach ($field['options'] ?? [] as $option): ?>
                                    <label class="flex items-center p-3 border-2 border-gray-200 rounded-lg cursor-pointer hover:border-gray-300 transition">
                                        <input type="radio" 
                                               name="<?= htmlspecialchars($field['id']) ?>"
                                               value="<?= htmlspecialchars($option) ?>"
                                               data-label="<?= htmlspecialchars($field['label']) ?>"
                                               <?= !empty($field['required']) ? 'required' : '' ?>
                                               class="custom-radio">
                                        <span class="ml-3 text-gray-700 font-medium uppercase text-xs tracking-wide">
                                            <?= htmlspecialchars($option) ?>
                                        </span>
                                    </label>
                                    <?php endforeach; ?>
                                </div>
                            
                            <?php elseif ($field['type'] === 'checkbox'): ?>
                                <div class="flex items-center p-4 border-2 border-gray-200 rounded-lg">
                                    <input type="checkbox" 
                                           name="<?= htmlspecialchars($field['id']) ?>"
                                           id="field_<?= htmlspecialchars($field['id']) ?>"
                                           data-label="<?= htmlspecialchars($field['label']) ?>"
                                           <?= !empty($field['required']) ? 'required' : '' ?>
                                           class="w-5 h-5 text-green-500 rounded focus:ring-green-500">
                                    <label for="field_<?= htmlspecialchars($field['id']) ?>" class="ml-3 text-sm text-gray-700 font-medium">
                                        <?= htmlspecialchars($field['label']) ?>
                                    </label>
                                </div>
                            
                            <?php elseif ($field['type'] === 'file'): ?>
                                <?php $isMultiple = !empty($field['multiple']); ?>
                                <input type="file" 
                                       name="<?= htmlspecialchars($field['id']) ?><?= $isMultiple ? '[]' : '' ?>"
                                       id="field_<?= htmlspecialchars($field['id']) ?>"
                                       data-label="<?= htmlspecialchars($field['label']) ?>"
                                       <?= $isMultiple ? 'multiple' : '' ?>
                                       accept=".pdf,.jpg,.jpeg,.png,.doc,.docx,.txt,.xlsx,.xls"
                                       <?= !empty($field['required']) ? 'required' : '' ?>
                                       class="form-input w-full file:mr-4 file:py-2 file:px-4 file:rounded-full file:border-0 file:text-sm file:font-semibold file:bg-green-50 file:text-green-700 hover:file:bg-green-100">
                                <p class="text-xs text-gray-500 mt-2">
                                    <i class="fas fa-info-circle"></i> Formatos: PDF, JPG, PNG, DOC, DOCX (Máx. 10MB)
                                </p>
                            <?php endif; ?>
                        <?php endif; ?>
                    </div>
                    <?php endforeach; ?>
                    
                    <!-- Auto-save status -->
                    <div id="autosave-status" class="text-sm text-gray-500 text-center hidden">
                        <i class="fas fa-cloud-upload-alt mr-1"></i>
                        <span id="autosave-text">Guardando...</span>
                    </div>
                    
                    <!-- Action Buttons -->
                    <div class="flex justify-between items-center pt-6 border-t">
                        <button type="button" id="prev-page-btn" 
                                class="btn-secondary px-6 py-2.5 rounded-lg text-sm hidden">
                            BACK
                        </button>
                        
                        <div class="flex gap-3 ml-auto">
                            <button type="button" id="save-draft-btn" 
                                    class="btn-secondary px-5 py-2.5 rounded-lg text-sm hidden md:block">
                                <i class="fas fa-save mr-2"></i>SAVE DRAFT
                            </button>
                            
                            <button type="button" id="next-page-btn"
                                    class="btn-primary px-6 py-2.5 rounded-lg text-sm hidden">
                                CONTINUE <i class="fas fa-arrow-right ml-2"></i>
                            </button>
                            
                            <button type="submit" id="submit-btn"
                                    class="btn-primary px-6 py-2.5 rounded-lg text-sm">
                                SUBMIT <i class="fas fa-arrow-right ml-2"></i>
                            </button>
                        </div>
                    </div>
                </form>
                
                <!-- Footer Info -->
                <div class="text-center mt-12 text-sm text-gray-500">
                    <p><i class="fas fa-lock mr-1"></i>Tus datos están protegidos y seguros</p>
                </div>
            </div>
            <?php endif; ?>
            </div> <!-- Close form-scroll-container -->
        </div>
    </div>

    <script>
        document.addEventListener('DOMContentLoaded', function() {
            console.log('🚀 Inicializando formulario del sistema...');
            
            const form = document.getElementById('public-form');
            const submitBtn = document.getElementById('submit-btn');
            const saveDraftBtn = document.getElementById('save-draft-btn');
            const prevPageBtn = document.getElementById('prev-page-btn');
            const nextPageBtn = document.getElementById('next-page-btn');
            const autosaveStatus = document.getElementById('autosave-status');
            const autosaveText = document.getElementById('autosave-text');
            const successMessage = document.getElementById('success-message');
            const submissionIdInput = document.getElementById('submission-id');
            const currentPageInput = document.getElementById('current-page');
        
        // Configuration
        const AUTOSAVE_DELAY_MS = 3000;
        const paginationEnabled = <?= json_encode($form['pagination_enabled'] ?? false) ?>;
        const pages = <?= json_encode($pages ?? []) ?>;
        const FORM_ID = '<?= $formId ?>';
        const LOCALSTORAGE_KEY = `form_draft_${FORM_ID}`;
        
        let currentPage = 1;
        let visiblePages = [];
        let autosaveTimeout;
        
        // ==========================================
        // CONDITIONAL FIELDS MANAGER
        // ==========================================
        const conditionalManager = {
            fields: [],
            
            init() {
                console.log('🔗 Inicializando ConditionalFieldsManager...');
                const els = document.querySelectorAll('[data-show-when]');
                console.log('📋 Campos condicionales encontrados:', els.length);
                
                els.forEach(el => {
                    try {
                        const sw = JSON.parse(el.getAttribute('data-show-when'));
                        if (sw && sw.fieldId && sw.value) {
                            this.fields.push({
                                element: el,
                                parentFieldId: sw.fieldId,
                                requiredValue: sw.value,
                                fieldId: el.getAttribute('data-field-id'),
                                page: parseInt(el.getAttribute('data-page')) || 1
                            });
                        }
                    } catch(e) { console.error('Error parsing showWhen:', e); }
                });
                
                // Ocultar todos los condicionales
                this.fields.forEach(f => {
                    f.element.style.display = 'none';
                    f.element.classList.add('conditional-hidden');
                });
                
                // Listeners en campos padre
                const parentIds = [...new Set(this.fields.map(f => f.parentFieldId))];
                console.log('🎯 Campos padre:', parentIds);
                parentIds.forEach(pid => {
                    document.querySelectorAll(`input[name="${pid}"]`).forEach(radio => {
                        radio.addEventListener('change', () => {
                            console.log(`🔄 Cambio: "${pid}" → "${radio.value}"`);
                            // Limpiar valores de campos que se van a ocultar
                            this.fields.filter(f => f.parentFieldId === pid).forEach(f => {
                                if (radio.value !== f.requiredValue) {
                                    this.clearFieldValues(f.element);
                                }
                            });
                            // Recalcular páginas visibles y refrescar vista actual
                            recalculateVisiblePages();
                            showPage(currentPage);
                        });
                    });
                });
            },
            
            shouldShowField(fieldDiv) {
                if (!fieldDiv.hasAttribute('data-show-when')) return true;
                try {
                    const sw = JSON.parse(fieldDiv.getAttribute('data-show-when'));
                    return this.getFieldValue(sw.fieldId) === sw.value;
                } catch(e) { return false; }
            },
            
            getFieldValue(fieldId) {
                const radio = document.querySelector(`input[name="${fieldId}"]:checked`);
                if (radio) return radio.value;
                const input = document.getElementById(`field_${fieldId}`);
                if (input) return input.type === 'checkbox' ? (input.checked ? 'true' : 'false') : input.value;
                return null;
            },
            
            clearFieldValues(container) {
                container.querySelectorAll('input:not([type="hidden"]), textarea').forEach(input => {
                    if (input.type === 'checkbox' || input.type === 'radio') input.checked = false;
                    else input.value = '';
                    input.classList.remove('border-red-500');
                });
            }
        };
        window.conditionalManager = conditionalManager;
        
        // ==========================================
        // PAGINACIÓN DINÁMICA (salta páginas vacías)
        // ==========================================
        function recalculateVisiblePages() {
            if (!paginationEnabled) { visiblePages = [1]; return; }
            
            const pagesWithContent = new Set();
            document.querySelectorAll('.form-field').forEach(field => {
                const page = parseInt(field.dataset.page) || 1;
                if (conditionalManager.shouldShowField(field)) {
                    pagesWithContent.add(page);
                }
            });
            visiblePages = Array.from(pagesWithContent).sort((a, b) => a - b);
            if (visiblePages.length === 0) visiblePages = [1];
            console.log('📄 Páginas visibles:', visiblePages);
        }
        
        function showPage(pageNum) {
            // Si la página ya no es visible, ir a la más cercana
            if (paginationEnabled && !visiblePages.includes(pageNum)) {
                const closest = visiblePages.reduce((prev, curr) => 
                    Math.abs(curr - pageNum) < Math.abs(prev - pageNum) ? curr : prev, visiblePages[0]);
                pageNum = closest;
            }
            
            currentPage = pageNum;
            currentPageInput.value = pageNum;
            
            // Ocultar todos los campos
            document.querySelectorAll('.form-field').forEach(f => f.style.display = 'none');
            
            if (paginationEnabled) {
                // Mostrar solo campos de esta página cuya condición se cumple
                document.querySelectorAll(`[data-page="${pageNum}"]`).forEach(field => {
                    if (conditionalManager.shouldShowField(field)) {
                        field.style.display = 'block';
                        field.classList.remove('conditional-hidden');
                    }
                });
            } else {
                // Sin paginación: mostrar todos los que deben ser visibles
                document.querySelectorAll('.form-field').forEach(field => {
                    if (conditionalManager.shouldShowField(field)) {
                        field.style.display = 'block';
                        field.classList.remove('conditional-hidden');
                    }
                });
            }
            
            updateStepIndicator();
            updateNavigation();
            updateProgress();
        }
        
        function updateStepIndicator() {
            const stepNumber = document.getElementById('current-step-number');
            const stepTitle = document.getElementById('step-title');
            const visibleIndex = visiblePages.indexOf(currentPage);
            
            if (stepNumber) stepNumber.textContent = (visibleIndex + 1).toString().padStart(2, '0');
            if (stepTitle && pages[currentPage - 1]) stepTitle.textContent = pages[currentPage - 1].name;
        }
        
        function updateNavigation() {
            if (!paginationEnabled) {
                if (prevPageBtn) prevPageBtn.classList.add('hidden');
                if (nextPageBtn) nextPageBtn.classList.add('hidden');
                submitBtn.classList.remove('hidden');
                return;
            }
            
            const idx = visiblePages.indexOf(currentPage);
            const isFirst = idx <= 0;
            const isLast = idx >= visiblePages.length - 1;
            
            if (prevPageBtn) prevPageBtn.classList.toggle('hidden', isFirst);
            if (nextPageBtn) nextPageBtn.classList.toggle('hidden', isLast);
            submitBtn.classList.toggle('hidden', !isLast);
        }
        
        function updateProgress() {
            const bar = document.getElementById('progress-bar');
            if (bar && visiblePages.length > 0) {
                const idx = visiblePages.indexOf(currentPage);
                bar.style.width = ((idx + 1) / visiblePages.length * 100) + '%';
            }
        }
        
        // ==========================================
        // VALIDACIÓN
        // ==========================================
        function validateCurrentPage() {
            let isValid = true;
            let firstInvalid = null;
            
            document.querySelectorAll(`[data-page="${currentPage}"]`).forEach(fieldDiv => {
                if (fieldDiv.style.display === 'none') return;
                
                fieldDiv.querySelectorAll('input:not([type="hidden"]), textarea').forEach(input => {
                    input.classList.remove('border-red-500');
                    
                    if (input.hasAttribute('required')) {
                        if (input.type === 'radio') {
                            if (!document.querySelector(`input[name="${input.name}"]:checked`)) {
                                input.classList.add('border-red-500');
                                isValid = false;
                                if (!firstInvalid) firstInvalid = input;
                            }
                            return;
                        }
                        if (input.type === 'file') {
                            if (input.files.length === 0) {
                                input.classList.add('border-red-500');
                                isValid = false;
                                if (!firstInvalid) firstInvalid = input;
                            }
                            return;
                        }
                        if (!input.value.trim()) {
                            input.classList.add('border-red-500');
                            isValid = false;
                            if (!firstInvalid) firstInvalid = input;
                            return;
                        }
                    }
                    
                    if (input.type === 'email' && input.value) {
                        if (!/^[a-z0-9._%+\-]+@[a-z0-9.\-]+\.[a-z]{2,}$/i.test(input.value)) {
                            input.classList.add('border-red-500');
                            isValid = false;
                            if (!firstInvalid) firstInvalid = input;
                        }
                    }
                    
                    if (input.type === 'tel' && input.value) {
                        if (!/[\(]?[0-9]{3}[\)]?[-\s\.]?[0-9]{3}[-\s\.]?[0-9]{4}/.test(input.value)) {
                            input.classList.add('border-red-500');
                            isValid = false;
                            if (!firstInvalid) firstInvalid = input;
                        }
                    }
                });
            });
            
            if (!isValid && firstInvalid) {
                firstInvalid.focus();
                firstInvalid.scrollIntoView({ behavior: 'smooth', block: 'center' });
            }
            return isValid;
        }
        
        // ==========================================
        // LOCALSTORAGE DRAFT (preserved from original)
        // ==========================================
        function saveDraftToLocalStorage() {
            try {
                const formData = new FormData(form);
                const data = Object.fromEntries(formData.entries());
                localStorage.setItem(LOCALSTORAGE_KEY, JSON.stringify(data));
            } catch (error) {
                console.error('Error saving to localStorage:', error);
            }
        }
        
        function loadDraftFromLocalStorage() {
            try {
                const savedData = localStorage.getItem(LOCALSTORAGE_KEY);
                if (savedData) {
                    const data = JSON.parse(savedData);
                    for (const [key, value] of Object.entries(data)) {
                        const field = form.querySelector(`[name="${key}"]`);
                        if (field) {
                            if (field.type === 'checkbox') {
                                field.checked = value === 'on' || value === 'Yes';
                            } else if (field.type === 'radio') {
                                const radio = form.querySelector(`[name="${key}"][value="${value}"]`);
                                if (radio) radio.checked = true;
                            } else {
                                field.value = value;
                            }
                        }
                    }
                }
            } catch (error) {
                console.error('Error loading from localStorage:', error);
            }
        }
        
        // ==========================================
        // SUBMIT - Usa FormData para soportar archivos
        // ==========================================
        function saveFormData(isCompleted, callback, errorCallback) {
            submitBtn.disabled = true;
            if (saveDraftBtn) saveDraftBtn.disabled = true;
            
            if (isCompleted) {
                submitBtn.innerHTML = '<i class="fas fa-spinner fa-spin mr-2"></i>SENDING...';
            } else {
                autosaveStatus.classList.remove('hidden');
                autosaveText.textContent = 'Guardando...';
            }
            
            const newFormData = new FormData();
            
            // Metadata
            newFormData.append('form_source', 'constructor');
            const formIdInput = form.querySelector('[name="form_id"]');
            if (formIdInput) newFormData.append('form_id', formIdInput.value);
            if (submissionIdInput && submissionIdInput.value) {
                newFormData.append('submissionId', submissionIdInput.value);
            }
            newFormData.append('currentPage', currentPageInput.value);
            
            // Recolectar campos de TODAS las páginas cuya condición se cumple
            const addedRadioGroups = new Set();
            
            document.querySelectorAll('.form-field').forEach(fieldDiv => {
                if (!conditionalManager.shouldShowField(fieldDiv)) return;
                
                fieldDiv.querySelectorAll('input:not([type="hidden"]), textarea, select').forEach(input => {
                    const label = input.getAttribute('data-label') || input.name;
                    
                    if (input.type === 'file') {
                        if (input.files.length > 0) {
                            for (let i = 0; i < input.files.length; i++) {
                                newFormData.append(input.multiple ? label + '[]' : label, input.files[i]);
                            }
                        }
                    } else if (input.type === 'checkbox') {
                        if (input.checked) {
                            newFormData.append(label, 'Yes');
                        }
                    } else if (input.type === 'radio') {
                        if (!addedRadioGroups.has(input.name)) {
                            const checked = document.querySelector(`input[name="${input.name}"]:checked`);
                            if (checked) {
                                newFormData.append(label, checked.value);
                                addedRadioGroups.add(input.name);
                            }
                        }
                    } else {
                        if (input.value.trim()) {
                            newFormData.append(label, input.value);
                        }
                    }
                });
            });
            
            console.log('📦 Enviando formulario con FormData (soporta archivos)...');
            
            fetch('/send_quote.php', {
                method: 'POST',
                body: newFormData
            })
            .then(response => response.json())
            .then(result => {
                if (result.status === 'success' || result.success) {
                    if (isCompleted) {
                        try {
                            localStorage.removeItem(LOCALSTORAGE_KEY);
                        } catch (error) {
                            console.error('Error clearing localStorage:', error);
                        }
                        
                        form.style.display = 'none';
                        successMessage.classList.remove('hidden');
                    } else {
                        autosaveText.textContent = '✓ Guardado';
                        setTimeout(() => {
                            autosaveStatus.classList.add('hidden');
                        }, 2000);
                    }
                    
                    if (callback) callback();
                } else {
                    alert('Error: ' + (result.message || 'No se pudo enviar el formulario'));
                    if (errorCallback) errorCallback();
                }
            })
            .catch(error => {
                console.error('Error:', error);
                alert('Error al enviar el formulario. Por favor, intenta de nuevo.');
                if (errorCallback) errorCallback();
            })
            .finally(() => {
                submitBtn.disabled = false;
                submitBtn.innerHTML = 'SUBMIT <i class="fas fa-arrow-right ml-2"></i>';
                if (saveDraftBtn) saveDraftBtn.disabled = false;
            });
        }
        
        // ==========================================
        // EVENT LISTENERS
        // ==========================================
        form.addEventListener('input', function(e) {
            if (e.target.classList) e.target.classList.remove('border-red-500');
            clearTimeout(autosaveTimeout);
            autosaveTimeout = setTimeout(function() {
                saveDraftToLocalStorage();
            }, AUTOSAVE_DELAY_MS);
        });
        
        if (saveDraftBtn) {
            saveDraftBtn.addEventListener('click', function() {
                saveDraftToLocalStorage();
                autosaveStatus.classList.remove('hidden');
                autosaveText.textContent = '✓ Borrador guardado localmente';
                setTimeout(() => {
                    autosaveStatus.classList.add('hidden');
                }, 3000);
            });
        }
        
        if (prevPageBtn) {
            prevPageBtn.addEventListener('click', () => {
                recalculateVisiblePages();
                const idx = visiblePages.indexOf(currentPage);
                if (idx > 0) showPage(visiblePages[idx - 1]);
            });
        }
        
        if (nextPageBtn) {
            nextPageBtn.addEventListener('click', () => {
                if (validateCurrentPage()) {
                    recalculateVisiblePages();
                    const idx = visiblePages.indexOf(currentPage);
                    if (idx < visiblePages.length - 1) showPage(visiblePages[idx + 1]);
                }
            });
        }
        
        form.addEventListener('submit', function(e) {
            e.preventDefault();
            if (validateCurrentPage()) saveFormData(true);
        });
        
        // ==========================================
        // INICIALIZACIÓN
        // ==========================================
        // Load draft from localStorage first
        loadDraftFromLocalStorage();
        
        // Init conditional fields
        conditionalManager.init();
        recalculateVisiblePages();
        
        if (paginationEnabled && visiblePages.length > 1) {
            saveDraftBtn.classList.remove('hidden');
        }
        
        if (paginationEnabled && pages.length > 0) {
            showPage(visiblePages[0] || 1);
        } else {
            document.querySelectorAll('.form-field').forEach(field => {
                if (conditionalManager.shouldShowField(field)) {
                    field.style.display = 'block';
                }
            });
            updateNavigation();
        }
        
        updateProgress();
        console.log('✅ Formulario inicializado correctamente');
        
        }); // FIN DOMContentLoaded
    </script>
</body>
</html>
