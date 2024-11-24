<%@ page import="java.sql.*"%>
<%@ page import="java.security.MessageDigest"%>
<%@ page import="java.security.NoSuchAlgorithmException"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Create New Service</title>
</head>
<body>
<%
String serviceName = request.getParameter("service_name");
String description = request.getParameter("description");
Double price = Double.parseDouble(request.getParameter("price"));
Integer categoryId = Integer.parseInt(request.getParameter("category_id"));

Connection conn = null;
PreparedStatement pstmt = null;

try {
    Class.forName("com.mysql.cj.jdbc.Driver");
    String connURL = "jdbc:mysql://localhost:3306/JADCA1?user=root&password=BlaBla968@gmail.com!&serverTimezone=UTC";
    conn = DriverManager.getConnection(connURL);

    String sql = "INSERT INTO service (service_name, description, price, category_id) VALUES (?, ?, ?, ?)";
    pstmt = conn.prepareStatement(sql);

    pstmt.setString(1, serviceName);
    pstmt.setString(2, description);
    pstmt.setDouble(3, price);
    pstmt.setInt(4, categoryId);

    int rows = pstmt.executeUpdate();

    if (rows > 0) {
        response.sendRedirect("/JADProject/admin/servicesList.jsp?status=success&message=Service created successfully");
    } else {
        response.sendRedirect("/JADProject/admin/servicesList.jsp?status=error&message=Error creating service");
    }
} catch (Exception e) {
    e.printStackTrace();
    response.sendRedirect("/JADProject/admin/servicesList.jsp?status=error&message=" + e.getMessage());
} finally {
    if (pstmt != null) pstmt.close();
    if (conn != null) conn.close();
}
%>
</body>
</html>