<%@ page import="java.sql.*"%>
<%@ page import="java.security.MessageDigest"%>
<%@ page import="java.security.NoSuchAlgorithmException"%>
<%@ include file="components/modals/userModal.jsp"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Users List</title>
<link
	href="https://cdn.jsdelivr.net/npm/tailwindcss@2.2.19/dist/tailwind.min.css"
	rel="stylesheet">
<link
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css"
	rel="stylesheet">
</head>
<body class="bg-gray-100">
	<div class="flex min-h-screen p-4">
		<%@ include file="components/adminSideBar/adminSideBar.jsp"%>
		<div class="flex-1">
			<%@ include file="components/adminNavbar/adminNavbar.jsp"%>
			<%
			String status = request.getParameter("status");
			String message = request.getParameter("message");
			if (status != null && message != null) {
			%>
			<div id="statusAlert"
				class="mx-6 mt-4 px-4 py-3 rounded relative <%=status.equals("success") ? "bg-green-100 text-green-800" : "bg-red-100 text-red-800"%>">
				<div class="flex justify-between items-center">
					<div class="flex items-center">
						<span
							class="<%=status.equals("success") ? "text-green-500" : "text-red-500"%> mr-2">
							<i
							class="fas <%=status.equals("success") ? "fa-check-circle" : "fa-exclamation-circle"%>"></i>
						</span>
						<p class="text-sm font-medium"><%=message%></p>
					</div>
					<button onclick="this.parentElement.parentElement.remove()"
						class="<%=status.equals("success") ? "text-green-500 hover:text-green-600" : "text-red-500 hover:text-red-600"%> 
                               transition-colors duration-200 ml-4">
						<i class="fas fa-times"></i>
					</button>
				</div>
			</div>
			<%
			}
			%>
			<div class="font-bold text-3xl py-2">Users List</div>

			<!-- User List Content -->
			<div class="p-6">
				<div class="bg-white rounded-lg shadow-sm">
					<div class="p-6">
						<!-- Header Section -->
						<div class="flex justify-between items-center mb-6">
							<h2 class="text-xl font-bold">All users</h2>
							<div class="flex gap-2">
								<button onclick="openModal('userModal')"
									class="px-4 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700 flex items-center gap-2">
									<i class="fas fa-plus"></i> Add user
								</button>
								<button
									class="px-4 py-2 bg-gray-100 text-gray-700 rounded-lg hover:bg-gray-200 flex items-center gap-2">
									<i class="fas fa-file-export"></i> Export
								</button>
							</div>
						</div>

						<!-- Search and Page Size Section -->
						<div class="flex justify-between items-center mb-6">
							<div class="relative flex-1 max-w-md">
								<input type="text" placeholder="Search for users"
									class="w-full pl-10 pr-4 py-2 border rounded-lg focus:outline-none focus:border-blue-500">
								<i class="fas fa-search absolute left-3 top-3 text-gray-400"></i>
							</div>
							<div class="flex items-center gap-3">
								<span class="text-sm text-gray-600">Show</span> <select
									id="pageSize" onchange="changePageSize(this.value)"
									class="border rounded-lg px-3 py-2 focus:outline-none focus:border-blue-500">
									<option value="10">10</option>
									<option value="25">25</option>
									<option value="50">50</option>
									<option value="100">100</option>
								</select> <span class="text-sm text-gray-600">entries</span>
							</div>
						</div>

						<!-- Table -->
						<div class="overflow-x-auto">
							<table class="w-full">
								<thead>
									<tr class="text-left text-gray-500 text-sm border-b">
										<th class="pb-4 font-medium">NAME</th>
										<th class="pb-4 font-medium">PHONE NUMBER</th>
										<th class="pb-4 font-medium">ROLE</th>
										<th class="pb-4 font-medium">STATUS</th>
										<th class="pb-4 font-medium text-right">ACTIONS</th>
									</tr>
								</thead>
								<tbody>
									<%
									Connection conn = null;
									PreparedStatement pstmt = null;
									ResultSet rs = null;
									ResultSet countRs = null;
									int totalRecords = 0;
									int totalPages = 0;
									int pageSize = 10;
									int currentPage = 1;
									int offset = 0;

									try {
										// Get pagination parameters
										String pageSizeParam = request.getParameter("pageSize");
										if (pageSizeParam != null && !pageSizeParam.isEmpty()) {
											pageSize = Integer.parseInt(pageSizeParam);
										}

										String pageParam = request.getParameter("page");
										if (pageParam != null && !pageParam.isEmpty()) {
											currentPage = Integer.parseInt(pageParam);
										}

										offset = (currentPage - 1) * pageSize;

										// Database connection
										Class.forName("com.mysql.cj.jdbc.Driver");
										String connURL = "jdbc:mysql://localhost:3306/JADCA1?user=root&password=BlaBla968@gmail.com!&serverTimezone=UTC";
										conn = DriverManager.getConnection(connURL);

										// Get total count
										String countSql = "SELECT COUNT(*) as total FROM user";
										PreparedStatement countStmt = conn.prepareStatement(countSql);
										countRs = countStmt.executeQuery();
										if (countRs.next()) {
											totalRecords = countRs.getInt("total");
										}
										totalPages = (int) Math.ceil((double) totalRecords / pageSize);

										// Get paginated data
										String sqlStr = "SELECT customer_id, first_name, last_name, email, phone_number, address, admin FROM user LIMIT ?";
										pstmt = conn.prepareStatement(sqlStr);
										pstmt.setInt(1, pageSize);
										rs = pstmt.executeQuery();

										while (rs.next()) {
											int userId = rs.getInt("customer_id");
											String firstName = rs.getString("first_name");
											String lastName = rs.getString("last_name");
											String email = rs.getString("email");
											String phoneNumber = rs.getString("phone_number");
											String address = rs.getString("address");
											System.out.println(address);
											boolean isAdmin = rs.getBoolean("admin");
									%>
									<tr class="border-b">
										<td class="py-4">
											<div class="flex items-center gap-3">
												<div>
													<div class="font-medium"><%=firstName + " " + lastName%></div>
													<div class="text-sm text-gray-500"><%=email%></div>
												</div>
											</div>
										</td>
										<td class="py-4"><%=phoneNumber%></td>
										<td class="py-4"><%=isAdmin ? "Admin" : "User"%></td>
										<td class="py-4"><span
											class="px-2 py-1 bg-green-100 text-green-800 rounded-full text-sm">
												Active </span></td>
										<td class="py-4">
											<div class="flex justify-end gap-3">
												<button
													onclick="openModal('userModal', {
    													mode: 'edit',
    													id: <%=userId%>,
    													firstName: '<%=firstName.replace("'", "\\'")%>',
    													lastName: '<%=lastName.replace("'", "\\'")%>',
    													email: '<%=email.replace("'", "\\'")%>',
    													address: '<%=address.replace("'", "\\'")%>',
    													phoneNumber: '<%=phoneNumber.replace("'", "\\'")%>',
    													role: '<%=isAdmin ? "admin" : "user"%>'
														})"
													class="p-2 text-blue-600 hover:bg-blue-50 rounded-lg">
													<i class="fas fa-edit"></i>
												</button>
												<button class="p-2 text-red-600 hover:bg-red-50 rounded-lg">
													<i class="fas fa-trash"></i>
												</button>
											</div>
										</td>
									</tr>
									<%
									}
									} catch (Exception e) {
									System.err.println("Error: " + e.getMessage());
									} finally {
									try {
									if (rs != null)
										rs.close();
									if (countRs != null)
										countRs.close();
									if (pstmt != null)
										pstmt.close();
									if (conn != null)
										conn.close();
									} catch (SQLException e) {
									System.err.println("Error closing resources: " + e.getMessage());
									}
									}
									%>
								</tbody>
								<tfoot>
									<tr>
										<td colspan="5" class="pt-4">
											<div class="flex justify-between items-center">
												<div class="text-sm text-gray-500">
													Showing 1 to
													<%=Math.min(pageSize, totalRecords)%>
													of
													<%=totalRecords%>
													entries
												</div>
												<div class="flex gap-2">
													<%
													if (currentPage > 1) {
													%>
													<a href="?page=<%=currentPage - 1%>&pageSize=<%=pageSize%>"
														class="px-3 py-1 border rounded hover:bg-gray-50">Previous</a>
													<%
													}
													%>

													<%
													for (int i = 1; i <= totalPages; i++) {
													%>
													<a href="?page=<%=i%>&pageSize=<%=pageSize%>"
														class="px-3 py-1 border rounded <%=i == currentPage ? "bg-blue-600 text-white" : "hover:bg-gray-50"%>">
														<%=i%>
													</a>
													<%
													}
													%>

													<%
													if (currentPage < totalPages) {
													%>
													<a href="?page=<%=currentPage + 1%>&pageSize=<%=pageSize%>"
														class="px-3 py-1 border rounded hover:bg-gray-50">Next</a>
													<%
													}
													%>
												</div>
											</div>
										</td>
									</tr>
								</tfoot>
							</table>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>

	<script>
		function changePageSize(size) {
			const url = new URL(window.location.href);
			url.searchParams.set('pageSize', size);
			url.searchParams.set('page', '1'); // Reset to first page
			window.location.href = url.toString();
		}

		// Set selected page size in dropdown
		document.addEventListener('DOMContentLoaded', function() {
			const urlParams = new URLSearchParams(window.location.search);
			const pageSize = urlParams.get('pageSize') || '10';
			document.getElementById('pageSize').value = pageSize;
		});
		
		document.addEventListener('DOMContentLoaded', function() {
	        const statusAlert = document.getElementById('statusAlert');
	        if (statusAlert) {
	            setTimeout(() => {
	                statusAlert.remove();
	                
	                // Remove status parameters from URL
	                const url = new URL(window.location.href);
	                url.searchParams.delete('status');
	                url.searchParams.delete('message');
	                window.history.replaceState({}, '', url);
	            }, 5000);
	        }
	    });
	</script>
</body>
</html>