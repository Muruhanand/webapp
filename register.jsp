<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Customer Form</title>
</head>
<body>
    <h2>Customer Information Form</h2>
    <form action="processCustomerData.jsp" method="post">


        <label for="first_name">First Name:</label>
        <input type="text" id="first_name" name="first_name" required><br><br>

        <label for="last_name">Last Name:</label>
        <input type="text" id="last_name" name="last_name" required><br><br>

        <label for="email">Email:</label>
        <input type="email" id="email" name="email" required><br><br>

        <label for="phone_number">Phone Number:</label>
        <input type="text" id="phone_number" name="phone_number" required><br><br>

        <label for="address">Address:</label>
        <textarea id="address" name="address" required></textarea><br><br>

        <label for="password">Password:</label>
        <input type="password" id="password" name="password" required><br><br>



        <input type="submit" value="Submit">
    </form>
</body>
</html>
