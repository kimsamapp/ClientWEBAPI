-- phpMyAdmin SQL Dump
-- version 5.2.0
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Sep 08, 2024 at 04:15 PM
-- Server version: 10.4.24-MariaDB
-- PHP Version: 8.1.6

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `projectalphav1`
--

-- --------------------------------------------------------

--
-- Table structure for table `acontactus`
--

CREATE TABLE `acontactus` (
  `AContactUsId` int(11) NOT NULL,
  `Name` varchar(250) DEFAULT NULL,
  `EmailAddress` varchar(250) DEFAULT NULL,
  `ContactUsNumber` varchar(250) DEFAULT NULL,
  `MessageContext` text DEFAULT NULL,
  `IsStatus` int(11) DEFAULT NULL,
  `DateCreated` datetime DEFAULT current_timestamp(),
  `AHeaderServicesId` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `afcontacts`
--

CREATE TABLE `afcontacts` (
  `AFContactsId` int(11) NOT NULL,
  `Name` varchar(150) DEFAULT NULL,
  `EmailAddress` varchar(200) DEFAULT NULL,
  `ContactNumber` varchar(20) DEFAULT NULL,
  `PlatformContact` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `aflinks`
--

CREATE TABLE `aflinks` (
  `AFLinksId` int(11) NOT NULL,
  `LinkUrl` varchar(200) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `afooter`
--

CREATE TABLE `afooter` (
  `AFooterId` int(11) NOT NULL,
  `Address` varchar(500) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `aheader`
--

CREATE TABLE `aheader` (
  `AHeaderId` int(11) NOT NULL,
  `HeaderTextMessage` varchar(500) DEFAULT NULL,
  `HeaderTextSubMessage` varchar(500) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `aheaderservices`
--

CREATE TABLE `aheaderservices` (
  `AHeaderServicesId` int(11) NOT NULL,
  `HeaderName` varchar(100) DEFAULT NULL,
  `Description` varchar(500) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `aheaderservices`
--

INSERT INTO `aheaderservices` (`AHeaderServicesId`, `HeaderName`, `Description`) VALUES
(1, 'For Sale', 'To Sell'),
(2, 'For Rent', 'To Rent'),
(3, 'Buy', 'Buy'),
(4, 'Rent', 'Rent'),
(5, 'Property Management', 'Property Management');

-- --------------------------------------------------------

--
-- Table structure for table `apersoninformation`
--

CREATE TABLE `apersoninformation` (
  `PersonId` int(11) NOT NULL,
  `Firstname` varchar(100) DEFAULT NULL,
  `Middlename` varchar(100) DEFAULT NULL,
  `Lastname` varchar(100) DEFAULT NULL,
  `ContactNumber` varchar(100) DEFAULT NULL,
  `EmailAddress` varchar(200) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `apersoninformation`
--

INSERT INTO `apersoninformation` (`PersonId`, `Firstname`, `Middlename`, `Lastname`, `ContactNumber`, `EmailAddress`) VALUES
(1, 'Kim Joshua', '-', 'Espanol', '09395274010', 'kim.joshua.espanol.work@gmail.com');

-- --------------------------------------------------------

--
-- Table structure for table `aproperty`
--

CREATE TABLE `aproperty` (
  `PropertyId` int(11) NOT NULL,
  `PropertyCode` varchar(100) DEFAULT NULL,
  `Name` varchar(300) DEFAULT NULL,
  `Description` text DEFAULT NULL,
  `AHeaderServicesId` int(11) DEFAULT NULL,
  `LocationA` text DEFAULT NULL,
  `PriceAmount` decimal(16,2) DEFAULT NULL,
  `BedRooms` int(11) DEFAULT NULL,
  `BathRooms` int(11) DEFAULT NULL,
  `FloorArea` decimal(16,2) DEFAULT NULL,
  `LotArea` decimal(16,2) DEFAULT NULL,
  `Garage` int(11) DEFAULT NULL,
  `Furnishing` varchar(100) DEFAULT NULL,
  `DateCreated` datetime DEFAULT current_timestamp(),
  `IsStatus` int(11) DEFAULT NULL,
  `IsActive` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `aproperty`
--

INSERT INTO `aproperty` (`PropertyId`, `PropertyCode`, `Name`, `Description`, `AHeaderServicesId`, `LocationA`, `PriceAmount`, `BedRooms`, `BathRooms`, `FloorArea`, `LotArea`, `Garage`, `Furnishing`, `DateCreated`, `IsStatus`, `IsActive`) VALUES
(1, '75a45667-55aa-49b6-878a-399b4267c1b9', 'Property #1 Test Data', 'This a test of property #1', 2, 'Cebu', '3000.00', 1, 1, '44.00', '1500.00', 1, 'Not Furnished', '2024-06-27 19:47:15', 1, 2),
(2, '7368969d-fbc4-48a7-8334-c69fa7dc7e3d', 'Test Property', 'qkdbqwjdquiwhdiq', 1, 'Lahug', '2000000.00', 2, 2, '60.00', '120.00', 1, 'Furnished', '2024-07-01 10:09:45', 1, 2);

-- --------------------------------------------------------

--
-- Table structure for table `apropertyamenities`
--

CREATE TABLE `apropertyamenities` (
  `APropertyAmenityId` int(11) NOT NULL,
  `PropertyId` int(11) DEFAULT NULL,
  `Name` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `apropertyamenities`
--

INSERT INTO `apropertyamenities` (`APropertyAmenityId`, `PropertyId`, `Name`) VALUES
(2, 1, 'pool'),
(4, 1, 'amenities');

-- --------------------------------------------------------

--
-- Table structure for table `apropertyimage`
--

CREATE TABLE `apropertyimage` (
  `APropertyImageId` int(11) NOT NULL,
  `PropertyId` int(11) DEFAULT NULL,
  `FileName` varchar(100) DEFAULT NULL,
  `FileBase64Name` longtext DEFAULT NULL,
  `FilePath` varchar(200) DEFAULT NULL,
  `FileSize` bigint(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `apropertyinclusions`
--

CREATE TABLE `apropertyinclusions` (
  `APropertyInclusionId` int(11) NOT NULL,
  `PropertyId` int(11) DEFAULT NULL,
  `Name` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `apropertyinclusions`
--

INSERT INTO `apropertyinclusions` (`APropertyInclusionId`, `PropertyId`, `Name`) VALUES
(1, 1, 'Add this one to your database'),
(2, 1, 'Add this one to your database 2');

-- --------------------------------------------------------

--
-- Table structure for table `auser`
--

CREATE TABLE `auser` (
  `UserId` int(11) NOT NULL,
  `Username` varchar(100) DEFAULT NULL,
  `PasswordHash` longtext DEFAULT NULL,
  `PasswordSalt` longtext DEFAULT NULL,
  `DateCreated` datetime DEFAULT current_timestamp(),
  `PersonId` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `auser`
--

INSERT INTO `auser` (`UserId`, `Username`, `PasswordHash`, `PasswordSalt`, `DateCreated`, `PersonId`) VALUES
(1, 'kim.joshua.espanol.work@gmail.com', '/jJQmui5E6ww6GAVOVN30LW4GXFRZAgpvW4CgUEnfMjEYKlncD1OVflizBhuTF/6G0pRhxI72Oi8Xgx0FFm60Q==', 'aydy3BamlLvQRHuC0JzMnSjIdfs1r2Ys2g0cJ0Pdrfnv/ym4PXAGOiEmblJzSWZwuoPTEqHfZNAL8dTkypZKsT0SHwyExp6QjNXPvyKzyRS1EbvMpvunkajCHDwYLDWmhoDngfOyZV1CaRxKqygfBx+8+vDhLGc9JcQP1HBLADQ=', '2024-06-21 01:25:54', 1),
(2, 'espanol@gmail.com', 'test123', 'test123', '2024-08-13 23:24:14', 1),
(3, 'admincreate', 'Ops/Jqgoe4rU0FW2YlkUnLZDhZVCQPEMV0OTZG6QXkRjwGdDhZltubdzXMuX6BziiX7zXaQhe5rZboKYRhzIOg==', 'ihROjIYEdoDPjU83vygCoDD2icP1Q/XbUXNYQGQkDzqOpP1dilfyeZMZXAQ9wuU/q9XSScMfu/jMQ60oW/KH86BC6gafp3IzApqs4RBOHrlnfne9WeW2dDQMJFCfJj2ZDAoH6TsxKj9QVWC3AcTgbp49mBKi7JF82rsIqGlE94I=', '2024-08-13 23:28:11', NULL),
(4, 'admincreate@gmail.com', 'RHHdcbYc1Rg9FC0p6vKoAGCzmTJy6UBXKTbd8UEza6HzPbsbfzAOPHX3pfVK14WtPtS674hrI1FG1ToVwhX5bg==', 'baUpMQyK+tckURhHWcmjHPIn1a7mZg9sgnF5dCDcQPVPbUpfofT07xZwI3c5D+5Yu6dTlC3LR+B+L1aJuqDwlsvWwAnY9gkCdGNSZYuu+vNCLOm/DpGcNSEc52rDf9Wicixix94osPQUD857Qvki8A+VYsH+s7IluJYSBJWRIO4=', '2024-08-13 23:28:43', NULL);

--
-- Indexes for dumped tables
--

--
-- Indexes for table `acontactus`
--
ALTER TABLE `acontactus`
  ADD PRIMARY KEY (`AContactUsId`),
  ADD KEY `FK_AContactUs_AHeaderServicesId` (`AHeaderServicesId`);

--
-- Indexes for table `afcontacts`
--
ALTER TABLE `afcontacts`
  ADD PRIMARY KEY (`AFContactsId`);

--
-- Indexes for table `aflinks`
--
ALTER TABLE `aflinks`
  ADD PRIMARY KEY (`AFLinksId`);

--
-- Indexes for table `afooter`
--
ALTER TABLE `afooter`
  ADD PRIMARY KEY (`AFooterId`);

--
-- Indexes for table `aheader`
--
ALTER TABLE `aheader`
  ADD PRIMARY KEY (`AHeaderId`);

--
-- Indexes for table `aheaderservices`
--
ALTER TABLE `aheaderservices`
  ADD PRIMARY KEY (`AHeaderServicesId`);

--
-- Indexes for table `apersoninformation`
--
ALTER TABLE `apersoninformation`
  ADD PRIMARY KEY (`PersonId`);

--
-- Indexes for table `aproperty`
--
ALTER TABLE `aproperty`
  ADD PRIMARY KEY (`PropertyId`),
  ADD KEY `FK_AProperty_AHeaderServicesId` (`AHeaderServicesId`);

--
-- Indexes for table `apropertyamenities`
--
ALTER TABLE `apropertyamenities`
  ADD PRIMARY KEY (`APropertyAmenityId`),
  ADD KEY `FK_APropertyAmenities_PropertyId` (`PropertyId`);

--
-- Indexes for table `apropertyimage`
--
ALTER TABLE `apropertyimage`
  ADD PRIMARY KEY (`APropertyImageId`),
  ADD KEY `FK_APropertyImage_PropertyId` (`PropertyId`);

--
-- Indexes for table `apropertyinclusions`
--
ALTER TABLE `apropertyinclusions`
  ADD PRIMARY KEY (`APropertyInclusionId`),
  ADD KEY `FK_APropertyInclusions_PropertyId` (`PropertyId`);

--
-- Indexes for table `auser`
--
ALTER TABLE `auser`
  ADD PRIMARY KEY (`UserId`),
  ADD KEY `FK_AUser_PersonId` (`PersonId`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `acontactus`
--
ALTER TABLE `acontactus`
  MODIFY `AContactUsId` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `afcontacts`
--
ALTER TABLE `afcontacts`
  MODIFY `AFContactsId` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `aflinks`
--
ALTER TABLE `aflinks`
  MODIFY `AFLinksId` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `afooter`
--
ALTER TABLE `afooter`
  MODIFY `AFooterId` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `aheader`
--
ALTER TABLE `aheader`
  MODIFY `AHeaderId` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `aheaderservices`
--
ALTER TABLE `aheaderservices`
  MODIFY `AHeaderServicesId` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `apersoninformation`
--
ALTER TABLE `apersoninformation`
  MODIFY `PersonId` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `aproperty`
--
ALTER TABLE `aproperty`
  MODIFY `PropertyId` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `apropertyamenities`
--
ALTER TABLE `apropertyamenities`
  MODIFY `APropertyAmenityId` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `apropertyimage`
--
ALTER TABLE `apropertyimage`
  MODIFY `APropertyImageId` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `apropertyinclusions`
--
ALTER TABLE `apropertyinclusions`
  MODIFY `APropertyInclusionId` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `auser`
--
ALTER TABLE `auser`
  MODIFY `UserId` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `acontactus`
--
ALTER TABLE `acontactus`
  ADD CONSTRAINT `FK_AContactUs_AHeaderServicesId` FOREIGN KEY (`AHeaderServicesId`) REFERENCES `aheaderservices` (`AHeaderServicesId`);

--
-- Constraints for table `aproperty`
--
ALTER TABLE `aproperty`
  ADD CONSTRAINT `FK_AProperty_AHeaderServicesId` FOREIGN KEY (`AHeaderServicesId`) REFERENCES `aheaderservices` (`AHeaderServicesId`),
  ADD CONSTRAINT `aproperty_ibfk_1` FOREIGN KEY (`AHeaderServicesId`) REFERENCES `aheaderservices` (`AHeaderServicesId`);

--
-- Constraints for table `apropertyamenities`
--
ALTER TABLE `apropertyamenities`
  ADD CONSTRAINT `FK_APropertyAmenities_PropertyId` FOREIGN KEY (`PropertyId`) REFERENCES `aproperty` (`PropertyId`),
  ADD CONSTRAINT `apropertyamenities_ibfk_1` FOREIGN KEY (`PropertyId`) REFERENCES `aproperty` (`PropertyId`);

--
-- Constraints for table `apropertyimage`
--
ALTER TABLE `apropertyimage`
  ADD CONSTRAINT `FK_APropertyImage_PropertyId` FOREIGN KEY (`PropertyId`) REFERENCES `aproperty` (`PropertyId`),
  ADD CONSTRAINT `apropertyimage_ibfk_1` FOREIGN KEY (`PropertyId`) REFERENCES `aproperty` (`PropertyId`);

--
-- Constraints for table `apropertyinclusions`
--
ALTER TABLE `apropertyinclusions`
  ADD CONSTRAINT `FK_APropertyInclusions_PropertyId` FOREIGN KEY (`PropertyId`) REFERENCES `aproperty` (`PropertyId`),
  ADD CONSTRAINT `apropertyinclusions_ibfk_1` FOREIGN KEY (`PropertyId`) REFERENCES `aproperty` (`PropertyId`);

--
-- Constraints for table `auser`
--
ALTER TABLE `auser`
  ADD CONSTRAINT `FK_AUser_PersonId` FOREIGN KEY (`PersonId`) REFERENCES `apersoninformation` (`PersonId`),
  ADD CONSTRAINT `auser_ibfk_1` FOREIGN KEY (`PersonId`) REFERENCES `apersoninformation` (`PersonId`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
