<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8" import="java.sql.*, java.util.*"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>Book an Appointment!</title>
<link rel="stylesheet" href="css/styles.css">
<link rel="stylesheet" href="css/form.css">
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
	rel="stylesheet">
</head>
<body>
	<%@ include file="navbar.jsp"%>
	<%@page import="java.sql.*"%>
	<form action="appointmentProcess.jsp">
		<h3>Send us your feedback!</h3>
		<%
		String serviceId = request.getParameter("serviceid");

		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Map<String, List<String[]>> servicesByCategory = new HashMap<>();

		try {
			Class.forName("com.mysql.cj.jdbc.Driver");
			String connURL = "jdbc:mysql://localhost:3306/jad_ca?user=root&password=root1234&serverTimezone=UTC";
			conn = DriverManager.getConnection(connURL);

			if (serviceId != null && !serviceId.isEmpty()) {
				String sqlStr = "SELECT sc.category_name, s.service_name FROM service s "
				+ "JOIN service_category sc ON s.category_id = sc.category_id WHERE s.service_id = ?";
				pstmt = conn.prepareStatement(sqlStr);
				pstmt.setString(1, serviceId);
				rs = pstmt.executeQuery();

				if (rs.next()) {
			String categoryName = rs.getString("category_name");
			String serviceName = rs.getString("service_name");
		%>
		<div class="mb-3">
			<label>Email Address:</label> <input type="email"
				class="form-control">
		</div>
		<div class="mb-3">
			<label>Cleaning Category:</label> <select class="form-select"
				disabled>
				<option><%=categoryName%></option>
			</select>
		</div>
		<div class="mb-3">
			<label>Service:</label> <select class="form-select" disabled>
				<option><%=serviceName%></option>
			</select>
		</div>
		<%
		}
		} else {
		// Query for all categories and services
		String sqlStrCategories = "SELECT category_id, category_name FROM service_category";
		pstmt = conn.prepareStatement(sqlStrCategories);
		rs = pstmt.executeQuery();

		while (rs.next()) {
		String categoryId = rs.getString("category_id");
		String categoryName = rs.getString("category_name");
		servicesByCategory.put(categoryId, new ArrayList<>());
		}

		String sqlStrServices = "SELECT category_id, service_id, service_name FROM service";
		pstmt = conn.prepareStatement(sqlStrServices);
		rs = pstmt.executeQuery();

		while (rs.next()) {
		String categoryId = rs.getString("category_id");
		String serviceIdFromDb = rs.getString("service_id");
		String serviceName = rs.getString("service_name");

		servicesByCategory.get(categoryId).add(new String[]{serviceIdFromDb, serviceName});
		}
		%>
		<div class="mb-3">
			<label>Email Address:</label> <input type="email"
				class="form-control">
		</div>
		<div class="mb-3">
			<label>Cleaning Category:</label> <select id="categoryOptions"
				class="form-select" onchange="populateServices()">
				<option value="" selected>Select a category</option>
				<%
				for (Map.Entry<String, List<String[]>> entry : servicesByCategory.entrySet()) {
					String categoryId = entry.getKey();
					String categoryName = entry.getValue().get(0)[1]; // Assuming the first entry has the category name
				%>
				<option value="<%=categoryId%>"><%=categoryName%></option>
				<%
				}
				%>
			</select>

		</div>
		<div class="mb-3">
			<label>Service:</label> <select id="serviceOptions"
				class="form-select"></select>
		</div>
		<script>
                    var servicesByCategory = {
                        <%for (Map.Entry<String, List<String[]>> entry : servicesByCategory.entrySet()) {
	String categoryId = entry.getKey();
	List<String[]> services = entry.getValue();%>
                            "<%=categoryId%>": [
                                <%for (String[] service : services) {%>
                                    ["<%=service[0]%>", "<%=service[1]%>"],
                                <%}%>
                            ],
                        <%}%>
                    };
        </script>
		<%
		}
		} catch (Exception e) {
		out.println("Error: " + e.getMessage());
		} finally {
		if (rs != null)
		try {
			rs.close();
		} catch (SQLException e) {
			e.printStackTrace();
		}
		if (pstmt != null)
		try {
			pstmt.close();
		} catch (SQLException e) {
			e.printStackTrace();
		}
		if (conn != null)
		try {
			conn.close();
		} catch (SQLException e) {
			e.printStackTrace();
		}
		}
		%>
		<div class="mb-3">
			<label for="dateSelector" class="form-label">Select Date</label> 
			<input type="date" class="form-control" id="dateSelector" name="selectedDate" required>
		</div>
		<div class="mb-3">
			<label for="timeSelectorStart" class="form-label">From:</label>
			<input type="time" class="form-control" id="timeSelectorStart" name="selectedTimeStart" min="09:00" max="18:00" required>
		</div>
		<div class="mb-3">
			<label for="timeSelectorEnd" class="form-label">To:</label>
			<input type="time" class="form-control" id="timeSelectorEnd" name="selectedTimeEnd" min="09:00" max="18:00" required>
		</div>
		<button type="submit" class="btn btn-primary mt-3">Submit</button>
	</form>
	<script src="/js/appointment.js"></script>
	<%@ include file="footer.jsp"%>
</body>
</html>
