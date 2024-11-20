DROP TABLE IF EXISTS `feedback`;
DROP TABLE IF EXISTS `bookings`;
DROP TABLE IF EXISTS `service`;
DROP TABLE IF EXISTS `service_category`;
DROP TABLE IF EXISTS `user`;

CREATE TABLE `user` (
  `customer_id` int(11) NOT NULL AUTO_INCREMENT,
  `admin` boolean NOT NULL,
  `first_name` varchar(50) NOT NULL,
  `last_name` varchar(50) NOT NULL,
  `email` varchar(100) NOT NULL,
  `phone_number` varchar(15) DEFAULT NULL,
  `address` varchar(255) DEFAULT NULL,
  `password` varchar(255) NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`customer_id`),
  UNIQUE KEY `email` (`email`)
);

INSERT INTO `user` VALUES (1,true,'a','a','admin@gmail.com','81136589','aaa','9834876dcfb05cb167a5c24953eba58c4ac89b1adf57f28f2f9d09af107ee8f0','2024-11-11 13:04:15'),(2,false,'a','a','jovanyeo.jyzr@gmail.com','81136589','aaa','9834876dcfb05cb167a5c24953eba58c4ac89b1adf57f28f2f9d09af107ee8f0','2024-11-11 13:04:15');

CREATE TABLE `service_category` (
  `category_id` int(11) NOT NULL AUTO_INCREMENT,
  `category_name` varchar(100) NOT NULL,
  `description` text,
  PRIMARY KEY (`category_id`)
);

INSERT INTO `service_category` VALUES 
(1,'Residential Cleaning','General and detailed cleaning services for homes, including standard, deep, and move-in/move-out options.'),
(2,'Commercial Cleaning','Cleaning services tailored to offices, retail spaces, and warehouses, ensuring clean and organized work environments.'),
(3,'Specialized Cleaning','Focused cleaning services for carpets, windows, and upholstery, designed to handle specific materials and surfaces.'),
(4,'Eco-Friendly Cleaning','Cleaning services that use non-toxic and biodegradable products to minimize environmental impact.'),
(5,'Post-Construction Cleaning','Comprehensive cleaning after construction, including debris removal, rough cleaning, and final touch-ups.'),
(6,'Event Cleaning','Cleaning services for events, including pre-event setup, on-site cleaning during events, and post-event cleanup.'),
(7,'Janitorial Services','Daily or regular cleaning and maintenance for offices and commercial spaces, including trash removal and restroom sanitation.'),
(8,'Exterior Cleaning','Outdoor cleaning services like pressure washing, gutter cleaning, and roof cleaning for buildings.'),
(9,'Disinfection Services','Specialized sanitization services for homes and offices, targeting high-touch surfaces and areas.'),
(10,'Floor Care Services','Professional cleaning, polishing, and waxing for hardwood, tile, and other flooring types.'),
(11,'Specialty Cleaning','Niche cleaning services, including air duct cleaning, chimney sweeping, and pool maintenance.'),
(12,'Appliance Cleaning','Deep cleaning of household appliances such as ovens, refrigerators, and dishwashers to maintain efficiency.'),
(13,'Vacation Rental Cleaning','Turnover cleaning for vacation rentals, including laundry and restocking for new guests.'),
(14,'Seasonal Cleaning','Intensive cleaning for specific seasons, including spring cleaning, holiday preparation, and winter upkeep.'),
(15,'Pet-Specific Cleaning','Cleaning services focused on pet-related areas, including hair and odor removal and litter box sanitation.');

CREATE TABLE `service` (
  `service_id` int(11) NOT NULL AUTO_INCREMENT,
  `service_name` varchar(100) NOT NULL,
  `description` text,
  `price` decimal(10,2) NOT NULL,
  `category_id` int(11) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`service_id`),
  KEY `category_id` (`category_id`),
  CONSTRAINT `service_ibfk_1` FOREIGN KEY (`category_id`) REFERENCES `service_category` (`category_id`) ON DELETE SET NULL
);

