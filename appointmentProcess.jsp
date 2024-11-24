<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Book Appointment</title>
</head>
<body>
<%@ page import="java.text.SimpleDateFormat, java.util.Date, java.sql.*, java.text.ParseException, java.math.BigDecimal, java.lang.StringBuilder"%>
<%
    String customer_id = "";
    if(session.getAttribute("userid") != null) {
        customer_id = (String) session.getAttribute("userid");
    } else {
        out.println("<script>alert('Please log in to book an appointment.'); window.location.href = 'index.jsp';</script>");
        return;
    }

    String selectedDate = request.getParameter("selectedDate");
    String selectedTimeStart = request.getParameter("selectedTimeStart");
    String selectedTimeEnd = request.getParameter("selectedTimeEnd");
    String categoryOption = request.getParameter("categoryOptions");
    String serviceOption = request.getParameter("serviceOptions");
    int numOfHours = 0;

    boolean isValid = true;
    StringBuilder errorMessage = new StringBuilder();

    // Print the values being submitted
    System.out.println("Selected Date: " + selectedDate);
    System.out.println("Selected Time Start: " + selectedTimeStart);
    System.out.println("Selected Time End: " + selectedTimeEnd);
    System.out.println("Category Option: " + categoryOption);
    System.out.println("Service Option: " + serviceOption);

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
    if (selectedTimeStart == null || !selectedTimeStart.matches("^(?:[01]\\d|2[0-3]):[0-5]\\d$")) {
        isValid = false;
        errorMessage.append("Invalid or missing start time (expected HH:mm). ");
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
            long differenceInHours = differenceInMilliSeconds / (60 * 60 * 1000);

            // Validate the time difference
            if (differenceInHours < 1 || differenceInMilliSeconds % (60 * 60 * 1000) != 0) {
                isValid = false;
                errorMessage.append("Time difference must be whole hours. ");
            } else {
                numOfHours = (int) differenceInHours;
            }
        } catch (ParseException e) {
            isValid = false;
            errorMessage.append("Invalid time format. ");
        }
    }

    // Validate categoryOption and serviceOption
    if (categoryOption == null || !categoryOption.matches("\\d+")) {
        isValid = false;
        errorMessage.append("Invalid or missing category. ");
    }
    if (serviceOption == null || !serviceOption.matches("\\d+")) {
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
        String connURL = "jdbc:mysql://localhost:3306/jadca1?user=root&password=root123&serverTimezone=UTC";
        conn = DriverManager.getConnection(connURL);

        String sqlStr = "SELECT * FROM service WHERE service_id = ?";
        pstmt = conn.prepareStatement(sqlStr);
        pstmt.setString(1, serviceOption);
        rs = pstmt.executeQuery();

        if (rs.next()) {
            String serviceId = rs.getString("service_id");
            String priceStr = rs.getString("price");
            BigDecimal price = new BigDecimal(priceStr);
            BigDecimal totalPrice = price.multiply(BigDecimal.valueOf(numOfHours));

            String sqlInsert = "INSERT INTO bookings (service_id, customer_id, booking_date, booking_start_time, booking_end_time, total_price) VALUES (?, ?, ?, ?, ?, ?)";
            pstmt.close(); // Close previous statement
            pstmt = conn.prepareStatement(sqlInsert);
            pstmt.setString(1, serviceId);
            pstmt.setString(2, customer_id);
            pstmt.setString(3, selectedDate);
            pstmt.setString(4, selectedTimeStart);
            pstmt.setString(5, selectedTimeEnd);
            pstmt.setBigDecimal(6, totalPrice);
            pstmt.executeUpdate();

            response.sendRedirect("bookAppointment.jsp?success=Appointment booked successfully.");
        } else {
            response.sendRedirect("bookAppointment.jsp?error=Service not found.");
        }
    } catch (Exception e) {
        response.sendRedirect("bookAppointment.jsp?error=Error occurred: " + e.getMessage());
    } finally {
        try {
            if (rs != null) rs.close();
            if (pstmt != null) pstmt.close();
            if (conn != null) conn.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
%>
</body>
</html>
