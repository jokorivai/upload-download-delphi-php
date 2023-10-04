-- --------------------------------------------------------
-- Host:                         10.211.55.2
-- Server version:               5.6.40 - MySQL Community Server (GPL)
-- Server OS:                    macos10.13
-- HeidiSQL Version:             11.3.0.6295
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;


-- Dumping database structure for file_storage
DROP DATABASE IF EXISTS `file_storage`;
CREATE DATABASE IF NOT EXISTS `file_storage` /*!40100 DEFAULT CHARACTER SET latin1 */;
USE `file_storage`;

-- Dumping structure for table file_storage.file_list
DROP TABLE IF EXISTS `file_list`;
CREATE TABLE IF NOT EXISTS `file_list` (
  `id` int(8) NOT NULL AUTO_INCREMENT,
  `file_name` varchar(100) NOT NULL DEFAULT '',
  `file_id` varchar(64) NOT NULL DEFAULT '',
  `file_ext` varchar(10) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=latin1;

-- Dumping data for table file_storage.file_list: ~0 rows (approximately)
/*!40000 ALTER TABLE `file_list` DISABLE KEYS */;
INSERT INTO `file_list` (`id`, `file_name`, `file_id`, `file_ext`) VALUES
	(9, 'Rifan.png', '64-cc83c7f3cd1d7aa1dc8960fff4ae233b65142f1b086262.93911947', 'png');
/*!40000 ALTER TABLE `file_list` ENABLE KEYS */;

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IFNULL(@OLD_FOREIGN_KEY_CHECKS, 1) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40111 SET SQL_NOTES=IFNULL(@OLD_SQL_NOTES, 1) */;
