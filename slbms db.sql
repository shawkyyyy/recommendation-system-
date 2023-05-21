CREATE DATABASE  IF NOT EXISTS `slbms` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;
USE `slbms`;
-- MySQL dump 10.13  Distrib 8.0.29, for Win64 (x86_64)
--
-- Host: localhost    Database: slbms
-- ------------------------------------------------------
-- Server version	8.0.29

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
-- Table structure for table `audit`
--

DROP TABLE IF EXISTS `audit`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `audit` (
  `id` int NOT NULL AUTO_INCREMENT,
  `type` varchar(255) NOT NULL,
  `body` json NOT NULL,
  `entity` varchar(255) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=23 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `audit`
--

LOCK TABLES `audit` WRITE;
/*!40000 ALTER TABLE `audit` DISABLE KEYS */;
INSERT INTO `audit` VALUES (1,'New Book','\"{\\\"subject\\\":\\\"Computer Science\\\",\\\"bookTitle\\\":\\\"Fundementals of C+\\\",\\\"numberOfPages\\\":2500,\\\"editionNumber\\\":2,\\\"copyWriteYear\\\":2014,\\\"publishers\\\":[{\\\"id\\\":1,\\\"publisherName\\\":\\\"Printice Hall\\\"}],\\\"authors\\\":[{\\\"id\\\":1,\\\"authorName\\\":\\\"rc hibbeler\\\"}],\\\"genres\\\":[{\\\"id\\\":1,\\\"genreName\\\":\\\"Mechanics\\\"},{\\\"id\\\":2,\\\"genreName\\\":\\\"Computer\\\"}]}\"','Books'),(2,'New Book','{\"genres\": [{\"id\": 1, \"genreName\": \"Mechanics\"}, {\"id\": 2, \"genreName\": \"Computer\"}], \"authors\": [{\"id\": 1, \"authorName\": \"rc hibbeler\"}], \"subject\": \"Computer Science\", \"bookTitle\": \"Fundementals of C+\", \"publishers\": [{\"id\": 1, \"publisherName\": \"Printice Hall\"}], \"copyWriteYear\": 2014, \"editionNumber\": 2, \"numberOfPages\": 2500}','Books'),(3,'New Author','{\"authorName\": \"Naguib Mahfouz\"}','Authors'),(4,'New Reservation','{\"user\": null, \"dueDate\": \"9999-12-31 23:59:59\", \"bookStock\": null, \"reservationDate\": \"9999-12-31 23:59:59\", \"reservationStatus\": \"pending\"}','Reservations'),(5,'New User','{\"email\": \"test@gmail.com\", \"phone\": \"01276097734\", \"roles\": [\"User\"], \"fullName\": \"Ahmed Ashraf Mohamed\", \"password\": \"$2b$10$nZglAd7LeVQYQJ06L5ZtZ.lYUggBsvICLPzf8OtR85kkLkjbsjAuO\", \"createdAt\": \"2023-04-09T17:17:06.490Z\"}','Users'),(6,'New Reservation','{\"user\": null, \"dueDate\": \"9999-12-31 23:59:59\", \"bookStock\": null, \"reservationDate\": \"9999-12-31 23:59:59\", \"reservationStatus\": \"pending\"}','Reservations'),(7,'New Book','{\"book\": {\"id\": 1, \"subject\": \"Mechanics\", \"bookTitle\": \"Engineering Mechanics Statics\", \"copyWriteYear\": 1998, \"editionNumber\": 8, \"numberOfPages\": 624}, \"shelf\": \"EX01\", \"bookStock\": 0, \"distributor\": {\"id\": 1, \"distributorName\": \"Main\"}}','Book Stock'),(8,'New Book','{\"genres\": [{\"id\": 1, \"genreName\": \"Mechanics\"}, {\"id\": 2, \"genreName\": \"Computer\"}], \"authors\": [{\"id\": 1, \"authorName\": \"rc hibbeler\"}], \"subject\": \"Computer Science\", \"bookTitle\": \"Fundementals of C+\", \"publishers\": [{\"id\": 1, \"publisherName\": \"Printice Hall\"}], \"copyWriteYear\": 2014, \"editionNumber\": 2, \"numberOfPages\": 2500}','Books'),(9,'New Reservation','{\"id\": 7, \"user\": null, \"dueDate\": \"9999-12-31 23:59:59\", \"bookStock\": null, \"returnDate\": null, \"reservationDate\": \"9999-12-31 23:59:59\", \"reservationStatus\": \"pending\"}','Reservations'),(10,'New Reservation','{\"user\": null, \"dueDate\": \"9999-12-31 23:59:59\", \"bookStock\": null, \"reservationDate\": \"9999-12-31 23:59:59\", \"reservationStatus\": \"pending\"}','Reservations'),(11,'New Reservation','{\"user\": null, \"dueDate\": \"9999-12-31 23:59:59\", \"bookStock\": null, \"reservationDate\": \"9999-12-31 23:59:59\", \"reservationStatus\": \"pending\"}','Reservations'),(12,'New Reservation','{\"user\": null, \"dueDate\": \"9999-12-31 23:59:59\", \"bookStock\": null, \"reservationDate\": \"9999-12-31 23:59:59\", \"reservationStatus\": \"pending\"}','Reservations'),(13,'New Reservation','{\"user\": null, \"dueDate\": \"9999-12-31 23:59:59\", \"bookStock\": null, \"reservationDate\": \"9999-12-31 23:59:59\", \"reservationStatus\": \"pending\"}','Reservations'),(14,'New Reservation','{\"user\": null, \"dueDate\": \"9999-12-31 23:59:59\", \"bookStock\": null, \"reservationDate\": \"9999-12-31 23:59:59\", \"reservationStatus\": \"pending\"}','Reservations'),(15,'New Reservation','{\"user\": null, \"dueDate\": \"9999-12-31 23:59:59\", \"bookStock\": null, \"reservationDate\": \"9999-12-31 23:59:59\", \"reservationStatus\": \"pending\"}','Reservations'),(16,'New Reservation','{\"userId\": null, \"dueDate\": \"9999-12-31 23:59:59\", \"bookStockId\": null, \"reservationDate\": \"9999-12-31 23:59:59\", \"reservationStatus\": \"pending\"}','Reservations'),(17,'New Reservation','{\"userId\": null, \"dueDate\": \"9999-12-31 23:59:59\", \"bookStockId\": null, \"reservationDate\": \"9999-12-31 23:59:59\", \"reservationStatus\": \"pending\"}','Reservations'),(18,'New Reservation','{\"userId\": {\"id\": 12, \"flag\": null, \"email\": \"test@gmail.com\", \"phone\": \"01276097734\", \"roles\": \"User\", \"fullName\": \"Ahmed Ashraf Mohamed\", \"password\": \"$2b$10$nZglAd7LeVQYQJ06L5ZtZ.lYUggBsvICLPzf8OtR85kkLkjbsjAuO\", \"createdAt\": \"2023-04-09T17:17:06.000Z\"}, \"dueDate\": \"9999-12-31 23:59:59\", \"bookStockId\": {\"id\": 92, \"shelf\": \"EX01\", \"bookStock\": 0}, \"reservationDate\": \"9999-12-31 23:59:59\", \"reservationStatus\": \"pending\"}','Reservations'),(19,'New Reservation','{\"userId\": {\"id\": 10, \"flag\": null, \"email\": \"superadmin@gmail.com\", \"phone\": \"01276097734\", \"roles\": \"SuperAdmin\", \"fullName\": \"Ahmed Ashraf Mohamed\", \"password\": \"$2b$10$vAOqJjwr0Eo9OqIkkhYZJ.Y376y5tplahd1CN6Rqt4UhBxp5gga2i\", \"createdAt\": \"2023-04-08T04:55:27.000Z\"}, \"dueDate\": \"9999-12-31 23:59:59\", \"bookStockId\": {\"id\": 2, \"shelf\": \"1/25D\", \"bookStock\": 1}, \"reservationDate\": \"4-27-2023 7:58:52\", \"reservationStatus\": \"pending\"}','Reservations'),(20,'New Book','{\"genres\": [{\"id\": 1, \"genreName\": \"Mechanics\"}], \"authors\": [{\"id\": 1, \"authorName\": \"rc hibbeler\"}], \"subject\": \"Computer Science\", \"bookTitle\": \"Fundementals of C+\", \"publishers\": [{\"id\": 1, \"publisherName\": \"Printice Hall\"}], \"copyWriteYear\": 2014, \"editionNumber\": 2, \"numberOfPages\": 2500}','Books'),(21,'New Book','{\"book\": {\"id\": 1, \"subject\": \"Mechanics\", \"bookTitle\": \"Engineering Mechanics Statics\", \"copyWriteYear\": 1998, \"editionNumber\": 8, \"numberOfPages\": 624}, \"shelf\": \"EX01\", \"bookStock\": 0, \"distributor\": {\"id\": 1, \"distributorName\": \"Main\"}}','Book Stock'),(22,'New Book','{\"book\": {\"id\": 1, \"subject\": \"Mechanics\", \"bookTitle\": \"Engineering Mechanics Statics\", \"copyWriteYear\": 1998, \"editionNumber\": 8, \"numberOfPages\": 624}, \"shelf\": \"EX01\", \"bookStock\": 0, \"distributor\": {\"id\": 1, \"distributorName\": \"Main\"}}','Book Stock');
/*!40000 ALTER TABLE `audit` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `author`
--

DROP TABLE IF EXISTS `author`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `author` (
  `id` int NOT NULL AUTO_INCREMENT,
  `authorName` varchar(255) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=59 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `author`
--

LOCK TABLES `author` WRITE;
/*!40000 ALTER TABLE `author` DISABLE KEYS */;
INSERT INTO `author` VALUES (1,'rc hibbeler'),(2,'stuart j russel'),(3,'ahmed elshiem'),(4,'cledef coombs j . R'),(5,'fredrick e. giesecke'),(6,'john montague'),(7,'S.N. Sivanandam'),(8,'serway'),(9,'ray mond change'),(10,'r c hibbler'),(11,'surject singkazi zam'),(12,'michale walker'),(13,'m. morris mano'),(14,'john g. proakis'),(15,'davide e. jonshon'),(16,'j .f douglas'),(17,'thomans commally'),(18,'james a. obriex'),(19,'brian p . Bloom'),(20,'lionel warnes'),(21,'chinline chem'),(22,'henery matcolm'),(23,'vicent jones'),(24,'willam f. smith'),(25,'subsah machajam'),(26,'simon r. saun'),(27,'micheal seull'),(28,'paul a.lynn'),(29,'paul a. tipler'),(30,'erwinkrey szig'),(31,'sherief d. elwakil'),(32,'sedra&smith'),(33,'rossl finney'),(34,'charkel a. gross'),(35,'clydel f coombs'),(36,'milton ohring'),(37,'s. m. sze'),(38,'davide irwin'),(39,'francaise s. tse'),(40,'davide halliday'),(41,'philip mattews'),(42,'robert d. mason'),(43,'tom hutchinson'),(44,'byron s. gottriel'),(45,'murthy'),(46,'alan single'),(47,'wrigh wldkhakhn'),(48,'abdel fatah ebrahim'),(49,'kaliel walked'),(50,'weal eladawy'),(51,'theodors wild'),(52,'فاروق عباس حيدر'),(53,'سوسن اسكانيات'),(54,'عبد اللطيف ابو العطا'),(55,'وحيد حلمى حبيب'),(56,'السيد عبد الفتاح الق'),(57,'محمد احمد عبد الله');
/*!40000 ALTER TABLE `author` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `book`
--

DROP TABLE IF EXISTS `book`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `book` (
  `id` int NOT NULL AUTO_INCREMENT,
  `bookTitle` varchar(255) NOT NULL,
  `copyWriteYear` int NOT NULL,
  `subject` varchar(255) NOT NULL,
  `editionNumber` int NOT NULL,
  `numberOfPages` int NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=93 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `book`
--

LOCK TABLES `book` WRITE;
/*!40000 ALTER TABLE `book` DISABLE KEYS */;
INSERT INTO `book` VALUES (1,'Engineering Mechanics Statics',1998,'Mechanics',8,624),(2,'Artificial intelganacel',1995,'Computer',1,932),(3,'An introduction to drawing for civil engineering',1995,'Eng.Drawing',1,230),(4,'Mechanics of Materials',1997,'Phys.',3,855),(5,'Printed Circuits Handbook',1996,'Electrical',4,42),(6,'Technical Drawing',1997,'Eng.Drawing',10,841),(7,'Basic perfective Drawing',1993,'Eng.Drawing',2,200),(8,'Gentic Algorithms',1999,'Computer',1,344),(9,'College Physics',1999,'Phys.',5,1029),(10,'Chemistry',1998,'Chem.',6,993),(11,'Engineering Machines Dynamics',1997,'Mechanics',1,624),(12,'Engineering Mechanics Dynamics',1997,'Mechanics',1,624),(13,'Modern Alegebra',1972,'Math.',1,511),(14,'Success Comnunicathing in English',1995,'Language',3,128),(15,'Success bonus Pratice',1994,'Language',2,128),(16,'Success Bonus Pratic',1994,'Language',2,128),(17,'Success Comunicateion in English',1994,'Language',2,128),(18,'Digital Design',1991,'Electrical',2,516),(19,'Digital Signal Processing',1996,'Electrical',3,968),(20,'Electric Circuit Anallysis',1997,'Electrical',3,848),(21,'Fluid Mechanics',1995,'Production',2,819),(22,'Database Systems',1999,'Computer',2,1094),(23,'Intyoduction to Information Systems',1994,'Computer',17,483),(24,'Information Technology &Organization',1997,'Computer',1,186),(25,'Analogue &Digital Electronhcs',1998,'Electrical',1,572),(26,'Elements of to Electronics &Fiber optics',1996,'Electrical',1,595),(27,'Engineering Economic Principles',1996,'Language',2,520),(28,'Nefurt. Archectects Data',1998,'Arch.',2,433),(29,'Principles of Materials Sciences&ENGINEERING',1996,'Production',3,892),(30,'Principles of Growth of Semiconductors',1999,'Electrical',1,512),(31,'Antennas &propragation for wireless Communication',1999,'Electrical',1,409),(32,'Practical Algorthns for image Analysis',2000,'Computer',1,295),(33,'Introductory Digital Signal Processing',1996,'Electrical',1,400),(34,'Physics for Sciencetists &Engineering',1999,'Phys.',4,1335),(35,'Advanced Engineering Mathematics',1999,'Math.',8,1156),(36,'Proceses & Design for Manufacturing',1998,'Electrical',2,614),(37,'Microelectronic Circuit',1998,'Electrical',4,1237),(38,'Calculus',1994,'Math.',2,1004),(39,'Power System Analysis',1996,'Electrical',2,593),(40,'Printed Circuit Hand book',1996,'Electrical',4,42),(41,'Reliabililytiy &Failure of electronic Materials',1998,'Production',1,692),(42,'Semiconductor Devices Physics & Technology',1985,'Phys.',1,523),(43,'Basic Enginerring Circuit Analysics',1999,'Electrical',6,976),(44,'Measurement & instermenation In Enginerring',1989,'Electrical',1,757),(45,'Fundmental of Physics Extended',1997,'Phys.',5,1142),(46,'Fundemental of Physics Ettended',1997,'Phys.',1,1142),(47,'Advanced Chemistry',1996,'Chem.',1,976),(48,'Statical Techniques in Pusiness & Economics',1999,'Language',10,791),(49,'Interface English forTechnical Comunication',1992,'Language',1,128),(50,'Programing With Pascal',1994,'Computer',2,1004),(51,'Soil Mechanics & Fondation Engineering',1984,'Production',1,762),(52,'Soil Mechanics & Fundation Engineering',1984,'Production',1,762),(53,'Basic Soil Mechanics & Fundmation',1996,'Production',1,465),(54,'Theory of Structers',1995,'Arch.',5,480),(55,'Theory of Structers',1990,'Arch.',10,432),(56,'Reinforced Concerte Design Handbook',1988,'Arch.',1,240),(57,'Design of Renforced Concerte Collums',1999,'Arch.',3,263),(58,'Design of Reforced Concrete Collums',1999,'Arch.',3,263),(59,'SAP go (finite element analysics of Structers)',1997,'Arch.',1,259),(60,'Design of Reniforced Concreat BEAMS',1995,'Arch.',3,294),(61,'Design of Reinforced Concreate BEAMS',1995,'Arch.',3,294),(62,'Design of Reinforced Concreat Salabs',1997,'Arch.',4,342),(63,'Design of Reinforced Concreat Salab',1997,'Arch.',4,342),(64,'Design of Reniforced Concreate Stairrs',1998,'Arch.',5,215),(65,'DESIGN OF Reniforced Concreate Stairs',1998,'Arch.',5,215),(66,'Design of Reinforced Concreat  Water tanks',1995,'Arch.',1,339),(67,'Design Of Reinforced Concerete Water Tanks',1995,'Arch.',1,339),(68,'Fondation Design',1998,'Arch.',1,421),(69,'Fundation Design',1998,'Arch.',1,421),(70,'Structure design of mosques',1997,'Arch.',2,358),(71,'Electrical power  technology',1981,'Electrical',1,686),(72,'تششيد المبانى (1)',1997,'Arch.',5,566),(73,'تشيد المبانى(2)',1998,'Arch.',4,784),(74,'تشيد المبانى (1)',1997,'Arch.',5,566),(75,'تشيد المبانى (2)',1997,'Arch.',4,784),(76,'تشيد المبانى',1997,'Arch.',6,766),(77,'فن المنظور والاظهارالمعمارى',1985,'Arch.',2,303),(78,'فن المنظور والاظهار المعمارى',1985,'Arch.',2,303),(79,'الموسوعة الهندسيةلانشاء المبانى والمرافق العامة',1994,'Arch.',5,659),(80,'الموسوعة الهندسية لانشاء المبانى والمرافق العامة',1994,'Arch.',5,659),(81,'تخطيط المدن الجديدة (1)',1990,'Arch.',1,454),(82,'تخطيط المدن الجديدة',1990,'Arch.',1,567),(83,'تخطيط المدن الجديدة (1)',1990,'Arch.',2,567),(84,'ميكانيكا التربة',1999,'Arch.',2,734),(85,'ميكانيكا التربة',1999,'Arch.',2,753),(86,'المنساً المعمارية',1997,'Arch.',2,753),(87,'المنشاًة المعمارية',1997,'Arch.',1,753),(88,'الاظهار المعماري',1997,'Arch.',1,203),(91,'Fundementals of C+',2014,'Computer Science',2,2500),(92,'Fundementals of C+',2014,'Computer Science',2,2500);
/*!40000 ALTER TABLE `book` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `book_stock`
--

DROP TABLE IF EXISTS `book_stock`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `book_stock` (
  `id` int NOT NULL AUTO_INCREMENT,
  `bookStock` int NOT NULL DEFAULT '0',
  `shelf` varchar(255) NOT NULL,
  `distributorId` int DEFAULT NULL,
  `bookId` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `FK_be9912962290b33caaa1731bfbd` (`bookId`),
  KEY `FK_c49558812ace11c2a030c0e6b08` (`distributorId`),
  CONSTRAINT `FK_be9912962290b33caaa1731bfbd` FOREIGN KEY (`bookId`) REFERENCES `book` (`id`),
  CONSTRAINT `FK_c49558812ace11c2a030c0e6b08` FOREIGN KEY (`distributorId`) REFERENCES `distributor` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=95 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `book_stock`
--

LOCK TABLES `book_stock` WRITE;
/*!40000 ALTER TABLE `book_stock` DISABLE KEYS */;
INSERT INTO `book_stock` VALUES (1,1,'24/29C',2,1),(2,1,'1/25D',2,2),(3,1,'3/8C',2,3),(4,1,'1/5C',2,4),(5,1,'9/28B',2,5),(6,1,'1/8C',2,6),(7,1,'4/8C',2,7),(8,1,'3/23D',2,8),(9,1,'6/16C',2,9),(10,1,'23/17B',2,10),(11,1,'12/19C',2,1),(12,1,'5/19C',2,12),(13,1,'6/19C',2,13),(14,1,'27/12B',2,14),(15,1,'1/22B',2,15),(16,1,'2/22B',2,16),(17,1,'12/22B',2,17),(18,1,'13/22B',2,18),(19,1,'12/23E',2,19),(20,1,'11/23E',2,20),(21,1,'5/28B',2,21),(22,1,'2/4C',2,22),(23,1,'15/24C',2,23),(24,1,'8/24C',2,24),(25,1,'6/25D',2,25),(26,1,'13/28B',2,26),(27,1,'31/31B',2,27),(28,1,'7/5B',2,28),(29,1,'20/1C',2,29),(30,1,'4/5C',2,30),(31,1,'7/31B',2,31),(32,1,'20/28C - 22/28C',2,32),(33,1,'2/26C',2,33),(34,1,'10/23E',2,34),(35,1,'21/16C',2,35),(36,1,'1/13D',2,36),(37,1,'2/5C',2,4),(38,1,'24/5B',2,38),(39,1,'5/29C',2,39),(40,1,'11/12D',2,40),(41,1,'5/30B',2,41),(42,1,'10/28B',2,42),(43,1,'1/29C',2,43),(44,1,'22/30B',2,44),(45,1,'4/28B',2,45),(46,1,'21/28D',2,46),(47,1,'4/16C',2,47),(48,1,'3/16C',2,48),(49,1,'3/17C',2,49),(50,1,'11/22B',2,50),(51,1,'5/22B',2,51),(52,1,'36/26D',2,52),(53,1,'24/3D',2,53),(54,1,'25/3D',2,54),(55,1,'28/3D',2,55),(56,1,'29/3D',2,55),(57,1,'11/3D',2,57),(58,1,'12/3D',2,57),(59,1,'14/3D',2,57),(60,1,'13/3D',2,57),(61,1,'9/3D',2,61),(62,1,'10/3D',2,61),(63,1,'15/3D',2,63),(64,1,'16/3D',2,64),(65,1,'13/3E',2,65),(66,1,'7/3D',2,66),(67,1,'8/3D',2,67),(68,1,'3/3D',2,68),(69,1,'4/3D',2,69),(70,1,'26/3D',2,70),(71,1,'27/3D',2,71),(72,1,'5/3D',2,72),(73,1,'6/3D',2,73),(74,1,'17/3D',2,74),(75,1,'18/3D',2,75),(76,1,'19/3D',2,76),(77,1,'20/3D',2,76),(78,1,'19/30C',2,78),(79,1,'12/2C',2,79),(80,1,'13/2C',2,80),(81,1,'11/2C',2,81),(82,1,'4/2B',2,82),(83,1,'9/2C',2,83),(84,1,'10/2C',2,81),(85,1,'11/2B',2,85),(86,1,'12/2B',2,86),(87,1,'6/2C',2,87),(88,1,'5/2C',2,88),(92,0,'EX01',1,1),(93,0,'EX01',1,1),(94,0,'EX01',1,1);
/*!40000 ALTER TABLE `book_stock` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `books_authors`
--

DROP TABLE IF EXISTS `books_authors`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `books_authors` (
  `bookId` int NOT NULL,
  `authorId` int NOT NULL,
  PRIMARY KEY (`bookId`,`authorId`),
  KEY `IDX_49317e96c1e48ad58971b515b5` (`bookId`),
  KEY `IDX_bd1523e8f4d8a04cd9e6bd8a13` (`authorId`),
  CONSTRAINT `FK_49317e96c1e48ad58971b515b50` FOREIGN KEY (`bookId`) REFERENCES `book` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `FK_bd1523e8f4d8a04cd9e6bd8a139` FOREIGN KEY (`authorId`) REFERENCES `author` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `books_authors`
--

LOCK TABLES `books_authors` WRITE;
/*!40000 ALTER TABLE `books_authors` DISABLE KEYS */;
INSERT INTO `books_authors` VALUES (1,1),(2,2),(3,3),(4,1),(5,4),(6,5),(7,6),(8,7),(9,8),(10,9),(11,10),(12,10),(13,11),(14,12),(15,12),(16,12),(17,12),(18,13),(19,14),(20,15),(21,16),(22,17),(23,18),(24,19),(25,20),(26,21),(27,22),(28,23),(29,24),(30,25),(31,26),(32,27),(33,28),(34,29),(35,30),(36,31),(37,32),(38,33),(39,34),(40,35),(41,36),(42,37),(43,38),(44,39),(45,40),(46,40),(47,41),(48,42),(49,43),(50,44),(51,45),(52,45),(53,46),(54,47),(55,47),(56,48),(57,49),(58,49),(59,50),(60,49),(61,49),(62,49),(63,49),(64,49),(65,49),(66,49),(67,49),(68,49),(69,49),(70,49),(71,51),(72,52),(73,52),(74,52),(75,52),(76,52),(77,53),(78,53),(79,54),(80,54),(81,55),(82,55),(83,55),(84,56),(85,56),(86,54),(87,54),(88,57),(91,1),(92,1);
/*!40000 ALTER TABLE `books_authors` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `books_genres`
--

DROP TABLE IF EXISTS `books_genres`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `books_genres` (
  `bookId` int NOT NULL,
  `genreId` int NOT NULL,
  PRIMARY KEY (`bookId`,`genreId`),
  KEY `IDX_6be725b00a687badd89efc6c26` (`bookId`),
  KEY `IDX_c6e45e1bf711b3e9ccce92b0e2` (`genreId`),
  CONSTRAINT `FK_6be725b00a687badd89efc6c26d` FOREIGN KEY (`bookId`) REFERENCES `book` (`id`),
  CONSTRAINT `FK_c6e45e1bf711b3e9ccce92b0e29` FOREIGN KEY (`genreId`) REFERENCES `genre` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `books_genres`
--

LOCK TABLES `books_genres` WRITE;
/*!40000 ALTER TABLE `books_genres` DISABLE KEYS */;
INSERT INTO `books_genres` VALUES (1,1),(2,2),(3,3),(4,4),(5,5),(6,3),(7,3),(8,2),(9,4),(10,6),(11,1),(12,1),(13,7),(14,8),(15,8),(16,8),(17,8),(18,5),(19,5),(20,5),(21,9),(22,2),(23,2),(24,2),(25,5),(26,5),(27,8),(28,10),(29,9),(30,5),(31,5),(32,2),(33,5),(34,4),(35,7),(36,5),(37,5),(38,7),(39,5),(40,5),(41,9),(42,4),(43,5),(44,5),(45,4),(46,4),(47,6),(48,8),(49,8),(50,2),(51,9),(52,9),(53,9),(54,10),(55,10),(56,10),(57,10),(58,10),(59,10),(60,10),(61,10),(62,10),(63,10),(64,10),(65,10),(66,10),(67,10),(68,10),(69,10),(70,10),(71,5),(72,10),(73,10),(74,10),(75,10),(76,10),(77,10),(78,10),(79,10),(80,10),(81,10),(82,10),(83,10),(84,10),(85,10),(86,10),(87,10),(88,10),(91,1),(91,2),(92,1);
/*!40000 ALTER TABLE `books_genres` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `books_publishers`
--

DROP TABLE IF EXISTS `books_publishers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `books_publishers` (
  `bookId` int NOT NULL,
  `publisherId` int NOT NULL,
  PRIMARY KEY (`bookId`,`publisherId`),
  KEY `IDX_df349b8f76a3368a37673a185f` (`bookId`),
  KEY `IDX_3f8c611a9800585e49ec8336aa` (`publisherId`),
  CONSTRAINT `FK_3f8c611a9800585e49ec8336aa0` FOREIGN KEY (`publisherId`) REFERENCES `publisher` (`id`),
  CONSTRAINT `FK_df349b8f76a3368a37673a185fe` FOREIGN KEY (`bookId`) REFERENCES `book` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `books_publishers`
--

LOCK TABLES `books_publishers` WRITE;
/*!40000 ALTER TABLE `books_publishers` DISABLE KEYS */;
INSERT INTO `books_publishers` VALUES (1,1),(2,1),(3,2),(4,1),(5,2),(6,1),(7,3),(8,4),(9,5),(10,2),(11,1),(12,1),(13,6),(14,7),(15,7),(16,7),(17,7),(18,1),(19,1),(20,1),(21,8),(22,7),(23,9),(24,10),(25,11),(26,9),(27,2),(28,12),(29,2),(30,2),(31,2),(32,13),(33,14),(34,15),(35,16),(36,17),(37,10),(38,7),(39,14),(40,2),(41,18),(42,14),(43,14),(44,19),(45,14),(46,20),(47,20),(48,21),(49,8),(50,2),(51,22),(52,22),(53,23),(54,24),(55,24),(56,25),(57,25),(58,25),(59,25),(60,25),(61,25),(62,25),(63,25),(64,25),(65,25),(66,25),(67,25),(68,25),(69,25),(70,25),(71,14),(72,26),(73,26),(74,26),(75,26),(76,26),(77,27),(78,27),(79,28),(80,28),(81,29),(82,29),(83,29),(84,30),(85,30),(86,31),(87,31),(88,32),(91,1),(92,1);
/*!40000 ALTER TABLE `books_publishers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `distributor`
--

DROP TABLE IF EXISTS `distributor`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `distributor` (
  `id` int NOT NULL AUTO_INCREMENT,
  `distributorName` varchar(255) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `distributor`
--

LOCK TABLES `distributor` WRITE;
/*!40000 ALTER TABLE `distributor` DISABLE KEYS */;
INSERT INTO `distributor` VALUES (1,'Main'),(2,'Extention');
/*!40000 ALTER TABLE `distributor` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `genre`
--

DROP TABLE IF EXISTS `genre`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `genre` (
  `id` int NOT NULL AUTO_INCREMENT,
  `genreName` varchar(255) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `genre`
--

LOCK TABLES `genre` WRITE;
/*!40000 ALTER TABLE `genre` DISABLE KEYS */;
INSERT INTO `genre` VALUES (1,'Mechanics'),(2,'Computer'),(3,'Eng.Drawing'),(4,'Phys.'),(5,'Electrical'),(6,'Chem.'),(7,'Math.'),(8,'Language'),(9,'Production'),(10,'Arch.');
/*!40000 ALTER TABLE `genre` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `logger`
--

DROP TABLE IF EXISTS `logger`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `logger` (
  `id` int NOT NULL AUTO_INCREMENT,
  `type` varchar(255) NOT NULL,
  `body` json NOT NULL,
  `entity` varchar(255) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `logger`
--

LOCK TABLES `logger` WRITE;
/*!40000 ALTER TABLE `logger` DISABLE KEYS */;
/*!40000 ALTER TABLE `logger` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `notification`
--

DROP TABLE IF EXISTS `notification`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `notification` (
  `notificationId` varchar(36) NOT NULL,
  `subject` varchar(255) NOT NULL,
  `reservationId` int DEFAULT NULL,
  `payload` json NOT NULL,
  PRIMARY KEY (`notificationId`),
  KEY `FK_0dbb41113fb3fe18842b0686df1` (`reservationId`),
  CONSTRAINT `FK_0dbb41113fb3fe18842b0686df1` FOREIGN KEY (`reservationId`) REFERENCES `reservation` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `notification`
--

LOCK TABLES `notification` WRITE;
/*!40000 ALTER TABLE `notification` DISABLE KEYS */;
INSERT INTO `notification` VALUES ('13a3210d-3ffe-41a9-a89e-ff95fb4311bd','New Reservation',NULL,'{\"user\": null, \"dueDate\": \"9999-12-31 23:59:59\", \"bookStock\": null, \"reservationDate\": \"9999-12-31 23:59:59\", \"reservationStatus\": \"pending\"}'),('1f351732-4644-44f1-ab7c-00f26b5aded9','New Reservation',NULL,'{\"user\": null, \"dueDate\": \"9999-12-31 23:59:59\", \"bookStock\": null, \"reservationDate\": \"9999-12-31 23:59:59\", \"reservationStatus\": \"pending\"}'),('25b06c1f-2c02-4223-ba72-1a9c59f6ca70','New Reservation',NULL,'{\"userId\": null, \"dueDate\": \"9999-12-31 23:59:59\", \"bookStockId\": null, \"reservationDate\": \"9999-12-31 23:59:59\", \"reservationStatus\": \"pending\"}'),('38aeb0d2-6fc4-48ac-8d0e-28b889462ae3','New Reservation',NULL,'{\"user\": null, \"dueDate\": \"9999-12-31 23:59:59\", \"bookStock\": null, \"reservationDate\": \"9999-12-31 23:59:59\", \"reservationStatus\": \"pending\"}'),('5539f43c-9e75-4ea9-a3ca-3ab99259db04','New Reservation',NULL,'{\"id\": 7, \"user\": null, \"dueDate\": \"9999-12-31 23:59:59\", \"bookStock\": null, \"returnDate\": null, \"reservationDate\": \"9999-12-31 23:59:59\", \"reservationStatus\": \"pending\"}'),('59a6e7bf-f14e-441e-9495-02dbfa6a47c9','New Reservation',NULL,'{\"userId\": null, \"dueDate\": \"9999-12-31 23:59:59\", \"bookStockId\": null, \"reservationDate\": \"9999-12-31 23:59:59\", \"reservationStatus\": \"pending\"}'),('80832225-1e49-4caf-8c9b-519450d2b2ea','New Reservation',NULL,'{\"userId\": {\"id\": 10, \"flag\": null, \"email\": \"superadmin@gmail.com\", \"phone\": \"01276097734\", \"roles\": \"SuperAdmin\", \"fullName\": \"Ahmed Ashraf Mohamed\", \"password\": \"$2b$10$vAOqJjwr0Eo9OqIkkhYZJ.Y376y5tplahd1CN6Rqt4UhBxp5gga2i\", \"createdAt\": \"2023-04-08T04:55:27.000Z\"}, \"dueDate\": \"9999-12-31 23:59:59\", \"bookStockId\": {\"id\": 2, \"shelf\": \"1/25D\", \"bookStock\": 1}, \"reservationDate\": \"4-27-2023 7:58:52\", \"reservationStatus\": \"pending\"}'),('93de9008-0f90-470c-a9a8-71b203aef57b','New Reservation',NULL,'{\"userId\": {\"id\": 12, \"flag\": null, \"email\": \"test@gmail.com\", \"phone\": \"01276097734\", \"roles\": \"User\", \"fullName\": \"Ahmed Ashraf Mohamed\", \"password\": \"$2b$10$nZglAd7LeVQYQJ06L5ZtZ.lYUggBsvICLPzf8OtR85kkLkjbsjAuO\", \"createdAt\": \"2023-04-09T17:17:06.000Z\"}, \"dueDate\": \"9999-12-31 23:59:59\", \"bookStockId\": {\"id\": 92, \"shelf\": \"EX01\", \"bookStock\": 0}, \"reservationDate\": \"9999-12-31 23:59:59\", \"reservationStatus\": \"pending\"}'),('b33d7af7-728e-4232-b720-2e1b1f5a1460','New Reservation',NULL,'{\"user\": null, \"dueDate\": \"9999-12-31 23:59:59\", \"bookStock\": null, \"reservationDate\": \"9999-12-31 23:59:59\", \"reservationStatus\": \"pending\"}'),('c0af5dd8-9eec-4cef-8141-066bbbaad526','New Reservation',NULL,'{\"user\": null, \"dueDate\": \"9999-12-31 23:59:59\", \"bookStock\": null, \"reservationDate\": \"9999-12-31 23:59:59\", \"reservationStatus\": \"pending\"}'),('ce442687-2227-407b-9e17-9d56ff2e3535','New Reservation',NULL,'{\"user\": null, \"dueDate\": \"9999-12-31 23:59:59\", \"bookStock\": null, \"reservationDate\": \"9999-12-31 23:59:59\", \"reservationStatus\": \"pending\"}'),('db157e5c-2c51-4141-9aa3-b669727b2b71','New Reservation',NULL,'{\"user\": null, \"dueDate\": \"9999-12-31 23:59:59\", \"bookStock\": null, \"reservationDate\": \"9999-12-31 23:59:59\", \"reservationStatus\": \"pending\"}'),('ffa1bf82-8fec-4c88-b9b9-283e3f1c164f','New Reservation',NULL,'{\"user\": null, \"dueDate\": \"9999-12-31 23:59:59\", \"bookStock\": null, \"reservationDate\": \"9999-12-31 23:59:59\", \"reservationStatus\": \"pending\"}');
/*!40000 ALTER TABLE `notification` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `publisher`
--

DROP TABLE IF EXISTS `publisher`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `publisher` (
  `id` int NOT NULL AUTO_INCREMENT,
  `publisherName` varchar(255) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=33 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `publisher`
--

LOCK TABLES `publisher` WRITE;
/*!40000 ALTER TABLE `publisher` DISABLE KEYS */;
INSERT INTO `publisher` VALUES (1,'Printice Hall'),(2,'Mc-Graw hill'),(3,'Van Nostrand'),(4,'Springer- Verlag'),(5,'Sunders'),(6,'Sanjay Prints'),(7,'Addison Wesley'),(8,'Long man'),(9,'Irwin'),(10,'Oxford'),(11,'Mac millan'),(12,'Blackwell Sciences ltd'),(13,'Syndicatte'),(14,'John Wilsey'),(15,'Free man'),(16,'Peter Janzow'),(17,'PWS'),(18,'Academic press'),(19,'Marchel Dekker'),(20,'Cambridge'),(21,'Irwin- Mcgraw hill'),(22,'Justen Office'),(23,'CBS publiser'),(24,'Dar Elmaaref'),(25,'DarElkotob'),(26,'منشاة المعارف'),(27,'النسر الذهبى'),(28,'مطابع الوفاء'),(29,'دار مكتبة المهندسين'),(30,'دار الكتب العلمية'),(31,'دار الوفاء'),(32,'الانجلو المصريه');
/*!40000 ALTER TABLE `publisher` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `reservation`
--

DROP TABLE IF EXISTS `reservation`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `reservation` (
  `id` int NOT NULL AUTO_INCREMENT,
  `reservationDate` datetime NOT NULL,
  `dueDate` datetime NOT NULL,
  `returnDate` datetime DEFAULT NULL,
  `reservationStatus` varchar(255) NOT NULL DEFAULT 'pending',
  `userIdId` int DEFAULT NULL,
  `bookStockIdId` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `REL_cfd5b0ed59c23a41387fa33459` (`bookStockIdId`),
  KEY `FK_7894e4e1b96647176dbfd1a9790` (`userIdId`),
  CONSTRAINT `FK_7894e4e1b96647176dbfd1a9790` FOREIGN KEY (`userIdId`) REFERENCES `user` (`id`),
  CONSTRAINT `FK_cfd5b0ed59c23a41387fa33459c` FOREIGN KEY (`bookStockIdId`) REFERENCES `book_stock` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `reservation`
--

LOCK TABLES `reservation` WRITE;
/*!40000 ALTER TABLE `reservation` DISABLE KEYS */;
INSERT INTO `reservation` VALUES (6,'9999-12-31 23:59:59','9999-12-31 23:59:59',NULL,'pending',NULL,NULL),(7,'9999-12-31 23:59:59','9999-12-31 23:59:59',NULL,'pending',NULL,NULL),(8,'9999-12-31 23:59:59','9999-12-31 23:59:59',NULL,'pending',NULL,NULL),(9,'9999-12-31 23:59:59','9999-12-31 23:59:59',NULL,'pending',NULL,NULL),(10,'9999-12-31 23:59:59','9999-12-31 23:59:59',NULL,'pending',NULL,NULL),(11,'9999-12-31 23:59:59','9999-12-31 23:59:59',NULL,'pending',NULL,NULL),(12,'9999-12-31 23:59:59','9999-12-31 23:59:59',NULL,'pending',NULL,NULL),(13,'9999-12-31 23:59:59','9999-12-31 23:59:59',NULL,'pending',NULL,NULL),(14,'9999-12-31 23:59:59','9999-12-31 23:59:59',NULL,'pending',NULL,NULL),(15,'9999-12-31 23:59:59','9999-12-31 23:59:59',NULL,'pending',NULL,NULL),(16,'9999-12-31 23:59:59','9999-12-31 23:59:59',NULL,'done',12,92);
/*!40000 ALTER TABLE `reservation` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `role`
--

DROP TABLE IF EXISTS `role`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `role` (
  `roleId` int NOT NULL AUTO_INCREMENT,
  `roleName` varchar(255) NOT NULL,
  PRIMARY KEY (`roleId`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `role`
--

LOCK TABLES `role` WRITE;
/*!40000 ALTER TABLE `role` DISABLE KEYS */;
INSERT INTO `role` VALUES (1,'User'),(2,'Admin'),(3,'SuperAdmin');
/*!40000 ALTER TABLE `role` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user`
--

DROP TABLE IF EXISTS `user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user` (
  `id` int NOT NULL AUTO_INCREMENT,
  `fullName` varchar(255) DEFAULT NULL,
  `email` varchar(255) NOT NULL,
  `password` varchar(255) NOT NULL,
  `flag` varchar(255) DEFAULT NULL,
  `createdAt` datetime NOT NULL,
  `phone` varchar(255) NOT NULL,
  `roles` enum('User','Admin','SuperAdmin') NOT NULL DEFAULT 'User',
  PRIMARY KEY (`id`),
  UNIQUE KEY `IDX_e12875dfb3b1d92d7d7c5377e2` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user`
--

LOCK TABLES `user` WRITE;
/*!40000 ALTER TABLE `user` DISABLE KEYS */;
INSERT INTO `user` VALUES (1,'Ahmed Ashraf','aa@gmail.com','asdasdqw',NULL,'2023-03-24 21:09:19','01276097734','User'),(2,'Mody','ahmed@gmail.com','123456789',NULL,'2023-03-25 03:59:43','01276097734','User'),(5,'Ahmed Ashraf Mohamed','gg@gmail.com','MODAyam1',NULL,'2023-03-28 21:23:21','01276097734','SuperAdmin'),(7,'Ahmed Ashraf Mohamed','ss@gmail.com','$2b$10$/kUdxH.F4VnMCOU5phWLIuVyIJN3BhoFzDDaUB5xU4NgV2s1PlTki',NULL,'2023-04-08 06:29:40','01276097734','User'),(8,'Ahmed Ashraf Mohamed','ff@gmail.com','$2b$10$sH.6YpiGudXUXATc4kTQqua2yU2xoBZDJpHFGRszTJlPFnWavahEm',NULL,'2023-04-08 06:41:23','01276097734','SuperAdmin'),(9,'Ahmed Ashraf Mohamed','admin@gmail.com','$2b$10$0MRPlFQJ0qRircJPWLJA8eSMDWR4qMTFOVTyeLCGyd9zqEfoYFO9a',NULL,'2023-04-08 06:55:16','01276097734','Admin'),(10,'Ahmed Ashraf Mohamed','superadmin@gmail.com','$2b$10$vAOqJjwr0Eo9OqIkkhYZJ.Y376y5tplahd1CN6Rqt4UhBxp5gga2i',NULL,'2023-04-08 06:55:27','01276097734','SuperAdmin'),(11,'Ahmed Ashraf Mohamed','user@gmail.com','$2b$10$591xxoZluLPh3Kfirsx1YOziMvnVM8UwKm6W/TlejgRgiX11H603q',NULL,'2023-04-08 06:55:40','01276097734','User'),(12,'Ahmed Ashraf Mohamed','test@gmail.com','$2b$10$nZglAd7LeVQYQJ06L5ZtZ.lYUggBsvICLPzf8OtR85kkLkjbsjAuO',NULL,'2023-04-09 19:17:06','01276097734','User');
/*!40000 ALTER TABLE `user` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users_roles`
--

DROP TABLE IF EXISTS `users_roles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users_roles` (
  `userId` int NOT NULL,
  `roleRoleId` int NOT NULL,
  PRIMARY KEY (`userId`,`roleRoleId`),
  KEY `IDX_776b7cf9330802e5ef5a8fb18d` (`userId`),
  KEY `IDX_21affdaf3405de1fa0ebdc7855` (`roleRoleId`),
  CONSTRAINT `FK_21affdaf3405de1fa0ebdc78551` FOREIGN KEY (`roleRoleId`) REFERENCES `role` (`roleId`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `FK_776b7cf9330802e5ef5a8fb18dc` FOREIGN KEY (`userId`) REFERENCES `user` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users_roles`
--

LOCK TABLES `users_roles` WRITE;
/*!40000 ALTER TABLE `users_roles` DISABLE KEYS */;
INSERT INTO `users_roles` VALUES (1,1);
/*!40000 ALTER TABLE `users_roles` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2023-04-29 17:04:16