INSERT INTO `service` (`service_name`, `description`, `price`, `category_id`, `created_at`)
VALUES
('Standard House Cleaning', 'General cleaning tasks such as vacuuming, dusting, mopping, and wiping surfaces.', 100.00, 2, '2024-11-07 05:09:05'),
('Deep Cleaning', 'A more thorough cleaning that includes baseboards, inside cabinets, appliances, and harder-to-reach areas.', 150.00, 4, '2024-11-07 05:09:05'),
('Move-In/Move-Out Cleaning', 'Specialized cleaning for homes before moving in or after moving out, including detailed cleaning of all rooms.', 200.00, 5, '2024-11-07 05:09:05'),
('Office Cleaning', 'Daily or weekly cleaning of office spaces, including vacuuming, dusting, and sanitizing common areas.', 120.00, 3, '2024-11-07 05:09:05'),
('Retail Store Cleaning', 'Cleaning and organizing retail spaces, including sweeping, window cleaning, and bathroom sanitation.', 130.00, 3, '2024-11-07 05:09:05'),
('Warehouse Cleaning', 'Industrial-level cleaning of warehouses, including floor scrubbing, dust removal, and waste management.', 180.00, 5, '2024-11-07 05:09:05'),
('Carpet Cleaning', 'Deep cleaning of carpets using steam or dry-cleaning methods to remove stains and odors.', 80.00, 2, '2024-11-07 05:09:05'),
('Window Cleaning', 'Interior and exterior cleaning of windows, frames, and sills.', 60.00, 2, '2024-11-07 05:09:05'),
('Upholstery Cleaning', 'Cleaning and sanitizing of sofas, chairs, and other fabric furniture.', 70.00, 2, '2024-11-07 05:09:05'),
('Green House Cleaning', 'Residential cleaning using environmentally safe products and methods.', 110.00, 3, '2024-11-07 05:09:05'),
('Eco-Friendly Office Cleaning', 'Commercial cleaning with non-toxic and biodegradable products.', 130.00, 3, '2024-11-07 05:09:05'),
('Recycling Management', 'Assisting homes and offices with proper waste segregation and recycling processes.', 50.00, 1, '2024-11-07 05:09:05'),
('Debris Removal', 'Clearing construction sites of debris, dust, and leftover materials.', 250.00, 5, '2024-11-07 05:09:05'),
('Final Cleaning', 'Detailed cleaning of newly constructed or renovated spaces, including windows, floors, and fixtures.', 300.00, 6, '2024-11-07 05:09:05'),
('Rough Cleaning', 'Initial cleaning during the construction phase, focusing on removing larger debris and dust.', 200.00, 4, '2024-11-07 05:09:05'),
('Pre-Event Cleaning', 'Preparing event spaces by cleaning floors, setting up spaces, and sanitizing.', 150.00, 3, '2024-11-07 05:09:05'),
('Post-Event Cleaning', 'Cleaning up after events by removing trash, sweeping floors, and sanitizing restrooms.', 170.00, 3, '2024-11-07 05:09:05'),
('On-Site Event Cleaning', 'Continuous cleaning service during events, managing trash, and keeping the venue tidy.', 200.00, 4, '2024-11-07 05:09:05'),
('Daily Office Cleaning', 'Regular cleaning services that include trash removal, floor cleaning, and restroom sanitation.', 100.00, 2, '2024-11-07 05:09:05'),
('Restroom Sanitation', 'Regular cleaning, disinfecting, and restocking of restrooms in commercial or public spaces.', 60.00, 2, '2024-11-07 05:09:05'),
('Trash Removal and Recycling', 'Routine removal of garbage and recycling from commercial buildings or residential areas.', 50.00, 1, '2024-11-07 05:09:05'),
('Pressure Washing', 'Cleaning of exterior walls, driveways, and sidewalks using high-pressure water jets.', 120.00, 2, '2024-11-07 05:09:05'),
('Gutter Cleaning', 'Clearing and cleaning gutters to ensure proper drainage.', 80.00, 2, '2024-11-07 05:09:05'),
('Roof Cleaning', 'Removing dirt, debris, and mold from residential or commercial roofs.', 150.00, 3, '2024-11-07 05:09:05'),
('Home Disinfection', 'Using approved disinfectants to sanitize surfaces in homes, especially high-touch areas.', 90.00, 2, '2024-11-07 05:09:05'),
('Office Disinfection', 'Regular disinfection of workstations, desks, and shared spaces in offices.', 100.00, 2, '2024-11-07 05:09:05'),
('COVID-19 Cleaning', 'Deep sanitization focusing on preventing virus spread in homes or commercial areas.', 120.00, 3, '2024-11-07 05:09:05'),
('Hardwood Floor Polishing', 'Cleaning, polishing, and waxing hardwood floors to restore shine and durability.', 140.00, 3, '2024-11-07 05:09:05'),
('Tile and Grout Cleaning', 'Deep cleaning of tiles and grout to remove dirt, stains, and mold.', 130.00, 3, '2024-11-07 05:09:05'),
('Floor Stripping and Waxing', 'Removing old wax layers and applying new coats to protect and shine floors.', 160.00, 3, '2024-11-07 05:09:05'),
('Air Duct Cleaning', 'Cleaning and sanitizing air ducts to improve air quality and HVAC efficiency.', 180.00, 3, '2024-11-07 05:09:05'),
('Chimney Cleaning', 'Removal of soot and blockages from chimneys to ensure proper ventilation.', 100.00, 2, '2024-11-07 05:09:05'),
('Pool Cleaning', 'Cleaning and maintenance of residential or commercial swimming pools.', 150.00, 3, '2024-11-07 05:09:05'),
('Oven Cleaning', 'Removing grease, grime, and buildup from oven interiors.', 70.00, 2, '2024-11-07 05:09:05'),
('Refrigerator Cleaning', 'Emptying and sanitizing refrigerators, including shelves, drawers, and doors.', 80.00, 2, '2024-11-07 05:09:05'),
('Dishwasher Cleaning', 'Cleaning and descaling dishwashers to maintain efficiency.', 60.00, 1, '2024-11-07 05:09:05'),
('Turnover Cleaning', 'Quick and efficient cleaning between guests in vacation rentals (Airbnb, VRBO, etc.).', 90.00, 2, '2024-11-07 05:09:05'),
('Laundry Service', 'Washing and replacing linens and towels in vacation rentals.', 40.00, 1, '2024-11-07 05:09:05'),
('Stocking and Restocking Supplies', 'Refilling amenities like toiletries, cleaning supplies, and coffee for the next guest.', 30.00, 1, '2024-11-07 05:09:05'),
('Spring Cleaning', 'Intensive cleaning that covers every room and includes organizing, decluttering, and deep cleaning.', 200.00, 5, '2024-11-07 05:09:05'),
('Holiday Cleaning', 'Pre-holiday cleaning to prepare homes for guests or post-holiday cleanup to remove decorations and waste.', 150.00, 4, '2024-11-07 05:09:05'),
('Winter Cleaning', 'Specialized cleaning for homes during colder months, including snow removal and de-icing services.', 170.00, 4, '2024-11-07 05:09:05'),
('Pet Hair Removal', 'Thorough cleaning of carpets, furniture, and upholstery to remove pet hair.', 60.00, 2, '2024-11-07 05:09:05'),
('Odor Removal', 'Deodorizing spaces affected by pet odors, including deep cleaning carpets and fabrics.', 80.00, 2, '2024-11-07 05:09:05'),
('Litter Box Area Cleaning', 'Deep cleaning and sanitizing of areas where pets litter boxes or sleeping areas are located.', 50.00, 1, '2024-11-07 05:09:05');


