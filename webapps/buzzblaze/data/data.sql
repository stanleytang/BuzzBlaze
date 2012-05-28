-- phpMyAdmin SQL Dump
-- version 3.3.8.1
-- http://www.phpmyadmin.net
--
-- Host: localhost
-- Generation Time: Jan 14, 2011 at 05:39 PM
-- Server version: 5.1.46
-- PHP Version: 5.3.3

SET SQL_MODE="NO_AUTO_VALUE_ON_ZERO";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

--
-- Database: `w_buzzblaze`
--

--
-- Dumping data for table `bb_admins`
--

INSERT INTO `bb_admins` (`admin_ID`, `admin_login`, `admin_password`) VALUES
(1, 'admin', '$P$Bcf02juZDTcRGLMssMohjZhjVFd2EW/');

--
-- Dumping data for table `bb_emails`
--

INSERT INTO `bb_emails` (`email_ID`, `email_event`, `email_title`, `email_body`) VALUES
(1, 'user_registration', 'User Registration!', '<p>Hello %fullname%,<p>\r\n\r\n<p>\r\nYou are now registered. To confirm your email please click link below:<br />\r\n<a href="%confirm_url%">%confirm_url%</a>\r\n<p>\r\n\r\n<p>\r\nBest,<br />\r\nBuzzBlaze\r\n</p>'),
(2, 'forgot_password', 'Password Reset Assistance', '<p>Hi %fullname%,</p>\r\n\r\n<p>\r\nPlease click link below to reset your password:<br />\r\n<a href="%reset_url%">%reset_url%</a>\r\n</p>\r\n\r\n<p>\r\nBest,<br />\r\nBuzzBlaze\r\n</p>'),
(3, 'user_follow', '%follower_fullname% is now following you!', '<p>Hi %fullname%,</p>\r\n\r\n<p>\r\n<a href="%follower_profile_url%">%follower_fullname% (%follower_username%)</a> is now following you.\r\n</p>\r\n\r\n<p>\r\nBest,<br />\r\nBuzzBlaze\r\n</p>');

--
-- Dumping data for table `bb_settings`
--

INSERT INTO `bb_settings` (`setting_ID`, `setting_name`, `setting_value`) VALUES
(1, 'filter_urls', 'http://freelanceswitch.com/\r\nhttp://wordpress.com/\r\nhttp://mashable.com/\r\nhttp://www.chrisbrogan.com/\r\nhttp://alternateidea.com/\r\nhttp://www.danwebb.net/\r\nhttp://ambethia.com'),
(2, 'ad_code', '<a href="#"><img src="/images/ad.jpg" alt="" /></a>'),
(3, 'beta_mode', '0'),
(4, 'analytic_code', '-put analytic code here -'),
(5, 'no_ad', '1');
