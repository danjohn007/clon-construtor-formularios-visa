/**
 * Visual Form Builder with Drag & Drop
 * Replaces JSON textarea with a user-friendly interface
 */
class FormBuilder {
    constructor(containerId, initialData = null, initialPages = null) {
        this.container = document.getElementById(containerId);
        this.fields = [];
        this.pages = [{ id: 1, name: 'Page 1', fieldIds: [] }];
        this.currentPage = 1;
        this.paginationEnabled = false;
        this.draggedElement = null;
        this.nextId = 1;
        this.nextPageId = 2;
        
        // Field types available
        this.fieldTypes = [
            { id: 'label', label: 'Encabezado', icon: 'fa-heading' },
            { id: 'text', label: 'Texto', icon: 'fa-font' },
            { id: 'email', label: 'Email', icon: 'fa-envelope' },
            { id: 'tel', label: 'Teléfono', icon: 'fa-phone' },
            { id: 'number', label: 'Número', icon: 'fa-hashtag' },
            { id: 'date', label: 'Fecha', icon: 'fa-calendar' },
            { id: 'select', label: 'Selección', icon: 'fa-list' },
            { id: 'textarea', label: 'Área de Texto', icon: 'fa-align-left' },
            { id: 'checkbox', label: 'Casilla', icon: 'fa-check-square' },
            { id: 'file', label: 'Archivo', icon: 'fa-file-upload' }
        ];
        
        // Parse initial data if provided
        if (initialData) {
            try {
                const parsed = typeof initialData === 'string' ? JSON.parse(initialData) : initialData;
                if (parsed && parsed.fields && Array.isArray(parsed.fields)) {
                    this.fields = parsed.fields;
                    // Calcular nextId desde el máximo ID existente para evitar duplicados
                    const maxId = this.fields.reduce((max, f) => {
                        const match = f.id && f.id.match(/campo_(\d+)/);
                        return match ? Math.max(max, parseInt(match[1])) : max;
                    }, 0);
                    this.nextId = maxId + 1;
                }
            } catch (e) {
                console.error('Error parsing initial data:', e);
            }
        }
        
        // Parse initial pages if provided
        if (initialPages) {
            try {
                const parsedPages = typeof initialPages === 'string' ? JSON.parse(initialPages) : initialPages;
                if (parsedPages && Array.isArray(parsedPages) && parsedPages.length > 0) {
                    this.pages = parsedPages;
                    this.nextPageId = Math.max(...parsedPages.map(p => p.id)) + 1;
                }
            } catch (e) {
                console.error('Error parsing initial pages:', e);
            }
        }
        
        // Check if pagination is enabled
        this.checkPaginationEnabled();
        
        // Si la paginación está habilitada pero hay campos sin asignar, asignarlos a la primera página
        if (this.paginationEnabled && this.fields.length > 0) {
            this.ensureAllFieldsAssigned();
        }
        
        this.render();
    }
    
    checkPaginationEnabled() {
        const paginationCheckbox = document.getElementById('pagination_enabled');
        if (paginationCheckbox) {
            this.paginationEnabled = paginationCheckbox.checked;
            paginationCheckbox.addEventListener('change', (e) => {
                const wasEnabled = this.paginationEnabled;
                this.paginationEnabled = e.target.checked;
                
                // Si se activa la paginación, agregar todos los campos existentes a la primera página
                if (this.paginationEnabled && !wasEnabled && this.fields.length > 0) {
                    // Resetear páginas con los campos existentes en la primera página
                    this.pages = [{
                        id: 1,
                        name: 'Page 1',
                        fieldIds: this.fields.map(field => field.id)
                    }];
                    this.currentPage = 1;
                    this.nextPageId = 2;
                    console.log('Paginación activada: todos los campos asignados a Página 1');
                }
                
                // Si se desactiva la paginación, limpiar las páginas
                if (!this.paginationEnabled && wasEnabled) {
                    this.pages = [{ id: 1, name: 'Page 1', fieldIds: [] }];
                    this.currentPage = 1;
                    this.nextPageId = 2;
                }
                
                this.render();
                this.updateJSON();
            });
        }
    }
    
