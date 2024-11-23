<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" import="java.sql.*, java.util.*"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Edit Booking</title>
<link rel="stylesheet" href="css/styles.css">
<link rel="stylesheet" href="css/form.css">
<link
    href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
    rel="stylesheet">
</head>
<body>
    <%@ include file="navbar.jsp"%>
    <h3 class="display-3 text-center">Edit Booking</h3>

    <%
    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;
    String bookingId = request.getParameter("bookingid");

    try {
        // Load database driver and establish connection
        Class.forName("com.mysql.cj.jdbc.Driver");
        String connURL = "jdbc:mysql://localhost:3306/jadca1?user=root&password=root123&serverTimezone=UTC";
        conn = DriverManager.getConnection(connURL);

        // Retrieve booking details
        String sqlStr = "SELECT s.service_name, b.booking_date, b.booking_start_time, b.booking_end_time FROM bookings b JOIN service s ON b.service_id = s.service_id WHERE b.booking_id = ?";
        pstmt = conn.prepareStatement(sqlStr);
        pstmt.setString(1, bookingId);
        rs = pstmt.executeQuery();

        if (rs.next()) {
            String serviceName = rs.getString("service_name");
            String bookingDate = rs.getString("booking_date");
            String startTime = rs.getString("booking_start_time");
            String endTime = rs.getString("booking_end_time");
    %>
    <form action="updateBooking.jsp" method="post">
        <input type="hidden" name="bookingid" value="<%= bookingId %>">
        <div class="mb-3">
            <label for="serviceName" class="form-label">Service Name:</label>
            <input type="text" class="form-control" id="serviceName" name="serviceName" value="<%= serviceName %>" readonly>
        </div>
        <div class="mb-3">
            <label for="bookingDate" class="form-label">Booking Date:</label>
            <input type="date" class="form-control" id="bookingDate" name="bookingDate" value="<%= bookingDate %>">
        </div>
        <div class="mb-3">
            <label for="startTime" class="form-label">Start Time:</label>
            <input type="time" class="form-control" id="startTime" name="startTime" value="<%= startTime %>">
        </div>
        <div class="mb-3">
            <label for="endTime" class="form-label">End Time:</label>
            <input type="time" class="form-control" id="endTime" name="endTime" value="<%= endTime %>">
        </div>
        <button type="submit" class="btn btn-primary">Update Booking</button>
    </form>
    <%
        } else {
            out.println("<div class='alert alert-danger'>Booking not found.</div>");
        }
    } catch (Exception e) {
        out.println("<div class='alert alert-danger'>An error occurred. Please try again later.</div>");
        e.printStackTrace(); // Log detailed error to server logs
    } finally {
        // Close all resources
        try {
            if (rs != null) rs.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
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