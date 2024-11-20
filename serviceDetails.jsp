<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Service Details</title>
<meta name="viewport" content="width=device-width, initial-scale=1">
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com">
<link
	href="https://fonts.googleapis.com/css2?family=Josefin+Sans&family=Libre+Baskerville:ital,wght@0,400;0,700;1,400&display=swap"
	rel="stylesheet">
<link rel="stylesheet" href="css/styles.css">
<link rel="stylesheet" href="css/service.css">
</head>
<body>
	<%@ include file="navbar.jsp"%>
	<%@page import="java.sql.*"%>
	<div class="details-container">
		<h2>Service Details</h2>
		<%
		String categoryid = request.getParameter("categoryid");
		Connection conn1 = null;
		PreparedStatement pstmt1 = null;
		ResultSet rs1 = null;

		try {
			// Step 1: Load JDBC Driver
			Class.forName("com.mysql.cj.jdbc.Driver");

			// Step 2: Define Connection URL
			String connURL = "jdbc:mysql://localhost:3306/jad_ca?user=root&password=root1234&serverTimezone=UTC";

			// Step 3: Establish connection to URL
			conn1 = DriverManager.getConnection(connURL);

			// Step 4: Create PreparedStatement object
			String sqlStr = "SELECT service_id, service_name, description FROM service WHERE category_id = ?";
			pstmt = conn1.prepareStatement(sqlStr);
			pstmt.setString(1, categoryid); // Assuming category is a string, adjust if it's an integer

			// Step 5: Execute SQL Command
			rs1 = pstmt1.executeQuery();

			// Step 6: Process Result
			while (rs.next()) {
				int service_id = rs.getInt("service_id");
				String service_name = rs.getString("service_name");
				String description = rs.getString("description");
		%>
		<div class="service-details">
			<h3><%=service_name%></h3>
			<p><%=description%></p>
			<a href="bookAppointment.jsp?serviceid=<%=service_id%>">Book Now</a>
		</div>
		<%
		}

		} catch (Exception e) {
		System.err.println("Error :" + e);
		} finally {
		// Step 7: Close resources
		if (rs1 != null)
		try {
			rs1.close();
		} catch (SQLException e) {
			e.printStackTrace();
		}
		if (pstmt1 != null)
		try {
			pstmt1.close();
		} catch (SQLException e) {
			e.printStackTrace();
		}
		if (conn1 != null)
		try {
			conn1.close();
		} catch (SQLException e) {
			e.printStackTrace();
		}
		}
		%>
	</div>
	<%@ include file="footer.jsp"%>
</body>
</html>