    render() {
        this.container.innerHTML = `
            <div class="form-builder">
                <!-- Field Types Palette -->
                <div class="field-palette bg-gray-50 p-4 rounded-lg border-2 border-gray-200 mb-4">
                    <h3 class="text-sm font-semibold text-gray-700 mb-3">
                        <i class="fas fa-tools mr-2"></i>Tipos de Campo
                    </h3>
                    <div class="grid grid-cols-3 gap-2">
                        ${this.fieldTypes.map(type => `
                            <button type="button" 
                                    class="field-type-btn bg-white border-2 border-gray-300 rounded-lg p-3 hover:border-blue-500 hover:bg-blue-50 transition cursor-move text-center"
                                    data-field-type="${type.id}"
                                    draggable="true">
                                <i class="fas ${type.icon} text-xl text-gray-600 mb-1"></i>
                                <div class="text-xs font-medium text-gray-700">${type.label}</div>
                            </button>
                        `).join('')}
                    </div>
                    <p class="text-xs text-gray-500 mt-3">
                        <i class="fas fa-info-circle"></i> Arrastra un tipo de campo hacia el área de construcción
                    </p>
                </div>
                
                <!-- Page Management (shown only when pagination is enabled) -->
                ${this.paginationEnabled ? `
                <div class="page-management bg-blue-50 border-2 border-blue-200 rounded-lg p-4 mb-4">
                    <div class="flex items-center justify-between mb-3">
                        <h3 class="text-sm font-semibold text-blue-900">
                            <i class="fas fa-layer-group mr-2"></i>Gestión de Páginas
                        </h3>
                        <button type="button" id="add-page-btn" class="bg-blue-600 text-white px-3 py-1 rounded text-xs hover:bg-blue-700">
                            <i class="fas fa-plus mr-1"></i>Agregar Página
                        </button>
                    </div>
                    <div class="flex space-x-2 overflow-x-auto pb-2" id="pages-tabs">
                        ${this.pages.map(page => `
                            <button type="button" 
                                    class="page-tab px-4 py-2 rounded text-sm whitespace-nowrap ${page.id === this.currentPage ? 'bg-blue-600 text-white' : 'bg-white text-blue-800 border border-blue-300'}"
                                    data-page-id="${page.id}"
                                    aria-label="${page.name} con ${page.fieldIds.length} campo${page.fieldIds.length !== 1 ? 's' : ''}"
                                    ${page.id === this.currentPage ? 'aria-current="page"' : ''}>
                                <i class="fas fa-file-alt mr-1"></i>${page.name} (${page.fieldIds.length})
                            </button>
                        `).join('')}
                    </div>
                </div>
                ` : ''}
                
                <!-- Form Fields Area -->
                <div class="fields-area bg-white border-2 border-dashed border-gray-300 rounded-lg p-4 min-h-[300px]"
                     id="fields-drop-area">
                    ${this.paginationEnabled ? `
                        <div class="text-sm text-blue-700 mb-3 flex items-center justify-between">
                            <span><i class="fas fa-info-circle mr-1"></i>Mostrando campos de: <strong>${this.getPageName(this.currentPage)}</strong></span>
                            <button type="button" id="show-all-fields-btn" class="text-blue-600 hover:underline text-xs">
                                Ver todos los campos
                            </button>
                        </div>
                    ` : ''}
                    <div class="fields-list" id="fields-list">
                        ${this.fields.length === 0 ? `
                            <div class="empty-state text-center py-12 text-gray-400">
                                <i class="fas fa-arrow-up text-4xl mb-3"></i>
                                <p class="text-sm">Arrastra campos aquí para construir tu formulario</p>
                            </div>
                        ` : ''}
                    </div>
                </div>
            </div>
        `;
        
        this.attachEventListeners();
        this.renderFields();
    }
    
    getPageName(pageId) {
        const page = this.pages.find(p => p.id === pageId);
        return page ? page.name : 'Page unknown';
    }
    
    addPage() {
        const newPage = {
            id: this.nextPageId++,
            name: `Page ${this.pages.length + 1}`,
            fieldIds: []
        };
        this.pages.push(newPage);
        this.currentPage = newPage.id;
        this.render();
        this.updateJSON();
    }
    
    isShowingAllPages() {
        return !this.paginationEnabled || this.currentPage === 0;
    }
    
    switchPage(pageId) {
        this.currentPage = pageId;
        this.renderFields();
        // Update tabs styling and aria attributes
        document.querySelectorAll('.page-tab').forEach(tab => {
            const tabPageId = parseInt(tab.dataset.pageId);
            if (tabPageId === pageId) {
                tab.className = 'page-tab px-4 py-2 rounded text-sm whitespace-nowrap bg-blue-600 text-white';
                tab.setAttribute('aria-current', 'page');
            } else {
                tab.className = 'page-tab px-4 py-2 rounded text-sm whitespace-nowrap bg-white text-blue-800 border border-blue-300';
                tab.removeAttribute('aria-current');
            }
        });
    }
    
