<%@ page import="java.sql.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Delete Category</title>
</head>
<body>
<!-- userId and admin check -->
<%@ page import="utils.DBFunctions" %>
<%
	String userId = (String)session.getAttribute("userid");
	if (userId == null || !DBFunctions.checkAdminAuth(userId)) {
	    response.sendRedirect("/JADProject/newlogin.jsp");
	    return;
	}
%>
<%
try {
    int categoryId = Integer.parseInt(request.getParameter("deleteCategoryId"));
    
    Connection conn = null;
    PreparedStatement checkPstmt = null;
    PreparedStatement deletePstmt = null;
    ResultSet rs = null;
    
    try {
        // Load the JDBC driver
        Class.forName("com.mysql.cj.jdbc.Driver");
        
        // Connect to the database
        String connURL = "jdbc:mysql://localhost:3306/JADCA1?user=root&password=BlaBla968@gmail.com!&serverTimezone=UTC";
        conn = DriverManager.getConnection(connURL);
        
        // check if got services using category
        String checkSql = "SELECT COUNT(*) as count FROM service WHERE category_id = ?";
        checkPstmt = conn.prepareStatement(checkSql);
        checkPstmt.setInt(1, categoryId);
        rs = checkPstmt.executeQuery();
        
        if (rs.next() && rs.getInt("count") > 0) {
            // if got services using this category
            response.sendRedirect("/JADProject/admin/categoriesList.jsp?status=error&message=Cannot delete category: It is being used by existing services");
            return;
        }
        
        // proceed if none
        String deleteSql = "DELETE FROM service_category WHERE category_id = ?";
        deletePstmt = conn.prepareStatement(deleteSql);
        deletePstmt.setInt(1, categoryId);
        
        int rows = deletePstmt.executeUpdate();
        
        if (rows > 0) {
            response.sendRedirect("/JADProject/admin/categoriesList.jsp?status=success&message=Category deleted successfully");
        } else {
            response.sendRedirect("/JADProject/admin/categoriesList.jsp?status=error&message=Category not found");
        }
    } finally {
        // Close resources
        if (rs != null) rs.close();
        if (checkPstmt != null) checkPstmt.close();
        if (deletePstmt != null) deletePstmt.close();
        if (conn != null) conn.close();
    }
} catch (NumberFormatException e) {
    response.sendRedirect("/JADProject/admin/categoriesList.jsp?status=error&message=Invalid category ID");
} catch (Exception e) {
    e.printStackTrace();
    response.sendRedirect("/JADProject/admin/categoriesList.jsp?status=error&message=" + e.getMessage());
}
%>
</body>
</html>