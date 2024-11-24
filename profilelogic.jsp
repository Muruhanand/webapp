<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, java.net.URLEncoder"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Service Details</title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
</head>
<body>
    <%@ include file="navbar.jsp"%>
<%
Connection conn = null;
PreparedStatement pstmt = null;
ResultSet rs = null;

try {
    // Get session attributes
    String customerId = (String) session.getAttribute("userid");
    String userEmail = (String) session.getAttribute("userEmail");

    // Debug print for session values
    System.out.println("Session values - CustomerID: " + customerId + ", Email: " + userEmail);

    if (customerId == null ) {
        response.sendRedirect("newlogin.jsp");
        return;
    }

    int userid1 = Integer.parseInt(customerId);

    // Database connection
    Class.forName("com.mysql.cj.jdbc.Driver");
    String connURL = "jdbc:mysql://localhost:3306/jadca1?user=root&password=BlaBla968@gmail.com!&serverTimezone=UTC";
    conn = DriverManager.getConnection(connURL);

    // Query to get user details
    String sqlStr = "SELECT first_name, last_name, email, phone_number, address FROM user WHERE customer_id = ?";
    pstmt = conn.prepareStatement(sqlStr);
    pstmt.setInt(1, userid1);

    // Debug print for SQL execution
    System.out.println("Executing SQL to fetch user details for customer_id: " + customerId);

    rs = pstmt.executeQuery();

    if (rs.next()) {
        String firstName = rs.getString("first_name");
        String lastName = rs.getString("last_name");
        String email = rs.getString("email");
        String phoneNum = rs.getString("phone_number"); // Use String for phone number
        String address = rs.getString("address");

        // Debug print for fetched user data
        System.out.println("Retrieved user data - Name: " + firstName + " " + lastName);

%>
<div class="container mt-4">
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
            <form action="updateService.jsp" method="post" class="mt-3" onsubmit="return validateProfileForm();">
                <div class="form-group">
                    <label for="firstName">First Name:</label>
                    <input type="text" class="form-control" id="first_name" name="first_name" value="<%= firstName %>" required>
                </div>
                <div class="form-group">
                    <label for="lastName">Last Name:</label>
                    <input type="text" class="form-control" id="last_name" name="last_name" value="<%= lastName %>" required>
                </div>
                <div class="form-group">
                    <label for="email">Email:</label>
                    <input type="email" class="form-control" id="email" name="email" value="<%= email %>" required>
                </div>
                <div class="form-group">
                    <label for="phoneNum">Phone Number:</label>
                    <input type="text" class="form-control" id="phone_number" name="phone_number" value="<%= phoneNum %>" required>
                </div>
                <div class="form-group">
                    <label for="address">Address:</label>
                    <input type="text" class="form-control" id="address" name="address" value="<%= address %>" required>
                </div>
                <button type="submit" class="btn btn-primary">Update Service</button>
            </form>

            <script>
                function validateProfileForm() {
                    const firstName = document.getElementById('first_name').value.trim();
                    const lastName = document.getElementById('last_name').value.trim();
                    const email = document.getElementById('email').value.trim();
                    const phoneNumber = document.getElementById('phone_number').value.trim();
                    const address = document.getElementById('address').value.trim();

                    if (!firstName || !lastName || !email || !phoneNumber || !address) {
                        alert("All fields are required and cannot contain only spaces.");
                        return false;
                    }

                    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
                    if (!emailRegex.test(email)) {
                        alert("Please enter a valid email address.");
                        return false;
                    }

                    const phoneRegex = /^[0-9]*$/;
                    if (!phoneRegex.test(phoneNumber)) {
                        alert("Phone number must be numeric.");
                        return false;
                    }

                    return true;
                }
            </script>
        </div>
        <div class="tab-pane fade" id="booking-history" role="tabpanel" aria-labelledby="booking-history-tab">
            <h3 class="mt-3">Booking History</h3>
<%
        // Pagination logic
        int currentPage = 1;
        int recordsPerPage = 4;
        if (request.getParameter("page") != null) {
            currentPage = Integer.parseInt(request.getParameter("page"));
        }
        int offset = (currentPage - 1) * recordsPerPage;

        // Query to get total number of bookings
        String sqlCount = "SELECT COUNT(*) FROM bookings WHERE customer_id = ?";
        int totalRecords = 0;
        try (PreparedStatement pstmtCount = conn.prepareStatement(sqlCount)) {
            pstmtCount.setInt(1, userid1);
            try (ResultSet rsCount = pstmtCount.executeQuery()) {
                if (rsCount.next()) {
                    totalRecords = rsCount.getInt(1);
                }
            }
        }

        // Query to get booking history with pagination
        String sqlBookings = "SELECT s.service_id, s.service_name, b.booking_date, b.status FROM bookings b JOIN service s ON b.service_id = s.service_id WHERE b.customer_id = ? LIMIT ? OFFSET ?";
        try (PreparedStatement pstmtBookings = conn.prepareStatement(sqlBookings)) {
            pstmtBookings.setInt(1, userid1);
            pstmtBookings.setInt(2, recordsPerPage);
            pstmtBookings.setInt(3, offset);
            try (ResultSet rsBookings = pstmtBookings.executeQuery()) {
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
<%
            }
        }

        // Pagination controls
        int totalPages = (int) Math.ceil((double) totalRecords / recordsPerPage);
%>
            <nav aria-label="Page navigation">
                <ul class="pagination justify-content-center">
                    <li class="page-item <%= (currentPage == 1) ? "disabled" : "" %>">
                        <a class="page-link" href="profilelogic.jsp?page=<%= currentPage - 1 %>" aria-label="Previous">
                            <span aria-hidden="true">&laquo;</span>
                        </a>
                    </li>
<%
        for (int i = 1; i <= totalPages; i++) {
%>
                    <li class="page-item <%= (i == currentPage) ? "active" : "" %>">
                        <a class="page-link" href="profilelogic.jsp?page=<%= i %>"><%= i %></a>
                    </li>
<%
        }
%>
                    <li class="page-item <%= (currentPage == totalPages) ? "disabled" : "" %>">
                        <a class="page-link" href="profilelogic.jsp?page=<%= currentPage + 1 %>" aria-label="Next">
                            <span aria-hidden="true">&raquo;</span>
                        </a>
                    </li>
                </ul>
            </nav>
<%
    }
%>
        </div>
    </div>
</div>
<%
    
} catch (Exception e) {
    e.printStackTrace();
    out.println("<p>An error occurred while retrieving your details. Please try again later.</p>");
} finally {
    if (rs != null) try { rs.close(); } catch (SQLException ignore) {}
    if (pstmt != null) try { pstmt.close(); } catch (SQLException ignore) {}
    if (conn != null) try { conn.close(); } catch (SQLException ignore) {}
}
%>
<script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.4.4/dist/umd/popper.min.js"></script>
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
    <%@ include file="footer.jsp"%>
</body>
</html>