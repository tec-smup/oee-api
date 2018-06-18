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
-- Table structure for table `user`
--

DROP TABLE IF EXISTS `user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `username` varchar(100) NOT NULL,
  `password` varchar(500) NOT NULL,
  `active` bit(1) NOT NULL DEFAULT b'1',
  `admin` bit(1) NOT NULL DEFAULT b'0',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `company_name` varchar(200) DEFAULT NULL,
  `phone` varchar(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user`
--

LOCK TABLES `user` WRITE;
/*!40000 ALTER TABLE `user` DISABLE KEYS */;
INSERT INTO `user` (`id`, `username`, `password`, `active`, `admin`, `created_at`, `company_name`, `phone`) VALUES (1,'paul8liveira@gmail.com','$2a$10$SWLfel2IqmhVnw1/4bGKs.023uqOOWViV4k3p/69Lwanr1QdbprbC','','','2018-03-07 00:08:33',NULL,'19983173834'),(2,'diogo.maccord@startmeupsolutions.com.br','$2a$10$SWLfel2IqmhVnw1/4bGKs.023uqOOWViV4k3p/69Lwanr1QdbprbC','','','2018-03-07 00:08:33',NULL,NULL),(3,'washington.peroni@startmeupsolutions.com.br','$2a$10$SWLfel2IqmhVnw1/4bGKs.023uqOOWViV4k3p/69Lwanr1QdbprbC','','','2018-03-07 00:08:33',NULL,NULL),(4,'contato@startmeupsolutions.com.br','$2a$10$SWLfel2IqmhVnw1/4bGKs.023uqOOWViV4k3p/69Lwanr1QdbprbC','','','2018-04-24 08:40:46',NULL,NULL),(5,'leolac@leolac.com.br','$2a$10$n2UFk998Sd4uTkW9Z8aKbuKoYkf4KsbmrVdCS3AGBkolPMdhvGpRK','','\0','2018-06-03 02:38:34','Leolac',NULL),(6,'leolac2@leolac.com.br','$2a$10$/cIfM2qAdPShDF7F.FwfmOJeB2RFjKpz9CAHF6WeieDxgvUXoGqk2','','\0','2018-06-03 20:01:32','Leolac',NULL);
/*!40000 ALTER TABLE `user` ENABLE KEYS */;
UNLOCK TABLES;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2018-06-17 12:29:20
