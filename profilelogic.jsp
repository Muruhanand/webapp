<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Service Details</title>
</head>
<body>
<%
Connection conn = null;
PreparedStatement pstmt = null;
ResultSet rs = null;

try {
    // Get the customerid from session
    String customerId = (String) session.getAttribute("userid");
    String userEmail = (String) session.getAttribute("userEmail");
    int userid = Integer.parseInt(customerId);
    
    // Debug print
    System.out.println("Session values - CustomerID: " + customerId + ", Email: " + userEmail);

    if (customerId == null) {
        response.sendRedirect("login.jsp");
    } else {
        Class.forName("com.mysql.cj.jdbc.Driver");
        String connURL = "jdbc:mysql://localhost:3306/jadca1?user=root&password=root123&serverTimezone=UTC";
        conn = DriverManager.getConnection(connURL);
        
        // Query using customer_id
        String sqlStr = "SELECT first_name, last_name, email, phone_number, address FROM user WHERE customer_id = ?";
        pstmt = conn.prepareStatement(sqlStr);
        pstmt.setInt(1, userid);
        
        // Debug print
        System.out.println("Executing SQL with customer_id: " + customerId);
        
        rs = pstmt.executeQuery();

        if (rs.next()) {
            String firstName = rs.getString("first_name");
            String lastName = rs.getString("last_name");
            String email = rs.getString("email");
            int phoneNum = rs.getInt("phone_number");
            String address = rs.getString("address");

            // Debug print
            System.out.println("Retrieved user data - Name: " + firstName + " " + lastName);

%>
            <ul class="nav nav-tabs" id="myTab" role="tablist">
                <li class="nav-item">
                    <a class="nav-link active" id="service-details-tab" data-toggle="tab" href="#service-details" role="tab" aria-controls="service-details" aria-selected="true">Service Details</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" id="booking-history-tab" data-toggle="tab" href="#booking-history" role="tab" aria-controls="booking-history" aria-selected="false">Booking History</a>
                </li>
            </ul>
            <div class="tab-content" id="myTabContent">
                <div class="tab-pane fade show active" id="service-details" role="tabpanel" aria-labelledby="service-details-tab">
                    <form action="updateService.jsp" method="post" class="mt-3">
                        <div class="form-group">
                            <label for="firstName">First Name:</label>
                            <input type="text" class="form-control" id="first_name" name="first_name" value="<%= firstName %>">
                        </div>
                        <div class="form-group">
                            <label for="lastName">Last Name:</label>
                            <input type="text" class="form-control" id="last_name" name="last_name" value="<%= lastName %>">
                        </div>
                        <div class="form-group">
                            <label for="email">Email:</label>
                            <input type="email" class="form-control" id="email" name="email" value="<%= email %>">
                        </div>
                        <div class="form-group">
                            <label for="phoneNum">Phone Number:</label>
                            <input type="text" class="form-control" id="phone_number" name="phone_number" value="<%= phoneNum %>">
                        </div>
                        <div class="form-group">
                            <label for="address">Address:</label>
                            <input type="text" class="form-control" id="address" name="address" value="<%= address %>">
                        </div>
                        <button type="submit" class="btn btn-primary">Update Service</button>
                    </form>
                </div>
                <div class="tab-pane fade" id="booking-history" role="tabpanel" aria-labelledby="booking-history-tab">
                    <h3 class="mt-3">Booking History</h3>
<%
    // Query to get booking information
    String sqlBookings = "SELECT s.service_id, s.service_name, b.booking_date, b.status FROM bookings b JOIN service s ON b.service_id = s.service_id WHERE b.customer_id = ?";
    pstmtBookings = conn.prepareStatement(sqlBookings);
    pstmtBookings.setString(1, userid);
    rsBookings = pstmtBookings.executeQuery();
%>
<table class="table table-borderless">
    <thead>
        <tr>
            <th>Service Name</th>
            <th>Booking Date</th>
            <th>Status</th>
            <th>Review</th>
        </tr>
    </thead>
    <tbody>
<%
    while (rsBookings.next()) {
    	int serviceid = rsBookings.getInt("service_id");
        String serviceName = rsBookings.getString("service_name");
        String bookingDate = rsBookings.getString("booking_date");
        String status = rsBookings.getString("status");
%>
        <tr>
            <td><%= serviceName %></td>
            <td><%= bookingDate %></td>
            <td><%= status %></td>
            <td>
                <a href="feedback.jsp?serviceId=<%= serviceid %>&serviceName=<%= serviceName %>" class="btn btn-primary">Review</a>
            </td>
        </tr>
<%
    }
%>
    </tbody>
</table>
                </div>
            </div>
<%

</body>
</html>