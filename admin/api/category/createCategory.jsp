<%@ page import="java.sql.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Create New Category</title>
</head>
<body>
<%
String categoryName = request.getParameter("category_name");
String description = request.getParameter("description");

Connection conn = null;
PreparedStatement pstmt = null;

try {
    // Load the JDBC driver
    Class.forName("com.mysql.cj.jdbc.Driver");
    
    // Connect to the database
    String connURL = "jdbc:mysql://localhost:3306/JADCA1?user=root&password=BlaBla968@gmail.com!&serverTimezone=UTC";
    conn = DriverManager.getConnection(connURL);
    
    String checkSql = "SELECT COUNT(*) FROM service_category WHERE category_name = ?";
    pstmt = conn.prepareStatement(checkSql);
    pstmt.setString(1, categoryName);
    ResultSet rs = pstmt.executeQuery();
    rs.next();
    int count = rs.getInt(1);
    
    if (count > 0) {
        response.sendRedirect("/JADProject/admin/categoriesList.jsp?status=error&message=Category name already exists");
        return;
    }
    
    String sql = "INSERT INTO service_category (category_name, description) VALUES (?, ?)";
    
    pstmt = conn.prepareStatement(sql);
    
    // set param
    pstmt.setString(1, categoryName);
    pstmt.setString(2, description);
    
    int rows = pstmt.executeUpdate();
    
    if (rows > 0) {
        response.sendRedirect("/JADProject/admin/categoriesList.jsp?status=success&message=Category created successfully");
    } else {
        response.sendRedirect("/JADProject/admin/categoriesList.jsp?status=error&message=Error creating category");
    }
} catch (Exception e) {
    e.printStackTrace();
    response.sendRedirect("/JADProject/admin/categoriesList.jsp?status=error&message=" + e.getMessage());
} finally {
    // Close resources
    if (pstmt != null) pstmt.close();
    if (conn != null) conn.close();
}
%>
</body>
</html>