<%@ page import="java.sql.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Update Existing Category</title>
</head>
<body>
<%
int categoryId = Integer.parseInt(request.getParameter("category_id"));
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
    
    String checkSql = "SELECT COUNT(*) FROM service_category WHERE category_name = ? AND category_id != ?";
    pstmt = conn.prepareStatement(checkSql);
    pstmt.setString(1, categoryName);
    pstmt.setInt(2, categoryId);
    ResultSet rs = pstmt.executeQuery();
    rs.next();
    int count = rs.getInt(1);
    
    if (count > 0) {
        response.sendRedirect("/JADProject/admin/categoriesList.jsp?status=error&message=Category name already exists");
        return;
    }
    
    String sql = "UPDATE service_category SET category_name=?, description=? WHERE category_id=?";
    
    pstmt = conn.prepareStatement(sql);
    
    // set param
    pstmt.setString(1, categoryName);
    pstmt.setString(2, description);
    pstmt.setInt(3, categoryId);
    
    int rows = pstmt.executeUpdate();
    
    if (rows > 0) {
        response.sendRedirect("/JADProject/admin/categoriesList.jsp?status=success&message=Category updated successfully");
    } else {
        response.sendRedirect("/JADProject/admin/categoriesList.jsp?status=error&message=Error updating category");
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