CREATE TABLE `bookings` (
  `booking_id` int(11) NOT NULL AUTO_INCREMENT,
  `customer_id` int(11)  NOT NULL,
  `service_id` int(11) NOT NULL,
  `booking_date` date NOT NULL,
  `booking_start_time` time NOT NULL,
  `booking_end_time` time NOT NULL,
  `total_price` decimal(10,2) NOT NULL,
  `status` enum('pending','confirmed','canceled','completed') DEFAULT 'pending',
  `payment_status` enum('pending','paid','failed') DEFAULT 'pending',
  `payment_method` enum('online','offline','bank_transfer') DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`booking_id`),
  KEY `customer_id` (`customer_id`),
  KEY `service_id` (`service_id`),
  CONSTRAINT `bookings_ibfk_1` FOREIGN KEY (`customer_id`) REFERENCES `user` (`customer_id`) ON DELETE CASCADE
);

CREATE TABLE `feedback` (
  `feedback_id` int(11) NOT NULL AUTO_INCREMENT,
  `customer_id` int(11) DEFAULT NULL,
  `service_id` int(11) DEFAULT NULL,
  `rating` int(11) DEFAULT NULL,
  `comment` text,
  `feedback_date` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`feedback_id`),
  KEY `customer_id` (`customer_id`),
  KEY `service_id` (`service_id`),
  CONSTRAINT `feedback_ibfk_1` FOREIGN KEY (`customer_id`) REFERENCES `user` (`customer_id`) ON DELETE CASCADE,
  CONSTRAINT `feedback_ibfk_2` FOREIGN KEY (`service_id`) REFERENCES `service` (`service_id`) ON DELETE SET NULL
);