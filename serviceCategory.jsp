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
        <h3>Residential Cleaning</h3>
        <p>Standard House Cleaning: General cleaning tasks such as vacuuming, dusting, mopping, and wiping surfaces.<br>
        Deep Cleaning: Includes baseboards, inside cabinets, appliances, and harder-to-reach areas.<br>
        Move-In/Move-Out Cleaning: Specialized cleaning before moving in or after moving out.</p>
        <button onclick="location.href='searchCategories.jsp?categoryName=residential'">Book Now!</button>
    </div>

    <div class="card">
        <h3>Commercial Cleaning</h3>
        <p>Office Cleaning: Daily or weekly office space cleaning.<br>
        Retail Store Cleaning: Sweeping, window cleaning, and bathroom sanitation.<br>
        Warehouse Cleaning: Industrial-level cleaning including floor scrubbing and waste management.</p>
        <button onclick="location.href='searchCategories.jsp?categoryName=commercial'">Book Now!</button>
    </div>

    <div class="card">
        <h3>Specialized Cleaning</h3>
        <p>Carpet Cleaning: Deep cleaning carpets using steam or dry-cleaning methods.<br>
        Window Cleaning: Interior and exterior cleaning of windows.<br>
        Upholstery Cleaning: Cleaning of fabric furniture like sofas and chairs.</p>
        <button onclick="location.href='searchCategories.jsp?categoryName=specialized'">Book Now!</button>
    </div>

    <div class="card">
        <h3>Eco-Friendly Cleaning</h3>
        <p>Green House Cleaning: Residential cleaning with eco-friendly products.<br>
        Eco-Friendly Office Cleaning: Commercial cleaning with non-toxic, biodegradable products.<br>
        Recycling Management: Assisting with waste segregation and recycling processes.</p>
        <button onclick="location.href='searchCategories.jsp?categoryName=ecoFriendly'">Book Now!</button>
    </div>

    <div class="card">
        <h3>Post-Construction Cleaning</h3>
        <p>Debris Removal: Clearing construction sites of debris.<br>
        Final Cleaning: Detailed cleaning of newly constructed or renovated spaces.<br>
        Rough Cleaning: Initial cleaning during the construction phase.</p>
        <button onclick="location.href='searchCategories.jsp?categoryName=postConstruction'">Book Now!</button>
    </div>

    <div class="card">
        <h3>Event Cleaning</h3>
        <p>Pre-Event Cleaning: Preparing event spaces by cleaning and setting up.<br>
        Post-Event Cleaning: Cleaning up after events by removing trash and sanitizing.<br>
        On-Site Event Cleaning: Continuous cleaning during events to keep the venue tidy.</p>
        <button onclick="location.href='searchCategories.jsp?categoryName=event'">Book Now!</button>
    </div>

    <div class="card">
        <h3>Janitorial Services</h3>
        <p>Daily Office Cleaning: Regular trash removal and floor cleaning.<br>
        Restroom Sanitation: Cleaning, disinfecting, and restocking of restrooms.<br>
        Trash Removal and Recycling: Routine garbage and recycling removal from buildings.</p>
        <button onclick="location.href='searchCategories.jsp?categoryName=janitorial'">Book Now!</button>
    </div>

    <div class="card">
        <h3>Exterior Cleaning</h3>
        <p>Pressure Washing: Cleaning of exterior walls, driveways, and sidewalks.<br>
        Gutter Cleaning: Clearing gutters to ensure proper drainage.<br>
        Roof Cleaning: Removing dirt and mold from roofs.</p>
        <button onclick="location.href='searchCategories.jsp?categoryName=exterior'">Book Now!</button>
    </div>

    <div class="card">
        <h3>Disinfection Services</h3>
        <p>Home Disinfection: Sanitizing surfaces in homes.<br>
        Office Disinfection: Regular disinfection of workstations and shared spaces.<br>
        COVID-19 Cleaning: Deep sanitization to prevent virus spread.</p>
        <button onclick="location.href='searchCategories.jsp?categoryName=disinfection'">Book Now!</button>
    </div>

    <div class="card">
        <h3>Floor Care Services</h3>
        <p>Hardwood Floor Polishing: Cleaning and polishing hardwood floors.<br>
        Tile and Grout Cleaning: Deep cleaning of tiles and grout.<br>
        Floor Stripping and Waxing: Removing old wax and applying new coats for floor protection.</p>
        <button onclick="location.href='searchCategories.jsp?categoryName=floorCare'">Book Now!</button>
    </div>

    <div class="card">
        <h3>Specialty Cleaning</h3>
        <p>Air Duct Cleaning: Cleaning air ducts to improve air quality.<br>
        Chimney Cleaning: Removing soot and blockages from chimneys.<br>
        Pool Cleaning: Cleaning and maintaining swimming pools.</p>
        <button onclick="location.href='searchCategories.jsp?categoryName=specialty'">Book Now!</button>
    </div>

    <div class="card">
        <h3>Appliance Cleaning</h3>
        <p>Oven Cleaning: Removing grease and grime from ovens.<br>
        Refrigerator Cleaning: Sanitizing refrigerators, shelves, and drawers.<br>
        Dishwasher Cleaning: Cleaning and descaling dishwashers.</p>
        <button onclick="location.href='searchCategories.jsp?categoryName=appliance'">Book Now!</button>
    </div>

    <div class="card">
        <h3>Vacation Rental Cleaning</h3>
        <p>Turnover Cleaning: Quick cleaning between guests in vacation rentals.<br>
        Laundry Service: Washing and replacing linens in vacation rentals.<br>
        Stocking Supplies: Refilling amenities like toiletries and coffee for the next guest.</p>
        <button onclick="location.href='searchCategories.jsp?categoryName=vacationRental'">Book Now!</button>
    </div>

    <div class="card">
        <h3>Seasonal Cleaning</h3>
        <p>Spring Cleaning: Intensive cleaning that covers every room.<br>
        Holiday Cleaning: Pre or post-holiday cleaning for homes.<br>
        Winter Cleaning: Specialized cleaning during the colder months.</p>
        <button onclick="location.href='searchCategories.jsp?categoryName=seasonal'">Book Now!</button>
    </div>

    <div class="card">
        <h3>Pet-Specific Cleaning</h3>
        <p>Pet Hair Removal: Thorough cleaning to remove pet adwhair from carpets and furniture.<br>
        Odor Removal: Deodorizing spaces affected by pet odors.<br>
        Litter Box Area Cleaning: Deep cleaning of litter box areas.</p>
        <button onclick="location.href='searchCategories.jsp?categoryName=petSpecific'">Book Now!</button>
    </div>
</div>

    	</section>
    <%@ include file="footer.jsp" %>
</body>
</html>