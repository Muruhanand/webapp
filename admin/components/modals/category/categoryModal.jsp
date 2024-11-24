<%@ page import="java.sql.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Category Management Modal</title>
</head>
<body>
    <%
    String mode = request.getParameter("mode") != null ? request.getParameter("mode") : "create";
    boolean isEdit = mode.equals("edit");
    String editModalTitle = isEdit ? "Edit Category" : "Add New Category";
    String modalId = "categoryModal";
    String formAction = isEdit ? "api/category/editCategory.jsp" : "api/category/createCategory.jsp";
    String submitButtonText = isEdit ? "Save Changes" : "Add Category";
    %>

    <div id="<%=modalId%>" class="hidden fixed inset-0 z-50"
        aria-labelledby="modal-title" role="dialog" aria-modal="true">
        <!-- Backdrop -->
        <div
            class="modal-backdrop fixed inset-0 bg-gray-600 transition-opacity duration-300 ease-in-out opacity-0"></div>

        <div class="fixed inset-0 overflow-y-auto">
            <div
                class="flex min-h-screen items-center justify-center p-4 text-center">
                <!-- modal content -->
                <div
                    class="modal-content w-full max-w-md transform transition-all duration-300 ease-in-out scale-95 opacity-0">
                    <div class="relative bg-white rounded-lg shadow-xl p-6">
                        <div class="flex items-center justify-between mb-4">
                            <h3 id="modal-title" class="text-xl font-semibold text-gray-900"><%=editModalTitle%></h3>
                            <button onclick="closeModal('<%=modalId%>')"
                                class="text-gray-400 hover:text-gray-500 transition-colors duration-200">
                                <i class="fas fa-times"></i>
                            </button>
                        </div>

                        <form action="<%=formAction%>" method="POST" class="mt-4"
                            id="categoryForm">
                            <%
                            if (isEdit) {
                            %>
                            <input type="hidden" name="category_id" id="category_id">
                            <%
                            }
                            %>

                            <div class="space-y-4">
                            	<!--  category id -->
                            	<input type="text" name="category_id" id="category_id" class="hidden"/>
                                <!-- Category Name -->
                                <div>
                                    <label class="block text-sm font-medium text-gray-700 mb-1">Category
                                        Name</label> 
                                    <input type="text" name="category_name" id="category_name"
                                        required
                                        class="w-full border border-gray-300 rounded-lg shadow-sm py-2 px-3 focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-blue-500 transition-shadow duration-200">
                                </div>

                                <!-- Description -->
                                <div>
                                    <label class="block text-sm font-medium text-gray-700 mb-1">Description</label>
                                    <textarea name="description" id="description" required rows="3"
                                        class="w-full border border-gray-300 rounded-lg shadow-sm py-2 px-3 focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-blue-500 transition-shadow duration-200"></textarea>
                                </div>
                            </div>

                            <!-- Form Buttons -->
                            <div class="mt-6 flex items-center justify-end gap-3">
                                <button type="button" onclick="closeModal('<%=modalId%>')"
                                    class="px-4 py-2 bg-gray-100 text-gray-700 rounded-lg hover:bg-gray-200 transition-colors duration-200">
                                    Cancel</button>
                                <button type="submit" id="submitButton"
                                    class="px-4 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700 transition-colors duration-200">
                                    <%=submitButtonText%>
                                </button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script>
    function openModal(modalId, categoryData = null) {
        const modal = document.getElementById(modalId);
        const backdrop = modal.querySelector('.modal-backdrop');
        const content = modal.querySelector('.modal-content');
        const editModalTitle = modal.querySelector('#modal-title');
        const submitButton = modal.querySelector('#submitButton');
        const categoryForm = document.getElementById('categoryForm');
        
        // open modal
        modal.classList.remove('hidden');
        
        // animation
        requestAnimationFrame(() => {
            backdrop.classList.add('opacity-50');
            content.classList.add('opacity-100', 'scale-100');
            content.classList.remove('scale-95', 'opacity-0');
        });
        
        // prevent body scroll
        document.body.style.overflow = 'hidden';

        // reset form
        categoryForm.reset();
        
        if (categoryData && categoryData.mode === 'edit') {
            editModalTitle.textContent = 'Edit Category';
            submitButton.textContent = 'Save Changes';
            categoryForm.action = 'api/category/editCategory.jsp';
            
            document.getElementById('category_id').value = categoryData.id;
            document.getElementById('category_name').value = categoryData.name;
            document.getElementById('description').value = categoryData.description;
        } else {
            editModalTitle.textContent = 'Add New Category';
            submitButton.textContent = 'Add Category';
            categoryForm.action = 'api/category/createCategory.jsp';
        }
    }

    function closeModal(modalId) {
        const modal = document.getElementById(modalId);
        const backdrop = modal.querySelector('.modal-backdrop');
        const content = modal.querySelector('.modal-content');
        
        backdrop.classList.remove('opacity-50');
        content.classList.remove('opacity-100', 'scale-100');
        content.classList.add('scale-95', 'opacity-0');
        
        setTimeout(() => {
            modal.classList.add('hidden');
            document.body.style.overflow = 'auto';
        }, 300);
    }

    // form validation
    document.getElementById('categoryForm').addEventListener('submit', function(e) {
        // prevent default form submission
        e.preventDefault(); 
        
        // get values and trim whitespace
        const categoryName = document.getElementById('category_name').value.trim();
        const description = document.getElementById('description').value.trim();
        
        // category name validation
        if (!categoryName || categoryName.length < 3) {
            alert('Category name must be at least 3 characters long (excluding spaces)');
            document.getElementById('category_name').focus();
            return false;
        }
        
        // category name space check
        if (!categoryName.replace(/\s/g, '').length) {
            alert('Category name cannot contain only spaces');
            document.getElementById('category_name').focus();
            return false;
        }
        
        // description validation
        if (!description || description.length < 10) {
            alert('Description must be at least 10 characters long (excluding spaces)');
            document.getElementById('description').focus();
            return false;
        }
        
        // description space check
        if (!description.replace(/\s/g, '').length) {
            alert('Description cannot contain only spaces');
            document.getElementById('description').focus();
            return false;
        }
        
        // submit when all checks pass
        this.submit();
    });
    
    // no space allowance at start of input field
    document.getElementById('category_name').addEventListener('input', function(e) {
        // Remove leading spaces as they're typed
        if (this.value.startsWith(' ')) {
            this.value = this.value.trimStart();
        }
        
        // only letters, spaces and basic punctuation allowed
        this.value = this.value.replace(/[^\w\s-]/g, '');
    });
    
    // prevent space at start for description
    document.getElementById('description').addEventListener('input', function(e) {
        // Remove leading spaces as they're typed
        if (this.value.startsWith(' ')) {
            this.value = this.value.trimStart();
        }
    });
    </script>
</body>
</html>