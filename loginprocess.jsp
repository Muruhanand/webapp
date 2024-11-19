<%@ page import="java.sql.*" %>
<%@ page import="java.security.MessageDigest" %>
<%@ page import="java.security.NoSuchAlgorithmException" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Login</title>
</head>
<body>
<%
    // Get email and password parameters from the request
    String email = request.getParameter("email");
    String password = request.getParameter("password");

    // Hash the entered password with SHA-256
    String hashedPassword = null;
    try {
        MessageDigest md = MessageDigest.getInstance("SHA-256");
        byte[] hashedBytes = md.digest(password.getBytes("UTF-8"));
        StringBuilder sb = new StringBuilder();
        for (byte b : hashedBytes) {
            sb.append(String.format("%02x", b));  // Convert each byte to a hex string
        }
        hashedPassword = sb.toString();
    } catch (NoSuchAlgorithmException | java.io.UnsupportedEncodingException e) {
        e.printStackTrace();
    }

    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;

    try {
        // Load the JDBC driver
        Class.forName("com.mysql.cj.jdbc.Driver");

        // Connect to the database
        String connURL = "jdbc:mysql://localhost:3306/jad_ca?user=root&password=root1234&serverTimezone=UTC";
        conn = DriverManager.getConnection(connURL);

        // SQL query to fetch the stored hashed password by email
        String sql = "SELECT password, customer_id FROM user WHERE email = ?";

        pstmt = conn.prepareStatement(sql);
        pstmt.setString(1, email);  // Set the email parameter for the query

        rs = pstmt.executeQuery();

        if (rs.next()) {
            String storedHashedPassword = rs.getString("password");
            String customerid = rs.getString("customer_id");

            // Compare the hashed password entered by the user with the stored hashed password
            if (hashedPassword.equals(storedHashedPassword)) {
            	session.setAttribute("userid",customerid);
            	response.sendRedirect("index.jsp");
            } else {
                response.sendRedirect("<p>Invalid password.</p>");
            }
        } else {
            out.println("<p>No user found with the provided email.</p>");
        }
    } catch (Exception e) {
        e.printStackTrace();
        out.println("<p>Error: " + e.getMessage() + "</p>");
    } finally {
        // Close resources
        if (rs != null) rs.close();
        if (pstmt != null) pstmt.close();
        if (conn != null) conn.close();
    }
%>
</body>
</html>