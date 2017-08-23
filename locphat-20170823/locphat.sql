-- MySQL dump 10.13  Distrib 5.7.17, for Win64 (x86_64)
--
-- Host: localhost    Database: locphat
-- ------------------------------------------------------
-- Server version	5.7.19-log

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `billings`
--

DROP TABLE IF EXISTS `billings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `billings` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `invoice_id` varchar(50) NOT NULL,
  `date` date NOT NULL,
  `order_time` time DEFAULT NULL,
  `payment_time` time DEFAULT NULL,
  `total` bigint(20) NOT NULL DEFAULT '0',
  `posted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `IX_invoice_id` (`invoice_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `billings`
--

LOCK TABLES `billings` WRITE;
/*!40000 ALTER TABLE `billings` DISABLE KEYS */;
/*!40000 ALTER TABLE `billings` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `billings_detail`
--

DROP TABLE IF EXISTS `billings_detail`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `billings_detail` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `billing_id` int(11) NOT NULL,
  `item_code` varchar(50) NOT NULL,
  `item_name` varchar(255) NOT NULL,
  `qnty` double NOT NULL,
  `price` double NOT NULL,
  `discount` double DEFAULT NULL,
  `total` bigint(20) NOT NULL,
  `posted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `billings_detail`
--

LOCK TABLES `billings_detail` WRITE;
/*!40000 ALTER TABLE `billings_detail` DISABLE KEYS */;
/*!40000 ALTER TABLE `billings_detail` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ws_logs`
--

DROP TABLE IF EXISTS `ws_logs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ws_logs` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `invoice_id` varchar(50) NOT NULL,
  `date` date DEFAULT NULL,
  `order_time` char(5) DEFAULT NULL,
  `payment_time` char(5) DEFAULT NULL,
  `total` bigint(20) NOT NULL,
  `calling_ip` varchar(24) DEFAULT NULL,
  `resp_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ws_logs`
--

LOCK TABLES `ws_logs` WRITE;
/*!40000 ALTER TABLE `ws_logs` DISABLE KEYS */;
/*!40000 ALTER TABLE `ws_logs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ws_logs_error`
--

DROP TABLE IF EXISTS `ws_logs_error`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ws_logs_error` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `invoice_id` varchar(50) DEFAULT NULL,
  `date` date DEFAULT NULL,
  `order_time` char(5) DEFAULT NULL,
  `payment_time` char(5) DEFAULT NULL,
  `total` bigint(20) DEFAULT NULL,
  `calling_ip` varchar(24) DEFAULT NULL,
  `resp_code` int(11) DEFAULT NULL,
  `resp_desc` text,
  `resp_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ws_logs_error`
--

LOCK TABLES `ws_logs_error` WRITE;
/*!40000 ALTER TABLE `ws_logs_error` DISABLE KEYS */;
/*!40000 ALTER TABLE `ws_logs_error` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping events for database 'locphat'
--

--
-- Dumping routines for database 'locphat'
--
/*!50003 DROP PROCEDURE IF EXISTS `billings_detail_insert` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `billings_detail_insert`(pbilling_id int,pitem_code varchar(50),pitem_name varchar(255),pqnty double,pprice double,pdiscount double,ptotal bigint,pdatetime timestamp)
    MODIFIES SQL DATA
BEGIN
	DECLARE rTime TIME DEFAULT NULL;
	INSERT INTO billings_detail(billing_id,item_code,item_name,qnty,price,
															discount,total,posted_at
	)
	VALUE (
		pbilling_id,pitem_code,pitem_name,pqnty,pprice,
		pdiscount,ptotal,pdatetime
	);

	SET rTime = TIME(pdatetime);

	UPDATE billings SET order_time=rTime WHERE id=pbilling_id AND (order_time < rTime OR order_time IS NULL) LIMIT 1;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `billings_get` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `billings_get`(pinvoice_id varchar(50))
    READS SQL DATA
BEGIN
	SELECT A.id, A.invoice_id, A.date, LEFT(A.order_time,5) AS order_time, LEFT(A.payment_time,5) AS payment_time,
		A.total, A.posted_at,
		B.id AS item_id, B.item_code, B.item_name, B.qnty AS item_qnty, B.price AS item_price, 
		B.discount AS item_discount, B.total AS item_total, B.posted_at AS item_posted_at		
	FROM billings A JOIN billings_detail B ON A.id=B.billing_id
	WHERE A.invoice_id=pinvoice_id
	ORDER BY B.id ASC;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `billings_getall` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `billings_getall`(pinvoice_id varchar(50),pdate date,ppage int,plimit int)
    READS SQL DATA
BEGIN
	#null,1,10
	DECLARE rFoundRows INT DEFAULT 0;
	DECLARE rOffset INT DEFAULT 0;
	DECLARE rUnixTimestamp INT DEFAULT 0;
	
	SET rOffset = (ppage-1) * plimit;
	SET rOffset = IF(rOffset < 0, 0, rOffset);
	IF pdate IS NOT NULL AND CHARACTER_LENGTH(pdate) > 0 THEN
		SET rUnixTimestamp = UNIX_TIMESTAMP(pdate);
	END IF;

	CREATE TEMPORARY TABLE IF NOT EXISTS tmp_billings(id bigint) ENGINE = MEMORY;

	SET @sqlStm = CONCAT('
												INSERT tmp_billings(id)
												SELECT SQL_CALC_FOUND_ROWS
														id
												FROM billings
												WHERE id > 0 ',
													IF(CHARACTER_LENGTH(pinvoice_id) > 0, CONCAT(' AND invoice_id=',QUOTE(pinvoice_id)), ''),
													IF(rUnixTimestamp > 0, CONCAT(' AND date >=',QUOTE(pdate)), ''),
												'
												ORDER BY ',IF(rUnixTimestamp > 0, CONCAT('date ASC, posted_at ASC'), CONCAT('posted_at DESC')),'
												LIMIT ', rOffset,',',plimit);
	PREPARE stmt FROM @sqlStm;
	EXECUTE stmt;

	SET rFoundRows = FOUND_ROWS();

	SELECT rFoundRows AS foundRows;	

	SELECT SQL_SMALL_RESULT
		invoice_id, date, total, LEFT(order_time, 5) AS order_time, LEFT(payment_time,5) AS payment_time	
	FROM tmp_billings TMP JOIN billings A ON TMP.id=A.id;

	DROP TEMPORARY TABLE IF EXISTS tmp_billings;	

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `billings_insert` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `billings_insert`(pinvoice_id varchar(50),pdate date,ppayment_time time,ptotal bigint)
    MODIFIES SQL DATA
BEGIN
	DECLARE rId INT DEFAULT 0;
	SELECT id INTO rId FROM billings WHERE invoice_id=pinvoice_id LIMIT 1;
	SET rId = IFNULL(rId,0);
	IF rId = 0 THEN	
		INSERT INTO billings(invoice_id,date,payment_time,total,posted_at)
		VALUES(pinvoice_id,pdate,ppayment_time,ptotal,CURRENT_TIMESTAMP);
		SET rId = LAST_INSERT_ID();
	ELSE
		SET rId = 0;
	END IF;
	SELECT rId AS id;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `ws_logs_delete` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `ws_logs_delete`(pid int)
    MODIFIES SQL DATA
BEGIN
	DELETE FROM ws_logs WHERE id=pid LIMIT 1;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `ws_logs_error_insert` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `ws_logs_error_insert`(pinvoice_id varchar(50),pdate date,porder_time char(5),ppayment_time char(5),ptotal bigint,pcalling_ip varchar(24),presp_code int,presp_desc text)
BEGIN
	INSERT INTO ws_logs_error(
		invoice_id,date,order_time,payment_time,total,
		calling_ip,resp_code,resp_desc
	) VALUE (
		pinvoice_id,pdate,porder_time,ppayment_time,ptotal,
		pcalling_ip,presp_code,presp_desc
	);
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `ws_logs_get` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `ws_logs_get`(pinvoice_id varchar(50))
    READS SQL DATA
BEGIN
	SELECT * FROM ws_logs WHERE invoice_id=pinvoice_id LIMIT 1;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `ws_logs_getall` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `ws_logs_getall`(pinvoice_id varchar(50),pdate date,ppage int,plimit int)
    READS SQL DATA
BEGIN
	#null,null,1,10
	DECLARE rFoundRows INT DEFAULT 0;
	DECLARE rOffset INT DEFAULT 0;
	DECLARE rUnixTimestamp INT DEFAULT 0;
	
	SET rOffset = (ppage-1) * plimit;
	SET rOffset = IF(rOffset < 0, 0, rOffset);
	IF pdate IS NOT NULL AND CHARACTER_LENGTH(pdate) > 0 THEN
		SET rUnixTimestamp = UNIX_TIMESTAMP(pdate);
	END IF;

	CREATE TEMPORARY TABLE IF NOT EXISTS tmp_ws_logs(id bigint) ENGINE = MEMORY;

	SET @sqlStm = CONCAT('
												INSERT tmp_ws_logs(id)
												SELECT SQL_CALC_FOUND_ROWS
														id
												FROM ws_logs
												WHERE id > 0 ',
													IF(CHARACTER_LENGTH(pinvoice_id) > 0, CONCAT(' AND invoice_id=',QUOTE(pinvoice_id)), ''),
													IF(rUnixTimestamp > 0, CONCAT(' AND date >=',QUOTE(pdate)), ''),
												'
												ORDER BY ',IF(rUnixTimestamp > 0, CONCAT('date ASC, resp_at ASC'), CONCAT('resp_at DESC')),'
												LIMIT ', rOffset,',',plimit);
	PREPARE stmt FROM @sqlStm;
	EXECUTE stmt;

	SET rFoundRows = FOUND_ROWS();

	SELECT rFoundRows AS foundRows;	

	SELECT SQL_SMALL_RESULT
		A.*	
	FROM tmp_ws_logs TMP JOIN ws_logs A ON TMP.id=A.id;

	DROP TEMPORARY TABLE IF EXISTS tmp_ws_logs;	

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `ws_logs_insert` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `ws_logs_insert`(pinvoice_id varchar(50),pdate date,porder_time char(5),ppayment_time char(5),ptotal bigint,pcalling_ip varchar(24))
    MODIFIES SQL DATA
BEGIN
	INSERT INTO ws_logs(
		invoice_id,date,order_time,payment_time,total,
		calling_ip
	)
	VALUE(
		pinvoice_id,pdate,porder_time,ppayment_time,ptotal,
		pcalling_ip
	);
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2017-08-09 23:02:13
