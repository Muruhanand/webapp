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
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
	rel="stylesheet">
<link rel="stylesheet" href="css/styles.css">
<link rel="stylesheet" href="css/service.css">
</head>
<body>
	<%@ include file="navbar.jsp"%>
	<%@page import="java.sql.*, java.net.URLEncoder"%>
	<h2 class="display-3 text-center">Service Details</h2>

	<%
		// Get category ID from request
		String categoryid = request.getParameter("categoryid");

		// Get current page from request, default to 1 if not provided
		int currentPage = 1;
		String pageParam = request.getParameter("page");
		if (pageParam != null && !pageParam.isEmpty()) {
			try {
				currentPage = Integer.parseInt(pageParam);
			} catch (NumberFormatException e) {
				currentPage = 1;
			}
		}

		int recordsPerPage = 4; // Number of records per page
		int offset = (currentPage - 1) * recordsPerPage;

		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		int totalRecords = 0;

		try {
			// Database connection
			Class.forName("com.mysql.cj.jdbc.Driver");
	    String connURL = "jdbc:mysql://localhost:3306/jadca1?user=root&password=BlaBla968@gmail.com!&serverTimezone=UTC";
			conn = DriverManager.getConnection(connURL);

			// Get total record count
			String countQuery = "SELECT COUNT(*) FROM service WHERE category_id = ?";
			pstmt = conn.prepareStatement(countQuery);
			pstmt.setString(1, categoryid);
			rs = pstmt.executeQuery();
			if (rs.next()) {
				totalRecords = rs.getInt(1);
			}
			rs.close();
			pstmt.close();

			// Retrieve paginated records
			String sqlStr = "SELECT service_id, service_name, description, icon_path FROM service WHERE category_id = ? LIMIT ? OFFSET ?";
			pstmt = conn.prepareStatement(sqlStr);
			pstmt.setString(1, categoryid);
			pstmt.setInt(2, recordsPerPage);
			pstmt.setInt(3, offset);
			rs = pstmt.executeQuery();

			// Render services
	%>
	<div class="details-container">
		<%
			while (rs.next()) {
				int service_id = rs.getInt("service_id");
				String service_name = rs.getString("service_name");
				String description = rs.getString("description");
				String iconPath = rs.getString("icon_path") != null ? rs.getString("icon_path") : "media/placeholder_service.png";
		%>
		<div class="service-details">
			<h3><%=service_name%></h3>
			<img src="<%=iconPath%>" alt="Service Image">
			<p><%=description%></p>
			<a href="bookAppointment.jsp?serviceid=<%=service_id%>">Book Now</a>
		</div>
		<%
			}
		%>
	</div>
	<%
		} catch (Exception e) {
			out.println("Error: " + e.getMessage());
		} finally {
			// Close resources
			if (rs != null) try { rs.close(); } catch (SQLException ignore) {}
			if (pstmt != null) try { pstmt.close(); } catch (SQLException ignore) {}
			if (conn != null) try { conn.close(); } catch (SQLException ignore) {}
		}
	%>

	<!-- Pagination Controls -->
	<div class="pagination">
		<%
		String encodedCategory = categoryid != null ? URLEncoder.encode(categoryid, "UTF-8") : "";

		// Previous Button
		if (currentPage > 1) {
		%>
		<a href="serviceDetails.jsp?categoryid=<%=encodedCategory%>&page=<%=currentPage - 1%>">Previous</a>
		<%
		}

		// Current Page Display
		out.println("<span>Page " + currentPage + "</span>");

		// Next Button
		if (totalRecords > recordsPerPage * currentPage) {
		%>
		<a href="serviceDetails.jsp?categoryid=<%=encodedCategory%>&page=<%=currentPage + 1%>">Next</a>
		<%
		}
		%>
	</div>

	<%@ include file="footer.jsp"%>
</body>
</html>