    attachEventListeners() {
        // Drag start for field types
        const fieldTypeBtns = this.container.querySelectorAll('.field-type-btn');
        fieldTypeBtns.forEach(btn => {
            btn.addEventListener('dragstart', (e) => {
                e.dataTransfer.setData('fieldType', btn.dataset.fieldType);
                btn.style.opacity = '0.5';
            });
            
            btn.addEventListener('dragend', (e) => {
                btn.style.opacity = '1';
            });
            
            // Click to add field (mobile friendly)
            btn.addEventListener('click', (e) => {
                this.addField(btn.dataset.fieldType);
            });
        });
        
        // Drop area events
        const dropArea = document.getElementById('fields-drop-area');
        dropArea.addEventListener('dragover', (e) => {
            e.preventDefault();
            dropArea.classList.add('border-blue-500', 'bg-blue-50');
        });
        
        dropArea.addEventListener('dragleave', (e) => {
            dropArea.classList.remove('border-blue-500', 'bg-blue-50');
        });
        
        dropArea.addEventListener('drop', (e) => {
            e.preventDefault();
            dropArea.classList.remove('border-blue-500', 'bg-blue-50');
            
            const fieldType = e.dataTransfer.getData('fieldType');
            if (fieldType) {
                this.addField(fieldType);
            }
        });
        
        // Page management buttons
        if (this.paginationEnabled) {
            const addPageBtn = document.getElementById('add-page-btn');
            if (addPageBtn) {
                addPageBtn.addEventListener('click', () => this.addPage());
            }
            
            const pageTabs = document.querySelectorAll('.page-tab');
            pageTabs.forEach(tab => {
                tab.addEventListener('click', () => {
                    const pageId = parseInt(tab.dataset.pageId);
                    this.switchPage(pageId);
                });
            });
            
            const showAllBtn = document.getElementById('show-all-fields-btn');
            if (showAllBtn) {
                showAllBtn.addEventListener('click', () => {
                    this.currentPage = 0; // Use 0 to indicate "show all"
                    this.renderFields();
                });
            }
        }
    }
    
    addField(type) {
        const fieldType = this.fieldTypes.find(ft => ft.id === type);
        if (!fieldType) return;
        
        const newField = {
            id: `campo_${this.nextId++}`,
            type: type,
            label: fieldType.label,
            required: false
        };
        
        // Add options for select fields
        if (type === 'select') {
            newField.options = ['Opción 1', 'Opción 2'];
        }
        
        this.fields.push(newField);
        
        // If pagination is enabled, add field to a page
        if (this.paginationEnabled) {
            let page = null;
            if (this.currentPage) {
                page = this.pages.find(p => p.id === this.currentPage);
            }
            // Fallback to last page if viewing all (currentPage === 0)
            if (!page && this.pages.length > 0) {
                page = this.pages[this.pages.length - 1];
            }
            if (page) {
                page.fieldIds.push(newField.id);
            }
        }
        
        this.renderFields();
        this.updateJSON();
    }
    
