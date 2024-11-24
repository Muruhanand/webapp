<%@ page import="java.sql.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Update Existing Service</title>
</head>
<body>
<%

int serviceId = Integer.parseInt(request.getParameter("service_id"));

String serviceName = request.getParameter("service_name");
String description = request.getParameter("description");
double price = Double.parseDouble(request.getParameter("price"));
int categoryId = Integer.parseInt(request.getParameter("category_id"));

Connection conn = null;
PreparedStatement pstmt = null;

try {
    // Load the JDBC driver
    Class.forName("com.mysql.cj.jdbc.Driver");

    // Connect to the database
    String connURL = "jdbc:mysql://localhost:3306/JADCA1?user=root&password=BlaBla968@gmail.com!&serverTimezone=UTC";
    conn = DriverManager.getConnection(connURL);

    // SQL query to update service
    String sql = "UPDATE service SET service_name=?, description=?, price=?, category_id=? WHERE service_id=?";
    
    pstmt = conn.prepareStatement(sql);
    
    // Set parameters
    pstmt.setString(1, serviceName);
    pstmt.setString(2, description);
    pstmt.setDouble(3, price);
    pstmt.setInt(4, categoryId);
    pstmt.setInt(5, serviceId);

    int rows = pstmt.executeUpdate();

    if (rows > 0) {
        response.sendRedirect("/JADProject/admin/servicesList.jsp?status=success&message=Service updated successfully");
    } else {
        response.sendRedirect("/JADProject/admin/servicesList.jsp?status=error&message=Error updating service");
    }
} catch (Exception e) {
    e.printStackTrace();
    response.sendRedirect("/JADProject/admin/servicesList.jsp?status=error&message=" + e.getMessage());
} finally {
    // Close resources
    if (pstmt != null) pstmt.close();
    if (conn != null) conn.close();
}
%>
</body>
</html>