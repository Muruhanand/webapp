<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Navbar</title>
<link href="css/navbar.css" rel="stylesheet" />
</head>
<body>
    <nav>
        <ul class="navbar-menu">
            <li><a href="index.jsp"><img src="media/brand-logo.png"
                    alt="WebsiteLogo" class="navbarLogo"></a></li>
            <li><a href="serviceCategory.jsp">Browse Services</a></li>
            <li><a href="bookAppointment.jsp">Book an Appointment</a></li>
            <li><a href="cart.jsp">Cart</a></li>

            <%
            String userid = (String) session.getAttribute("userid");
            String role = (String) session.getAttribute("role");
            if (userid != null) {
                if ("admin".equalsIgnoreCase(role)) {
            %>
                <li><a href="adminDashboard.jsp">Admin</a></li>
            <%
                }
            %>
                <li><a href="profilelogic.jsp">Profile</a></li>
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
