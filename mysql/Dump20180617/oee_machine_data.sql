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
-- Table structure for table `machine_data`
--

DROP TABLE IF EXISTS `machine_data`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `machine_data` (
  `code` varchar(10) NOT NULL,
  `name` varchar(20) NOT NULL,
  `department` varchar(100) DEFAULT NULL,
  `product` varchar(100) DEFAULT NULL,
  `last_maintenance` timestamp NULL DEFAULT NULL,
  `next_maintenance` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`code`),
  UNIQUE KEY `code_unique` (`code`),
  KEY `code_idx` (`code`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `machine_data`
--

LOCK TABLES `machine_data` WRITE;
/*!40000 ALTER TABLE `machine_data` DISABLE KEYS */;
INSERT INTO `machine_data` (`code`, `name`, `department`, `product`, `last_maintenance`, `next_maintenance`) VALUES ('MAQ1','Moinho 1','Departamento 1','Produto 1',NULL,NULL),('MAQ1*','Máquina 1',NULL,NULL,NULL,NULL),('MAQ10','MAQ3 PB ESQ',NULL,'Balões',NULL,NULL),('MAQ11','MAQ3 PB DIR',NULL,'Balões',NULL,NULL),('MAQ2','Dispersor 1','Departamento 2','Produto 2',NULL,NULL),('MAQ2*','Máquina 2',NULL,NULL,NULL,NULL),('MAQ3','Moinho 3','Departamento 3','',NULL,NULL),('MAQ3*','Máquina 3',NULL,NULL,NULL,NULL),('MAQ4','Moinho 2','','',NULL,NULL),('MAQ5','Dispersor 2','Departamento 5','',NULL,NULL),('MAQ6','MAQ3 CO ESQ',NULL,NULL,NULL,NULL);
/*!40000 ALTER TABLE `machine_data` ENABLE KEYS */;
UNLOCK TABLES;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2018-06-17 12:29:18