    renderFields() {
        const fieldsList = document.getElementById('fields-list');
        if (!fieldsList) return;
        
        // Determine which fields to show
        let fieldsToShow = this.fields;
        if (!this.isShowingAllPages()) {
            const page = this.pages.find(p => p.id === this.currentPage);
            if (page) {
                fieldsToShow = this.fields.filter(f => page.fieldIds.includes(f.id));
            }
        }
        
        if (fieldsToShow.length === 0) {
            fieldsList.innerHTML = `
                <div class="empty-state text-center py-12 text-gray-400">
                    <i class="fas fa-arrow-up text-4xl mb-3"></i>
                    <p class="text-sm">${!this.isShowingAllPages() ? 'Arrastra campos aquí para agregarlos a esta página' : 'Arrastra campos aquí para construir tu formulario'}</p>
                </div>
            `;
            return;
        }
        
        fieldsList.innerHTML = fieldsToShow.map((field) => {
            const index = this.fields.indexOf(field);
            const hasShowWhen = field.showWhen && field.showWhen.fieldId;
            
            return `
            <div class="field-item bg-gray-50 border border-gray-300 rounded-lg p-4 mb-3" data-index="${index}">
                <div class="flex items-start justify-between mb-3">
                    <div class="flex items-center flex-1">
                        <i class="fas fa-grip-vertical text-gray-400 mr-3 cursor-move"></i>
                        <div class="flex-1">
                            <div class="flex items-center gap-2">
                                <span class="font-semibold text-gray-800">${field.label}</span>
                                ${hasShowWhen ? `
                                    <span class="inline-flex items-center px-2 py-0.5 rounded text-xs font-medium bg-blue-100 text-blue-800" 
                                          title="Se muestra cuando ${this.getFieldLabel(field.showWhen.fieldId)} = ${field.showWhen.value}">
                                        <i class="fas fa-link mr-1"></i>Condicional
                                    </span>
                                ` : ''}
                            </div>
                            <div class="text-xs text-gray-500">
                                ID: ${field.id} | Tipo: ${field.type}
                                ${hasShowWhen ? `<br><i class="fas fa-arrow-right text-blue-500 mr-1"></i>Depende de: ${this.getFieldLabel(field.showWhen.fieldId)} = "${field.showWhen.value}"` : ''}
                            </div>
                        </div>
                    </div>
                    <div class="flex items-center space-x-2">
                        ${this.paginationEnabled ? `
                            <select class="field-page-select text-xs border border-gray-300 rounded px-2 py-1" 
                                    data-field-id="${field.id}"
                                    aria-label="Asignar campo a página">
                                ${this.pages.map(page => `
                                    <option value="${page.id}" ${page.fieldIds.includes(field.id) ? 'selected' : ''}>
                                        ${page.name}
                                    </option>
                                `).join('')}
                            </select>
                        ` : ''}
                        <button type="button" class="btn-configure-conditional text-blue-600 hover:text-blue-800" 
                                data-index="${index}"
                                title="Configurar cuándo se muestra este campo">
                            <i class="fas fa-link"></i>
                        </button>
                        <button type="button" class="btn-delete-field text-red-600 hover:text-red-800" data-index="${index}">
                            <i class="fas fa-trash"></i>
                        </button>
                    </div>
                </div>
                
                <div class="grid grid-cols-2 gap-3 text-sm">
                    <div class="col-span-2">
                        <label class="block text-xs text-gray-600 mb-1">Nombre de campo</label>
                        <input type="text" value="${field.label}" 
                               class="field-label-input w-full border border-gray-300 rounded px-2 py-1 text-sm"
                               data-index="${index}">
                    </div>
                    <div style="display:none">
                        <label class="block text-xs text-gray-600 mb-1">ID del campo</label>
                        <input type="text" value="${field.id}" 
                               class="field-id-input w-full border border-gray-300 rounded px-2 py-1 text-sm"
                               data-index="${index}">
                    </div>
                    ${field.type === 'select' ? `
                        <div class="col-span-2">
                            <label class="block text-xs text-gray-600 mb-1">Opciones (separadas por coma)</label>
                            <input type="text" value="${(field.options || []).join(', ')}" 
                                   class="field-options-input w-full border border-gray-300 rounded px-2 py-1 text-sm"
                                   data-index="${index}">
                        </div>
                    ` : ''}
                    ${field.type !== 'label' ? `
                    <div class="col-span-2">
                        <label class="flex items-center">
                            <input type="checkbox" ${field.required ? 'checked' : ''} 
                                   class="field-required-input mr-2"
                                   data-index="${index}">
                            <span class="text-xs text-gray-700">Campo obligatorio</span>
                        </label>
                    </div>
                    ` : ''}
                </div>
            </div>
        `}).join('');
        
        // Attach event listeners after rendering
        this.attachFieldEventListeners();
    }
    
