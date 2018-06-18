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
-- Table structure for table `machine_pause`
--

DROP TABLE IF EXISTS `machine_pause`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `machine_pause` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `mc_cd` varchar(10) NOT NULL,
  `pause` int(11) NOT NULL,
  `date_ref` date NOT NULL,
  `inserted_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `justification` varchar(5000) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `code_idx` (`mc_cd`),
  CONSTRAINT `fk_pause_machine` FOREIGN KEY (`mc_cd`) REFERENCES `machine_data` (`code`)
) ENGINE=InnoDB AUTO_INCREMENT=59 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `machine_pause`
--

LOCK TABLES `machine_pause` WRITE;
/*!40000 ALTER TABLE `machine_pause` DISABLE KEYS */;
INSERT INTO `machine_pause` (`id`, `mc_cd`, `pause`, `date_ref`, `inserted_at`, `justification`) VALUES (1,'MAQ1 ',216,'2018-05-24','2018-05-24 12:56:05','Gdeve'),(2,'MAQ2 ',355,'2018-05-24','2018-05-24 12:57:35','Matéria prima'),(3,'MAQ3 ',355,'2018-05-24','2018-05-24 12:58:40','Greve'),(4,'MAQ4 ',355,'2018-05-24','2018-05-24 12:58:44','Greve'),(5,'MAQ4 ',3,'2018-05-24','2018-05-24 13:00:17','Greve'),(6,'MAQ5 ',248,'2018-05-24','2018-05-24 13:00:22','Greve'),(7,'MAQ1 ',184,'2018-05-25','2018-05-25 10:05:27','Greve - Falta de Matéria prima'),(8,'MAQ2 ',184,'2018-05-25','2018-05-25 10:05:31','Greve - Falta de Matéria prima'),(9,'MAQ3 ',184,'2018-05-25','2018-05-25 10:05:36','Greve - Falta de Matéria prima'),(10,'MAQ4 ',184,'2018-05-25','2018-05-25 10:05:40','Greve - Falta de Matéria prima'),(11,'MAQ5 ',184,'2018-05-25','2018-05-25 10:05:55','Greve - Falta de Matéria prima'),(12,'MAQ1 ',45,'2018-05-25','2018-05-25 10:50:27','Greve - Falta de Matéria prima'),(13,'MAQ2 ',45,'2018-05-25','2018-05-25 10:50:30','Greve - Falta de Matéria prima'),(14,'MAQ3 ',45,'2018-05-25','2018-05-25 10:50:35','Greve - Falta de Matéria prima'),(15,'MAQ4 ',45,'2018-05-25','2018-05-25 10:50:39','Greve - Falta de Matéria prima'),(16,'MAQ5 ',45,'2018-05-25','2018-05-25 10:50:46','Greve - Falta de Matéria prima'),(17,'MAQ1 ',54,'2018-05-25','2018-05-25 11:43:47','Greve'),(18,'MAQ2 ',51,'2018-05-25','2018-05-25 11:51:00','Greve'),(19,'MAQ3 ',60,'2018-05-25','2018-05-25 11:51:06','Greve'),(20,'MAQ4 ',60,'2018-05-25','2018-05-25 11:51:11','Greve'),(21,'MAQ5 ',60,'2018-05-25','2018-05-25 11:51:17','Greve'),(22,'MAQ2 ',9,'2018-05-25','2018-05-25 11:51:26','Greve'),(23,'MAQ1 ',42,'2018-05-25','2018-05-25 12:27:37','greve'),(24,'MAQ2 ',36,'2018-05-25','2018-05-25 12:27:42','greve'),(25,'MAQ3 ',36,'2018-05-25','2018-05-25 12:27:49','greve'),(26,'MAQ4 ',36,'2018-05-25','2018-05-25 12:27:55','greve'),(27,'MAQ5 ',36,'2018-05-25','2018-05-25 13:12:17','greve'),(28,'MAQ5 ',36,'2018-05-25','2018-05-25 13:12:17','greve'),(29,'MAQ1 ',275,'2018-05-25','2018-05-25 18:18:11','greve'),(30,'MAQ2 ',275,'2018-05-25','2018-05-25 18:18:17','greve'),(31,'MAQ3 ',275,'2018-05-25','2018-05-25 18:18:23','greve'),(32,'MAQ4 ',275,'2018-05-25','2018-05-25 18:18:29','greve'),(33,'MAQ5 ',239,'2018-05-25','2018-05-25 18:18:46','greve'),(34,'MAQ1 ',245,'2018-05-30','2018-05-30 12:07:27','setup 1 hora, almoço e rotina'),(35,'MAQ2 ',304,'2018-05-30','2018-05-30 12:07:34','desligada'),(36,'MAQ3 ',304,'2018-05-30','2018-05-30 12:07:40','desligada'),(37,'MAQ4 ',304,'2018-05-30','2018-05-30 12:07:47','desligada'),(38,'MAQ5 ',194,'2018-05-30','2018-05-30 12:08:16','setup, almoço, rotinas, movimentaçao'),(39,'MAQ1 ',83,'2018-05-30','2018-05-30 13:51:37','ALMOÇO'),(40,'MAQ5 ',53,'2018-05-30','2018-05-30 13:51:51','ALMOÇO'),(41,'MAQ1 ',5,'2018-05-30','2018-05-30 15:30:00','Retirada de material'),(42,'MAQ5 ',22,'2018-05-30','2018-05-30 15:30:42','Retirada / Movimentação da produção'),(43,'MAQ1 ',21,'2018-05-30','2018-05-30 16:31:00','Movimentação de produção'),(44,'MAQ2 ',163,'2018-05-30','2018-05-30 16:47:20','Maquina foi ligada apos as 14 porque?\''),(45,'MAQ3 ',293,'2018-05-30','2018-05-30 16:59:07','Não produziram'),(46,'MAQ4 ',293,'2018-05-30','2018-05-30 16:59:17','não produziram'),(47,'MAQ2 ',12,'2018-05-30','2018-05-30 16:59:29','fim de expediente'),(48,'MAQ2 ',3,'2018-05-30','2018-05-30 17:02:12','fim de expediente'),(49,'MAQ3 ',3,'2018-05-30','2018-05-30 17:02:26','não houve produção'),(50,'MAQ4 ',3,'2018-05-30','2018-05-30 17:02:27','n'),(51,'MAQ5 ',9,'2018-05-30','2018-05-30 17:02:47','fim de expediente'),(52,'MAQ1 ',8,'2018-05-30','2018-05-30 17:02:56','fim de expediente'),(53,'MAQ1 ',275,'2018-06-06','2018-06-06 17:51:30','Setup. Almoo e Movimentações'),(54,'MAQ2 ',391,'2018-06-06','2018-06-06 17:51:44','Setup. almoo e movimentações'),(55,'MAQ3 ',486,'2018-06-06','2018-06-06 17:52:03','Setup, almoo e movimentações'),(56,'MAQ1 ',140,'2018-06-08','2018-06-08 10:59:55','Setup e movimentações'),(57,'MAQ2 ',63,'2018-06-08','2018-06-08 11:00:06','setup e movimentações'),(58,'MAQ3 ',123,'2018-06-08','2018-06-08 11:00:24','setup e movimentações');
/*!40000 ALTER TABLE `machine_pause` ENABLE KEYS */;
UNLOCK TABLES;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2018-06-17 12:29:17
