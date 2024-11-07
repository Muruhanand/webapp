<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Search Page</title>
</head>
<body>

    <!-- Search form -->
    <form action="search.jsp" method="GET">
        <input type="text" name="query" placeholder="Search..." 
               value="<%= request.getParameter("query") != null ? request.getParameter("query") : "" %>">
        <button type="submit">Search</button>
    </form>

<%
	Boolean useramt = true;
    String searchquery = request.getParameter("query");

    int currentPage = 1;
    String pageParam = request.getParameter("page");
    if (pageParam != null && !pageParam.isEmpty()) {
        try {
            currentPage = Integer.parseInt(pageParam);
        } catch (NumberFormatException e) {
            currentPage = 1;
        }
    }

    // Calculate the OFFSET based on the current page
    int recordsPerPage = 2;
    int offset = (currentPage - 1) * recordsPerPage;

    // Database connection and query execution
    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;

    try {
        // Load JDBC Driver
        Class.forName("com.mysql.cj.jdbc.Driver");

        // Define Connection URL
        String connURL = "jdbc:mysql://localhost:3306/jadpract?user=root&password=root123&serverTimezone=UTC";

        // Establish connection to URL
        conn = DriverManager.getConnection(connURL);

        // Prepare SQL query based on whether search query is provided
        String sqlStr;
        if (searchquery == null || searchquery.trim().isEmpty()) {
            // If no search query is provided, fetch all users with pagination
            sqlStr = "SELECT * FROM member LIMIT ? OFFSET ?";
            pstmt = conn.prepareStatement(sqlStr);
            pstmt.setInt(1, recordsPerPage); // LIMIT 2 records per page
            pstmt.setInt(2, offset); // OFFSET for pagination
        } else {
            // If there's a search query, filter by username with pagination
            sqlStr = "SELECT * FROM member WHERE name LIKE ? LIMIT ? OFFSET ?";
            pstmt = conn.prepareStatement(sqlStr);
            pstmt.setString(1, searchquery + "%"); // Match username starting with the search query
            pstmt.setInt(2, recordsPerPage); // LIMIT 2 records per page
            pstmt.setInt(3, offset); // OFFSET for pagination
        }

        // Execute SQL Command
        rs = pstmt.executeQuery();

        // If no users found, show message
        if (!rs.isBeforeFirst()) {
            out.println("<p>No users found.</p>");
             useramt = false;
        } else {
            // Process Results
            while (rs.next()) {
                int id = rs.getInt("id");
                String name = rs.getString("name");
                String password = rs.getString("password");
%>
                <div style="border:1px solid red; padding:1em; margin:1em 0;">
                    <div>ID: <%= id %></div>
                    <div>Name: <%= name %></div>
                    <div>Password: <%= password %></div>
                </div>
<%
            }
        }

    } catch (Exception e) {
        out.println("Error: " + e.getMessage());
    } finally {
        // Close resources to prevent resource leaks
        if (rs != null) try { rs.close(); } catch (SQLException ignore) {}
        if (pstmt != null) try { pstmt.close(); } catch (SQLException ignore) {}
        if (conn != null) try { conn.close(); } catch (SQLException ignore) {}
    }
%>

<!-- Pagination Controls - Only at the Bottom -->
<div>
    <% if (currentPage > 1) { %>
        <a href="search.jsp?query=<%= request.getParameter("query") != null ? request.getParameter("query") : "" %>&page=<%= currentPage - 1 %>">Previous</a>
    <% } %>

    <span>Page <%= currentPage %></span>

    
	<%if(useramt) {%>
	<a href="search.jsp?query=<%= request.getParameter("query") != null ? request.getParameter("query") : "" %>&page=<%= currentPage + 1 %>">Next</a>
	<%}; %>
</div>


</body>
</html>
