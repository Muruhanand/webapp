<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
    <title>Clean Slate Services</title>
    <link rel="stylesheet" href="css/styles.css">
</head>
<body>
    <%@ include file="navbar.jsp" %>
    	<!-- Services Section -->
    	<section id="services">
        	<h2>Our Services</h2>
        	<div class="service-cards">
            	<div class="card">
                	<h3>Home Cleaning</h3>
                	<p>Description of Service 1.</p>
            	</div>
            	<div class="card">
                	<h3>Office Cleaning</h3>
                	<p>Description of Service 2.</p>
            	</div>
            	<div class="card">
                	<h3>Upholstery CLeaning</h3>
                	<p>Description of Service 3.</p>
                	<button onclick="location.href('bookAppointment.jsp?serviceName=``')">Book Now!</button>
            	</div>
            	<div class="card">
                	<h3>Cart CLeaning</h3>
                	<p>Description of Service 3.</p>
                	<button onclick="location.href('bookAppointment.jsp?serviceName=``')">Book Now!</button>
            	</div>
        	</div>
    	</section>
    <%@ include file="footer.jsp" %>
</body>
</html>