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
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com">
<link href="https://fonts.googleapis.com/css2?family=Josefin+Sans&family=Libre+Baskerville:ital,wght@0,400;0,700;1,400&display=swap" rel="stylesheet">

<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
	rel="stylesheet">
	<script src="js/appointment.js"></script>
</head>
<body>
	<%@ include file="navbar.jsp"%>
	<%@page import="java.sql.*"%>
	<h3 class="display-3 text-center">Cart</h3>
		<%
		String serviceId = request.getParameter("serviceid");

		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Map<String, List<String[]>> servicesByCategory = new HashMap<>();

		String email = null;
		PreparedStatement pstmt2 = null;

		try {
			Class.forName("com.mysql.cj.jdbc.Driver");
			String connURL = "jdbc:mysql://localhost:3306/jad_ca?user=root&password=root1234&serverTimezone=UTC";
			conn = DriverManager.getConnection(connURL);

			if(session.getAttribute("userid") != null) {
				String customerid = (String) session.getAttribute("userid");
				String sqlStr2 = "SELECT email FROM user WHERE customer_id = ?";
				pstmt2 = conn.prepareStatement(sqlStr2);
				pstmt2.setString(1, customerid);
				rs = pstmt2.executeQuery();
				if (rs.next()) {
					System.out.println(customerid);
					email = rs.getString("email");
					System.out.println(email);
					%>
						<div class="mb-3" style="display:none;">
							<label for="email" class="form-label">Email:</label>
							<input type="email" class="form-control" id="email" name="email" value="<%=email%>" required>
						</div>
					<%
				}
			}else{
				out.println("<script>alert('Please log in to access your cart.'); window.location.href = 'index.jsp';</script>");
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
		}%>
</body>
</html>
	