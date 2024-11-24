<%@ page import="java.sql.*"%>
<%@ page import="java.security.MessageDigest"%>
<%@ page import="java.security.NoSuchAlgorithmException"%>
<%@ page import="java.util.ArrayList"%>
<%@ include file="components/modals/category/categoryModal.jsp"%>
<%@ include file="components/modals/category/confirmationModal.jsp"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Categories List</title>
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
			<div class="font-bold text-3xl py-2">Categories List</div>

			<!-- content -->
			<div class="p-6">
				<div class="bg-white rounded-lg shadow-sm">
					<div class="p-6">
						<!-- header-->
						<div class="flex justify-between items-center mb-6">
							<h2 class="text-xl font-bold">All Categories</h2>
							<div class="flex gap-2">
								<button 
								    onclick="event.preventDefault(); openModal('categoryModal');"
								    class="px-4 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700 flex items-center gap-2">
								    <i class="fas fa-plus"></i> Add Category
								</button>
							</div>
						</div>

						<!-- search bar & pagination -->
						<div class="flex justify-between items-center mb-6">
							<div class="relative flex-1 max-w-md">
								<input type="text" id="searchInput"
									placeholder="Search for Categories"
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
							            <th class="pb-4 font-medium w-24">ID</th>
							            <th class="pb-4 font-medium w-64">NAME</th>
							            <th class="pb-4 font-medium">DESCRIPTION</th>
							            <th class="pb-4 font-medium text-right">ACTIONS</th>
							        </tr>
							    </thead>
							    <tbody>
									<%!int getPageSize(String size, int total) {
										try {
											int val = Integer.parseInt(size);
											return (val > 0 && val <= 100) ? val : 10;
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
									}%>
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
										Class.forName("com.mysql.cj.jdbc.Driver");
										String connURL = "jdbc:mysql://localhost:3306/JADCA1?user=root&password=BlaBla968@gmail.com!&serverTimezone=UTC";
										conn = DriverManager.getConnection(connURL);

										StringBuilder countSql = new StringBuilder("SELECT COUNT(*) as total FROM service_category");
										StringBuilder dataSql = new StringBuilder("SELECT category_id, category_name, description FROM service_category");

										StringBuilder whereClause = new StringBuilder();
										ArrayList<Object> params = new ArrayList<>();

										String searchQuery = request.getParameter("search");
										ArrayList<String> conditions = new ArrayList<>();

										if (searchQuery != null && !searchQuery.trim().isEmpty()) {
										    conditions.add("(category_name LIKE ? OR description LIKE ? OR CAST(category_id AS CHAR) LIKE ?)");
										    String searchParam = "%" + searchQuery.trim() + "%";
										    params.add(searchParam);
										    params.add(searchParam);
										    params.add(searchParam);
										}

										if (!conditions.isEmpty()) {
											whereClause.append(" WHERE ").append(String.join(" AND ", conditions));
										}

										countSql.append(whereClause);
										dataSql.append(whereClause);

										dataSql.append(" ORDER BY category_id ASC");
										dataSql.append(" LIMIT ? OFFSET ?");

										PreparedStatement countStmt = conn.prepareStatement(countSql.toString());
										int paramCount = 1;
										if (searchQuery != null && !searchQuery.trim().isEmpty()) {
										    String searchPattern = "%" + searchQuery + "%";
										    countStmt.setString(paramCount++, searchPattern);
										    countStmt.setString(paramCount++, searchPattern);
										    countStmt.setString(paramCount, searchPattern);
										}
										
										countRs = countStmt.executeQuery();
										totalRecords = countRs.next() ? countRs.getInt("total") : 0;

										pageSize = getPageSize(request.getParameter("pageSize"), totalRecords);
										currentPage = getPageNumber(request.getParameter("page"), totalRecords, pageSize);
										totalPages = (int) Math.ceil((double) totalRecords / pageSize);
										offset = (currentPage - 1) * pageSize;

										pstmt = conn.prepareStatement(dataSql.toString());
										int paramIndex = 1;
										if (searchQuery != null && !searchQuery.trim().isEmpty()) {
										    String searchPattern = "%" + searchQuery + "%";
										    pstmt.setString(paramIndex++, searchPattern);
										    pstmt.setString(paramIndex++, searchPattern);
										    pstmt.setString(paramIndex++, searchPattern);
										}

										pstmt.setInt(paramIndex++, pageSize);
										pstmt.setInt(paramIndex, offset);

										rs = pstmt.executeQuery();

										while (rs.next()) {
											int categoryId = rs.getInt("category_id");
											String categoryName = rs.getString("category_name");
											String description = rs.getString("description");
									%>
									<tr class="border-b">
							            <td class="py-4 font-medium w-24"><%=categoryId%></td>
							            <td class="py-4 font-medium w-64"><%=categoryName%></td>
							            <td class="py-4"><%=description%></td>
							            <td class="py-4">
							                <div class="flex justify-end gap-3">
							                    <button
							                        onclick="openModal('categoryModal', {
							                            mode: 'edit',
							                            id: <%=categoryId%>,
							                            name: '<%=categoryName.replace("'", "\\'")%>',
							                            description: '<%=description.replace("'", "\\'")%>'
							                        })"
							                        class="p-2 text-blue-600 hover:bg-blue-50 rounded-lg">
							                        <i class="fas fa-edit"></i>
							                    </button>
							                    <button class="p-2 text-red-600 hover:bg-red-50 rounded-lg"
							                        onclick="openDeleteModal(<%=categoryId%>)">
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
										<td colspan="4" class="pt-4">
											<div class="flex justify-between items-center">
												<div class="text-sm text-gray-500">
													<%
													int startRecord = offset + 1;
													int endRecord = Math.min(offset + pageSize, totalRecords);
													if (totalRecords == 0) {
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
    </script>
</body>
</html>