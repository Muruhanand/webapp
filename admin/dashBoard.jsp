<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Admin Dashboard</title>
<link
	href="https://cdn.jsdelivr.net/npm/tailwindcss@2.2.19/dist/tailwind.min.css"
	rel="stylesheet">
<link
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css"
	rel="stylesheet">
</head>
<body class="bg-gray-100">
	<!-- userId and admin check -->
	<%@ page import="utils.DBFunctions"%>
	<%
	String userId = (String) session.getAttribute("userid");
	if (userId == null || !DBFunctions.checkAdminAuth(userId)) {
		response.sendRedirect("/JADProject/newlogin.jsp");
		return;
	}
	%>

	<div class="flex min-h-screen p-4">
		<%@ include file="components/adminSideBar/adminSideBar.jsp"%>
		<div class="flex-1">
			<%@ include file="components/adminNavbar/adminNavbar.jsp"%>
			<%
			Connection conn = null;

			// preparesStatement metrics
			PreparedStatement psBookings = null;
			PreparedStatement psReviews = null;
			PreparedStatement psServices = null;
			PreparedStatement psUsers = null;

			// preparedStatement tables
			PreparedStatement psTopServices = null;
			PreparedStatement psRecentBookings = null;
			PreparedStatement psHighValue = null;

			// resultset metric
			ResultSet rsBookings = null;
			ResultSet rsReviews = null;
			ResultSet rsServices = null;
			ResultSet rsUsers = null;

			// resultset table
			ResultSet rsTopServices = null;
			ResultSet rsRecentBookings = null;
			ResultSet rsHighValue = null;

			try {
				Class.forName("com.mysql.cj.jdbc.Driver");
				String connURL = "jdbc:mysql://localhost:3306/JADCA1?user=root&password=BlaBla968@gmail.com!&serverTimezone=UTC";
				conn = DriverManager.getConnection(connURL);

				// prepare metric statement
				psBookings = conn.prepareStatement("SELECT COUNT(*) as total FROM bookings");
				psReviews = conn.prepareStatement("SELECT COUNT(*) as total FROM feedback");
				psServices = conn.prepareStatement("SELECT COUNT(*) as total FROM service");
				psUsers = conn.prepareStatement("SELECT COUNT(*) as total FROM user WHERE admin = false");

				// execute metric query
				rsBookings = psBookings.executeQuery();
				rsReviews = psReviews.executeQuery();
				rsServices = psServices.executeQuery();
				rsUsers = psUsers.executeQuery();

				// obtain metric value
				int totalBookings = rsBookings.next() ? rsBookings.getInt("total") : 0;
				int totalReviews = rsReviews.next() ? rsReviews.getInt("total") : 0;
				int totalServices = rsServices.next() ? rsServices.getInt("total") : 0;
				int totalUsers = rsUsers.next() ? rsUsers.getInt("total") : 0;

				// top 5 services
				String topServicesQuery = "SELECT s.service_name, sc.category_name, s.price, COUNT(b.booking_id) as booking_count "
				+ "FROM service s " + "LEFT JOIN bookings b ON s.service_id = b.service_id "
				+ "LEFT JOIN service_category sc ON s.category_id = sc.category_id "
				+ "GROUP BY s.service_id, s.service_name, sc.category_name, s.price " + "ORDER BY booking_count DESC "
				+ "LIMIT 5";

				// most recent booking
				String recentBookingsQuery = "SELECT s.service_name, u.first_name, u.last_name, b.total_price, b.created_at "
				+ "FROM bookings b " + "JOIN service s ON b.service_id = s.service_id "
				+ "JOIN user u ON b.customer_id = u.customer_id " + "WHERE b.status = 'completed' "
				+ "ORDER BY b.created_at DESC " + "LIMIT 5";

				// high-value booking
				String highValueBookingsQuery = "SELECT u.first_name, u.last_name, b.total_price, b.created_at "
				+ "FROM bookings b " + "JOIN user u ON b.customer_id = u.customer_id "
				+ "WHERE b.total_price > 100 AND b.status = 'completed' " + "ORDER BY b.total_price DESC " + "LIMIT 5";

				// execute query
				psTopServices = conn.prepareStatement(topServicesQuery);
				psRecentBookings = conn.prepareStatement(recentBookingsQuery);
				psHighValue = conn.prepareStatement(highValueBookingsQuery);

				rsTopServices = psTopServices.executeQuery();
				rsRecentBookings = psRecentBookings.executeQuery();
				rsHighValue = psHighValue.executeQuery();
			%>
			
			<%
				PreparedStatement psUser = null;
				ResultSet rsUser = null;
				String userName = "";
				
				try {
				    psUser = conn.prepareStatement("SELECT first_name, last_name FROM user WHERE customer_id = ?");
				    psUser.setString(1, userId);
				    rsUser = psUser.executeQuery();
				    if (rsUser.next()) {
				        userName = rsUser.getString("first_name") + " " + rsUser.getString("last_name");
				    }
				} catch (SQLException e) {
				    System.err.println("Error getting user name: " + e.getMessage());
				} finally {
				    if (rsUser != null) rsUser.close();
				    if (psUser != null) psUser.close();
				}
			%>			
			<!-- metrics -->
			<div class="font-bold text-3xl py-2">Hello, <%= userName %></div>
			<div class="w-full p-4">
				<div class="flex gap-6">
					<!-- total booking -->
					<div class="bg-white rounded-lg shadow-sm p-6 flex-1">
						<div class="flex items-center gap-4">
							<div class="text-blue-500">
								<i class="fas fa-calendar-check text-2xl"></i>
							</div>
							<div>
								<div class="text-2xl font-bold"><%=totalBookings%></div>
								<div class="text-gray-500 text-sm">Total Bookings</div>
							</div>
						</div>
					</div>

					<!-- count of review -->
					<div class="bg-white rounded-lg shadow-sm p-6 flex-1">
						<div class="flex items-center gap-4">
							<div class="text-yellow-500">
								<i class="fas fa-star text-2xl"></i>
							</div>
							<div>
								<div class="text-2xl font-bold"><%=totalReviews%></div>
								<div class="text-gray-500 text-sm">Total Reviews</div>
							</div>
						</div>
					</div>

					<!-- count of services -->
					<div class="bg-white rounded-lg shadow-sm p-6 flex-1">
						<div class="flex items-center gap-4">
							<div class="text-green-500">
								<i class="fas fa-broom text-2xl"></i>
							</div>
							<div>
								<div class="text-2xl font-bold"><%=totalServices%></div>
								<div class="text-gray-500 text-sm">Total Services</div>
							</div>
						</div>
					</div>

					<!-- count of users -->
					<div class="bg-white rounded-lg shadow-sm p-6 flex-1">
						<div class="flex items-center gap-4">
							<div class="text-purple-500">
								<i class="fas fa-users text-2xl"></i>
							</div>
							<div>
								<div class="text-2xl font-bold"><%=totalUsers%></div>
								<div class="text-gray-500 text-sm">Current Users</div>
							</div>
						</div>
					</div>
				</div>
			</div>

			<!-- top services -->
			<div class="w-full px-4 flex flex-col gap-6">
				<div class="bg-white rounded-lg shadow-sm p-6 mt-6">
					<div class="mb-4">
						<h2 class="text-xl font-bold">Top Services Provided</h2>
					</div>
					<div class="overflow-x-auto">
						<table class="w-full">
							<thead>
								<tr class="text-left text-gray-500 text-sm border-b">
									<th class="pb-4">SERVICE</th>
									<th class="pb-4">CATEGORY</th>
									<th class="pb-4">PRICE</th>
								</tr>
							</thead>
							<tbody>
								<%
								while (rsTopServices.next()) {
								%>
								<tr class="border-b">
									<td class="py-4">
										<div class="flex items-center gap-3">
											<div class="w-12 h-12 bg-gray-200 rounded-lg overflow-hidden">
												<img src="/JADProject/assets/services/default.jpg"
													alt="Service Image" class="w-full h-full object-cover">
											</div>
											<div>
												<div class="font-medium"><%=rsTopServices.getString("service_name")%></div>
												<div class="text-sm text-green-600"><%=rsTopServices.getInt("booking_count")%>
													orders
												</div>
											</div>
										</div>
									</td>
									<td class="py-4"><%=rsTopServices.getString("category_name")%></td>
									<td class="py-4">$<%=String.format("%.2f", rsTopServices.getDouble("price"))%></td>
								</tr>
								<%
								}
								%>
							</tbody>
						</table>
					</div>
				</div>

				<!-- table container -->
				<div class="flex gap-6">
					<!-- recent booking -->
					<div class="w-1/2 bg-white rounded-lg shadow-sm p-6">
						<div class="mb-4">
							<h2 class="text-xl font-bold">Most Recent Bookings Completed</h2>
						</div>
						<div class="overflow-x-auto">
							<table class="w-full">
								<thead>
									<tr class="text-left text-gray-500 text-sm border-b">
										<th class="pb-4">SERVICE</th>
										<th class="pb-4">PRICE</th>
										<th class="pb-4">DATE COMPLETED</th>
									</tr>
								</thead>
								<tbody>
									<%
									while (rsRecentBookings.next()) {
									%>
									<tr class="border-b">
										<td class="py-4">
											<div class="flex items-center gap-3">
												<div
													class="w-12 h-12 bg-gray-200 rounded-lg overflow-hidden">
													<img src="/JADProject/assets/services/default.jpg"
														alt="Service Image" class="w-full h-full object-cover">
												</div>
												<div>
													<div class="font-medium"><%=rsRecentBookings.getString("service_name")%></div>
													<div class="text-sm text-gray-500">
														<%=rsRecentBookings.getString("first_name") + " " + rsRecentBookings.getString("last_name")%>
													</div>
												</div>
											</div>
										</td>
										<td class="py-4">$<%=String.format("%.2f", rsRecentBookings.getDouble("total_price"))%></td>
										<td class="py-4 text-gray-500"><%=rsRecentBookings.getTimestamp("created_at").toString()%>
										</td>
									</tr>
									<%
									}
									%>
								</tbody>
							</table>
						</div>
					</div>

					<!-- high value booking -->
					<div class="w-1/2 bg-white rounded-lg shadow-sm p-6">
						<div class="mb-4">
							<h2 class="text-xl font-bold">High-Value Bookings (>$100)</h2>
						</div>
						<div class="overflow-x-auto">
							<table class="w-full">
								<thead>
									<tr class="text-left text-gray-500 text-sm border-b">
										<th class="pb-4">NAME</th>
										<th class="pb-4">PRICE</th>
										<th class="pb-4">DATE COMPLETED</th>
									</tr>
								</thead>
								<tbody>
									<%
									while (rsHighValue.next()) {
									%>
									<tr class="border-b">
										<td class="py-4">
											<div class="flex items-center gap-3">
												<div
													class="w-10 h-10 bg-gray-200 rounded-full overflow-hidden">
													<img src="/JADProject/assets/users/default-avatar.jpg"
														alt="User Avatar" class="w-full h-full object-cover">
												</div>
												<div class="font-medium">
													<%=rsHighValue.getString("first_name") + " " + rsHighValue.getString("last_name")%>
												</div>
											</div>
										</td>
										<td class="py-4">$<%=String.format("%.2f", rsHighValue.getDouble("total_price"))%></td>
										<td class="py-4 text-gray-500"><%=rsHighValue.getTimestamp("created_at").toString()%>
										</td>
									</tr>
									<%
									}
									%>
								</tbody>
							</table>
						</div>
					</div>
				</div>
			</div>

			<%
			} catch (Exception e) {
			System.err.println("Error: " + e.getMessage());
			} finally {
			try {
				// close conn for metric
				if (rsBookings != null)
					rsBookings.close();
				if (rsReviews != null)
					rsReviews.close();
				if (rsServices != null)
					rsServices.close();
				if (rsUsers != null)
					rsUsers.close();

				// close conn for tables
				if (rsTopServices != null)
					rsTopServices.close();
				if (rsRecentBookings != null)
					rsRecentBookings.close();
				if (rsHighValue != null)
					rsHighValue.close();

				// close conn for metrics
				if (psBookings != null)
					psBookings.close();
				if (psReviews != null)
					psReviews.close();
				if (psServices != null)
					psServices.close();
				if (psUsers != null)
					psUsers.close();

				// close preparedStatement for tables
				if (psTopServices != null)
					psTopServices.close();
				if (psRecentBookings != null)
					psRecentBookings.close();
				if (psHighValue != null)
					psHighValue.close();

				// close conn
				if (conn != null)
					conn.close();
			} catch (SQLException e) {
				System.err.println("Error closing resources: " + e.getMessage());
			}
			}
			%>
		</div>
	</div>
</body>
</html>