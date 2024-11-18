<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
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
            flex-wrap: wrap; /* Allows items to wrap to the next row if they don't fit */
            gap: 1em; /* Space between items */
        }

        /* Individual result item styling */
        .result-item {
            border: 1px solid red;
            padding: 1em;
            width: calc(50% - 1em); /* Adjust width as needed; -1em accounts for the gap */
            box-sizing: border-box;
        }

        /* Align pagination links horizontally */
        .pagination a, .pagination span {
            margin-right: 0.5em;
        }
    </style>
</head>
<body>

    <!-- Search form -->
    <form class="search-form" action="servicetest.jsp" method="GET">
        <input type="text" name="query" placeholder="Search..." 
               value="<%= request.getParameter("query") != null ? request.getParameter("query") : "" %>">
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
        String connURL = "jdbc:mysql://localhost:3306/jadca1?user=root&password=root123&serverTimezone=UTC";

        // Establish connection to URL
        conn = DriverManager.getConnection(connURL);

        // Prepare SQL query based on whether search query is provided
        String sqlStr;
        if (searchquery == null || searchquery.trim().isEmpty()) {
            // If no search query is provided, fetch all users with pagination
            sqlStr = "SELECT * FROM service_category LIMIT ? OFFSET ?";
            pstmt = conn.prepareStatement(sqlStr);
            pstmt.setInt(1, recordsPerPage); // LIMIT 2 records per page
            pstmt.setInt(2, offset); // OFFSET for pagination
        } else {
            // If there's a search query, filter by username with pagination
            sqlStr = "SELECT * FROM service_category WHERE category_name LIKE ? LIMIT ? OFFSET ?";
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
        } else {
%>
            <!-- Flex container for results -->
            <div class="results-container">
<%
            // Process Results
            while (rs.next()) {
                int id = rs.getInt("category_id");
                String category = rs.getString("category_name");
                String description = rs.getString("description");
%>
                <div class="result-item">
                    <div>ID: <%= id %></div>
                    <div>Name: <%= category %></div>
                    <div>Password: <%= description %></div>
                                    <input type="button" 
                       onclick="location.href='servicepagetest.jsp?categoryid=<%= id %>';" 
                       value="View more" />
                </div>
<%
            }
%>
            </div>
<%
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
<div class="pagination">
    <% if (currentPage > 1) { %>
        <a href="servicetest.jsp?query=<%= request.getParameter("query") != null ? request.getParameter("query") : "" %>&page=<%= currentPage - 1 %>">Previous</a>
    <% } %>

    <span>Page <%= currentPage %></span>

    <a href="servicetest.jsp?query=<%= request.getParameter("query") != null ? request.getParameter("query") : "" %>&page=<%= currentPage + 1 %>">Next</a>
</div>

</body>
</html>
