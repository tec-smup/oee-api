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
-- Table structure for table `feed_config`
--

DROP TABLE IF EXISTS `feed_config`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `feed_config` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `channel_id` int(11) NOT NULL,
  `field1` varchar(100) NOT NULL,
  `field2` varchar(100) NOT NULL,
  `field3` varchar(100) NOT NULL,
  `field4` varchar(100) NOT NULL,
  `field5` varchar(100) NOT NULL,
  `chart_sql` text,
  PRIMARY KEY (`id`),
  KEY `fk_feed_config_channel` (`channel_id`),
  CONSTRAINT `fk_feed_config_channel` FOREIGN KEY (`channel_id`) REFERENCES `channel` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `feed_config`
--

LOCK TABLES `feed_config` WRITE;
/*!40000 ALTER TABLE `feed_config` DISABLE KEYS */;
INSERT INTO `feed_config` (`id`, `channel_id`, `field1`, `field2`, `field3`, `field4`, `field5`, `chart_sql`) VALUES (1,1,'Tempo produtivo (hrs)','Tempo produtivo (min)','Total Hourimetro (Minutos)','Tempo turno (min)','Tempo turno (hrs)','\nselect date_format(f.inserted_at, \'%H:%i:%s\') as time  \n	 , case f.field4 when 0\n	     then 0 \n	   else \n		 round(((f.field2 / f.field4)*100),2) \n	   end as oee            \n  from feed f\n inner join channel c on c.id = f.ch_id\n inner join machine_data md on md.code = f.mc_cd\n inner join feed_config fc on fc.channel_id = c.id\n where date_format(f.inserted_at, \'%d/%m/%Y %H:%i\') between \'__date_ini\' and \'__date_fin\'\n   and ch_id = __ch_id\n   and mc_cd = \'__mc_cd\'\n order by f.inserted_at'),(2,2,'Temperatura','Tempo Turno(min)','Contagem linha2','Contagem linha1','','\nselect date_format(f.inserted_at, \'%H:%i:%s\') as time  \n	 , case f.field4 when 0\n	     then 0 \n	   else \n		 round(((f.field2 / f.field4)*100),2) \n	   end as oee            \n  from feed f\n inner join channel c on c.id = f.ch_id\n inner join machine_data md on md.code = f.mc_cd\n inner join feed_config fc on fc.channel_id = c.id\n where date_format(f.inserted_at, \'%d/%m/%Y %H:%i\') between \'__date_ini\' and \'__date_fin\'\n   and ch_id = __ch_id\n   and mc_cd = \'__mc_cd\'\n order by f.inserted_at');
/*!40000 ALTER TABLE `feed_config` ENABLE KEYS */;
UNLOCK TABLES;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2018-06-17 12:29:15
