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
            width: 18px;
            height: 18px;
            border: 2px solid #d1d5db;
            border-radius: 50%;
            outline: none;
            cursor: pointer;
            position: relative;
            transition: all 0.2s ease;
        }
        
        .custom-radio:checked {
            border-color: var(--primary-green);
            background-color: transparent;
        }
        
        .custom-radio:checked::after {
            content: '';
            position: absolute;
            width: 10px;
            height: 10px;
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
            border-radius: 8px;
            padding: 12px 16px;
            font-size: 14px;
            transition: all 0.2s ease;
        }
        
        .form-input:focus {
            outline: none;
            border-color: var(--primary-green);
            box-shadow: 0 0 0 3px rgba(124, 252, 0, 0.1);
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
        <div class="flex-1 <?= $isEmbedded ? 'p-4' : 'p-8 lg:p-12' ?> overflow-y-auto">
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
                    <h1 class="text-3xl font-bold text-gray-900 mb-4" id="step-title">
                        <?= htmlspecialchars($pages[0]['name'] ?? $form['name']) ?>
                    </h1>
                    
                    <!-- Progress Bar -->
                    <div class="w-full bg-gray-200 rounded-full h-2 mb-6">
                        <div id="progress-bar" class="progress-bar-fill h-2 rounded-full" style="width: 0%"></div>
                    </div>
                </div>
                <?php else: ?>
                <div class="mb-8">
                    <h1 class="text-3xl font-bold text-gray-900 mb-2"><?= htmlspecialchars($form['name']) ?></h1>
                    <?php if (!empty($form['description'])): ?>
                    <p class="text-gray-600"><?= htmlspecialchars($form['description']) ?></p>
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
                <form id="public-form" class="space-y-6">
                    <input type="hidden" id="submission-id" name="submissionId" value="">
                    <input type="hidden" id="current-page" name="currentPage" value="1">
                    
                    <?php foreach ($fields['fields'] as $field): ?>
                    <div class="form-field" data-field-id="<?= htmlspecialchars($field['id']) ?>" data-page="<?php
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
                        <label class="block text-sm font-semibold text-gray-700 mb-2 <?= !empty($field['required']) ? 'form-field-required' : '' ?>">
                            <?= htmlspecialchars($field['label']) ?>
                        </label>
                        
                        <?php if ($field['type'] === 'text' || $field['type'] === 'email' || $field['type'] === 'tel'): ?>
                            <input type="<?= htmlspecialchars($field['type']) ?>" 
                                   name="<?= htmlspecialchars($field['id']) ?>"
                                   id="field_<?= htmlspecialchars($field['id']) ?>"
                                   <?= !empty($field['required']) ? 'required' : '' ?>
                                   class="form-input w-full"
                                   placeholder="<?= htmlspecialchars($field['label']) ?>">
                        
                        <?php elseif ($field['type'] === 'number'): ?>
                            <input type="number" 
                                   name="<?= htmlspecialchars($field['id']) ?>"
                                   id="field_<?= htmlspecialchars($field['id']) ?>"
                                   <?= !empty($field['required']) ? 'required' : '' ?>
                                   class="form-input w-full">
                        
                        <?php elseif ($field['type'] === 'date'): ?>
                            <input type="date" 
                                   name="<?= htmlspecialchars($field['id']) ?>"
                                   id="field_<?= htmlspecialchars($field['id']) ?>"
                                   <?= !empty($field['required']) ? 'required' : '' ?>
                                   class="form-input w-full">
                        
                        <?php elseif ($field['type'] === 'textarea'): ?>
                            <textarea name="<?= htmlspecialchars($field['id']) ?>"
                                      id="field_<?= htmlspecialchars($field['id']) ?>"
                                      <?= !empty($field['required']) ? 'required' : '' ?>
                                      rows="4"
                                      class="form-input w-full resize-none"
                                      placeholder="<?= htmlspecialchars($field['label']) ?>"></textarea>
                        
                        <?php elseif ($field['type'] === 'select'): ?>
                            <div class="space-y-3">
                                <?php foreach ($field['options'] ?? [] as $option): ?>
                                <label class="flex items-center p-4 border-2 border-gray-200 rounded-lg cursor-pointer hover:border-gray-300 transition">
                                    <input type="radio" 
                                           name="<?= htmlspecialchars($field['id']) ?>"
                                           value="<?= htmlspecialchars($option) ?>"
                                           <?= !empty($field['required']) ? 'required' : '' ?>
                                           class="custom-radio">
                                    <span class="ml-3 text-gray-700 font-medium uppercase text-sm tracking-wide">
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
                                       <?= !empty($field['required']) ? 'required' : '' ?>
                                       class="w-5 h-5 text-green-500 rounded focus:ring-green-500">
                                <label for="field_<?= htmlspecialchars($field['id']) ?>" class="ml-3 text-sm text-gray-700 font-medium">
                                    <?= htmlspecialchars($field['label']) ?>
                                </label>
                            </div>
                        
                        <?php elseif ($field['type'] === 'file'): ?>
                            <input type="file" 
                                   name="<?= htmlspecialchars($field['id']) ?>"
                                   id="field_<?= htmlspecialchars($field['id']) ?>"
                                   <?= !empty($field['required']) ? 'required' : '' ?>
                                   class="form-input w-full file:mr-4 file:py-2 file:px-4 file:rounded-full file:border-0 file:text-sm file:font-semibold file:bg-green-50 file:text-green-700 hover:file:bg-green-100">
                            <p class="text-xs text-gray-500 mt-2">
                                <i class="fas fa-info-circle"></i> Formatos: PDF, JPG, PNG, DOC, DOCX (Máx. 10MB)
                            </p>
                        <?php endif; ?>
                    </div>
                    <?php endforeach; ?>
                    
                    <!-- Auto-save status -->
                    <div id="autosave-status" class="text-sm text-gray-500 text-center hidden">
                        <i class="fas fa-cloud-upload-alt mr-1"></i>
                        <span id="autosave-text">Guardando...</span>
                    </div>
                    
                    <!-- Action Buttons -->
                    <div class="flex justify-between items-center pt-8 border-t">
                        <button type="button" id="prev-page-btn" 
                                class="btn-secondary px-8 py-3 rounded-lg hidden">
                            BACK
                        </button>
                        
                        <div class="flex gap-3 ml-auto">
                            <button type="button" id="save-draft-btn" 
                                    class="btn-secondary px-6 py-3 rounded-lg hidden md:block">
                                <i class="fas fa-save mr-2"></i>SAVE DRAFT
                            </button>
                            
                            <button type="button" id="next-page-btn"
                                    class="btn-primary px-8 py-3 rounded-lg hidden">
                                CONTINUE <i class="fas fa-arrow-right ml-2"></i>
                            </button>
                            
                            <button type="submit" id="submit-btn"
                                    class="btn-primary px-8 py-3 rounded-lg">
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
        </div>
    </div>

    <script>
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
        const totalPages = pages.length || 1;
        const FORM_ID = '<?= $formId ?>';
        const LOCALSTORAGE_KEY = `form_draft_${FORM_ID}`;
        
        let currentPage = 1;
        let autosaveTimeout;
        
        // Load draft from localStorage
        loadDraftFromLocalStorage();
        
        // Initialize pagination
        if (paginationEnabled && pages.length > 0) {
            initializePagination();
            showPage(1);
        }
        
        // Auto-save on input change
        form.addEventListener('input', function() {
            clearTimeout(autosaveTimeout);
            autosaveTimeout = setTimeout(function() {
                saveDraftToLocalStorage();
                saveFormData(false);
            }, AUTOSAVE_DELAY_MS);
        });
        
        // Save draft button
        if (saveDraftBtn) {
            saveDraftBtn.addEventListener('click', function() {
                saveFormData(false);
            });
        }
        
        // Form submission
        form.addEventListener('submit', function(e) {
            e.preventDefault();
            saveFormData(true);
        });
        
        // Pagination buttons
        if (prevPageBtn) {
            prevPageBtn.addEventListener('click', function() {
                if (currentPage > 1) {
                    showPage(currentPage - 1);
                }
            });
        }
        
        if (nextPageBtn) {
            nextPageBtn.addEventListener('click', function() {
                if (validateCurrentPage() && currentPage < totalPages) {
                    showPage(currentPage + 1);
                }
            });
        }
        
        function initializePagination() {
            if (totalPages > 1) {
                saveDraftBtn.classList.remove('hidden');
            }
        }
        
        function showPage(pageNum) {
            currentPage = pageNum;
            currentPageInput.value = pageNum;
            
            // Hide all fields
            document.querySelectorAll('.form-field').forEach(field => {
                field.style.display = 'none';
            });
            
            // Show fields for current page
            document.querySelectorAll(`[data-page="${pageNum}"]`).forEach(field => {
                field.style.display = 'block';
            });
            
            // Update step indicator
            const stepNumber = document.getElementById('current-step-number');
            const stepTitle = document.getElementById('step-title');
            if (stepNumber) {
                stepNumber.textContent = pageNum.toString().padStart(2, '0');
            }
            if (stepTitle && pages[pageNum - 1]) {
                stepTitle.textContent = pages[pageNum - 1].name;
            }
            
            // Update buttons
            prevPageBtn.classList.toggle('hidden', pageNum === 1);
            
            if (pageNum === totalPages) {
                nextPageBtn.classList.add('hidden');
                submitBtn.classList.remove('hidden');
            } else {
                nextPageBtn.classList.remove('hidden');
                submitBtn.classList.add('hidden');
            }
            
            // Calculate and update progress
            calculateProgress();
            
            // Scroll to top
            window.scrollTo({ top: 0, behavior: 'smooth' });
        }
        
        function validateCurrentPage() {
            const currentPageFields = document.querySelectorAll(`[data-page="${currentPage}"]`);
            let isValid = true;
            
            currentPageFields.forEach(fieldDiv => {
                const inputs = fieldDiv.querySelectorAll('input[required], select[required], textarea[required]');
                inputs.forEach(input => {
                    if (!input.checkValidity()) {
                        input.reportValidity();
                        isValid = false;
                    }
                });
            });
            
            return isValid;
        }
        
        function calculateProgress() {
            const allFields = document.querySelectorAll('.form-field');
            let filledFields = 0;
            let totalFields = 0;
            
            allFields.forEach(fieldDiv => {
                const pageNum = parseInt(fieldDiv.dataset.page);
                if (pageNum <= currentPage) {
                    totalFields++;
                    const input = fieldDiv.querySelector('input, select, textarea');
                    if (input && input.value && input.value.trim() !== '') {
                        filledFields++;
                    }
                }
            });
            
            const percentage = totalFields > 0 ? (filledFields / totalFields) * 100 : 0;
            updateProgress(percentage);
        }
        
        function updateProgress(percentage) {
            const progressBar = document.getElementById('progress-bar');
            if (progressBar) {
                progressBar.style.width = percentage + '%';
            }
        }
        
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
                                field.checked = value === 'on';
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
        
        function saveFormData(isCompleted, callback, errorCallback) {
            submitBtn.disabled = true;
            saveDraftBtn.disabled = true;
            
            if (!isCompleted) {
                autosaveStatus.classList.remove('hidden');
                autosaveText.textContent = 'Guardando...';
            }
            
            const payload = new FormData();
            const data = {};
            
            // Collect form data
            const formData = new FormData(form);
            for (const [key, value] of formData.entries()) {
                const field = form.querySelector(`[name="${key}"]`);
                if (field) {
                    if (field.type === 'file') {
                        if (field.files && field.files[0]) {
                            payload.append(key, field.files[0]);
                            data[key] = field.files[0].name;
                        }
                    } else {
                        data[key] = value;
                    }
                }
            }
            
            payload.append('formData', JSON.stringify(data));
            payload.append('currentPage', currentPageInput.value);
            payload.append('isCompleted', isCompleted);
            
            <?php if (!empty($appId)): ?>
            payload.append('appId', '<?= intval($appId) ?>');
            <?php endif; ?>

            if (submissionIdInput.value) {
                payload.append('submissionId', submissionIdInput.value);
            }
            
            fetch('<?= BASE_URL ?>/public/form/<?= $formId ?>/submit', {
                method: 'POST',
                body: payload
            })
            .then(response => response.json())
            .then(result => {
                if (result.success) {
                    if (result.submissionId && !submissionIdInput.value) {
                        submissionIdInput.value = result.submissionId;
                    }
                    
                    if (isCompleted) {
                        try {
                            localStorage.removeItem(LOCALSTORAGE_KEY);
                        } catch (error) {
                            console.error('Error clearing localStorage:', error);
                        }
                        
                        form.style.display = 'none';
                        successMessage.classList.remove('hidden');
                        window.scrollTo({ top: 0, behavior: 'smooth' });
                    } else {
                        autosaveText.textContent = '✓ Guardado';
                        setTimeout(() => {
                            autosaveStatus.classList.add('hidden');
                        }, 2000);
                    }
                    
                    if (result.progressPercentage) {
                        updateProgress(result.progressPercentage);
                    } else if (paginationEnabled) {
                        calculateProgress();
                    }
                    
                    if (callback) callback();
                } else {
                    alert('Error: ' + (result.error || 'No se pudo guardar el formulario'));
                    if (errorCallback) errorCallback();
                }
            })
            .catch(error => {
                console.error('Error:', error);
                alert('Error al guardar el formulario. Por favor, intenta de nuevo.');
                if (errorCallback) errorCallback();
            })
            .finally(() => {
                submitBtn.disabled = false;
                saveDraftBtn.disabled = false;
            });
        }
    </script>
</body>
</html>