    attachFieldEventListeners() {
        // Label inputs
        document.querySelectorAll('.field-label-input').forEach(input => {
            input.addEventListener('change', (e) => {
                const index = parseInt(e.target.dataset.index);
                this.updateFieldProperty(index, 'label', e.target.value);
            });
        });
        
        // ID inputs
        document.querySelectorAll('.field-id-input').forEach(input => {
            input.addEventListener('change', (e) => {
                const index = parseInt(e.target.dataset.index);
                const oldId = this.fields[index].id;
                const newId = e.target.value.trim();
                
                // Validate for duplicate IDs
                const isDuplicate = this.fields.some((field, idx) => 
                    idx !== index && field.id === newId
                );
                
                if (isDuplicate) {
                    alert('Ya existe un campo con ese ID. Por favor, elige un ID único.');
                    e.target.value = oldId; // Reset to old value
                    return;
                }
                
                if (!newId) {
                    alert('El ID no puede estar vacío.');
                    e.target.value = oldId; // Reset to old value
                    return;
                }
                
                // Update field ID in pages
                if (this.paginationEnabled) {
                    this.pages.forEach(page => {
                        const idIndex = page.fieldIds.indexOf(oldId);
                        if (idIndex !== -1) {
                            page.fieldIds[idIndex] = newId;
                        }
                    });
                }
                
                this.updateFieldProperty(index, 'id', newId);
            });
        });
        
        // Options inputs
        document.querySelectorAll('.field-options-input').forEach(input => {
            input.addEventListener('change', (e) => {
                const index = parseInt(e.target.dataset.index);
                const options = e.target.value.split(',').map(o => o.trim());
                this.updateFieldProperty(index, 'options', options);
            });
        });
        
        // Required checkboxes
        document.querySelectorAll('.field-required-input').forEach(input => {
            input.addEventListener('change', (e) => {
                const index = parseInt(e.target.dataset.index);
                this.updateFieldProperty(index, 'required', e.target.checked);
            });
        });
        
        // Page assignment dropdown
        document.querySelectorAll('.field-page-select').forEach(select => {
            select.addEventListener('change', (e) => {
                const fieldId = e.target.dataset.fieldId;
                const newPageId = parseInt(e.target.value);
                
                // Remove field from all pages
                this.pages.forEach(page => {
                    page.fieldIds = page.fieldIds.filter(id => id !== fieldId);
                });
                
                // Add field to selected page
                const targetPage = this.pages.find(p => p.id === newPageId);
                if (targetPage && !targetPage.fieldIds.includes(fieldId)) {
                    targetPage.fieldIds.push(fieldId);
                }
                
                this.updateJSON();
                // Update page tabs to show field counts
                this.render();
            });
        });
        
        // Delete buttons
        document.querySelectorAll('.btn-delete-field').forEach(button => {
            button.addEventListener('click', (e) => {
                const index = parseInt(e.currentTarget.dataset.index);
                this.deleteField(index);
            });
        });
        
        // Configure conditional buttons
        document.querySelectorAll('.btn-configure-conditional').forEach(button => {
            button.addEventListener('click', (e) => {
                const index = parseInt(e.currentTarget.dataset.index);
                this.openConditionalModal(index);
            });
        });
    }
    
    updateFieldProperty(index, property, value) {
        if (this.fields[index]) {
            this.fields[index][property] = value;
            this.updateJSON();
        }
    }
    
    deleteField(index) {
        if (confirm('¿Estás seguro de eliminar este campo?')) {
            const fieldId = this.fields[index].id;
            
            // Remove from pages if pagination enabled
            if (this.paginationEnabled) {
                this.pages.forEach(page => {
                    page.fieldIds = page.fieldIds.filter(id => id !== fieldId);
                });
            }
            
            this.fields.splice(index, 1);
            this.renderFields();
            this.updateJSON();
        }
    }
    
    updateJSON() {
        const jsonOutput = {
            fields: this.fields
        };
        
        // Update hidden field with JSON
        const hiddenField = document.getElementById('fields_json_hidden');
        if (hiddenField) {
            hiddenField.value = JSON.stringify(jsonOutput);
        }
        
        // Ensure all fields are assigned to a page before saving
        if (this.paginationEnabled) {
            this.ensureAllFieldsAssigned();
        }
        
        // Also save pages JSON to a separate hidden field
        if (this.paginationEnabled) {
            let pagesInput = document.getElementById('pages_json_hidden');
            if (!pagesInput) {
                pagesInput = document.createElement('input');
                pagesInput.type = 'hidden';
                pagesInput.id = 'pages_json_hidden';
                pagesInput.name = 'pages_json';
                hiddenField.parentNode.appendChild(pagesInput);
            }
            pagesInput.value = JSON.stringify(this.pages);
        }
        
        // Dispatch event for other components
        const event = new CustomEvent('formbuilder:update', { detail: jsonOutput });
        document.dispatchEvent(event);
    }
    
    getJSON() {
        return JSON.stringify({ fields: this.fields }, null, 2);
    }
    
    getData() {
        return { fields: this.fields };
    }
    
