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
        	<h2>Service Categories</h2>
        	<div class="service-cards">
            	<div class="card">
                	<h3>Home Cleaning</h3>
                	<p>Our comprehensive home cleaning service is designed to give your living space a fresh, spotless feel. Whether it's scrubbing floors, disinfecting surfaces, or dusting those hard-to-reach areas, our highly trained staff is equipped with the latest cleaning techniques and eco-friendly products. Trust us to create a cleaner, healthier home for you and your family, leaving every room sparkling and inviting.</p>
                	<button onclick="location.href='bookAppointment.jsp?categoryName=home'">Book Now!</button>
            	</div>
            	<div class="card">
                	<h3>Office Cleaning</h3>
                	<p>Maintain a professional and hygienic workspace with our specialized office cleaning service. Our dedicated team of trained professionals ensures your office is always clean, from common areas and desks to restrooms and breakrooms. We understand the importance of a tidy work environment for productivity and employee well-being. Let us tailor a cleaning plan that fits your business needs, whether it’s regular upkeep or deep cleaning solutions.</p>
                	<button onclick="location.href='bookAppointment.jsp?serviceName=office'">Book Now!</button>
            	</div>
            	<div class="card">
                	<h3>Upholstery Cleaning</h3>
                	<p>Give your furniture a new lease on life with our expert upholstery cleaning service. Our skilled staff is trained to handle all types of fabrics, from delicate materials to more robust textiles. Using advanced cleaning methods, we carefully remove stains, dust, and allergens, restoring your sofas, chairs, and cushions to their original beauty. You can trust our professionals to deliver a deep clean that extends the life of your furniture while maintaining its quality and comfort.</p>
                	<button onclick="location.href='bookAppointment.jsp?serviceName=uphols'">Book Now!</button>
            	</div>
            	<div class="card">
                	<h3>Carpet Cleaning</h3>
                	<p>Our professional carpet cleaning service goes beyond just surface cleaning. We tackle the deep-seated dirt, stains, and odors that accumulate over time, leaving your carpets looking vibrant and feeling fresh. With the expertise of our highly trained technicians, we use cutting-edge equipment and safe cleaning products to remove allergens and bacteria, creating a cleaner and healthier environment for your home or office. Let our team restore the beauty and softness of your carpets with a thorough, reliable clean.</p>
                	<button onclick="location.href='bookAppointment.jsp?serviceName=carpet'">Book Now!</button>
            	</div>
        	</div>
    	</section>
    <%@ include file="footer.jsp" %>
</body>
</html>