<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="jadca1.User, java.sql.Connection, java.sql.DriverManager, java.sql.PreparedStatement, java.sql.SQLException"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Update Service Details</title>
</head>
<body>
    <%
        // Debug prints
        System.out.println("Session ID in updateService.jsp: " + session.getId());
    User user = (User) session.getAttribute("user");
    String userId = (String) session.getAttribute("userid");
    
    int usersid = Integer.parseInt(userId);
        if (user != null) {
            // Extract form data from request
            String firstName = request.getParameter("first_name");
            String lastName = request.getParameter("last_name");
            String email = request.getParameter("email");
            String phoneNumber = request.getParameter("phone_number");
            String address = request.getParameter("address");
			int phonenum = Integer.parseInt(phoneNumber);
            // Update the user object
            user.setFirstName(firstName);
            user.setLastName(lastName);
            user.setEmail(email);
            user.setPhoneNumber(phonenum);
            user.setAddress(address);

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
                statement.setInt(6, usersid);  // Assuming User object has getUserId() method

                // Execute update
                int rowsAffected = statement.executeUpdate();

                // Provide feedback to user
                if (rowsAffected > 0) {
                    out.println("<p>Service details updated successfully!</p>");
                    response.sendRedirect("userprofile.jsp");
                } else {
                    out.println("<p>Error updating details. Please try again.</p>");
                }
                
                // Close the connection
                connection.close();
            } catch (SQLException | ClassNotFoundException e) {
                e.printStackTrace();
                out.println("<p>Database error: " + e.getMessage() + "</p>");
            }
        } else {
            out.println("<p>User session not found. Please log in.</p>");
        }
    %>

</body>
</html>
