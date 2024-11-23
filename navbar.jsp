<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Navbar</title>
    <link href="css/navbar.css" rel="stylesheet" />
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com">
    <link href="https://fonts.googleapis.com/css2?family=Josefin+Sans&family=Libre+Baskerville:ital,wght@0,400;0,700;1,400&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
    <nav class="navbar navbar-expand-lg navbar-light bg-light">
        <div class="container-fluid">
            <a class="navbar-brand" href="index.jsp">
                <img src="media/brand-logo.png" alt="WebsiteLogo" class="navbarLogo">
            </a>
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav" aria-controls="navbarNav" aria-expanded="false" aria-label="Toggle navigation">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse" id="navbarNav">
                <ul class="navbar-nav ms-auto">
                    <li class="nav-item">
                        <a class="nav-link" href="serviceCategory.jsp">Browse Services</a>
                    </li>
                    <%
                    String userid = (String) session.getAttribute("userid");
                    String role = (String) session.getAttribute("role");
                    if (userid != null) {
                    %>
                        <li class="nav-item">
                            <a class="nav-link" href="bookAppointment.jsp">Book an Appointment</a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="cart.jsp">Cart</a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="profilelogic.jsp">Profile</a>
                        </li>
                    <%
                    }
                    if (role != null && role.equals("Admin")) {
                    %>
                        <li class="nav-item">
                            <a class="nav-link" href="admin.jsp">Admin</a>
                        </li>
                    <%
                    }
                    if (role != null && role.equals("member")) {
                    %>
                        <li class="nav-item">
                            <a class="nav-link" href="logout.jsp">Logout</a>
                        </li>
                    <%
                    } else {
                    %>
                        <li class="nav-item">
                            <a class="nav-link" href="newlogin.jsp">Login/Signup</a>
                        </li>
                    <%
                    }
                    %>
                </ul>
            </div>
        </div>
    </nav>
</body>
</html>