-- phpMyAdmin SQL Dump
-- version 4.2.7.1
-- http://www.phpmyadmin.net
--
-- Host: 127.0.0.1
-- Generation Time: Mar 03, 2017 at 04:03 AM
-- Server version: 5.5.39
-- PHP Version: 5.4.31

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

--
-- Database: `flatbook_admin`
--

-- --------------------------------------------------------

--
-- Table structure for table `admin`
--

CREATE TABLE IF NOT EXISTS `admin` (
`SN` int(11) NOT NULL,
  `USERNAME` varchar(200) DEFAULT NULL,
  `PASSWORD` varchar(200) DEFAULT NULL,
  `FIRST_NAME` varchar(200) DEFAULT NULL,
  `LAST_NAME` varchar(200) DEFAULT NULL,
  `EMAIL` varchar(200) DEFAULT NULL,
  `BROKER_ADMIN_HOST_NAME` varchar(200) DEFAULT NULL,
  `TRADE_PLATFORM_HOST_NAME` varchar(200) DEFAULT NULL,
  `PRIVILEGES` varchar(2000) DEFAULT NULL COMMENT 'e.g CREATE_BROKER, CREATE_ADMIN, DELETE_ADMIN, REGISTER_TRADER, FUND_TRADER_ACCOUNT, TRADER_FUND_WITHDRAWAL',
  `CREATED_BY` varchar(200) DEFAULT NULL,
  `DATE_CREATED` datetime NOT NULL DEFAULT '1900-01-01 00:00:00'
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=15 ;

--
-- Dumping data for table `admin`
--

INSERT INTO `admin` (`SN`, `USERNAME`, `PASSWORD`, `FIRST_NAME`, `LAST_NAME`, `EMAIL`, `BROKER_ADMIN_HOST_NAME`, `TRADE_PLATFORM_HOST_NAME`, `PRIVILEGES`, `CREATED_BY`, `DATE_CREATED`) VALUES
(1, 'chuks', 'e83030f9563d9487e0a41586373bda8160889cbf', 'Chuks', 'Alimele', 'chuksalimele@yahoo.com', '', '', 'REGISTER_BROKER,CREATE_ADMIN_USER,DELETE_ADMIN_USER,REGISTER_TRADER,FUND_TRADER_ACCOUNT,TRADER_FUND_WITHDRAWAL', 'chuks', '1900-01-01 00:00:00'),
(2, 'onyeka', '87d4d24f934fca74d4f551b0cd8553dbf3479383', 'Onyeka', NULL, 'chuksalimele@gmail.com', '', '', 'REGISTER_BROKER,CREATE_ADMIN_USER,DELETE_ADMIN_USER,REGISTER_TRADER,FUND_TRADER_ACCOUNT,TRADER_FUND_WITHDRAWAL', 'chuks', '2016-11-13 14:01:29'),
(3, 'onyeka1', 'c0dc1de39ce7db9dcd88150308a0afe9ccca6ea1', 'Onyeka1', NULL, 'chuksalimele@gmail.com', '', '', 'REGISTER_BROKER,CREATE_ADMIN_USER,REGISTER_TRADER,FUND_TRADER_ACCOUNT', 'chuks', '2016-11-13 14:03:34'),
(4, 'onyeka2', 'e62dcc49e160d483e8e3f8e03ef7bab101cf25ce', 'Onyeka', 'Alimele2', 'chuksalimele@yahoo.com', '', '', 'REGISTER_TRADER,FUND_TRADER_ACCOUNT,TRADER_FUND_WITHDRAWAL', 'chuks', '2016-11-13 17:17:58'),
(5, 'onyeka3', '9d6208751a5af03a4451db6c5041d2d73ebc7277', 'Onyeka3', 'Alimele3', 'chuksalimele@gmail.com', '', '', 'CREATE_ADMIN_USER,DELETE_ADMIN_USER,REGISTER_TRADER,FUND_TRADER_ACCOUNT,TRADER_FUND_WITHDRAWAL', 'onyeka1', '2016-11-13 17:47:24'),
(6, NULL, 'd5d4cd07616a542891b7ec2d0257b3a24b69856e', NULL, NULL, NULL, '', '', '', 'chuks', '2016-11-15 07:30:13'),
(7, NULL, 'd5d4cd07616a542891b7ec2d0257b3a24b69856e', NULL, NULL, NULL, '', '', '', 'chuks', '2016-11-15 07:52:05'),
(10, 'gon', '686cd87da7465527cf09367e8e5cc1aae82aaf3b', 'gon company', NULL, 'gon@gmail.com', '127.0.0.1:444', '127.0.0.1:446', 'CREATE_ADMIN_USER,DELETE_ADMIN_USER,REGISTER_TRADER,FUND_TRADER_ACCOUNT,TRADER_FUND_WITHDRAWAL', 'chuks', '2016-12-13 06:40:24'),
(11, 'ken', '470bc578162732ac7f9d387d34c4af4ca6e1b6f7', 'Ken', 'Dunuo', 'ken@yahoo.com', '127.0.0.1:444', '127.0.0.1:446', 'CREATE_ADMIN_USER,DELETE_ADMIN_USER,REGISTER_TRADER,FUND_TRADER_ACCOUNT,TRADER_FUND_WITHDRAWAL', 'gon', '2016-12-13 06:53:26'),
(12, 'han', '4ff615253469989932532e926006ae5c995e5dd6', 'Han', 'Vonso', 'han@gmail.com', '127.0.0.1:444', '127.0.0.1:446', 'CREATE_ADMIN_USER,REGISTER_TRADER', 'gon', '2016-12-13 07:35:22'),
(13, 'bon', '3b4f14403e709da5b91e1679d6e9ad1b00b9d903', 'Bon', 'Aom', 'bon@gmail.com', '127.0.0.1:444', '127.0.0.1:446', 'CREATE_ADMIN_USER,DELETE_ADMIN_USER,REGISTER_TRADER,FUND_TRADER_ACCOUNT,TRADER_FUND_WITHDRAWAL', 'gon', '2017-01-03 15:14:41'),
(14, 'zim', '0ef25ae00f40c8471ee44b720036abcc25e96cee', 'MatadorPrime', NULL, 'm.zimkind@matadorprime.com', 'map.elcmarkets.com', 'matadorprime.elcmarkets.com', 'CREATE_ADMIN_USER,DELETE_ADMIN_USER,REGISTER_TRADER,FUND_TRADER_ACCOUNT,TRADER_FUND_WITHDRAWAL', 'chuks', '2017-03-01 07:04:06');

-- --------------------------------------------------------

--
-- Table structure for table `brokers`
--

CREATE TABLE IF NOT EXISTS `brokers` (
  `SN` int(11) NOT NULL,
  `USERNAME` varchar(200) DEFAULT NULL,
  `PASSWORD` varchar(200) DEFAULT NULL,
  `COMPANY` varchar(200) DEFAULT NULL,
  `WEBSITE` varchar(200) DEFAULT NULL,
  `EMAIL` varchar(200) DEFAULT NULL,
  `BROKER_ADMIN_HOST_NAME` varchar(200) DEFAULT NULL,
  `TRADE_PLATFORM_HOST_NAME` varchar(200) DEFAULT NULL,
  `REGISTERED_BY` varchar(200) DEFAULT NULL,
  `DATE_REGISTERED` datetime NOT NULL DEFAULT '1900-01-01 00:00:00'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `brokers`
--

INSERT INTO `brokers` (`SN`, `USERNAME`, `PASSWORD`, `COMPANY`, `WEBSITE`, `EMAIL`, `BROKER_ADMIN_HOST_NAME`, `TRADE_PLATFORM_HOST_NAME`, `REGISTERED_BY`, `DATE_REGISTERED`) VALUES
(0, 'zim', '0ef25ae00f40c8471ee44b720036abcc25e96cee', 'MatadorPrime', 'www.matadorprime.com', 'm.zimkind@matadorprime.com', 'map.elcmarkets.com', 'matadorprime.elcmarkets.com', 'chuks', '2017-03-01 07:04:05');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `admin`
--
ALTER TABLE `admin`
 ADD PRIMARY KEY (`SN`), ADD UNIQUE KEY `USERNAME` (`USERNAME`);

--
-- Indexes for table `brokers`
--
ALTER TABLE `brokers`
 ADD PRIMARY KEY (`SN`), ADD UNIQUE KEY `USERNAME` (`USERNAME`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `admin`
--
ALTER TABLE `admin`
MODIFY `SN` int(11) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=15;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
