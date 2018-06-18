-- MySQL dump 10.13  Distrib 5.7.9, for Win64 (x86_64)
--
-- Host: localhost    Database: oee
-- ------------------------------------------------------
-- Server version	5.5.34

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `channel_machine`
--

DROP TABLE IF EXISTS `channel_machine`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `channel_machine` (
  `channel_id` int(11) NOT NULL,
  `machine_code` varchar(10) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`channel_id`,`machine_code`),
  KEY `fk_channel_machine_machine` (`machine_code`),
  CONSTRAINT `fk_channel_machine_machine` FOREIGN KEY (`machine_code`) REFERENCES `machine_data` (`code`),
  CONSTRAINT `fk_channel_machine_channel` FOREIGN KEY (`channel_id`) REFERENCES `channel` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `channel_machine`
--

LOCK TABLES `channel_machine` WRITE;
/*!40000 ALTER TABLE `channel_machine` DISABLE KEYS */;
INSERT INTO `channel_machine` (`channel_id`, `machine_code`, `created_at`, `updated_at`) VALUES (1,'MAQ1','2018-06-06 16:35:55',NULL),(1,'MAQ10','2018-06-15 08:47:13',NULL),(1,'MAQ11','2018-06-15 11:15:23',NULL),(1,'MAQ2','2018-06-06 16:35:55',NULL),(1,'MAQ3','2018-06-06 16:35:55',NULL),(1,'MAQ4','2018-06-06 16:35:55',NULL),(1,'MAQ5','2018-06-06 16:38:30',NULL),(1,'MAQ6','2018-06-14 16:16:32',NULL),(2,'MAQ1','2018-06-06 16:35:55',NULL),(2,'MAQ10','2018-06-15 08:47:13',NULL),(2,'MAQ11','2018-06-15 11:15:23',NULL),(2,'MAQ2','2018-06-06 16:35:55',NULL),(2,'MAQ3','2018-06-06 16:35:55',NULL),(2,'MAQ4','2018-06-06 16:35:55',NULL),(2,'MAQ5','2018-06-06 16:38:30',NULL),(2,'MAQ6','2018-06-14 16:16:32',NULL),(6,'MAQ1*','2018-06-03 02:38:34',NULL),(6,'MAQ2*','2018-06-03 02:38:34',NULL),(6,'MAQ3*','2018-06-03 02:38:34',NULL),(7,'MAQ1*','2018-06-03 20:01:32',NULL),(7,'MAQ2*','2018-06-03 20:01:32',NULL),(7,'MAQ3*','2018-06-03 20:01:32',NULL);
/*!40000 ALTER TABLE `channel_machine` ENABLE KEYS */;
UNLOCK TABLES;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2018-06-17 12:29:16
