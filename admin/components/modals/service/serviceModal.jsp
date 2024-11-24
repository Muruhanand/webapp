<%@ page import="java.sql.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Service Management Modal</title>
</head>
<body>
	<%
	String mode = request.getParameter("mode") != null ? request.getParameter("mode") : "create";
	boolean isEdit = mode.equals("edit");
	String editModalTitle = isEdit ? "Edit Service" : "Add New Service";
	String modalId = "serviceModal";
	String formAction = isEdit ? "api/service/editService.jsp" : "api/service/createService.jsp";
	String submitButtonText = isEdit ? "Save Changes" : "Add Service";
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
							id="serviceForm">
							<%
							if (isEdit) {
							%>
							<input type="hidden" name="serviceId" id="serviceId">
							<%
							}
							%>

							<div class="space-y-4">
								<!-- service id -->
								<input type="text" name="service_id" id="service_id" class="hidden"/>
								<!-- service Name -->
								<div>
									<label class="block text-sm font-medium text-gray-700 mb-1">Service
										Name</label> <input type="text" name="service_name" id="service_name"
										required
										class="w-full border border-gray-300 rounded-lg shadow-sm py-2 px-3 focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-blue-500 transition-shadow duration-200">
								</div>

								<!-- description -->
								<div>
									<label class="block text-sm font-medium text-gray-700 mb-1">Description</label>
									<textarea name="description" id="description" required rows="3"
										class="w-full border border-gray-300 rounded-lg shadow-sm py-2 px-3 focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-blue-500 transition-shadow duration-200"></textarea>
								</div>

								<!-- price -->
								<div>
									<label class="block text-sm font-medium text-gray-700 mb-1">Price
										($)</label> <input type="number" name="price" id="price" required
										step="0.01" min="0"
										class="w-full border border-gray-300 rounded-lg shadow-sm py-2 px-3 focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-blue-500 transition-shadow duration-200">
								</div>
															
								<!-- Category -->
								<div>
									<label class="block text-sm font-medium text-gray-700 mb-1">Category</label>
									<select name="category_id" id="category_id" required
										class="w-full border border-gray-300 rounded-lg shadow-sm py-2 px-3 focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-blue-500 transition-shadow duration-200">
										<%
										Connection modalConn = null;
										PreparedStatement modalPstmt = null;
										ResultSet modalRs = null;

										try {
											Class.forName("com.mysql.cj.jdbc.Driver");
											String connURL = "jdbc:mysql://localhost:3306/JADCA1?user=root&password=BlaBla968@gmail.com!&serverTimezone=UTC";
											modalConn = DriverManager.getConnection(connURL);

											String sql = "SELECT category_id, category_name FROM service_category ORDER BY category_name";
											modalPstmt = modalConn.prepareStatement(sql);
											modalRs = modalPstmt.executeQuery();

											while (modalRs.next()) {
										%>
										<option value="<%=modalRs.getInt("category_id")%>"><%=modalRs.getString("category_name")%></option>
										<%
										}
										} catch (Exception e) {
										e.printStackTrace();
										} finally {
										if (modalRs != null)
										modalRs.close();
										if (modalPstmt != null)
										modalPstmt.close();
										if (modalConn != null)
										modalConn.close();
										}
										%>
									</select>
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
	function openModal(modalId, serviceData = null) {
	    const modal = document.getElementById(modalId);
	    const backdrop = modal.querySelector('.modal-backdrop');
	    const content = modal.querySelector('.modal-content');
	    const editModalTitle = modal.querySelector('#modal-title');
	    const submitButton = modal.querySelector('#submitButton');
	    const serviceForm = document.getElementById('serviceForm');
	    
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
	    serviceForm.reset();
	    
	    if (serviceData && serviceData.mode === 'edit') {
	        editModalTitle.textContent = 'Edit Service';
	        submitButton.textContent = 'Save Changes';
	        serviceForm.action = 'api/service/editService.jsp';
	        
	        document.getElementById('service_id').value = serviceData.id;
	        document.getElementById('service_name').value = serviceData.name;
	        document.getElementById('description').value = serviceData.description;
	        document.getElementById('price').value = serviceData.price;
	        document.getElementById('category_id').value = serviceData.category_id;
	    } else {
	        editModalTitle.textContent = 'Add New Service';
	        submitButton.textContent = 'Add Service';
	        serviceForm.action = 'api/service/createService.jsp';
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
    document.getElementById('serviceForm').addEventListener('submit', function(e) {
    	// dont allow form submission
	    e.preventDefault(); 
	    
	    // obtain values and trim whitespace
	    const serviceName = document.getElementById('service_name').value.trim();
	    const description = document.getElementById('description').value.trim();
	    const price = parseFloat(document.getElementById('price').value);
	    const categoryId = document.getElementById('category_id').value;
	    
	    // service name validation
	    if (!serviceName || serviceName.length < 3) {
	        alert('Service name must be at least 3 characters long (excluding spaces)');
	        document.getElementById('service_name').focus();
	        return false;
	    }
	    
	    // service name space check
	    if (!serviceName.replace(/\s/g, '').length) {
	        alert('Service name cannot contain only spaces');
	        document.getElementById('service_name').focus();
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
	    
	    // price validation
	    if (isNaN(price) || price <= 0) {
	        alert('Please enter a valid price greater than 0');
	        document.getElementById('price').focus();
	        return false;
	    }
	    
	    // category validation
	    if (!categoryId) {
	        alert('Please select a category');
	        document.getElementById('category_id').focus();
	        return false;
	    }
	    
	    // submit when all pass checks
	    this.submit();
	});
	
 	// no space allowance at start of input field
	document.getElementById('service_name').addEventListener('input', function(e) {
		// only allow one consecutive space
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
	
	// price validation
	document.getElementById('price').addEventListener('input', function(e) {
	   	// only allow numbers
	    this.value = this.value.replace(/[^\d.]/g, '');
	    
	    // only allow one decimal point
	    const decimalCount = this.value.split('.').length - 1;
	    if (decimalCount > 1) {
	        this.value = this.value.replace(/\.+$/, '');
	    }
	    
	    // allow only two decimal places
	    if (this.value.includes('.')) {
	        const parts = this.value.split('.');
	        if (parts[1].length > 2) {
	            this.value = parseFloat(this.value).toFixed(2);
	        }
	    }
	});
    </script>
</body>
</html>