    /**
     * Obtiene el label de un campo por su ID
     */
    getFieldLabel(fieldId) {
        const field = this.fields.find(f => f.id === fieldId);
        return field ? field.label : fieldId;
    }
    
    /**
     * Abre el modal simple de configuración condicional
     */
    openConditionalModal(fieldIndex) {
        const field = this.fields[fieldIndex];
        if (!field) return;
        
        const hasShowWhen = field.showWhen && field.showWhen.fieldId;
        const selectFields = this.fields.filter(f => f.type === 'select' && f.id !== field.id);
        
        // Crear modal simple
        const modalHtml = `
            <div id="conditional-modal" class="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50 p-4">
                <div class="bg-white rounded-lg shadow-xl max-w-lg w-full">
                    <div class="bg-gradient-to-r from-blue-500 to-blue-600 px-6 py-4 rounded-t-lg">
                        <div class="flex items-center justify-between">
                            <h3 class="text-lg font-semibold text-white">
                                <i class="fas fa-link mr-2"></i>Campo Condicional
                            </h3>
                            <button type="button" id="close-modal" class="text-white hover:text-gray-200">
                                <i class="fas fa-times text-xl"></i>
                            </button>
                        </div>
                        <p class="text-blue-100 text-sm mt-1">Configurando: <strong>${field.label}</strong></p>
                    </div>
                    
                    <div class="p-6">
                        ${selectFields.length === 0 ? `
                            <div class="text-center py-8">
                                <i class="fas fa-info-circle text-gray-400 text-4xl mb-3"></i>
                                <p class="text-gray-600 font-medium mb-2">No hay campos de selección disponibles</p>
                                <p class="text-sm text-gray-500">Primero debes crear al menos un campo tipo "Selección" para poder configurar dependencias</p>
                            </div>
                        ` : `
                            <!-- Enable checkbox -->
                            <div class="mb-5 p-4 bg-blue-50 border border-blue-200 rounded-lg">
                                <label class="flex items-start cursor-pointer">
                                    <input type="checkbox" id="conditional-enabled" 
                                           ${hasShowWhen ? 'checked' : ''}
                                           class="w-5 h-5 text-blue-600 rounded mt-0.5 flex-shrink-0">
                                    <div class="ml-3">
                                        <span class="text-sm font-medium text-gray-900">
                                            Mostrar este campo solo cuando otro campo tenga un valor específico
                                        </span>
                                        <p class="text-xs text-gray-600 mt-1">
                                            Por ejemplo: mostrar "Tamaño del jardín" solo si "Tipo de servicio" es "Residencial"
                                        </p>
                                    </div>
                                </label>
                            </div>
                            
                            <!-- Conditional config -->
                            <div id="conditional-config" ${!hasShowWhen ? 'style="display:none"' : ''}>
                                <div class="space-y-4">
                                    <div>
                                        <label class="block text-sm font-medium text-gray-700 mb-2">
                                            <i class="fas fa-level-up-alt mr-1 text-blue-500"></i>
                                            ¿De qué campo depende?
                                        </label>
                                        <select id="parent-field-select" 
                                                class="w-full border border-gray-300 rounded-lg px-3 py-2 text-sm focus:ring-2 focus:ring-blue-500 focus:border-blue-500">
                                            <option value="">Seleccionar campo...</option>
                                            ${selectFields.map(f => `
                                                <option value="${f.id}" ${field.showWhen?.fieldId === f.id ? 'selected' : ''}>
                                                    ${f.label}
                                                </option>
                                            `).join('')}
                                        </select>
                                        <p class="text-xs text-gray-500 mt-1">
                                            Solo aparecen campos de tipo "Selección"
                                        </p>
                                    </div>
                                    
                                    <div id="value-selector" ${!field.showWhen?.fieldId ? 'style="display:none"' : ''}>
                                        <label class="block text-sm font-medium text-gray-700 mb-2">
                                            <i class="fas fa-check-circle mr-1 text-blue-500"></i>
                                            ¿Qué valor debe tener ese campo?
                                        </label>
                                        <select id="parent-value-select" 
                                                class="w-full border border-gray-300 rounded-lg px-3 py-2 text-sm focus:ring-2 focus:ring-blue-500 focus:border-blue-500">
                                            <option value="">Seleccionar valor...</option>
                                        </select>
                                        <p class="text-xs text-gray-500 mt-1">
                                            Este campo aparecerá solo cuando se seleccione esta opción
                                        </p>
                                    </div>
                                    
                                    <div class="bg-yellow-50 border border-yellow-200 rounded-lg p-3">
                                        <div class="flex">
                                            <i class="fas fa-lightbulb text-yellow-600 mt-0.5 mr-2 flex-shrink-0"></i>
                                            <div class="text-xs text-yellow-800">
                                                <strong>Ejemplo:</strong> Si configuras que este campo depende de 
                                                "Tipo de servicio" con valor "Residencial", entonces este campo 
                                                solo aparecerá en el formulario cuando el usuario seleccione "Residencial" 
                                                en la opción de tipo de servicio.
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        `}
                    </div>
                    
                    <div class="bg-gray-50 px-6 py-4 border-t flex justify-end gap-3 rounded-b-lg">
                        <button type="button" id="cancel-conditional" 
                                class="px-4 py-2 text-sm font-medium text-gray-700 bg-white border border-gray-300 rounded-lg hover:bg-gray-50 transition">
                            Cancelar
                        </button>
                        ${selectFields.length > 0 ? `
                            <button type="button" id="save-conditional" 
                                    class="px-4 py-2 text-sm font-medium text-white bg-blue-600 rounded-lg hover:bg-blue-700 transition">
                                <i class="fas fa-save mr-1"></i>Guardar
                            </button>
                        ` : ''}
                    </div>
                </div>
            </div>
        `;
        
        // Insert modal into document
        const modalElement = document.createElement('div');
        modalElement.innerHTML = modalHtml;
        document.body.appendChild(modalElement);
        
        // Si hay un campo padre seleccionado, cargar sus opciones
        if (field.showWhen?.fieldId) {
            this.loadParentOptions(field.showWhen.fieldId, field.showWhen.value);
        }
        
        // Event listeners
        const conditionalEnabled = document.getElementById('conditional-enabled');
        if (conditionalEnabled) {
            conditionalEnabled.addEventListener('change', (e) => {
                const config = document.getElementById('conditional-config');
                if (config) {
                    config.style.display = e.target.checked ? '' : 'none';
                }
            });
        }
        
        const parentSelect = document.getElementById('parent-field-select');
        if (parentSelect) {
            parentSelect.addEventListener('change', (e) => {
                const valueSelector = document.getElementById('value-selector');
                if (valueSelector) {
                    valueSelector.style.display = e.target.value ? '' : 'none';
                }
                if (e.target.value) {
                    this.loadParentOptions(e.target.value);
                }
            });
        }
        
        document.getElementById('close-modal')?.addEventListener('click', () => {
            this.closeConditionalModal();
        });
        
        document.getElementById('cancel-conditional')?.addEventListener('click', () => {
            this.closeConditionalModal();
        });
        
        const saveBtn = document.getElementById('save-conditional');
        if (saveBtn) {
            saveBtn.addEventListener('click', () => {
                this.saveConditional(fieldIndex);
            });
        }
        
        // Close on backdrop click
        document.getElementById('conditional-modal')?.addEventListener('click', (e) => {
            if (e.target.id === 'conditional-modal') {
                this.closeConditionalModal();
            }
        });
    }
    
