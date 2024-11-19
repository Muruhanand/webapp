<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="jadca1.User" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Edit Service Details</title>
</head>
<body>
    <%
    // Debug prints
    System.out.println("Session ID in userprofile.jsp: " + session.getId());
    User user = (User) session.getAttribute("user");
    System.out.println("User object from session: " + (user != null ? "found" : "not found"));
    
    if (user != null) {
        System.out.println("User name from session: " + user.getFirstName() + " " + user.getLastName());
    %>
    <form action="updateService.jsp" method="post">
        <label for="first_name">First Name:</label>
        <input type="text" id="first_name" name="first_name" value="<%= user.getFirstName() %>" required><br><br>

        <label for="last_name">Last Name:</label>
        <input type="text" id="last_name" name="last_name" value="<%= user.getLastName() %>" required><br><br>

        <label for="email">Email:</label>
        <input type="email" id="email" name="email" value="<%= user.getEmail() %>" required><br><br>

        <label for="phone_number">Phone Number:</label>
        <input type="tel" id="phone_number" name="phone_number" value="<%= user.getPhoneNumber() %>" required><br><br>

        <label for="address">Address:</label>
        <textarea id="address" name="address" required><%= user.getAddress() %></textarea><br><br>

        <input type="submit" value="Update">
    </form>
    <% } else { %>
        <p>User information not found. Debug info:</p>
        <p>Session attributes available:</p>
        <%
        java.util.Enumeration<String> attributeNames = session.getAttributeNames();
        while(attributeNames.hasMoreElements()) {
            String attributeName = attributeNames.nextElement();
            out.println(attributeName + ": " + session.getAttribute(attributeName) + "<br>");
        }
        %>
    <% } %>
</body>
</html>