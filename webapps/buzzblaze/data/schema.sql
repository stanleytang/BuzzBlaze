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

-- --------------------------------------------------------

--
-- Table structure for table `bb_admins`
--

CREATE TABLE IF NOT EXISTS `bb_admins` (
  `admin_ID` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `admin_login` varchar(60) COLLATE utf8_unicode_ci NOT NULL,
  `admin_password` varchar(64) COLLATE utf8_unicode_ci NOT NULL,
  PRIMARY KEY (`admin_ID`),
  UNIQUE KEY `admin_login` (`admin_login`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `bb_emails`
--

CREATE TABLE IF NOT EXISTS `bb_emails` (
  `email_ID` int(11) NOT NULL AUTO_INCREMENT,
  `email_event` varchar(60) COLLATE utf8_unicode_ci NOT NULL,
  `email_title` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `email_body` text COLLATE utf8_unicode_ci NOT NULL,
  PRIMARY KEY (`email_ID`),
  UNIQUE KEY `email_event` (`email_event`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `bb_feeds`
--

CREATE TABLE IF NOT EXISTS `bb_feeds` (
  `feed_ID` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `feed_uuid` char(36) COLLATE utf8_unicode_ci NOT NULL,
  `feed_url` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `feed_website` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `feed_title` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `feed_description` text COLLATE utf8_unicode_ci,
  `feed_hub` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `feed_image` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `feed_added` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `feed_last_fetched` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  PRIMARY KEY (`feed_ID`),
  UNIQUE KEY `feed_url` (`feed_url`),
  KEY `feed_uuid` (`feed_uuid`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `bb_feed_entries`
--

CREATE TABLE IF NOT EXISTS `bb_feed_entries` (
  `entry_ID` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `feed_ID` bigint(20) unsigned NOT NULL,
  `entry_uuid` char(36) COLLATE utf8_unicode_ci NOT NULL,
  `entry_guid` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `entry_url` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `entry_title` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `entry_published` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `entry_description` longtext COLLATE utf8_unicode_ci,
  `entry_content` longtext COLLATE utf8_unicode_ci,
  `entry_modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `entry_hash` varchar(32) COLLATE utf8_unicode_ci NOT NULL,
  PRIMARY KEY (`entry_ID`),
  UNIQUE KEY `entry_guid` (`entry_guid`),
  KEY `feed_ID` (`feed_ID`),
  KEY `entry_uuid` (`entry_uuid`),
  FULLTEXT KEY `entry_title` (`entry_title`,`entry_description`,`entry_content`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `bb_invites`
--

CREATE TABLE IF NOT EXISTS `bb_invites` (
  `invite_ID` int(11) NOT NULL AUTO_INCREMENT,
  `invite_code` varchar(5) COLLATE utf8_unicode_ci NOT NULL,
  `invite_expires` date NOT NULL DEFAULT '0000-00-00',
  `invite_reg_count` int(11) NOT NULL,
  PRIMARY KEY (`invite_ID`),
  UNIQUE KEY `invite_code` (`invite_code`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `bb_notifications`
--

CREATE TABLE IF NOT EXISTS `bb_notifications` (
  `notification_ID` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `notification_scope` int(11) NOT NULL DEFAULT '1',
  `notification_event` varchar(100) COLLATE utf8_unicode_ci NOT NULL,
  `notification_created` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `user_ID` bigint(20) unsigned NOT NULL,
  `object_ID` int(11) NOT NULL DEFAULT '0',
  `object_type` varchar(100) COLLATE utf8_unicode_ci NOT NULL,
  PRIMARY KEY (`notification_ID`),
  KEY `user_ID` (`user_ID`),
  KEY `object_ID` (`object_ID`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `bb_relationships`
--

CREATE TABLE IF NOT EXISTS `bb_relationships` (
  `user_ID` bigint(20) unsigned NOT NULL,
  `follower_ID` bigint(20) unsigned NOT NULL,
  `relationship_created` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`user_ID`,`follower_ID`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `bb_settings`
--

CREATE TABLE IF NOT EXISTS `bb_settings` (
  `setting_ID` int(11) NOT NULL AUTO_INCREMENT,
  `setting_name` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `setting_value` text COLLATE utf8_unicode_ci NOT NULL,
  PRIMARY KEY (`setting_ID`),
  UNIQUE KEY `setting_name` (`setting_name`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `bb_users`
--

CREATE TABLE IF NOT EXISTS `bb_users` (
  `user_ID` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `user_login` varchar(64) COLLATE utf8_unicode_ci NOT NULL,
  `user_password` varchar(64) COLLATE utf8_unicode_ci NOT NULL,
  `user_full_name` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `user_email` varchar(100) COLLATE utf8_unicode_ci NOT NULL,
  `user_status` int(11) NOT NULL DEFAULT '0',
  `user_visibility` int(11) NOT NULL DEFAULT '1',
  `user_registered` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `user_secret` varchar(40) COLLATE utf8_unicode_ci NOT NULL,
  `user_last_login` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `user_last_ip` int(10) unsigned NOT NULL,
  PRIMARY KEY (`user_ID`),
  UNIQUE KEY `email` (`user_email`),
  UNIQUE KEY `user_login` (`user_login`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `bb_user_actions`
--

CREATE TABLE IF NOT EXISTS `bb_user_actions` (
  `action_ID` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `user_ID` bigint(20) unsigned NOT NULL,
  `entry_ID` bigint(20) unsigned NOT NULL,
  `action_type` int(11) NOT NULL DEFAULT '0',
  `action_timestamp` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`action_ID`),
  UNIQUE KEY `user_ID` (`user_ID`,`entry_ID`,`action_type`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `bb_user_feeds`
--

CREATE TABLE IF NOT EXISTS `bb_user_feeds` (
  `ufeed_ID` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `feed_ID` bigint(20) unsigned NOT NULL,
  `page_ID` bigint(20) unsigned NOT NULL,
  `ufeed_display` int(11) NOT NULL DEFAULT '0',
  `ufeed_title` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `ufeed_color` varchar(64) COLLATE utf8_unicode_ci NOT NULL DEFAULT 'color-white',
  `ufeed_order` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`ufeed_ID`),
  UNIQUE KEY `unique_combo` (`feed_ID`,`page_ID`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `bb_user_meta`
--

CREATE TABLE IF NOT EXISTS `bb_user_meta` (
  `meta_ID` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `user_ID` int(10) unsigned NOT NULL DEFAULT '0',
  `meta_key` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `meta_value` longtext COLLATE utf8_unicode_ci NOT NULL,
  PRIMARY KEY (`meta_ID`),
  KEY `user_ID` (`user_ID`),
  KEY `meta_key` (`meta_key`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `bb_user_pages`
--

CREATE TABLE IF NOT EXISTS `bb_user_pages` (
  `page_ID` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `user_ID` bigint(20) unsigned NOT NULL,
  `page_name` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `page_title` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  PRIMARY KEY (`page_ID`),
  UNIQUE KEY `user_ID` (`user_ID`,`page_name`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