    /**
     * Carga las opciones del campo padre en el dropdown de valores
     */
    loadParentOptions(parentFieldId, selectedValue = '') {
        const parentField = this.fields.find(f => f.id === parentFieldId);
        if (!parentField || !parentField.options) return;
        
        const valueSelect = document.getElementById('parent-value-select');
        if (!valueSelect) return;
        
        valueSelect.innerHTML = '<option value="">Seleccionar valor...</option>' +
            parentField.options.map(opt => `
                <option value="${opt}" ${opt === selectedValue ? 'selected' : ''}>
                    ${opt}
                </option>
            `).join('');
    }
    
    /**
     * Guarda la configuración condicional simple
     */
    saveConditional(fieldIndex) {
        const field = this.fields[fieldIndex];
        if (!field) return;
        
        const enabled = document.getElementById('conditional-enabled')?.checked || false;
        
        if (enabled) {
            const parentFieldId = document.getElementById('parent-field-select')?.value;
            const parentValue = document.getElementById('parent-value-select')?.value;
            
            if (!parentFieldId || !parentValue) {
                alert('Debes seleccionar tanto el campo padre como el valor específico');
                return;
            }
            
            field.showWhen = {
                fieldId: parentFieldId,
                value: parentValue
            };
        } else {
            // Eliminar configuración condicional
            delete field.showWhen;
        }
        
        this.closeConditionalModal();
        this.renderFields();
        this.updateJSON();
    }
    
