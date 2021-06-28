-- phpMyAdmin SQL Dump
-- version 4.2.7.1
-- http://www.phpmyadmin.net
--
-- Host: 127.0.0.1
-- Generation Time: Mar 19, 2017 at 03:34 PM
-- Server version: 5.5.39
-- PHP Version: 5.4.31

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

--
-- Database: `flatbook_traders`
--

DELIMITER $$
--
-- Procedures
--
CREATE DEFINER=`elitecapital`@`localhost` PROCEDURE `checkEquity`(IN type VARCHAR(200), IN exchange_id VARCHAR(200), IN losable_amt INT, IN server_now DATETIME)
BEGIN  DECLARE equity INT DEFAULT 0;  DECLARE val INT DEFAULT 0;  SELECT ACCOUNT_BALANCE  INTO val FROM users  WHERE users.EXCHANGE_ID = exchange_id;  SET equity = val - losable_amt;  IF (type = 'SELLER') THEN  SELECT COALESCE(SUM(SELLER_LOSABLE_AMT), 0)  INTO val FROM exchange_options  WHERE  exchange_options.CANCELLED = 0 AND exchange_options.EXCHANGE_EXPIRY > server_now  AND (exchange_options.BUYER_ID IS NULL AND BINARY exchange_options.SELLER_ID = exchange_id AND exchange_options.DEL_BY_SELLER_ID  IS NULL);  SET equity = equity - val;  SELECT COALESCE(SUM(SELLER_LOSABLE_AMT), 0)  INTO val FROM exchange_spotfx   WHERE  exchange_spotfx.CANCELLED = 0 AND exchange_spotfx.EXCHANGE_EXPIRY > server_now  AND (exchange_spotfx.BUYER_ID IS NULL AND BINARY exchange_spotfx.SELLER_ID = exchange_id AND exchange_spotfx.DEL_BY_SELLER_ID  IS NULL);  SET equity = equity - val;  SELECT COALESCE(SUM(SELLER_LOSABLE_AMT), 0)  INTO val FROM open_positions_options   WHERE BINARY open_positions_options.BUYER_ID = exchange_id OR BINARY open_positions_options.SELLER_ID = exchange_id;  SET equity = equity - val;  SELECT COALESCE(SUM(SELLER_LOSABLE_AMT), 0)  INTO val FROM open_positions_spotfx   WHERE BINARY open_positions_spotfx.BUYER_ID = exchange_id OR BINARY open_positions_spotfx.SELLER_ID = exchange_id;  SET equity = equity - val;  ELSEIF (type = 'BUYER') THEN  SELECT COALESCE(SUM(BUYER_LOSABLE_AMT), 0)  INTO val FROM exchange_options  WHERE  exchange_options.CANCELLED = 0 AND exchange_options.EXCHANGE_EXPIRY > server_now  AND (exchange_options.BUYER_ID IS NULL AND BINARY exchange_options.SELLER_ID = exchange_id AND exchange_options.DEL_BY_SELLER_ID  IS NULL);  SET equity = equity - val;  SELECT COALESCE(SUM(BUYER_LOSABLE_AMT), 0)  INTO val FROM exchange_spotfx   WHERE  exchange_spotfx.CANCELLED = 0 AND exchange_spotfx.EXCHANGE_EXPIRY > server_now  AND (exchange_spotfx.BUYER_ID IS NULL AND BINARY exchange_spotfx.SELLER_ID = exchange_id AND exchange_spotfx.DEL_BY_SELLER_ID  IS NULL);  SET equity = equity - val;  SELECT COALESCE(SUM(BUYER_LOSABLE_AMT), 0)  INTO val FROM open_positions_options   WHERE BINARY open_positions_options.BUYER_ID = exchange_id OR BINARY open_positions_options.SELLER_ID = exchange_id;  SET equity = equity - val;  SELECT COALESCE(SUM(BUYER_LOSABLE_AMT), 0)  INTO val FROM open_positions_spotfx   WHERE BINARY open_positions_spotfx.BUYER_ID = exchange_id OR BINARY open_positions_spotfx.SELLER_ID = exchange_id;  SET equity = equity - val;  END IF;SELECT equity; END$$

CREATE DEFINER=`elitecapital`@`localhost` PROCEDURE `test_proc`(IN `type` VARCHAR(200), IN `COL` VARCHAR(200))
BEGIN  DECLARE val INT DEFAULT 0; DECLARE equity INT DEFAULT 0; select SUM(COL) INTO val from users;  IF (type = 'BUYER') THEN     SET equity =  val + 1000; ELSEIF (type = 'SELLER') THEN     SET equity =  val - 1000; ELSE    SET equity = 2; END IF;  SELECT equity; END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `account_tran`
--

