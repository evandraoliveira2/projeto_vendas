-- MySQL dump 10.13  Distrib 8.0.19, for Win64 (x86_64)
--
-- Host: localhost    Database: banco_wk
-- ------------------------------------------------------
-- Server version	8.0.40

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `clientes`
--

DROP TABLE IF EXISTS `clientes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `clientes` (
  `CODIGO` int NOT NULL AUTO_INCREMENT,
  `NOME` varchar(100) NOT NULL,
  `CIDADE` varchar(50) DEFAULT NULL,
  `UF` varchar(2) DEFAULT NULL,
  PRIMARY KEY (`CODIGO`),
  KEY `IDX_CODIGO` (`CODIGO`) USING BTREE,
  KEY `IDX_NOME` (`NOME`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=22 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `clientes`
--

LOCK TABLES `clientes` WRITE;
/*!40000 ALTER TABLE `clientes` DISABLE KEYS */;
INSERT INTO `clientes` VALUES (1,'Maria Eduarda Vilela','Guararema','SP'),(2,'Jonatas Faro de Oliveira','São Paulo','SP'),(3,'Felipe de Araújo Oliveira','Curitiba','PR'),(4,'Amanda Garcia da Costa','Guararema','SP'),(5,'José Alencar de Azevedo','São Paulo','SP'),(6,'Maria Cristina Costa Silva','Guararema','SP'),(7,'Jeferson Eduardo dos Santos','São Paulo','SP'),(8,'Maria Clara Vilar','Guararema','SP'),(9,'Eduardo de Souza Castro','São Paulo','SP'),(10,'Joana Nascimento de Oliveira','Guararema','SP'),(11,'Edison Oliveira','Guararema','SP'),(12,'Vagner Batista Pereira','São Paulo','SP'),(13,'Isabela Cristina Wagner','Curitiba','PR'),(14,'Paola Armando','São Paulo','SP'),(15,'Raquel Maria Souza','Floarianópolis','SC'),(16,'Guilherme Cavalcanti de Oliveira','Floarianópolis','SC'),(17,'Gabriela Dias','Curitiba','PR'),(18,'Sofia Maria Pereira Dias','Guararema','SP'),(19,'Jessica de Araújo Moura','Floarianópolis','SC'),(20,'Sebastião Costa','Curitiba','PR'),(21,'Mariana Batista Rodrigues','Guararema','SP');
/*!40000 ALTER TABLE `clientes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `pedidos`
--

DROP TABLE IF EXISTS `pedidos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `pedidos` (
  `NUMERO` int NOT NULL AUTO_INCREMENT,
  `DATA_EMISSAO` datetime DEFAULT NULL,
  `CODIGO_CLIENTE` int DEFAULT NULL,
  `VALOR_TOTAL` float DEFAULT NULL,
  PRIMARY KEY (`NUMERO`),
  KEY `IDX_PEDIDOS_NUMERO` (`NUMERO`) USING BTREE,
  KEY `IDX_PEDIDOS_DATA_EMISSAO` (`DATA_EMISSAO`) USING BTREE,
  KEY `IDX_PEDIDOS_CODIGO_CLIENTE` (`CODIGO_CLIENTE`) USING BTREE,
  CONSTRAINT `FK_CLIENTES` FOREIGN KEY (`CODIGO_CLIENTE`) REFERENCES `clientes` (`CODIGO`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `pedidos`
--

LOCK TABLES `pedidos` WRITE;
/*!40000 ALTER TABLE `pedidos` DISABLE KEYS */;
INSERT INTO `pedidos` VALUES (8,'2024-10-28 20:34:05',5,17.8),(10,'2024-10-28 20:34:05',6,15);
/*!40000 ALTER TABLE `pedidos` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `pedidos_produtos`
--

DROP TABLE IF EXISTS `pedidos_produtos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `pedidos_produtos` (
  `AUTO_INCREM` int NOT NULL AUTO_INCREMENT,
  `NUMERO_PEDIDO` int NOT NULL,
  `CODIGO_PRODUTO` int NOT NULL,
  `QUANTIDADE` float DEFAULT NULL,
  `VALOR_UNITARIO` float DEFAULT NULL,
  `VALOR_TOTAL` float DEFAULT NULL,
  PRIMARY KEY (`AUTO_INCREM`),
  KEY `FK_PRODUTOS` (`CODIGO_PRODUTO`),
  KEY `IDX_PEDIDOS_PRODUTOS_AUTO_INCREM` (`AUTO_INCREM`) USING BTREE,
  KEY `IDX_PEDIDOS_PRODUTOS_NUMERO_PEDIDO` (`NUMERO_PEDIDO`) USING BTREE,
  CONSTRAINT `FK_PEDIDOS` FOREIGN KEY (`NUMERO_PEDIDO`) REFERENCES `pedidos` (`NUMERO`),
  CONSTRAINT `FK_PRODUTOS` FOREIGN KEY (`CODIGO_PRODUTO`) REFERENCES `produtos` (`CODIGO`)
) ENGINE=InnoDB AUTO_INCREMENT=20 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `pedidos_produtos`
--

LOCK TABLES `pedidos_produtos` WRITE;
/*!40000 ALTER TABLE `pedidos_produtos` DISABLE KEYS */;
INSERT INTO `pedidos_produtos` VALUES (18,8,3,1,17.8,17.8),(19,10,9,1,15,15);
/*!40000 ALTER TABLE `pedidos_produtos` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `produtos`
--

DROP TABLE IF EXISTS `produtos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `produtos` (
  `CODIGO` int NOT NULL AUTO_INCREMENT,
  `DESCRICAO` varchar(100) NOT NULL,
  `VL_UNITARIO` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`CODIGO`),
  KEY `PRODUTOS_CODIGO_IDX` (`CODIGO`) USING BTREE,
  KEY `PRODUTOS_DESCRICAO_IDX` (`DESCRICAO`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `produtos`
--

LOCK TABLES `produtos` WRITE;
/*!40000 ALTER TABLE `produtos` DISABLE KEYS */;
INSERT INTO `produtos` VALUES (1,'BASE','25,90'),(2,'CORRETIVO','13,50'),(3,'PÓ COMPACTO','17,80'),(4,'PÓ SOLTO','22,00'),(5,'CONTORNO','19,00'),(6,'ILUMINADOR','16,40'),(7,'LÁPIS PARA SOBRANCELHA','18,30'),(8,'GEL PARA SOBRANCELHA','19,90'),(9,'SOMBRA MARROM','15'),(10,'SOMBRA PRETA','15'),(11,'SOMBRA GLITER PRATA','14'),(12,'DELINEADOR EM GEL','17'),(13,'DELINEADOR EM CANETA','19,90'),(14,'DELINEADOR','18,20'),(15,'LÁPIS PRETO','11'),(16,'LÁPIS MARROM','11'),(17,'BLUSH','24'),(18,'BATOM','23,90'),(19,'BATOM LÍQUIDO','25,40'),(20,'GLOSS','21,90');
/*!40000 ALTER TABLE `produtos` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping routines for database 'banco_wk'
--
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2024-10-28 15:18:24
