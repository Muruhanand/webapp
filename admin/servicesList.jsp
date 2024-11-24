<%@ page import="java.sql.*"%>
<%@ page import="java.security.MessageDigest"%>
<%@ page import="java.security.NoSuchAlgorithmException"%>
<%@ page import="java.util.ArrayList"%>
<%@ include file="components/modals/service/serviceModal.jsp"%>
<%@ include file="components/modals/service/confirmationModal.jsp"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Services List</title>
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
			<div class="font-bold text-3xl py-2">Services List</div>

			<!-- content -->
			<div class="p-6">
				<div class="bg-white rounded-lg shadow-sm">
					<div class="p-6">
						<!-- header-->
						<div class="flex justify-between items-center mb-6">
							<h2 class="text-xl font-bold">All Services</h2>
							<div class="flex gap-2">
								<button onclick="openModal('userModal')"
									class="px-4 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700 flex items-center gap-2">
									<i class="fas fa-plus"></i> Add Service
								</button>
								<select id="categoryFilter" onchange="applyFilter(this.value)"
									class="px-4 py-2 bg-gray-100 text-gray-700 rounded-lg hover:bg-gray-200 border-none focus:ring-2 focus:ring-blue-500">
									<option value="">All Categories</option>
                                    <%
                                    Connection catConn = null;
                                    PreparedStatement catStmt = null;
                                    ResultSet catRs = null;
                                    
                                    try {
                                        Class.forName("com.mysql.cj.jdbc.Driver");
                                        String connURL = "jdbc:mysql://localhost:3306/JADCA1?user=root&password=BlaBla968@gmail.com!&serverTimezone=UTC";
                                        catConn = DriverManager.getConnection(connURL);
                                        
                                        // Fetch all categories
                                        String catQuery = "SELECT category_id, category_name FROM service_category ORDER BY category_name";
                                        catStmt = catConn.prepareStatement(catQuery);
                                        catRs = catStmt.executeQuery();
                                        
                                        while(catRs.next()) {
                                            String categoryId = catRs.getString("category_id");
                                            String categoryName = catRs.getString("category_name");
                                    %>
                                   			 <option value="<%=categoryId%>"><%=categoryName%></option>
                                    <%
                                        }
                                    } catch (Exception e) {
                                        System.err.println("Error loading categories: " + e.getMessage());
                                    } finally {
                                        try {
                                            if (catRs != null) catRs.close();
                                            if (catStmt != null) catStmt.close();
                                            if (catConn != null) catConn.close();
                                        } catch (SQLException e) {
                                            System.err.println("Error closing category resources: " + e.getMessage());
                                        }
                                    }
                                    %>
								</select>
							</div>
						</div>

						<!-- search bar & pagination -->
						<div class="flex justify-between items-center mb-6">
							<div class="relative flex-1 max-w-md">
								<input type="text" id="searchInput"
									placeholder="Search for Services"
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
										<th class="pb-4 font-medium">DESCRIPTION</th>
										<th class="pb-4 font-medium">PRICE</th>
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

										// total count of services
										StringBuilder countSql = new StringBuilder("SELECT COUNT(*) as total FROM service s JOIN service_category sc ON s.category_id = sc.category_id");
										
										// every service in db
										StringBuilder dataSql = new StringBuilder("SELECT s.service_id, s.service_name, s.description, s.price, s.category_id, sc.category_name FROM service s JOIN service_category sc ON s.category_id = sc.category_id");

										StringBuilder whereClause = new StringBuilder();
										ArrayList<Object> params = new ArrayList<>();

										// if smt is in search add this part to filter out basically
										String searchQuery = request.getParameter("search");
										String categoryFilter = request.getParameter("categoryFilter");
										
										// where conditions
										ArrayList<String> conditions = new ArrayList<>();
										
										if (searchQuery != null && !searchQuery.trim().isEmpty()) {
										    conditions.add("(s.service_name LIKE ? OR s.description LIKE ? OR sc.category_name LIKE ?)");
										    String searchParam = "%" + searchQuery.trim() + "%";
										    for(int i = 0; i < 3; i++) {
										        params.add(searchParam);
										    }
										}
										
										if (categoryFilter != null && !categoryFilter.trim().isEmpty()) {
										    conditions.add("s.category_id = ?");
										    params.add(categoryFilter);
										}
										
										if (!conditions.isEmpty()) {
										    whereClause.append(" WHERE ").append(String.join(" AND ", conditions));
										}
										
										// add the where or and
										countSql.append(whereClause);
										dataSql.append(whereClause);
										
										// alphabetical order
										dataSql.append(" ORDER BY s.service_name");

										// add pagination
										dataSql.append(" LIMIT ? OFFSET ?");

										// total count (how this works err a bit long to explain basically run for loop to fill in param entered earlier)
										PreparedStatement countStmt = conn.prepareStatement(countSql.toString());
										int paramCount = 1;
										if (searchQuery != null && !searchQuery.trim().isEmpty()) {
										    String searchPattern = "%" + searchQuery + "%";
										    for(int i = 0; i < 3; i++) {
										        countStmt.setString(paramCount++, searchPattern);
										    }
										}
										
										if (categoryFilter != null && !categoryFilter.trim().isEmpty()) {
										    countStmt.setString(paramCount, categoryFilter);
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
										int paramIndex = 1;
										if (searchQuery != null && !searchQuery.trim().isEmpty()) {
										    String searchPattern = "%" + searchQuery + "%";
										    for (int i = 0; i < 3; i++) {
										        pstmt.setString(paramIndex++, searchPattern);
										    }
										}
										
										if (categoryFilter != null && !categoryFilter.trim().isEmpty()) {
										    pstmt.setString(paramIndex++, categoryFilter);
										}
										
										// pagination param
										pstmt.setInt(paramIndex++, pageSize);
										pstmt.setInt(paramIndex, offset);
 									
 										rs = pstmt.executeQuery();

										while (rs.next()) {											
											int serviceId = rs.getInt("s.service_id");
										    String serviceName = rs.getString("s.service_name");
										    String description = rs.getString("s.description");
										    double price = rs.getDouble("s.price");
										    int categoryId = rs.getInt("s.category_id");
										    String categoryName = rs.getString("sc.category_name");

									%>
									<tr class="border-b">
										<td class="py-4">
											<div class="flex items-center gap-3">
												<div>
													<div class="font-medium"><%=serviceName%></div>
													<div class="text-sm text-gray-500"><%=categoryName%></div>
												</div>
											</div>
										</td>
										<td class="py-4"><%=description%></td>
										<td class="py-4"><%="$" + price%></td>
										<td class="py-4">
											<div class="flex justify-end gap-3">
												<button
													onclick="openModal('serviceModal', {
                                                        mode: 'edit',
                                                        id: <%=serviceId%>,                                                  
                                                        description: '<%=description.replace("'", "\\'")%>',
                                                        price: '<%= String.valueOf(price).replace("'", "\\'") %>',
                                                        category_id: '<%=String.valueOf(categoryId).replace("'", "\\'") %>',                                                       
                                                        })"
													class="p-2 text-blue-600 hover:bg-blue-50 rounded-lg">
													<i class="fas fa-edit"></i>
												</button>
												<button class="p-2 text-red-600 hover:bg-red-50 rounded-lg"
													onclick="openDeleteModal(<%=serviceId%>)">
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
														href="?page=<%=currentPage - 1%>&pageSize=<%=pageSize%><%=request.getParameter("search") != null ? "&search=" + request.getParameter("search") : ""%><%=request.getParameter("categoryFilter") != null ? "&categoryFilter=" + request.getParameter("categoryFilter") : ""%>"
    													class="px-3 py-1 border rounded hover:bg-gray-50">Previous</a>
													<%
													}
													%>
													<%
													for (int i = 1; i <= totalPages; i++) {
													%>
													<a href="?page=<%=i%>&pageSize=<%=pageSize%><%=request.getParameter("search") != null ? "&search=" + request.getParameter("search") : ""%><%=request.getParameter("categoryFilter") != null ? "&categoryFilter=" + request.getParameter("categoryFilter") : ""%>"
													    class="px-3 py-1 border rounded <%=i == currentPage ? "bg-blue-600 text-white" : "hover:bg-gray-50"%>">
													    <%=i%>
													</a>
													<%
													}
													%>

													<%
													if (currentPage < totalPages) {
													%>
													<a href="?page=<%=currentPage + 1%>&pageSize=<%=pageSize%><%=request.getParameter("search") != null ? "&search=" + request.getParameter("search") : ""%><%=request.getParameter("categoryFilter") != null ? "&categoryFilter=" + request.getParameter("categoryFilter") : ""%>"
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
 
            if (filterValue) {
		        url.searchParams.set('categoryFilter', filterValue);
		    } else {
		        url.searchParams.delete('categoryFilter');
		    }
            
            // reset to first page
            url.searchParams.set('page', '1');
            
            // keep the page size even after filtering
            const currentPageSize = url.searchParams.get('pageSize');
            if (currentPageSize) {
                url.searchParams.set('pageSize', currentPageSize);
            }
            
            const currentSearch = url.searchParams.get('search');
            if (currentSearch) {
                url.searchParams.set('search', currentSearch);
            }
            
            window.location.href = url.toString();
        }

        // set filter when page is loading
        document.addEventListener('DOMContentLoaded', function() {
		    const urlParams = new URLSearchParams(window.location.search);
		    const categoryFilter = urlParams.get('categoryFilter');
		    if (categoryFilter) {
		        document.getElementById('categoryFilter').value = categoryFilter;
		    }
		});
    </script>
</body>
</html>