    /**
     * Cierra el modal condicional
     */
    closeConditionalModal() {
        const modal = document.getElementById('conditional-modal');
        if (modal && modal.parentElement) {
            modal.parentElement.remove();
        }
    }
    
    /**
     * Asegura que todos los campos estén asignados a al menos una página
     * Los campos huérfanos se asignan a la primera página
     */
    ensureAllFieldsAssigned() {
        if (!this.paginationEnabled || this.pages.length === 0) return;
        
        // Build lookup: fieldId → pageId for assigned fields
        const fieldToPage = new Map();
        this.pages.forEach(page => {
            if (page.fieldIds && Array.isArray(page.fieldIds)) {
                page.fieldIds.forEach(id => fieldToPage.set(id, page.id));
            }
        });
        
        // Section-based assignment: labels define section boundaries
        // All fields in a section go to the SAME page
        const sections = [];
        let curSec = null;
        let curCK = '';
        
        this.fields.forEach(field => {
            const ck = (field.showWhen && field.showWhen.fieldId && field.showWhen.value)
                ? `${field.showWhen.fieldId}=${field.showWhen.value}`
                : '';
            
            if (!ck) {
                curSec = null;
                curCK = '';
                return;
            }
            
            // New section when: label, different condition, or no current section
            if (field.type === 'label' || ck !== curCK || curSec === null) {
                sections.push({ condKey: ck, fieldIds: [] });
                curSec = sections.length - 1;
                curCK = ck;
            }
            sections[curSec].fieldIds.push(field.id);
        });
        
        // For each section, determine target page and consolidate
        let changeCount = 0;
        sections.forEach(sec => {
            let targetPageId = null;
            
            // Use first explicitly-assigned field's page
            for (const fid of sec.fieldIds) {
                if (fieldToPage.has(fid)) {
                    targetPageId = fieldToPage.get(fid);
                    break;
                }
            }
            
            // No explicit assignment → create virtual page
            if (targetPageId === null) {
                const newPageId = this.nextPageId++;
                this.pages.push({ id: newPageId, name: `Sección ${newPageId}`, fieldIds: [] });
                targetPageId = newPageId;
            }
            
            const targetPage = this.pages.find(p => p.id === targetPageId);
            if (!targetPage) return;
            if (!targetPage.fieldIds) targetPage.fieldIds = [];
            
            sec.fieldIds.forEach(fid => {
                const currentPageId = fieldToPage.get(fid);
                if (currentPageId === targetPageId) return; // already correct
                
                if (currentPageId !== undefined) {
                    // Remove from old page
                    const oldPage = this.pages.find(p => p.id === currentPageId);
                    if (oldPage && oldPage.fieldIds) {
                        oldPage.fieldIds = oldPage.fieldIds.filter(id => id !== fid);
                    }
                }
                
                if (!targetPage.fieldIds.includes(fid)) {
                    targetPage.fieldIds.push(fid);
                }
                fieldToPage.set(fid, targetPageId);
                changeCount++;
            });
        });
        
        // Handle non-conditional orphans
        let lastPageId = this.pages[0].id;
        this.fields.forEach(field => {
            if (fieldToPage.has(field.id)) {
                lastPageId = fieldToPage.get(field.id);
                return;
            }
            const ck = (field.showWhen && field.showWhen.fieldId && field.showWhen.value)
                ? `${field.showWhen.fieldId}=${field.showWhen.value}`
                : '';
            if (ck) return; // conditional fields already handled by sections
            
            const page = this.pages.find(p => p.id === lastPageId);
            if (page) {
                if (!page.fieldIds) page.fieldIds = [];
                page.fieldIds.push(field.id);
                fieldToPage.set(field.id, lastPageId);
                changeCount++;
            }
        });
        
        if (changeCount > 0) {
            console.log(`${changeCount} campo(s) reasignado(s) por secciones`);
        }
    }
}

// Global instance
let formBuilder;

// Initialize form builder when DOM is ready
document.addEventListener('DOMContentLoaded', function() {
    const builderContainer = document.getElementById('form-builder-container');
    if (builderContainer) {
        const initialData = builderContainer.dataset.initialData;
        const initialPages = builderContainer.dataset.initialPages; // Nuevo: soporte para páginas iniciales
        formBuilder = new FormBuilder('form-builder-container', initialData, initialPages);
    }
});
