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
-- Table structure for table `user_channel`
--

DROP TABLE IF EXISTS `user_channel`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_channel` (
  `user_id` int(11) NOT NULL,
  `channel_id` int(11) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`user_id`,`channel_id`),
  KEY `fk_user_channel_channel` (`channel_id`),
  CONSTRAINT `fk_user_channel_user` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`),
  CONSTRAINT `fk_user_channel_channel` FOREIGN KEY (`channel_id`) REFERENCES `channel` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_channel`
--

LOCK TABLES `user_channel` WRITE;
/*!40000 ALTER TABLE `user_channel` DISABLE KEYS */;
INSERT INTO `user_channel` (`user_id`, `channel_id`, `created_at`, `updated_at`) VALUES (1,1,'2018-06-06 16:34:58',NULL),(1,2,'2018-06-06 16:34:58',NULL),(2,1,'2018-06-06 16:34:58',NULL),(2,2,'2018-06-06 16:34:58',NULL),(3,1,'2018-06-06 16:34:58',NULL),(3,2,'2018-06-06 16:34:58',NULL),(4,1,'2018-06-06 16:34:58',NULL),(4,2,'2018-06-06 16:34:58',NULL),(5,6,'2018-06-03 02:38:34',NULL),(6,7,'2018-06-03 20:01:32',NULL);
/*!40000 ALTER TABLE `user_channel` ENABLE KEYS */;
UNLOCK TABLES;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2018-06-17 12:29:13
