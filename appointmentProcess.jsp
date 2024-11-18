<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Date"%>
<%@page import="java.sql.*"%>
<%@page import="java.text.ParseException"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Appointment Processing</title>
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
	rel="stylesheet">
</head>
<body>
	<%
	String userId = (String) session.getAttribute("userid");
	String email = request.getParameter("email");
	String selectedDate = request.getParameter("selectedDate");
	String selectedTimeStart = request.getParameter("selectedTimeStart");
	String selectedTimeEnd = request.getParameter("selectedTimeEnd");
	String categoryOption = request.getParameter("categoryOptions");
	String serviceOption = request.getParameter("serviceOptions");

	boolean isValid = true;

	// Validate email
	if (email == null || email.trim().isEmpty() || !email.matches("^[\\w.%+-]+@[\\w.-]+\\.[a-zA-Z]{2,}$")) {
		isValid = false;
		response.sendRedirect("bookAppointment.jsp?serviceid=" + serviceOption + "&error=Invalid email address.");
		return;
	}

	// Validate date
	if (selectedDate == null || selectedDate.trim().isEmpty()) {
		isValid = false;
		response.sendRedirect("bookAppointment.jsp?serviceid=" + serviceOption + "&error=Date is required.");
		return;
	}

	// Validate times
	if (selectedTimeStart == null || selectedTimeStart.trim().isEmpty() || selectedTimeEnd == null
			|| selectedTimeEnd.trim().isEmpty()) {
		isValid = false;
		response.sendRedirect(
		"bookAppointment.jsp?serviceid=" + serviceOption + "&error=Start and end times are required.");
		return;
	}

	if (isValid) {
		try {
			SimpleDateFormat sdf = new SimpleDateFormat("HH:mm");
			Date startTime = sdf.parse(selectedTimeStart);
			Date endTime = sdf.parse(selectedTimeEnd);

			long differenceInMilliSeconds = endTime.getTime() - startTime.getTime();
			long differenceInHours = differenceInMilliSeconds / (60 * 60 * 1000);

			if (differenceInHours < 1 || differenceInMilliSeconds % (60 * 60 * 1000) != 0) {
		isValid = false;
		response.sendRedirect(
				"bookAppointment.jsp?serviceid=" + serviceOption + "&error=Time difference must be whole hours.");
		return;
			}
		} catch (ParseException e) {
			isValid = false;
			response.sendRedirect("bookAppointment.jsp?serviceid=" + serviceOption + "&error=Invalid time format.");
			return;
		}
	}

	// Validate category and service options
	if (categoryOption == null || categoryOption.trim().isEmpty() || serviceOption == null
			|| serviceOption.trim().isEmpty()) {
		isValid = false;
		response.sendRedirect("bookAppointment.jsp?error=Category and service selections are required.");
		return;
	}

	Connection conn = null;
	PreparedStatement pstmt = null;
	ResultSet rs = null;

	try {
		Class.forName("com.mysql.cj.jdbc.Driver");
		String connURL = "jdbc:mysql://localhost:3306/jadca1?user=root&password=root123&serverTimezone=UTC";
		conn = DriverManager.getConnection(connURL);

		// Verify service exists and get details
		String sqlStr = "SELECT * FROM service WHERE service_id = ?";
		pstmt = conn.prepareStatement(sqlStr);
		pstmt.setString(1, serviceOption);
		rs = pstmt.executeQuery();

		if (rs.next()) {
			String serviceId = rs.getString("service_id");
			String categoryId = rs.getString("category_id");
			String price = rs.getString("price");

			// Insert appointment
			String sqlStrInsert = "INSERT INTO bookings (customer_id, service_id, email, booking_date, booking_start_time, booking_end_time, total_price) VALUES (?, ?, ?, ?, ?, ?, ?)";
			pstmt = conn.prepareStatement(sqlStrInsert);
			pstmt.setString(1, userId);
			pstmt.setString(2, serviceId);
			pstmt.setString(3, email);
			pstmt.setString(4, selectedDate);
			pstmt.setString(5, selectedTimeStart);
			pstmt.setString(6, selectedTimeEnd);
			pstmt.setString(7, price); 
			pstmt.executeUpdate();

			response.sendRedirect("bookAppointment.jsp?success=Appointment booked successfully.");
		} else {
			response.sendRedirect("bookAppointment.jsp?error=Service not found.");
		}
	} catch (Exception e) {
		response.sendRedirect(
		"bookAppointment.jsp?error=" + java.net.URLEncoder.encode("An error occurred: " + e.getMessage(), "UTF-8"));
	} finally {
		if (rs != null)
			try {
		rs.close();
			} catch (SQLException e) {
		e.printStackTrace();
			}
		if (pstmt != null)
			try {
		pstmt.close();
			} catch (SQLException e) {
		e.printStackTrace();
			}
		if (conn != null)
			try {
		conn.close();
			} catch (SQLException e) {
		e.printStackTrace();
			}
	}
	%>
</body>
</html>