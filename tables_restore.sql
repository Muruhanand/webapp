-- MySQL dump 10.13  Distrib 8.0.14, for Win64 (x86_64)
--
-- Host: 127.0.0.1    Database: jadca1
-- ------------------------------------------------------
-- Server version	8.0.15

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
 SET NAMES utf8 ;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;
--
-- Table structure for table `bookings`
--

DROP TABLE IF EXISTS `bookings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
 SET character_set_client = utf8mb4 ;
CREATE TABLE `bookings` (
  `booking_id` int(11) NOT NULL AUTO_INCREMENT,
  `customer_id` int(11) NOT NULL,
  `service_id` int(11) NOT NULL,
  `email` varchar(100) NOT NULL,
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `bookings`
--

LOCK TABLES `bookings` WRITE;
/*!40000 ALTER TABLE `bookings` DISABLE KEYS */;
/*!40000 ALTER TABLE `bookings` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `feedback`
--

DROP TABLE IF EXISTS `feedback`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
 SET character_set_client = utf8mb4 ;
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `feedback`
--

LOCK TABLES `feedback` WRITE;
/*!40000 ALTER TABLE `feedback` DISABLE KEYS */;
/*!40000 ALTER TABLE `feedback` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `service`
--

DROP TABLE IF EXISTS `service`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
 SET character_set_client = utf8mb4 ;
CREATE TABLE `service` (
  `service_id` int(11) NOT NULL AUTO_INCREMENT,
  `service_name` varchar(100) NOT NULL,
  `description` text,
  `price` decimal(10,2) NOT NULL,
  `duration` int(11) NOT NULL,
  `category_id` int(11) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`service_id`),
  KEY `category_id` (`category_id`),
  CONSTRAINT `service_ibfk_1` FOREIGN KEY (`category_id`) REFERENCES `service_category` (`category_id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=46 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `service`
--

