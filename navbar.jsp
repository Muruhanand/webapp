<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Navbar</title>
    <link href="css/navbar.css" rel="stylesheet" />
</head>
<body>
	<nav>
    	<ul>
			<li><a href="index.jsp"><img src="media/brand-logo.png" alt="WebsiteLogo" class="navbarLogo"></img></a></li>
    		<li><a href="serviceCategory.jsp">Browse Services</a></li>
        	<li><a href="bookAppointment.jsp">Book an Appointment</a></li>
            <li><a href="cart.jsp">Cart</a></li>

            <% 
                // Check if user is logged in by checking the session
                String userEmail = (String) session.getAttribute("userEmail");
                if (userEmail != null) {
            %>
                <li><a href="profile.jsp">Profile</a></li>
                <li><a href="logout.jsp">Logout</a></li>
            <% 
                } else {
            %>
                <li><a href="login.jsp">Login</a></li>
            <% 
                }
            %>
        </ul>
    </nav>
</body>
</html>
