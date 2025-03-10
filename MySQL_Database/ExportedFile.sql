-- MySQL dump 10.13  Distrib 8.0.36, for Win64 (x86_64)
--
-- Host: 127.0.0.1    Database: retetewebsite
-- ------------------------------------------------------
-- Server version	8.0.36

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
-- Table structure for table `ingrediente`
--

DROP TABLE IF EXISTS `ingrediente`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ingrediente` (
  `ID_ingredient` int NOT NULL AUTO_INCREMENT,
  `Nume_ingredient` varchar(100) NOT NULL,
  PRIMARY KEY (`ID_ingredient`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ingrediente`
--

LOCK TABLES `ingrediente` WRITE;
/*!40000 ALTER TABLE `ingrediente` DISABLE KEYS */;
INSERT INTO `ingrediente` VALUES (1,'Mere'),(2,'Faina'),(3,'Oua'),(4,'Rosii'),(5,'Piept de pui'),(6,'Cartofi'),(8,'Ingredient'),(9,'cedva');
/*!40000 ALTER TABLE `ingrediente` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `retete`
--

DROP TABLE IF EXISTS `retete`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `retete` (
  `ID_reteta` int NOT NULL AUTO_INCREMENT,
  `Nume_reteta` varchar(255) NOT NULL,
  `Descriere` text,
  `Timp_preparare` int DEFAULT NULL,
  `Unitate_timp` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`ID_reteta`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `retete`
--

LOCK TABLES `retete` WRITE;
/*!40000 ALTER TABLE `retete` DISABLE KEYS */;
INSERT INTO `retete` VALUES (1,'Prajitura cu mere','O prajitura simpla si gustoasa.',6,'minutes'),(2,'Supa de rosii','O supa racoritoare de vara.',4,'seconds'),(3,'Pui la cuptor','Pui fraged cu legume la cuptor.',4,'hours'),(4,'reteta test','cexs',20,'minutes');
/*!40000 ALTER TABLE `retete` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `retete_ingrediente`
--

DROP TABLE IF EXISTS `retete_ingrediente`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `retete_ingrediente` (
  `ID_reteta` int NOT NULL,
  `ID_ingredient` int NOT NULL,
  `Cantitate` int NOT NULL,
  `Unitate_masura` varchar(50) NOT NULL,
  PRIMARY KEY (`ID_reteta`,`ID_ingredient`),
  KEY `ID_ingredient` (`ID_ingredient`),
  CONSTRAINT `retete_ingrediente_ibfk_1` FOREIGN KEY (`ID_reteta`) REFERENCES `retete` (`ID_reteta`) ON DELETE CASCADE,
  CONSTRAINT `retete_ingrediente_ibfk_2` FOREIGN KEY (`ID_ingredient`) REFERENCES `ingrediente` (`ID_ingredient`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `retete_ingrediente`
--

LOCK TABLES `retete_ingrediente` WRITE;
/*!40000 ALTER TABLE `retete_ingrediente` DISABLE KEYS */;
INSERT INTO `retete_ingrediente` VALUES (1,1,4,'buc'),(1,2,200,'g'),(1,3,3,'buc'),(2,4,500,'g'),(3,5,2,'buc'),(3,6,4,'buc');
/*!40000 ALTER TABLE `retete_ingrediente` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `utilizatori`
--

DROP TABLE IF EXISTS `utilizatori`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `utilizatori` (
  `ID_utilizator` int NOT NULL AUTO_INCREMENT,
  `Nume_utilizator` varchar(100) NOT NULL,
  `Parola` varchar(255) NOT NULL,
  PRIMARY KEY (`ID_utilizator`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `utilizatori`
--

LOCK TABLES `utilizatori` WRITE;
/*!40000 ALTER TABLE `utilizatori` DISABLE KEYS */;
INSERT INTO `utilizatori` VALUES (1,'Bardasu Emi','parola123');
/*!40000 ALTER TABLE `utilizatori` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-01-30 20:48:29