LOCK TABLES `service` WRITE;
/*!40000 ALTER TABLE `service` DISABLE KEYS */;
INSERT INTO `service` VALUES (1,'Standard House Cleaning','General cleaning tasks such as vacuuming, dusting, mopping, and wiping surfaces.',100.00,2,1,'2024-11-07 05:09:05'),(2,'Deep Cleaning','A more thorough cleaning that includes baseboards, inside cabinets, appliances, and harder-to-reach areas.',150.00,4,1,'2024-11-07 05:09:05'),(3,'Move-In/Move-Out Cleaning','Specialized cleaning for homes before moving in or after moving out, including detailed cleaning of all rooms.',200.00,5,1,'2024-11-07 05:09:05'),(4,'Office Cleaning','Daily or weekly cleaning of office spaces, including vacuuming, dusting, and sanitizing common areas.',120.00,3,2,'2024-11-07 05:09:05'),(5,'Retail Store Cleaning','Cleaning and organizing retail spaces, including sweeping, window cleaning, and bathroom sanitation.',130.00,3,2,'2024-11-07 05:09:05'),(6,'Warehouse Cleaning','Industrial-level cleaning of warehouses, including floor scrubbing, dust removal, and waste management.',180.00,5,2,'2024-11-07 05:09:05'),(7,'Carpet Cleaning','Deep cleaning of carpets using steam or dry-cleaning methods to remove stains and odors.',80.00,2,3,'2024-11-07 05:09:05'),(8,'Window Cleaning','Interior and exterior cleaning of windows, frames, and sills.',60.00,2,3,'2024-11-07 05:09:05'),(9,'Upholstery Cleaning','Cleaning and sanitizing of sofas, chairs, and other fabric furniture.',70.00,2,3,'2024-11-07 05:09:05'),(10,'Green House Cleaning','Residential cleaning using environmentally safe products and methods.',110.00,3,4,'2024-11-07 05:09:05'),(11,'Eco-Friendly Office Cleaning','Commercial cleaning with non-toxic and biodegradable products.',130.00,3,4,'2024-11-07 05:09:05'),(12,'Recycling Management','Assisting homes and offices with proper waste segregation and recycling processes.',50.00,1,4,'2024-11-07 05:09:05'),(13,'Debris Removal','Clearing construction sites of debris, dust, and leftover materials.',250.00,5,5,'2024-11-07 05:09:05'),(14,'Final Cleaning','Detailed cleaning of newly constructed or renovated spaces, including windows, floors, and fixtures.',300.00,6,5,'2024-11-07 05:09:05'),(15,'Rough Cleaning','Initial cleaning during the construction phase, focusing on removing larger debris and dust.',200.00,4,5,'2024-11-07 05:09:05'),(16,'Pre-Event Cleaning','Preparing event spaces by cleaning floors, setting up spaces, and sanitizing.',150.00,3,6,'2024-11-07 05:09:05'),(17,'Post-Event Cleaning','Cleaning up after events by removing trash, sweeping floors, and sanitizing restrooms.',170.00,3,6,'2024-11-07 05:09:05'),(18,'On-Site Event Cleaning','Continuous cleaning service during events, managing trash, and keeping the venue tidy.',200.00,4,6,'2024-11-07 05:09:05'),(19,'Daily Office Cleaning','Regular cleaning services that include trash removal, floor cleaning, and restroom sanitation.',100.00,2,7,'2024-11-07 05:09:05'),(20,'Restroom Sanitation','Regular cleaning, disinfecting, and restocking of restrooms in commercial or public spaces.',60.00,2,7,'2024-11-07 05:09:05'),(21,'Trash Removal and Recycling','Routine removal of garbage and recycling from commercial buildings or residential areas.',50.00,1,7,'2024-11-07 05:09:05'),(22,'Pressure Washing','Cleaning of exterior walls, driveways, and sidewalks using high-pressure water jets.',120.00,2,8,'2024-11-07 05:09:05'),(23,'Gutter Cleaning','Clearing and cleaning gutters to ensure proper drainage.',80.00,2,8,'2024-11-07 05:09:05'),(24,'Roof Cleaning','Removing dirt, debris, and mold from residential or commercial roofs.',150.00,3,8,'2024-11-07 05:09:05'),(25,'Home Disinfection','Using approved disinfectants to sanitize surfaces in homes, especially high-touch areas.',90.00,2,9,'2024-11-07 05:09:05'),(26,'Office Disinfection','Regular disinfection of workstations, desks, and shared spaces in offices.',100.00,2,9,'2024-11-07 05:09:05'),(27,'COVID-19 Cleaning','Deep sanitization focusing on preventing virus spread in homes or commercial areas.',120.00,3,9,'2024-11-07 05:09:05'),(28,'Hardwood Floor Polishing','Cleaning, polishing, and waxing hardwood floors to restore shine and durability.',140.00,3,10,'2024-11-07 05:09:05'),(29,'Tile and Grout Cleaning','Deep cleaning of tiles and grout to remove dirt, stains, and mold.',130.00,3,10,'2024-11-07 05:09:05'),(30,'Floor Stripping and Waxing','Removing old wax layers and applying new coats to protect and shine floors.',160.00,3,10,'2024-11-07 05:09:05'),(31,'Air Duct Cleaning','Cleaning and sanitizing air ducts to improve air quality and HVAC efficiency.',180.00,3,11,'2024-11-07 05:09:05'),(32,'Chimney Cleaning','Removal of soot and blockages from chimneys to ensure proper ventilation.',100.00,2,11,'2024-11-07 05:09:05'),(33,'Pool Cleaning','Cleaning and maintenance of residential or commercial swimming pools.',150.00,3,11,'2024-11-07 05:09:05'),(34,'Oven Cleaning','Removing grease, grime, and buildup from oven interiors.',70.00,2,12,'2024-11-07 05:09:05'),(35,'Refrigerator Cleaning','Emptying and sanitizing refrigerators, including shelves, drawers, and doors.',80.00,2,12,'2024-11-07 05:09:05'),(36,'Dishwasher Cleaning','Cleaning and descaling dishwashers to maintain efficiency.',60.00,1,12,'2024-11-07 05:09:05'),(37,'Turnover Cleaning','Quick and efficient cleaning between guests in vacation rentals (Airbnb, VRBO, etc.).',90.00,2,13,'2024-11-07 05:09:05'),(38,'Laundry Service','Washing and replacing linens and towels in vacation rentals.',40.00,1,13,'2024-11-07 05:09:05'),(39,'Stocking and Restocking Supplies','Refilling amenities like toiletries, cleaning supplies, and coffee for the next guest.',30.00,1,13,'2024-11-07 05:09:05'),(40,'Spring Cleaning','Intensive cleaning that covers every room and includes organizing, decluttering, and deep cleaning.',200.00,5,14,'2024-11-07 05:09:05'),(41,'Holiday Cleaning','Pre-holiday cleaning to prepare homes for guests or post-holiday cleanup to remove decorations and waste.',150.00,4,14,'2024-11-07 05:09:05'),(42,'Winter Cleaning','Specialized cleaning for homes during colder months, including snow removal and de-icing services.',170.00,4,14,'2024-11-07 05:09:05'),(43,'Pet Hair Removal','Thorough cleaning of carpets, furniture, and upholstery to remove pet hair.',60.00,2,15,'2024-11-07 05:09:05'),(44,'Odor Removal','Deodorizing spaces affected by pet odors, including deep cleaning carpets and fabrics.',80.00,2,15,'2024-11-07 05:09:05'),(45,'Litter Box Area Cleaning','Deep cleaning and sanitizing of areas where pets litter boxes or sleeping areas are located.',50.00,1,15,'2024-11-07 05:09:05');
/*!40000 ALTER TABLE `service` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `service_category`
--

DROP TABLE IF EXISTS `service_category`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
 SET character_set_client = utf8mb4 ;
CREATE TABLE `service_category` (
  `category_id` int(11) NOT NULL AUTO_INCREMENT,
  `category_name` varchar(100) NOT NULL,
  `description` text,
  PRIMARY KEY (`category_id`)
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `service_category`
--

LOCK TABLES `service_category` WRITE;
/*!40000 ALTER TABLE `service_category` DISABLE KEYS */;
INSERT INTO `service_category` VALUES (1,'Residential Cleaning','General and detailed cleaning services for homes, including standard, deep, and move-in/move-out options.'),(2,'Commercial Cleaning','Cleaning services tailored to offices, retail spaces, and warehouses, ensuring clean and organized work environments.'),(3,'Specialized Cleaning','Focused cleaning services for carpets, windows, and upholstery, designed to handle specific materials and surfaces.'),(4,'Eco-Friendly Cleaning','Cleaning services that use non-toxic and biodegradable products to minimize environmental impact.'),(5,'Post-Construction Cleaning','Comprehensive cleaning after construction, including debris removal, rough cleaning, and final touch-ups.'),(6,'Event Cleaning','Cleaning services for events, including pre-event setup, on-site cleaning during events, and post-event cleanup.'),(7,'Janitorial Services','Daily or regular cleaning and maintenance for offices and commercial spaces, including trash removal and restroom sanitation.'),(8,'Exterior Cleaning','Outdoor cleaning services like pressure washing, gutter cleaning, and roof cleaning for buildings.'),(9,'Disinfection Services','Specialized sanitization services for homes and offices, targeting high-touch surfaces and areas.'),(10,'Floor Care Services','Professional cleaning, polishing, and waxing for hardwood, tile, and other flooring types.'),(11,'Specialty Cleaning','Niche cleaning services, including air duct cleaning, chimney sweeping, and pool maintenance.'),(12,'Appliance Cleaning','Deep cleaning of household appliances such as ovens, refrigerators, and dishwashers to maintain efficiency.'),(13,'Vacation Rental Cleaning','Turnover cleaning for vacation rentals, including laundry and restocking for new guests.'),(14,'Seasonal Cleaning','Intensive cleaning for specific seasons, including spring cleaning, holiday preparation, and winter upkeep.'),(15,'Pet-Specific Cleaning','Cleaning services focused on pet-related areas, including hair and odor removal and litter box sanitation.');
/*!40000 ALTER TABLE `service_category` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user`
--

DROP TABLE IF EXISTS `user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
 SET character_set_client = utf8mb4 ;
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
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user`
--

LOCK TABLES `user` WRITE;
/*!40000 ALTER TABLE `user` DISABLE KEYS */;
INSERT INTO `user` VALUES (1,true,'a','a','admin@gmail.com','81136589','aaa','9834876dcfb05cb167a5c24953eba58c4ac89b1adf57f28f2f9d09af107ee8f0','2024-11-11 13:04:15'),(2,false,'a','a','jovanyeo.jyzr@gmail.com','81136589','aaa','9834876dcfb05cb167a5c24953eba58c4ac89b1adf57f28f2f9d09af107ee8f0','2024-11-11 13:04:15');
/*!40000 ALTER TABLE `user` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2024-11-13 22:01:18
