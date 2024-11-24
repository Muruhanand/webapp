<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.Connection, java.sql.DriverManager, java.sql.PreparedStatement, java.sql.SQLException"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Update Service Details</title>
</head>
<body>
<%
    String userId = (String) session.getAttribute("userid");

    if (userId == null) {
        // Redirect to login if session is invalid
        response.sendRedirect("login.jsp");
        return;
    }
    try {
        int userid = Integer.parseInt(userId); // Parse session userId
        String firstName = request.getParameter("first_name");
        String lastName = request.getParameter("last_name");
        String email = request.getParameter("email");
        String phoneNumber = request.getParameter("phone_number");
        String address = request.getParameter("address");

        System.out.println("Updating details for User ID: " + userid);
        System.out.println("First Name: " + firstName);
        System.out.println("Last Name: " + lastName);
        System.out.println("Email: " + email);
        System.out.println("Phone Number: " + phoneNumber);
        System.out.println("Address: " + address);

        String connURL = "jdbc:mysql://localhost:3306/jad_ca?user=root&password=root1234&serverTimezone=UTC";
        Class.forName("com.mysql.cj.jdbc.Driver"); // Load driver
        Connection connection = DriverManager.getConnection(connURL);

        String sql = "UPDATE user SET first_name = ?, last_name = ?, email = ?, phone_number = ?, address = ? WHERE customer_id = ?";
        PreparedStatement statement = connection.prepareStatement(sql);

        statement.setString(1, firstName);
        statement.setString(2, lastName);
        statement.setString(3, email);
        statement.setString(4, phoneNumber); // Do not parse phone number; use it as a string
        statement.setString(5, address);
        statement.setInt(6, userid); // Use corrected variable name

        int rowsAffected = statement.executeUpdate();

        // Feedback to user
        if (rowsAffected > 0) {
            out.println("<p>Service details updated successfully!</p>");
            response.sendRedirect("profilelogic.jsp");
        } else {
            out.println("<p>Error updating details. Please try again.</p>");
        }

        // Close connection
        statement.close();
        connection.close();
    } catch (NumberFormatException e) {
        out.println("<p>Invalid user ID format. Please log in again.</p>");
    } catch (SQLException | ClassNotFoundException e) {
        out.println("<p>Database error: " + e.getMessage() + "</p>");
    }
%>
</body>
</html>

