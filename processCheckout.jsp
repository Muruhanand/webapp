<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" import="java.sql.*, java.util.*"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Checkout Process</title>
</head>
<body>
<%
    Connection conn = null;
    PreparedStatement pstmt = null;
    String[] selectedItems = request.getParameterValues("selectedItems");

    if (selectedItems == null || selectedItems.length == 0) {
        out.println("<script>alert('No items selected for checkout.'); window.location.href = 'cart.jsp';</script>");
        return;
    }

    try {
        // Load database driver and establish connection
        Class.forName("com.mysql.cj.jdbc.Driver");
        String connURL = "jdbc:mysql://localhost:3306/jadca1?user=root&password=root123&serverTimezone=UTC";
        conn = DriverManager.getConnection(connURL);

        // Update the status of the selected bookings to 'confirmed'
        String sqlStr = "UPDATE bookings SET status = 'confirmed' WHERE booking_id = ?";
        pstmt = conn.prepareStatement(sqlStr);

        for (String bookingId : selectedItems) {
            pstmt.setString(1, bookingId);
            pstmt.executeUpdate();
        }

        out.println("<script>alert('Checkout successful.'); window.location.href = 'cart.jsp';</script>");
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
</body>
</html>