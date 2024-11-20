<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Update Service Details</title>
    <link href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
<div class="container mt-5">
    <%
        // Debug prints
        System.out.println("Session ID in updateService.jsp: " + session.getId());
        String userId = (String) session.getAttribute("userid");

        if (userId == null) {
            response.sendRedirect("newlogin.jsp");
        } else {
            int usersid = Integer.parseInt(userId);

            // Extract form data from request
            String firstName = request.getParameter("first_name");
            String lastName = request.getParameter("last_name");
            String email = request.getParameter("email");
            String phoneNumber = request.getParameter("phone_number");
            String address = request.getParameter("address");

            // Database URL and connection setup
            String connURL = "jdbc:mysql://localhost:3306/jadca1?user=root&password=root123&serverTimezone=UTC";

            try {
                // Register JDBC driver (optional depending on your setup)
                Class.forName("com.mysql.cj.jdbc.Driver");

                // Establish database connection
                Connection connection = DriverManager.getConnection(connURL);

                // Prepare SQL query for updating user details
                String sql = "UPDATE user SET first_name = ?, last_name = ?, email = ?, phone_number = ?, address = ? WHERE customer_id = ?";
                PreparedStatement statement = connection.prepareStatement(sql);

                // Set parameters for the prepared statement
                statement.setString(1, firstName);
                statement.setString(2, lastName);
                statement.setString(3, email);
                statement.setString(4, phoneNumber);
                statement.setString(5, address);
                statement.setInt(6, usersid);

                // Execute update
                int rowsAffected = statement.executeUpdate();

                // Provide feedback to user
                if (rowsAffected > 0) {
                    out.println("<div class='alert alert-success' role='alert'>Service details updated successfully!</div>");
                    response.sendRedirect("profilelogic.jsp");
                } else {
                    out.println("<div class='alert alert-danger' role='alert'>Error updating details. Please try again.</div>");
                }

                // Close the connection
                connection.close();
            } catch (SQLException | ClassNotFoundException e) {
                e.printStackTrace();
                out.println("<div class='alert alert-danger' role='alert'>Database error: " + e.getMessage() + "</div>");
            }
        }
    %>
</div>
</body>
</html>