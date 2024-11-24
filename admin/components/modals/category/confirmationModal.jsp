<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Delete Category Confirmation Modal</title>
</head>
<body>
    <div id="deleteCategoryModal" class="hidden fixed inset-0 z-50"
        aria-labelledby="modal-title" role="dialog" aria-modal="true">
        <!-- backdrop -->
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
                            <h3 id="modal-title" class="text-xl font-semibold text-gray-900">
                                Confirm Category Deletion
                            </h3>
                            <button onclick="closeDeleteModal()"
                                class="text-gray-400 hover:text-gray-500 transition-colors duration-200">
                                <i class="fas fa-times"></i>
                            </button>
                        </div>

                        <div class="mt-4 mb-6">
                            <p id="main-message" class="text-gray-700">Are you sure you want to delete this category? This action cannot be undone.</p>
                            <p id="sub-message" class="text-sm text-gray-500 mt-2">Note: Categories with associated services cannot be deleted.</p>
                        </div>

                        <div class="flex items-center justify-end gap-3">
                            <button type="button" onclick="closeDeleteModal()"
                                class="px-4 py-2 bg-gray-100 text-gray-700 rounded-lg hover:bg-gray-200 transition-colors duration-200">
                                Cancel</button>
                            <form action="/JADProject/admin/api/category/deleteCategory.jsp"
                                method="POST">
                                <input name="deleteCategoryId" id="deleteCategoryId"
                                    value="" class="hidden" />
                                <button type="submit"
                                    class="px-4 py-2 bg-red-600 hover:bg-red-700 text-white rounded-lg transition-colors duration-200">
                                    Delete Category
                                </button>
                            </form>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script>
    function openDeleteModal(categoryId) {
        const modal = document.getElementById('deleteCategoryModal');
        const backdrop = modal.querySelector('.modal-backdrop');
        const content = modal.querySelector('.modal-content');
        
        document.getElementById('deleteCategoryId').value = categoryId;
        
        modal.classList.remove('hidden');
        
        // animation
        requestAnimationFrame(() => {
            backdrop.classList.add('opacity-50');
            content.classList.add('opacity-100', 'scale-100');
            content.classList.remove('scale-95', 'opacity-0');
        });
        
        // prevent body scroll
        document.body.style.overflow = 'hidden';
    }

    function closeDeleteModal() {
        const modal = document.getElementById('deleteCategoryModal');
        const backdrop = modal.querySelector('.modal-backdrop');
        const content = modal.querySelector('.modal-content');
        
        // animation
        backdrop.classList.remove('opacity-50');
        content.classList.remove('opacity-100', 'scale-100');
        content.classList.add('scale-95', 'opacity-0');
        
        // close modal
        setTimeout(() => {
            modal.classList.add('hidden');
            document.body.style.overflow = 'auto';
        }, 300);
    }
    </script>
</body>
</html>