<%@ page import="java.sql.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Delete Service</title>
</head>
<body>
<%
int serviceId = Integer.parseInt(request.getParameter("serviceId"));

Connection conn = null;
PreparedStatement checkStmt = null;
PreparedStatement deleteStmt = null;
ResultSet rs = null;

try {
    // Load the JDBC driver
    Class.forName("com.mysql.cj.jdbc.Driver");

    // Connect to the database
    String connURL = "jdbc:mysql://localhost:3306/JADCA1?user=root&password=BlaBla968@gmail.com!&serverTimezone=UTC";
    conn = DriverManager.getConnection(connURL);
    
    // check if got bookings for this service
    String checkSql = "SELECT COUNT(*) as count FROM bookings WHERE service_id = ? AND status != 'canceled'";
    checkStmt = conn.prepareStatement(checkSql);
    checkStmt.setInt(1, serviceId);
    rs = checkStmt.executeQuery();
    
    if (rs.next() && rs.getInt("count") > 0) {
        // check booking
        response.sendRedirect("/JADProject/admin/serviceList.jsp?status=error&message=Cannot delete service: It has active bookings");
        return;
    }

    // only proceed if got no bookings lor
    // for now i think i just implement this because the other members decided not to cascade it altho i would have because of data integrity
    String deleteSql = "DELETE FROM service WHERE service_id=?";
    deleteStmt = conn.prepareStatement(deleteSql);
    deleteStmt.setInt(1, serviceId);

    int rows = deleteStmt.executeUpdate();

    if (rows > 0) {
        response.sendRedirect("/JADProject/admin/servicesList.jsp?status=success&message=Service deleted successfully");
    } else {
        response.sendRedirect("/JADProject/admin/servicesList.jsp?status=error&message=Error deleting service");
    }
} catch (Exception e) {
    e.printStackTrace();
    response.sendRedirect("/JADProject/admin/servicesList.jsp?status=error&message=" + e.getMessage());
} finally {
    // Close resources
    if (rs != null) rs.close();
    if (checkStmt != null) checkStmt.close();
    if (deleteStmt != null) deleteStmt.close();
    if (conn != null) conn.close();
}
%>
</body>
</html>