<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>User Management Modal</title>
</head>
<body>
	<!-- Create a new file: components/modals/userModal.jsp -->
	<%
	String mode = request.getParameter("mode") != null ? request.getParameter("mode") : "create";
	boolean isEdit = mode.equals("edit");
	String modalTitle = isEdit ? "Edit User" : "Add New User";
	String modalId = "userModal";
	String formAction = isEdit ? "api/user/editUser.jsp" : "api/user/createUser.jsp";
	String submitButtonText = isEdit ? "Save Changes" : "Add User";
	%>

	<div id="<%=modalId%>" class="hidden fixed inset-0 z-50"
		aria-labelledby="modal-title" role="dialog" aria-modal="true">
		<!-- Backdrop -->
		<div
			class="modal-backdrop fixed inset-0 bg-gray-600 transition-opacity duration-300 ease-in-out opacity-0"></div>

		<!-- Modal Container -->
		<div class="fixed inset-0 overflow-y-auto">
			<div
				class="flex min-h-screen items-center justify-center p-4 text-center">
				<!-- Modal Content -->
				<div
					class="modal-content w-full max-w-md transform transition-all duration-300 ease-in-out scale-95 opacity-0">
					<div class="relative bg-white rounded-lg shadow-xl p-6">
						<div class="flex items-center justify-between mb-4">
							<h3 id="modal-title" class="text-xl font-semibold text-gray-900"><%=modalTitle%></h3>
							<button onclick="closeModal('<%=modalId%>')"
								class="text-gray-400 hover:text-gray-500 transition-colors duration-200">
								<i class="fas fa-times"></i>
							</button>
						</div>

						<form action="<%=formAction%>" method="POST" class="mt-4"
							id="userForm">
							<%
							if (isEdit) {
							%>
							<input type="hidden" name="userId" id="userId">
							<%
							}
							%>

							<div class="space-y-4">
								<!-- Name Fields -->
								<div class="grid grid-cols-2 gap-4">
									<div>
										<label class="block text-sm font-medium text-gray-700 mb-1">First
											Name</label> <input type="text" name="first_name" id="first_name"
											required
											class="w-full border border-gray-300 rounded-lg shadow-sm py-2 px-3 focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-blue-500 transition-shadow duration-200">
									</div>

									<div>
										<label class="block text-sm font-medium text-gray-700 mb-1">Last
											Name</label> <input type="text" name="last_name" id="last_name"
											required
											class="w-full border border-gray-300 rounded-lg shadow-sm py-2 px-3 focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-blue-500 transition-shadow duration-200">
									</div>
								</div>

								<!-- Email -->
								<div>
									<label class="block text-sm font-medium text-gray-700 mb-1">Email</label>
									<input type="email" name="email" id="email" required
										class="w-full border border-gray-300 rounded-lg shadow-sm py-2 px-3 focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-blue-500 transition-shadow duration-200">
								</div>

								<!-- Phone Number -->
								<div>
									<label class="block text-sm font-medium text-gray-700 mb-1">Phone
										Number</label> <input type="tel" name="phone_number" id="phone_number"
										required
										class="w-full border border-gray-300 rounded-lg shadow-sm py-2 px-3 focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-blue-500 transition-shadow duration-200">
								</div>

								<!-- Address -->
								<div>
									<label class="block text-sm font-medium text-gray-700 mb-1">Address
									</label> <input type="tel" name="address" id="address" required
										class="w-full border border-gray-300 rounded-lg shadow-sm py-2 px-3 focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-blue-500 transition-shadow duration-200">
								</div>

								<!-- Password Fields -->
								<div class="space-y-4">
									<div>
										<label class="block text-sm font-medium text-gray-700 mb-1">
											Password <%
										if (isEdit) {
										%><span class="text-sm text-gray-500">(Leave blank to
												keep current password)</span> <%
 }
 %>
										</label> <input type="password" name="password" id="password"
											<%=isEdit ? "" : "required"%>
											class="w-full border border-gray-300 rounded-lg shadow-sm py-2 px-3 focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-blue-500 transition-shadow duration-200"
											minlength="8">
									</div>

									<div>
										<label class="block text-sm font-medium text-gray-700 mb-1">Confirm
											Password</label> <input type="password" name="confirmPassword"
											id="confirmPassword" <%=isEdit ? "" : "required"%>
											class="w-full border border-gray-300 rounded-lg shadow-sm py-2 px-3 focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-blue-500 transition-shadow duration-200"
											minlength="8">
									</div>
								</div>

								<!-- Role -->
								<div>
									<label class="block text-sm font-medium text-gray-700 mb-1">Role</label>
									<select name="role" id="role" required
										class="w-full border border-gray-300 rounded-lg shadow-sm py-2 px-3 focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-blue-500 transition-shadow duration-200">
										<option value="user">User</option>
										<option value="admin">Admin</option>
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
	function openModal(modalId, userData = null) {
    	const modal = document.getElementById(modalId);
    	const backdrop = modal.querySelector('.modal-backdrop');
    	const content = modal.querySelector('.modal-content');
    	const modalTitle = modal.querySelector('#modal-title');
    	const submitButton = modal.querySelector('#submitButton');
		const userForm = document.getElementById('userForm');
    
    	// Show modal container
    	modal.classList.remove('hidden');
    
    	// Animate in
    	requestAnimationFrame(() => {
        	backdrop.classList.add('opacity-50');
        	content.classList.add('opacity-100', 'scale-100');
        	content.classList.remove('scale-95', 'opacity-0');
    	});
    
    	// Prevent body scroll
    	document.body.style.overflow = 'hidden';

		// reset form field first
		userForm.reset();

    	// Clear password fields always
    	document.getElementById('password').value = '';
    	document.getElementById('confirmPassword').value = '';


    
    	if (userData && userData.mode === 'edit') {
        	// Edit mode - populate form
			modalTitle.textContent = 'Edit User';
			submitButton.textContent = 'Save Changes';
			userForm.action = 'api/user/editUser.jsp';
        	
			document.getElementById('userId').value = userData.id;
        	document.getElementById('first_name').value = userData.firstName;
        	document.getElementById('last_name').value = userData.lastName;
        	document.getElementById('email').value = userData.email;
        	document.getElementById('phone_number').value = userData.phoneNumber;
        	document.getElementById('address').value = userData.address;
        	document.getElementById('role').value = userData.role;
        
        	// Make password optional in edit mode
        	document.getElementById('password').removeAttribute('required');
        	document.getElementById('confirmPassword').removeAttribute('required');
    	} else {
        	// Change text
			modalTitle.textContent = 'Add New User';
			submitButton.textContent = 'Add User';
			userForm.action = 'api/user/createUser.jsp';

			// Make password required in create mode
        	document.getElementById('password').setAttribute('required', 'required');
        	document.getElementById('confirmPassword').setAttribute('required', 'required');
    	}
	}

	function closeModal(modalId) {
    	const modal = document.getElementById(modalId);
    	const backdrop = modal.querySelector('.modal-backdrop');
    	const content = modal.querySelector('.modal-content');
    
    	// Animate out
    	backdrop.classList.remove('opacity-50');
    	content.classList.remove('opacity-100', 'scale-100');
    	content.classList.add('scale-95', 'opacity-0');
    
    	// Hide modal after animation
    	setTimeout(() => {
        	modal.classList.add('hidden');
        	document.body.style.overflow = 'auto';
    	}, 300);
	}

	// Form validation
	document.getElementById('userForm').addEventListener('submit', function(e) {
    	const password = document.getElementById('password').value;
    	const confirmPassword = document.getElementById('confirmPassword').value;
    
    	if (password !== confirmPassword) {
        	e.preventDefault();
        	alert('Passwords do not match!');
        	return false;
    	}
    
    	if (password && password.length < 8) {
        	e.preventDefault();
        	alert('Password must be at least 8 characters long!');
        	return false;
    	}
	});

</script>
</body>
</html>