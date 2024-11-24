<%@ page import="java.sql.*"%>
<%@ page import="java.security.MessageDigest"%>
<%@ page import="java.security.NoSuchAlgorithmException"%>
<%@ page import="java.util.ArrayList"%>
<%@ include file="components/modals/user/userModal.jsp"%>
<%@ include file="components/modals/user/confirmationModal.jsp"%>
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
	<!-- userId and admin check -->
	<%@ page import="utils.DBFunctions" %>
	<%
	    String customerIdss = (String)session.getAttribute("userid");
	    if (customerIdss == null || !DBFunctions.checkAdminAuth(customerIdss)) {
	        response.sendRedirect("/JADProject/newlogin.jsp");
	        return;
	    }
	%>
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

			<!-- content -->
			<div class="p-6">
				<div class="bg-white rounded-lg shadow-sm">
					<div class="p-6">
						<!-- header-->
						<div class="flex justify-between items-center mb-6">
							<h2 class="text-xl font-bold">All users</h2>
							<div class="flex gap-2">
								<button onclick="openModal('userModal')"
									class="px-4 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700 flex items-center gap-2">
									<i class="fas fa-plus"></i> Add user
								</button>
								<select id="filterSelect" onchange="applyFilter(this.value)"
								    class="px-4 py-2 bg-gray-100 text-gray-700 rounded-lg hover:bg-gray-200 border-none focus:ring-2 focus:ring-blue-500">
								    <option value="">All Users</option>
								    <option value="role:admin">Admins Only</option>
								    <option value="role:user">Regular Users Only</option>
								    <option value="status:active">Active Users</option>
								    <option value="status:inactive">Deactivated Users</option>
								</select>
							</div>
						</div>

						<!-- search bar & pagination -->
						<div class="flex justify-between items-center mb-6">
							<div class="relative flex-1 max-w-md">
								<input type="text" id="searchInput"
									placeholder="Search for users"
									class="w-full pl-10 pr-4 py-2 border rounded-lg focus:outline-none focus:border-blue-500"
									value="<%=request.getParameter("search") != null ? request.getParameter("search") : ""%>">
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

						<!-- table -->
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
									<%!
									int getPageSize(String size, int total) {
										try {
											int val = Integer.parseInt(size);
											return (val > 0 && val <= 100) ? val : 10; // Max 100, default 10
										} catch (Exception e) {
											return 10;
										}
									}

									int getPageNumber(String page, int total, int size) {
										try {
											int val = Integer.parseInt(page);
											int maxPages = Math.max(1, (int) Math.ceil((double) total / size));
											return Math.min(Math.max(1, val), maxPages);
										} catch (Exception e) {
											return 1;
										}
									}
									%>
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
										// Database connection
										Class.forName("com.mysql.cj.jdbc.Driver");
										String connURL = "jdbc:mysql://localhost:3306/JADCA1?user=root&password=BlaBla968@gmail.com!&serverTimezone=UTC";
										conn = DriverManager.getConnection(connURL);

										// total count of users
										StringBuilder countSql = new StringBuilder("SELECT COUNT(*) as total FROM user");
										// every user in db
										StringBuilder dataSql = new StringBuilder(
										"SELECT customer_id, first_name, last_name, email, phone_number, address, admin, status FROM user");

										StringBuilder whereClause = new StringBuilder();
										ArrayList<Object> params = new ArrayList<>();

										// if smt is in search add this part to filter out basically
										String searchQuery = request.getParameter("search");
										if (searchQuery != null && !searchQuery.trim().isEmpty()) {
											whereClause
											.append(" WHERE (first_name LIKE ? OR last_name LIKE ? OR CONCAT(first_name, ' ', last_name) LIKE ?)");
											params.add("%" + searchQuery + "%");
											params.add("%" + searchQuery + "%");
											params.add("%" + searchQuery + "%");
										}

										// role filter
										String roleFilter = request.getParameter("roleFilter");
										if (roleFilter != null && !roleFilter.trim().isEmpty()) {
											if (whereClause.length() == 0) {
										whereClause.append(" WHERE");
											} else {
										whereClause.append(" AND");
											}
											whereClause.append(" admin = ?");
											params.add(roleFilter.equals("admin"));
										}

										// status filter
										String statusFilter = request.getParameter("statusFilter");
										if (statusFilter != null && !statusFilter.trim().isEmpty()) {
											if (whereClause.length() == 0) {
										whereClause.append(" WHERE");
											} else {
										whereClause.append(" AND");
											}
											whereClause.append(" status = ?");
											params.add(statusFilter.equals("active"));
										}

										// add the where or and
										countSql.append(whereClause);
										dataSql.append(whereClause);

										// add pagination
										dataSql.append(" LIMIT ? OFFSET ?");

										// total count (how this works err a bit long to explain basically run for loop to fill in param entered earlier)
										PreparedStatement countStmt = conn.prepareStatement(countSql.toString());
										int paramIndex = 1;
										if (searchQuery != null && !searchQuery.trim().isEmpty()) {
											String searchPattern = "%" + searchQuery + "%";
											for (int i = 1; i <= 3; i++) {
										countStmt.setString(paramIndex++, searchPattern);
											}
										}

										// role filter
										if (roleFilter != null && !roleFilter.trim().isEmpty()) {
											countStmt.setBoolean(paramIndex++, roleFilter.equals("admin"));
										}

										// status filter
										if (statusFilter != null && !statusFilter.trim().isEmpty()) {
											countStmt.setBoolean(paramIndex++, statusFilter.equals("active"));
										}

										countRs = countStmt.executeQuery();
										totalRecords = countRs.next() ? countRs.getInt("total") : 0;

										// all user data (how this works err a bit long to explain basically run for loop to fill in param entered earlier)
										pageSize = getPageSize(request.getParameter("pageSize"), totalRecords);
										currentPage = getPageNumber(request.getParameter("page"), totalRecords, pageSize);
										totalPages = (int) Math.ceil((double) totalRecords / pageSize);
										offset = (currentPage - 1) * pageSize;

										// paginated data same thing with the searchquery
										pstmt = conn.prepareStatement(dataSql.toString());
										paramIndex = 1;
										if (searchQuery != null && !searchQuery.trim().isEmpty()) {
											String searchPattern = "%" + searchQuery + "%";
											for (int i = 0; i < 3; i++) {
										pstmt.setString(paramIndex++, searchPattern);
											}
										}

										if (roleFilter != null && !roleFilter.trim().isEmpty()) {
											pstmt.setBoolean(paramIndex++, roleFilter.equals("admin"));
										}

										if (statusFilter != null && !statusFilter.trim().isEmpty()) {
											pstmt.setBoolean(paramIndex++, statusFilter.equals("active"));
										}

										pstmt.setInt(paramIndex++, pageSize);
										pstmt.setInt(paramIndex, offset);

										rs = pstmt.executeQuery();

										while (rs.next()) {
											int userId = rs.getInt("customer_id");
											String firstName = rs.getString("first_name");
											String lastName = rs.getString("last_name");
											String email = rs.getString("email");
											String phoneNumber = rs.getString("phone_number");
											String address = rs.getString("address");
											boolean isAdmin = rs.getBoolean("admin");
											boolean userStatus = rs.getBoolean("status");
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
											class="px-2 py-1 <%=userStatus ? "bg-green-100 text-green-800" : "bg-red-100 text-red-800"%> rounded-full text-sm w-32 inline-flex items-center">
												<i class="fas fa-circle text-xs mr-2"></i> <%=userStatus ? "Enabled" : "Disabled"%>
										</span></td>
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
												<button class="p-2 text-red-600 hover:bg-red-50 rounded-lg"
													onclick="openDeactivationModal(<%=userId%>, <%=userStatus%>)">
													<i
														class="fas <%=userStatus ? "fa-user-slash" : "fa-user-check"%>"></i>
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
													<%
													int startRecord = offset + 1;
													int endRecord = Math.min(offset + pageSize, totalRecords);
													if(totalRecords == 0) { 
												        startRecord = 0;
												        endRecord = 0;
												    }
													%>
													Showing
													<%=startRecord%>
													to
													<%=endRecord%>
													of
													<%=totalRecords%>
													entries
												</div>
												<div class="flex gap-2">
													<%
													if (currentPage > 1) {
													%>
													<a
														href="?page=<%=currentPage - 1%>&pageSize=<%=pageSize%><%=request.getParameter("search") != null ? "&search=" + request.getParameter("search") : ""%>"
														class="px-3 py-1 border rounded hover:bg-gray-50">Previous</a>
													<%
													}
													%>
													<%
													for (int i = 1; i <= totalPages; i++) {
													%>
													<a
														href="?page=<%=i%>&pageSize=<%=pageSize%><%=request.getParameter("search") != null ? "&search=" + request.getParameter("search") : ""%>"
														class="px-3 py-1 border rounded <%=i == currentPage ? "bg-blue-600 text-white" : "hover:bg-gray-50"%>">
														<%=i%>
													</a>
													<%
													}
													%>

													<%
													if (currentPage < totalPages) {
													%>
													<a
														href="?page=<%=currentPage + 1%>&pageSize=<%=pageSize%><%=request.getParameter("search") != null ? "&search=" + request.getParameter("search") : ""%>"
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
            const validSize = !isNaN(size) && size > 0 && size <= 100 ? size : 10;
            const url = new URL(window.location.href);
            url.searchParams.set('pageSize', validSize);
            url.searchParams.set('page', '1'); // reset to first page
            window.location.href = url.toString();
        }

        // set page number in dropdown
        document.addEventListener('DOMContentLoaded', function() {
            const urlParams = new URLSearchParams(window.location.search);
            const pageSize = urlParams.get('pageSize') || '10';
            const validPageSize = !isNaN(pageSize) && pageSize > 0 && pageSize <= 100 ? pageSize : '10';
            document.getElementById('pageSize').value = validPageSize;
        });
        
        // close alert after update or create
        document.addEventListener('DOMContentLoaded', function() {
            const statusAlert = document.getElementById('statusAlert');
            if (statusAlert) {
                setTimeout(() => {
                    statusAlert.remove();
                    
                    // remove url param for page size and number
                    const url = new URL(window.location.href);
                    url.searchParams.delete('status');
                    url.searchParams.delete('message');
                    window.history.replaceState({}, '', url);
                }, 5000);
            }
        });

     // search functionality
        document.addEventListener('DOMContentLoaded', function() {
            const searchInput = document.getElementById('searchInput');
            
            searchInput.addEventListener('keyup', function(event) {
                // check for enter key input
                if (event.key === 'Enter') {
                    const searchValue = this.value.trim();
                    const url = new URL(window.location.href);
                    
                    // if empty show all results
                    if (!searchValue) {
                        url.searchParams.delete('search');
                    } else {
                        url.searchParams.set('search', searchValue);
                    }
                    
                    // reset page when search 
                    url.searchParams.set('page', '1');
                    
                    // keep page size
                    const currentPageSize = url.searchParams.get('pageSize');
                    if (currentPageSize) {
                        url.searchParams.set('pageSize', currentPageSize);
                    }
                    
                    window.location.href = url.toString();
                }
            });
        });
     
        function applyFilter(filterValue) {
            const url = new URL(window.location.href);
            
            // clear filter params
            url.searchParams.delete('roleFilter');
            url.searchParams.delete('statusFilter');
            
            // apply fiter
            if (filterValue.startsWith('role:')) {
                url.searchParams.set('roleFilter', filterValue.split(':')[1]);
            } else if (filterValue.startsWith('status:')) {
                url.searchParams.set('statusFilter', filterValue.split(':')[1]);
            }
            
            // go back first page
            url.searchParams.set('page', '1');
            
            // keep page size
            const currentPageSize = url.searchParams.get('pageSize');
            if (currentPageSize) {
                url.searchParams.set('pageSize', currentPageSize);
            }
            
            // keep search param
            const currentSearch = url.searchParams.get('search');
            if (currentSearch) {
                url.searchParams.set('search', currentSearch);
            }
            
            window.location.href = url.toString();
        }

        // set filter on the text
        document.addEventListener('DOMContentLoaded', function() {
		    const urlParams = new URLSearchParams(window.location.search);
		    const roleFilter = urlParams.get('roleFilter');
		    const statusFilter = urlParams.get('statusFilter');
		    const filterSelect = document.getElementById('filterSelect');
		    
		    if (roleFilter === 'admin') {
		        filterSelect.value = 'role:admin';
		    } else if (roleFilter === 'user') {
		        filterSelect.value = 'role:user';
		    } else if (statusFilter === 'active') {
		        filterSelect.value = 'status:active';
		    } else if (statusFilter === 'inactive') {
		        filterSelect.value = 'status:inactive';
		    } else {
		        filterSelect.value = '';
		    }
		});
    </script>
</body>
</html>