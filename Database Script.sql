-- phpMyAdmin SQL Dump
-- version 5.1.3
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1:3306
-- Generation Time: Apr 22, 2022 at 07:55 PM
-- Server version: 5.7.31
-- PHP Version: 8.1.2

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `e-learning`
--

-- --------------------------------------------------------

--
-- Table structure for table `course`
--

DROP TABLE IF EXISTS `course`;
CREATE TABLE IF NOT EXISTS `course` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `Name` varchar(70) COLLATE utf16_bin NOT NULL,
  `Instructor` varchar(50) COLLATE utf16_bin NOT NULL,
  `Institute` varchar(70) COLLATE utf16_bin DEFAULT NULL,
  `Description` json NOT NULL,
  `Image` mediumblob NOT NULL,
  `Category` varchar(50) COLLATE utf16_bin DEFAULT NULL,
  `Preview_video_link` varchar(37) COLLATE utf16_bin NOT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf16 COLLATE=utf16_bin;

-- --------------------------------------------------------

--
-- Table structure for table `course_enrol`
--

DROP TABLE IF EXISTS `course_enrol`;
CREATE TABLE IF NOT EXISTS `course_enrol` (
  `User_ID` int(11) NOT NULL,
  `Course_ID` int(11) NOT NULL,
  `Time_enroll` datetime DEFAULT NULL,
  `progress` int(11) DEFAULT NULL COMMENT 'lesson id',
  KEY `User_ID` (`User_ID`,`Course_ID`),
  KEY `Course_ID` (`Course_ID`),
  KEY `progress_fkLessonID` (`progress`)
) ENGINE=InnoDB DEFAULT CHARSET=utf16 COLLATE=utf16_bin;

--
-- Triggers `course_enrol`
--
DROP TRIGGER IF EXISTS `CourseEnrollDate`;
DELIMITER $$
CREATE TRIGGER `CourseEnrollDate` AFTER INSERT ON `course_enrol` FOR EACH ROW INSERT INTO course_enrol (Time_enroll)
VALUE (NOW())
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `lesson_content`
--

DROP TABLE IF EXISTS `lesson_content`;
CREATE TABLE IF NOT EXISTS `lesson_content` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `ChapterID` int(11) NOT NULL,
  `TextID` int(11) DEFAULT NULL,
  `VideoID` int(11) DEFAULT NULL,
  `Lesson_title` varchar(50) COLLATE utf16_bin NOT NULL,
  PRIMARY KEY (`ID`),
  KEY `ChapterID` (`ChapterID`),
  KEY `TextID` (`TextID`),
  KEY `VideoID` (`VideoID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf16 COLLATE=utf16_bin;

-- --------------------------------------------------------

--
-- Table structure for table `lesson_text`
--

DROP TABLE IF EXISTS `lesson_text`;
CREATE TABLE IF NOT EXISTS `lesson_text` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `Lesson_ID` int(11) NOT NULL,
  `Text` varchar(3000) COLLATE utf16_bin NOT NULL,
  PRIMARY KEY (`ID`),
  KEY `Lesson_ID` (`Lesson_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf16 COLLATE=utf16_bin;

-- --------------------------------------------------------

--
-- Table structure for table `lesson_video`
--

DROP TABLE IF EXISTS `lesson_video`;
CREATE TABLE IF NOT EXISTS `lesson_video` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `Lesson_ID` int(11) NOT NULL,
  `Video` longblob,
  `Video_link` varchar(37) COLLATE utf16_bin DEFAULT NULL,
  PRIMARY KEY (`ID`),
  KEY `Lesson_ID` (`Lesson_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf16 COLLATE=utf16_bin;

-- --------------------------------------------------------

--
-- Table structure for table `unit`
--

DROP TABLE IF EXISTS `unit`;
CREATE TABLE IF NOT EXISTS `unit` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `Course_ID` int(11) NOT NULL,
  `Unit_number` int(11) NOT NULL,
  `Title` varchar(50) COLLATE utf16_bin NOT NULL,
  PRIMARY KEY (`ID`),
  KEY `Course_ID` (`Course_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf16 COLLATE=utf16_bin;

-- --------------------------------------------------------

--
-- Table structure for table `user`
--

DROP TABLE IF EXISTS `user`;
CREATE TABLE IF NOT EXISTS `user` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `Fname` varchar(45) COLLATE utf16_bin NOT NULL,
  `Lname` varchar(45) COLLATE utf16_bin NOT NULL,
  `email` varchar(70) COLLATE utf16_bin NOT NULL,
  `register_date` datetime DEFAULT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf16 COLLATE=utf16_bin;

--
-- Triggers `user`
--
DROP TRIGGER IF EXISTS `RegistrationDate`;
DELIMITER $$
CREATE TRIGGER `RegistrationDate` AFTER INSERT ON `user` FOR EACH ROW INSERT INTO user (register_date)
VALUE (NOW())
$$
DELIMITER ;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `course_enrol`
--
ALTER TABLE `course_enrol`
  ADD CONSTRAINT `course_enrol_ibfk_1` FOREIGN KEY (`Course_ID`) REFERENCES `course` (`ID`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `course_enrol_ibfk_2` FOREIGN KEY (`User_ID`) REFERENCES `user` (`ID`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `course_enrol_ibfk_3` FOREIGN KEY (`progress`) REFERENCES `lesson_content` (`ID`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `lesson_content`
--
ALTER TABLE `lesson_content`
  ADD CONSTRAINT `lesson_content_ibfk_1` FOREIGN KEY (`ChapterID`) REFERENCES `unit` (`ID`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `lesson_text`
--
ALTER TABLE `lesson_text`
  ADD CONSTRAINT `lesson_text_ibfk_1` FOREIGN KEY (`Lesson_ID`) REFERENCES `lesson_content` (`ID`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `lesson_video`
--
ALTER TABLE `lesson_video`
  ADD CONSTRAINT `lesson_video_ibfk_1` FOREIGN KEY (`Lesson_ID`) REFERENCES `lesson_content` (`ID`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `unit`
--
ALTER TABLE `unit`
  ADD CONSTRAINT `unit_ibfk_1` FOREIGN KEY (`Course_ID`) REFERENCES `course` (`ID`) ON DELETE CASCADE ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
