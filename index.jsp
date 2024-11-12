<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>The Clean Slate</title>
<link rel="stylesheet" href="css/styles.css">
</head>
<body>
	<%@ include file="navbar.jsp"%>

	<!-- Hero Section -->
	<section id="hero">
		<div class="hero-content">
			<h1>Welcome to Our Business</h1>
			<p>Providing the best services for your needs.</p>
			<a href="#services" class="cta-button">Learn More</a>
		</div>
	</section>

	<section id="about-us">
		<div class="about-container">
			<h2>About Us</h2>
			<p>
				Welcome to <strong>CleanSpace Services</strong>, your trusted
				partner for all your cleaning needs. With years of experience in the
				industry, we are committed to delivering top-notch cleaning services
				to homes and businesses across the city. Our mission is to provide a
				cleaner, healthier, and more organized environment for our clients,
				ensuring complete satisfaction every time.
			</p>

			<div class="about-mission">
				<h3>Our Mission</h3>
				<p>At CleanSpace, our mission is simple: to provide exceptional
					cleaning services while ensuring the well-being of our clients and
					the environment. We believe that a clean space fosters
					productivity, relaxation, and peace of mind, which is why we strive
					to exceed expectations in every job we undertake.
				</p>
			</div>

			<div class="about-values">
				<h3>Our Values</h3>
				<table>
					<tr>
						<th><strong>Quality:</strong></th>
						<th><strong>Integrity:</strong></th>
						<th><strong>Eco-Friendliness:</strong></th>
						<th>Customer Satisfaction:</th>
					</tr>
					<tr>
						<td>We use the best products and
						equipment to ensure a spotless finish.</td>
						<td>We are transparent and honest
						in every interaction, providing services you can trust.</td>
						<td>We prioritize the use
						of environmentally-friendly products that are safe for your
						family, pets, and the planet.</td>
						<td>Your happiness is
						our top priority, and we guarantee you'll love the results.</td>
					</tr>
				</table>
			</div>

			<div class="about-team">
				<h3>Meet Our Team</h3>
				<p>Our team consists of highly trained and experienced
					professionals who are passionate about delivering the best service.
					From basic cleaning tasks to deep cleaning solutions, our staff is
					equipped with the latest tools and techniques to ensure your space
					looks and feels its best.</p>
			</div>

			<div class="about-cta">
				<p>If you have ever used our services, write in now if you wish 
				to convey any feedback for our staff or services. Contact us now!</p>
				<a href="contact.jsp" class="cta-button">Get in Touch</a>
			</div>
		</div>
	</section>

	<%@ include file="footer.jsp"%>
</body>
</html>
