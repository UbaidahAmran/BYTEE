-- MySQL dump 10.13  Distrib 8.0.34, for Win64 (x86_64)
--
-- Host: localhost    Database: bytee_db
-- ------------------------------------------------------
-- Server version	8.0.35

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `announcements`
--

DROP TABLE IF EXISTS `announcements`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `announcements` (
  `announcement_id` int NOT NULL AUTO_INCREMENT,
  `title` varchar(100) NOT NULL,
  `message` text NOT NULL,
  `date_posted` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`announcement_id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `announcements`
--

LOCK TABLES `announcements` WRITE;
/*!40000 ALTER TABLE `announcements` DISABLE KEYS */;
INSERT INTO `announcements` VALUES (1,'Welcome to the New Semester!','We hope you have a great stay at KKSI. Please check your room inventory upon arrival.','2025-11-30 07:02:15'),(2,'Water Disruption Notice','There will be a scheduled water maintenance on Block A this Saturday from 10 AM to 2 PM.','2025-11-30 07:02:15'),(3,'Cafeteria Opening Hours','For Ramadan, the cafeteria will operate from 4 PM to 10 PM daily.','2025-11-30 07:02:15'),(5,'Java Presentation','ISNIN DEPAN','2026-01-02 03:37:25');
/*!40000 ALTER TABLE `announcements` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `colleges`
--

DROP TABLE IF EXISTS `colleges`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `colleges` (
  `college_id` varchar(50) NOT NULL,
  `name` varchar(100) DEFAULT NULL,
  `description` text,
  `main_image` varchar(255) DEFAULT NULL,
  `location` varchar(255) DEFAULT NULL,
  `lat_long` varchar(50) DEFAULT NULL,
  `view_360_url` varchar(255) DEFAULT NULL,
  `gender_restriction` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`college_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `colleges`
--

LOCK TABLES `colleges` WRITE;
/*!40000 ALTER TABLE `colleges` DISABLE KEYS */;
INSERT INTO `colleges` VALUES ('2af4b334','Kolej Kediaman Anggerik Court (KKAC)','KKAC is also an off-campus residential college often managed in conjunction with nearby residential facilities like Acacia Avenue. It provides additional apartment units for student accommodation in the Nilai area.','images/kkac.jpg','Persiaran Perbandaran, Taman Desa Anggerik, 71800 Nilai, Negeri Sembilan','2.838375, 101.786465','https://www.teleport360.app/share/503aae76-170e-4b90-a0e4-1745945fa611','Male'),('44b02973','Kolej Kediaman 1 (KK1)','KK1 is notable for being the only residential college located inside the USIM main campus in Nilai. It is often referred to as an \"on-campus\" college and provides essential facilities for students who live closest to the main academic buildings.','images/kk1.jpg','KOLEJ KEDIAMAN 1, 71800 Nilai, Negeri Sembilan, Malaysia','2.849466, 101.781148','https://www.teleport360.app/share/537349d7-4b2b-45bf-9457-06419e517bce','Female'),('7eeadd98','Kolej Kediaman Nilam Court (KKNC)','KKNC is an off-campus residential complex located near the main highway exit in Nilai. It is designated for female students only and is known for accommodating a large student capacity.','images/kknc.jpg','Nilai Impian, 71800 Nilai, Negeri Sembilan, Malaysia','2.844578, 101.810011','https://www.teleport360.app/share/b071d884-fbce-4188-83fc-c22994e8b3b5','Female'),('86930825','Kolej Kediaman Acasia Avenue (KKAA)','KKAA is an off-campus residential college that provides apartment-style accommodation for USIM students. It is known for its facilities that support a variety of planned student activities and programs.','images/kkaa.jpg','71800 Bandar Baru Nilai, Negeri Sembilan, Malaysia','2.841300, 101.787665','https://drive.google.com/file/d/1J1CK0ez8NON2vuk785kZ1-6f1lsDjyMq/view?usp=drive_link','Male'),('da2de169','Kolej Kediaman Sutera Indah (KKSI)','KKSI is an off-campus residential college located in Bandar Baru Nilai. It is known for providing a conducive living environment and is strategically located due to its proximity to commercial and business centres in the area, offering students easy access to amenities outside the campus.','images/kksi.jpg','Putra Point, 71800 Bandar Baru Nilai, Negeri Sembilan, Malaysia','2.821566, 101.792065','https://www.teleport360.app/share/25e6a024-082a-41b0-98e5-80059c2492d0','Male');
/*!40000 ALTER TABLE `colleges` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `complaints`
--

DROP TABLE IF EXISTS `complaints`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `complaints` (
  `complaint_id` varchar(50) NOT NULL,
  `user_id` varchar(50) DEFAULT NULL,
  `room_id` varchar(50) DEFAULT NULL,
  `category` varchar(50) DEFAULT NULL,
  `description` text,
  `image_path` varchar(255) DEFAULT NULL,
  `status` varchar(20) DEFAULT 'Pending',
  `date_filed` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`complaint_id`),
  KEY `user_id` (`user_id`),
  KEY `room_id` (`room_id`),
  CONSTRAINT `complaints_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`),
  CONSTRAINT `complaints_ibfk_2` FOREIGN KEY (`room_id`) REFERENCES `rooms` (`room_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `complaints`
--

LOCK TABLES `complaints` WRITE;
/*!40000 ALTER TABLE `complaints` DISABLE KEYS */;
/*!40000 ALTER TABLE `complaints` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `reservations`
--

DROP TABLE IF EXISTS `reservations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `reservations` (
  `reservation_id` int NOT NULL AUTO_INCREMENT,
  `user_id` varchar(50) DEFAULT NULL,
  `room_id` varchar(50) DEFAULT NULL,
  `booking_date` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `status` varchar(20) DEFAULT 'Confirmed',
  PRIMARY KEY (`reservation_id`),
  KEY `user_id` (`user_id`),
  KEY `room_id` (`room_id`),
  CONSTRAINT `reservations_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`),
  CONSTRAINT `reservations_ibfk_2` FOREIGN KEY (`room_id`) REFERENCES `rooms` (`room_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `reservations`
--

LOCK TABLES `reservations` WRITE;
/*!40000 ALTER TABLE `reservations` DISABLE KEYS */;
/*!40000 ALTER TABLE `reservations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `room_units`
--

DROP TABLE IF EXISTS `room_units`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `room_units` (
  `room_unit_id` varchar(50) NOT NULL,
  `college_id` varchar(50) DEFAULT NULL,
  `block` varchar(10) DEFAULT NULL,
  `level` int DEFAULT NULL,
  `room_number` varchar(20) DEFAULT NULL,
  `total_beds` int DEFAULT NULL,
  PRIMARY KEY (`room_unit_id`),
  KEY `college_id` (`college_id`),
  CONSTRAINT `room_units_ibfk_1` FOREIGN KEY (`college_id`) REFERENCES `colleges` (`college_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `room_units`
--

LOCK TABLES `room_units` WRITE;
/*!40000 ALTER TABLE `room_units` DISABLE KEYS */;
INSERT INTO `room_units` VALUES ('0013bcce','2af4b334','D',1,'D-1-3',2),('01db92f2','2af4b334','C',1,'C-1-1',2),('03812af9','da2de169','A',2,'A-2-1',2),('056fee02','44b02973','C',1,'C-1-3',3),('0ba435f7','2af4b334','B',3,'B-3-3',2),('0c9dc625','da2de169','B',2,'B-2-1',2),('0ec94992','86930825','B',2,'B-2-1',1),('0ed3e252','da2de169','C',2,'C-2-1',2),('0f459aa9','44b02973','A',2,'A-2-2',3),('12ecaae7','7eeadd98','A',2,'A-2-2',3),('138eab40','7eeadd98','D',2,'D-2-2',3),('13c5f2fc','2af4b334','C',3,'C-3-1',2),('1408ec26','da2de169','B',3,'B-3-3',2),('15485cf1','7eeadd98','C',2,'C-2-1',3),('15986652','86930825','C',3,'C-3-3',1),('1614cd7d','da2de169','D',2,'D-2-1',2),('166bf208','44b02973','B',2,'B-2-2',3),('1688c09e','2af4b334','A',3,'A-3-2',2),('17d3c15b','7eeadd98','B',1,'B-1-3',3),('1e4df6c4','44b02973','A',2,'A-2-1',3),('2194d57b','da2de169','B',1,'B-1-1',2),('22f03c84','da2de169','C',1,'C-1-1',2),('252b81a2','7eeadd98','B',1,'B-1-2',3),('25d9bf7a','44b02973','B',3,'B-3-1',3),('260aa7a0','44b02973','D',2,'D-2-1',3),('270607b2','7eeadd98','B',3,'B-3-1',3),('27644cff','7eeadd98','D',2,'D-2-3',3),('289bc130','2af4b334','B',3,'B-3-1',2),('28b58e68','86930825','C',3,'C-3-2',1),('28bd3399','da2de169','D',1,'D-1-3',2),('28bf6275','44b02973','D',1,'D-1-2',3),('2a8b9f05','2af4b334','B',2,'B-2-3',2),('2c26c413','da2de169','D',1,'D-1-2',2),('2da9a80e','da2de169','B',1,'B-1-3',2),('2e235d22','7eeadd98','A',2,'A-2-1',3),('2e8979ad','2af4b334','C',2,'C-2-2',2),('2f8b138e','7eeadd98','C',2,'C-2-3',3),('30c82afe','86930825','D',3,'D-3-2',2),('3105a1e8','da2de169','D',3,'D-3-3',2),('31813981','86930825','C',2,'C-2-3',1),('33702817','7eeadd98','A',3,'A-3-3',3),('3ad5ce34','86930825','D',2,'D-2-2',2),('3bdd85d4','7eeadd98','B',1,'B-1-1',3),('3cfd6d24','7eeadd98','B',2,'B-2-1',3),('3f8d3128','da2de169','B',1,'B-1-2',2),('42c3f915','44b02973','D',3,'D-3-3',3),('434458dc','da2de169','B',2,'B-2-2',2),('436529fd','2af4b334','A',1,'A-1-1',2),('4429e62e','da2de169','B',2,'B-2-3',2),('45950cae','2af4b334','B',1,'B-1-1',2),('48b4d5ca','86930825','A',1,'A-1-4',2),('4a47fa31','2af4b334','A',3,'A-3-1',2),('4bde9488','da2de169','A',3,'A-3-1',2),('4ddc816d','da2de169','A',2,'A-2-3',2),('4e9888f3','2af4b334','D',2,'D-2-1',2),('4ebae1bb','44b02973','A',2,'A-2-3',3),('4f17634c','44b02973','C',2,'C-2-1',3),('520c8452','da2de169','A',3,'A-3-2',2),('558f6e59','86930825','A',1,'A-1-1',2),('570e9b64','7eeadd98','D',3,'D-3-2',3),('57dd29fa','86930825','B',3,'B-3-3',1),('5aeffdec','2af4b334','C',2,'C-2-1',2),('5b90e61e','86930825','B',2,'B-2-3',1),('5c9612eb','86930825','A',2,'A-2-1',2),('5e2ea7d7','7eeadd98','B',3,'B-3-2',3),('5f3dfd3f','7eeadd98','C',3,'C-3-2',3),('5fdebebc','2af4b334','A',2,'A-2-3',2),('6094853e','7eeadd98','D',1,'D-1-3',3),('611a6a46','7eeadd98','C',3,'C-3-1',3),('6499d9f1','da2de169','D',3,'D-3-1',2),('650382fd','44b02973','C',1,'C-1-1',3),('667fbdb2','7eeadd98','D',1,'D-1-1',3),('6737c47c','86930825','D',1,'D-1-1',2),('69448bc1','da2de169','A',1,'A-1-2',2),('69dfa882','44b02973','D',1,'D-1-1',3),('6b6d1676','44b02973','A',3,'A-3-2',3),('6b9f9d10','86930825','B',1,'B-1-1',1),('6c2f120a','da2de169','B',3,'B-3-1',2),('6dd39cad-31dd-485e-a24a-4b539252c96d','44b02973','A',1,'1',NULL),('6ecd63ff','86930825','C',2,'C-2-2',1),('73c72ab8','da2de169','C',1,'C-1-2',2),('75f90af0','86930825','D',1,'D-1-2',2),('769f2018','86930825','B',1,'B-1-2',1),('76b406b1','44b02973','B',3,'B-3-3',3),('7933a0e1','7eeadd98','A',3,'A-3-2',3),('7b0fbb35','7eeadd98','B',3,'B-3-3',3),('7bead7c3','2af4b334','B',2,'B-2-2',2),('7dba1374','7eeadd98','A',1,'A-1-2',3),('7e65ed02','7eeadd98','A',2,'A-2-3',3),('84ae4ecb','da2de169','A',2,'A-2-2',2),('874025b6','da2de169','C',3,'C-3-3',2),('886db12a','2af4b334','A',2,'A-2-1',2),('88913645','44b02973','C',2,'C-2-2',3),('88ade80d','2af4b334','D',1,'D-1-1',2),('89296019','2af4b334','A',2,'A-2-2',2),('8a8b7988','2af4b334','B',1,'B-1-3',2),('8dd012d0','7eeadd98','A',1,'A-1-3',3),('8fb50e27','7eeadd98','A',1,'A-1-1',3),('8fcb3cc0','da2de169','D',2,'D-2-3',2),('9218a495','86930825','C',2,'C-2-1',1),('975b8404','da2de169','A',1,'A-1-1',2),('97a0c017','86930825','B',3,'B-3-1',1),('97f0c6a7','86930825','A',3,'A-3-2',2),('988cc5fa','44b02973','D',3,'D-3-2',3),('9a101819','44b02973','C',3,'C-3-2',3),('9ab5f016','86930825','D',2,'D-2-1',2),('9baa2c9a','44b02973','D',2,'D-2-2',3),('9c81eaa8','86930825','A',1,'A-1-3',2),('9ceaf6f1','2af4b334','C',3,'C-3-2',2),('9d594b0b','44b02973','C',1,'C-1-2',3),('9dd21868','44b02973','A',3,'A-3-1',3),('9dfb40e8','2af4b334','C',1,'C-1-2',2),('9fb47487','86930825','C',1,'C-1-1',1),('a08c12d1','86930825','B',3,'B-3-2',1),('a2df791e','86930825','A',2,'A-2-2',2),('a2e6708e','44b02973','B',2,'B-2-1',3),('a348992f','da2de169','C',3,'C-3-2',2),('a4254806','2af4b334','A',3,'A-3-3',2),('a65fe078','86930825','C',1,'C-1-3',1),('a67a55ea','7eeadd98','C',1,'C-1-3',3),('a7bc3204','2af4b334','D',1,'D-1-2',2),('a834a7c0','7eeadd98','D',3,'D-3-1',3),('a88d47ec','2af4b334','D',2,'D-2-3',2),('a9d6be7b','da2de169','A',1,'A-1-3',2),('ac2c8504','44b02973','B',1,'B-1-1',3),('b0534383','86930825','D',1,'D-1-3',2),('b1e178c8','44b02973','D',2,'D-2-3',3),('b1e76196','7eeadd98','C',2,'C-2-2',3),('b28f4a80','86930825','A',2,'A-2-3',2),('b2db79bb','2af4b334','D',3,'D-3-1',2),('b536620f','86930825','D',3,'D-3-1',2),('b86ca1fc','86930825','A',1,'A-1-2',2),('b8ede1e9','44b02973','C',3,'C-3-1',3),('b93db6f6','7eeadd98','B',2,'B-2-3',3),('ba35e610','44b02973','A',1,'A-1-1',3),('ba40882c','2af4b334','C',2,'C-2-3',2),('bccb504f','7eeadd98','D',2,'D-2-1',3),('bd5c0e62','44b02973','D',3,'D-3-1',3),('bf4a118f','44b02973','D',1,'D-1-3',3),('bf6aead5','86930825','D',2,'D-2-3',2),('c2b9e1ab','2af4b334','A',1,'A-1-2',2),('c614e495','44b02973','B',3,'B-3-2',3),('c72135b6','da2de169','D',3,'D-3-2',2),('cb1ede70','7eeadd98','C',1,'C-1-1',3),('cbac9a51','2af4b334','B',2,'B-2-1',2),('ce6c8b2e','da2de169','C',3,'C-3-1',2),('d2e96df2','2af4b334','B',1,'B-1-2',2),('d531be2d','7eeadd98','A',3,'A-3-1',3),('d5b56b58','da2de169','C',2,'C-2-3',2),('d70f0c3a','86930825','A',3,'A-3-1',2),('d72057fc','2af4b334','B',3,'B-3-2',2),('d8712d50','86930825','C',1,'C-1-2',1),('d88564f2','44b02973','A',1,'A-1-3',3),('d91a7fd8','86930825','C',3,'C-3-1',1),('d9d91d3e','86930825','B',1,'B-1-4',1),('dbfd7b6a','2af4b334','D',3,'D-3-2',2),('de0c940c','86930825','B',2,'B-2-2',1),('dec36c81','7eeadd98','C',1,'C-1-2',3),('e1bc0faf','44b02973','A',1,'A-1-2',3),('e1c0f319','da2de169','A',3,'A-3-3',2),('e2253ae0','da2de169','B',3,'B-3-2',2),('e438a521','da2de169','D',2,'D-2-2',2),('e5a96d64','44b02973','C',2,'C-2-3',3),('e7132032','2af4b334','C',1,'C-1-3',2),('e814430a','da2de169','D',1,'D-1-1',2),('eaa064b7','2af4b334','A',1,'A-1-3',2),('ebaaa80a','44b02973','B',1,'B-1-3',3),('ed472554','da2de169','C',2,'C-2-2',2),('eded5551','86930825','B',1,'B-1-3',1),('f010d997','86930825','D',3,'D-3-3',2),('f12943c6','44b02973','B',1,'B-1-2',3),('f153ba35','44b02973','B',2,'B-2-3',3),('f196f42c','7eeadd98','C',3,'C-3-3',3),('f8d253a2','7eeadd98','B',2,'B-2-2',3),('f8fb2893','2af4b334','D',3,'D-3-3',2),('fa74ab22','2af4b334','D',2,'D-2-2',2),('fd5d99b0','7eeadd98','D',3,'D-3-3',3),('fe0d4ff9','7eeadd98','D',1,'D-1-2',3),('ff6e6ef5','da2de169','C',1,'C-1-3',2);
/*!40000 ALTER TABLE `room_units` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `rooms`
--

DROP TABLE IF EXISTS `rooms`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `rooms` (
  `room_id` varchar(50) NOT NULL,
  `room_unit_id` varchar(50) DEFAULT NULL,
  `bed_number` varchar(50) DEFAULT NULL,
  `status` varchar(20) DEFAULT NULL,
  `occupant_id` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`room_id`),
  KEY `room_unit_id` (`room_unit_id`),
  CONSTRAINT `rooms_ibfk_1` FOREIGN KEY (`room_unit_id`) REFERENCES `room_units` (`room_unit_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `rooms`
--

LOCK TABLES `rooms` WRITE;
/*!40000 ALTER TABLE `rooms` DISABLE KEYS */;
INSERT INTO `rooms` VALUES ('00ba69ac','97f0c6a7','Single Bed (1)','Available',NULL),('03fd3574','6094853e','Double Decker (Upper)','Available',''),('048b654c','f010d997','Single Bed (1)','Available',''),('05ce2620','6737c47c','Single Bed (1)','Available',''),('0665469b','1e4df6c4','Single Bed','Available',''),('075c2d7f','2f8b138e','Double Decker (Upper)','Available',''),('079ee7b3','a348992f','Single Bed (2)','Available',''),('086ee153','fd5d99b0','Double Decker (Lower)','Available',''),('0918473a','0ed3e252','Single Bed (2)','Available',''),('09b0f3fa','a4254806','Single Bed (1)','Available',''),('09d5b8b7','1688c09e','Single Bed (2)','Available',''),('0aa98a9d','a9d6be7b','Single Bed (1)','Available',''),('0aba067c','2194d57b','Single Bed (1)','Available',''),('0b7abff7','13c5f2fc','Single Bed (2)','Available',''),('0b7da301','88913645','Double Decker (Upper)','Available',''),('0bc96be2','cbac9a51','Single Bed (2)','Available',''),('0c60b6f4','988cc5fa','Double Decker (Upper)','Available',''),('0c6b425c','c72135b6','Single Bed (2)','Available',NULL),('0c93ed8a','650382fd','Single Bed','Available',''),('0cbc15c4','166bf208','Double Decker (Upper)','Available',''),('104340a9','9c81eaa8','Single Bed (2)','Available',''),('106fce45','cb1ede70','Double Decker (Lower)','Available',''),('1092bdc4','4f17634c','Single Bed','Available',''),('109c2e8b','ce6c8b2e','Single Bed (2)','Available',''),('10b62fe9','28bf6275','Single Bed','Available',''),('10e1fafd','d2e96df2','Single Bed (2)','Available',''),('11456ef4','3bdd85d4','Double Decker (Lower)','Available',''),('137d5cfc','4f17634c','Double Decker (Upper)','Available',''),('13cbe822','7b0fbb35','Double Decker (Lower)','Available',''),('145d568d','7b0fbb35','Double Decker (Upper)','Available',''),('154988f7','f153ba35','Double Decker (Upper)','Available',''),('15afab52','27644cff','Single Bed','Available',''),('1607b334','4429e62e','Single Bed (1)','Available',''),('162440a1','ac2c8504','Single Bed','Available',''),('16adde0d','570e9b64','Single Bed','Available',''),('17a6ea3b','2a8b9f05','Single Bed (1)','Available',''),('18170314','166bf208','Single Bed','Available',''),('18bb79ae','cbac9a51','Single Bed (1)','Available',''),('19c02290','4ebae1bb','Double Decker (Lower)','Available',''),('19caf566','b8ede1e9','Double Decker (Lower)','Available',''),('1a776cb7','b2db79bb','Single Bed (1)','Available',''),('1ace6079','260aa7a0','Single Bed','Available',''),('1b95ac74','84ae4ecb','Single Bed (2)','Available',''),('1b9f1d66','f8fb2893','Single Bed (1)','Available',''),('1ba9b509','5f3dfd3f','Single Bed','Available',''),('1eef186a','9baa2c9a','Double Decker (Upper)','Available',''),('1ff1d962','a834a7c0','Single Bed','Available',''),('20b8299b','9d594b0b','Single Bed','Available',''),('220aa32f','a2e6708e','Double Decker (Lower)','Available',''),('223a13ef','ff6e6ef5','Single Bed (1)','Available',''),('230c73b6','de0c940c','Single Bed','Available',''),('23fb6ef2','75f90af0','Single Bed (2)','Available',''),('25aa87d5','30c82afe','Single Bed (2)','Available',''),('25e91bef','138eab40','Double Decker (Upper)','Available',''),('26d31666','a2e6708e','Double Decker (Upper)','Available',''),('27940b8f','0ed3e252','Single Bed (1)','Available',''),('2825c81e','bf4a118f','Single Bed','Available',''),('28464b8d','9218a495','Single Bed','Available',''),('289c87f7','5c9612eb','Single Bed (2)','Available',''),('28e3520b','b93db6f6','Double Decker (Upper)','Available',''),('2b29701e','bd5c0e62','Double Decker (Upper)','Available',''),('2d1d7ebb','76b406b1','Double Decker (Upper)','Available',''),('2df4320c','874025b6','Single Bed (2)','Available',''),('2ec63662','2194d57b','Single Bed (2)','Available',''),('2edad988','886db12a','Single Bed (1)','Available',''),('2f1df861','9dfb40e8','Single Bed (1)','Available',''),('2f28a749','f12943c6','Single Bed','Available',''),('2fdec49d','88913645','Single Bed','Available',''),('30321067','eaa064b7','Single Bed (1)','Available',''),('308c534a','1e4df6c4','Double Decker (Upper)','Available',''),('30d6b7e2','f196f42c','Double Decker (Lower)','Available',''),('30dc8a88','28bd3399','Single Bed (2)','Available',''),('31dfa9f6','a4254806','Single Bed (2)','Available',''),('335b4897','4ebae1bb','Double Decker (Upper)','Available',''),('33706b23-567f-48de-bf53-65d94aafe785','ba35e610','Single Bed (1)','Available',NULL),('33d06bb0','e2253ae0','Single Bed (1)','Available',''),('36c3350d','6737c47c','Single Bed (2)','Available',''),('36d6adb1','28bd3399','Single Bed (1)','Available',''),('373da58b','a9d6be7b','Single Bed (2)','Available',''),('393d8e27','bf4a118f','Double Decker (Upper)','Available',''),('395f415d','1408ec26','Single Bed (1)','Available',''),('39d39301','a08c12d1','Single Bed','Available',''),('39ef1851','e1c0f319','Single Bed (1)','Available',''),('3aaadbbb','a88d47ec','Single Bed (1)','Available',''),('3ba7dfe5','33702817','Double Decker (Lower)','Available',''),('3bb4bcd2','5fdebebc','Single Bed (2)','Available',''),('3bcf8e01','d91a7fd8','Single Bed','Available',''),('3bd056e9','c614e495','Double Decker (Upper)','Available',''),('3bde8bef','9a101819','Double Decker (Upper)','Available',''),('3bfed9ce','9dd21868','Double Decker (Upper)','Available',''),('3c1f5efd','e814430a','Single Bed (2)','Available',''),('3c636735','3ad5ce34','Single Bed (1)','Available',''),('3d5b86d8','13c5f2fc','Single Bed (1)','Available',''),('3dbc663f','fe0d4ff9','Double Decker (Upper)','Available',''),('3ec425c0','9dfb40e8','Single Bed (2)','Available',''),('3f8db37a','76b406b1','Single Bed','Available',''),('41f28b2b','a348992f','Single Bed (1)','Available',''),('44ba4774','436529fd','Single Bed (1)','Available',NULL),('44fb3b67','c72135b6','Single Bed (1)','Available',''),('46cdcd17','28bf6275','Double Decker (Upper)','Available',''),('4716134d','d9d91d3e','Single Bed','Available',''),('47fefdf9','9ab5f016','Single Bed (2)','Available',''),('490f0a80','2a8b9f05','Single Bed (2)','Available',''),('491ec818','6499d9f1','Single Bed (1)','Available',''),('49c0b9b8','a65fe078','Single Bed','Available',''),('49fdabfa','27644cff','Double Decker (Upper)','Available',''),('4a45ed05','4ebae1bb','Single Bed','Available',''),('4bad0a1a','ebaaa80a','Single Bed','Available',''),('4bc1678e','15485cf1','Double Decker (Upper)','Available',''),('4c35af11','dbfd7b6a','Single Bed (1)','Available',''),('4d5c6bcf','9d594b0b','Double Decker (Lower)','Available',''),('4e0d03cd','9c81eaa8','Single Bed (1)','Available',''),('4eb2ba30','1614cd7d','Single Bed (1)','Available',''),('50b85a6b','eded5551','Single Bed','Available',''),('5145918c','cb1ede70','Double Decker (Upper)','Available',''),('51c84cc9','270607b2','Single Bed','Available',''),('51de7678','f196f42c','Single Bed','Available',''),('5287ce32','84ae4ecb','Single Bed (1)','Available',''),('52f8904c','3ad5ce34','Single Bed (2)','Available',''),('5301407f','fa74ab22','Single Bed (2)','Available',''),('5311d3dc','8dd012d0','Single Bed','Available',''),('536b88e1','1408ec26','Single Bed (2)','Available',''),('538532fb','0f459aa9','Double Decker (Lower)','Available',''),('56dcf0c3','b86ca1fc','Single Bed (2)','Available',''),('570ed49e','bccb504f','Double Decker (Upper)','Available',''),('57b612dd','17d3c15b','Double Decker (Lower)','Available',''),('588d54c4','b0534383','Single Bed (2)','Available',''),('59a99da8','bf6aead5','Single Bed (1)','Available',''),('5a2f9115','0ba435f7','Single Bed (2)','Available',''),('5b8799a5','9a101819','Single Bed','Available',''),('5bf29d07','570e9b64','Double Decker (Lower)','Available',''),('5c3f28ce','b93db6f6','Double Decker (Lower)','Available',''),('5c541f9a','ba35e610','Double Decker (Upper)','Available',NULL),('5d6e28d8','667fbdb2','Double Decker (Upper)','Available',''),('5dc5220f','667fbdb2','Double Decker (Lower)','Available',''),('5e58b0d2','9d594b0b','Double Decker (Upper)','Available',''),('5e7cef18','d72057fc','Single Bed (2)','Available',''),('5f745be3','056fee02','Double Decker (Lower)','Available',''),('5f91eade','69448bc1','Single Bed (1)','Available',''),('60b95766','8dd012d0','Double Decker (Lower)','Available',''),('60c0e169','45950cae','Single Bed (1)','Available',NULL),('61183fbf','b1e76196','Double Decker (Upper)','Available',''),('62839cb8','8a8b7988','Single Bed (1)','Available',''),('6354c523','15485cf1','Double Decker (Lower)','Available',''),('648cbd8c','8fb50e27','Double Decker (Lower)','Available',''),('66215c60','b28f4a80','Single Bed (2)','Available',''),('66aa1610','9ab5f016','Single Bed (1)','Available',''),('68333f42','15485cf1','Single Bed','Available',''),('6976bef5','a834a7c0','Double Decker (Lower)','Available',''),('6bbf5215','5e2ea7d7','Single Bed','Available',''),('6c17ef73','e5a96d64','Double Decker (Upper)','Available',''),('6c3ffc59','9baa2c9a','Single Bed','Available',''),('6cc5a186','6ecd63ff','Single Bed','Available',''),('6cfb5a56','42c3f915','Single Bed','Available',''),('6e4a8edf','434458dc','Single Bed (2)','Available',''),('6f213eed','166bf208','Double Decker (Lower)','Available',''),('6f4b85ff','056fee02','Single Bed','Available',''),('70e69eb2','03812af9','Single Bed (1)','Available',''),('71b9a293','0c9dc625','Single Bed (1)','Available',''),('71c49e11','e5a96d64','Single Bed','Available',''),('73632041','667fbdb2','Single Bed','Available',''),('742433c1','2e235d22','Double Decker (Upper)','Available',''),('746f4b10','3cfd6d24','Double Decker (Lower)','Available',''),('7507f4ed','ac2c8504','Double Decker (Upper)','Available',''),('76199b4c','bd5c0e62','Double Decker (Lower)','Available',''),('769c93d4','28bf6275','Double Decker (Lower)','Available',''),('76e31a65','7bead7c3','Single Bed (1)','Available',''),('7798d6d2','e1bc0faf','Single Bed','Available',''),('781258c6','ba40882c','Single Bed (2)','Available',''),('782048a5','e7132032','Single Bed (1)','Available',''),('783bb72c','4e9888f3','Single Bed (2)','Available',''),('79d146aa','e7132032','Single Bed (2)','Available',''),('7a982071','5c9612eb','Single Bed (1)','Available',''),('7ad1a34a','b0534383','Single Bed (1)','Available',''),('7aeb11ec','d5b56b58','Single Bed (2)','Available',''),('7b348601','988cc5fa','Double Decker (Lower)','Available',''),('7c31525f','f153ba35','Single Bed','Available',''),('7c71354e','9a101819','Double Decker (Lower)','Available',''),('7d7623ae','22f03c84','Single Bed (1)','Available',''),('7ed6b7b3','88ade80d','Single Bed (1)','Available',''),('7f2f9d6b','8fb50e27','Single Bed','Available',''),('7f387955','5f3dfd3f','Double Decker (Lower)','Available',''),('7faa366f','e438a521','Single Bed (2)','Available',''),('805d0b94','dec36c81','Single Bed','Available',''),('83dbe77b','ebaaa80a','Double Decker (Upper)','Available',''),('8448847d','fd5d99b0','Double Decker (Upper)','Available',''),('84aa44ca','b536620f','Single Bed (2)','Available',''),('86fbfc18','0013bcce','Single Bed (1)','Available',''),('8732def0','6094853e','Single Bed','Available',''),('874d22b1','289bc130','Single Bed (1)','Available',''),('88553a2b','5f3dfd3f','Double Decker (Upper)','Available',''),('88ac59c0','7933a0e1','Double Decker (Upper)','Available',''),('88d8b066','558f6e59','Single Bed (1)','Available',''),('88ee4205','ed472554','Single Bed (2)','Available',''),('89ad30bb','fa74ab22','Single Bed (1)','Available',''),('8a125a06','3f8d3128','Single Bed (1)','Available',''),('8b1057e1','4a47fa31','Single Bed (1)','Available',''),('8c6eede5','25d9bf7a','Double Decker (Lower)','Available',''),('8d0ff913','252b81a2','Single Bed','Available',''),('8d35f109','7e65ed02','Single Bed','Available',''),('8d7c8b13','4ddc816d','Single Bed (2)','Available',''),('8ec9350e','252b81a2','Double Decker (Lower)','Available',''),('8ed349f8','886db12a','Single Bed (2)','Available',''),('90beac58','9ceaf6f1','Single Bed (2)','Available',''),('90e718ad','d70f0c3a','Single Bed (2)','Available',''),('912827f2','73c72ab8','Single Bed (2)','Available',''),('9254ffec','260aa7a0','Double Decker (Upper)','Available',''),('926adaa1','ba40882c','Single Bed (1)','Available',''),('92c70bf7','f8d253a2','Double Decker (Upper)','Available',''),('939ac90a','6b9f9d10','Single Bed','Available',''),('949c75ae','a7bc3204','Single Bed (1)','Available',''),('96362104','611a6a46','Double Decker (Lower)','Available',''),('970099da','15986652','Single Bed','Available',''),('97b0b033','2da9a80e','Single Bed (2)','Available',''),('97dece3d','8dd012d0','Double Decker (Upper)','Available',''),('98731168','fd5d99b0','Single Bed','Available',''),('9888f5c9','f8d253a2','Single Bed','Available',''),('9933547b','b28f4a80','Single Bed (1)','Available',''),('9981942d','0f459aa9','Double Decker (Upper)','Available',''),('99954e7a','2f8b138e','Double Decker (Lower)','Available',''),('9a7e5b2e','5aeffdec','Single Bed (1)','Available',''),('9b712f0c','3105a1e8','Single Bed (1)','Available',''),('9b843924','0f459aa9','Single Bed','Available',''),('9bfa150c','2e8979ad','Single Bed (1)','Available',''),('9c67a8f4','975b8404','Single Bed (2)','Available',''),('9d60091b','769f2018','Single Bed','Available',''),('9dc18167','6499d9f1','Single Bed (2)','Available',''),('9e6aee21','7bead7c3','Single Bed (2)','Available',''),('9eac858b','dec36c81','Double Decker (Lower)','Available',''),('9ef4b0ba','d70f0c3a','Single Bed (1)','Available',''),('9fe2fefa','d5b56b58','Single Bed (1)','Available',''),('a11033f6','9dd21868','Double Decker (Lower)','Available',''),('a13e7d1f','a67a55ea','Double Decker (Lower)','Available',''),('a1b4eea4','b2db79bb','Single Bed (2)','Available',''),('a20f5e84','6094853e','Double Decker (Lower)','Available',''),('a23c195e','b8ede1e9','Double Decker (Upper)','Available',''),('a25debf5','e438a521','Single Bed (1)','Available',''),('a2732571','7e65ed02','Double Decker (Upper)','Available',''),('a29c6705','434458dc','Single Bed (1)','Available',''),('a4ce726f','2c26c413','Single Bed (1)','Available',''),('a4e52415','89296019','Single Bed (2)','Available',''),('a53428db','dbfd7b6a','Single Bed (2)','Available',''),('a547000d','874025b6','Single Bed (1)','Available',''),('a60a8370','25d9bf7a','Single Bed','Available',''),('a703ab8c','89296019','Single Bed (1)','Available',''),('a71d0162','1614cd7d','Single Bed (2)','Available',''),('a8e30ee5','ff6e6ef5','Single Bed (2)','Available',''),('a92cd30a','c614e495','Single Bed','Available',''),('aac89a34','6b6d1676','Double Decker (Lower)','Available',''),('abe0fd71','fe0d4ff9','Single Bed','Available',''),('abed08fe','69dfa882','Double Decker (Upper)','Available',''),('ac3486fa','28b58e68','Single Bed','Available',''),('acb68bb3','69dfa882','Single Bed','Available',''),('accdd59e','bd5c0e62','Single Bed','Available',''),('acd5d394','33702817','Double Decker (Upper)','Available',''),('acf1b3dc','9fb47487','Single Bed','Available',''),('ad8dacb4','d88564f2','Double Decker (Lower)','Available',''),('adce60c4','3cfd6d24','Double Decker (Upper)','Available',''),('adf88be7','eaa064b7','Single Bed (2)','Available',''),('ae0da6bd','436529fd','Single Bed (2)','Available',''),('ae8e8924','2f8b138e','Single Bed','Available',''),('af6d5514','5e2ea7d7','Double Decker (Lower)','Available',''),('afb7b9b1','dec36c81','Double Decker (Upper)','Available',''),('b04ed987','7dba1374','Double Decker (Lower)','Available',''),('b0d27a14','4ddc816d','Single Bed (1)','Available',''),('b11bd481','611a6a46','Single Bed','Available',''),('b15d4e6b','2da9a80e','Single Bed (1)','Available',''),('b182ce6a','57dd29fa','Single Bed','Available',''),('b1a784dc','252b81a2','Double Decker (Upper)','Available',''),('b21b95db','b86ca1fc','Single Bed (1)','Available',''),('b278fd49','8a8b7988','Single Bed (2)','Available',''),('b2b7e599','31813981','Single Bed','Available',''),('b2f69940','2c26c413','Single Bed (2)','Available',''),('b30886a6','ac2c8504','Double Decker (Lower)','Available',''),('b3178b89','520c8452','Single Bed (2)','Available',''),('b358841b','48b4d5ca','Single Bed (1)','Available',''),('b3c29f4a','5e2ea7d7','Double Decker (Upper)','Available',''),('b5db658a','1688c09e','Single Bed (1)','Available',''),('b6966ce0','d72057fc','Single Bed (1)','Available',''),('b82a9104','9dd21868','Single Bed','Available',''),('b88a5223','f010d997','Single Bed (2)','Available',''),('b90ee530','9ceaf6f1','Single Bed (1)','Available',''),('b991874e','75f90af0','Single Bed (1)','Available',''),('bb33198d','0ba435f7','Single Bed (1)','Available',''),('bc6d5388','138eab40','Double Decker (Lower)','Available',''),('bcdbe1f7','27644cff','Double Decker (Lower)','Available',''),('bd2438c5','7933a0e1','Double Decker (Lower)','Available',''),('bfa92405','975b8404','Single Bed (1)','Available',NULL),('bfe59357','a2df791e','Single Bed (1)','Available',''),('c07046f4','a834a7c0','Double Decker (Upper)','Available',''),('c208e48b','d2e96df2','Single Bed (1)','Available',''),('c22a8272','48b4d5ca','Single Bed (2)','Available',''),('c234fdfc','270607b2','Double Decker (Lower)','Available',''),('c238e0db','5b90e61e','Single Bed','Available',''),('c2ad315a','ed472554','Single Bed (1)','Available',''),('c2d4ed11','0013bcce','Single Bed (2)','Available',''),('c337d0cc','f12943c6','Double Decker (Upper)','Available',''),('c38f8321','8fb50e27','Double Decker (Upper)','Available',''),('c4582690','270607b2','Double Decker (Upper)','Available',''),('c4a413da','4429e62e','Single Bed (2)','Available',''),('c4fd5051','d88564f2','Double Decker (Upper)','Available',''),('c69089a1','ce6c8b2e','Single Bed (1)','Available',''),('c7b316eb','f8d253a2','Double Decker (Lower)','Available',''),('c89987f4','289bc130','Single Bed (2)','Available',''),('c963683d','b1e178c8','Single Bed','Available',''),('c97ec559','7933a0e1','Single Bed','Available',''),('caa61755','01db92f2','Single Bed (2)','Available',''),('cbee1e3b','03812af9','Single Bed (2)','Available',''),('cc6abe6f','33702817','Single Bed','Available',''),('ccdcc777','2e235d22','Single Bed','Available',''),('cd048d47','42c3f915','Double Decker (Upper)','Available',''),('cd8b13eb','a67a55ea','Double Decker (Upper)','Available',''),('ce0dfd8b','c2b9e1ab','Single Bed (1)','Available',''),('cf254dbe','c2b9e1ab','Single Bed (2)','Available',''),('d18bd87f','22f03c84','Single Bed (2)','Available',''),('d1e21df1','570e9b64','Double Decker (Upper)','Available',''),('d2496e2a','5fdebebc','Single Bed (1)','Available',''),('d2833dc8','76b406b1','Double Decker (Lower)','Available',''),('d3311da0','6b6d1676','Single Bed','Available',''),('d3bd2a71','bf4a118f','Double Decker (Lower)','Available',''),('d4224e85','138eab40','Single Bed','Available',''),('d59a1166','12ecaae7','Double Decker (Lower)','Available',''),('d615f9da','7e65ed02','Double Decker (Lower)','Available',''),('d7b6e973','d531be2d','Single Bed','Available',''),('d7ce05aa','4bde9488','Single Bed (2)','Available',''),('d84659c1','12ecaae7','Single Bed','Available',''),('d8e821b3','4f17634c','Double Decker (Lower)','Available',''),('d8f55832','a67a55ea','Single Bed','Available',''),('d90d504a','2e235d22','Double Decker (Lower)','Available',''),('d937170f','d531be2d','Double Decker (Lower)','Available',''),('da1cd0a6','4e9888f3','Single Bed (1)','Available',''),('dacb37fb','97f0c6a7','Single Bed (2)','Available',''),('dafd9141','ebaaa80a','Double Decker (Lower)','Available',''),('db4c8888','e814430a','Single Bed (1)','Available',''),('db99a284','7dba1374','Double Decker (Upper)','Available',''),('dc254be8','3f8d3128','Single Bed (2)','Available',''),('dc57a40d','7dba1374','Single Bed','Available',''),('dcb285e5','d88564f2','Single Bed','Available',''),('dd11b0ae','88ade80d','Single Bed (2)','Available',''),('dd632afe','69dfa882','Double Decker (Lower)','Available',''),('dd642530','b1e76196','Single Bed','Available',''),('dd9fbc61','520c8452','Single Bed (1)','Available',''),('de6413f3','e1bc0faf','Double Decker (Lower)','Available',''),('df6ecf64','e2253ae0','Single Bed (2)','Available',''),('dfb9ae61','c614e495','Double Decker (Lower)','Available',''),('dfcef44b','bf6aead5','Single Bed (2)','Available',''),('dff28343','7b0fbb35','Single Bed','Available',''),('e0645d1f','e1bc0faf','Double Decker (Upper)','Available',''),('e0983205','260aa7a0','Double Decker (Lower)','Available',''),('e0a36f79','bccb504f','Single Bed','Available',''),('e0de0899','45950cae','Single Bed (2)','Available',NULL),('e11d39f8','cb1ede70','Single Bed','Available',''),('e1206875','b1e76196','Double Decker (Lower)','Available',''),('e1de2a3f','4bde9488','Single Bed (1)','Available',''),('e22c6cd4','6c2f120a','Single Bed (2)','Available',''),('e269df98','8fcb3cc0','Single Bed (1)','Available',''),('e3535996','f153ba35','Double Decker (Lower)','Available',''),('e46ca232','01db92f2','Single Bed (1)','Available',''),('e5279ce3','0c9dc625','Single Bed (2)','Available',''),('e7347630','3bdd85d4','Single Bed','Available',''),('e77cd2b5','3cfd6d24','Single Bed','Available',''),('e7df48c5','e5a96d64','Double Decker (Lower)','Available',''),('e8f0269b','97a0c017','Single Bed','Available',''),('e9d8be8b','3105a1e8','Single Bed (2)','Available',''),('eaa85d45','25d9bf7a','Double Decker (Upper)','Available',''),('ebaa74a0','bccb504f','Double Decker (Lower)','Available',''),('ec759dfa','b8ede1e9','Single Bed','Available',''),('ec76a3ee','5aeffdec','Single Bed (2)','Available',''),('ecea4131','650382fd','Double Decker (Lower)','Available',''),('ed60976b','d8712d50','Single Bed','Available',''),('edb9c9f6','73c72ab8','Single Bed (1)','Available',''),('ee8cb979','e1c0f319','Single Bed (2)','Available',''),('eeefc3b4','d531be2d','Double Decker (Upper)','Available',''),('ef110cb3','8fcb3cc0','Single Bed (2)','Available',''),('efdcbb7b','a7bc3204','Single Bed (2)','Available',''),('eff87bbe','6c2f120a','Single Bed (1)','Available',''),('f01ca32e','988cc5fa','Single Bed','Available',''),('f14a225a','a2e6708e','Single Bed','Available',''),('f1c892da','611a6a46','Double Decker (Upper)','Available',''),('f24cb48c','a2df791e','Single Bed (2)','Available',''),('f308dfd2','6b6d1676','Double Decker (Upper)','Available',''),('f3092744','b1e178c8','Double Decker (Upper)','Available',''),('f37dbe93','12ecaae7','Double Decker (Upper)','Available',''),('f3990617','0ec94992','Single Bed','Available',''),('f4575034','4a47fa31','Single Bed (2)','Available',''),('f4b00503','3bdd85d4','Double Decker (Upper)','Available',''),('f4f9bdd0','fe0d4ff9','Double Decker (Lower)','Available',''),('f505c214','69448bc1','Single Bed (2)','Available',''),('f6374373','b1e178c8','Double Decker (Lower)','Available',''),('f6ae4c42','17d3c15b','Double Decker (Upper)','Available',''),('f6cb747e','f196f42c','Double Decker (Upper)','Available',''),('f7e8fefe','1e4df6c4','Double Decker (Lower)','Available',''),('f8004604','88913645','Double Decker (Lower)','Available',''),('f83ee197','056fee02','Double Decker (Upper)','Available',''),('f8610470','650382fd','Double Decker (Upper)','Available',''),('fa65fefb','558f6e59','Single Bed (2)','Available',''),('fa89dcff','a88d47ec','Single Bed (2)','Available',''),('facc99c6','f12943c6','Double Decker (Lower)','Available',''),('fbcaed17','b93db6f6','Single Bed','Available',''),('fc59e471','9baa2c9a','Double Decker (Lower)','Available',''),('fd47036b','b536620f','Single Bed (1)','Available',''),('fd4e82db','ba35e610','Double Decker (Lower)','Available',NULL),('fe9c6aa8','f8fb2893','Single Bed (2)','Available',''),('feef6bdf','42c3f915','Double Decker (Lower)','Available',''),('ff2ba3a8','30c82afe','Single Bed (1)','Available',''),('ff4d627e','17d3c15b','Single Bed','Available',''),('ffbd75f8','2e8979ad','Single Bed (2)','Available','');
/*!40000 ALTER TABLE `rooms` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `user_id` varchar(50) NOT NULL,
  `email` varchar(100) DEFAULT NULL,
  `password` varchar(255) DEFAULT NULL,
  `full_name` varchar(100) DEFAULT NULL,
  `role` varchar(20) DEFAULT 'Student',
  `matric_number` varchar(20) DEFAULT NULL,
  `home_state` varchar(50) DEFAULT NULL,
  `about_me` text,
  `profile_image` varchar(255) DEFAULT NULL,
  `faculty` varchar(100) DEFAULT NULL,
  `Gender` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`user_id`),
  UNIQUE KEY `matric_number` (`matric_number`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES ('admin_001','admin@bytee.com','admin123','Demo Admin','Admin','STAFF001','Selangor','Hostel Manager',NULL,'Admin Office','Male'),('9509654a-673b-4ab1-85af-bedc1cabc1a1','student@bytee.com','456123','ALI BIN KAREM','Student','123457','Johor','Demo student account',NULL,'Faculty of Science and Technology (FST)','Male');
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-01-12  9:56:06
