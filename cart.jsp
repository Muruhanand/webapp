<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8" import="java.sql.*, java.util.*"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>Cart</title>
<link rel="stylesheet" href="css/styles.css">
<link rel="stylesheet" href="css/form.css">
<link
	href="https://fonts.googleapis.com/css2?family=Josefin+Sans&family=Libre+Baskerville:ital,wght@0,400;0,700;1,400&display=swap"
	rel="stylesheet">
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
	rel="stylesheet">
<script src="js/appointment.js"></script>
</head>
<body>
	<%@ include file="navbar.jsp"%>
	<h3 class="display-3 text-center">Cart</h3>

	<%
    Connection conn = null;
    PreparedStatement pstmt2 = null;
    PreparedStatement pstmt3 = null;
    ResultSet rs = null;
    String email = null;
    double totalPriceSum = 0;

    try {
        // Load database driver and establish connection
        Class.forName("com.mysql.cj.jdbc.Driver");
        String connURL = "jdbc:mysql://localhost:3306/jad_ca?user=root&password=root1234&serverTimezone=UTC";
        conn = DriverManager.getConnection(connURL);

        // Get customer ID from session
        String customerid = (String) session.getAttribute("userid");
        if (customerid == null) {
            out.println(
            "<script>alert('Please log in to access your cart.'); window.location.href = 'index.jsp';</script>");
        } else {
            // Retrieve email
            String sqlStr2 = "SELECT email FROM user WHERE customer_id = ?";
            pstmt2 = conn.prepareStatement(sqlStr2);
            pstmt2.setString(1, customerid);
            rs = pstmt2.executeQuery();
            if (rs.next()) {
        email = rs.getString("email");
    %>
	<div class="mb-3" style="display: none;">
		<label for="email" class="form-label">Email:</label> <input
			type="email" class="form-control" id="email" name="email"
			value="<%=email%>" readonly>
	</div>
	<%
    }

    // Retrieve pending bookings
    String sqlStr3 = "SELECT b.service_id, b.booking_date, b.total_price, s.service_name, b.booking_id "
            + "FROM bookings b " + "JOIN service s ON b.service_id = s.service_id "
            + "WHERE b.status = 'pending' AND b.customer_id = ?";
    pstmt3 = conn.prepareStatement(sqlStr3);
    pstmt3.setString(1, customerid);
    rs = pstmt3.executeQuery();
    %>
	<form id="checkoutForm" method="post">
		<table class="table table-borderless">
			<thead>
				<tr>
					<th scope="col">Select</th>
					<th scope="col">Service Name</th>
					<th scope="col">Total Price</th>
					<th scope="col">Booking Date</th>
					<th scope="col">Actions</th>
				</tr>
			</thead>
			<tbody>
				<%
                while (rs.next()) {
                    int bookingid = rs.getInt("booking_id");
                    String serviceName = rs.getString("service_name");
                    String bookingDate = rs.getString("booking_date");
                    double totalPrice = rs.getDouble("total_price");
                    String serviceId = rs.getString("service_id");
                    totalPriceSum += totalPrice;
                %>
				<tr style="border-bottom: 3px solid #24034C;">
					<td style="border-bottom: 3px solid #24034C;"><input
						type="checkbox" class="form-check-input" name="selectedItems"
						value="<%=serviceId%>" id="deleteItem<%=serviceId%>"></td>
					<td><%=serviceName%></td>
					<td>$<%=totalPrice%></td>
					<td><%=bookingDate%></td>
					<td>
						<button class="btn btn-primary btn-sm me-2" type="button"
							onclick="location.href='editBooking.jsp?bookingid=<%=bookingid%>'">Edit</button>
						<button class="btn btn-danger btn-sm" type="button"
							onclick="location.href='deleteBooking.jsp?bookingid=<%=bookingid%>'">Delete</button>
					</td>
				</tr>
				<%
                }
                %>
				<tr>
					<td colspan="4" class="text-end"><strong>Total Price:</strong></td>
					<td><strong>$<%=totalPriceSum%></strong></td>
				</tr>
				<tr>
					<td colspan="5" class="text-end">
						<button class="btn btn-success" type="button" onclick="checkOut()">Check
							Out</button>
					</td>
				</tr>
			</tbody>
		</table>
	</form>
	<%
    }
    } catch (Exception e) {
    out.println("<div class='alert alert-danger'>An error occurred. Please try again later.</div>");
    e.printStackTrace(); // Log detailed error to server logs
    } finally {
    // Close all resources
    try {
    if (rs != null)
        rs.close();
    } catch (SQLException e) {
    e.printStackTrace();
    }
    try {
    if (pstmt2 != null)
        pstmt2.close();
    } catch (SQLException e) {
    e.printStackTrace();
    }
    try {
    if (pstmt3 != null)
        pstmt3.close();
    } catch (SQLException e) {
    e.printStackTrace();
    }
    try {
    if (conn != null)
        conn.close();
    } catch (SQLException e) {
    e.printStackTrace();
    }
    }
    %>
</body>
</html>
