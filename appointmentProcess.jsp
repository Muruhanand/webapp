<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
    <%@ page import="java.text.SimpleDateFormat, java.util.Date, java.sql.*, java.text.ParseException, java.math.BigDecimal"%>
<%
    boolean isNumeric(String str) {
        return str != null && str.matches("\\d+");
    }

    String email = request.getParameter("email");
    String selectedDate = request.getParameter("selectedDate");
    String selectedTimeStart = request.getParameter("selectedTimeStart");
    String selectedTimeEnd = request.getParameter("selectedTimeEnd");
    String categoryOption = request.getParameter("categoryOptions");
    String serviceOption = request.getParameter("serviceOptions");

    boolean isValid = true;
    StringBuilder errorMessage = new StringBuilder();

    // Validate email
    if (email == null || email.trim().isEmpty() || !email.matches("^[\\w.%+-]+@[\\w.-]+\\.[a-zA-Z]{2,}$")) {
        isValid = false;
        errorMessage.append("Invalid email address. ");
    }

    // Validate selectedDate
    if (selectedDate == null || selectedDate.trim().isEmpty()) {
        isValid = false;
        errorMessage.append("Date is required. ");
    } else {
        try {
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
            sdf.setLenient(false); // Strict parsing
            Date date = sdf.parse(selectedDate);
        } catch (ParseException e) {
            isValid = false;
            errorMessage.append("Invalid date format (expected yyyy-MM-dd). ");
        }
    }

    // Validate selectedTimeStart and selectedTimeEnd
    if (selectedTimeStart == null || selectedTimeStart.trim().isEmpty()) {
        isValid = false;
        errorMessage.append("Starting time is required. ");
    } else if (!selectedTimeStart.matches("^(?:[01]\\d|2[0-3]):[0-5]\\d$")) {
        isValid = false;
        errorMessage.append("Invalid start time format (expected HH:mm). ");
    }

    if (selectedTimeEnd == null || selectedTimeEnd.trim().isEmpty()) {
        isValid = false;
        errorMessage.append("Ending time is required. ");
    } else if (!selectedTimeEnd.matches("^(?:[01]\\d|2[0-3]):[0-5]\\d$")) {
        isValid = false;
        errorMessage.append("Invalid end time format (expected HH:mm). ");
    } else if (isValid) {
        try {
            SimpleDateFormat sdf = new SimpleDateFormat("HH:mm");
            Date startTime = sdf.parse(selectedTimeStart);
            Date endTime = sdf.parse(selectedTimeEnd);

            long differenceInMilliSeconds = endTime.getTime() - startTime.getTime();
            if (differenceInMilliSeconds < 3600000 || differenceInMilliSeconds % 3600000 != 0) {
                isValid = false;
                errorMessage.append("Time difference must be whole hours. ");
            }
        } catch (ParseException e) {
            isValid = false;
            errorMessage.append("Invalid time parsing error. ");
        }
    }

    // Validate categoryOption
    if (categoryOption == null || categoryOption.trim().isEmpty() || !isNumeric(categoryOption)) {
        isValid = false;
        errorMessage.append("Category selection is required and must be numeric. ");
    }

    // Validate serviceOption
    if (serviceOption == null || serviceOption.trim().isEmpty() || !isNumeric(serviceOption)) {
        isValid = false;
        errorMessage.append("Service selection is required and must be numeric. ");
    }

    if (!isValid) {
        response.sendRedirect("bookAppointment.jsp?serviceid=" + serviceOption + "&error=" + errorMessage.toString().trim());
        return;
    }

    // Proceed with booking
    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        String connURL = "jdbc:mysql://localhost:3306/jad_ca?user=root&password=root1234&serverTimezone=UTC";
        conn = DriverManager.getConnection(connURL);

        String sqlStr = "SELECT * FROM service WHERE service_id = ?";
        pstmt = conn.prepareStatement(sqlStr);
        pstmt.setString(1, serviceOption);
        rs = pstmt.executeQuery();

        if (rs.next()) {
            String serviceId = rs.getString("service_id");
            String priceStr = rs.getString("price");
            BigDecimal price = new BigDecimal(priceStr);

            String sqlInsert = "INSERT INTO booking (service_id, email, booking_date, booking_start_time, booking_end_time, total_price) VALUES (?, ?, ?, ?, ?, ?)";
            pstmt = conn.prepareStatement(sqlInsert);
            pstmt.setString(1, serviceId);
            pstmt.setString(2, email);
            pstmt.setString(3, selectedDate);
            pstmt.setString(4, selectedTimeStart);
            pstmt.setString(5, selectedTimeEnd);
            pstmt.setBigDecimal(6, price);
            pstmt.executeUpdate();

            response.sendRedirect("bookAppointment.jsp?success=Appointment booked successfully.");
        } else {
            response.sendRedirect("bookAppointment.jsp?error=Service not found.");
        }
    } catch (Exception e) {
        response.sendRedirect("bookAppointment.jsp?error=Error occurred: " + e.getMessage());
    } finally {
        if (rs != null) try { rs.close(); } catch (SQLException e) { e.printStackTrace(); }
        if (pstmt != null) try { pstmt.close(); } catch (SQLException e) { e.printStackTrace(); }
        if (conn != null) try { conn.close(); } catch (SQLException e) { e.printStackTrace(); }
    }
%>
	
</body>
</html>