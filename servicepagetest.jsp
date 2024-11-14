<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Service Details</title>
</head>
<body>
    <%@page import="java.sql.*" %>
    <% 
        String categoryid = request.getParameter("categoryid");
        
        // Define JDBC variables
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            // Step 1: Load JDBC Driver
            Class.forName("com.mysql.cj.jdbc.Driver");

            // Step 2: Define Connection URL
            String connURL = "jdbc:mysql://localhost:3306/jadca1?user=root&password=root123&serverTimezone=UTC";

            // Step 3: Establish connection to URL
            conn = DriverManager.getConnection(connURL);

            // Step 4: Create PreparedStatement object
            String sqlStr = "SELECT service_id, service_name, description FROM service WHERE category_id = ?";
            pstmt = conn.prepareStatement(sqlStr);
            pstmt.setString(1, categoryid);  // Assuming category is a string, adjust if it's an integer

            // Step 5: Execute SQL Command
            rs = pstmt.executeQuery();

            // Step 6: Process Result
            while (rs.next()) {
                int service_id = rs.getInt("service_id");
                String service_name = rs.getString("service_name");
                String description = rs.getString("description");
    %>
                <div style="border:1px solid red; padding:1em; margin:1em 0;">
                    <div>ID: <%=service_id %></div>
                    <div>Name: <%=service_name %></div>
                    <div>description: <%=description %></div>
                </div>
    <%
            }

        } catch (Exception e) {
            System.err.println("Error :" + e);
        } finally {
            // Step 7: Close resources
            if (rs != null) try { rs.close(); } catch (SQLException e) { e.printStackTrace(); }
            if (pstmt != null) try { pstmt.close(); } catch (SQLException e) { e.printStackTrace(); }
            if (conn != null) try { conn.close(); } catch (SQLException e) { e.printStackTrace(); }
        }
    %>
</body>
</html>
