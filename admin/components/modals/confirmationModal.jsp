<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Confirmation Modal</title>
</head>
<body>
	<%
	boolean accountStatus = request.getParameter("status") != null
			? Boolean.parseBoolean(request.getParameter("status"))
			: true;

	String modalTitle = accountStatus ? "Confirm Account Deactivation" : "Confirm Account Activation";
	String actionText = accountStatus ? "deactivate" : "activate";
	String mainMessage = String.format("Are you sure you want to %s this account? %s", actionText,
			accountStatus ? "This action cannot be undone." : "This will restore full account access.");
	String subMessage = accountStatus
			? "All associated data will be marked as inactive but retained in the system."
			: "The account will regain access to all previous data and permissions.";
	String buttonText = accountStatus ? "Deactivate Account" : "Activate Account";
	String buttonColorClass = accountStatus ? "bg-red-600 hover:bg-red-700" : "bg-green-600 hover:bg-green-700";
	%>
	<div id="deactivationModal" class="hidden fixed inset-0 z-50"
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
							<h3 id="modal-title" class="text-xl font-semibold text-gray-900">
								<%=modalTitle%>
							</h3>
							<button onclick="closeDeactivationModal()"
								class="text-gray-400 hover:text-gray-500 transition-colors duration-200">
								<i class="fas fa-times"></i>
							</button>
						</div>

						<div class="mt-4 mb-6">
							<p id="main-message" class="text-gray-700"><%=mainMessage%></p>
							<p id="sub-message" class="text-sm text-gray-500 mt-2"><%=subMessage%></p>
						</div>

						<div class="flex items-center justify-end gap-3">
							<button type="button" onclick="closeDeactivationModal()"
								class="px-4 py-2 bg-gray-100 text-gray-700 rounded-lg hover:bg-gray-200 transition-colors duration-200">
								Cancel</button>
							<form action="/JADProject/admin/api/user/disableUser.jsp"
								method="POST">
								<input name="status" id="status" value="<%=accountStatus%>"
									class="hidden" /> <input name="customerId" id="customerId"
									value="" class="hidden" />
								<button id="action-button" type="submit"
									class="px-4 py-2 <%=buttonColorClass%> text-white rounded-lg transition-colors duration-200">
									<%=buttonText%>
								</button>
							</form>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>

	<script>
    function openDeactivationModal(customerId, currentStatus) {
        const modal = document.getElementById('deactivationModal');
        const backdrop = modal.querySelector('.modal-backdrop');
        const content = modal.querySelector('.modal-content');
        
        // Only update the customerId and status inputs
        document.getElementById('customerId').value = customerId;
        document.getElementById('status').value = currentStatus;
        
        // Update button color based on status
        const actionButton = document.getElementById('action-button');
        if (!currentStatus) {
            actionButton.classList.remove('bg-red-600', 'hover:bg-red-700');
            actionButton.classList.add('bg-green-600', 'hover:bg-green-700');
        } else {
            actionButton.classList.remove('bg-green-600', 'hover:bg-green-700');
            actionButton.classList.add('bg-red-600', 'hover:bg-red-700');
        }
        
        // Update modal text content
        document.getElementById('modal-title').textContent = currentStatus ? "Confirm Account Deactivation" : "Confirm Account Activation";
        document.getElementById('main-message').textContent = `Are you sure you want to ${currentStatus ? "deactivate" : "activate"} this account? ${
            currentStatus ? "This action cannot be undone." : "This will restore full account access."
        }`;
        document.getElementById('sub-message').textContent = currentStatus
            ? "All associated data will be marked as inactive but retained in the system."
            : "The account will regain access to all previous data and permissions.";
        actionButton.textContent = currentStatus ? "Deactivate Account" : "Activate Account";
        
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
    }

    function closeDeactivationModal() {
        const modal = document.getElementById('deactivationModal');
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
    </script>
</body>
</html>