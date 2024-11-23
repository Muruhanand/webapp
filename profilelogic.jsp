<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="jadca1.User" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Service Details</title>
</head>
<body>
<%
Connection conn = null;
PreparedStatement pstmt = null;
ResultSet rs = null;

try {
    // Get the customerid from session
    String customerId = (String) session.getAttribute("userid");
    String userEmail = (String) session.getAttribute("userEmail");
    int userid = Integer.parseInt(customerId);
    
    // Debug print
    System.out.println("Session values - CustomerID: " + customerId + ", Email: " + userEmail);

    if (customerId == null) {
        response.sendRedirect("login.jsp");
    } else {
        Class.forName("com.mysql.cj.jdbc.Driver");
        String connURL = "jdbc:mysql://localhost:3306/jadca1?user=root&password=root123&serverTimezone=UTC";
        conn = DriverManager.getConnection(connURL);
        
        // Query using customer_id
        String sqlStr = "SELECT first_name, last_name, email, phone_number, address FROM user WHERE customer_id = ?";
        pstmt = conn.prepareStatement(sqlStr);
        pstmt.setInt(1, userid);
        
        // Debug print
        System.out.println("Executing SQL with customer_id: " + customerId);
        
        rs = pstmt.executeQuery();

        if (rs.next()) {
            String firstName = rs.getString("first_name");
            String lastName = rs.getString("last_name");
            String email = rs.getString("email");
            int phoneNum = rs.getInt("phone_number");
            String address = rs.getString("address");

            // Debug print
            System.out.println("Retrieved user data - Name: " + firstName + " " + lastName);

            User userobj = new User(firstName, lastName, email, phoneNum, address);
            session.setAttribute("user", userobj);
            
            // Debug print
            System.out.println("User object stored in session");
            
            response.sendRedirect("userprofile.jsp");
        } else {
            // Debug print
            System.out.println("No user found for customer_id: " + customerId);
            %>
            <div>
                <h3>Debug Information:</h3>
                <p>No user found in database.</p>
                <p>Customer ID: <%= customerId %></p>
                <p>Email: <%= userEmail %></p>
                
                <h4>Session Attributes:</h4>
                <%
                java.util.Enumeration<String> attributeNames = session.getAttributeNames();
                while(attributeNames.hasMoreElements()) {
                    String name = attributeNames.nextElement();
                    out.println(name + ": " + session.getAttribute(name) + "<br>");
                }
                %>
                
                <p><a href="login.jsp">Return to Login</a></p>
            </div>
            <%
        }
    }
} catch (Exception e) {
    System.err.println("Error: " + e);
    e.printStackTrace();
    %>
    <div>
        <h3>Error Details:</h3>
        <p>Error Message: <%= e.getMessage() %></p>
        <p><a href="login.jsp">Return to Login</a></p>
    </div>
    <%
} finally {
    if (rs != null) try { rs.close(); } catch (SQLException e) { e.printStackTrace(); }
    if (pstmt != null) try { pstmt.close(); } catch (SQLException e) { e.printStackTrace(); }
    if (conn != null) try { conn.close(); } catch (SQLException e) { e.printStackTrace(); }
}
%>
</body>
</html>