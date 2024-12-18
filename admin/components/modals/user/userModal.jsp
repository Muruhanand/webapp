<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>User Management Modal</title>
</head>
<body>
<!-- userId and admin check -->
	<%@ page import="utils.DBFunctions" %>
	<%
	    String customerIds = (String)session.getAttribute("userid");
	    if (customerIds == null || !DBFunctions.checkAdminAuth(customerIds)) {
	        response.sendRedirect("/JADProject/newlogin.jsp");
	        return;
	    }
	%>
	<%
	String mode = request.getParameter("mode") != null ? request.getParameter("mode") : "create";
	boolean isEdit = mode.equals("edit");
	String editModalTitle = isEdit ? "Edit User" : "Add New User";
	String modalId = "userModal";
	String formAction = isEdit ? "api/user/editUser.jsp" : "api/user/createUser.jsp";
	String submitButtonText = isEdit ? "Save Changes" : "Add User";
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
							id="userForm">
							<%
							if (isEdit) {
							%>
							<input type="hidden" name="userId" id="userId">
							<%
							}
							%>

							<div class="space-y-4">
								<input class="hidden" name="userId" id="userId" />
								<!-- name (first and last) -->
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

								<!-- email -->
								<div>
									<label class="block text-sm font-medium text-gray-700 mb-1">Email</label>
									<input type="email" name="email" id="email" required
										class="w-full border border-gray-300 rounded-lg shadow-sm py-2 px-3 focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-blue-500 transition-shadow duration-200">
								</div>

								<!-- number -->
								<div>
									<label class="block text-sm font-medium text-gray-700 mb-1">Phone
										Number</label> <input type="tel" name="phone_number" id="phone_number"
										required
										class="w-full border border-gray-300 rounded-lg shadow-sm py-2 px-3 focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-blue-500 transition-shadow duration-200">
								</div>

								<!-- address -->
								<div>
									<label class="block text-sm font-medium text-gray-700 mb-1">Address
									</label> <input type="tel" name="address" id="address" required
										class="w-full border border-gray-300 rounded-lg shadow-sm py-2 px-3 focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-blue-500 transition-shadow duration-200">
								</div>

								<!-- password and confirm -->
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

								<!-- role -->
								<div>
									<label class="block text-sm font-medium text-gray-700 mb-1">Role</label>
									<select name="role" id="role" required
										class="w-full border border-gray-300 rounded-lg shadow-sm py-2 px-3 focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-blue-500 transition-shadow duration-200">
										<option value="false">User</option>
										<option value="true">Admin</option>
									</select>
								</div>
							</div>

							<!-- form buttons -->
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
    	const editModalTitle = modal.querySelector('#modal-title');
    	const submitButton = modal.querySelector('#submitButton');
		const userForm = document.getElementById('userForm');
    
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

		// reset form field first
		userForm.reset();

    	// always clear password fields 
    	document.getElementById('password').value = '';
    	document.getElementById('confirmPassword').value = '';


    
    	if (userData && userData.mode === 'edit') {
			editModalTitle.textContent = 'Edit User';
			submitButton.textContent = 'Save Changes';
			userForm.action = 'api/user/editUser.jsp';
			console.log(userData);
        	
			document.getElementById('userId').value = userData.id;
        	document.getElementById('first_name').value = userData.firstName;
        	document.getElementById('last_name').value = userData.lastName;
        	document.getElementById('email').value = userData.email;
        	document.getElementById('phone_number').value = userData.phoneNumber;
        	document.getElementById('address').value = userData.address;
        	document.getElementById('role').value = userData.role;
        
        	// make password optional for the blank thingy if u read the code yk what this is
        	document.getElementById('password').removeAttribute('required');
        	document.getElementById('confirmPassword').removeAttribute('required');
    	} else {
       		// change text and action
			editModalTitle.textContent = 'Add New User';
			submitButton.textContent = 'Add User';
			userForm.action = 'api/user/createUser.jsp';

			// make passwrod required
        	document.getElementById('password').setAttribute('required', 'required');
        	document.getElementById('confirmPassword').setAttribute('required', 'required');
    	}
	}

	function closeModal(modalId) {
    	const modal = document.getElementById(modalId);
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

	// validate form
	document.getElementById('userForm').addEventListener('submit', function(e) {
		// dont allow form submission
	    e.preventDefault(); 
	    
	    // obtain values and trim whitespace
	    const firstName = document.getElementById('first_name').value.trim();
	    const lastName = document.getElementById('last_name').value.trim();
	    const email = document.getElementById('email').value.trim();
	    const phoneNumber = document.getElementById('phone_number').value.trim();
	    const address = document.getElementById('address').value.trim();
	    const password = document.getElementById('password').value;
	    const confirmPassword = document.getElementById('confirmPassword').value;
	    const role = document.getElementById('role').value;
	    
	    // first name validation
	    if (!firstName || !firstName.replace(/\s/g, '').length) {
	        alert('First name cannot be empty or contain only spaces');
	        document.getElementById('first_name').focus();
	        return false;
	    }
	    
	    if (firstName.length < 2) {
	        alert('First name must be at least 2 characters long');
	        document.getElementById('first_name').focus();
	        return false;
	    }
	    
	    // last name validation
	    if (!lastName || !lastName.replace(/\s/g, '').length) {
	        alert('Last name cannot be empty or contain only spaces');
	        document.getElementById('last_name').focus();
	        return false;
	    }
	    
	    if (lastName.length < 2) {
	        alert('Last name must be at least 2 characters long');
	        document.getElementById('last_name').focus();
	        return false;
	    }
	    
	    // email validation
	    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
	    if (!email || !emailRegex.test(email)) {
	        alert('Please enter a valid email address');
	        document.getElementById('email').focus();
	        return false;
	    }
	    
	    // phone number validation
	    const phoneRegex = /^[689]\d{7}$/;
	    if (!phoneNumber || !phoneRegex.test(phoneNumber)) {
	        alert('Please enter a valid 8-digit phone number starting with 6, 8, or 9');
	        document.getElementById('phone_number').focus();
	        return false;
	    }
	    
	    // address validation
	    if (!address || !address.replace(/\s/g, '').length) {
	        alert('Address cannot be empty or contain only spaces');
	        document.getElementById('address').focus();
	        return false;
	    }
	    
	    if (address.length < 5) {
	        alert('Address must be at least 5 characters long');
	        document.getElementById('address').focus();
	        return false;
	    }
	    
	    // password validation
	    const isEdit = document.querySelector('#userForm').action.includes('editUser.jsp');
	    
	    if (!isEdit || (isEdit && password.length > 0)) {
	        if (password !== confirmPassword) {
	            alert('Passwords do not match!');
	            return false;
	        }
	        
	        if (password && password.length < 8) {
	            alert('Password must be at least 8 characters long!');
	            return false;
	        }
	    }
	    
	    // submit when pass all checks
	    this.submit();
	});
	
	// no space allowance at start of input field
	const textInputs = ['first_name', 'last_name', 'address'];
	textInputs.forEach(inputId => {
	    document.getElementById(inputId).addEventListener('input', function(e) {
	        // only allow one consecutive space
	        if (this.value.startsWith(' ')) {
	            this.value = this.value.trimStart();
	        }
	        
	        // only letters, spaces and basic punctuation allowed
	        this.value = this.value.replace(/[^\w\s-']/g, '');
	    });
	});
	
	// phone number validation on input
	document.getElementById('phone_number').addEventListener('input', function(e) {
	    // Remove any non-digit characters
	    this.value = this.value.replace(/\D/g, '');
	    
	    // Limit to 8 digits
	    if (this.value.length > 8) {
	        this.value = this.value.slice(0, 8);
	    }
	});
	
	// email validation on input
	document.getElementById('email').addEventListener('input', function(e) {
	    // Remove spaces as they're typed
	    this.value = this.value.replace(/\s/g, '');
	});
</script>
</body>
</html>