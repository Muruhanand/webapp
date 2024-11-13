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
            flex-wrap: wrap;
            gap: 1em;
        }

        /* Individual result item styling */
        .result-item {
            border: 1px solid red;
            padding: 1em;
            width: calc(50% - 1em);
            box-sizing: border-box;
        }

        /* Align pagination links horizontally */
        .pagination a, .pagination span {
            margin-right: 0.5em;
        }
    </style>
</head>
<body>
<%String categoryid = request.getParameter("categoryid"); %>
    <!-- Search form -->
    <form class="search-form" action="servicetest.jsp" method="GET">
        <input type="text" name="query" placeholder="Search..." 
               value="<%= request.getParameter("query") != null ? request.getParameter("query") : "" %>">
        <button type="submit">Search</button>
    </form>
	
<%
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

    int recordsPerPage = 2;
    int offset = (currentPage - 1) * recordsPerPage;
    int totalRecords = 0;
    int totalPages = 0;
    boolean hasResults = false;

    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        String connURL = "jdbc:mysql://localhost:3306/jadca1?user=root&password=root123&serverTimezone=UTC";
        conn = DriverManager.getConnection(connURL);

        // First, get the total count of records
        String countQuery;
        if (searchquery == null || searchquery.trim().isEmpty()) {
            countQuery = "SELECT COUNT(*) FROM service WHERE category_id = ?";
            pstmt = conn.prepareStatement(countQuery);
            pstmt.setString(1, categoryid);
        } else {
            countQuery = "SELECT COUNT(*) FROM service WHERE category_id = ?, service_name LIKE=?";
            pstmt = conn.prepareStatement(countQuery);
            pstmt.setString(1, categoryid);  // Searching by category_name
            pstmt.setString(2,  searchquery + "%");  // Searching by service_name
        }
        ResultSet countRs = pstmt.executeQuery();
        if (countRs.next()) {
            totalRecords = countRs.getInt(1);
            totalPages = (int) Math.ceil((double) totalRecords / recordsPerPage);
        }
        countRs.close();
        pstmt.close();

        // Now, fetch the results with pagination
        String sqlStr;
        if (searchquery == null || searchquery.trim().isEmpty()) {
            sqlStr = "SELECT s.service_name,s.description,sc.category_name FROM service s JOIN service_category sc ON s.category_id = sc.category_id WHERE s.category_id = ? LIMIT ? OFFSET ?";
            pstmt = conn.prepareStatement(sqlStr);
            pstmt.setString(1, categoryid);
            pstmt.setInt(2, recordsPerPage);
            pstmt.setInt(3, offset);
        } else {
            sqlStr = "SELECT s.service_name,s.description,sc.category_name FROM service s JOIN service_category sc ON s.category_id = sc.category_id WHERE s.category_id = ? AND s.service_name LIKE =? LIMIT ? OFFSET ?";
            pstmt = conn.prepareStatement(sqlStr);
            pstmt.setString(1, categoryid);  // Searching by category_name
            pstmt.setString(2,  searchquery + "%");  // Searching by service_name
            pstmt.setInt(3, recordsPerPage);  // Set the limit value
            pstmt.setInt(4, offset);  // Set the offset value
        }

        rs = pstmt.executeQuery();

        if (!rs.isBeforeFirst()) {
            out.println("<p>No results found.</p>");
        } else {
            hasResults = true;
%>
            <!-- Flex container for results -->
            <div class="results-container">
<%
            while (rs.next()) {
  
           String serviceName = rs.getString("service_name");
                String description = rs.getString("description");
                


%>  
                <div class="result-item">
                    <div>Name: <%= serviceName %></div>
                    <div>Description: <%= description %></div>
                    <input type="button" onclick="location.href='bookAppointment.jsp?serviceid=<%= serviceName %>';" value="Book Appointment" />
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
        if (rs != null) try { rs.close(); } catch (SQLException ignore) {}
        if (pstmt != null) try { pstmt.close(); } catch (SQLException ignore) {}
        if (conn != null) try { conn.close(); } catch (SQLException ignore) {}
    }
%>

<% if (hasResults && totalPages > 1) { %>
<div class="pagination">
    <% if (currentPage > 1) { %>
        <a href="servicepagetest.jsp?categoryid=<%= categoryid %>&query=<%= request.getParameter("query") != null ? request.getParameter("query") : "" %>&page=<%= currentPage - 1 %>">Previous</a>
    <% } %>

    <span>Page <%= currentPage %> of <%= totalPages %></span>

    <% if (currentPage < totalPages) { %>
        <a href="servicepagetest.jsp?categoryid=<%= categoryid %>&query=<%= request.getParameter("query") != null ? request.getParameter("query") : "" %>&page=<%= currentPage + 1 %>">Next</a>
    <% } %>
</div>
<% } %>

</body>
</html>
