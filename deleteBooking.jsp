<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" import="java.sql.*, java.util.*"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Delete Booking</title>
<link rel="stylesheet" href="css/styles.css">
<link rel="stylesheet" href="css/form.css">
<link
    href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
    rel="stylesheet">
</head>
<body>
    <%@ include file="navbar.jsp"%>
    <h3 class="display-3 text-center">Delete Booking</h3>

    <%
    Connection conn = null;
    PreparedStatement pstmt = null;
    String bookingId = request.getParameter("bookingid");

    try {
        // Load database driver and establish connection
        Class.forName("com.mysql.cj.jdbc.Driver");
        String connURL = "jdbc:mysql://localhost:3306/jadca1?user=root&password=root123&serverTimezone=UTC";
        conn = DriverManager.getConnection(connURL);

        // Delete booking
        String sqlStr = "DELETE FROM bookings WHERE booking_id = ?";
        pstmt = conn.prepareStatement(sqlStr);
        pstmt.setString(1, bookingId);
        int rowsAffected = pstmt.executeUpdate();

        if (rowsAffected > 0) {
            out.println("<div class='alert alert-success'>Booking deleted successfully.</div>");
        } else {
            out.println("<div class='alert alert-danger'>Booking not found.</div>");
        }
    } catch (Exception e) {
        out.println("<div class='alert alert-danger'>An error occurred. Please try again later.</div>");
        e.printStackTrace(); // Log detailed error to server logs
    } finally {
        // Close all resources
        try {
            if (pstmt != null) pstmt.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        try {
            if (conn != null) conn.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
    %>
    <a href="cart.jsp" class="btn btn-primary">Back to Cart</a>
</body>
</html>