<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
    <%@page import="java.text.SimpleDateFormat"%>  
    <%@page import="java.util.Date"%>
    <%@page import="java.sql.*"%>
    <%@page import="java.text.ParseException"%>
	<%
		String email = request.getParameter("email");
    	String selectedDate = request.getParameter("selectedDate");
    	String selectedTimeStart = request.getParameter("selectedTimeStart");
        String selectedTimeEnd = request.getParameter("selectedTimeEnd");
    	String categoryOption = request.getParameter("categoryOptions");
    	String serviceOption = request.getParameter("serviceOptions");
    	
    	boolean isValid = true;
        StringBuilder validationMessage = new StringBuilder();

        // Validate email
        if (email == null || email.trim().isEmpty() || !email.matches("^[\\w.%+-]+@[\\w.-]+\\.[a-zA-Z]{2,}$")) {
            isValid = false;
            response.sendRedirect("bookAppointment.jsp?serviceid="+serviceOption+"&error=Invalid email address.");
        }

        // Validate date
        if (selectedDate == null || selectedDate.trim().isEmpty()) {
            isValid = false;
            response.sendRedirect("bookAppointment.jsp?serviceid="+serviceOption+"&error=Date is required.");
        }

        // Validate time
        if (selectedTimeStart == null || selectedTimeStart.trim().isEmpty()) {
            isValid = false;
            response.sendRedirect("bookAppointment.jsp?serviceid="+serviceOption+"&error=Starting time is required.");
        }

        if (selectedTimeEnd == null || selectedTimeEnd.trim().isEmpty()) {
            isValid = false;
            response.sendRedirect("bookAppointment.jsp?serviceid="+serviceOption+"&error=Starting time is required.");
        }
        // Validate that the time between start and end are whole hours
        if (isValid) {
            try {
            SimpleDateFormat sdf = new SimpleDateFormat("HH:mm");
            Date startTime = sdf.parse(selectedTimeStart);
            Date endTime = sdf.parse(selectedTimeEnd);

            long differenceInMilliSeconds = endTime.getTime() - startTime.getTime();
            long differenceInHours = differenceInMilliSeconds / (60 * 60 * 1000);

            if (differenceInHours < 1 || differenceInMilliSeconds % (60 * 60 * 1000) != 0) {
                isValid = false;
                response.sendRedirect("bookAppointment.jsp?serviceid=" + serviceOption + "&error=Time difference must be whole hours.");
            }
            } catch (ParseException e) {
            	isValid = false;
            	response.sendRedirect("bookAppointment.jsp?serviceid=" + serviceOption + "&error=Invalid time format.");
            }
        }

        // Validate category option
        if (categoryOption == null || categoryOption.trim().isEmpty()) {
            isValid = false;
            response.sendRedirect("bookAppointment.jsp?serviceid="+serviceOption+"&error=Category selection is required.");
        }

        // Validate service option
        if (serviceOption == null || serviceOption.trim().isEmpty()) {
            isValid = false;
            response.sendRedirect("bookAppointment.jsp?error=Service selection is required.");
        }
        Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;

        try{
            Class.forName("com.mysql.cj.jdbc.Driver");
			String connURL = "jdbc:mysql://localhost:3306/jad_ca?user=root&password=root1234&serverTimezone=UTC";
			conn = DriverManager.getConnection(connURL);
            String sqlStr = "SELECT * FROM service WHERE service_id = ?";
            pstmt = conn.prepareStatement(sqlStr);
            pstmt.setString(1, serviceOption);
            rs = pstmt.executeQuery();

            if (rs.next()) {
                String serviceId = rs.getString("service_id");
                String serviceName = rs.getString("service_name");
                String categoryId = rs.getString("category_id");
                String price = rs.getString("price");

                String sqlStrInsert = "INSERT INTO appointment (email, service_id, category_id, appointment_date, start_time, end_time, price) VALUES (?, ?, ?, ?, ?, ?, ?)";
                pstmt = conn.prepareStatement(sqlStrInsert);
                pstmt.setString(1, email);
                pstmt.setString(2, serviceId);
                pstmt.setString(3, categoryId);
                pstmt.setString(4, selectedDate);
                pstmt.setString(5, selectedTimeStart);
                pstmt.setString(6, selectedTimeEnd);
                pstmt.setString(7, price);
                pstmt.executeUpdate();
                response.sendRedirect("bookAppointment.jsp?success=Appointment booked successfully.");
            } else {
                response.sendRedirect("bookAppointment.jsp?error=Service not found.");
            }
            
        }catch (Exception e) {
		out.println("Error: " + e.getMessage());
        }finally{
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