CREATE TABLE IF NOT EXISTS `account_tran` (
`SN` int(11) NOT NULL,
  `USERNAME` varchar(200) DEFAULT NULL,
  `TRAN_DATE` varchar(200) NOT NULL DEFAULT '1900-01-01 00:00:00' COMMENT 'important! must be VARCHAR and not DATETIME because of some internal isssues where local time is selected by knex against our wish.',
  `TRAN_TYPE` varchar(200) DEFAULT NULL COMMENT 'e.g DEPOSIT, WITHDRAWAL',
  `TRAN_DETAILS` varchar(2000) DEFAULT NULL,
  `AMOUNT` float NOT NULL DEFAULT '0',
  `PAYMENT_METHOD` varchar(200) NOT NULL
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=65 ;

--
-- Dumping data for table `account_tran`
--

INSERT INTO `account_tran` (`SN`, `USERNAME`, `TRAN_DATE`, `TRAN_TYPE`, `TRAN_DETAILS`, `AMOUNT`, `PAYMENT_METHOD`) VALUES
(1, 'chuks1', '2016-01-18 12:32:35', 'WITHDRAWAL', 'I WITHDRAW SOME MONEY', 1000, 'PayPal'),
(2, 'Skefr3apQx', '2016-12-13 22:35:13', 'DEPOSIT', '', 3000, ''),
(3, 'SJl7pqppmx', '2016-12-13 22:57:25', 'WITHDRAWAL', '', 2000, ''),
(4, 'SJl7pqppmx', '2016-12-13 23:01:27', 'WITHDRAWAL', '', 3000, ''),
(5, 'SJl7pqppmx', '2016-12-13 23:04:25', 'DEPOSIT', '', 2000, ''),
(6, 'chuks3', '2016-12-17 23:05:48', 'WITHDRAWAL', '', 2000, ''),
(7, 'chuks3', '2016-12-17 23:08:21', 'WITHDRAWAL', '', 2000, 'Bank Wire Transfer'),
(8, 'chuks3', '2016-12-17 23:08:49', 'WITHDRAWAL', '', 3000, 'Bank Wire Transfer'),
(9, 'chuks3', '2016-12-17 23:10:00', 'WITHDRAWAL', '', 9000, 'Bank Wire Transfer'),
(10, 'chuks3', '2016-12-17 23:14:44', 'WITHDRAWAL', '', 600, 'bank wire'),
(11, 'chuks3', '2016-12-17 23:16:18', 'WITHDRAWAL', '', 600, 'Bank Wire Transfer'),
(12, 'chuks3', '2016-12-17 23:16:42', 'WITHDRAWAL', '', 3400, 'Bank Wire Transfer'),
(13, 'chuks3', '2016-12-17 23:19:41', 'WITHDRAWAL', '', 7000, 'bank wire'),
(14, 'chuks3', '2016-12-17 23:21:24', 'WITHDRAWAL', '', 5400, ''),
(15, 'chuks3', '2016-12-17 23:22:19', 'WITHDRAWAL', '', 5400, 'PayPal'),
(16, 'chuks3', '2016-12-17 23:24:34', 'WITHDRAWAL', '', 5400, ''),
(17, 'chuks3', '2016-12-17 23:28:34', 'WITHDRAWAL', '', 2020, ''),
(18, 'chuks3', '2016-12-17 23:31:39', 'WITHDRAWAL', '', 5900, ''),
(19, 'chuks3', '2016-12-17 23:37:25', 'WITHDRAWAL', '', 900, ''),
(20, 'chuks3', '2016-12-17 23:37:33', 'WITHDRAWAL', '', 1000000, ''),
(22, 'chuks3', '2016-12-18 00:00:59', 'WITHDRAWAL', '', 300, ''),
(23, 'chuks3', '2016-12-18 00:04:50', 'WITHDRAWAL', '', 50, ''),
(26, 'chuks3', '2016-12-18 00:14:29', 'WITHDRAWAL', '', 70, ''),
(27, 'chuks3', '2016-12-18 00:14:47', 'WITHDRAWAL', '', 700, ''),
(28, 'chuks3', '2016-12-18 00:16:20', 'WITHDRAWAL', '', 700, ''),
(30, 'chuks3', '2016-12-18 00:22:55', 'WITHDRAWAL', '', 689, ''),
(31, 'chuks3', '2016-12-18 00:24:24', 'WITHDRAWAL', '', 400, ''),
(38, 'chuks3', '2016-12-18 00:37:59', 'WITHDRAWAL', '', 400, ''),
(39, 'chuks3', '2016-12-18 00:38:26', 'WITHDRAWAL', '', 600, ''),
(42, 'chuks3', '2016-12-18 00:39:37', 'WITHDRAWAL', '', 1000, ''),
(43, 'chuks3', '2016-12-18 12:19:35', 'WITHDRAWAL', '', 400, ''),
(44, 'chuks3', '2016-12-18 12:20:09', 'WITHDRAWAL', '', 1300, ''),
(45, 'chuks3', '2016-12-18 12:20:23', 'WITHDRAWAL', '', 233, ''),
(46, 'chuks3', '2016-12-18 12:22:05', 'WITHDRAWAL', '', 34, ''),
(47, 'chuks3', '2016-12-18 12:24:55', 'WITHDRAWAL', '', 23, ''),
(48, 'chuks3', '2016-12-18 12:25:17', 'WITHDRAWAL', '', 30, ''),
(49, 'chuks3', '2016-12-18 12:25:25', 'WITHDRAWAL', '', 10, ''),
(50, 'chuks3', '2016-12-18 12:25:32', 'WITHDRAWAL', '', 100, ''),
(51, 'chuks3', '2016-12-18 12:26:47', 'WITHDRAWAL', '', 1000, ''),
(52, 'chuks3', '2016-12-18 12:27:43', 'WITHDRAWAL', '', 310, ''),
(53, 'chuks4', '2016-12-18 13:47:44', 'WITHDRAWAL', '', 20, ''),
(54, 'chuks4', '2016-12-18 13:48:16', 'WITHDRAWAL', '', 500, ''),
(55, 'chuks4', '2016-12-18 13:49:13', 'WITHDRAWAL', '', 400000, ''),
(56, 'chuks4', '2016-12-18 13:49:39', 'WITHDRAWAL', '', 99480, ''),
(57, 'Skefr3apQx', '2016-12-31 14:21:57', 'WITHDRAWAL', '', 5000, ''),
(58, 'Skefr3apQx', '2016-12-31 14:23:18', 'DEPOSIT', '', 4000, ''),
(59, 'HkxZmxBFHl', '2017-01-03 15:18:09', 'DEPOSIT', '', 500, ''),
(60, 'HkxZmxBFHl', '2017-01-03 16:07:36', 'WITHDRAWAL', '', 600, ''),
(61, 'HkxZmxBFHl', '2017-01-03 16:10:34', 'WITHDRAWAL', '', 4200, ''),
(62, 'tt', '2017-03-03 05:02:14', 'WITHDRAWAL', '', 10, ''),
(63, 'HJlJ_urLqg', '2017-03-03 01:49:06', 'DEPOSIT', 'INITIAL DEPOSIT UPON ACCOUNT OPENING.', 1500, ''),
(64, 'S1gG83SL5x', '2017-03-03 01:54:02', 'DEPOSIT', 'INITIAL DEPOSIT UPON ACCOUNT OPENING.', 5000, '');

-- --------------------------------------------------------

--
-- Table structure for table `daily_rebate`
--

CREATE TABLE IF NOT EXISTS `daily_rebate` (
`SN` int(11) NOT NULL,
  `LIVE` tinyint(1) NOT NULL DEFAULT '0',
  `DATE` varchar(200) NOT NULL DEFAULT '1900-01-01' COMMENT 'important! must be VARCHAR and not DATE. Our design decision because of some issues observed',
  `DAY_COMMISSION` float NOT NULL DEFAULT '0',
  `DAY_ACCOUNT_BALANCE` float NOT NULL DEFAULT '0'
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=109 ;

--
-- Dumping data for table `daily_rebate`
--

INSERT INTO `daily_rebate` (`SN`, `LIVE`, `DATE`, `DAY_COMMISSION`, `DAY_ACCOUNT_BALANCE`) VALUES
(94, 1, '2017-03-02', 0, 126200),
(95, 1, '2017-03-03', 0, 126200),
(96, 1, '2017-03-04', 0, 126200),
(97, 1, '2017-03-05', 0, 126200),
(98, 1, '2017-03-06', 0, 126200),
(99, 1, '2017-03-07', 100, 126100),
(100, 1, '2017-03-08', 100, 126100),
(101, 1, '2017-03-09', 0, 126100),
(102, 1, '2017-03-10', 0, 126100),
(103, 1, '2017-03-11', 0, 126100),
(104, 1, '2017-03-12', 100, 126000),
(105, 1, '2017-03-13', 100, 126000),
(106, 1, '2017-03-14', 100, 125900),
(107, 1, '2017-03-15', 200, 125800),
(108, 1, '2017-03-17', 0, 125800);

-- --------------------------------------------------------

--
-- Table structure for table `exchange_options`
--

CREATE TABLE IF NOT EXISTS `exchange_options` (
`SN` int(11) NOT NULL,
  `LIVE` tinyint(1) NOT NULL DEFAULT '0' COMMENT 'whether it is live or demo account/tade. 0 means dem and 1 means live',
  `SELLER_ID` varchar(200) DEFAULT NULL,
  `BUYER_ID` varchar(200) DEFAULT NULL,
  `SELLER_USERNAME` varchar(200) DEFAULT NULL,
  `BUYER_USERNAME` varchar(200) DEFAULT NULL,
  `ORDER_TICKET` varchar(200) DEFAULT NULL,
  `METHOD` varchar(200) NOT NULL,
  `PENDING_ORDER_PRICE` float NOT NULL DEFAULT '0',
  `PRODUCT` varchar(200) DEFAULT NULL,
  `BUYER_ACTION` varchar(200) DEFAULT NULL,
  `SELLER_LOSABLE_AMT` float DEFAULT '0' COMMENT 'important! hold the amount the seller can loss in this trade',
  `BUYER_LOSABLE_AMT` float DEFAULT '0' COMMENT 'important! hold the amount the buyer can loss in this trade',
  `SYMBOL` varchar(200) DEFAULT NULL,
  `STRIKE` int(11) NOT NULL DEFAULT '0',
  `STRIKE_UP` int(11) NOT NULL DEFAULT '0',
  `STRIKE_DOWN` int(11) NOT NULL DEFAULT '0',
  `EXPIRY_VALUE` int(11) NOT NULL DEFAULT '0',
  `EXPIRY_UNIT` varchar(200) DEFAULT NULL,
  `SIZE` int(11) NOT NULL DEFAULT '0',
  `PRICE` float NOT NULL DEFAULT '0',
  `PREMIUM` float NOT NULL DEFAULT '0',
  `TIME` varchar(200) DEFAULT '1900-01-01 00:00:00' COMMENT 'important! must be VARCHAR and not DATETIME because of some internal isssues where local time is selected by knex against our wish.',
  `EXCHANGE_EXPIRY` varchar(200) NOT NULL DEFAULT '1900-01-01 00:00:00' COMMENT 'important! must be VARCHAR and not DATETIME because of some internal isssues where local time is selected by knex against our wish.',
  `CANCELLED` tinyint(1) NOT NULL DEFAULT '0',
  `DEL_BY_SELLER_ID` varchar(200) DEFAULT NULL COMMENT 'Only just marks the record as deleted by the seller. but the record is not actually deleted from the table. Takes the id of the seller for testing to ensure the record is no longer sent to him',
  `DEL_BY_BUYER_ID` varchar(200) DEFAULT NULL COMMENT 'Only just marks the record as deleted by the buyer. but the record is not actually deleted from the table. Takes the id of the buyer for testing to ensure the record is no longer sent to him'
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=123 ;

--
-- Dumping data for table `exchange_options`
--

INSERT INTO `exchange_options` (`SN`, `LIVE`, `SELLER_ID`, `BUYER_ID`, `SELLER_USERNAME`, `BUYER_USERNAME`, `ORDER_TICKET`, `METHOD`, `PENDING_ORDER_PRICE`, `PRODUCT`, `BUYER_ACTION`, `SELLER_LOSABLE_AMT`, `BUYER_LOSABLE_AMT`, `SYMBOL`, `STRIKE`, `STRIKE_UP`, `STRIKE_DOWN`, `EXPIRY_VALUE`, `EXPIRY_UNIT`, `SIZE`, `PRICE`, `PREMIUM`, `TIME`, `EXCHANGE_EXPIRY`, `CANCELLED`, `DEL_BY_SELLER_ID`, `DEL_BY_BUYER_ID`) VALUES
(91, 0, 'EXD001280', NULL, 'chuks3', NULL, 'ODT6116rkRJT774e', '', 0, 'DIGITAL CALL (ATM)', 'DIGITAL PUT (ATM)', 200000, 200000, 'AUD/USD', 0, 0, 0, 1, 'minutes', 200000, 20, 20, '2016-12-17 21:23:50', '2016-12-17 22:00:00', 0, NULL, NULL),
(92, 0, 'EXD001280', NULL, 'chuks3', NULL, 'ODT6116BkXrT7QVl', '', 0, 'RANGE OUT', 'RANGE IN', 90000, 90000, 'AUD/USD', 0, 20, -30, 1, '', 90000, 20, 20, '2016-12-17 21:25:15', '2016-12-17 22:00:00', 0, NULL, NULL),
(93, 0, 'EXD001280', NULL, 'chuks3', NULL, 'ODT6116BkwOpQm4l', '', 0, 'DIGITAL PUT (ATM)', 'DIGITAL CALL (ATM)', 1, 1, 'AUD/USD', 0, 0, 0, 1, '', 1, 20, 20, '2016-12-17 21:26:06', '2016-12-17 22:00:00', 0, NULL, NULL),
(94, 0, 'EXD001280', NULL, 'chuks3', NULL, 'ODT6116B1IPFVmNe', '', 0, 'RANGE OUT', 'RANGE IN', 1, 1, 'AUD/USD', 0, 30, -3, 1, 'seconds', 1, 20, 20, '2016-12-17 22:17:02', '2016-12-17 23:00:00', 0, 'EXD001280', NULL),
(95, 0, 'EXD001192', 'EXD001280', 'chuks2', 'chuks3', 'ODT0116rykmzGVEx', '', 0, 'DIGITAL CALL (OTM)', 'DIGITAL CALL (ITM)', 188, 188, 'GBP/USD', 34, 0, 0, 13, 'hours', 188, 20, 20, '2016-12-18 13:41:42', '2016-12-18 14:45:00', 0, NULL, NULL),
(96, 0, 'EXD386BJgGmr-xT', NULL, 'chuks', NULL, 'ODT3116B1_OGhvEe', '', 0, 'DIGITAL CALL (ATM)', 'DIGITAL PUT (ATM)', 100000, 100000, 'XAG/USD', 0, 0, 0, 1, 'seconds', 100000, 20, 20, '2016-12-21 07:42:40', '2016-12-21 08:00:00', 0, 'EXD386BJgGmr-xT', NULL),
(97, 0, 'EXD386BJgGmr-xT', NULL, 'chuks', NULL, 'ODT3116SyR_73vEg', '', 0, 'DIGITAL CALL (OTM)', 'DIGITAL CALL (ITM)', 499999, 499999, 'XAG/USD', 2, 0, 0, 1, 'seconds', 499999, 20, 20, '2016-12-21 07:47:02', '2016-12-21 08:00:00', 0, 'EXD386BJgGmr-xT', NULL),
(98, 0, 'EXD002530', 'EXD001280', 'o3', 'chuks3', 'ODT6116rJNRje2Ee', '', 0, 'DIGITAL CALL (OTM)', 'DIGITAL CALL (ITM)', 100, 100, 'EUR/USD', 3, 0, 0, 1, 'minutes', 100, 20, 20, '2016-12-24 13:44:43', '2016-12-24 13:47:00', 0, NULL, NULL),
(99, 0, 'EXD001280', 'EXD002530', 'chuks3', 'o3', 'ODT6116HyUXTe24e', '', 0, 'DIGITAL CALL (OTM)', 'DIGITAL CALL (ITM)', 100, 100, 'EUR/USD', 4, 0, 0, 1, 'minutes', 100, 20, 20, '2016-12-24 13:50:21', '2016-12-24 13:52:00', 0, NULL, NULL),
(100, 0, 'EXD001280', 'EXD002530', 'chuks3', 'o3', 'ODT6116HJQDCghNx', '', 0, 'DIGITAL CALL (ITM)', 'DIGITAL CALL (OTM)', 100, 100, 'EUR/USD', -3, 0, 0, 1, 'seconds', 100, 20, 20, '2016-12-24 13:55:38', '2016-12-24 13:57:00', 0, NULL, NULL),
(101, 0, 'EXD002530', 'EXD001280', 'o3', 'chuks3', 'ODT6116SkkpyZn4e', '', 0, 'DIGITAL CALL (OTM)', 'DIGITAL CALL (ITM)', 100, 100, 'EUR/USD', 1, 0, 0, 1, 'minutes', 100, 20, 20, '2016-12-24 14:01:26', '2016-12-24 14:02:00', 0, NULL, NULL),
(102, 0, 'EXD001280', 'EXD002530', 'chuks3', 'o3', 'ODT6116H11ZN-hNl', '', 0, 'DIGITAL CALL (OTM)', 'DIGITAL CALL (ITM)', 100, 100, 'EUR/USD', 2, 0, 0, 1, 'minutes', 100, 20, 20, '2016-12-24 14:19:34', '2016-12-24 14:21:00', 0, NULL, NULL),
(103, 0, 'EXD002530', 'EXD001280', 'o3', 'chuks3', 'ODT6116HknWBZ2Ee', '', 0, 'DIGITAL CALL (OTM)', 'DIGITAL CALL (ITM)', 100, 100, 'EUR/USD', 3, 0, 0, 1, 'minutes', 100, 20, 20, '2016-12-24 14:24:03', '2016-12-24 14:25:00', 0, NULL, NULL),
(104, 0, 'EXD002530', 'EXD001280', 'o3', 'chuks3', 'ODT6116Hy3lcZ3Vx', '', 0, 'DIGITAL CALL (OTM)', 'DIGITAL CALL (ITM)', 100, 100, 'EUR/USD', 10, 0, 0, 1, 'minutes', 100, 20, 20, '2016-12-24 14:45:07', '2016-12-24 14:47:00', 0, NULL, NULL),
(105, 0, 'EXD002530', 'EXD001280', 'o3', 'chuks3', 'ODT6116r1xGh-nEg', '', 0, 'DIGITAL CALL (OTM)', 'DIGITAL CALL (ITM)', 100, 100, 'EUR/USD', 10, 0, 0, 1, 'minutes', 100, 20, 20, '2016-12-24 14:54:00', '2016-12-24 14:55:00', 0, NULL, NULL),
(106, 0, 'EXD001280', 'EXD002530', 'chuks3', 'o3', 'ODT6116SJpe6-3Ne', '', 0, 'DIGITAL CALL (OTM)', 'DIGITAL CALL (ITM)', 100, 100, 'EUR/USD', 10, 0, 0, 1, 'minutes', 100, 20, 20, '2016-12-24 14:57:57', '2016-12-24 14:59:00', 0, NULL, NULL),
(107, 0, 'EXD002530', 'EXD001280', 'o3', 'chuks3', 'ODT6116rkLSkGh4g', '', 0, 'DIGITAL CALL (OTM)', 'DIGITAL CALL (ITM)', 100, 100, 'EUR/USD', 10, 0, 0, 1, 'minutes', 100, 20, 20, '2016-12-24 15:07:41', '2016-12-24 15:09:00', 0, NULL, NULL),
(108, 0, 'EXD001280', 'EXD002530', 'chuks3', 'o3', 'ODT6116Bk3zdG34x', '', 0, 'DIGITAL CALL (OTM)', 'DIGITAL CALL (ITM)', 100, 100, 'EUR/USD', 10, 0, 0, 1, 'minutes', 100, 20, 20, '2016-12-24 15:45:24', '2016-12-24 15:47:00', 0, NULL, NULL),
(109, 0, 'EXD002530', 'EXD001280', 'o3', 'chuks3', 'ODT6116HJuRTznVg', '', 0, 'DIGITAL CALL (OTM)', 'DIGITAL CALL (ITM)', 100, 100, 'EUR/USD', 10, 0, 0, 1, 'minutes', 100, 20, 20, '2016-12-24 16:09:52', '2016-12-24 16:11:00', 0, NULL, NULL),
(110, 0, 'EXD001192', NULL, 'chuks2', NULL, 'ODT1116r1QAOq0Vg', '', 0, 'DIGITAL CALL (OTM)', 'DIGITAL CALL (ITM)', 100, 100, 'EUR/USD', 20, 0, 0, 2, 'hours', 100, 20, 20, '2016-12-26 13:19:07', '2016-12-26 13:30:00', 0, NULL, NULL),
(111, 0, 'EXD001192', NULL, 'chuks2', NULL, 'ODT1116ryN4ocREg', '', 0, 'DIGITAL CALL (OTM)', 'DIGITAL PUT (ITM)', 100, 100, 'EUR/USD', 30, 0, 0, 2, 'hours', 100, 20, 20, '2016-12-26 13:29:16', '2016-12-26 13:45:00', 0, NULL, NULL),
(112, 0, 'EXD002750', 'EXD002848', 'p1', 'p2', 'ODT407HJALZVPwg', 'Price (Pending order)', 1.0734, 'DIGITAL CALL (ATM)', 'DIGITAL PUT (ATM)', 1000, 1000, 'EUR/USD', 0, 0, 0, 1, 'minutes', 1000, 21, 20, '2017-01-26 08:20:37', '2017-01-26 08:30:00', 0, NULL, NULL),
(113, 0, 'EXD002848', NULL, 'p2', NULL, 'ODT407BJ3zU4wPx', 'Price (Pending order)', 1.0739, 'DIGITAL CALL (OTM)', 'DIGITAL PUT (ITM)', 1000, 1000, 'EUR/USD', 5, 0, 0, 1, 'minutes', 1000, 20, 20, '2017-01-26 08:40:52', '2017-01-26 09:15:00', 1, NULL, NULL),
(114, 0, 'EXD002750', 'EXD002848', 'p1', 'p2', 'ODT407rJUpIVPPl', 'Price (Pending order)', 1.074, 'DIGITAL CALL (OTM)', 'DIGITAL PUT (ITM)', 1000, 1000, 'EUR/USD', 10, 0, 0, 1, 'minutes', 1000, 20, 20, '2017-01-26 08:43:41', '2017-01-26 09:15:00', 0, NULL, NULL),
(115, 0, 'EXD002848', 'EXD002750', 'p2', 'p1', 'ODT407SJV5dEvDg', 'Price (Pending order)', 1.074, 'DIGITAL CALL (OTM)', 'DIGITAL PUT (ITM)', 1000, 1000, 'EUR/USD', 10, 0, 0, 10, 'minutes', 1000, 20, 20, '2017-01-26 08:51:23', '2017-01-26 09:30:00', 0, NULL, NULL),
(116, 0, 'EXD002750', 'EXD002848', 'p1', 'p2', 'ODT407ByxjjVvvl', 'Price (Pending order)', 1.074, 'DIGITAL CALL (OTM)', 'DIGITAL PUT (ITM)', 1000, 1000, 'EUR/USD', 5, 0, 0, 10, 'minutes', 1000, 20, 20, '2017-01-26 09:04:23', '2017-01-26 10:00:00', 0, NULL, NULL),
(117, 0, 'EXD002750', 'EXD002848', 'p1', 'p2', 'ODT407SkJza4wve', 'Time (Countdown)', 0, 'DIGITAL CALL (ATM)', 'DIGITAL PUT (ATM)', 1000, 1000, 'EUR/USD', 0, 0, 0, 10, 'minutes', 1000, 20, 20, '2017-01-26 09:10:31', '2017-01-26 09:15:00', 0, NULL, NULL),
(118, 0, 'EXD002848', 'EXD002750', 'p2', 'p1', 'ODT407r1_TLHDvl', 'Time (Countdown)', 0, 'DIGITAL CALL (OTM)', 'DIGITAL PUT (ITM)', 1000, 1000, 'EUR/USD', 5, 0, 0, 10, 'minutes', 1000, 20, 20, '2017-01-26 09:51:59', '2017-01-26 10:00:00', 0, NULL, NULL),
(119, 0, 'EXD002952', 'EXD003346', 'op1', 'tt', 'ODT427BJsUtu89e', 'Time (Countdown)', 0, 'DIGITAL CALL (OTM)', 'DIGITAL PUT (ITM)', 100, 100, 'EUR/USD', 1, 0, 0, 1, 'minutes', 100, 20, 20, '2017-03-03 05:04:19', '2017-03-03 05:15:00', 0, NULL, NULL),
(120, 1, 'EXD427SJfU2HIqx', NULL, 'S1gG83SL5x', NULL, 'ODT227S1Jxznh9l', 'Time (Countdown)', 0, 'DIGITAL CALL (OTM)', 'DIGITAL PUT (ITM)', 200, 200, 'GBP/JPY', 5, 0, 0, 3, 'days', 200, 100, 20, '2017-03-07 22:19:19', '2017-03-07 23:00:00', 0, NULL, NULL),
(121, 1, 'EXD427SJfU2HIqx', NULL, 'S1gG83SL5x', NULL, 'ODT227rkR0N3nqg', 'Time (Countdown)', 0, 'ONE TOUCH (UP)', 'NO TOUCH (UP)', 300, 300, 'EUR/USD', 35, 0, 0, 7, 'days', 300, 50, 50, '2017-03-07 22:31:49', '2017-03-07 23:00:00', 0, NULL, NULL),
(122, 1, 'EXD427SJfU2HIqx', NULL, 'S1gG83SL5x', NULL, 'ODT327S1iabcTqe', 'Time (Countdown)', 0, 'DIGITAL PUT (ITM)', 'DIGITAL CALL (OTM)', 300, 300, 'EUR/CHF', 30, 0, 0, 27, 'hours', 300, 50, 50, '2017-03-08 14:14:27', '2017-03-08 21:00:00', 0, 'EXD427SJfU2HIqx', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `exchange_spotfx`
--

CREATE TABLE IF NOT EXISTS `exchange_spotfx` (
`SN` int(11) NOT NULL,
  `LIVE` tinyint(1) NOT NULL DEFAULT '0' COMMENT 'whether it is live or demo account/tade. 0 means dem and 1 means live',
  `SELLER_ID` varchar(200) DEFAULT NULL,
  `BUYER_ID` varchar(200) DEFAULT NULL,
  `SELLER_USERNAME` varchar(200) DEFAULT NULL,
  `BUYER_USERNAME` varchar(200) DEFAULT NULL,
  `ORDER_TICKET` varchar(200) DEFAULT NULL,
  `METHOD` varchar(200) NOT NULL,
  `PENDING_ORDER_PRICE` float NOT NULL DEFAULT '0',
  `DIRECTION` varchar(200) DEFAULT NULL,
  `BUYER_ACTION` varchar(200) DEFAULT NULL,
  `SELLER_LOSABLE_AMT` float DEFAULT '0' COMMENT 'important! hold the amount the seller can loss in this trade',
  `BUYER_LOSABLE_AMT` float DEFAULT '0' COMMENT 'important! hold the amount the buyer can loss in this trade',
  `SYMBOL` varchar(200) DEFAULT NULL,
  `STOP_LOSS` int(11) NOT NULL DEFAULT '0',
  `TAKE_PROFIT` int(11) NOT NULL DEFAULT '0',
  `TIME` varchar(200) NOT NULL DEFAULT '1900-01-01 00:00:00' COMMENT 'important! must be VARCHAR and not DATETIME because of some internal isssues where local time is selected by knex against our wish.',
  `EXCHANGE_EXPIRY` varchar(200) NOT NULL DEFAULT '1900-01-01 00:00:00' COMMENT 'important! must be VARCHAR and not DATETIME because of some internal isssues where local time is selected by knex against our wish.',
  `CANCELLED` tinyint(1) NOT NULL DEFAULT '0',
  `SIZE` int(11) NOT NULL DEFAULT '0',
  `DEL_BY_SELLER_ID` varchar(200) DEFAULT NULL COMMENT 'Only just marks the record as deleted by the Seller. but the record is not actually deleted from the table. Takes the id of the seller for testing to ensure the record is no longer sent to him',
  `DEL_BY_BUYER_ID` varchar(200) DEFAULT NULL COMMENT 'Only just marks the record as deleted by the buyer. but the record is not actually deleted from the table. Takes the id of the sbuyer for testing to ensure the record is no longer sent to him'
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=275 ;

--
-- Dumping data for table `exchange_spotfx`
--

INSERT INTO `exchange_spotfx` (`SN`, `LIVE`, `SELLER_ID`, `BUYER_ID`, `SELLER_USERNAME`, `BUYER_USERNAME`, `ORDER_TICKET`, `METHOD`, `PENDING_ORDER_PRICE`, `DIRECTION`, `BUYER_ACTION`, `SELLER_LOSABLE_AMT`, `BUYER_LOSABLE_AMT`, `SYMBOL`, `STOP_LOSS`, `TAKE_PROFIT`, `TIME`, `EXCHANGE_EXPIRY`, `CANCELLED`, `SIZE`, `DEL_BY_SELLER_ID`, `DEL_BY_BUYER_ID`) VALUES
(165, 0, 'EXD386H1qfL-la', 'EXD001192', 'chuks1', 'chuks2', 'ODT6116HkFP8QX4l', '', 0, 'BUY', 'SELL', 304166, 304166, 'AUD/USD', 20, 20, '2016-12-17 20:56:00', '2016-12-17 22:00:00', 0, 304166, NULL, NULL),
(166, 0, 'EXD001192', NULL, 'chuks2', NULL, 'ODT6116H1T0UXQNg', '', 0, 'BUY', 'SELL', 100000, 100000, 'AUD/USD', 20, 20, '2016-12-17 20:57:57', '2016-12-17 22:00:00', 0, 100000, NULL, NULL),
(167, 0, 'EXD001192', NULL, 'chuks2', NULL, 'ODT6116HkedPQmNe', '', 0, 'BUY', 'SELL', 200000, 200000, 'AUD/USD', 20, 20, '2016-12-17 21:00:24', '2016-12-17 22:00:00', 0, 200000, NULL, NULL),
(168, 0, 'EXD001192', NULL, 'chuks2', NULL, 'ODT6116r1qhPQ7Ee', '', 0, 'BUY', 'SELL', 35000, 35000, 'AUD/USD', 20, 20, '2016-12-17 21:01:38', '2016-12-17 22:00:00', 0, 35000, NULL, NULL),
(169, 0, 'EXD001280', NULL, 'chuks3', NULL, 'ODT6116S19B3774g', '', 0, 'BUY', 'SELL', 200000, 200000, 'AUD/USD', 20, 20, '2016-12-17 21:21:06', '2016-12-17 22:00:00', 0, 200000, NULL, NULL),
(170, 0, 'EXD001280', NULL, 'chuks3', NULL, 'ODT0116HJyIoB7Nl', '', 0, 'BUY', 'SELL', 400, 400, 'EUR/USD', 20, 20, '2016-12-17 23:33:27', '2016-12-17 23:55:00', 0, 400, 'EXD001280', NULL),
(171, 0, 'EXD001192', 'EXD001280', 'chuks2', 'chuks3', 'ODT0116SkSW7WENg', '', 0, 'BUY', 'SELL', 100, 100, 'EUR/USD', 20, 20, '2016-12-18 12:37:16', '2016-12-18 14:00:00', 0, 100, NULL, NULL),
(172, 0, 'EXD001192', 'EXD001280', 'chuks2', 'chuks3', 'ODT0116B10g9-NEx', '', 0, 'BUY', 'SELL', 1500, 1500, 'EUR/USD', 20, 20, '2016-12-18 13:07:02', '2016-12-18 14:15:00', 0, 1500, NULL, NULL),
(173, 0, 'EXD001192', 'EXD001280', 'chuks2', 'chuks3', 'ODT0116B1mnhZENg', '', 0, 'BUY', 'SELL', 100, 100, 'EUR/USD', 20, 20, '2016-12-18 13:18:35', '2016-12-18 14:30:00', 0, 100, NULL, NULL),
(174, 0, 'EXD001192', 'EXD001280', 'chuks2', 'chuks3', 'ODT0116ryQfAW44e', '', 0, 'BUY', 'SELL', 400, 400, 'EUR/USD', 20, 20, '2016-12-18 13:24:27', '2016-12-18 14:45:00', 0, 400, NULL, NULL),
(175, 0, 'EXD001192', 'EXD001280', 'chuks2', 'chuks3', 'ODT1116SkGMRlSEe', '', 0, 'BUY', 'SELL', 100, 100, 'EUR/USD', 20, 20, '2016-12-19 06:28:26', '2016-12-19 07:15:00', 0, 100, NULL, NULL),
(176, 0, 'EXD001192', 'EXD001280', 'chuks2', 'chuks3', 'ODT1116SyLPWZHNl', '', 0, 'BUY', 'SELL', 100, 100, 'GBP/USD', 20, 20, '2016-12-19 06:42:37', '2016-12-19 07:45:00', 0, 100, NULL, NULL),
(177, 0, 'EXD001192', 'EXD001280', 'chuks2', 'chuks3', 'ODT1116rybMhbH4l', '', 0, 'BUY', 'SELL', 200, 200, 'EUR/USD', 20, 20, '2016-12-19 07:28:08', '2016-12-19 08:30:00', 0, 200, NULL, NULL),
(178, 0, 'EXD001192', 'EXD001280', 'chuks2', 'chuks3', 'ODT1116HkXTAbSEl', '', 0, 'SELL', 'BUY', 1000, 1000, 'EUR/USD', 20, 20, '2016-12-19 07:39:38', '2016-12-19 08:45:00', 0, 1000, NULL, NULL),
(179, 0, 'EXD001192', 'EXD001280', 'chuks2', 'chuks3', 'ODT1116BJyUz0S4g', '', 0, 'BUY', 'SELL', 100, 100, 'EUR/USD', 20, 20, '2016-12-19 21:33:58', '2016-12-19 22:45:00', 0, 100, NULL, NULL),
(180, 0, 'EXD001192', 'EXD001280', 'chuks2', 'chuks3', 'ODT2116Hkd4VywNe', '', 0, 'BUY', 'SELL', 1000, 1000, 'EUR/USD', 20, 20, '2016-12-20 17:02:39', '2016-12-20 17:45:00', 0, 1000, NULL, NULL),
(181, 0, 'EXD386BJgGmr-xT', NULL, 'chuks', NULL, 'ODT3116H1_aKIPNe', '', 0, 'BUY', 'SELL', 450000, 450000, 'XAG/USD', 20, 20, '2016-12-21 01:24:15', '2016-12-21 02:00:00', 0, 90000, 'EXD386BJgGmr-xT', NULL),
(182, 0, 'EXD386BJgGmr-xT', NULL, 'chuks', NULL, 'ODT3116r1UpDDDNg', '', 0, 'BUY', 'SELL', 100000, 100000, 'EUR/USD', 20, 20, '2016-12-21 02:23:57', '2016-12-21 02:45:00', 0, 100000, NULL, NULL),
(183, 0, 'EXD386BJgGmr-xT', NULL, 'chuks', NULL, 'ODT3116BJKs9iwNe', '', 0, 'BUY', 'SELL', 400000, 400000, 'EUR/USD', 20, 20, '2016-12-21 07:09:20', '2016-12-21 08:00:00', 0, 400000, 'EXD386BJgGmr-xT', NULL),
(184, 0, 'EXD386BJgGmr-xT', NULL, 'chuks', NULL, 'ODT3116Hkexijw4e', '', 0, 'BUY', 'SELL', 499999, 499999, 'EUR/USD', 20, 20, '2016-12-21 07:10:31', '2016-12-21 08:00:00', 0, 499999, 'EXD386BJgGmr-xT', NULL),
(185, 0, 'EXD386BJgGmr-xT', NULL, 'chuks', NULL, 'ODT3116HkFYjswVe', '', 0, 'BUY', 'SELL', 499999, 499999, 'EUR/USD', 100, 100, '2016-12-21 07:13:05', '2016-12-21 08:00:00', 0, 499999, 'EXD386BJgGmr-xT', NULL),
(186, 0, 'EXD386BJgGmr-xT', NULL, 'chuks', NULL, 'ODT3116rkuxyhwEe', '', 0, 'BUY', 'SELL', 450000, 450000, 'XAG/USD', 100, 100, '2016-12-21 07:27:44', '2016-12-21 08:00:00', 0, 90000, 'EXD386BJgGmr-xT', NULL),
(187, 0, 'EXD386BJgGmr-xT', NULL, 'chuks', NULL, 'ODT3116H1j0xnPEg', '', 0, 'BUY', 'SELL', 450000, 450000, 'XAG/USD', 20, 100, '2016-12-21 07:35:47', '2016-12-21 08:00:00', 0, 90000, 'EXD386BJgGmr-xT', NULL),
(188, 0, 'EXD002530', NULL, 'o3', NULL, 'ODT3116SyhBZnvEl', '', 0, 'BUY', 'SELL', 100000, 100000, 'EUR/USD', 20, 20, '2016-12-21 07:37:39', '2016-12-21 08:00:00', 0, 100000, 'EXD002530', NULL),
(189, 0, 'EXD001192', 'EXD001280', 'chuks2', 'chuks3', 'ODT4116SJfcfVKEg', '', 0, 'BUY', 'SELL', 100, 100, 'EUR/USD', 20, 20, '2016-12-22 11:01:30', '2016-12-22 11:03:00', 0, 100, NULL, NULL),
(190, 0, 'EXD001192', 'EXD001280', 'chuks2', 'chuks3', 'ODT4116BkS_wEt4x', '', 0, 'BUY', 'SELL', 100, 100, 'EUR/USD', 20, 20, '2016-12-22 11:22:20', '2016-12-22 11:25:00', 0, 100, NULL, NULL),
(191, 0, 'EXD001192', 'EXD001280', 'chuks2', 'chuks3', 'ODT4116Bk0Vd4KNx', '', 0, 'BUY', 'SELL', 100, 100, 'EUR/USD', 20, 20, '2016-12-22 11:25:42', '2016-12-22 11:45:00', 0, 100, NULL, NULL),
(192, 0, 'EXD001192', 'EXD001280', 'chuks2', 'chuks3', 'ODT4116ryNdvDKEl', '', 0, 'BUY', 'SELL', 100, 100, 'EUR/USD', 20, 20, '2016-12-22 14:47:08', '2016-12-22 14:50:00', 0, 100, NULL, NULL),
(193, 0, 'EXD001192', 'EXD001280', 'chuks2', 'chuks3', 'ODT4116SJtpKDtVx', '', 0, 'BUY', 'SELL', 100, 100, 'EUR/USD', 20, 20, '2016-12-22 14:57:05', '2016-12-22 15:00:00', 0, 100, NULL, NULL),
(194, 0, 'EXD001192', 'EXD001280', 'chuks2', 'chuks3', 'ODT4116rkKdUjYVl', '', 0, 'BUY', 'SELL', 100, 100, 'EUR/USD', 20, 20, '2016-12-22 19:16:00', '2016-12-22 19:20:00', 0, 100, NULL, NULL),
(195, 0, 'EXD001192', NULL, 'chuks2', NULL, 'ODT5116ry_bcsq4g', '', 0, 'BUY', 'SELL', 10, 10, 'EUR/USD', 20, 20, '2016-12-23 13:43:28', '2016-12-23 14:15:00', 0, 10, NULL, NULL),
(196, 0, 'EXD001192', NULL, 'chuks2', NULL, 'ODT6116ryW2nToNg', '', 0, 'BUY', 'SELL', 100, 100, 'EUR/USD', 20, 20, '2016-12-24 10:23:36', '2016-12-24 10:30:00', 0, 100, NULL, NULL),
(197, 0, 'EXD001192', NULL, 'chuks2', NULL, 'ODT6116Bk0_40s4e', '', 0, 'BUY', 'SELL', 100, 100, 'EUR/USD', 20, 20, '2016-12-24 10:56:54', '2016-12-24 12:15:00', 0, 100, NULL, NULL),
(198, 0, 'EXD001192', NULL, 'chuks2', NULL, 'ODT2116BJk_2WgSl', '', 0, 'BUY', 'SELL', 10, 10, 'XAU/USD', 200, 200, '2016-12-27 15:44:39', '2016-12-27 16:00:00', 0, 100, NULL, NULL),
(199, 0, 'EXD001192', NULL, 'chuks2', NULL, 'ODT2116rJpVMQeSx', '', 0, 'BUY', 'SELL', 100, 100, 'EUR/USD', 20, 20, '2016-12-27 17:17:40', '2016-12-27 17:40:00', 0, 100, NULL, NULL),
(200, 0, 'EXD001192', 'EXD001280', 'chuks2', 'chuks3', 'ODT2116BJn4TmgBx', '', 0, 'BUY', 'SELL', 100, 100, 'EUR/USD', 20, 20, '2016-12-27 18:04:36', '2016-12-27 18:10:00', 0, 100, NULL, NULL),
(201, 0, 'EXD001192', 'EXD001280', 'chuks2', 'chuks3', 'ODT407H1Hcqmr8l', 'Time (Countdown)', 0, 'BUY', 'SELL', 100, 100, 'EUR/USD', 20, 20, '2017-01-12 16:10:52', '2017-01-12 17:15:00', 0, 100, NULL, NULL),
(202, 0, 'EXD001192', 'EXD001280', 'chuks2', 'chuks3', 'ODT407HJlXvVBLg', 'Time (Countdown)', 0, 'BUY', 'SELL', 100, 100, 'EUR/USD', 20, 20, '2017-01-12 17:04:24', '2017-01-12 17:10:00', 0, 100, NULL, NULL),
(203, 0, 'EXD001192', 'EXD001280', 'chuks2', 'chuks3', 'ODT407BkV8mrHLg', 'Time (Countdown)', 0, 'BUY', 'SELL', 100, 100, 'GBP/USD', 20, 20, '2017-01-12 17:56:27', '2017-01-12 18:00:00', 0, 100, NULL, NULL),
(204, 0, 'EXD001192', 'EXD001280', 'chuks2', 'chuks3', 'ODT407BJssPBHIx', 'Price (Pending order)', 1.44, 'BUY', 'SELL', 100, 100, 'AUD/USD', 20, 20, '2017-01-12 18:14:58', '2017-01-12 18:17:00', 0, 100, NULL, NULL),
(205, 0, 'EXD001192', 'EXD001280', 'chuks2', 'chuks3', 'ODT407rJHFmDS8e', 'Price (Pending order)', 1.43, 'BUY', 'SELL', 100, 100, 'GBP/USD', 20, 20, '2017-01-12 20:13:48', '2017-01-12 21:16:00', 0, 100, NULL, NULL),
(206, 0, 'EXD001192', 'EXD001280', 'chuks2', 'chuks3', 'ODT407BJs3BvHLx', 'Price (Pending order)', 0, 'BUY', 'SELL', 300, 300, 'EUR/USD', 20, 20, '2017-01-12 20:23:15', '2017-01-12 21:30:00', 0, 300, NULL, NULL),
(207, 0, 'EXD001192', NULL, 'chuks2', NULL, 'ODT407HknvFPrLe', 'Price (Pending order)', 0, 'BUY', 'SELL', 150, 150, 'GBP/USD', 20, 20, '2017-01-12 20:38:59', '2017-01-12 20:45:00', 0, 150, NULL, NULL),
(208, 0, 'EXD001192', NULL, 'chuks2', NULL, 'ODT407ryl45DrLe', 'Price (Pending order)', 0, 'BUY', 'SELL', 100, 100, 'GBP/USD', 20, 20, '2017-01-12 20:42:16', '2017-01-12 20:45:00', 0, 100, NULL, NULL),
(209, 0, 'EXD001192', 'EXD001280', 'chuks2', 'chuks3', 'ODT407S187hwSIx', 'Price (Pending order)', 1.43, 'BUY', 'SELL', 1400, 1400, 'EUR/USD', 20, 20, '2017-01-12 20:50:38', '2017-01-12 20:55:00', 0, 1400, NULL, NULL),
(210, 0, 'EXD001192', 'EXD001280', 'chuks2', 'chuks3', 'ODT407B1HaHFr8l', 'Price (Pending order)', 1.43, 'BUY', 'SELL', 100, 100, 'GBP/USD', 20, 20, '2017-01-12 22:39:57', '2017-01-12 22:45:00', 0, 100, NULL, NULL),
(211, 0, 'EXD001192', 'EXD001280', 'chuks2', 'chuks3', 'ODT407By3uOKBUg', 'Price (Pending order)', 1.43, 'BUY', 'SELL', 700, 700, 'EUR/USD', 20, 20, '2017-01-12 22:51:31', '2017-01-12 22:55:00', 0, 700, NULL, NULL),
(212, 0, 'EXD001192', 'EXD001280', 'chuks2', 'chuks3', 'ODT507Sy05l9r8g', 'Price (Pending order)', 1.43, 'BUY', 'SELL', 1000, 1000, 'GBP/USD', 30, 30, '2017-01-12 23:26:14', '2017-01-12 23:45:00', 0, 1000, NULL, NULL),
(213, 0, 'EXD001192', 'EXD001280', 'chuks2', 'chuks3', 'ODT507BJMDz9SLl', 'Price (Pending order)', 1.43, 'BUY', 'SELL', 1000, 1000, 'EUR/USD', 20, 20, '2017-01-12 23:33:46', '2017-01-12 23:45:00', 0, 1000, NULL, NULL),
(214, 0, 'EXD001192', 'EXD001280', 'chuks2', 'chuks3', 'ODT507SJE2bWU8g', 'Price (Pending order)', 1.43, 'BUY', 'SELL', 900, 900, 'EUR/USD', 20, 20, '2017-01-13 07:28:44', '2017-01-13 07:35:00', 0, 900, NULL, NULL),
(215, 0, 'EXD001192', 'EXD001280', 'chuks2', 'chuks3', 'ODT507BJY2_D8Ux', 'Price (Pending order)', 1.43, 'BUY', 'SELL', 100, 100, 'EUR/USD', 20, 20, '2017-01-13 14:48:17', '2017-01-13 15:30:00', 0, 100, NULL, NULL),
(216, 0, 'EXD001192', 'EXD001280', 'chuks2', 'chuks3', 'ODT507ByW-xOL8g', 'Price (Pending order)', 1.4385, 'BUY', 'SELL', 100, 100, 'EUR/USD', 20, 20, '2017-01-13 15:19:21', '2017-01-13 15:22:00', 0, 100, NULL, NULL),
(217, 0, 'EXD001192', 'EXD001280', 'chuks2', 'chuks3', 'ODT507HJHOicLUl', 'Price (Pending order)', 1.437, 'BUY', 'SELL', 100, 100, 'EUR/USD', 20, 20, '2017-01-13 18:24:45', '2017-01-13 18:30:00', 0, 100, NULL, NULL),
(218, 0, 'EXD001192', 'EXD001280', 'chuks2', 'chuks3', 'ODT007H1OF2NYUx', 'Price (Pending order)', 1.437, 'BUY', 'SELL', 100, 100, 'EUR/USD', 20, 20, '2017-01-15 18:16:31', '2017-01-15 18:30:00', 0, 100, NULL, NULL),
(219, 0, 'EXD001192', 'EXD001280', 'chuks2', 'chuks3', 'ODT007B1ty1SY8e', 'Price (Pending order)', 1.437, 'BUY', 'SELL', 100, 100, 'EUR/USD', 20, 20, '2017-01-15 18:26:40', '2017-01-15 18:35:00', 0, 100, NULL, NULL),
(220, 0, 'EXD001192', 'EXD001280', 'chuks2', 'chuks3', 'ODT007Hkn5yHKLx', 'Price (Pending order)', 1.437, 'BUY', 'SELL', 100, 100, 'EUR/USD', 20, 20, '2017-01-15 18:29:40', '2017-01-15 18:45:00', 0, 100, NULL, NULL),
(221, 0, 'EXD001192', 'EXD001280', 'chuks2', 'chuks3', 'ODT007BkkqHHF8l', 'Price (Pending order)', 1.437, 'BUY', 'SELL', 100, 100, 'EUR/USD', 20, 20, '2017-01-15 18:55:03', '2017-01-15 19:00:00', 0, 100, NULL, NULL),
(222, 0, 'EXD001192', 'EXD001280', 'chuks2', 'chuks3', 'ODT007Bkzd_rKLl', 'Price (Pending order)', 1.437, 'BUY', 'SELL', 100, 100, 'EUR/USD', 20, 20, '2017-01-15 19:07:21', '2017-01-15 19:11:00', 0, 100, NULL, NULL),
(223, 0, 'EXD001192', 'EXD001280', 'chuks2', 'chuks3', 'ODT007SJ2uKStLg', 'Price (Pending order)', 1.437, 'BUY', 'SELL', 100, 100, 'EUR/USD', 20, 20, '2017-01-15 19:11:48', '2017-01-15 19:20:00', 0, 100, NULL, NULL),
(224, 0, 'EXD001192', 'EXD001280', 'chuks2', 'chuks3', 'ODT307rJJhuu2Ll', 'Price (Pending order)', 1.439, 'BUY', 'SELL', 100, 100, 'EUR/USD', 20, 20, '2017-01-18 05:09:59', '2017-01-18 05:15:00', 0, 100, NULL, NULL),
(225, 0, 'EXD001192', 'EXD001280', 'chuks2', 'chuks3', 'ODT307S1yrKuhUe', 'Price (Pending order)', 1.437, 'BUY', 'SELL', 100, 100, 'EUR/USD', 20, 20, '2017-01-18 05:12:23', '2017-01-18 05:18:00', 0, 100, NULL, NULL),
(226, 0, 'EXD001192', NULL, 'chuks2', NULL, 'ODT307BJ8Yh_hUl', 'Price (Pending order)', 1.437, 'BUY', 'SELL', 100, 100, 'GBP/USD', 20, 20, '2017-01-18 05:26:21', '2017-01-18 05:30:00', 0, 100, NULL, NULL),
(227, 0, 'EXD001192', NULL, 'chuks2', NULL, 'ODT507S1MnqSkwe', 'Price (Pending order)', 1.437, 'BUY', 'SELL', 100, 100, 'EUR/USD', 20, 20, '2017-01-20 08:30:34', '2017-01-20 09:00:00', 0, 100, NULL, NULL),
(228, 0, 'EXD001192', NULL, 'chuks2', NULL, 'ODT507rJhM3Skwg', 'Price (Pending order)', 1.437, 'BUY', 'SELL', 100, 100, 'EUR/USD', 20, 20, '2017-01-20 08:36:36', '2017-01-20 09:15:00', 0, 100, NULL, NULL),
(229, 0, 'EXD001192', NULL, 'chuks2', NULL, 'ODT507Sk_u3r1De', 'Price (Pending order)', 1.437, 'BUY', 'SELL', 100, 100, 'EUR/USD', 20, 20, '2017-01-20 08:38:08', '2017-01-20 09:15:00', 0, 100, NULL, NULL),
(230, 0, 'EXD001192', NULL, 'chuks2', NULL, 'ODT507r1PW6BkDx', 'Price (Pending order)', 1.437, 'BUY', 'SELL', 100, 100, 'EUR/USD', 20, 20, '2017-01-20 08:40:30', '2017-01-20 10:15:00', 0, 100, NULL, NULL),
(231, 0, 'EXD001192', NULL, 'chuks2', NULL, 'ODT507rkaN6ryve', 'Price (Pending order)', 1.437, 'BUY', 'SELL', 100, 100, 'EUR/USD', 20, 20, '2017-01-20 08:41:24', '2017-01-20 09:30:00', 0, 100, NULL, NULL),
(232, 0, 'EXD001192', NULL, 'chuks2', NULL, 'ODT507ByuiaB1vx', 'Price (Pending order)', 1.437, 'BUY', 'SELL', 100, 100, 'EUR/USD', 20, 20, '2017-01-20 08:43:12', '2017-01-20 11:45:00', 0, 100, NULL, NULL),
(233, 0, 'EXD001192', NULL, 'chuks2', NULL, 'ODT507rkgK1UkDx', 'Price (Pending order)', 1.437, 'BUY', 'SELL', 100, 100, 'EUR/USD', 20, 20, '2017-01-20 08:51:04', '2017-01-20 10:30:00', 0, 100, NULL, NULL),
(234, 0, 'EXD001192', NULL, 'chuks2', NULL, 'ODT507SJkv-UJwg', 'Price (Pending order)', 1.43, 'BUY', 'SELL', 100, 100, 'EUR/USD', 20, 20, '2017-01-20 08:59:02', '2017-01-20 12:30:00', 1, 100, NULL, NULL),
(235, 0, 'EXD002750', NULL, 'p1', NULL, 'ODT407SJteV4DPl', 'Price (Pending order)', 1.074, 'BUY', 'SELL', 1000, 1000, 'EUR/USD', 20, 20, '2017-01-26 08:31:45', '2017-01-26 09:00:00', 1, 1000, NULL, NULL),
(236, 0, 'EXD002750', NULL, 'p1', NULL, 'ODT407S1vH4Vvwl', 'Price (Pending order)', 1.074, 'BUY', 'SELL', 1000, 1000, 'EUR/USD', 20, 20, '2017-01-26 08:33:02', '2017-01-26 09:00:00', 1, 1000, NULL, NULL),
(237, 0, 'EXD002750', 'EXD002848', 'p1', 'p2', 'ODT407rJfjaVPPg', 'Time (Countdown)', 0, 'BUY', 'SELL', 1000, 1000, 'EUR/USD', 20, 20, '2017-01-26 09:12:57', '2017-01-26 09:15:00', 0, 1000, NULL, NULL),
(238, 0, 'EXD002750', 'EXD002848', 'p1', 'p2', 'ODT407By7A0EDwe', 'Time (Countdown)', 0, 'BUY', 'SELL', 1000, 1000, 'EUR/USD', 20, 20, '2017-01-26 09:18:03', '2017-01-26 09:30:00', 0, 1000, NULL, NULL),
(239, 0, 'EXD002750', 'EXD002848', 'p1', 'p2', 'ODT407r1XZJrPPl', 'Time (Countdown)', 0, 'BUY', 'SELL', 1000, 1000, 'EUR/USD', 20, 20, '2017-01-26 09:18:51', '2017-01-26 09:30:00', 0, 1000, NULL, NULL),
(240, 0, 'EXD002750', 'EXD002848', 'p1', 'p2', 'ODT407BJlKGSvPl', 'Time (Countdown)', 0, 'BUY', 'SELL', 1000, 1000, 'EUR/USD', 20, 20, '2017-01-26 09:33:44', '2017-01-26 10:00:00', 0, 1000, NULL, NULL),
(241, 0, 'EXD386BJgGmr-xT', NULL, 'chuks', NULL, 'ODT117HJ8sp1YYg', 'Time (Countdown)', 0, 'BUY', 'SELL', 100, 100, 'EUR/USD', 20, 20, '2017-02-20 22:28:45', '2017-02-20 22:30:00', 0, 100, 'EXD386BJgGmr-xT', NULL),
(242, 0, 'EXD002952', 'EXD003346', 'op1', 'tt', 'ODT427HknHO_Lql', 'Time (Countdown)', 0, 'BUY', 'SELL', 100, 100, 'EUR/USD', 20, 20, '2017-03-03 04:59:47', '2017-03-03 05:15:00', 0, 100, NULL, NULL),
(243, 1, 'EXD427HykO_SUqg', NULL, 'HJlJ_urLqg', NULL, 'ODT127HJvTWmjqx', 'Price (Pending order)', 1.062, 'SELL', 'BUY', 100, 100, 'EUR/USD', 20, 100, '2017-03-06 17:51:59', '2017-03-06 18:00:00', 0, 100, NULL, NULL),
(244, 1, 'EXD427HykO_SUqg', NULL, 'HJlJ_urLqg', NULL, 'ODT127rJ4oBNo5x', 'Price (Pending order)', 1.064, 'SELL', 'BUY', 100, 100, 'EUR/USD', 20, 100, '2017-03-06 19:16:43', '2017-03-06 19:30:00', 0, 100, NULL, NULL),
(245, 1, 'EXD427SJfU2HIqx', NULL, 'S1gG83SL5x', NULL, 'ODT127B1wGRTi5e', 'Time (Countdown)', 0, 'BUY', 'SELL', 1000, 1000, 'EUR/USD', 30, 30, '2017-03-07 06:07:10', '2017-03-07 15:00:00', 0, 1000, NULL, NULL),
(246, 1, 'EXD427SJfU2HIqx', NULL, 'S1gG83SL5x', NULL, 'ODT127SJ-KR6i5g', 'Time (Countdown)', 0, 'SELL', 'BUY', 1000, 1000, 'GBP/USD', 50, 50, '2017-03-07 06:08:56', '2017-03-07 15:00:00', 0, 1000, NULL, NULL),
(247, 1, 'EXD427SJfU2HIqx', 'EXD427HykO_SUqg', 'S1gG83SL5x', 'HJlJ_urLqg', 'ODT127rJ8nC6j9e', 'Time (Countdown)', 0, 'SELL', 'BUY', 849, 849, 'GBP/JPY', 50, 50, '2017-03-07 06:09:49', '2017-03-07 15:00:00', 0, 1000, NULL, NULL),
(248, 1, 'EXD427SJfU2HIqx', NULL, 'S1gG83SL5x', NULL, 'ODT227B1HDm239x', 'Time (Countdown)', 0, 'SELL', 'BUY', 972, 972, 'USD/CHF', 40, 40, '2017-03-07 22:25:32', '2017-03-07 23:00:00', 0, 1000, NULL, NULL),
(249, 1, 'EXD427SJfU2HIqx', NULL, 'S1gG83SL5x', NULL, 'ODT227SJh-En3ql', 'Time (Countdown)', 0, 'SELL', 'BUY', 848, 848, 'USD/JPY', 40, 40, '2017-03-07 22:28:20', '2017-03-07 23:00:00', 0, 1000, NULL, NULL),
(250, 1, 'EXD427SJfU2HIqx', NULL, 'S1gG83SL5x', NULL, 'ODT227SkWrVnnqg', 'Time (Countdown)', 0, 'BUY', 'SELL', 1000, 1000, 'GBP/USD', 50, 50, '2017-03-07 22:29:13', '2017-03-07 23:00:00', 0, 1000, NULL, NULL),
(251, 1, 'EXD427SJfU2HIqx', NULL, 'S1gG83SL5x', NULL, 'ODT327B1QBCtp5x', 'Time (Countdown)', 0, 'SELL', 'BUY', 1000, 1000, 'GBP/USD', 50, 50, '2017-03-08 13:59:22', '2017-03-08 20:00:00', 0, 1000, 'EXD427SJfU2HIqx', NULL),
(252, 1, 'EXD427SJfU2HIqx', NULL, 'S1gG83SL5x', NULL, 'ODT327HJJcAKpce', 'Time (Countdown)', 0, 'SELL', 'BUY', 849, 849, 'GBP/JPY', 50, 50, '2017-03-08 14:00:38', '2017-03-08 21:15:00', 0, 1000, 'EXD427SJfU2HIqx', NULL),
(253, 1, 'EXD427SJfU2HIqx', NULL, 'S1gG83SL5x', NULL, 'ODT427ByQqd0kil', 'Time (Countdown)', 0, 'SELL', 'BUY', 1000, 1000, 'EUR/USD', 50, 50, '2017-03-10 07:40:58', '2017-03-10 11:00:00', 0, 1000, NULL, NULL),
(254, 1, 'EXD427SJfU2HIqx', 'EXD427HykO_SUqg', 'S1gG83SL5x', 'HJlJ_urLqg', 'ODT427SJj-KA1sx', 'Time (Countdown)', 0, 'SELL', 'BUY', 1000, 1000, 'GBP/USD', 50, 50, '2017-03-10 07:42:59', '2017-03-10 11:05:00', 0, 1000, NULL, NULL),
(255, 1, 'EXD427SJfU2HIqx', NULL, 'S1gG83SL5x', NULL, 'ODT427HkdNF0ysx', 'Time (Countdown)', 0, 'SELL', 'BUY', 849, 849, 'GBP/JPY', 50, 50, '2017-03-10 07:43:43', '2017-03-10 11:10:00', 0, 1000, NULL, NULL),
(256, 1, 'EXD427SJfU2HIqx', NULL, 'S1gG83SL5x', NULL, 'ODT427SyuOFAJie', 'Time (Countdown)', 0, 'BUY', 'SELL', 848, 848, 'USD/JPY', 50, 50, '2017-03-10 07:44:48', '2017-03-10 11:15:00', 0, 1000, NULL, NULL),
(257, 1, 'EXD427SJfU2HIqx', NULL, 'S1gG83SL5x', NULL, 'ODT427SyCntC1je', 'Time (Countdown)', 0, 'SELL', 'BUY', 748, 748, 'EUR/CAD', 50, 50, '2017-03-10 07:45:57', '2017-03-10 11:20:00', 0, 1000, NULL, NULL),
(258, 1, 'EXD427SJfU2HIqx', NULL, 'S1gG83SL5x', NULL, 'ODT527HyJUT7lsx', 'Time (Countdown)', 0, 'BUY', 'SELL', 972, 972, 'USD/CHF', 40, 40, '2017-03-10 13:42:31', '2017-03-10 14:00:00', 0, 1000, NULL, NULL),
(259, 1, 'EXD427SJfU2HIqx', NULL, 'S1gG83SL5x', NULL, 'ODT527SJmk0mgol', 'Time (Countdown)', 0, 'SELL', 'BUY', 1000, 1000, 'EUR/USD', 50, 50, '2017-03-10 13:44:59', '2017-03-10 14:00:00', 0, 1000, NULL, NULL),
(260, 1, 'EXD427SJfU2HIqx', NULL, 'S1gG83SL5x', NULL, 'ODT127r1lKGH4ox', 'Time (Countdown)', 0, 'SELL', 'BUY', 1000, 1000, 'GBP/USD', 50, 40, '2017-03-13 16:02:00', '2017-03-13 23:00:00', 0, 1000, 'EXD427SJfU2HIqx', NULL),
(261, 0, 'EXD386H1qfL-la', 'EXD001192', 'chuks1', 'chuks2', 'ODT127S1T24krsx', 'Time (Countdown)', 0, 'BUY', 'SELL', 100, 100, 'EUR/USD', 20, 20, '2017-03-14 03:34:12', '2017-03-14 03:45:00', 0, 100, NULL, NULL),
(262, 1, 'EXD427SJfU2HIqx', 'EXD427HykO_SUqg', 'S1gG83SL5x', 'HJlJ_urLqg', 'ODT227HysGBmBje', 'Time (Countdown)', 0, 'BUY', 'SELL', 1000, 1000, 'GBP/USD', 50, 50, '2017-03-14 08:08:51', '2017-03-14 15:00:00', 0, 1000, NULL, NULL),
(263, 1, 'EXD427SJfU2HIqx', NULL, 'S1gG83SL5x', NULL, 'ODT227HJwBrXrsl', 'Time (Countdown)', 0, 'BUY', 'SELL', 1000, 1000, 'EUR/USD', 40, 40, '2017-03-14 08:09:35', '2017-03-14 15:05:00', 0, 1000, NULL, NULL),
(264, 1, 'EXD427SJfU2HIqx', NULL, 'S1gG83SL5x', NULL, 'ODT227ByQqSmBsl', 'Time (Countdown)', 0, 'BUY', 'SELL', 849, 849, 'GBP/JPY', 50, 50, '2017-03-14 08:10:51', '2017-03-14 15:15:00', 0, 1000, NULL, NULL),
(265, 1, 'EXD427SJfU2HIqx', NULL, 'S1gG83SL5x', NULL, 'ODT327SJyvawLil', 'Time (Countdown)', 0, 'BUY', 'SELL', 1000, 1000, 'EUR/USD', 50, 50, '2017-03-15 07:29:26', '2017-03-15 09:00:00', 0, 1000, 'EXD427SJfU2HIqx', NULL),
(266, 1, 'EXD427SJfU2HIqx', NULL, 'S1gG83SL5x', NULL, 'ODT327HJ75TvUjl', 'Time (Countdown)', 0, 'BUY', 'SELL', 972, 972, 'USD/CHF', 50, 50, '2017-03-15 07:30:19', '2017-03-15 09:05:00', 0, 1000, 'EXD427SJfU2HIqx', NULL),
(267, 1, 'EXD427SJfU2HIqx', NULL, 'S1gG83SL5x', NULL, 'ODT327BkIpaw8ig', 'Time (Countdown)', 0, 'SELL', 'BUY', 1000, 1000, 'GBP/USD', 50, 50, '2017-03-15 07:31:10', '2017-03-15 09:10:00', 0, 1000, NULL, NULL),
(268, 1, 'EXD427SJfU2HIqx', NULL, 'S1gG83SL5x', NULL, 'ODT327SkfG-uLsx', 'Time (Countdown)', 0, 'SELL', 'BUY', 1000, 1000, 'EUR/USD', 50, 50, '2017-03-15 07:45:14', '2017-03-15 09:00:00', 0, 1000, NULL, NULL),
(269, 1, 'EXD427SJfU2HIqx', 'EXD427HykO_SUqg', 'S1gG83SL5x', 'HJlJ_urLqg', 'ODT327ryxrZdUsg', 'Time (Countdown)', 0, 'SELL', 'BUY', 972, 972, 'USD/CHF', 50, 50, '2017-03-15 07:45:59', '2017-03-15 09:05:00', 0, 1000, NULL, NULL),
(270, 1, 'EXD427SJfU2HIqx', NULL, 'S1gG83SL5x', NULL, 'ODT427rkbGPiwsx', 'Time (Countdown)', 0, 'SELL', 'BUY', 1000, 1000, 'EUR/USD', 50, 50, '2017-03-16 05:47:53', '2017-03-16 09:00:00', 0, 1000, NULL, NULL),
(271, 1, 'EXD427SJfU2HIqx', NULL, 'S1gG83SL5x', NULL, 'ODT427ByGBPjDjx', 'Time (Countdown)', 0, 'SELL', 'BUY', 1000, 1000, 'GBP/USD', 50, 50, '2017-03-16 05:48:41', '2017-03-16 09:05:00', 0, 1000, NULL, NULL),
(272, 1, 'EXD427SJfU2HIqx', 'EXD427HykO_SUqg', 'S1gG83SL5x', 'HJlJ_urLqg', 'ODT427rJabuovig', 'Time (Countdown)', 0, 'BUY', 'SELL', 849, 849, 'GBP/JPY', 50, 50, '2017-03-16 05:52:05', '2017-03-16 09:10:00', 0, 1000, NULL, NULL),
(273, 1, 'EXD427SJfU2HIqx', NULL, 'S1gG83SL5x', NULL, 'ODT427rJTi_iPjg', 'Time (Countdown)', 0, 'BUY', 'SELL', 284, 284, 'EUR/TRY', 300, 300, '2017-03-16 05:54:44', '2017-03-16 09:15:00', 0, 1000, NULL, NULL),
(274, 1, 'EXD427SJfU2HIqx', NULL, 'S1gG83SL5x', NULL, 'ODT427rklUcjwsl', 'Time (Countdown)', 0, 'SELL', 'BUY', 1000, 1000, 'AUD/USD', 50, 50, '2017-03-16 06:01:43', '2017-03-16 09:20:00', 0, 1000, NULL, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `history_trades_options`
--

CREATE TABLE IF NOT EXISTS `history_trades_options` (
`SN` int(11) NOT NULL,
  `LIVE` tinyint(1) NOT NULL DEFAULT '0' COMMENT 'whether it is live or demo account/tade. 0 means dem and 1 means live',
  `SELLER_ID` varchar(200) DEFAULT NULL,
  `BUYER_ID` varchar(200) DEFAULT NULL,
  `SELLER_USERNAME` varchar(200) DEFAULT NULL,
  `BUYER_USERNAME` varchar(200) DEFAULT NULL,
  `ORDER_TICKET` varchar(200) DEFAULT NULL COMMENT 'the order ticket of the trade. This is same of both the buyer and seller. Note: the term buyer and seller does not mean the same as in forex. seller is the initiator of the exchange while buyer is the acceptor of the exchange offer.',
  `TYPE` varchar(200) DEFAULT NULL COMMENT 'buyer or seller',
  `PRODUCT` varchar(200) DEFAULT NULL,
  `OPEN` float NOT NULL DEFAULT '0',
  `SYMBOL` varchar(200) DEFAULT NULL,
  `STRIKE` float NOT NULL DEFAULT '0',
  `STRIKE_UP` float NOT NULL DEFAULT '0',
  `STRIKE_DOWN` float NOT NULL DEFAULT '0',
  `SIZE` int(11) NOT NULL DEFAULT '0',
  `BARRIER` float NOT NULL DEFAULT '0',
  `BARRIER_UP` float NOT NULL DEFAULT '0',
  `BARRIER_DOWN` float NOT NULL DEFAULT '0',
  `STAKE` float NOT NULL DEFAULT '0',
  `PRICE` float NOT NULL DEFAULT '0',
  `PREMIUM` float NOT NULL DEFAULT '0',
  `COUNT_DOWN` varchar(200) NOT NULL DEFAULT '1900-01-01 00:00:00' COMMENT 'important! must be VARCHAR and not DATETIME because of some internal isssues where local time is selected by knex against our wish.',
  `TIME` varchar(200) NOT NULL DEFAULT '1900-01-01 00:00:00' COMMENT 'important! must be VARCHAR and not DATETIME because of some internal isssues where local time is selected by knex against our wish.',
  `EXPIRY` varchar(200) NOT NULL DEFAULT '1900-01-01 00:00:00' COMMENT 'important! must be VARCHAR and not DATETIME because of some internal isssues where local time is selected by knex against our wish.',
  `CLOSE` float NOT NULL DEFAULT '0',
  `SELLER_RESULT` varchar(200) DEFAULT NULL,
  `BUYER_RESULT` varchar(200) DEFAULT NULL,
  `SELLER_PAYOUT` float NOT NULL DEFAULT '0',
  `BUYER_PAYOUT` float NOT NULL DEFAULT '0',
  `SELLER_COMMISSION` float NOT NULL DEFAULT '0',
  `BUYER_COMMISSION` float NOT NULL DEFAULT '0',
  `SELLER_PROFIT_AND_LOSS` float NOT NULL DEFAULT '0',
  `BUYER_PROFIT_AND_LOSS` float NOT NULL DEFAULT '0',
  `DEL_BY_SELLER_ID` varchar(200) DEFAULT NULL COMMENT 'Only just marks the record as deleted by the seller. but the record is not actually deleted from the table. Takes the id of the seller for testing to ensure the record is no longer sent to him',
  `DEL_BY_BUYER_ID` varchar(200) DEFAULT NULL COMMENT 'Only just marks the record as deleted by the buyer. but the record is not actually deleted from the table. Takes the id of the buyer for testing to ensure the record is no longer sent to him'
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=21 ;

--
-- Dumping data for table `history_trades_options`
--

INSERT INTO `history_trades_options` (`SN`, `LIVE`, `SELLER_ID`, `BUYER_ID`, `SELLER_USERNAME`, `BUYER_USERNAME`, `ORDER_TICKET`, `TYPE`, `PRODUCT`, `OPEN`, `SYMBOL`, `STRIKE`, `STRIKE_UP`, `STRIKE_DOWN`, `SIZE`, `BARRIER`, `BARRIER_UP`, `BARRIER_DOWN`, `STAKE`, `PRICE`, `PREMIUM`, `COUNT_DOWN`, `TIME`, `EXPIRY`, `CLOSE`, `SELLER_RESULT`, `BUYER_RESULT`, `SELLER_PAYOUT`, `BUYER_PAYOUT`, `SELLER_COMMISSION`, `BUYER_COMMISSION`, `SELLER_PROFIT_AND_LOSS`, `BUYER_PROFIT_AND_LOSS`, `DEL_BY_SELLER_ID`, `DEL_BY_BUYER_ID`) VALUES
(1, 0, 'EXD002530', 'EXD001280', 'o3', 'chuks3', 'ODT6116rJNRje2Ee', NULL, 'DIGITAL CALL (OTM)', 1.4338, 'EUR/USD', 3, 0, 0, 100, 1.4341, 1.4338, 1.4338, 0, 20, 20, '1900-01-01 00:00:00', '2016-12-24 13:48:01', '2016-12-24 13:48:01', 1.4321, 'LOSS', 'WIN', 0, 0, 0, 10, -20, 10, NULL, NULL),
(2, 0, 'EXD001280', 'EXD002530', 'chuks3', 'o3', 'ODT6116HyUXTe24e', NULL, 'DIGITAL CALL (OTM)', 1.4358, 'EUR/USD', 4, 0, 0, 100, 1.4362, 1.4358, 1.4358, 0, 20, 20, '1900-01-01 00:00:00', '2016-12-24 13:53:00', '2016-12-24 13:53:00', 1.43, 'LOSS', 'WIN', 0, 0, 0, 10, -20, 10, NULL, NULL),
(3, 0, 'EXD001280', 'EXD002530', 'chuks3', 'o3', 'ODT6116HJQDCghNx', NULL, 'DIGITAL CALL (ITM)', 1.4378, 'EUR/USD', -3, 0, 0, 100, 1.4375, 1.4378, 1.4378, 0, 20, 20, '1900-01-01 00:00:00', '2016-12-24 13:57:01', '2016-12-24 13:57:01', 1.4377, 'WIN', 'LOSS', 0, 0, 10, 0, 10, -20, NULL, NULL),
(4, 0, 'EXD002530', 'EXD001280', 'o3', 'chuks3', 'ODT6116SkkpyZn4e', NULL, 'DIGITAL CALL (OTM)', 1.4359, 'EUR/USD', 1, 0, 0, 100, 1.436, 1.4359, 1.4359, 0, 20, 20, '1900-01-01 00:00:00', '2016-12-24 14:03:00', '2016-12-24 14:03:00', 1.4338, 'LOSS', 'WIN', 0, 0, 0, 10, -20, 10, NULL, NULL),
(5, 0, 'EXD001280', 'EXD002530', 'chuks3', 'o3', 'ODT6116H11ZN-hNl', NULL, 'DIGITAL CALL (OTM)', 1.4378, 'EUR/USD', 2, 0, 0, 100, 1.438, 1.4378, 1.4378, 0, 20, 20, '1900-01-01 00:00:00', '2016-12-24 14:22:00', '2016-12-24 14:22:00', 1.4319, 'LOSS', 'WIN', 0, 0, 0, 10, -20, 10, NULL, NULL),
(6, 0, 'EXD002530', 'EXD001280', 'o3', 'chuks3', 'ODT6116HknWBZ2Ee', NULL, 'DIGITAL CALL (OTM)', 1.43, 'EUR/USD', 3, 0, 0, 100, 1.4303, 1.43, 1.43, 0, 20, 20, '1900-01-01 00:00:00', '2016-12-24 14:26:01', '2016-12-24 14:26:01', 1.436, 'WIN', 'LOSS', 0, 0, 10, 0, 10, -20, NULL, NULL),
(7, 0, 'EXD002530', 'EXD001280', 'o3', 'chuks3', 'ODT6116Hy3lcZ3Vx', NULL, 'DIGITAL CALL (OTM)', 1.4338, 'EUR/USD', 10, 0, 0, 100, 1.4348, 1.4338, 1.4338, 0, 20, 20, '1900-01-01 00:00:00', '2016-12-24 14:48:00', '2016-12-24 14:48:00', 1.4359, 'WIN', 'LOSS', 0, 0, 10, 0, 10, -20, NULL, NULL),
(8, 0, 'EXD002530', 'EXD001280', 'o3', 'chuks3', 'ODT6116r1xGh-nEg', NULL, 'DIGITAL CALL (OTM)', 1.4338, 'EUR/USD', 10, 0, 0, 100, 1.4348, 1.4338, 1.4338, 0, 20, 20, '1900-01-01 00:00:00', '2016-12-24 14:56:00', '2016-12-24 14:56:00', 1.436, 'WIN', 'LOSS', 0, 0, 10, 0, 10, -20, NULL, NULL),
(9, 0, 'EXD001280', 'EXD002530', 'chuks3', 'o3', 'ODT6116SJpe6-3Ne', NULL, 'DIGITAL CALL (OTM)', 1.434, 'EUR/USD', 10, 0, 0, 100, 1.435, 1.434, 1.434, 0, 20, 20, '1900-01-01 00:00:00', '2016-12-24 15:00:00', '2016-12-24 15:00:00', 1.4318, 'LOSS', 'WIN', 0, 0, 0, 10, -20, 10, NULL, NULL),
(10, 0, 'EXD002530', 'EXD001280', 'o3', 'chuks3', 'ODT6116rkLSkGh4g', NULL, 'DIGITAL CALL (OTM)', 1.4378, 'EUR/USD', 10, 0, 0, 100, 1.4388, 1.4378, 1.4378, 0, 20, 20, '1900-01-01 00:00:00', '2016-12-24 15:10:00', '2016-12-24 15:10:00', 1.432, 'LOSS', 'WIN', 0, 0, 0, 10, -20, 10, NULL, NULL),
(11, 0, 'EXD002530', 'EXD001280', 'o3', 'chuks3', 'ODT6116HJuRTznVg', NULL, 'DIGITAL CALL (OTM)', 1.4342, 'EUR/USD', 10, 0, 0, 100, 1.4352, 1.4342, 1.4342, 0, 20, 20, '1900-01-01 00:00:00', '2016-12-24 16:12:00', '2016-12-24 16:12:00', 1.4317, 'LOSS', 'WIN', 0, 0, 0, 10, -20, 10, NULL, NULL),
(12, 0, 'EXD002750', 'EXD002848', 'p1', 'p2', 'ODT407HJALZVPwg', NULL, 'DIGITAL CALL (ATM)', 0, 'EUR/USD', 0, 0, 0, 1000, 1.0734, 1.0734, 1.0734, 0, 21, 20, '1900-01-01 00:00:00', '2017-01-26 08:30:00', '1900-01-01 00:00:00', 0, NULL, NULL, 0, 0, 0, 0, 0, 0, NULL, NULL),
(13, 0, 'EXD002750', 'EXD002848', 'p1', 'p2', 'ODT407rJUpIVPPl', NULL, 'DIGITAL CALL (OTM)', 1.074, 'EUR/USD', 10, 0, 0, 1000, 1.075, 1.074, 1.074, 0, 20, 20, '1900-01-01 00:00:00', '2017-01-26 08:46:11', '2017-01-26 08:46:09', 1.07413, 'LOSS', 'WIN', 0, 0, 0, 100, -200, 100, NULL, NULL),
(14, 0, 'EXD002848', 'EXD002750', 'p2', 'p1', 'ODT407SJV5dEvDg', NULL, 'DIGITAL CALL (OTM)', 1.074, 'EUR/USD', 10, 0, 0, 1000, 1.075, 1.074, 1.074, 0, 20, 20, '1900-01-01 00:00:00', '2017-01-26 09:05:15', '2017-01-26 09:05:15', 1.07383, 'LOSS', 'WIN', 0, 0, 0, 100, -200, 100, NULL, NULL),
(15, 0, 'EXD002750', 'EXD002848', 'p1', 'p2', 'ODT407ByxjjVvvl', NULL, 'DIGITAL CALL (OTM)', 1.074, 'EUR/USD', 5, 0, 0, 1000, 1.0745, 1.074, 1.074, 0, 20, 20, '1900-01-01 00:00:00', '2017-01-26 09:17:44', '2017-01-26 09:17:44', 1.07425, 'LOSS', 'WIN', 0, 0, 0, 100, -200, 100, NULL, NULL),
(16, 0, 'EXD002750', 'EXD002848', 'p1', 'p2', 'ODT407SkJza4wve', NULL, 'DIGITAL CALL (ATM)', 1.0738, 'EUR/USD', 0, 0, 0, 1000, 1.0738, 1.0738, 1.0738, 0, 20, 20, '1900-01-01 00:00:00', '2017-01-26 09:20:52', '2017-01-26 09:20:47', 1.07398, 'WIN', 'LOSS', 0, 0, 100, 0, 100, -200, NULL, NULL),
(17, 0, 'EXD002848', 'EXD002750', 'p2', 'p1', 'ODT407r1_TLHDvl', NULL, 'DIGITAL CALL (OTM)', 1.0723, 'EUR/USD', 5, 0, 0, 1000, 1.0728, 1.0723, 1.0723, 0, 20, 20, '1900-01-01 00:00:00', '2017-01-26 10:02:16', '2017-01-26 10:02:16', 1.0722, 'LOSS', 'WIN', 0, 0, 0, 100, -200, 100, NULL, NULL),
(18, 0, 'EXD001192', 'EXD001280', 'chuks2', 'chuks3', 'ODT0116rykmzGVEx', NULL, 'DIGITAL CALL (OTM)', 0, 'GBP/USD', 34, 0, 0, 188, 0, 0, 0, 0, 20, 20, '1900-01-01 00:00:00', '2017-02-04 22:27:17', '1900-01-01 00:00:00', 0, 'BREAK EVEN', 'BREAK EVEN', 0, 0, 0, 0, 0, 0, NULL, NULL),
(19, 0, 'EXD001280', 'EXD002530', 'chuks3', 'o3', 'ODT6116Bk3zdG34x', NULL, 'DIGITAL CALL (OTM)', 1.4304, 'EUR/USD', 10, 0, 0, 100, 1.4314, 1.4304, 1.4304, 0, 20, 20, '1900-01-01 00:00:00', '2017-02-06 03:00:01', '2016-12-24 15:48:00', 1.07783, 'LOSS', 'WIN', 0, 0, 0, 10, -20, 10, NULL, NULL),
(20, 0, 'EXD002952', 'EXD003346', 'op1', 'tt', 'ODT427BJsUtu89e', NULL, 'DIGITAL CALL (OTM)', 1.04983, 'EUR/USD', 1, 0, 0, 100, 1.04993, 1.04983, 1.04983, 0, 20, 20, '1900-01-01 00:00:00', '2017-03-03 05:16:00', '2017-03-03 05:16:00', 1.04982, 'LOSS', 'WIN', 0, 0, 0, 10, -20, 10, NULL, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `history_trades_spotfx`
--

CREATE TABLE IF NOT EXISTS `history_trades_spotfx` (
`SN` int(11) NOT NULL,
  `LIVE` tinyint(1) NOT NULL DEFAULT '0' COMMENT 'whether it is live or demo account/tade. 0 means dem and 1 means live',
  `SELLER_ID` varchar(200) DEFAULT NULL,
  `BUYER_ID` varchar(200) DEFAULT NULL,
  `SELLER_USERNAME` varchar(200) DEFAULT NULL,
  `BUYER_USERNAME` varchar(200) DEFAULT NULL,
  `ORDER_TICKET` varchar(200) DEFAULT NULL COMMENT 'the order ticket of the trade. This is same of both the buyer and seller. Note: the term buyer and seller does not mean the same as in forex. seller is the initiator of the exchange while buyer is the acceptor of the exchange offer.',
  `TIME` varchar(200) NOT NULL DEFAULT '1900-01-01 00:00:00' COMMENT 'important! must be VARCHAR and not DATETIME because of some internal isssues where local time is selected by knex against our wish.',
  `DIRECTION` varchar(200) DEFAULT NULL,
  `SIZE` int(11) NOT NULL DEFAULT '0',
  `SYMBOL` varchar(200) DEFAULT NULL,
  `OPEN` float NOT NULL DEFAULT '0',
  `STOP_LOSS` float NOT NULL DEFAULT '0',
  `TAKE_PROFIT` float NOT NULL DEFAULT '0',
  `CLOSE` float NOT NULL DEFAULT '0',
  `COUNT_DOWN` varchar(200) NOT NULL DEFAULT '1900-01-01 00:00:00' COMMENT 'important! must be VARCHAR and not DATETIME because of some internal isssues where local time is selected by knex against our wish.',
  `SELLER_RESULT` varchar(200) DEFAULT NULL,
  `BUYER_RESULT` varchar(200) DEFAULT NULL,
  `SELLER_COMMISSION` float NOT NULL DEFAULT '0',
  `BUYER_COMMISSION` float NOT NULL DEFAULT '0',
  `SELLER_PROFIT_AND_LOSS` float NOT NULL DEFAULT '0',
  `BUYER_PROFIT_AND_LOSS` float DEFAULT '0',
  `DEL_BY_SELLER_ID` varchar(200) DEFAULT NULL COMMENT 'Only just marks the record as deleted by the seller. but the record is not actually deleted from the table. Takes the id of the seller for testing to ensure the record is no longer sent to him',
  `DEL_BY_BUYER_ID` varchar(200) DEFAULT NULL COMMENT 'Only just marks the record as deleted by the buyer. but the record is not actually deleted from the table. Takes the id of the buyer for testing to ensure the record is no longer sent to him'
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=45 ;

--
-- Dumping data for table `history_trades_spotfx`
--

INSERT INTO `history_trades_spotfx` (`SN`, `LIVE`, `SELLER_ID`, `BUYER_ID`, `SELLER_USERNAME`, `BUYER_USERNAME`, `ORDER_TICKET`, `TIME`, `DIRECTION`, `SIZE`, `SYMBOL`, `OPEN`, `STOP_LOSS`, `TAKE_PROFIT`, `CLOSE`, `COUNT_DOWN`, `SELLER_RESULT`, `BUYER_RESULT`, `SELLER_COMMISSION`, `BUYER_COMMISSION`, `SELLER_PROFIT_AND_LOSS`, `BUYER_PROFIT_AND_LOSS`, `DEL_BY_SELLER_ID`, `DEL_BY_BUYER_ID`) VALUES
(1, 0, 'EXD001192', 'EXD001280', 'chuks2', 'chuks3', 'ODT1116SkGMRlSEe', '2016-12-19 07:15:20', 'BUY', 100, 'EUR/USD', 1.4338, 1.4318, 1.4358, 1.4358, '1900-01-01 00:00:00', 'WIN', 'LOSS', 10, 0, 10, -20, NULL, NULL),
(2, 0, 'EXD001192', 'EXD001280', 'chuks2', 'chuks3', 'ODT1116SyLPWZHNl', '2016-12-19 07:45:23', 'BUY', 100, 'GBP/USD', 1.4377, 1.4357, 1.4397, 1.4357, '1900-01-01 00:00:00', 'LOSS', 'WIN', 0, 10, -20, 10, NULL, NULL),
(3, 0, 'EXD001192', 'EXD001280', 'chuks2', 'chuks3', 'ODT1116rybMhbH4l', '2016-12-19 08:30:19', 'BUY', 200, 'EUR/USD', 1.4356, 1.4336, 1.4376, 1.4376, '1900-01-01 00:00:00', 'WIN', 'LOSS', 20, 0, 20, -40, NULL, NULL),
(4, 0, 'EXD001192', 'EXD001280', 'chuks2', 'chuks3', 'ODT1116HkXTAbSEl', '2016-12-19 08:45:24', 'SELL', 1000, 'EUR/USD', 1.4301, 1.4321, 1.4281, 1.4321, '1900-01-01 00:00:00', 'LOSS', 'WIN', 0, 100, -200, 100, NULL, NULL),
(5, 0, 'EXD001192', 'EXD001280', 'chuks2', 'chuks3', 'ODT4116rkKdUjYVl', '2016-12-22 19:20:19', 'BUY', 100, 'EUR/USD', 1.4376, 1.4356, 1.4396, 1.4356, '1900-01-01 00:00:00', 'LOSS', 'WIN', 0, 10, -20, 10, NULL, NULL),
(6, 0, 'EXD001192', 'EXD001280', 'chuks2', 'chuks3', 'ODT2116Hkd4VywNe', '2016-12-26 08:51:10', 'BUY', 1000, 'EUR/USD', 1.03948, 1.03748, 1.04148, 1.04148, '1900-01-01 00:00:00', 'WIN', 'LOSS', 100, 0, 100, -200, NULL, NULL),
(7, 0, 'EXD001192', 'EXD001280', 'chuks2', 'chuks3', 'ODT4116ryNdvDKEl', '2016-12-26 08:51:10', 'BUY', 100, 'EUR/USD', 1.4348, 1.4328, 1.4368, 1.4368, '1900-01-01 00:00:00', 'WIN', 'LOSS', 10, 0, 10, -20, NULL, NULL),
(8, 0, 'EXD001192', 'EXD001280', 'chuks2', 'chuks3', 'ODT4116SJfcfVKEg', '2016-12-26 08:51:10', 'BUY', 100, 'EUR/USD', 1.04648, 1.04448, 1.04848, 1.04848, '1900-01-01 00:00:00', 'WIN', 'LOSS', 10, 0, 10, -20, NULL, NULL),
(9, 0, 'EXD001192', 'EXD001280', 'chuks2', 'chuks3', 'ODT4116SJtpKDtVx', '2016-12-26 08:51:11', 'BUY', 100, 'EUR/USD', 1.4308, 1.4288, 1.4328, 1.4328, '1900-01-01 00:00:00', 'WIN', 'LOSS', 10, 0, 10, -20, NULL, NULL),
(10, 0, 'EXD001192', 'EXD001280', 'chuks2', 'chuks3', 'ODT2116BJn4TmgBx', '2016-12-27 18:10:19', 'BUY', 100, 'EUR/USD', 1.431, 1.429, 1.433, 1.433, '1900-01-01 00:00:00', 'WIN', 'LOSS', 10, 0, 10, -20, NULL, NULL),
(11, 0, 'EXD001192', 'EXD001280', 'chuks2', 'chuks3', 'ODT407HJlXvVBLg', '2017-01-12 17:10:19', 'BUY', 100, 'EUR/USD', 1.4325, 1.4305, 1.4345, 1.4305, '1900-01-01 00:00:00', 'LOSS', 'WIN', 0, 10, -20, 10, NULL, NULL),
(12, 0, 'EXD001192', 'EXD001280', 'chuks2', 'chuks3', 'ODT407H1Hcqmr8l', '2017-01-12 17:15:20', 'BUY', 100, 'EUR/USD', 1.4344, 1.4324, 1.4364, 1.4324, '1900-01-01 00:00:00', 'LOSS', 'WIN', 0, 10, -20, 10, NULL, NULL),
(13, 0, 'EXD001192', 'EXD001280', 'chuks2', 'chuks3', 'ODT407BkV8mrHLg', '2017-01-12 18:00:20', 'BUY', 100, 'GBP/USD', 1.4366, 1.4346, 1.4386, 1.4346, '1900-01-01 00:00:00', 'LOSS', 'WIN', 0, 10, -20, 10, NULL, NULL),
(14, 0, 'EXD001192', 'EXD001280', 'chuks2', 'chuks3', 'ODT507BJMDz9SLl', '2017-01-12 23:34:34', 'BUY', 1000, 'EUR/USD', 0, 20, 20, 20, '1900-01-01 00:00:00', 'LOSS', 'WIN', 0, 100, -200, 100, NULL, NULL),
(15, 0, 'EXD001192', 'EXD001280', 'chuks2', 'chuks3', 'ODT507SJE2bWU8g', '2017-01-13 07:29:46', 'BUY', 900, 'EUR/USD', 1.43, 1.428, 1.432, 1.432, '1900-01-01 00:00:00', 'WIN', 'LOSS', 90, 0, 90, -180, NULL, NULL),
(16, 0, 'EXD001192', 'EXD001280', 'chuks2', 'chuks3', 'ODT507BJY2_D8Ux', '2017-01-13 14:49:55', 'BUY', 100, 'EUR/USD', 1.43, 1.428, 1.432, 1.432, '1900-01-01 00:00:00', 'WIN', 'LOSS', 10, 0, 10, -20, NULL, NULL),
(17, 0, 'EXD001192', 'EXD001280', 'chuks2', 'chuks3', 'ODT507HJHOicLUl', '2017-01-13 18:27:28', 'BUY', 100, 'EUR/USD', 1.437, 1.435, 1.439, 1.435, '1900-01-01 00:00:00', 'LOSS', 'WIN', 0, 10, -20, 10, NULL, NULL),
(18, 0, 'EXD001192', 'EXD001280', 'chuks2', 'chuks3', 'ODT307rJJhuu2Ll', '2017-01-18 05:15:01', 'BUY', 100, 'EUR/USD', 0, 20, 20, 0, '1900-01-01 00:00:00', NULL, NULL, 0, 0, 0, 0, NULL, NULL),
(19, 0, 'EXD001192', 'EXD001280', 'chuks2', 'chuks3', 'ODT307S1yrKuhUe', '2017-01-18 05:15:43', 'BUY', 100, 'EUR/USD', 1.437, 1.435, 1.439, 1.435, '1900-01-01 00:00:00', 'LOSS', 'WIN', 0, 10, -20, 10, NULL, NULL),
(20, 0, 'EXD002750', 'EXD002848', 'p1', 'p2', 'ODT407By7A0EDwe', '2017-01-26 09:51:39', 'BUY', 1000, 'EUR/USD', 1.07426, 1.07226, 1.07626, 1.07226, '1900-01-01 00:00:00', 'LOSS', 'WIN', 0, 100, -200, 100, NULL, NULL),
(21, 0, 'EXD002750', 'EXD002848', 'p1', 'p2', 'ODT407r1XZJrPPl', '2017-01-26 09:53:47', 'BUY', 1000, 'EUR/USD', 1.07411, 1.07211, 1.07611, 1.07211, '1900-01-01 00:00:00', 'LOSS', 'WIN', 0, 100, -200, 100, NULL, NULL),
(22, 0, 'EXD002750', 'EXD002848', 'p1', 'p2', 'ODT407rJfjaVPPg', '2017-01-26 09:53:51', 'BUY', 1000, 'EUR/USD', 1.07394, 1.07194, 1.07594, 1.07194, '1900-01-01 00:00:00', 'LOSS', 'WIN', 0, 100, -200, 100, NULL, NULL),
(23, 0, 'EXD002750', 'EXD002848', 'p1', 'p2', 'ODT407BJlKGSvPl', '2017-01-26 12:59:55', 'BUY', 1000, 'EUR/USD', 1.07305, 1.07105, 1.07505, 1.07105, '1900-01-01 00:00:00', 'LOSS', 'WIN', 0, 100, -200, 100, NULL, NULL),
(24, 0, 'EXD386H1qfL-la', 'EXD001192', 'chuks1', 'chuks2', 'ODT6116HkFP8QX4l', '2017-02-04 22:27:17', 'BUY', 304166, 'AUD/USD', 0, 20, 20, 0, '1900-01-01 00:00:00', 'BREAK EVEN', 'BREAK EVEN', 0, 0, 0, 0, NULL, NULL),
(25, 0, 'EXD001192', 'EXD001280', 'chuks2', 'chuks3', 'ODT0116SkSW7WENg', '2017-02-04 22:27:17', 'BUY', 100, 'EUR/USD', 0, 20, 20, 0, '1900-01-01 00:00:00', 'BREAK EVEN', 'BREAK EVEN', 0, 0, 0, 0, NULL, NULL),
(26, 0, 'EXD001192', 'EXD001280', 'chuks2', 'chuks3', 'ODT0116B10g9-NEx', '2017-02-04 22:27:17', 'BUY', 1500, 'EUR/USD', 0, 20, 20, 0, '1900-01-01 00:00:00', 'BREAK EVEN', 'BREAK EVEN', 0, 0, 0, 0, NULL, NULL),
(27, 0, 'EXD001192', 'EXD001280', 'chuks2', 'chuks3', 'ODT0116ryQfAW44e', '2017-02-04 22:27:17', 'BUY', 400, 'EUR/USD', 0, 20, 20, 0, '1900-01-01 00:00:00', 'BREAK EVEN', 'BREAK EVEN', 0, 0, 0, 0, NULL, NULL),
(28, 0, 'EXD001192', 'EXD001280', 'chuks2', 'chuks3', 'ODT0116B1mnhZENg', '2017-02-04 22:27:17', 'BUY', 100, 'EUR/USD', 0, 20, 20, 0, '1900-01-01 00:00:00', 'BREAK EVEN', 'BREAK EVEN', 0, 0, 0, 0, NULL, NULL),
(29, 0, 'EXD001192', 'EXD001280', 'chuks2', 'chuks3', 'ODT1116BJyUz0S4g', '2017-02-04 22:27:17', 'BUY', 100, 'EUR/USD', 0, 20, 20, 0, '1900-01-01 00:00:00', 'BREAK EVEN', 'BREAK EVEN', 0, 0, 0, 0, NULL, NULL),
(30, 0, 'EXD001192', 'EXD001280', 'chuks2', 'chuks3', 'ODT4116BkS_wEt4x', '2017-02-04 22:27:17', 'BUY', 100, 'EUR/USD', 0, 20, 20, 0, '1900-01-01 00:00:00', 'BREAK EVEN', 'BREAK EVEN', 0, 0, 0, 0, NULL, NULL),
(31, 0, 'EXD001192', 'EXD001280', 'chuks2', 'chuks3', 'ODT4116Bk0Vd4KNx', '2017-02-04 22:27:17', 'BUY', 100, 'EUR/USD', 0, 20, 20, 0, '1900-01-01 00:00:00', 'BREAK EVEN', 'BREAK EVEN', 0, 0, 0, 0, NULL, NULL),
(32, 0, 'EXD001192', 'EXD001280', 'chuks2', 'chuks3', 'ODT407BJssPBHIx', '2017-02-04 22:27:17', 'BUY', 100, 'AUD/USD', 0, 20, 20, 0, '1900-01-01 00:00:00', 'BREAK EVEN', 'BREAK EVEN', 0, 0, 0, 0, NULL, NULL),
(33, 0, 'EXD001192', 'EXD001280', 'chuks2', 'chuks3', 'ODT407BJs3BvHLx', '2017-02-04 22:27:17', 'BUY', 300, 'EUR/USD', 0, 20, 20, 0, '1900-01-01 00:00:00', 'BREAK EVEN', 'BREAK EVEN', 0, 0, 0, 0, NULL, NULL),
(34, 0, 'EXD001192', 'EXD001280', 'chuks2', 'chuks3', 'ODT507Sy05l9r8g', '2017-02-04 22:27:17', 'BUY', 1000, 'GBP/USD', 0, 30, 30, 0, '1900-01-01 00:00:00', 'BREAK EVEN', 'BREAK EVEN', 0, 0, 0, 0, NULL, NULL),
(35, 0, 'EXD001192', 'EXD001280', 'chuks2', 'chuks3', 'ODT507ByW-xOL8g', '2017-02-04 22:27:17', 'BUY', 100, 'EUR/USD', 0, 20, 20, 0, '1900-01-01 00:00:00', 'BREAK EVEN', 'BREAK EVEN', 0, 0, 0, 0, NULL, NULL),
(36, 0, 'EXD001192', 'EXD001280', 'chuks2', 'chuks3', 'ODT007H1OF2NYUx', '2017-02-04 22:27:17', 'BUY', 100, 'EUR/USD', 0, 20, 20, 0, '1900-01-01 00:00:00', 'BREAK EVEN', 'BREAK EVEN', 0, 0, 0, 0, NULL, NULL),
(37, 0, 'EXD001192', 'EXD001280', 'chuks2', 'chuks3', 'ODT007B1ty1SY8e', '2017-02-04 22:27:17', 'BUY', 100, 'EUR/USD', 0, 20, 20, 0, '1900-01-01 00:00:00', 'BREAK EVEN', 'BREAK EVEN', 0, 0, 0, 0, NULL, NULL),
(38, 0, 'EXD002952', 'EXD003346', 'op1', 'tt', 'ODT427HknHO_Lql', '2017-03-03 11:59:35', 'BUY', 100, 'EUR/USD', 1.04983, 1.04783, 1.05183, 1.05183, '1900-01-01 00:00:00', 'WIN', 'LOSS', 10, 0, 10, -20, NULL, NULL),
(39, 1, 'EXD427SJfU2HIqx', 'EXD427HykO_SUqg', 'S1gG83SL5x', 'HJlJ_urLqg', 'ODT127rJ8nC6j9e', '2017-03-08 13:15:48', 'SELL', 1000, 'GBP/JPY', 138.834, 139.334, 138.334, 139.334, '1900-01-01 00:00:00', 'LOSS', 'WIN', 0, 100, -424.5, 324.5, NULL, NULL),
(40, 1, 'EXD427SJfU2HIqx', 'EXD427HykO_SUqg', 'S1gG83SL5x', 'HJlJ_urLqg', 'ODT427SJj-KA1sx', '2017-03-13 15:44:03', 'SELL', 1000, 'GBP/USD', 1.21588, 1.22088, 1.21088, 1.22088, '1900-01-01 00:00:00', 'LOSS', 'WIN', 0, 100, -500, 400, NULL, NULL),
(41, 0, 'EXD386H1qfL-la', 'EXD001192', 'chuks1', 'chuks2', 'ODT127S1T24krsx', '2017-03-14 17:02:49', 'BUY', 100, 'EUR/USD', 1.0652, 1.0632, 1.0672, 1.0632, '1900-01-01 00:00:00', 'LOSS', 'WIN', 0, 10, -20, 10, NULL, NULL),
(42, 1, 'EXD427SJfU2HIqx', 'EXD427HykO_SUqg', 'S1gG83SL5x', 'HJlJ_urLqg', 'ODT227HysGBmBje', '2017-03-15 17:22:12', 'BUY', 1000, 'GBP/USD', 0, 50, 50, 0, '1900-01-01 00:00:00', 'BREAK EVEN', 'BREAK EVEN', 0, 0, 0, 0, NULL, NULL),
(43, 1, 'EXD427SJfU2HIqx', 'EXD427HykO_SUqg', 'S1gG83SL5x', 'HJlJ_urLqg', 'ODT327ryxrZdUsg', '2017-03-15 18:07:12', 'SELL', 1000, 'USD/CHF', 1.0078, 1.0128, 1.0028, 1.0028, '1900-01-01 00:00:00', 'WIN', 'LOSS', 100, 0, 386, -486, NULL, NULL),
(44, 1, 'EXD427SJfU2HIqx', 'EXD427HykO_SUqg', 'S1gG83SL5x', 'HJlJ_urLqg', 'ODT427rJabuovig', '2017-03-16 12:01:25', 'BUY', 1000, 'GBP/JPY', 139.026, 138.526, 139.526, 139.526, '1900-01-01 00:00:00', 'WIN', 'LOSS', 100, 0, 324.5, -424.5, NULL, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `open_positions_options`
--

CREATE TABLE IF NOT EXISTS `open_positions_options` (
`SN` int(11) NOT NULL,
  `LIVE` tinyint(1) NOT NULL DEFAULT '0' COMMENT 'whether it is live or demo account/tade. 0 means dem and 1 means live',
  `SELLER_ID` varchar(200) DEFAULT NULL,
  `BUYER_ID` varchar(200) DEFAULT NULL,
  `SELLER_USERNAME` varchar(200) DEFAULT NULL,
  `BUYER_USERNAME` varchar(200) DEFAULT NULL,
  `SELLER_LOSABLE_AMT` float DEFAULT '0' COMMENT 'important! hold the amount the seller can loss in this trade',
  `BUYER_LOSABLE_AMT` float DEFAULT '0' COMMENT 'important! hold the amount the buyer can loss in this trade',
  `ORDER_TICKET` varchar(200) DEFAULT NULL COMMENT 'the order ticket of the trade. This is same of both the buyer and seller. Note: the term buyer and seller does not mean the same as in forex. seller is the initiator of the exchange while buyer is the acceptor of the exchange offer.',
  `TYPE` varchar(200) DEFAULT NULL COMMENT 'buyer or seller',
  `SYMBOL` varchar(200) DEFAULT NULL,
  `PRODUCT` varchar(200) DEFAULT NULL,
  `OPEN` float NOT NULL DEFAULT '0',
  `STRIKE` float NOT NULL DEFAULT '0',
  `STRIKE_UP` float NOT NULL DEFAULT '0',
  `STRIKE_DOWN` float NOT NULL DEFAULT '0',
  `BARRIER` float NOT NULL DEFAULT '0',
  `BARRIER_UP` float NOT NULL DEFAULT '0',
  `BARRIER_DOWN` float DEFAULT '0',
  `SIZE` int(11) NOT NULL DEFAULT '0',
  `PRICE` float NOT NULL DEFAULT '0',
  `PREMIUM` float NOT NULL DEFAULT '0',
  `COUNT_DOWN` varchar(200) NOT NULL DEFAULT '1900-01-01 00:00:00' COMMENT 'important! must be VARCHAR and not DATETIME because of some internal isssues where local time is selected by knex against our wish.',
  `TIME` varchar(200) NOT NULL DEFAULT '1900-01-01 00:00:00' COMMENT 'important! must be VARCHAR and not DATETIME because of some internal isssues where local time is selected by knex against our wish.',
  `EXPIRY` varchar(200) NOT NULL DEFAULT '1900-01-01 00:00:00' COMMENT 'important! must be VARCHAR and not DATETIME because of some internal isssues where local time is selected by knex against our wish.',
  `CLOSE` float NOT NULL DEFAULT '0',
  `RESULT` varchar(200) DEFAULT NULL,
  `PAYOUT` float NOT NULL DEFAULT '0',
  `COMMISSION` float NOT NULL DEFAULT '0',
  `PROFIT_AND_LOSS` float NOT NULL DEFAULT '0',
  `DEL_BY_SELLER_ID` varchar(200) DEFAULT NULL COMMENT 'Only just marks the record as deleted by the seller. but the record is not actually deleted from the table. Takes the id of the seller for testing to ensure the record is no longer sent to him',
  `DEL_BY_BUYER_ID` varchar(200) DEFAULT NULL COMMENT 'Only just marks the record as deleted by the buyer. but the record is not actually deleted from the table. Takes the id of the buyer for testing to ensure the record is no longer sent to him'
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `open_positions_spotfx`
--

CREATE TABLE IF NOT EXISTS `open_positions_spotfx` (
`SN` int(11) NOT NULL,
  `LIVE` tinyint(1) NOT NULL DEFAULT '0' COMMENT 'whether it is live or demo account/tade. 0 means dem and 1 means live',
  `SELLER_ID` varchar(200) DEFAULT NULL,
  `BUYER_ID` varchar(200) DEFAULT NULL,
  `SELLER_USERNAME` varchar(200) DEFAULT NULL,
  `BUYER_USERNAME` varchar(200) DEFAULT NULL,
  `SELLER_LOSABLE_AMT` float DEFAULT '0' COMMENT 'important! hold the amount the seller can loss in this trade',
  `BUYER_LOSABLE_AMT` float DEFAULT '0' COMMENT 'important! hold the amount the buyer can loss in this trade',
  `ORDER_TICKET` varchar(200) DEFAULT NULL COMMENT 'the order ticket of the trade. This is same of both the buyer and seller. Note: the term buyer and seller does not mean the same as in forex. seller is the initiator of the exchange while buyer is the acceptor of the exchange offer.',
  `TIME` varchar(200) NOT NULL DEFAULT '1900-01-01 00:00:00' COMMENT 'important! must be VARCHAR and not DATETIME because of some internal isssues where local time is selected by knex against our wish.',
  `TYPE` varchar(200) DEFAULT NULL COMMENT 'buyer or seller',
  `DIRECTION` varchar(200) DEFAULT NULL,
  `SIZE` int(11) NOT NULL DEFAULT '0',
  `SYMBOL` varchar(200) DEFAULT NULL,
  `OPEN` float NOT NULL DEFAULT '0',
  `STOP_LOSS` float NOT NULL DEFAULT '0',
  `TAKE_PROFIT` float NOT NULL DEFAULT '0',
  `CLOSE` float NOT NULL DEFAULT '0',
  `COUNT_DOWN` varchar(200) NOT NULL DEFAULT '1900-01-01 00:00:00' COMMENT 'important! must be VARCHAR and not DATETIME because of some internal isssues where local time is selected by knex against our wish.',
  `COMMISSION` float NOT NULL DEFAULT '0',
  `PROFIT_AND_LOSS` float NOT NULL DEFAULT '0',
  `DEL_BY_SELLER_ID` varchar(200) DEFAULT NULL COMMENT 'Only just marks the record as deleted by the seller. but the record is not actually deleted from the table. Takes the id of the seller for testing to ensure the record is no longer sent to him',
  `DEL_BY_BUYER_ID` varchar(200) DEFAULT NULL COMMENT 'Only just marks the record as deleted by the buyer. but the record is not actually deleted from the table. Takes the id of the buyer for testing to ensure the record is no longer sent to him'
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `pending_positions_options`
--

CREATE TABLE IF NOT EXISTS `pending_positions_options` (
`SN` int(11) NOT NULL,
  `LIVE` tinyint(1) NOT NULL DEFAULT '0' COMMENT 'whether it is live or demo account/tade. 0 means dem and 1 means live',
  `SELLER_ID` varchar(200) DEFAULT NULL,
  `BUYER_ID` varchar(200) DEFAULT NULL,
  `SELLER_USERNAME` varchar(200) DEFAULT NULL,
  `BUYER_USERNAME` varchar(200) DEFAULT NULL,
  `SELLER_LOSABLE_AMT` float DEFAULT '0' COMMENT 'important! hold the amount the seller can loss in this trade',
  `BUYER_LOSABLE_AMT` float DEFAULT '0' COMMENT 'important! hold the amount the buyer can loss in this trade',
  `ORDER_TICKET` varchar(200) DEFAULT NULL COMMENT 'the order ticket of the trade. This is same of both the buyer and seller. Note: the term buyer and seller does not mean the same as in forex. seller is the initiator of the exchange while buyer is the acceptor of the exchange offer.',
  `TYPE` varchar(200) DEFAULT NULL COMMENT 'buyer or seller',
  `SYMBOL` varchar(200) DEFAULT NULL,
  `PRODUCT` varchar(200) DEFAULT NULL,
  `PENDING_ORDER_PRICE` float NOT NULL DEFAULT '0',
  `OPEN` float NOT NULL DEFAULT '0',
  `STRIKE` float NOT NULL DEFAULT '0',
  `STRIKE_UP` float NOT NULL DEFAULT '0',
  `STRIKE_DOWN` float NOT NULL DEFAULT '0',
  `BARRIER` float NOT NULL DEFAULT '0',
  `BARRIER_UP` float NOT NULL DEFAULT '0',
  `BARRIER_DOWN` float DEFAULT '0',
  `SIZE` int(11) NOT NULL DEFAULT '0',
  `PRICE` float NOT NULL DEFAULT '0',
  `PREMIUM` float NOT NULL DEFAULT '0',
  `TIME` varchar(200) NOT NULL DEFAULT '1900-01-01 00:00:00' COMMENT 'important! must be VARCHAR and not DATETIME because of some internal isssues where local time is selected by knex against our wish.',
  `EXPIRY_VALUE` int(11) NOT NULL,
  `EXPIRY_UNIT` varchar(200) DEFAULT NULL,
  `PENDING_ORDER_EXPIRY` varchar(200) DEFAULT '1900-01-01 00:00:00' COMMENT 'important! must be VARCHAR and not DATETIME because of some internal isssues where local time is selected by knex against our wish.',
  `CLOSE` float NOT NULL DEFAULT '0',
  `RESULT` varchar(200) DEFAULT NULL,
  `PAYOUT` float NOT NULL DEFAULT '0',
  `COMMISSION` float NOT NULL DEFAULT '0',
  `PROFIT_AND_LOSS` float NOT NULL DEFAULT '0',
  `DEL_BY_SELLER_ID` varchar(200) DEFAULT NULL COMMENT 'Only just marks the record as deleted by the seller. but the record is not actually deleted from the table. Takes the id of the seller for testing to ensure the record is no longer sent to him',
  `DEL_BY_BUYER_ID` varchar(200) DEFAULT NULL COMMENT 'Only just marks the record as deleted by the buyer. but the record is not actually deleted from the table. Takes the id of the buyer for testing to ensure the record is no longer sent to him'
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `pending_positions_spotfx`
--

CREATE TABLE IF NOT EXISTS `pending_positions_spotfx` (
`SN` int(11) NOT NULL,
  `LIVE` tinyint(1) NOT NULL DEFAULT '0' COMMENT 'whether it is live or demo account/tade. 0 means dem and 1 means live',
  `SELLER_ID` varchar(200) DEFAULT NULL,
  `BUYER_ID` varchar(200) DEFAULT NULL,
  `SELLER_USERNAME` varchar(200) DEFAULT NULL,
  `BUYER_USERNAME` varchar(200) DEFAULT NULL,
  `SELLER_LOSABLE_AMT` float DEFAULT '0' COMMENT 'important! hold the amount the seller can loss in this trade',
  `BUYER_LOSABLE_AMT` float DEFAULT '0' COMMENT 'important! hold the amount the buyer can loss in this trade',
  `ORDER_TICKET` varchar(200) DEFAULT NULL COMMENT 'the order ticket of the trade. This is same of both the buyer and seller. Note: the term buyer and seller does not mean the same as in forex. seller is the initiator of the exchange while buyer is the acceptor of the exchange offer.',
  `TIME` varchar(200) NOT NULL DEFAULT '1900-01-01 00:00:00' COMMENT 'important! must be VARCHAR and not DATETIME because of some internal isssues where local time is selected by knex against our wish.',
  `PENDING_ORDER_EXPIRY` varchar(200) DEFAULT '1900-01-01 00:00:00',
  `TYPE` varchar(200) DEFAULT NULL COMMENT 'buyer or seller',
  `DIRECTION` varchar(200) DEFAULT NULL,
  `SIZE` int(11) NOT NULL DEFAULT '0',
  `SYMBOL` varchar(200) DEFAULT NULL,
  `PENDING_ORDER_PRICE` float NOT NULL DEFAULT '0',
  `OPEN` float NOT NULL DEFAULT '0',
  `STOP_LOSS` float NOT NULL DEFAULT '0',
  `TAKE_PROFIT` float NOT NULL DEFAULT '0',
  `CLOSE` float NOT NULL DEFAULT '0',
  `COMMISSION` float NOT NULL DEFAULT '0',
  `PROFIT_AND_LOSS` float NOT NULL DEFAULT '0',
  `DEL_BY_SELLER_ID` varchar(200) DEFAULT NULL COMMENT 'Only just marks the record as deleted by the seller. but the record is not actually deleted from the table. Takes the id of the seller for testing to ensure the record is no longer sent to him',
  `DEL_BY_BUYER_ID` varchar(200) DEFAULT NULL COMMENT 'Only just marks the record as deleted by the buyer. but the record is not actually deleted from the table. Takes the id of the buyer for testing to ensure the record is no longer sent to him'
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE IF NOT EXISTS `users` (
`SN` int(11) NOT NULL,
  `LIVE` tinyint(1) NOT NULL DEFAULT '0' COMMENT 'whether it is live or demo account. 0 means dem and 1 means live',
  `EXCHANGE_ID` varchar(200) NOT NULL COMMENT 'also called seller id or buyer id depending on the context. if the user intiate an exchange it becomes his seller id and if he buy the exhange it become the buyer id  ',
  `USERNAME` varchar(200) DEFAULT NULL,
  `PASSWORD` varchar(200) DEFAULT NULL,
  `FIRST_NAME` varchar(200) DEFAULT NULL,
  `LAST_NAME` varchar(200) DEFAULT NULL,
  `EMAIL` varchar(200) DEFAULT NULL,
  `SEX` varchar(100) DEFAULT NULL,
  `DOB` date NOT NULL DEFAULT '1900-01-01',
  `ADDRESS` varchar(2000) DEFAULT NULL,
  `COUNTRY` varchar(200) DEFAULT NULL,
  `STATE` varchar(200) DEFAULT NULL,
  `COMPANY` varchar(500) DEFAULT NULL,
  `HOW_YOU_KNEW_US` text NOT NULL,
  `DATE_REGISTERED` datetime NOT NULL DEFAULT '1900-01-01 00:00:00',
  `REGISTERED_BY` varchar(200) DEFAULT NULL,
  `ACCOUNT_BALANCE` float NOT NULL DEFAULT '0'
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=35 ;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`SN`, `LIVE`, `EXCHANGE_ID`, `USERNAME`, `PASSWORD`, `FIRST_NAME`, `LAST_NAME`, `EMAIL`, `SEX`, `DOB`, `ADDRESS`, `COUNTRY`, `STATE`, `COMPANY`, `HOW_YOU_KNEW_US`, `DATE_REGISTERED`, `REGISTERED_BY`, `ACCOUNT_BALANCE`) VALUES
(8, 0, 'EXD386BJgGmr-xT', 'chuks', 'e83030f9563d9487e0a41586373bda8160889cbf', 'Chuks', 'Alimele', 'chuksalimele@yahoo.com', NULL, '2016-08-29', NULL, 'Nigeria', 'Edo', 'DigiTech', '', '2016-09-21 14:03:21', NULL, 500000),
(11, 0, 'EXD386H1qfL-la', 'chuks1', 'c92b78bf97e68be5f40891f9c77299fea61d5d7b', 'Chuks1', 'Alimele1', 'chuksalimele@yahoo.com', NULL, '2016-08-29', NULL, 'Nigeria', 'Edo', 'DigiTech1', '', '2016-09-21 14:07:29', NULL, 304147),
(12, 0, 'EXD001192', 'chuks2', '93bb4fc0ee54cc18d559a98a9bc3dbead9195e81', 'Chuks2', 'Alimele2', 'chuksalimele@yahoo.com', NULL, '2016-09-05', NULL, 'Nigeria', 'Delta', 'my com2', '', '2016-09-26 20:27:15', NULL, 640942),
(13, 0, 'EXD001280', 'chuks3', '83efa6aa41ae3342f279921117acb429edbd6788', 'chuks3', 'Alimele', 'chuksalimele@yahoo.com', NULL, '2016-10-02', NULL, 'Nigeria', 'Delta', 'chuks3 company', '', '2016-10-19 11:56:38', NULL, 548640),
(14, 0, 'EXD001364', 'chuks4', '93a35bf48950530b5045620c46e593f2b0c4b37b', 'Chuks', 'Alimele', 'chuksalimele@yahoo.com', NULL, '2016-10-05', NULL, 'Nigeria', 'Delta', 'my company', '', '2016-10-24 21:54:15', NULL, 0),
(17, 0, 'EXD001456', 'chuks5', 'cf380c43281fb36603aae22d0131cff10d664fce', 'Chuks5', 'Alimele5', 'chuksalimele@yahoo.com', NULL, '1900-01-01', NULL, 'Nigeria', NULL, NULL, '', '2016-10-25 14:13:38', NULL, 500000),
(18, 0, 'EXD001743', 'james2', '1036ccda40bda0a1459d58c0e8c5f3b025aa7fdc', 'james', 'james', 'weja@gmgm.com', NULL, '1900-01-01', NULL, 'Australia', NULL, NULL, '', '2016-11-07 22:30:42', NULL, 1080),
(19, 0, 'EXD001860', 'james3', '52c6b5bd52d2115c89a3f08be7227d4cf7320430', 'james', 'james', 'ghh@gmm.com', NULL, '1900-01-01', NULL, 'Armenia', NULL, NULL, '', '2016-11-07 23:00:21', NULL, 750),
(21, 0, 'EXD001996', 'paul', 'ce823356c75a5a6dedfe752cc6a1fa7b5df018ec', 'paul', 'smith', 'ggg@fg.com', NULL, '1900-01-01', NULL, 'Armenia', NULL, NULL, '', '2016-11-09 23:22:39', NULL, 0),
(23, 1, 'EXD2116S1MNUTa7e', 'rJlMVLaaXe', 'e9c24240585c21730cf1f497b5ef4c456b3d03c9', 'Emma', 'Okpon', 'emma@yahoo.com', NULL, '1900-01-01', NULL, '', NULL, NULL, '', '2016-12-13 19:04:44', NULL, 5000),
(24, 1, 'EXD2116BJmpqp6Xx', 'SJl7pqppmx', '638963956b6de5cd0bcdd0c4d2e8ceb68d8e5abd', 'Famat', 'Okono', 'famat email', NULL, '1900-01-01', NULL, '', NULL, NULL, '', '2016-12-13 19:24:00', 'gon', 17000),
(25, 1, 'EXD2116ryGSn6amg', 'Skefr3apQx', '162dbf18e5dedaf9249dccb94fa4464da252271c', 'Mike', 'Momon', 'mike@yahoo.com', NULL, '1900-01-01', NULL, '', NULL, NULL, '', '2016-12-13 19:30:36', 'gon', 62000),
(26, 0, 'EXD002530', 'o3', 'd099916d553b31fdbfa04885af9355bce9757722', 'h', 'h', 'h@g.com', NULL, '1900-01-01', NULL, 'Armenia', NULL, NULL, '', '2016-12-21 07:16:05', NULL, 499970),
(27, 1, 'EXD207HkWQeBKHl', 'HkxZmxBFHl', '312c2fa2287382998618265ed9da0f035711a3f6', 'Fred', 'konomo', 'fred@yahoo.com', NULL, '1900-01-01', NULL, '', NULL, NULL, '', '2017-01-03 15:17:03', 'gon', 35700),
(28, 0, 'EXD002750', 'p1', 'b78f576611ec06f96af3ca654c22172a5d746c40', 'o', 'o', 'o@g.com', NULL, '1900-01-01', NULL, 'Algeria', NULL, NULL, '', '2017-01-23 13:51:25', NULL, 99100),
(29, 0, 'EXD002848', 'p2', 'c5fd961c9f737a955a308050062e7a2c34ee67c3', 'p', 'p', 'p@gmail.com', NULL, '1900-01-01', NULL, 'Argentina', NULL, NULL, '', '2017-01-26 08:17:27', NULL, 10000),
(31, 0, 'EXD002952', 'op1', '7d836f4befca2bda3e8abb1f7bd93345a5b10ae9', 'Options', 'Trader', 'options@gmail.com', NULL, '1900-01-01', NULL, 'Bahamas', NULL, NULL, '', '2017-02-23 19:39:21', NULL, 99990),
(32, 1, 'EXD427HykO_SUqg', 'HJlJ_urLqg', '21950e494a53a9b2c37e47fa653cec2161aea6d2', 'Matador Prime', 'Trading Desk', 'm.zimkind@matadorprime.com', NULL, '1900-01-01', NULL, '', NULL, NULL, '', '2017-03-03 01:49:06', 'zim', 1314),
(33, 1, 'EXD427SJfU2HIqx', 'S1gG83SL5x', '4bd7fb5bcc4f2705ad922a077eb1fa09e89a24c2', 'Josee', 'Michel', 'joseefmichel@gmail.com', NULL, '1900-01-01', NULL, '', NULL, NULL, '', '2017-03-03 01:54:02', 'zim', 4786),
(34, 0, 'EXD003346', 'tt', '8c1017982b2032cc059203e3d83dd0ee2e7a86b3', 'tt', 'tt', 'tt@tt.cpm', NULL, '1900-01-01', NULL, 'Bahamas', NULL, NULL, '', '2017-03-03 05:01:37', NULL, 9980);

--
-- Indexes for dumped tables
--

--
-- Indexes for table `account_tran`
--
ALTER TABLE `account_tran`
 ADD PRIMARY KEY (`SN`), ADD KEY `USERNAME` (`USERNAME`);

--
-- Indexes for table `daily_rebate`
--
ALTER TABLE `daily_rebate`
 ADD PRIMARY KEY (`SN`);

--
-- Indexes for table `exchange_options`
--
ALTER TABLE `exchange_options`
 ADD PRIMARY KEY (`SN`), ADD UNIQUE KEY `ORDER_TICKET` (`ORDER_TICKET`);

--
-- Indexes for table `exchange_spotfx`
--
ALTER TABLE `exchange_spotfx`
 ADD PRIMARY KEY (`SN`), ADD UNIQUE KEY `ORDER_TICKET` (`ORDER_TICKET`);

--
-- Indexes for table `history_trades_options`
--
ALTER TABLE `history_trades_options`
 ADD PRIMARY KEY (`SN`);

--
-- Indexes for table `history_trades_spotfx`
--
ALTER TABLE `history_trades_spotfx`
 ADD PRIMARY KEY (`SN`);

--
-- Indexes for table `open_positions_options`
--
ALTER TABLE `open_positions_options`
 ADD PRIMARY KEY (`SN`);

--
-- Indexes for table `open_positions_spotfx`
--
ALTER TABLE `open_positions_spotfx`
 ADD PRIMARY KEY (`SN`);

--
-- Indexes for table `pending_positions_options`
--
ALTER TABLE `pending_positions_options`
 ADD PRIMARY KEY (`SN`);

--
-- Indexes for table `pending_positions_spotfx`
--
ALTER TABLE `pending_positions_spotfx`
 ADD PRIMARY KEY (`SN`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
 ADD PRIMARY KEY (`SN`), ADD UNIQUE KEY `EXCHANGE_ID` (`EXCHANGE_ID`), ADD UNIQUE KEY `USERNAME` (`USERNAME`), ADD KEY `LAST_NAME` (`LAST_NAME`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `account_tran`
--
ALTER TABLE `account_tran`
MODIFY `SN` int(11) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=65;
--
-- AUTO_INCREMENT for table `daily_rebate`
--
ALTER TABLE `daily_rebate`
MODIFY `SN` int(11) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=109;
--
-- AUTO_INCREMENT for table `exchange_options`
--
ALTER TABLE `exchange_options`
MODIFY `SN` int(11) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=123;
--
-- AUTO_INCREMENT for table `exchange_spotfx`
--
ALTER TABLE `exchange_spotfx`
MODIFY `SN` int(11) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=275;
--
-- AUTO_INCREMENT for table `history_trades_options`
--
ALTER TABLE `history_trades_options`
MODIFY `SN` int(11) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=21;
--
-- AUTO_INCREMENT for table `history_trades_spotfx`
--
ALTER TABLE `history_trades_spotfx`
MODIFY `SN` int(11) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=45;
--
-- AUTO_INCREMENT for table `open_positions_options`
--
ALTER TABLE `open_positions_options`
MODIFY `SN` int(11) NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT for table `open_positions_spotfx`
--
ALTER TABLE `open_positions_spotfx`
MODIFY `SN` int(11) NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT for table `pending_positions_options`
--
ALTER TABLE `pending_positions_options`
MODIFY `SN` int(11) NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT for table `pending_positions_spotfx`
--
ALTER TABLE `pending_positions_spotfx`
MODIFY `SN` int(11) NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
MODIFY `SN` int(11) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=35;
--
-- Constraints for dumped tables
--

--
-- Constraints for table `account_tran`
--
ALTER TABLE `account_tran`
ADD CONSTRAINT `account_tran_ibfk_1` FOREIGN KEY (`USERNAME`) REFERENCES `users` (`USERNAME`) ON DELETE NO ACTION ON UPDATE CASCADE;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
