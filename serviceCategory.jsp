<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, java.net.URLEncoder"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Search Page</title>
<style>
/* Styling for the search form and pagination */
.search-form, .pagination {
	margin-bottom: 1em;
}

/* Flex container for results */
.results-container {
	display: flex;
	flex-wrap: wrap;
	gap: 1em;
}

.result-item {
	border: 1px solid red;
	padding: 1em;
	width: calc(50% - 1em);
	box-sizing: border-box;
}

.pagination a, .pagination span {
	margin-right: 0.5em;
}
</style>
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com">
<link href="https://fonts.googleapis.com/css2?family=Josefin+Sans&family=Libre+Baskerville:ital,wght@0,400;0,700;1,400&display=swap" rel="stylesheet">
<link rel="stylesheet" href="css/styles.css">
<link rel="stylesheet" href="css/service.css">
</head>
<body>
	<%@ include file="navbar.jsp"%>

	<form class="search-form" action="serviceCategory.jsp" method="GET">
		<input type="text" name="query" placeholder="Search..."
			value="<%=request.getParameter("query") != null ? request.getParameter("query") : ""%>">
		<button type="submit">Search</button>
	</form>

	<%
	String searchquery = request.getParameter("query");

	// Get the current page from the request, default to 1 if not provided
	int currentPage = 1;
	String pageParam = request.getParameter("page");
	if (pageParam != null && !pageParam.isEmpty()) {
		try {
			currentPage = Integer.parseInt(pageParam);
		} catch (NumberFormatException e) {
			currentPage = 1;
		}
	}

	int recordsPerPage = 4;
	int offset = (currentPage - 1) * recordsPerPage;

	// Database connection and query execution
	Connection conn = null;
	PreparedStatement pstmt = null;
	ResultSet rs = null;
	int totalRecords = 0;
	try {
		Class.forName("com.mysql.cj.jdbc.Driver");

		String connURL = "jdbc:mysql://localhost:3306/jad_ca?user=root&password=root1234&serverTimezone=UTC";
		conn = DriverManager.getConnection(connURL);

		String countQuery = "SELECT COUNT(*) FROM service_category";
		pstmt = conn.prepareStatement(countQuery);
		rs = pstmt.executeQuery();

		
		if (rs.next()) {
			totalRecords = rs.getInt(1);
		}
		rs.close();
		pstmt.close();

		if (totalRecords == 0) {
			out.println("<p>No service categories found.</p>");
		} else {
			// Prepare SQL query based on whether search query is provided
			String sqlStr;
			if (searchquery == null || searchquery.trim().isEmpty()) {
				sqlStr = "SELECT * FROM service_category LIMIT ? OFFSET ?";
				pstmt = conn.prepareStatement(sqlStr);
				pstmt.setInt(1, recordsPerPage);
				pstmt.setInt(2, offset);
			} else {
				sqlStr = "SELECT * FROM service_category WHERE category_name LIKE ? LIMIT ? OFFSET ?";
				pstmt = conn.prepareStatement(sqlStr);
				pstmt.setString(1, searchquery + "%");
				pstmt.setInt(2, recordsPerPage);
				pstmt.setInt(3, offset);
			}

			rs = pstmt.executeQuery();

			// Check if there are any results
			if (!rs.isBeforeFirst()) {
				out.println("<p>No service categories found.</p>");
			} else {
	%>
	<!-- Flex container for results -->
	<div class="category-container">
		<%
			while (rs.next()) {
				int id = rs.getInt("category_id");
				String category = rs.getString("category_name");
				String description = rs.getString("description");
		%>
		<div class="category-details">
			<h3> <strong> <%=category%> </strong> </h3>

			<p> <%=description%> </p>
			<a href='serviceDetails.jsp?categoryid=<%=id%>'> See More </a>
		</div>
		<%
			}
		%>
	</div>
	<%
			}
		}

	} catch (Exception e) {
		out.println("Error: " + e.getMessage());
	} finally {
		if (rs != null)
			try {
				rs.close();
			} catch (SQLException ignore) {
			}
		if (pstmt != null)
			try {
				pstmt.close();
			} catch (SQLException ignore) {
			}
		if (conn != null)
			try {
				conn.close();
			} catch (SQLException ignore) {
			}
	}
	%>

	<!-- Pagination Controls -->
	<div class="pagination">
		<%
		String encodedQuery = searchquery != null ? URLEncoder.encode(searchquery, "UTF-8") : "";
		if (currentPage > 1) {
		%>
		<a href="serviceCategory.jsp?query=<%=encodedQuery%>&page=<%=currentPage - 1%>">Previous</a>
		<span>Page <%=currentPage%></span>
		<%
		}
		if (totalRecords > recordsPerPage * currentPage) {
		%>
		
		<a href="serviceCategory.jsp?query=<%=encodedQuery%>&page=<%=currentPage + 1%>">Next</a>
		<%
		}
		%>
	</div>
	<%@ include file="footer.jsp"%>
</body>
</html>