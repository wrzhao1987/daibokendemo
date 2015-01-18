-- MySQL dump 10.13  Distrib 5.5.38, for debian-linux-gnu (x86_64)
--
-- Host: localhost    Database: nami
-- ------------------------------------------------------
-- Server version	5.5.38-0+wheezy1

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
-- Table structure for table `accu_login_bonus_2014_05`
--

DROP TABLE IF EXISTS `accu_login_bonus_2014_05`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `accu_login_bonus_2014_05` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(10) unsigned NOT NULL,
  `accu_value` tinyint(4) DEFAULT NULL,
  `accept_ts` int(11) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `idx_ud` (`user_id`,`accu_value`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `announce`
--

DROP TABLE IF EXISTS `announce`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `announce` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(20) NOT NULL,
  `content` text NOT NULL,
  `weight` tinyint(3) NOT NULL,
  `start` datetime NOT NULL,
  `end` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `battle_history_mission`
--

DROP TABLE IF EXISTS `battle_history_mission`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `battle_history_mission` (
  `battle_id` int(11) NOT NULL,
  `attacker` int(10) unsigned NOT NULL,
  `target` int(10) unsigned NOT NULL,
  `result` tinyint(4) DEFAULT '-1',
  `battle_info` varchar(512) DEFAULT NULL,
  `gain` varchar(512) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`battle_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `battle_history_rank`
--

DROP TABLE IF EXISTS `battle_history_rank`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `battle_history_rank` (
  `battle_id` int(11) NOT NULL,
  `attacker` int(10) unsigned NOT NULL,
  `target` int(10) unsigned NOT NULL,
  `result` tinyint(4) DEFAULT '-1',
  `battle_info` varchar(512) DEFAULT NULL,
  `gain` varchar(512) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`battle_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `battle_history_rob`
--

DROP TABLE IF EXISTS `battle_history_rob`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `battle_history_rob` (
  `battle_id` int(11) NOT NULL,
  `attacker` int(10) unsigned NOT NULL,
  `target` int(10) unsigned NOT NULL,
  `result` tinyint(4) DEFAULT '-1',
  `battle_info` varchar(512) DEFAULT NULL,
  `gain` varchar(512) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`battle_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `card_raffle_record`
--

DROP TABLE IF EXISTS `card_raffle_record`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `card_raffle_record` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(10) unsigned NOT NULL,
  `type` tinyint(4) NOT NULL,
  `free` tinyint(4) NOT NULL DEFAULT '0',
  `seq` int(11) NOT NULL,
  `user_card_id` int(11) NOT NULL,
  `card_id` smallint(6) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=24311 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `email`
--

DROP TABLE IF EXISTS `email`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `email` (
  `email` varchar(200) NOT NULL,
  `secret_code` varchar(100) NOT NULL,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `guild`
--

DROP TABLE IF EXISTS `guild`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `guild` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `icon` tinyint(3) unsigned NOT NULL,
  `level` tinyint(3) NOT NULL,
  `notice` text NOT NULL,
  `fund` bigint(20) NOT NULL,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=22 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `guild_log`
--

DROP TABLE IF EXISTS `guild_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `guild_log` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `uid` int(10) NOT NULL,
  `gid` int(10) unsigned NOT NULL,
  `type` tinyint(3) NOT NULL,
  `params` varchar(200) NOT NULL,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `uid` (`uid`,`type`),
  KEY `gid` (`gid`)
) ENGINE=InnoDB AUTO_INCREMENT=1420 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `guild_member`
--

DROP TABLE IF EXISTS `guild_member`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `guild_member` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `uid` int(10) NOT NULL,
  `gid` int(10) unsigned NOT NULL,
  `grade` tinyint(1) NOT NULL,
  `contr` int(10) NOT NULL,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uid` (`uid`),
  KEY `grade_idx` (`gid`,`grade`)
) ENGINE=InnoDB AUTO_INCREMENT=83 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `guild_request`
--

DROP TABLE IF EXISTS `guild_request`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `guild_request` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `uid` int(10) NOT NULL,
  `gid` int(10) unsigned NOT NULL,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `uid` (`uid`),
  KEY `gid` (`gid`)
) ENGINE=InnoDB AUTO_INCREMENT=127 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `kpi`
--

DROP TABLE IF EXISTS `kpi`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `kpi` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `date` char(8) NOT NULL,
  `type` tinyint(3) unsigned NOT NULL,
  `data` text NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `date_type` (`date`,`type`)
) ENGINE=InnoDB AUTO_INCREMENT=51614 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `login_bonus_2014_05`
--

DROP TABLE IF EXISTS `login_bonus_2014_05`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `login_bonus_2014_05` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(10) unsigned NOT NULL,
  `bonus_day` tinyint(4) DEFAULT NULL,
  `accept_ts` int(11) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `idx_ud` (`user_id`,`bonus_day`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `mail_text`
--

DROP TABLE IF EXISTS `mail_text`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `mail_text` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `content` text,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `mission_attack_history`
--

DROP TABLE IF EXISTS `mission_attack_history`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `mission_attack_history` (
  `role_id` int(11) DEFAULT NULL,
  `section_id` int(11) DEFAULT NULL,
  `result` tinyint(4) DEFAULT NULL,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime DEFAULT NULL,
  `battle_id` int(11) DEFAULT NULL,
  `type` int(11) DEFAULT '0',
  UNIQUE KEY `idx_btl` (`battle_id`,`type`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `pvp_challenge_history`
--

DROP TABLE IF EXISTS `pvp_challenge_history`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `pvp_challenge_history` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `attacker` int(10) unsigned DEFAULT NULL,
  `defencer` int(10) unsigned DEFAULT NULL,
  `result` tinyint(4) DEFAULT NULL,
  `battle_info` varchar(512) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `pvp_prof`
--

DROP TABLE IF EXISTS `pvp_prof`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `pvp_prof` (
  `role_id` int(10) unsigned NOT NULL,
  `best_rank` int(10) unsigned DEFAULT NULL,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime DEFAULT NULL,
  `init_rank` int(10) unsigned NOT NULL,
  UNIQUE KEY `idx_role` (`role_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `pvp_rob_history`
--

DROP TABLE IF EXISTS `pvp_rob_history`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `pvp_rob_history` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `attacker` int(10) unsigned NOT NULL,
  `defencer` int(10) unsigned NOT NULL,
  `result` tinyint(4) DEFAULT '-1',
  `battle_info` varchar(512) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_dfc` (`defencer`),
  KEY `idx_atk` (`attacker`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user`
--

DROP TABLE IF EXISTS `user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user` (
  `id` bigint(20) unsigned NOT NULL,
  `account_id` int(11) NOT NULL,
  `name` varchar(200) NOT NULL,
  `level` int(10) unsigned NOT NULL DEFAULT '1',
  `exp` int(10) unsigned NOT NULL DEFAULT '0',
  `coin` int(10) unsigned NOT NULL DEFAULT '0',
  `gold` int(10) unsigned NOT NULL DEFAULT '0',
  `energy` int(10) unsigned NOT NULL DEFAULT '0',
  `token` int(10) unsigned NOT NULL DEFAULT '0',
  `vip` smallint(5) unsigned NOT NULL DEFAULT '0',
  `max_section` int(10) unsigned NOT NULL DEFAULT '0',
  `newbie` smallint(6) NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL,
  `honor` int(10) unsigned NOT NULL DEFAULT '0',
  `snake` int(10) unsigned NOT NULL DEFAULT '0',
  `gcoin` int(10) unsigned NOT NULL DEFAULT '0',
  `charge` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `idx_name` (`name`),
  KEY `idx_level` (`level`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_award_pvp`
--

DROP TABLE IF EXISTS `user_award_pvp`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_award_pvp` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` bigint(20) unsigned NOT NULL,
  `award_id` smallint(6) NOT NULL,
  `status` tinyint(4) DEFAULT '0',
  `item` varchar(1024) DEFAULT NULL,
  `redempt_time` datetime DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3062 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_card`
--

DROP TABLE IF EXISTS `user_card`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_card` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL COMMENT '卡牌用户ID',
  `card_id` smallint(6) NOT NULL COMMENT '卡牌ID',
  `exp` int(11) NOT NULL DEFAULT '0' COMMENT '经验值',
  `level` smallint(6) NOT NULL DEFAULT '1' COMMENT '卡牌等级',
  `phase` tinyint(4) NOT NULL DEFAULT '0' COMMENT '卡牌突破阶段',
  `potential` smallint(6) NOT NULL DEFAULT '0' COMMENT '潜能点',
  `dragon_ball_count` tinyint(1) NOT NULL DEFAULT '0',
  `atk` int(11) NOT NULL DEFAULT '0',
  `def` int(11) NOT NULL DEFAULT '0',
  `hp` int(11) NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_card_idx` (`user_id`,`card_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_card_00`
--

DROP TABLE IF EXISTS `user_card_00`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_card_00` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL COMMENT '卡牌用户ID',
  `card_id` smallint(6) NOT NULL COMMENT '卡牌ID',
  `exp` int(11) NOT NULL DEFAULT '0' COMMENT '经验值',
  `level` smallint(6) NOT NULL DEFAULT '1' COMMENT '卡牌等级',
  `phase` tinyint(4) NOT NULL DEFAULT '0' COMMENT '卡牌突破阶段',
  `potential` smallint(6) NOT NULL DEFAULT '0' COMMENT '潜能点',
  `atk` float(10,3) NOT NULL DEFAULT '0.000',
  `def` float(10,3) NOT NULL DEFAULT '0.000',
  `hp` float(10,3) NOT NULL DEFAULT '0.000',
  `slevel_1` smallint(4) NOT NULL DEFAULT '0',
  `slevel_2` smallint(4) NOT NULL DEFAULT '0',
  `slevel_3` smallint(4) NOT NULL DEFAULT '0',
  `slevel_4` smallint(4) NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_card_idx` (`user_id`,`card_id`)
) ENGINE=InnoDB AUTO_INCREMENT=167 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_card_01`
--

DROP TABLE IF EXISTS `user_card_01`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_card_01` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL COMMENT '卡牌用户ID',
  `card_id` smallint(6) NOT NULL COMMENT '卡牌ID',
  `exp` int(11) NOT NULL DEFAULT '0' COMMENT '经验值',
  `level` smallint(6) NOT NULL DEFAULT '1' COMMENT '卡牌等级',
  `phase` tinyint(4) NOT NULL DEFAULT '0' COMMENT '卡牌突破阶段',
  `potential` smallint(6) NOT NULL DEFAULT '0' COMMENT '潜能点',
  `atk` float(10,3) NOT NULL DEFAULT '0.000',
  `def` float(10,3) NOT NULL DEFAULT '0.000',
  `hp` float(10,3) NOT NULL DEFAULT '0.000',
  `slevel_1` smallint(4) NOT NULL DEFAULT '0',
  `slevel_2` smallint(4) NOT NULL DEFAULT '0',
  `slevel_3` smallint(4) NOT NULL DEFAULT '0',
  `slevel_4` smallint(4) NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_card_idx` (`user_id`,`card_id`)
) ENGINE=InnoDB AUTO_INCREMENT=107 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_card_02`
--

DROP TABLE IF EXISTS `user_card_02`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_card_02` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL COMMENT '卡牌用户ID',
  `card_id` smallint(6) NOT NULL COMMENT '卡牌ID',
  `exp` int(11) NOT NULL DEFAULT '0' COMMENT '经验值',
  `level` smallint(6) NOT NULL DEFAULT '1' COMMENT '卡牌等级',
  `phase` tinyint(4) NOT NULL DEFAULT '0' COMMENT '卡牌突破阶段',
  `potential` smallint(6) NOT NULL DEFAULT '0' COMMENT '潜能点',
  `atk` float(10,3) NOT NULL DEFAULT '0.000',
  `def` float(10,3) NOT NULL DEFAULT '0.000',
  `hp` float(10,3) NOT NULL DEFAULT '0.000',
  `slevel_1` smallint(4) NOT NULL DEFAULT '0',
  `slevel_2` smallint(4) NOT NULL DEFAULT '0',
  `slevel_3` smallint(4) NOT NULL DEFAULT '0',
  `slevel_4` smallint(4) NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_card_idx` (`user_id`,`card_id`)
) ENGINE=InnoDB AUTO_INCREMENT=154 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_card_03`
--

DROP TABLE IF EXISTS `user_card_03`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_card_03` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL COMMENT '卡牌用户ID',
  `card_id` smallint(6) NOT NULL COMMENT '卡牌ID',
  `exp` int(11) NOT NULL DEFAULT '0' COMMENT '经验值',
  `level` smallint(6) NOT NULL DEFAULT '1' COMMENT '卡牌等级',
  `phase` tinyint(4) NOT NULL DEFAULT '0' COMMENT '卡牌突破阶段',
  `potential` smallint(6) NOT NULL DEFAULT '0' COMMENT '潜能点',
  `atk` float(10,3) NOT NULL DEFAULT '0.000',
  `def` float(10,3) NOT NULL DEFAULT '0.000',
  `hp` float(10,3) NOT NULL DEFAULT '0.000',
  `slevel_1` smallint(4) NOT NULL DEFAULT '0',
  `slevel_2` smallint(4) NOT NULL DEFAULT '0',
  `slevel_3` smallint(4) NOT NULL DEFAULT '0',
  `slevel_4` smallint(4) NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_card_idx` (`user_id`,`card_id`)
) ENGINE=InnoDB AUTO_INCREMENT=141 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_card_04`
--

DROP TABLE IF EXISTS `user_card_04`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_card_04` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL COMMENT '卡牌用户ID',
  `card_id` smallint(6) NOT NULL COMMENT '卡牌ID',
  `exp` int(11) NOT NULL DEFAULT '0' COMMENT '经验值',
  `level` smallint(6) NOT NULL DEFAULT '1' COMMENT '卡牌等级',
  `phase` tinyint(4) NOT NULL DEFAULT '0' COMMENT '卡牌突破阶段',
  `potential` smallint(6) NOT NULL DEFAULT '0' COMMENT '潜能点',
  `atk` float(10,3) NOT NULL DEFAULT '0.000',
  `def` float(10,3) NOT NULL DEFAULT '0.000',
  `hp` float(10,3) NOT NULL DEFAULT '0.000',
  `slevel_1` smallint(4) NOT NULL DEFAULT '0',
  `slevel_2` smallint(4) NOT NULL DEFAULT '0',
  `slevel_3` smallint(4) NOT NULL DEFAULT '0',
  `slevel_4` smallint(4) NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_card_idx` (`user_id`,`card_id`)
) ENGINE=InnoDB AUTO_INCREMENT=202 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_card_05`
--

DROP TABLE IF EXISTS `user_card_05`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_card_05` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL COMMENT '卡牌用户ID',
  `card_id` smallint(6) NOT NULL COMMENT '卡牌ID',
  `exp` int(11) NOT NULL DEFAULT '0' COMMENT '经验值',
  `level` smallint(6) NOT NULL DEFAULT '1' COMMENT '卡牌等级',
  `phase` tinyint(4) NOT NULL DEFAULT '0' COMMENT '卡牌突破阶段',
  `potential` smallint(6) NOT NULL DEFAULT '0' COMMENT '潜能点',
  `atk` float(10,3) NOT NULL DEFAULT '0.000',
  `def` float(10,3) NOT NULL DEFAULT '0.000',
  `hp` float(10,3) NOT NULL DEFAULT '0.000',
  `slevel_1` smallint(4) NOT NULL DEFAULT '0',
  `slevel_2` smallint(4) NOT NULL DEFAULT '0',
  `slevel_3` smallint(4) NOT NULL DEFAULT '0',
  `slevel_4` smallint(4) NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_card_idx` (`user_id`,`card_id`)
) ENGINE=InnoDB AUTO_INCREMENT=267 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_card_06`
--

DROP TABLE IF EXISTS `user_card_06`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_card_06` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL COMMENT '卡牌用户ID',
  `card_id` smallint(6) NOT NULL COMMENT '卡牌ID',
  `exp` int(11) NOT NULL DEFAULT '0' COMMENT '经验值',
  `level` smallint(6) NOT NULL DEFAULT '1' COMMENT '卡牌等级',
  `phase` tinyint(4) NOT NULL DEFAULT '0' COMMENT '卡牌突破阶段',
  `potential` smallint(6) NOT NULL DEFAULT '0' COMMENT '潜能点',
  `atk` float(10,3) NOT NULL DEFAULT '0.000',
  `def` float(10,3) NOT NULL DEFAULT '0.000',
  `hp` float(10,3) NOT NULL DEFAULT '0.000',
  `slevel_1` smallint(4) NOT NULL DEFAULT '0',
  `slevel_2` smallint(4) NOT NULL DEFAULT '0',
  `slevel_3` smallint(4) NOT NULL DEFAULT '0',
  `slevel_4` smallint(4) NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_card_idx` (`user_id`,`card_id`)
) ENGINE=InnoDB AUTO_INCREMENT=141 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_card_07`
--

DROP TABLE IF EXISTS `user_card_07`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_card_07` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL COMMENT '卡牌用户ID',
  `card_id` smallint(6) NOT NULL COMMENT '卡牌ID',
  `exp` int(11) NOT NULL DEFAULT '0' COMMENT '经验值',
  `level` smallint(6) NOT NULL DEFAULT '1' COMMENT '卡牌等级',
  `phase` tinyint(4) NOT NULL DEFAULT '0' COMMENT '卡牌突破阶段',
  `potential` smallint(6) NOT NULL DEFAULT '0' COMMENT '潜能点',
  `atk` float(10,3) NOT NULL DEFAULT '0.000',
  `def` float(10,3) NOT NULL DEFAULT '0.000',
  `hp` float(10,3) NOT NULL DEFAULT '0.000',
  `slevel_1` smallint(4) NOT NULL DEFAULT '0',
  `slevel_2` smallint(4) NOT NULL DEFAULT '0',
  `slevel_3` smallint(4) NOT NULL DEFAULT '0',
  `slevel_4` smallint(4) NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_card_idx` (`user_id`,`card_id`)
) ENGINE=InnoDB AUTO_INCREMENT=252 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_card_08`
--

DROP TABLE IF EXISTS `user_card_08`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_card_08` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL COMMENT '卡牌用户ID',
  `card_id` smallint(6) NOT NULL COMMENT '卡牌ID',
  `exp` int(11) NOT NULL DEFAULT '0' COMMENT '经验值',
  `level` smallint(6) NOT NULL DEFAULT '1' COMMENT '卡牌等级',
  `phase` tinyint(4) NOT NULL DEFAULT '0' COMMENT '卡牌突破阶段',
  `potential` smallint(6) NOT NULL DEFAULT '0' COMMENT '潜能点',
  `atk` float(10,3) NOT NULL DEFAULT '0.000',
  `def` float(10,3) NOT NULL DEFAULT '0.000',
  `hp` float(10,3) NOT NULL DEFAULT '0.000',
  `slevel_1` smallint(4) NOT NULL DEFAULT '0',
  `slevel_2` smallint(4) NOT NULL DEFAULT '0',
  `slevel_3` smallint(4) NOT NULL DEFAULT '0',
  `slevel_4` smallint(4) NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_card_idx` (`user_id`,`card_id`)
) ENGINE=InnoDB AUTO_INCREMENT=250 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_card_09`
--

DROP TABLE IF EXISTS `user_card_09`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_card_09` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL COMMENT '卡牌用户ID',
  `card_id` smallint(6) NOT NULL COMMENT '卡牌ID',
  `exp` int(11) NOT NULL DEFAULT '0' COMMENT '经验值',
  `level` smallint(6) NOT NULL DEFAULT '1' COMMENT '卡牌等级',
  `phase` tinyint(4) NOT NULL DEFAULT '0' COMMENT '卡牌突破阶段',
  `potential` smallint(6) NOT NULL DEFAULT '0' COMMENT '潜能点',
  `atk` float(10,3) NOT NULL DEFAULT '0.000',
  `def` float(10,3) NOT NULL DEFAULT '0.000',
  `hp` float(10,3) NOT NULL DEFAULT '0.000',
  `slevel_1` smallint(4) NOT NULL DEFAULT '0',
  `slevel_2` smallint(4) NOT NULL DEFAULT '0',
  `slevel_3` smallint(4) NOT NULL DEFAULT '0',
  `slevel_4` smallint(4) NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_card_idx` (`user_id`,`card_id`)
) ENGINE=InnoDB AUTO_INCREMENT=355 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_card_10`
--

DROP TABLE IF EXISTS `user_card_10`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_card_10` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL COMMENT '卡牌用户ID',
  `card_id` smallint(6) NOT NULL COMMENT '卡牌ID',
  `exp` int(11) NOT NULL DEFAULT '0' COMMENT '经验值',
  `level` smallint(6) NOT NULL DEFAULT '1' COMMENT '卡牌等级',
  `phase` tinyint(4) NOT NULL DEFAULT '0' COMMENT '卡牌突破阶段',
  `potential` smallint(6) NOT NULL DEFAULT '0' COMMENT '潜能点',
  `atk` float(10,3) NOT NULL DEFAULT '0.000',
  `def` float(10,3) NOT NULL DEFAULT '0.000',
  `hp` float(10,3) NOT NULL DEFAULT '0.000',
  `slevel_1` smallint(4) NOT NULL DEFAULT '0',
  `slevel_2` smallint(4) NOT NULL DEFAULT '0',
  `slevel_3` smallint(4) NOT NULL DEFAULT '0',
  `slevel_4` smallint(4) NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_card_idx` (`user_id`,`card_id`)
) ENGINE=InnoDB AUTO_INCREMENT=227 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_card_11`
--

DROP TABLE IF EXISTS `user_card_11`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_card_11` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL COMMENT '卡牌用户ID',
  `card_id` smallint(6) NOT NULL COMMENT '卡牌ID',
  `exp` int(11) NOT NULL DEFAULT '0' COMMENT '经验值',
  `level` smallint(6) NOT NULL DEFAULT '1' COMMENT '卡牌等级',
  `phase` tinyint(4) NOT NULL DEFAULT '0' COMMENT '卡牌突破阶段',
  `potential` smallint(6) NOT NULL DEFAULT '0' COMMENT '潜能点',
  `atk` float(10,3) NOT NULL DEFAULT '0.000',
  `def` float(10,3) NOT NULL DEFAULT '0.000',
  `hp` float(10,3) NOT NULL DEFAULT '0.000',
  `slevel_1` smallint(4) NOT NULL DEFAULT '0',
  `slevel_2` smallint(4) NOT NULL DEFAULT '0',
  `slevel_3` smallint(4) NOT NULL DEFAULT '0',
  `slevel_4` smallint(4) NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_card_idx` (`user_id`,`card_id`)
) ENGINE=InnoDB AUTO_INCREMENT=383 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_card_12`
--

DROP TABLE IF EXISTS `user_card_12`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_card_12` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL COMMENT '卡牌用户ID',
  `card_id` smallint(6) NOT NULL COMMENT '卡牌ID',
  `exp` int(11) NOT NULL DEFAULT '0' COMMENT '经验值',
  `level` smallint(6) NOT NULL DEFAULT '1' COMMENT '卡牌等级',
  `phase` tinyint(4) NOT NULL DEFAULT '0' COMMENT '卡牌突破阶段',
  `potential` smallint(6) NOT NULL DEFAULT '0' COMMENT '潜能点',
  `atk` float(10,3) NOT NULL DEFAULT '0.000',
  `def` float(10,3) NOT NULL DEFAULT '0.000',
  `hp` float(10,3) NOT NULL DEFAULT '0.000',
  `slevel_1` smallint(4) NOT NULL DEFAULT '0',
  `slevel_2` smallint(4) NOT NULL DEFAULT '0',
  `slevel_3` smallint(4) NOT NULL DEFAULT '0',
  `slevel_4` smallint(4) NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_card_idx` (`user_id`,`card_id`)
) ENGINE=InnoDB AUTO_INCREMENT=187 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_card_13`
--

DROP TABLE IF EXISTS `user_card_13`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_card_13` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL COMMENT '卡牌用户ID',
  `card_id` smallint(6) NOT NULL COMMENT '卡牌ID',
  `exp` int(11) NOT NULL DEFAULT '0' COMMENT '经验值',
  `level` smallint(6) NOT NULL DEFAULT '1' COMMENT '卡牌等级',
  `phase` tinyint(4) NOT NULL DEFAULT '0' COMMENT '卡牌突破阶段',
  `potential` smallint(6) NOT NULL DEFAULT '0' COMMENT '潜能点',
  `atk` float(10,3) NOT NULL DEFAULT '0.000',
  `def` float(10,3) NOT NULL DEFAULT '0.000',
  `hp` float(10,3) NOT NULL DEFAULT '0.000',
  `slevel_1` smallint(4) NOT NULL DEFAULT '0',
  `slevel_2` smallint(4) NOT NULL DEFAULT '0',
  `slevel_3` smallint(4) NOT NULL DEFAULT '0',
  `slevel_4` smallint(4) NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_card_idx` (`user_id`,`card_id`)
) ENGINE=InnoDB AUTO_INCREMENT=144 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_card_14`
--

DROP TABLE IF EXISTS `user_card_14`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_card_14` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL COMMENT '卡牌用户ID',
  `card_id` smallint(6) NOT NULL COMMENT '卡牌ID',
  `exp` int(11) NOT NULL DEFAULT '0' COMMENT '经验值',
  `level` smallint(6) NOT NULL DEFAULT '1' COMMENT '卡牌等级',
  `phase` tinyint(4) NOT NULL DEFAULT '0' COMMENT '卡牌突破阶段',
  `potential` smallint(6) NOT NULL DEFAULT '0' COMMENT '潜能点',
  `atk` float(10,3) NOT NULL DEFAULT '0.000',
  `def` float(10,3) NOT NULL DEFAULT '0.000',
  `hp` float(10,3) NOT NULL DEFAULT '0.000',
  `slevel_1` smallint(4) NOT NULL DEFAULT '0',
  `slevel_2` smallint(4) NOT NULL DEFAULT '0',
  `slevel_3` smallint(4) NOT NULL DEFAULT '0',
  `slevel_4` smallint(4) NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_card_idx` (`user_id`,`card_id`)
) ENGINE=InnoDB AUTO_INCREMENT=141 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_card_15`
--

DROP TABLE IF EXISTS `user_card_15`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_card_15` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL COMMENT '卡牌用户ID',
  `card_id` smallint(6) NOT NULL COMMENT '卡牌ID',
  `exp` int(11) NOT NULL DEFAULT '0' COMMENT '经验值',
  `level` smallint(6) NOT NULL DEFAULT '1' COMMENT '卡牌等级',
  `phase` tinyint(4) NOT NULL DEFAULT '0' COMMENT '卡牌突破阶段',
  `potential` smallint(6) NOT NULL DEFAULT '0' COMMENT '潜能点',
  `atk` float(10,3) NOT NULL DEFAULT '0.000',
  `def` float(10,3) NOT NULL DEFAULT '0.000',
  `hp` float(10,3) NOT NULL DEFAULT '0.000',
  `slevel_1` smallint(4) NOT NULL DEFAULT '0',
  `slevel_2` smallint(4) NOT NULL DEFAULT '0',
  `slevel_3` smallint(4) NOT NULL DEFAULT '0',
  `slevel_4` smallint(4) NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_card_idx` (`user_id`,`card_id`)
) ENGINE=InnoDB AUTO_INCREMENT=319 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_card_16`
--

DROP TABLE IF EXISTS `user_card_16`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_card_16` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL COMMENT '卡牌用户ID',
  `card_id` smallint(6) NOT NULL COMMENT '卡牌ID',
  `exp` int(11) NOT NULL DEFAULT '0' COMMENT '经验值',
  `level` smallint(6) NOT NULL DEFAULT '1' COMMENT '卡牌等级',
  `phase` tinyint(4) NOT NULL DEFAULT '0' COMMENT '卡牌突破阶段',
  `potential` smallint(6) NOT NULL DEFAULT '0' COMMENT '潜能点',
  `atk` float(10,3) NOT NULL DEFAULT '0.000',
  `def` float(10,3) NOT NULL DEFAULT '0.000',
  `hp` float(10,3) NOT NULL DEFAULT '0.000',
  `slevel_1` smallint(4) NOT NULL DEFAULT '0',
  `slevel_2` smallint(4) NOT NULL DEFAULT '0',
  `slevel_3` smallint(4) NOT NULL DEFAULT '0',
  `slevel_4` smallint(4) NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_card_idx` (`user_id`,`card_id`)
) ENGINE=InnoDB AUTO_INCREMENT=198 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_card_17`
--

DROP TABLE IF EXISTS `user_card_17`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_card_17` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL COMMENT '卡牌用户ID',
  `card_id` smallint(6) NOT NULL COMMENT '卡牌ID',
  `exp` int(11) NOT NULL DEFAULT '0' COMMENT '经验值',
  `level` smallint(6) NOT NULL DEFAULT '1' COMMENT '卡牌等级',
  `phase` tinyint(4) NOT NULL DEFAULT '0' COMMENT '卡牌突破阶段',
  `potential` smallint(6) NOT NULL DEFAULT '0' COMMENT '潜能点',
  `atk` float(10,3) NOT NULL DEFAULT '0.000',
  `def` float(10,3) NOT NULL DEFAULT '0.000',
  `hp` float(10,3) NOT NULL DEFAULT '0.000',
  `slevel_1` smallint(4) NOT NULL DEFAULT '0',
  `slevel_2` smallint(4) NOT NULL DEFAULT '0',
  `slevel_3` smallint(4) NOT NULL DEFAULT '0',
  `slevel_4` smallint(4) NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_card_idx` (`user_id`,`card_id`)
) ENGINE=InnoDB AUTO_INCREMENT=243 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_card_18`
--

DROP TABLE IF EXISTS `user_card_18`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_card_18` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL COMMENT '卡牌用户ID',
  `card_id` smallint(6) NOT NULL COMMENT '卡牌ID',
  `exp` int(11) NOT NULL DEFAULT '0' COMMENT '经验值',
  `level` smallint(6) NOT NULL DEFAULT '1' COMMENT '卡牌等级',
  `phase` tinyint(4) NOT NULL DEFAULT '0' COMMENT '卡牌突破阶段',
  `potential` smallint(6) NOT NULL DEFAULT '0' COMMENT '潜能点',
  `atk` float(10,3) NOT NULL DEFAULT '0.000',
  `def` float(10,3) NOT NULL DEFAULT '0.000',
  `hp` float(10,3) NOT NULL DEFAULT '0.000',
  `slevel_1` smallint(4) NOT NULL DEFAULT '0',
  `slevel_2` smallint(4) NOT NULL DEFAULT '0',
  `slevel_3` smallint(4) NOT NULL DEFAULT '0',
  `slevel_4` smallint(4) NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_card_idx` (`user_id`,`card_id`)
) ENGINE=InnoDB AUTO_INCREMENT=157 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_card_19`
--

DROP TABLE IF EXISTS `user_card_19`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_card_19` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL COMMENT '卡牌用户ID',
  `card_id` smallint(6) NOT NULL COMMENT '卡牌ID',
  `exp` int(11) NOT NULL DEFAULT '0' COMMENT '经验值',
  `level` smallint(6) NOT NULL DEFAULT '1' COMMENT '卡牌等级',
  `phase` tinyint(4) NOT NULL DEFAULT '0' COMMENT '卡牌突破阶段',
  `potential` smallint(6) NOT NULL DEFAULT '0' COMMENT '潜能点',
  `atk` float(10,3) NOT NULL DEFAULT '0.000',
  `def` float(10,3) NOT NULL DEFAULT '0.000',
  `hp` float(10,3) NOT NULL DEFAULT '0.000',
  `slevel_1` smallint(4) NOT NULL DEFAULT '0',
  `slevel_2` smallint(4) NOT NULL DEFAULT '0',
  `slevel_3` smallint(4) NOT NULL DEFAULT '0',
  `slevel_4` smallint(4) NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_card_idx` (`user_id`,`card_id`)
) ENGINE=InnoDB AUTO_INCREMENT=253 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_card_20`
--

DROP TABLE IF EXISTS `user_card_20`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_card_20` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL COMMENT '卡牌用户ID',
  `card_id` smallint(6) NOT NULL COMMENT '卡牌ID',
  `exp` int(11) NOT NULL DEFAULT '0' COMMENT '经验值',
  `level` smallint(6) NOT NULL DEFAULT '1' COMMENT '卡牌等级',
  `phase` tinyint(4) NOT NULL DEFAULT '0' COMMENT '卡牌突破阶段',
  `potential` smallint(6) NOT NULL DEFAULT '0' COMMENT '潜能点',
  `atk` float(10,3) NOT NULL DEFAULT '0.000',
  `def` float(10,3) NOT NULL DEFAULT '0.000',
  `hp` float(10,3) NOT NULL DEFAULT '0.000',
  `slevel_1` smallint(4) NOT NULL DEFAULT '0',
  `slevel_2` smallint(4) NOT NULL DEFAULT '0',
  `slevel_3` smallint(4) NOT NULL DEFAULT '0',
  `slevel_4` smallint(4) NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_card_idx` (`user_id`,`card_id`)
) ENGINE=InnoDB AUTO_INCREMENT=199 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_card_21`
--

DROP TABLE IF EXISTS `user_card_21`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_card_21` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL COMMENT '卡牌用户ID',
  `card_id` smallint(6) NOT NULL COMMENT '卡牌ID',
  `exp` int(11) NOT NULL DEFAULT '0' COMMENT '经验值',
  `level` smallint(6) NOT NULL DEFAULT '1' COMMENT '卡牌等级',
  `phase` tinyint(4) NOT NULL DEFAULT '0' COMMENT '卡牌突破阶段',
  `potential` smallint(6) NOT NULL DEFAULT '0' COMMENT '潜能点',
  `atk` float(10,3) NOT NULL DEFAULT '0.000',
  `def` float(10,3) NOT NULL DEFAULT '0.000',
  `hp` float(10,3) NOT NULL DEFAULT '0.000',
  `slevel_1` smallint(4) NOT NULL DEFAULT '0',
  `slevel_2` smallint(4) NOT NULL DEFAULT '0',
  `slevel_3` smallint(4) NOT NULL DEFAULT '0',
  `slevel_4` smallint(4) NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_card_idx` (`user_id`,`card_id`)
) ENGINE=InnoDB AUTO_INCREMENT=77 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_card_22`
--

DROP TABLE IF EXISTS `user_card_22`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_card_22` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL COMMENT '卡牌用户ID',
  `card_id` smallint(6) NOT NULL COMMENT '卡牌ID',
  `exp` int(11) NOT NULL DEFAULT '0' COMMENT '经验值',
  `level` smallint(6) NOT NULL DEFAULT '1' COMMENT '卡牌等级',
  `phase` tinyint(4) NOT NULL DEFAULT '0' COMMENT '卡牌突破阶段',
  `potential` smallint(6) NOT NULL DEFAULT '0' COMMENT '潜能点',
  `atk` float(10,3) NOT NULL DEFAULT '0.000',
  `def` float(10,3) NOT NULL DEFAULT '0.000',
  `hp` float(10,3) NOT NULL DEFAULT '0.000',
  `slevel_1` smallint(4) NOT NULL DEFAULT '0',
  `slevel_2` smallint(4) NOT NULL DEFAULT '0',
  `slevel_3` smallint(4) NOT NULL DEFAULT '0',
  `slevel_4` smallint(4) NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_card_idx` (`user_id`,`card_id`)
) ENGINE=InnoDB AUTO_INCREMENT=92 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_card_23`
--

DROP TABLE IF EXISTS `user_card_23`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_card_23` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL COMMENT '卡牌用户ID',
  `card_id` smallint(6) NOT NULL COMMENT '卡牌ID',
  `exp` int(11) NOT NULL DEFAULT '0' COMMENT '经验值',
  `level` smallint(6) NOT NULL DEFAULT '1' COMMENT '卡牌等级',
  `phase` tinyint(4) NOT NULL DEFAULT '0' COMMENT '卡牌突破阶段',
  `potential` smallint(6) NOT NULL DEFAULT '0' COMMENT '潜能点',
  `atk` float(10,3) NOT NULL DEFAULT '0.000',
  `def` float(10,3) NOT NULL DEFAULT '0.000',
  `hp` float(10,3) NOT NULL DEFAULT '0.000',
  `slevel_1` smallint(4) NOT NULL DEFAULT '0',
  `slevel_2` smallint(4) NOT NULL DEFAULT '0',
  `slevel_3` smallint(4) NOT NULL DEFAULT '0',
  `slevel_4` smallint(4) NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_card_idx` (`user_id`,`card_id`)
) ENGINE=InnoDB AUTO_INCREMENT=171 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_card_24`
--

DROP TABLE IF EXISTS `user_card_24`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_card_24` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL COMMENT '卡牌用户ID',
  `card_id` smallint(6) NOT NULL COMMENT '卡牌ID',
  `exp` int(11) NOT NULL DEFAULT '0' COMMENT '经验值',
  `level` smallint(6) NOT NULL DEFAULT '1' COMMENT '卡牌等级',
  `phase` tinyint(4) NOT NULL DEFAULT '0' COMMENT '卡牌突破阶段',
  `potential` smallint(6) NOT NULL DEFAULT '0' COMMENT '潜能点',
  `atk` float(10,3) NOT NULL DEFAULT '0.000',
  `def` float(10,3) NOT NULL DEFAULT '0.000',
  `hp` float(10,3) NOT NULL DEFAULT '0.000',
  `slevel_1` smallint(4) NOT NULL DEFAULT '0',
  `slevel_2` smallint(4) NOT NULL DEFAULT '0',
  `slevel_3` smallint(4) NOT NULL DEFAULT '0',
  `slevel_4` smallint(4) NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_card_idx` (`user_id`,`card_id`)
) ENGINE=InnoDB AUTO_INCREMENT=156 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_card_25`
--

DROP TABLE IF EXISTS `user_card_25`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_card_25` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL COMMENT '卡牌用户ID',
  `card_id` smallint(6) NOT NULL COMMENT '卡牌ID',
  `exp` int(11) NOT NULL DEFAULT '0' COMMENT '经验值',
  `level` smallint(6) NOT NULL DEFAULT '1' COMMENT '卡牌等级',
  `phase` tinyint(4) NOT NULL DEFAULT '0' COMMENT '卡牌突破阶段',
  `potential` smallint(6) NOT NULL DEFAULT '0' COMMENT '潜能点',
  `atk` float(10,3) NOT NULL DEFAULT '0.000',
  `def` float(10,3) NOT NULL DEFAULT '0.000',
  `hp` float(10,3) NOT NULL DEFAULT '0.000',
  `slevel_1` smallint(4) NOT NULL DEFAULT '0',
  `slevel_2` smallint(4) NOT NULL DEFAULT '0',
  `slevel_3` smallint(4) NOT NULL DEFAULT '0',
  `slevel_4` smallint(4) NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_card_idx` (`user_id`,`card_id`)
) ENGINE=InnoDB AUTO_INCREMENT=123 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_card_26`
--

DROP TABLE IF EXISTS `user_card_26`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_card_26` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL COMMENT '卡牌用户ID',
  `card_id` smallint(6) NOT NULL COMMENT '卡牌ID',
  `exp` int(11) NOT NULL DEFAULT '0' COMMENT '经验值',
  `level` smallint(6) NOT NULL DEFAULT '1' COMMENT '卡牌等级',
  `phase` tinyint(4) NOT NULL DEFAULT '0' COMMENT '卡牌突破阶段',
  `potential` smallint(6) NOT NULL DEFAULT '0' COMMENT '潜能点',
  `atk` float(10,3) NOT NULL DEFAULT '0.000',
  `def` float(10,3) NOT NULL DEFAULT '0.000',
  `hp` float(10,3) NOT NULL DEFAULT '0.000',
  `slevel_1` smallint(4) NOT NULL DEFAULT '0',
  `slevel_2` smallint(4) NOT NULL DEFAULT '0',
  `slevel_3` smallint(4) NOT NULL DEFAULT '0',
  `slevel_4` smallint(4) NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_card_idx` (`user_id`,`card_id`)
) ENGINE=InnoDB AUTO_INCREMENT=182 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_card_27`
--

DROP TABLE IF EXISTS `user_card_27`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_card_27` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL COMMENT '卡牌用户ID',
  `card_id` smallint(6) NOT NULL COMMENT '卡牌ID',
  `exp` int(11) NOT NULL DEFAULT '0' COMMENT '经验值',
  `level` smallint(6) NOT NULL DEFAULT '1' COMMENT '卡牌等级',
  `phase` tinyint(4) NOT NULL DEFAULT '0' COMMENT '卡牌突破阶段',
  `potential` smallint(6) NOT NULL DEFAULT '0' COMMENT '潜能点',
  `atk` float(10,3) NOT NULL DEFAULT '0.000',
  `def` float(10,3) NOT NULL DEFAULT '0.000',
  `hp` float(10,3) NOT NULL DEFAULT '0.000',
  `slevel_1` smallint(4) NOT NULL DEFAULT '0',
  `slevel_2` smallint(4) NOT NULL DEFAULT '0',
  `slevel_3` smallint(4) NOT NULL DEFAULT '0',
  `slevel_4` smallint(4) NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_card_idx` (`user_id`,`card_id`)
) ENGINE=InnoDB AUTO_INCREMENT=140 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_card_28`
--

DROP TABLE IF EXISTS `user_card_28`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_card_28` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL COMMENT '卡牌用户ID',
  `card_id` smallint(6) NOT NULL COMMENT '卡牌ID',
  `exp` int(11) NOT NULL DEFAULT '0' COMMENT '经验值',
  `level` smallint(6) NOT NULL DEFAULT '1' COMMENT '卡牌等级',
  `phase` tinyint(4) NOT NULL DEFAULT '0' COMMENT '卡牌突破阶段',
  `potential` smallint(6) NOT NULL DEFAULT '0' COMMENT '潜能点',
  `atk` float(10,3) NOT NULL DEFAULT '0.000',
  `def` float(10,3) NOT NULL DEFAULT '0.000',
  `hp` float(10,3) NOT NULL DEFAULT '0.000',
  `slevel_1` smallint(4) NOT NULL DEFAULT '0',
  `slevel_2` smallint(4) NOT NULL DEFAULT '0',
  `slevel_3` smallint(4) NOT NULL DEFAULT '0',
  `slevel_4` smallint(4) NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_card_idx` (`user_id`,`card_id`)
) ENGINE=InnoDB AUTO_INCREMENT=193 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_card_29`
--

DROP TABLE IF EXISTS `user_card_29`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_card_29` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL COMMENT '卡牌用户ID',
  `card_id` smallint(6) NOT NULL COMMENT '卡牌ID',
  `exp` int(11) NOT NULL DEFAULT '0' COMMENT '经验值',
  `level` smallint(6) NOT NULL DEFAULT '1' COMMENT '卡牌等级',
  `phase` tinyint(4) NOT NULL DEFAULT '0' COMMENT '卡牌突破阶段',
  `potential` smallint(6) NOT NULL DEFAULT '0' COMMENT '潜能点',
  `atk` float(10,3) NOT NULL DEFAULT '0.000',
  `def` float(10,3) NOT NULL DEFAULT '0.000',
  `hp` float(10,3) NOT NULL DEFAULT '0.000',
  `slevel_1` smallint(4) NOT NULL DEFAULT '0',
  `slevel_2` smallint(4) NOT NULL DEFAULT '0',
  `slevel_3` smallint(4) NOT NULL DEFAULT '0',
  `slevel_4` smallint(4) NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_card_idx` (`user_id`,`card_id`)
) ENGINE=InnoDB AUTO_INCREMENT=187 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_card_30`
--

DROP TABLE IF EXISTS `user_card_30`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_card_30` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL COMMENT '卡牌用户ID',
  `card_id` smallint(6) NOT NULL COMMENT '卡牌ID',
  `exp` int(11) NOT NULL DEFAULT '0' COMMENT '经验值',
  `level` smallint(6) NOT NULL DEFAULT '1' COMMENT '卡牌等级',
  `phase` tinyint(4) NOT NULL DEFAULT '0' COMMENT '卡牌突破阶段',
  `potential` smallint(6) NOT NULL DEFAULT '0' COMMENT '潜能点',
  `atk` float(10,3) NOT NULL DEFAULT '0.000',
  `def` float(10,3) NOT NULL DEFAULT '0.000',
  `hp` float(10,3) NOT NULL DEFAULT '0.000',
  `slevel_1` smallint(4) NOT NULL DEFAULT '0',
  `slevel_2` smallint(4) NOT NULL DEFAULT '0',
  `slevel_3` smallint(4) NOT NULL DEFAULT '0',
  `slevel_4` smallint(4) NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_card_idx` (`user_id`,`card_id`)
) ENGINE=InnoDB AUTO_INCREMENT=151 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_card_31`
--

DROP TABLE IF EXISTS `user_card_31`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_card_31` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL COMMENT '卡牌用户ID',
  `card_id` smallint(6) NOT NULL COMMENT '卡牌ID',
  `exp` int(11) NOT NULL DEFAULT '0' COMMENT '经验值',
  `level` smallint(6) NOT NULL DEFAULT '1' COMMENT '卡牌等级',
  `phase` tinyint(4) NOT NULL DEFAULT '0' COMMENT '卡牌突破阶段',
  `potential` smallint(6) NOT NULL DEFAULT '0' COMMENT '潜能点',
  `atk` float(10,3) NOT NULL DEFAULT '0.000',
  `def` float(10,3) NOT NULL DEFAULT '0.000',
  `hp` float(10,3) NOT NULL DEFAULT '0.000',
  `slevel_1` smallint(4) NOT NULL DEFAULT '0',
  `slevel_2` smallint(4) NOT NULL DEFAULT '0',
  `slevel_3` smallint(4) NOT NULL DEFAULT '0',
  `slevel_4` smallint(4) NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_card_idx` (`user_id`,`card_id`)
) ENGINE=InnoDB AUTO_INCREMENT=100 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_card_32`
--

DROP TABLE IF EXISTS `user_card_32`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_card_32` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL COMMENT '卡牌用户ID',
  `card_id` smallint(6) NOT NULL COMMENT '卡牌ID',
  `exp` int(11) NOT NULL DEFAULT '0' COMMENT '经验值',
  `level` smallint(6) NOT NULL DEFAULT '1' COMMENT '卡牌等级',
  `phase` tinyint(4) NOT NULL DEFAULT '0' COMMENT '卡牌突破阶段',
  `potential` smallint(6) NOT NULL DEFAULT '0' COMMENT '潜能点',
  `atk` float(10,3) NOT NULL DEFAULT '0.000',
  `def` float(10,3) NOT NULL DEFAULT '0.000',
  `hp` float(10,3) NOT NULL DEFAULT '0.000',
  `slevel_1` smallint(4) NOT NULL DEFAULT '0',
  `slevel_2` smallint(4) NOT NULL DEFAULT '0',
  `slevel_3` smallint(4) NOT NULL DEFAULT '0',
  `slevel_4` smallint(4) NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_card_idx` (`user_id`,`card_id`)
) ENGINE=InnoDB AUTO_INCREMENT=117 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_card_33`
--

DROP TABLE IF EXISTS `user_card_33`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_card_33` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL COMMENT '卡牌用户ID',
  `card_id` smallint(6) NOT NULL COMMENT '卡牌ID',
  `exp` int(11) NOT NULL DEFAULT '0' COMMENT '经验值',
  `level` smallint(6) NOT NULL DEFAULT '1' COMMENT '卡牌等级',
  `phase` tinyint(4) NOT NULL DEFAULT '0' COMMENT '卡牌突破阶段',
  `potential` smallint(6) NOT NULL DEFAULT '0' COMMENT '潜能点',
  `atk` float(10,3) NOT NULL DEFAULT '0.000',
  `def` float(10,3) NOT NULL DEFAULT '0.000',
  `hp` float(10,3) NOT NULL DEFAULT '0.000',
  `slevel_1` smallint(4) NOT NULL DEFAULT '0',
  `slevel_2` smallint(4) NOT NULL DEFAULT '0',
  `slevel_3` smallint(4) NOT NULL DEFAULT '0',
  `slevel_4` smallint(4) NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_card_idx` (`user_id`,`card_id`)
) ENGINE=InnoDB AUTO_INCREMENT=211 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_card_34`
--

DROP TABLE IF EXISTS `user_card_34`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_card_34` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL COMMENT '卡牌用户ID',
  `card_id` smallint(6) NOT NULL COMMENT '卡牌ID',
  `exp` int(11) NOT NULL DEFAULT '0' COMMENT '经验值',
  `level` smallint(6) NOT NULL DEFAULT '1' COMMENT '卡牌等级',
  `phase` tinyint(4) NOT NULL DEFAULT '0' COMMENT '卡牌突破阶段',
  `potential` smallint(6) NOT NULL DEFAULT '0' COMMENT '潜能点',
  `atk` float(10,3) NOT NULL DEFAULT '0.000',
  `def` float(10,3) NOT NULL DEFAULT '0.000',
  `hp` float(10,3) NOT NULL DEFAULT '0.000',
  `slevel_1` smallint(4) NOT NULL DEFAULT '0',
  `slevel_2` smallint(4) NOT NULL DEFAULT '0',
  `slevel_3` smallint(4) NOT NULL DEFAULT '0',
  `slevel_4` smallint(4) NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_card_idx` (`user_id`,`card_id`)
) ENGINE=InnoDB AUTO_INCREMENT=139 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_card_35`
--

DROP TABLE IF EXISTS `user_card_35`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_card_35` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL COMMENT '卡牌用户ID',
  `card_id` smallint(6) NOT NULL COMMENT '卡牌ID',
  `exp` int(11) NOT NULL DEFAULT '0' COMMENT '经验值',
  `level` smallint(6) NOT NULL DEFAULT '1' COMMENT '卡牌等级',
  `phase` tinyint(4) NOT NULL DEFAULT '0' COMMENT '卡牌突破阶段',
  `potential` smallint(6) NOT NULL DEFAULT '0' COMMENT '潜能点',
  `atk` float(10,3) NOT NULL DEFAULT '0.000',
  `def` float(10,3) NOT NULL DEFAULT '0.000',
  `hp` float(10,3) NOT NULL DEFAULT '0.000',
  `slevel_1` smallint(4) NOT NULL DEFAULT '0',
  `slevel_2` smallint(4) NOT NULL DEFAULT '0',
  `slevel_3` smallint(4) NOT NULL DEFAULT '0',
  `slevel_4` smallint(4) NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_card_idx` (`user_id`,`card_id`)
) ENGINE=InnoDB AUTO_INCREMENT=274 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_card_36`
--

DROP TABLE IF EXISTS `user_card_36`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_card_36` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL COMMENT '卡牌用户ID',
  `card_id` smallint(6) NOT NULL COMMENT '卡牌ID',
  `exp` int(11) NOT NULL DEFAULT '0' COMMENT '经验值',
  `level` smallint(6) NOT NULL DEFAULT '1' COMMENT '卡牌等级',
  `phase` tinyint(4) NOT NULL DEFAULT '0' COMMENT '卡牌突破阶段',
  `potential` smallint(6) NOT NULL DEFAULT '0' COMMENT '潜能点',
  `atk` float(10,3) NOT NULL DEFAULT '0.000',
  `def` float(10,3) NOT NULL DEFAULT '0.000',
  `hp` float(10,3) NOT NULL DEFAULT '0.000',
  `slevel_1` smallint(4) NOT NULL DEFAULT '0',
  `slevel_2` smallint(4) NOT NULL DEFAULT '0',
  `slevel_3` smallint(4) NOT NULL DEFAULT '0',
  `slevel_4` smallint(4) NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_card_idx` (`user_id`,`card_id`)
) ENGINE=InnoDB AUTO_INCREMENT=182 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_card_37`
--

DROP TABLE IF EXISTS `user_card_37`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_card_37` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL COMMENT '卡牌用户ID',
  `card_id` smallint(6) NOT NULL COMMENT '卡牌ID',
  `exp` int(11) NOT NULL DEFAULT '0' COMMENT '经验值',
  `level` smallint(6) NOT NULL DEFAULT '1' COMMENT '卡牌等级',
  `phase` tinyint(4) NOT NULL DEFAULT '0' COMMENT '卡牌突破阶段',
  `potential` smallint(6) NOT NULL DEFAULT '0' COMMENT '潜能点',
  `atk` float(10,3) NOT NULL DEFAULT '0.000',
  `def` float(10,3) NOT NULL DEFAULT '0.000',
  `hp` float(10,3) NOT NULL DEFAULT '0.000',
  `slevel_1` smallint(4) NOT NULL DEFAULT '0',
  `slevel_2` smallint(4) NOT NULL DEFAULT '0',
  `slevel_3` smallint(4) NOT NULL DEFAULT '0',
  `slevel_4` smallint(4) NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_card_idx` (`user_id`,`card_id`)
) ENGINE=InnoDB AUTO_INCREMENT=112 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_card_38`
--

DROP TABLE IF EXISTS `user_card_38`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_card_38` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL COMMENT '卡牌用户ID',
  `card_id` smallint(6) NOT NULL COMMENT '卡牌ID',
  `exp` int(11) NOT NULL DEFAULT '0' COMMENT '经验值',
  `level` smallint(6) NOT NULL DEFAULT '1' COMMENT '卡牌等级',
  `phase` tinyint(4) NOT NULL DEFAULT '0' COMMENT '卡牌突破阶段',
  `potential` smallint(6) NOT NULL DEFAULT '0' COMMENT '潜能点',
  `atk` float(10,3) NOT NULL DEFAULT '0.000',
  `def` float(10,3) NOT NULL DEFAULT '0.000',
  `hp` float(10,3) NOT NULL DEFAULT '0.000',
  `slevel_1` smallint(4) NOT NULL DEFAULT '0',
  `slevel_2` smallint(4) NOT NULL DEFAULT '0',
  `slevel_3` smallint(4) NOT NULL DEFAULT '0',
  `slevel_4` smallint(4) NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_card_idx` (`user_id`,`card_id`)
) ENGINE=InnoDB AUTO_INCREMENT=265 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_card_39`
--

DROP TABLE IF EXISTS `user_card_39`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_card_39` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL COMMENT '卡牌用户ID',
  `card_id` smallint(6) NOT NULL COMMENT '卡牌ID',
  `exp` int(11) NOT NULL DEFAULT '0' COMMENT '经验值',
  `level` smallint(6) NOT NULL DEFAULT '1' COMMENT '卡牌等级',
  `phase` tinyint(4) NOT NULL DEFAULT '0' COMMENT '卡牌突破阶段',
  `potential` smallint(6) NOT NULL DEFAULT '0' COMMENT '潜能点',
  `atk` float(10,3) NOT NULL DEFAULT '0.000',
  `def` float(10,3) NOT NULL DEFAULT '0.000',
  `hp` float(10,3) NOT NULL DEFAULT '0.000',
  `slevel_1` smallint(4) NOT NULL DEFAULT '0',
  `slevel_2` smallint(4) NOT NULL DEFAULT '0',
  `slevel_3` smallint(4) NOT NULL DEFAULT '0',
  `slevel_4` smallint(4) NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_card_idx` (`user_id`,`card_id`)
) ENGINE=InnoDB AUTO_INCREMENT=141 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_card_40`
--

DROP TABLE IF EXISTS `user_card_40`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_card_40` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL COMMENT '卡牌用户ID',
  `card_id` smallint(6) NOT NULL COMMENT '卡牌ID',
  `exp` int(11) NOT NULL DEFAULT '0' COMMENT '经验值',
  `level` smallint(6) NOT NULL DEFAULT '1' COMMENT '卡牌等级',
  `phase` tinyint(4) NOT NULL DEFAULT '0' COMMENT '卡牌突破阶段',
  `potential` smallint(6) NOT NULL DEFAULT '0' COMMENT '潜能点',
  `atk` float(10,3) NOT NULL DEFAULT '0.000',
  `def` float(10,3) NOT NULL DEFAULT '0.000',
  `hp` float(10,3) NOT NULL DEFAULT '0.000',
  `slevel_1` smallint(4) NOT NULL DEFAULT '0',
  `slevel_2` smallint(4) NOT NULL DEFAULT '0',
  `slevel_3` smallint(4) NOT NULL DEFAULT '0',
  `slevel_4` smallint(4) NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_card_idx` (`user_id`,`card_id`)
) ENGINE=InnoDB AUTO_INCREMENT=187 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_card_41`
--

DROP TABLE IF EXISTS `user_card_41`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_card_41` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL COMMENT '卡牌用户ID',
  `card_id` smallint(6) NOT NULL COMMENT '卡牌ID',
  `exp` int(11) NOT NULL DEFAULT '0' COMMENT '经验值',
  `level` smallint(6) NOT NULL DEFAULT '1' COMMENT '卡牌等级',
  `phase` tinyint(4) NOT NULL DEFAULT '0' COMMENT '卡牌突破阶段',
  `potential` smallint(6) NOT NULL DEFAULT '0' COMMENT '潜能点',
  `atk` float(10,3) NOT NULL DEFAULT '0.000',
  `def` float(10,3) NOT NULL DEFAULT '0.000',
  `hp` float(10,3) NOT NULL DEFAULT '0.000',
  `slevel_1` smallint(4) NOT NULL DEFAULT '0',
  `slevel_2` smallint(4) NOT NULL DEFAULT '0',
  `slevel_3` smallint(4) NOT NULL DEFAULT '0',
  `slevel_4` smallint(4) NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_card_idx` (`user_id`,`card_id`)
) ENGINE=InnoDB AUTO_INCREMENT=119 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_card_42`
--

DROP TABLE IF EXISTS `user_card_42`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_card_42` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL COMMENT '卡牌用户ID',
  `card_id` smallint(6) NOT NULL COMMENT '卡牌ID',
  `exp` int(11) NOT NULL DEFAULT '0' COMMENT '经验值',
  `level` smallint(6) NOT NULL DEFAULT '1' COMMENT '卡牌等级',
  `phase` tinyint(4) NOT NULL DEFAULT '0' COMMENT '卡牌突破阶段',
  `potential` smallint(6) NOT NULL DEFAULT '0' COMMENT '潜能点',
  `atk` float(10,3) NOT NULL DEFAULT '0.000',
  `def` float(10,3) NOT NULL DEFAULT '0.000',
  `hp` float(10,3) NOT NULL DEFAULT '0.000',
  `slevel_1` smallint(4) NOT NULL DEFAULT '0',
  `slevel_2` smallint(4) NOT NULL DEFAULT '0',
  `slevel_3` smallint(4) NOT NULL DEFAULT '0',
  `slevel_4` smallint(4) NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_card_idx` (`user_id`,`card_id`)
) ENGINE=InnoDB AUTO_INCREMENT=105 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_card_43`
--

DROP TABLE IF EXISTS `user_card_43`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_card_43` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL COMMENT '卡牌用户ID',
  `card_id` smallint(6) NOT NULL COMMENT '卡牌ID',
  `exp` int(11) NOT NULL DEFAULT '0' COMMENT '经验值',
  `level` smallint(6) NOT NULL DEFAULT '1' COMMENT '卡牌等级',
  `phase` tinyint(4) NOT NULL DEFAULT '0' COMMENT '卡牌突破阶段',
  `potential` smallint(6) NOT NULL DEFAULT '0' COMMENT '潜能点',
  `atk` float(10,3) NOT NULL DEFAULT '0.000',
  `def` float(10,3) NOT NULL DEFAULT '0.000',
  `hp` float(10,3) NOT NULL DEFAULT '0.000',
  `slevel_1` smallint(4) NOT NULL DEFAULT '0',
  `slevel_2` smallint(4) NOT NULL DEFAULT '0',
  `slevel_3` smallint(4) NOT NULL DEFAULT '0',
  `slevel_4` smallint(4) NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_card_idx` (`user_id`,`card_id`)
) ENGINE=InnoDB AUTO_INCREMENT=144 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_card_44`
--

DROP TABLE IF EXISTS `user_card_44`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_card_44` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL COMMENT '卡牌用户ID',
  `card_id` smallint(6) NOT NULL COMMENT '卡牌ID',
  `exp` int(11) NOT NULL DEFAULT '0' COMMENT '经验值',
  `level` smallint(6) NOT NULL DEFAULT '1' COMMENT '卡牌等级',
  `phase` tinyint(4) NOT NULL DEFAULT '0' COMMENT '卡牌突破阶段',
  `potential` smallint(6) NOT NULL DEFAULT '0' COMMENT '潜能点',
  `atk` float(10,3) NOT NULL DEFAULT '0.000',
  `def` float(10,3) NOT NULL DEFAULT '0.000',
  `hp` float(10,3) NOT NULL DEFAULT '0.000',
  `slevel_1` smallint(4) NOT NULL DEFAULT '0',
  `slevel_2` smallint(4) NOT NULL DEFAULT '0',
  `slevel_3` smallint(4) NOT NULL DEFAULT '0',
  `slevel_4` smallint(4) NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_card_idx` (`user_id`,`card_id`)
) ENGINE=InnoDB AUTO_INCREMENT=154 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_card_45`
--

DROP TABLE IF EXISTS `user_card_45`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_card_45` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL COMMENT '卡牌用户ID',
  `card_id` smallint(6) NOT NULL COMMENT '卡牌ID',
  `exp` int(11) NOT NULL DEFAULT '0' COMMENT '经验值',
  `level` smallint(6) NOT NULL DEFAULT '1' COMMENT '卡牌等级',
  `phase` tinyint(4) NOT NULL DEFAULT '0' COMMENT '卡牌突破阶段',
  `potential` smallint(6) NOT NULL DEFAULT '0' COMMENT '潜能点',
  `atk` float(10,3) NOT NULL DEFAULT '0.000',
  `def` float(10,3) NOT NULL DEFAULT '0.000',
  `hp` float(10,3) NOT NULL DEFAULT '0.000',
  `slevel_1` smallint(4) NOT NULL DEFAULT '0',
  `slevel_2` smallint(4) NOT NULL DEFAULT '0',
  `slevel_3` smallint(4) NOT NULL DEFAULT '0',
  `slevel_4` smallint(4) NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_card_idx` (`user_id`,`card_id`)
) ENGINE=InnoDB AUTO_INCREMENT=138 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_card_46`
--

DROP TABLE IF EXISTS `user_card_46`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_card_46` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL COMMENT '卡牌用户ID',
  `card_id` smallint(6) NOT NULL COMMENT '卡牌ID',
  `exp` int(11) NOT NULL DEFAULT '0' COMMENT '经验值',
  `level` smallint(6) NOT NULL DEFAULT '1' COMMENT '卡牌等级',
  `phase` tinyint(4) NOT NULL DEFAULT '0' COMMENT '卡牌突破阶段',
  `potential` smallint(6) NOT NULL DEFAULT '0' COMMENT '潜能点',
  `atk` float(10,3) NOT NULL DEFAULT '0.000',
  `def` float(10,3) NOT NULL DEFAULT '0.000',
  `hp` float(10,3) NOT NULL DEFAULT '0.000',
  `slevel_1` smallint(4) NOT NULL DEFAULT '0',
  `slevel_2` smallint(4) NOT NULL DEFAULT '0',
  `slevel_3` smallint(4) NOT NULL DEFAULT '0',
  `slevel_4` smallint(4) NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_card_idx` (`user_id`,`card_id`)
) ENGINE=InnoDB AUTO_INCREMENT=109 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_card_47`
--

DROP TABLE IF EXISTS `user_card_47`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_card_47` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL COMMENT '卡牌用户ID',
  `card_id` smallint(6) NOT NULL COMMENT '卡牌ID',
  `exp` int(11) NOT NULL DEFAULT '0' COMMENT '经验值',
  `level` smallint(6) NOT NULL DEFAULT '1' COMMENT '卡牌等级',
  `phase` tinyint(4) NOT NULL DEFAULT '0' COMMENT '卡牌突破阶段',
  `potential` smallint(6) NOT NULL DEFAULT '0' COMMENT '潜能点',
  `atk` float(10,3) NOT NULL DEFAULT '0.000',
  `def` float(10,3) NOT NULL DEFAULT '0.000',
  `hp` float(10,3) NOT NULL DEFAULT '0.000',
  `slevel_1` smallint(4) NOT NULL DEFAULT '0',
  `slevel_2` smallint(4) NOT NULL DEFAULT '0',
  `slevel_3` smallint(4) NOT NULL DEFAULT '0',
  `slevel_4` smallint(4) NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_card_idx` (`user_id`,`card_id`)
) ENGINE=InnoDB AUTO_INCREMENT=231 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_card_48`
--

DROP TABLE IF EXISTS `user_card_48`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_card_48` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL COMMENT '卡牌用户ID',
  `card_id` smallint(6) NOT NULL COMMENT '卡牌ID',
  `exp` int(11) NOT NULL DEFAULT '0' COMMENT '经验值',
  `level` smallint(6) NOT NULL DEFAULT '1' COMMENT '卡牌等级',
  `phase` tinyint(4) NOT NULL DEFAULT '0' COMMENT '卡牌突破阶段',
  `potential` smallint(6) NOT NULL DEFAULT '0' COMMENT '潜能点',
  `atk` float(10,3) NOT NULL DEFAULT '0.000',
  `def` float(10,3) NOT NULL DEFAULT '0.000',
  `hp` float(10,3) NOT NULL DEFAULT '0.000',
  `slevel_1` smallint(4) NOT NULL DEFAULT '0',
  `slevel_2` smallint(4) NOT NULL DEFAULT '0',
  `slevel_3` smallint(4) NOT NULL DEFAULT '0',
  `slevel_4` smallint(4) NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_card_idx` (`user_id`,`card_id`)
) ENGINE=InnoDB AUTO_INCREMENT=205 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_card_49`
--

DROP TABLE IF EXISTS `user_card_49`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_card_49` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL COMMENT '卡牌用户ID',
  `card_id` smallint(6) NOT NULL COMMENT '卡牌ID',
  `exp` int(11) NOT NULL DEFAULT '0' COMMENT '经验值',
  `level` smallint(6) NOT NULL DEFAULT '1' COMMENT '卡牌等级',
  `phase` tinyint(4) NOT NULL DEFAULT '0' COMMENT '卡牌突破阶段',
  `potential` smallint(6) NOT NULL DEFAULT '0' COMMENT '潜能点',
  `atk` float(10,3) NOT NULL DEFAULT '0.000',
  `def` float(10,3) NOT NULL DEFAULT '0.000',
  `hp` float(10,3) NOT NULL DEFAULT '0.000',
  `slevel_1` smallint(4) NOT NULL DEFAULT '0',
  `slevel_2` smallint(4) NOT NULL DEFAULT '0',
  `slevel_3` smallint(4) NOT NULL DEFAULT '0',
  `slevel_4` smallint(4) NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_card_idx` (`user_id`,`card_id`)
) ENGINE=InnoDB AUTO_INCREMENT=165 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_card_50`
--

DROP TABLE IF EXISTS `user_card_50`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_card_50` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL COMMENT '卡牌用户ID',
  `card_id` smallint(6) NOT NULL COMMENT '卡牌ID',
  `exp` int(11) NOT NULL DEFAULT '0' COMMENT '经验值',
  `level` smallint(6) NOT NULL DEFAULT '1' COMMENT '卡牌等级',
  `phase` tinyint(4) NOT NULL DEFAULT '0' COMMENT '卡牌突破阶段',
  `potential` smallint(6) NOT NULL DEFAULT '0' COMMENT '潜能点',
  `atk` float(10,3) NOT NULL DEFAULT '0.000',
  `def` float(10,3) NOT NULL DEFAULT '0.000',
  `hp` float(10,3) NOT NULL DEFAULT '0.000',
  `slevel_1` smallint(4) NOT NULL DEFAULT '0',
  `slevel_2` smallint(4) NOT NULL DEFAULT '0',
  `slevel_3` smallint(4) NOT NULL DEFAULT '0',
  `slevel_4` smallint(4) NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_card_idx` (`user_id`,`card_id`)
) ENGINE=InnoDB AUTO_INCREMENT=102 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_card_51`
--

DROP TABLE IF EXISTS `user_card_51`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_card_51` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL COMMENT '卡牌用户ID',
  `card_id` smallint(6) NOT NULL COMMENT '卡牌ID',
  `exp` int(11) NOT NULL DEFAULT '0' COMMENT '经验值',
  `level` smallint(6) NOT NULL DEFAULT '1' COMMENT '卡牌等级',
  `phase` tinyint(4) NOT NULL DEFAULT '0' COMMENT '卡牌突破阶段',
  `potential` smallint(6) NOT NULL DEFAULT '0' COMMENT '潜能点',
  `atk` float(10,3) NOT NULL DEFAULT '0.000',
  `def` float(10,3) NOT NULL DEFAULT '0.000',
  `hp` float(10,3) NOT NULL DEFAULT '0.000',
  `slevel_1` smallint(4) NOT NULL DEFAULT '0',
  `slevel_2` smallint(4) NOT NULL DEFAULT '0',
  `slevel_3` smallint(4) NOT NULL DEFAULT '0',
  `slevel_4` smallint(4) NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_card_idx` (`user_id`,`card_id`)
) ENGINE=InnoDB AUTO_INCREMENT=152 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_card_52`
--

DROP TABLE IF EXISTS `user_card_52`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_card_52` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL COMMENT '卡牌用户ID',
  `card_id` smallint(6) NOT NULL COMMENT '卡牌ID',
  `exp` int(11) NOT NULL DEFAULT '0' COMMENT '经验值',
  `level` smallint(6) NOT NULL DEFAULT '1' COMMENT '卡牌等级',
  `phase` tinyint(4) NOT NULL DEFAULT '0' COMMENT '卡牌突破阶段',
  `potential` smallint(6) NOT NULL DEFAULT '0' COMMENT '潜能点',
  `atk` float(10,3) NOT NULL DEFAULT '0.000',
  `def` float(10,3) NOT NULL DEFAULT '0.000',
  `hp` float(10,3) NOT NULL DEFAULT '0.000',
  `slevel_1` smallint(4) NOT NULL DEFAULT '0',
  `slevel_2` smallint(4) NOT NULL DEFAULT '0',
  `slevel_3` smallint(4) NOT NULL DEFAULT '0',
  `slevel_4` smallint(4) NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_card_idx` (`user_id`,`card_id`)
) ENGINE=InnoDB AUTO_INCREMENT=175 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_card_53`
--

DROP TABLE IF EXISTS `user_card_53`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_card_53` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL COMMENT '卡牌用户ID',
  `card_id` smallint(6) NOT NULL COMMENT '卡牌ID',
  `exp` int(11) NOT NULL DEFAULT '0' COMMENT '经验值',
  `level` smallint(6) NOT NULL DEFAULT '1' COMMENT '卡牌等级',
  `phase` tinyint(4) NOT NULL DEFAULT '0' COMMENT '卡牌突破阶段',
  `potential` smallint(6) NOT NULL DEFAULT '0' COMMENT '潜能点',
  `atk` float(10,3) NOT NULL DEFAULT '0.000',
  `def` float(10,3) NOT NULL DEFAULT '0.000',
  `hp` float(10,3) NOT NULL DEFAULT '0.000',
  `slevel_1` smallint(4) NOT NULL DEFAULT '0',
  `slevel_2` smallint(4) NOT NULL DEFAULT '0',
  `slevel_3` smallint(4) NOT NULL DEFAULT '0',
  `slevel_4` smallint(4) NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_card_idx` (`user_id`,`card_id`)
) ENGINE=InnoDB AUTO_INCREMENT=176 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_card_54`
--

DROP TABLE IF EXISTS `user_card_54`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_card_54` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL COMMENT '卡牌用户ID',
  `card_id` smallint(6) NOT NULL COMMENT '卡牌ID',
  `exp` int(11) NOT NULL DEFAULT '0' COMMENT '经验值',
  `level` smallint(6) NOT NULL DEFAULT '1' COMMENT '卡牌等级',
  `phase` tinyint(4) NOT NULL DEFAULT '0' COMMENT '卡牌突破阶段',
  `potential` smallint(6) NOT NULL DEFAULT '0' COMMENT '潜能点',
  `atk` float(10,3) NOT NULL DEFAULT '0.000',
  `def` float(10,3) NOT NULL DEFAULT '0.000',
  `hp` float(10,3) NOT NULL DEFAULT '0.000',
  `slevel_1` smallint(4) NOT NULL DEFAULT '0',
  `slevel_2` smallint(4) NOT NULL DEFAULT '0',
  `slevel_3` smallint(4) NOT NULL DEFAULT '0',
  `slevel_4` smallint(4) NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_card_idx` (`user_id`,`card_id`)
) ENGINE=InnoDB AUTO_INCREMENT=148 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_card_55`
--

DROP TABLE IF EXISTS `user_card_55`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_card_55` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL COMMENT '卡牌用户ID',
  `card_id` smallint(6) NOT NULL COMMENT '卡牌ID',
  `exp` int(11) NOT NULL DEFAULT '0' COMMENT '经验值',
  `level` smallint(6) NOT NULL DEFAULT '1' COMMENT '卡牌等级',
  `phase` tinyint(4) NOT NULL DEFAULT '0' COMMENT '卡牌突破阶段',
  `potential` smallint(6) NOT NULL DEFAULT '0' COMMENT '潜能点',
  `atk` float(10,3) NOT NULL DEFAULT '0.000',
  `def` float(10,3) NOT NULL DEFAULT '0.000',
  `hp` float(10,3) NOT NULL DEFAULT '0.000',
  `slevel_1` smallint(4) NOT NULL DEFAULT '0',
  `slevel_2` smallint(4) NOT NULL DEFAULT '0',
  `slevel_3` smallint(4) NOT NULL DEFAULT '0',
  `slevel_4` smallint(4) NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_card_idx` (`user_id`,`card_id`)
) ENGINE=InnoDB AUTO_INCREMENT=256 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_card_56`
--

DROP TABLE IF EXISTS `user_card_56`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_card_56` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL COMMENT '卡牌用户ID',
  `card_id` smallint(6) NOT NULL COMMENT '卡牌ID',
  `exp` int(11) NOT NULL DEFAULT '0' COMMENT '经验值',
  `level` smallint(6) NOT NULL DEFAULT '1' COMMENT '卡牌等级',
  `phase` tinyint(4) NOT NULL DEFAULT '0' COMMENT '卡牌突破阶段',
  `potential` smallint(6) NOT NULL DEFAULT '0' COMMENT '潜能点',
  `atk` float(10,3) NOT NULL DEFAULT '0.000',
  `def` float(10,3) NOT NULL DEFAULT '0.000',
  `hp` float(10,3) NOT NULL DEFAULT '0.000',
  `slevel_1` smallint(4) NOT NULL DEFAULT '0',
  `slevel_2` smallint(4) NOT NULL DEFAULT '0',
  `slevel_3` smallint(4) NOT NULL DEFAULT '0',
  `slevel_4` smallint(4) NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_card_idx` (`user_id`,`card_id`)
) ENGINE=InnoDB AUTO_INCREMENT=111 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_card_57`
--

DROP TABLE IF EXISTS `user_card_57`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_card_57` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL COMMENT '卡牌用户ID',
  `card_id` smallint(6) NOT NULL COMMENT '卡牌ID',
  `exp` int(11) NOT NULL DEFAULT '0' COMMENT '经验值',
  `level` smallint(6) NOT NULL DEFAULT '1' COMMENT '卡牌等级',
  `phase` tinyint(4) NOT NULL DEFAULT '0' COMMENT '卡牌突破阶段',
  `potential` smallint(6) NOT NULL DEFAULT '0' COMMENT '潜能点',
  `atk` float(10,3) NOT NULL DEFAULT '0.000',
  `def` float(10,3) NOT NULL DEFAULT '0.000',
  `hp` float(10,3) NOT NULL DEFAULT '0.000',
  `slevel_1` smallint(4) NOT NULL DEFAULT '0',
  `slevel_2` smallint(4) NOT NULL DEFAULT '0',
  `slevel_3` smallint(4) NOT NULL DEFAULT '0',
  `slevel_4` smallint(4) NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_card_idx` (`user_id`,`card_id`)
) ENGINE=InnoDB AUTO_INCREMENT=301 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_card_58`
--

DROP TABLE IF EXISTS `user_card_58`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_card_58` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL COMMENT '卡牌用户ID',
  `card_id` smallint(6) NOT NULL COMMENT '卡牌ID',
  `exp` int(11) NOT NULL DEFAULT '0' COMMENT '经验值',
  `level` smallint(6) NOT NULL DEFAULT '1' COMMENT '卡牌等级',
  `phase` tinyint(4) NOT NULL DEFAULT '0' COMMENT '卡牌突破阶段',
  `potential` smallint(6) NOT NULL DEFAULT '0' COMMENT '潜能点',
  `atk` float(10,3) NOT NULL DEFAULT '0.000',
  `def` float(10,3) NOT NULL DEFAULT '0.000',
  `hp` float(10,3) NOT NULL DEFAULT '0.000',
  `slevel_1` smallint(4) NOT NULL DEFAULT '0',
  `slevel_2` smallint(4) NOT NULL DEFAULT '0',
  `slevel_3` smallint(4) NOT NULL DEFAULT '0',
  `slevel_4` smallint(4) NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_card_idx` (`user_id`,`card_id`)
) ENGINE=InnoDB AUTO_INCREMENT=175 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_card_59`
--

DROP TABLE IF EXISTS `user_card_59`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_card_59` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL COMMENT '卡牌用户ID',
  `card_id` smallint(6) NOT NULL COMMENT '卡牌ID',
  `exp` int(11) NOT NULL DEFAULT '0' COMMENT '经验值',
  `level` smallint(6) NOT NULL DEFAULT '1' COMMENT '卡牌等级',
  `phase` tinyint(4) NOT NULL DEFAULT '0' COMMENT '卡牌突破阶段',
  `potential` smallint(6) NOT NULL DEFAULT '0' COMMENT '潜能点',
  `atk` float(10,3) NOT NULL DEFAULT '0.000',
  `def` float(10,3) NOT NULL DEFAULT '0.000',
  `hp` float(10,3) NOT NULL DEFAULT '0.000',
  `slevel_1` smallint(4) NOT NULL DEFAULT '0',
  `slevel_2` smallint(4) NOT NULL DEFAULT '0',
  `slevel_3` smallint(4) NOT NULL DEFAULT '0',
  `slevel_4` smallint(4) NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_card_idx` (`user_id`,`card_id`)
) ENGINE=InnoDB AUTO_INCREMENT=96 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_card_60`
--

DROP TABLE IF EXISTS `user_card_60`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_card_60` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL COMMENT '卡牌用户ID',
  `card_id` smallint(6) NOT NULL COMMENT '卡牌ID',
  `exp` int(11) NOT NULL DEFAULT '0' COMMENT '经验值',
  `level` smallint(6) NOT NULL DEFAULT '1' COMMENT '卡牌等级',
  `phase` tinyint(4) NOT NULL DEFAULT '0' COMMENT '卡牌突破阶段',
  `potential` smallint(6) NOT NULL DEFAULT '0' COMMENT '潜能点',
  `atk` float(10,3) NOT NULL DEFAULT '0.000',
  `def` float(10,3) NOT NULL DEFAULT '0.000',
  `hp` float(10,3) NOT NULL DEFAULT '0.000',
  `slevel_1` smallint(4) NOT NULL DEFAULT '0',
  `slevel_2` smallint(4) NOT NULL DEFAULT '0',
  `slevel_3` smallint(4) NOT NULL DEFAULT '0',
  `slevel_4` smallint(4) NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_card_idx` (`user_id`,`card_id`)
) ENGINE=InnoDB AUTO_INCREMENT=139 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_card_61`
--

DROP TABLE IF EXISTS `user_card_61`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_card_61` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL COMMENT '卡牌用户ID',
  `card_id` smallint(6) NOT NULL COMMENT '卡牌ID',
  `exp` int(11) NOT NULL DEFAULT '0' COMMENT '经验值',
  `level` smallint(6) NOT NULL DEFAULT '1' COMMENT '卡牌等级',
  `phase` tinyint(4) NOT NULL DEFAULT '0' COMMENT '卡牌突破阶段',
  `potential` smallint(6) NOT NULL DEFAULT '0' COMMENT '潜能点',
  `atk` float(10,3) NOT NULL DEFAULT '0.000',
  `def` float(10,3) NOT NULL DEFAULT '0.000',
  `hp` float(10,3) NOT NULL DEFAULT '0.000',
  `slevel_1` smallint(4) NOT NULL DEFAULT '0',
  `slevel_2` smallint(4) NOT NULL DEFAULT '0',
  `slevel_3` smallint(4) NOT NULL DEFAULT '0',
  `slevel_4` smallint(4) NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_card_idx` (`user_id`,`card_id`)
) ENGINE=InnoDB AUTO_INCREMENT=187 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_card_62`
--

DROP TABLE IF EXISTS `user_card_62`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_card_62` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL COMMENT '卡牌用户ID',
  `card_id` smallint(6) NOT NULL COMMENT '卡牌ID',
  `exp` int(11) NOT NULL DEFAULT '0' COMMENT '经验值',
  `level` smallint(6) NOT NULL DEFAULT '1' COMMENT '卡牌等级',
  `phase` tinyint(4) NOT NULL DEFAULT '0' COMMENT '卡牌突破阶段',
  `potential` smallint(6) NOT NULL DEFAULT '0' COMMENT '潜能点',
  `atk` float(10,3) NOT NULL DEFAULT '0.000',
  `def` float(10,3) NOT NULL DEFAULT '0.000',
  `hp` float(10,3) NOT NULL DEFAULT '0.000',
  `slevel_1` smallint(4) NOT NULL DEFAULT '0',
  `slevel_2` smallint(4) NOT NULL DEFAULT '0',
  `slevel_3` smallint(4) NOT NULL DEFAULT '0',
  `slevel_4` smallint(4) NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_card_idx` (`user_id`,`card_id`)
) ENGINE=InnoDB AUTO_INCREMENT=87 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_card_63`
--

DROP TABLE IF EXISTS `user_card_63`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_card_63` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL COMMENT '卡牌用户ID',
  `card_id` smallint(6) NOT NULL COMMENT '卡牌ID',
  `exp` int(11) NOT NULL DEFAULT '0' COMMENT '经验值',
  `level` smallint(6) NOT NULL DEFAULT '1' COMMENT '卡牌等级',
  `phase` tinyint(4) NOT NULL DEFAULT '0' COMMENT '卡牌突破阶段',
  `potential` smallint(6) NOT NULL DEFAULT '0' COMMENT '潜能点',
  `atk` float(10,3) NOT NULL DEFAULT '0.000',
  `def` float(10,3) NOT NULL DEFAULT '0.000',
  `hp` float(10,3) NOT NULL DEFAULT '0.000',
  `slevel_1` smallint(4) NOT NULL DEFAULT '0',
  `slevel_2` smallint(4) NOT NULL DEFAULT '0',
  `slevel_3` smallint(4) NOT NULL DEFAULT '0',
  `slevel_4` smallint(4) NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_card_idx` (`user_id`,`card_id`)
) ENGINE=InnoDB AUTO_INCREMENT=75 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_card_64`
--

DROP TABLE IF EXISTS `user_card_64`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_card_64` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL COMMENT '卡牌用户ID',
  `card_id` smallint(6) NOT NULL COMMENT '卡牌ID',
  `exp` int(11) NOT NULL DEFAULT '0' COMMENT '经验值',
  `level` smallint(6) NOT NULL DEFAULT '1' COMMENT '卡牌等级',
  `phase` tinyint(4) NOT NULL DEFAULT '0' COMMENT '卡牌突破阶段',
  `potential` smallint(6) NOT NULL DEFAULT '0' COMMENT '潜能点',
  `atk` float(10,3) NOT NULL DEFAULT '0.000',
  `def` float(10,3) NOT NULL DEFAULT '0.000',
  `hp` float(10,3) NOT NULL DEFAULT '0.000',
  `slevel_1` smallint(4) NOT NULL DEFAULT '0',
  `slevel_2` smallint(4) NOT NULL DEFAULT '0',
  `slevel_3` smallint(4) NOT NULL DEFAULT '0',
  `slevel_4` smallint(4) NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_card_idx` (`user_id`,`card_id`)
) ENGINE=InnoDB AUTO_INCREMENT=121 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_card_65`
--

DROP TABLE IF EXISTS `user_card_65`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_card_65` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL COMMENT '卡牌用户ID',
  `card_id` smallint(6) NOT NULL COMMENT '卡牌ID',
  `exp` int(11) NOT NULL DEFAULT '0' COMMENT '经验值',
  `level` smallint(6) NOT NULL DEFAULT '1' COMMENT '卡牌等级',
  `phase` tinyint(4) NOT NULL DEFAULT '0' COMMENT '卡牌突破阶段',
  `potential` smallint(6) NOT NULL DEFAULT '0' COMMENT '潜能点',
  `atk` float(10,3) NOT NULL DEFAULT '0.000',
  `def` float(10,3) NOT NULL DEFAULT '0.000',
  `hp` float(10,3) NOT NULL DEFAULT '0.000',
  `slevel_1` smallint(4) NOT NULL DEFAULT '0',
  `slevel_2` smallint(4) NOT NULL DEFAULT '0',
  `slevel_3` smallint(4) NOT NULL DEFAULT '0',
  `slevel_4` smallint(4) NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_card_idx` (`user_id`,`card_id`)
) ENGINE=InnoDB AUTO_INCREMENT=117 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_card_66`
--

DROP TABLE IF EXISTS `user_card_66`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_card_66` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL COMMENT '卡牌用户ID',
  `card_id` smallint(6) NOT NULL COMMENT '卡牌ID',
  `exp` int(11) NOT NULL DEFAULT '0' COMMENT '经验值',
  `level` smallint(6) NOT NULL DEFAULT '1' COMMENT '卡牌等级',
  `phase` tinyint(4) NOT NULL DEFAULT '0' COMMENT '卡牌突破阶段',
  `potential` smallint(6) NOT NULL DEFAULT '0' COMMENT '潜能点',
  `atk` float(10,3) NOT NULL DEFAULT '0.000',
  `def` float(10,3) NOT NULL DEFAULT '0.000',
  `hp` float(10,3) NOT NULL DEFAULT '0.000',
  `slevel_1` smallint(4) NOT NULL DEFAULT '0',
  `slevel_2` smallint(4) NOT NULL DEFAULT '0',
  `slevel_3` smallint(4) NOT NULL DEFAULT '0',
  `slevel_4` smallint(4) NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_card_idx` (`user_id`,`card_id`)
) ENGINE=InnoDB AUTO_INCREMENT=74 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_card_67`
--

DROP TABLE IF EXISTS `user_card_67`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_card_67` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL COMMENT '卡牌用户ID',
  `card_id` smallint(6) NOT NULL COMMENT '卡牌ID',
  `exp` int(11) NOT NULL DEFAULT '0' COMMENT '经验值',
  `level` smallint(6) NOT NULL DEFAULT '1' COMMENT '卡牌等级',
  `phase` tinyint(4) NOT NULL DEFAULT '0' COMMENT '卡牌突破阶段',
  `potential` smallint(6) NOT NULL DEFAULT '0' COMMENT '潜能点',
  `atk` float(10,3) NOT NULL DEFAULT '0.000',
  `def` float(10,3) NOT NULL DEFAULT '0.000',
  `hp` float(10,3) NOT NULL DEFAULT '0.000',
  `slevel_1` smallint(4) NOT NULL DEFAULT '0',
  `slevel_2` smallint(4) NOT NULL DEFAULT '0',
  `slevel_3` smallint(4) NOT NULL DEFAULT '0',
  `slevel_4` smallint(4) NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_card_idx` (`user_id`,`card_id`)
) ENGINE=InnoDB AUTO_INCREMENT=210 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_card_68`
--

DROP TABLE IF EXISTS `user_card_68`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_card_68` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL COMMENT '卡牌用户ID',
  `card_id` smallint(6) NOT NULL COMMENT '卡牌ID',
  `exp` int(11) NOT NULL DEFAULT '0' COMMENT '经验值',
  `level` smallint(6) NOT NULL DEFAULT '1' COMMENT '卡牌等级',
  `phase` tinyint(4) NOT NULL DEFAULT '0' COMMENT '卡牌突破阶段',
  `potential` smallint(6) NOT NULL DEFAULT '0' COMMENT '潜能点',
  `atk` float(10,3) NOT NULL DEFAULT '0.000',
  `def` float(10,3) NOT NULL DEFAULT '0.000',
  `hp` float(10,3) NOT NULL DEFAULT '0.000',
  `slevel_1` smallint(4) NOT NULL DEFAULT '0',
  `slevel_2` smallint(4) NOT NULL DEFAULT '0',
  `slevel_3` smallint(4) NOT NULL DEFAULT '0',
  `slevel_4` smallint(4) NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_card_idx` (`user_id`,`card_id`)
) ENGINE=InnoDB AUTO_INCREMENT=163 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_card_69`
--

DROP TABLE IF EXISTS `user_card_69`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_card_69` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL COMMENT '卡牌用户ID',
  `card_id` smallint(6) NOT NULL COMMENT '卡牌ID',
  `exp` int(11) NOT NULL DEFAULT '0' COMMENT '经验值',
  `level` smallint(6) NOT NULL DEFAULT '1' COMMENT '卡牌等级',
  `phase` tinyint(4) NOT NULL DEFAULT '0' COMMENT '卡牌突破阶段',
  `potential` smallint(6) NOT NULL DEFAULT '0' COMMENT '潜能点',
  `atk` float(10,3) NOT NULL DEFAULT '0.000',
  `def` float(10,3) NOT NULL DEFAULT '0.000',
  `hp` float(10,3) NOT NULL DEFAULT '0.000',
  `slevel_1` smallint(4) NOT NULL DEFAULT '0',
  `slevel_2` smallint(4) NOT NULL DEFAULT '0',
  `slevel_3` smallint(4) NOT NULL DEFAULT '0',
  `slevel_4` smallint(4) NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_card_idx` (`user_id`,`card_id`)
) ENGINE=InnoDB AUTO_INCREMENT=237 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_card_70`
--

DROP TABLE IF EXISTS `user_card_70`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_card_70` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL COMMENT '卡牌用户ID',
  `card_id` smallint(6) NOT NULL COMMENT '卡牌ID',
  `exp` int(11) NOT NULL DEFAULT '0' COMMENT '经验值',
  `level` smallint(6) NOT NULL DEFAULT '1' COMMENT '卡牌等级',
  `phase` tinyint(4) NOT NULL DEFAULT '0' COMMENT '卡牌突破阶段',
  `potential` smallint(6) NOT NULL DEFAULT '0' COMMENT '潜能点',
  `atk` float(10,3) NOT NULL DEFAULT '0.000',
  `def` float(10,3) NOT NULL DEFAULT '0.000',
  `hp` float(10,3) NOT NULL DEFAULT '0.000',
  `slevel_1` smallint(4) NOT NULL DEFAULT '0',
  `slevel_2` smallint(4) NOT NULL DEFAULT '0',
  `slevel_3` smallint(4) NOT NULL DEFAULT '0',
  `slevel_4` smallint(4) NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_card_idx` (`user_id`,`card_id`)
) ENGINE=InnoDB AUTO_INCREMENT=190 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_card_71`
--

DROP TABLE IF EXISTS `user_card_71`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_card_71` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL COMMENT '卡牌用户ID',
  `card_id` smallint(6) NOT NULL COMMENT '卡牌ID',
  `exp` int(11) NOT NULL DEFAULT '0' COMMENT '经验值',
  `level` smallint(6) NOT NULL DEFAULT '1' COMMENT '卡牌等级',
  `phase` tinyint(4) NOT NULL DEFAULT '0' COMMENT '卡牌突破阶段',
  `potential` smallint(6) NOT NULL DEFAULT '0' COMMENT '潜能点',
  `atk` float(10,3) NOT NULL DEFAULT '0.000',
  `def` float(10,3) NOT NULL DEFAULT '0.000',
  `hp` float(10,3) NOT NULL DEFAULT '0.000',
  `slevel_1` smallint(4) NOT NULL DEFAULT '0',
  `slevel_2` smallint(4) NOT NULL DEFAULT '0',
  `slevel_3` smallint(4) NOT NULL DEFAULT '0',
  `slevel_4` smallint(4) NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_card_idx` (`user_id`,`card_id`)
) ENGINE=InnoDB AUTO_INCREMENT=390 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_card_72`
--

DROP TABLE IF EXISTS `user_card_72`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_card_72` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL COMMENT '卡牌用户ID',
  `card_id` smallint(6) NOT NULL COMMENT '卡牌ID',
  `exp` int(11) NOT NULL DEFAULT '0' COMMENT '经验值',
  `level` smallint(6) NOT NULL DEFAULT '1' COMMENT '卡牌等级',
  `phase` tinyint(4) NOT NULL DEFAULT '0' COMMENT '卡牌突破阶段',
  `potential` smallint(6) NOT NULL DEFAULT '0' COMMENT '潜能点',
  `atk` float(10,3) NOT NULL DEFAULT '0.000',
  `def` float(10,3) NOT NULL DEFAULT '0.000',
  `hp` float(10,3) NOT NULL DEFAULT '0.000',
  `slevel_1` smallint(4) NOT NULL DEFAULT '0',
  `slevel_2` smallint(4) NOT NULL DEFAULT '0',
  `slevel_3` smallint(4) NOT NULL DEFAULT '0',
  `slevel_4` smallint(4) NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_card_idx` (`user_id`,`card_id`)
) ENGINE=InnoDB AUTO_INCREMENT=215 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_card_73`
--

DROP TABLE IF EXISTS `user_card_73`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_card_73` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL COMMENT '卡牌用户ID',
  `card_id` smallint(6) NOT NULL COMMENT '卡牌ID',
  `exp` int(11) NOT NULL DEFAULT '0' COMMENT '经验值',
  `level` smallint(6) NOT NULL DEFAULT '1' COMMENT '卡牌等级',
  `phase` tinyint(4) NOT NULL DEFAULT '0' COMMENT '卡牌突破阶段',
  `potential` smallint(6) NOT NULL DEFAULT '0' COMMENT '潜能点',
  `atk` float(10,3) NOT NULL DEFAULT '0.000',
  `def` float(10,3) NOT NULL DEFAULT '0.000',
  `hp` float(10,3) NOT NULL DEFAULT '0.000',
  `slevel_1` smallint(4) NOT NULL DEFAULT '0',
  `slevel_2` smallint(4) NOT NULL DEFAULT '0',
  `slevel_3` smallint(4) NOT NULL DEFAULT '0',
  `slevel_4` smallint(4) NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_card_idx` (`user_id`,`card_id`)
) ENGINE=InnoDB AUTO_INCREMENT=207 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_card_74`
--

DROP TABLE IF EXISTS `user_card_74`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_card_74` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL COMMENT '卡牌用户ID',
  `card_id` smallint(6) NOT NULL COMMENT '卡牌ID',
  `exp` int(11) NOT NULL DEFAULT '0' COMMENT '经验值',
  `level` smallint(6) NOT NULL DEFAULT '1' COMMENT '卡牌等级',
  `phase` tinyint(4) NOT NULL DEFAULT '0' COMMENT '卡牌突破阶段',
  `potential` smallint(6) NOT NULL DEFAULT '0' COMMENT '潜能点',
  `atk` float(10,3) NOT NULL DEFAULT '0.000',
  `def` float(10,3) NOT NULL DEFAULT '0.000',
  `hp` float(10,3) NOT NULL DEFAULT '0.000',
  `slevel_1` smallint(4) NOT NULL DEFAULT '0',
  `slevel_2` smallint(4) NOT NULL DEFAULT '0',
  `slevel_3` smallint(4) NOT NULL DEFAULT '0',
  `slevel_4` smallint(4) NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_card_idx` (`user_id`,`card_id`)
) ENGINE=InnoDB AUTO_INCREMENT=300 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_card_75`
--

DROP TABLE IF EXISTS `user_card_75`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_card_75` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL COMMENT '卡牌用户ID',
  `card_id` smallint(6) NOT NULL COMMENT '卡牌ID',
  `exp` int(11) NOT NULL DEFAULT '0' COMMENT '经验值',
  `level` smallint(6) NOT NULL DEFAULT '1' COMMENT '卡牌等级',
  `phase` tinyint(4) NOT NULL DEFAULT '0' COMMENT '卡牌突破阶段',
  `potential` smallint(6) NOT NULL DEFAULT '0' COMMENT '潜能点',
  `atk` float(10,3) NOT NULL DEFAULT '0.000',
  `def` float(10,3) NOT NULL DEFAULT '0.000',
  `hp` float(10,3) NOT NULL DEFAULT '0.000',
  `slevel_1` smallint(4) NOT NULL DEFAULT '0',
  `slevel_2` smallint(4) NOT NULL DEFAULT '0',
  `slevel_3` smallint(4) NOT NULL DEFAULT '0',
  `slevel_4` smallint(4) NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_card_idx` (`user_id`,`card_id`)
) ENGINE=InnoDB AUTO_INCREMENT=294 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_card_76`
--

DROP TABLE IF EXISTS `user_card_76`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_card_76` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL COMMENT '卡牌用户ID',
  `card_id` smallint(6) NOT NULL COMMENT '卡牌ID',
  `exp` int(11) NOT NULL DEFAULT '0' COMMENT '经验值',
  `level` smallint(6) NOT NULL DEFAULT '1' COMMENT '卡牌等级',
  `phase` tinyint(4) NOT NULL DEFAULT '0' COMMENT '卡牌突破阶段',
  `potential` smallint(6) NOT NULL DEFAULT '0' COMMENT '潜能点',
  `atk` float(10,3) NOT NULL DEFAULT '0.000',
  `def` float(10,3) NOT NULL DEFAULT '0.000',
  `hp` float(10,3) NOT NULL DEFAULT '0.000',
  `slevel_1` smallint(4) NOT NULL DEFAULT '0',
  `slevel_2` smallint(4) NOT NULL DEFAULT '0',
  `slevel_3` smallint(4) NOT NULL DEFAULT '0',
  `slevel_4` smallint(4) NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_card_idx` (`user_id`,`card_id`)
) ENGINE=InnoDB AUTO_INCREMENT=229 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_card_77`
--

DROP TABLE IF EXISTS `user_card_77`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_card_77` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL COMMENT '卡牌用户ID',
  `card_id` smallint(6) NOT NULL COMMENT '卡牌ID',
  `exp` int(11) NOT NULL DEFAULT '0' COMMENT '经验值',
  `level` smallint(6) NOT NULL DEFAULT '1' COMMENT '卡牌等级',
  `phase` tinyint(4) NOT NULL DEFAULT '0' COMMENT '卡牌突破阶段',
  `potential` smallint(6) NOT NULL DEFAULT '0' COMMENT '潜能点',
  `atk` float(10,3) NOT NULL DEFAULT '0.000',
  `def` float(10,3) NOT NULL DEFAULT '0.000',
  `hp` float(10,3) NOT NULL DEFAULT '0.000',
  `slevel_1` smallint(4) NOT NULL DEFAULT '0',
  `slevel_2` smallint(4) NOT NULL DEFAULT '0',
  `slevel_3` smallint(4) NOT NULL DEFAULT '0',
  `slevel_4` smallint(4) NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_card_idx` (`user_id`,`card_id`)
) ENGINE=InnoDB AUTO_INCREMENT=137 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_card_78`
--

DROP TABLE IF EXISTS `user_card_78`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_card_78` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL COMMENT '卡牌用户ID',
  `card_id` smallint(6) NOT NULL COMMENT '卡牌ID',
  `exp` int(11) NOT NULL DEFAULT '0' COMMENT '经验值',
  `level` smallint(6) NOT NULL DEFAULT '1' COMMENT '卡牌等级',
  `phase` tinyint(4) NOT NULL DEFAULT '0' COMMENT '卡牌突破阶段',
  `potential` smallint(6) NOT NULL DEFAULT '0' COMMENT '潜能点',
  `atk` float(10,3) NOT NULL DEFAULT '0.000',
  `def` float(10,3) NOT NULL DEFAULT '0.000',
  `hp` float(10,3) NOT NULL DEFAULT '0.000',
  `slevel_1` smallint(4) NOT NULL DEFAULT '0',
  `slevel_2` smallint(4) NOT NULL DEFAULT '0',
  `slevel_3` smallint(4) NOT NULL DEFAULT '0',
  `slevel_4` smallint(4) NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_card_idx` (`user_id`,`card_id`)
) ENGINE=InnoDB AUTO_INCREMENT=324 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_card_79`
--

DROP TABLE IF EXISTS `user_card_79`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_card_79` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL COMMENT '卡牌用户ID',
  `card_id` smallint(6) NOT NULL COMMENT '卡牌ID',
  `exp` int(11) NOT NULL DEFAULT '0' COMMENT '经验值',
  `level` smallint(6) NOT NULL DEFAULT '1' COMMENT '卡牌等级',
  `phase` tinyint(4) NOT NULL DEFAULT '0' COMMENT '卡牌突破阶段',
  `potential` smallint(6) NOT NULL DEFAULT '0' COMMENT '潜能点',
  `atk` float(10,3) NOT NULL DEFAULT '0.000',
  `def` float(10,3) NOT NULL DEFAULT '0.000',
  `hp` float(10,3) NOT NULL DEFAULT '0.000',
  `slevel_1` smallint(4) NOT NULL DEFAULT '0',
  `slevel_2` smallint(4) NOT NULL DEFAULT '0',
  `slevel_3` smallint(4) NOT NULL DEFAULT '0',
  `slevel_4` smallint(4) NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_card_idx` (`user_id`,`card_id`)
) ENGINE=InnoDB AUTO_INCREMENT=196 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_card_80`
--

DROP TABLE IF EXISTS `user_card_80`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_card_80` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL COMMENT '卡牌用户ID',
  `card_id` smallint(6) NOT NULL COMMENT '卡牌ID',
  `exp` int(11) NOT NULL DEFAULT '0' COMMENT '经验值',
  `level` smallint(6) NOT NULL DEFAULT '1' COMMENT '卡牌等级',
  `phase` tinyint(4) NOT NULL DEFAULT '0' COMMENT '卡牌突破阶段',
  `potential` smallint(6) NOT NULL DEFAULT '0' COMMENT '潜能点',
  `atk` float(10,3) NOT NULL DEFAULT '0.000',
  `def` float(10,3) NOT NULL DEFAULT '0.000',
  `hp` float(10,3) NOT NULL DEFAULT '0.000',
  `slevel_1` smallint(4) NOT NULL DEFAULT '0',
  `slevel_2` smallint(4) NOT NULL DEFAULT '0',
  `slevel_3` smallint(4) NOT NULL DEFAULT '0',
  `slevel_4` smallint(4) NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_card_idx` (`user_id`,`card_id`)
) ENGINE=InnoDB AUTO_INCREMENT=187 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_card_81`
--

DROP TABLE IF EXISTS `user_card_81`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_card_81` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL COMMENT '卡牌用户ID',
  `card_id` smallint(6) NOT NULL COMMENT '卡牌ID',
  `exp` int(11) NOT NULL DEFAULT '0' COMMENT '经验值',
  `level` smallint(6) NOT NULL DEFAULT '1' COMMENT '卡牌等级',
  `phase` tinyint(4) NOT NULL DEFAULT '0' COMMENT '卡牌突破阶段',
  `potential` smallint(6) NOT NULL DEFAULT '0' COMMENT '潜能点',
  `atk` float(10,3) NOT NULL DEFAULT '0.000',
  `def` float(10,3) NOT NULL DEFAULT '0.000',
  `hp` float(10,3) NOT NULL DEFAULT '0.000',
  `slevel_1` smallint(4) NOT NULL DEFAULT '0',
  `slevel_2` smallint(4) NOT NULL DEFAULT '0',
  `slevel_3` smallint(4) NOT NULL DEFAULT '0',
  `slevel_4` smallint(4) NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_card_idx` (`user_id`,`card_id`)
) ENGINE=InnoDB AUTO_INCREMENT=147 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_card_82`
--

DROP TABLE IF EXISTS `user_card_82`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_card_82` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL COMMENT '卡牌用户ID',
  `card_id` smallint(6) NOT NULL COMMENT '卡牌ID',
  `exp` int(11) NOT NULL DEFAULT '0' COMMENT '经验值',
  `level` smallint(6) NOT NULL DEFAULT '1' COMMENT '卡牌等级',
  `phase` tinyint(4) NOT NULL DEFAULT '0' COMMENT '卡牌突破阶段',
  `potential` smallint(6) NOT NULL DEFAULT '0' COMMENT '潜能点',
  `atk` float(10,3) NOT NULL DEFAULT '0.000',
  `def` float(10,3) NOT NULL DEFAULT '0.000',
  `hp` float(10,3) NOT NULL DEFAULT '0.000',
  `slevel_1` smallint(4) NOT NULL DEFAULT '0',
  `slevel_2` smallint(4) NOT NULL DEFAULT '0',
  `slevel_3` smallint(4) NOT NULL DEFAULT '0',
  `slevel_4` smallint(4) NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_card_idx` (`user_id`,`card_id`)
) ENGINE=InnoDB AUTO_INCREMENT=399 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_card_83`
--

DROP TABLE IF EXISTS `user_card_83`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_card_83` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL COMMENT '卡牌用户ID',
  `card_id` smallint(6) NOT NULL COMMENT '卡牌ID',
  `exp` int(11) NOT NULL DEFAULT '0' COMMENT '经验值',
  `level` smallint(6) NOT NULL DEFAULT '1' COMMENT '卡牌等级',
  `phase` tinyint(4) NOT NULL DEFAULT '0' COMMENT '卡牌突破阶段',
  `potential` smallint(6) NOT NULL DEFAULT '0' COMMENT '潜能点',
  `atk` float(10,3) NOT NULL DEFAULT '0.000',
  `def` float(10,3) NOT NULL DEFAULT '0.000',
  `hp` float(10,3) NOT NULL DEFAULT '0.000',
  `slevel_1` smallint(4) NOT NULL DEFAULT '0',
  `slevel_2` smallint(4) NOT NULL DEFAULT '0',
  `slevel_3` smallint(4) NOT NULL DEFAULT '0',
  `slevel_4` smallint(4) NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_card_idx` (`user_id`,`card_id`)
) ENGINE=InnoDB AUTO_INCREMENT=160 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_card_84`
--

DROP TABLE IF EXISTS `user_card_84`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_card_84` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL COMMENT '卡牌用户ID',
  `card_id` smallint(6) NOT NULL COMMENT '卡牌ID',
  `exp` int(11) NOT NULL DEFAULT '0' COMMENT '经验值',
  `level` smallint(6) NOT NULL DEFAULT '1' COMMENT '卡牌等级',
  `phase` tinyint(4) NOT NULL DEFAULT '0' COMMENT '卡牌突破阶段',
  `potential` smallint(6) NOT NULL DEFAULT '0' COMMENT '潜能点',
  `atk` float(10,3) NOT NULL DEFAULT '0.000',
  `def` float(10,3) NOT NULL DEFAULT '0.000',
  `hp` float(10,3) NOT NULL DEFAULT '0.000',
  `slevel_1` smallint(4) NOT NULL DEFAULT '0',
  `slevel_2` smallint(4) NOT NULL DEFAULT '0',
  `slevel_3` smallint(4) NOT NULL DEFAULT '0',
  `slevel_4` smallint(4) NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_card_idx` (`user_id`,`card_id`)
) ENGINE=InnoDB AUTO_INCREMENT=224 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_card_85`
--

DROP TABLE IF EXISTS `user_card_85`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_card_85` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL COMMENT '卡牌用户ID',
  `card_id` smallint(6) NOT NULL COMMENT '卡牌ID',
  `exp` int(11) NOT NULL DEFAULT '0' COMMENT '经验值',
  `level` smallint(6) NOT NULL DEFAULT '1' COMMENT '卡牌等级',
  `phase` tinyint(4) NOT NULL DEFAULT '0' COMMENT '卡牌突破阶段',
  `potential` smallint(6) NOT NULL DEFAULT '0' COMMENT '潜能点',
  `atk` float(10,3) NOT NULL DEFAULT '0.000',
  `def` float(10,3) NOT NULL DEFAULT '0.000',
  `hp` float(10,3) NOT NULL DEFAULT '0.000',
  `slevel_1` smallint(4) NOT NULL DEFAULT '0',
  `slevel_2` smallint(4) NOT NULL DEFAULT '0',
  `slevel_3` smallint(4) NOT NULL DEFAULT '0',
  `slevel_4` smallint(4) NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_card_idx` (`user_id`,`card_id`)
) ENGINE=InnoDB AUTO_INCREMENT=175 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_card_86`
--

DROP TABLE IF EXISTS `user_card_86`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_card_86` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL COMMENT '卡牌用户ID',
  `card_id` smallint(6) NOT NULL COMMENT '卡牌ID',
  `exp` int(11) NOT NULL DEFAULT '0' COMMENT '经验值',
  `level` smallint(6) NOT NULL DEFAULT '1' COMMENT '卡牌等级',
  `phase` tinyint(4) NOT NULL DEFAULT '0' COMMENT '卡牌突破阶段',
  `potential` smallint(6) NOT NULL DEFAULT '0' COMMENT '潜能点',
  `atk` float(10,3) NOT NULL DEFAULT '0.000',
  `def` float(10,3) NOT NULL DEFAULT '0.000',
  `hp` float(10,3) NOT NULL DEFAULT '0.000',
  `slevel_1` smallint(4) NOT NULL DEFAULT '0',
  `slevel_2` smallint(4) NOT NULL DEFAULT '0',
  `slevel_3` smallint(4) NOT NULL DEFAULT '0',
  `slevel_4` smallint(4) NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_card_idx` (`user_id`,`card_id`)
) ENGINE=InnoDB AUTO_INCREMENT=336 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_card_87`
--

DROP TABLE IF EXISTS `user_card_87`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_card_87` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL COMMENT '卡牌用户ID',
  `card_id` smallint(6) NOT NULL COMMENT '卡牌ID',
  `exp` int(11) NOT NULL DEFAULT '0' COMMENT '经验值',
  `level` smallint(6) NOT NULL DEFAULT '1' COMMENT '卡牌等级',
  `phase` tinyint(4) NOT NULL DEFAULT '0' COMMENT '卡牌突破阶段',
  `potential` smallint(6) NOT NULL DEFAULT '0' COMMENT '潜能点',
  `atk` float(10,3) NOT NULL DEFAULT '0.000',
  `def` float(10,3) NOT NULL DEFAULT '0.000',
  `hp` float(10,3) NOT NULL DEFAULT '0.000',
  `slevel_1` smallint(4) NOT NULL DEFAULT '0',
  `slevel_2` smallint(4) NOT NULL DEFAULT '0',
  `slevel_3` smallint(4) NOT NULL DEFAULT '0',
  `slevel_4` smallint(4) NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_card_idx` (`user_id`,`card_id`)
) ENGINE=InnoDB AUTO_INCREMENT=318 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_card_88`
--

DROP TABLE IF EXISTS `user_card_88`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_card_88` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL COMMENT '卡牌用户ID',
  `card_id` smallint(6) NOT NULL COMMENT '卡牌ID',
  `exp` int(11) NOT NULL DEFAULT '0' COMMENT '经验值',
  `level` smallint(6) NOT NULL DEFAULT '1' COMMENT '卡牌等级',
  `phase` tinyint(4) NOT NULL DEFAULT '0' COMMENT '卡牌突破阶段',
  `potential` smallint(6) NOT NULL DEFAULT '0' COMMENT '潜能点',
  `atk` float(10,3) NOT NULL DEFAULT '0.000',
  `def` float(10,3) NOT NULL DEFAULT '0.000',
  `hp` float(10,3) NOT NULL DEFAULT '0.000',
  `slevel_1` smallint(4) NOT NULL DEFAULT '0',
  `slevel_2` smallint(4) NOT NULL DEFAULT '0',
  `slevel_3` smallint(4) NOT NULL DEFAULT '0',
  `slevel_4` smallint(4) NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_card_idx` (`user_id`,`card_id`)
) ENGINE=InnoDB AUTO_INCREMENT=148 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_card_89`
--

DROP TABLE IF EXISTS `user_card_89`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_card_89` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL COMMENT '卡牌用户ID',
  `card_id` smallint(6) NOT NULL COMMENT '卡牌ID',
  `exp` int(11) NOT NULL DEFAULT '0' COMMENT '经验值',
  `level` smallint(6) NOT NULL DEFAULT '1' COMMENT '卡牌等级',
  `phase` tinyint(4) NOT NULL DEFAULT '0' COMMENT '卡牌突破阶段',
  `potential` smallint(6) NOT NULL DEFAULT '0' COMMENT '潜能点',
  `atk` float(10,3) NOT NULL DEFAULT '0.000',
  `def` float(10,3) NOT NULL DEFAULT '0.000',
  `hp` float(10,3) NOT NULL DEFAULT '0.000',
  `slevel_1` smallint(4) NOT NULL DEFAULT '0',
  `slevel_2` smallint(4) NOT NULL DEFAULT '0',
  `slevel_3` smallint(4) NOT NULL DEFAULT '0',
  `slevel_4` smallint(4) NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_card_idx` (`user_id`,`card_id`)
) ENGINE=InnoDB AUTO_INCREMENT=220 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_card_90`
--

DROP TABLE IF EXISTS `user_card_90`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_card_90` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL COMMENT '卡牌用户ID',
  `card_id` smallint(6) NOT NULL COMMENT '卡牌ID',
  `exp` int(11) NOT NULL DEFAULT '0' COMMENT '经验值',
  `level` smallint(6) NOT NULL DEFAULT '1' COMMENT '卡牌等级',
  `phase` tinyint(4) NOT NULL DEFAULT '0' COMMENT '卡牌突破阶段',
  `potential` smallint(6) NOT NULL DEFAULT '0' COMMENT '潜能点',
  `atk` float(10,3) NOT NULL DEFAULT '0.000',
  `def` float(10,3) NOT NULL DEFAULT '0.000',
  `hp` float(10,3) NOT NULL DEFAULT '0.000',
  `slevel_1` smallint(4) NOT NULL DEFAULT '0',
  `slevel_2` smallint(4) NOT NULL DEFAULT '0',
  `slevel_3` smallint(4) NOT NULL DEFAULT '0',
  `slevel_4` smallint(4) NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_card_idx` (`user_id`,`card_id`)
) ENGINE=InnoDB AUTO_INCREMENT=209 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_card_91`
--

DROP TABLE IF EXISTS `user_card_91`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_card_91` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL COMMENT '卡牌用户ID',
  `card_id` smallint(6) NOT NULL COMMENT '卡牌ID',
  `exp` int(11) NOT NULL DEFAULT '0' COMMENT '经验值',
  `level` smallint(6) NOT NULL DEFAULT '1' COMMENT '卡牌等级',
  `phase` tinyint(4) NOT NULL DEFAULT '0' COMMENT '卡牌突破阶段',
  `potential` smallint(6) NOT NULL DEFAULT '0' COMMENT '潜能点',
  `atk` float(10,3) NOT NULL DEFAULT '0.000',
  `def` float(10,3) NOT NULL DEFAULT '0.000',
  `hp` float(10,3) NOT NULL DEFAULT '0.000',
  `slevel_1` smallint(4) NOT NULL DEFAULT '0',
  `slevel_2` smallint(4) NOT NULL DEFAULT '0',
  `slevel_3` smallint(4) NOT NULL DEFAULT '0',
  `slevel_4` smallint(4) NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_card_idx` (`user_id`,`card_id`)
) ENGINE=InnoDB AUTO_INCREMENT=180 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_card_92`
--

DROP TABLE IF EXISTS `user_card_92`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_card_92` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL COMMENT '卡牌用户ID',
  `card_id` smallint(6) NOT NULL COMMENT '卡牌ID',
  `exp` int(11) NOT NULL DEFAULT '0' COMMENT '经验值',
  `level` smallint(6) NOT NULL DEFAULT '1' COMMENT '卡牌等级',
  `phase` tinyint(4) NOT NULL DEFAULT '0' COMMENT '卡牌突破阶段',
  `potential` smallint(6) NOT NULL DEFAULT '0' COMMENT '潜能点',
  `atk` float(10,3) NOT NULL DEFAULT '0.000',
  `def` float(10,3) NOT NULL DEFAULT '0.000',
  `hp` float(10,3) NOT NULL DEFAULT '0.000',
  `slevel_1` smallint(4) NOT NULL DEFAULT '0',
  `slevel_2` smallint(4) NOT NULL DEFAULT '0',
  `slevel_3` smallint(4) NOT NULL DEFAULT '0',
  `slevel_4` smallint(4) NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_card_idx` (`user_id`,`card_id`)
) ENGINE=InnoDB AUTO_INCREMENT=177 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_card_93`
--

DROP TABLE IF EXISTS `user_card_93`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_card_93` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL COMMENT '卡牌用户ID',
  `card_id` smallint(6) NOT NULL COMMENT '卡牌ID',
  `exp` int(11) NOT NULL DEFAULT '0' COMMENT '经验值',
  `level` smallint(6) NOT NULL DEFAULT '1' COMMENT '卡牌等级',
  `phase` tinyint(4) NOT NULL DEFAULT '0' COMMENT '卡牌突破阶段',
  `potential` smallint(6) NOT NULL DEFAULT '0' COMMENT '潜能点',
  `atk` float(10,3) NOT NULL DEFAULT '0.000',
  `def` float(10,3) NOT NULL DEFAULT '0.000',
  `hp` float(10,3) NOT NULL DEFAULT '0.000',
  `slevel_1` smallint(4) NOT NULL DEFAULT '0',
  `slevel_2` smallint(4) NOT NULL DEFAULT '0',
  `slevel_3` smallint(4) NOT NULL DEFAULT '0',
  `slevel_4` smallint(4) NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_card_idx` (`user_id`,`card_id`)
) ENGINE=InnoDB AUTO_INCREMENT=126 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_card_94`
--

DROP TABLE IF EXISTS `user_card_94`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_card_94` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL COMMENT '卡牌用户ID',
  `card_id` smallint(6) NOT NULL COMMENT '卡牌ID',
  `exp` int(11) NOT NULL DEFAULT '0' COMMENT '经验值',
  `level` smallint(6) NOT NULL DEFAULT '1' COMMENT '卡牌等级',
  `phase` tinyint(4) NOT NULL DEFAULT '0' COMMENT '卡牌突破阶段',
  `potential` smallint(6) NOT NULL DEFAULT '0' COMMENT '潜能点',
  `atk` float(10,3) NOT NULL DEFAULT '0.000',
  `def` float(10,3) NOT NULL DEFAULT '0.000',
  `hp` float(10,3) NOT NULL DEFAULT '0.000',
  `slevel_1` smallint(4) NOT NULL DEFAULT '0',
  `slevel_2` smallint(4) NOT NULL DEFAULT '0',
  `slevel_3` smallint(4) NOT NULL DEFAULT '0',
  `slevel_4` smallint(4) NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_card_idx` (`user_id`,`card_id`)
) ENGINE=InnoDB AUTO_INCREMENT=212 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_card_95`
--

DROP TABLE IF EXISTS `user_card_95`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_card_95` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL COMMENT '卡牌用户ID',
  `card_id` smallint(6) NOT NULL COMMENT '卡牌ID',
  `exp` int(11) NOT NULL DEFAULT '0' COMMENT '经验值',
  `level` smallint(6) NOT NULL DEFAULT '1' COMMENT '卡牌等级',
  `phase` tinyint(4) NOT NULL DEFAULT '0' COMMENT '卡牌突破阶段',
  `potential` smallint(6) NOT NULL DEFAULT '0' COMMENT '潜能点',
  `atk` float(10,3) NOT NULL DEFAULT '0.000',
  `def` float(10,3) NOT NULL DEFAULT '0.000',
  `hp` float(10,3) NOT NULL DEFAULT '0.000',
  `slevel_1` smallint(4) NOT NULL DEFAULT '0',
  `slevel_2` smallint(4) NOT NULL DEFAULT '0',
  `slevel_3` smallint(4) NOT NULL DEFAULT '0',
  `slevel_4` smallint(4) NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_card_idx` (`user_id`,`card_id`)
) ENGINE=InnoDB AUTO_INCREMENT=114 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_card_96`
--

DROP TABLE IF EXISTS `user_card_96`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_card_96` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL COMMENT '卡牌用户ID',
  `card_id` smallint(6) NOT NULL COMMENT '卡牌ID',
  `exp` int(11) NOT NULL DEFAULT '0' COMMENT '经验值',
  `level` smallint(6) NOT NULL DEFAULT '1' COMMENT '卡牌等级',
  `phase` tinyint(4) NOT NULL DEFAULT '0' COMMENT '卡牌突破阶段',
  `potential` smallint(6) NOT NULL DEFAULT '0' COMMENT '潜能点',
  `atk` float(10,3) NOT NULL DEFAULT '0.000',
  `def` float(10,3) NOT NULL DEFAULT '0.000',
  `hp` float(10,3) NOT NULL DEFAULT '0.000',
  `slevel_1` smallint(4) NOT NULL DEFAULT '0',
  `slevel_2` smallint(4) NOT NULL DEFAULT '0',
  `slevel_3` smallint(4) NOT NULL DEFAULT '0',
  `slevel_4` smallint(4) NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_card_idx` (`user_id`,`card_id`)
) ENGINE=InnoDB AUTO_INCREMENT=127 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_card_97`
--

DROP TABLE IF EXISTS `user_card_97`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_card_97` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL COMMENT '卡牌用户ID',
  `card_id` smallint(6) NOT NULL COMMENT '卡牌ID',
  `exp` int(11) NOT NULL DEFAULT '0' COMMENT '经验值',
  `level` smallint(6) NOT NULL DEFAULT '1' COMMENT '卡牌等级',
  `phase` tinyint(4) NOT NULL DEFAULT '0' COMMENT '卡牌突破阶段',
  `potential` smallint(6) NOT NULL DEFAULT '0' COMMENT '潜能点',
  `atk` float(10,3) NOT NULL DEFAULT '0.000',
  `def` float(10,3) NOT NULL DEFAULT '0.000',
  `hp` float(10,3) NOT NULL DEFAULT '0.000',
  `slevel_1` smallint(4) NOT NULL DEFAULT '0',
  `slevel_2` smallint(4) NOT NULL DEFAULT '0',
  `slevel_3` smallint(4) NOT NULL DEFAULT '0',
  `slevel_4` smallint(4) NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_card_idx` (`user_id`,`card_id`)
) ENGINE=InnoDB AUTO_INCREMENT=172 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_card_98`
--

DROP TABLE IF EXISTS `user_card_98`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_card_98` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL COMMENT '卡牌用户ID',
  `card_id` smallint(6) NOT NULL COMMENT '卡牌ID',
  `exp` int(11) NOT NULL DEFAULT '0' COMMENT '经验值',
  `level` smallint(6) NOT NULL DEFAULT '1' COMMENT '卡牌等级',
  `phase` tinyint(4) NOT NULL DEFAULT '0' COMMENT '卡牌突破阶段',
  `potential` smallint(6) NOT NULL DEFAULT '0' COMMENT '潜能点',
  `atk` float(10,3) NOT NULL DEFAULT '0.000',
  `def` float(10,3) NOT NULL DEFAULT '0.000',
  `hp` float(10,3) NOT NULL DEFAULT '0.000',
  `slevel_1` smallint(4) NOT NULL DEFAULT '0',
  `slevel_2` smallint(4) NOT NULL DEFAULT '0',
  `slevel_3` smallint(4) NOT NULL DEFAULT '0',
  `slevel_4` smallint(4) NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_card_idx` (`user_id`,`card_id`)
) ENGINE=InnoDB AUTO_INCREMENT=105 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_card_99`
--

DROP TABLE IF EXISTS `user_card_99`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_card_99` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL COMMENT '卡牌用户ID',
  `card_id` smallint(6) NOT NULL COMMENT '卡牌ID',
  `exp` int(11) NOT NULL DEFAULT '0' COMMENT '经验值',
  `level` smallint(6) NOT NULL DEFAULT '1' COMMENT '卡牌等级',
  `phase` tinyint(4) NOT NULL DEFAULT '0' COMMENT '卡牌突破阶段',
  `potential` smallint(6) NOT NULL DEFAULT '0' COMMENT '潜能点',
  `atk` float(10,3) NOT NULL DEFAULT '0.000',
  `def` float(10,3) NOT NULL DEFAULT '0.000',
  `hp` float(10,3) NOT NULL DEFAULT '0.000',
  `slevel_1` smallint(4) NOT NULL DEFAULT '0',
  `slevel_2` smallint(4) NOT NULL DEFAULT '0',
  `slevel_3` smallint(4) NOT NULL DEFAULT '0',
  `slevel_4` smallint(4) NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_card_idx` (`user_id`,`card_id`)
) ENGINE=InnoDB AUTO_INCREMENT=208 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_card_piece`
--

DROP TABLE IF EXISTS `user_card_piece`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_card_piece` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `card_id` int(11) NOT NULL,
  `count` smallint(6) NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_card_index` (`user_id`,`card_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_card_piece_00`
--

DROP TABLE IF EXISTS `user_card_piece_00`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_card_piece_00` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `card_id` int(11) NOT NULL,
  `count` smallint(6) NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_card_index` (`user_id`,`card_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_card_piece_01`
--

DROP TABLE IF EXISTS `user_card_piece_01`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_card_piece_01` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `card_id` int(11) NOT NULL,
  `count` smallint(6) NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_card_index` (`user_id`,`card_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_card_piece_02`
--

DROP TABLE IF EXISTS `user_card_piece_02`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_card_piece_02` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `card_id` int(11) NOT NULL,
  `count` smallint(6) NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_card_index` (`user_id`,`card_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_card_piece_03`
--

DROP TABLE IF EXISTS `user_card_piece_03`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_card_piece_03` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `card_id` int(11) NOT NULL,
  `count` smallint(6) NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_card_index` (`user_id`,`card_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_card_piece_04`
--

DROP TABLE IF EXISTS `user_card_piece_04`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_card_piece_04` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `card_id` int(11) NOT NULL,
  `count` smallint(6) NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_card_index` (`user_id`,`card_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_card_piece_05`
--

DROP TABLE IF EXISTS `user_card_piece_05`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_card_piece_05` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `card_id` int(11) NOT NULL,
  `count` smallint(6) NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_card_index` (`user_id`,`card_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_card_piece_06`
--

DROP TABLE IF EXISTS `user_card_piece_06`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_card_piece_06` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `card_id` int(11) NOT NULL,
  `count` smallint(6) NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_card_index` (`user_id`,`card_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_card_piece_07`
--

DROP TABLE IF EXISTS `user_card_piece_07`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_card_piece_07` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `card_id` int(11) NOT NULL,
  `count` smallint(6) NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_card_index` (`user_id`,`card_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_card_piece_08`
--

DROP TABLE IF EXISTS `user_card_piece_08`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_card_piece_08` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `card_id` int(11) NOT NULL,
  `count` smallint(6) NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_card_index` (`user_id`,`card_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_card_piece_09`
--

DROP TABLE IF EXISTS `user_card_piece_09`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_card_piece_09` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `card_id` int(11) NOT NULL,
  `count` smallint(6) NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_card_index` (`user_id`,`card_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_card_piece_10`
--

DROP TABLE IF EXISTS `user_card_piece_10`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_card_piece_10` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `card_id` int(11) NOT NULL,
  `count` smallint(6) NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_card_index` (`user_id`,`card_id`)
) ENGINE=InnoDB AUTO_INCREMENT=458 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_card_piece_11`
--

DROP TABLE IF EXISTS `user_card_piece_11`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_card_piece_11` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `card_id` int(11) NOT NULL,
  `count` smallint(6) NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_card_index` (`user_id`,`card_id`)
) ENGINE=InnoDB AUTO_INCREMENT=936 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_card_piece_12`
--

DROP TABLE IF EXISTS `user_card_piece_12`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_card_piece_12` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `card_id` int(11) NOT NULL,
  `count` smallint(6) NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_card_index` (`user_id`,`card_id`)
) ENGINE=InnoDB AUTO_INCREMENT=279 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_card_piece_13`
--

DROP TABLE IF EXISTS `user_card_piece_13`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_card_piece_13` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `card_id` int(11) NOT NULL,
  `count` smallint(6) NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_card_index` (`user_id`,`card_id`)
) ENGINE=InnoDB AUTO_INCREMENT=195 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_card_piece_14`
--

DROP TABLE IF EXISTS `user_card_piece_14`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_card_piece_14` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `card_id` int(11) NOT NULL,
  `count` smallint(6) NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_card_index` (`user_id`,`card_id`)
) ENGINE=InnoDB AUTO_INCREMENT=302 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_card_piece_15`
--

DROP TABLE IF EXISTS `user_card_piece_15`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_card_piece_15` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `card_id` int(11) NOT NULL,
  `count` smallint(6) NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_card_index` (`user_id`,`card_id`)
) ENGINE=InnoDB AUTO_INCREMENT=909 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_card_piece_16`
--

DROP TABLE IF EXISTS `user_card_piece_16`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_card_piece_16` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `card_id` int(11) NOT NULL,
  `count` smallint(6) NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_card_index` (`user_id`,`card_id`)
) ENGINE=InnoDB AUTO_INCREMENT=567 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_card_piece_17`
--

DROP TABLE IF EXISTS `user_card_piece_17`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_card_piece_17` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `card_id` int(11) NOT NULL,
  `count` smallint(6) NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_card_index` (`user_id`,`card_id`)
) ENGINE=InnoDB AUTO_INCREMENT=969 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_card_piece_18`
--

DROP TABLE IF EXISTS `user_card_piece_18`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_card_piece_18` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `card_id` int(11) NOT NULL,
  `count` smallint(6) NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_card_index` (`user_id`,`card_id`)
) ENGINE=InnoDB AUTO_INCREMENT=368 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_card_piece_19`
--

DROP TABLE IF EXISTS `user_card_piece_19`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_card_piece_19` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `card_id` int(11) NOT NULL,
  `count` smallint(6) NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_card_index` (`user_id`,`card_id`)
) ENGINE=InnoDB AUTO_INCREMENT=843 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_card_piece_20`
--

DROP TABLE IF EXISTS `user_card_piece_20`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_card_piece_20` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `card_id` int(11) NOT NULL,
  `count` smallint(6) NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_card_index` (`user_id`,`card_id`)
) ENGINE=InnoDB AUTO_INCREMENT=569 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_card_piece_21`
--

DROP TABLE IF EXISTS `user_card_piece_21`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_card_piece_21` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `card_id` int(11) NOT NULL,
  `count` smallint(6) NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_card_index` (`user_id`,`card_id`)
) ENGINE=InnoDB AUTO_INCREMENT=61 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_card_piece_22`
--

DROP TABLE IF EXISTS `user_card_piece_22`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_card_piece_22` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `card_id` int(11) NOT NULL,
  `count` smallint(6) NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_card_index` (`user_id`,`card_id`)
) ENGINE=InnoDB AUTO_INCREMENT=95 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_card_piece_23`
--

DROP TABLE IF EXISTS `user_card_piece_23`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_card_piece_23` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `card_id` int(11) NOT NULL,
  `count` smallint(6) NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_card_index` (`user_id`,`card_id`)
) ENGINE=InnoDB AUTO_INCREMENT=329 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_card_piece_24`
--

DROP TABLE IF EXISTS `user_card_piece_24`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_card_piece_24` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `card_id` int(11) NOT NULL,
  `count` smallint(6) NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_card_index` (`user_id`,`card_id`)
) ENGINE=InnoDB AUTO_INCREMENT=301 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_card_piece_25`
--

DROP TABLE IF EXISTS `user_card_piece_25`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_card_piece_25` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `card_id` int(11) NOT NULL,
  `count` smallint(6) NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_card_index` (`user_id`,`card_id`)
) ENGINE=InnoDB AUTO_INCREMENT=225 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_card_piece_26`
--

DROP TABLE IF EXISTS `user_card_piece_26`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_card_piece_26` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `card_id` int(11) NOT NULL,
  `count` smallint(6) NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_card_index` (`user_id`,`card_id`)
) ENGINE=InnoDB AUTO_INCREMENT=284 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_card_piece_27`
--

DROP TABLE IF EXISTS `user_card_piece_27`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_card_piece_27` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `card_id` int(11) NOT NULL,
  `count` smallint(6) NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_card_index` (`user_id`,`card_id`)
) ENGINE=InnoDB AUTO_INCREMENT=344 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_card_piece_28`
--

DROP TABLE IF EXISTS `user_card_piece_28`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_card_piece_28` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `card_id` int(11) NOT NULL,
  `count` smallint(6) NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_card_index` (`user_id`,`card_id`)
) ENGINE=InnoDB AUTO_INCREMENT=803 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_card_piece_29`
--

DROP TABLE IF EXISTS `user_card_piece_29`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_card_piece_29` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `card_id` int(11) NOT NULL,
  `count` smallint(6) NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_card_index` (`user_id`,`card_id`)
) ENGINE=InnoDB AUTO_INCREMENT=446 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_card_piece_30`
--

DROP TABLE IF EXISTS `user_card_piece_30`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_card_piece_30` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `card_id` int(11) NOT NULL,
  `count` smallint(6) NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_card_index` (`user_id`,`card_id`)
) ENGINE=InnoDB AUTO_INCREMENT=452 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_card_piece_31`
--

DROP TABLE IF EXISTS `user_card_piece_31`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_card_piece_31` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `card_id` int(11) NOT NULL,
  `count` smallint(6) NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_card_index` (`user_id`,`card_id`)
) ENGINE=InnoDB AUTO_INCREMENT=141 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_card_piece_32`
--

DROP TABLE IF EXISTS `user_card_piece_32`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_card_piece_32` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `card_id` int(11) NOT NULL,
  `count` smallint(6) NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_card_index` (`user_id`,`card_id`)
) ENGINE=InnoDB AUTO_INCREMENT=335 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_card_piece_33`
--

DROP TABLE IF EXISTS `user_card_piece_33`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_card_piece_33` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `card_id` int(11) NOT NULL,
  `count` smallint(6) NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_card_index` (`user_id`,`card_id`)
) ENGINE=InnoDB AUTO_INCREMENT=736 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_card_piece_34`
--

DROP TABLE IF EXISTS `user_card_piece_34`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_card_piece_34` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `card_id` int(11) NOT NULL,
  `count` smallint(6) NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_card_index` (`user_id`,`card_id`)
) ENGINE=InnoDB AUTO_INCREMENT=282 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_card_piece_35`
--

DROP TABLE IF EXISTS `user_card_piece_35`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_card_piece_35` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `card_id` int(11) NOT NULL,
  `count` smallint(6) NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_card_index` (`user_id`,`card_id`)
) ENGINE=InnoDB AUTO_INCREMENT=667 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_card_piece_36`
--

DROP TABLE IF EXISTS `user_card_piece_36`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_card_piece_36` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `card_id` int(11) NOT NULL,
  `count` smallint(6) NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_card_index` (`user_id`,`card_id`)
) ENGINE=InnoDB AUTO_INCREMENT=268 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_card_piece_37`
--

DROP TABLE IF EXISTS `user_card_piece_37`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_card_piece_37` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `card_id` int(11) NOT NULL,
  `count` smallint(6) NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_card_index` (`user_id`,`card_id`)
) ENGINE=InnoDB AUTO_INCREMENT=170 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_card_piece_38`
--

DROP TABLE IF EXISTS `user_card_piece_38`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_card_piece_38` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `card_id` int(11) NOT NULL,
  `count` smallint(6) NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_card_index` (`user_id`,`card_id`)
) ENGINE=InnoDB AUTO_INCREMENT=619 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_card_piece_39`
--

DROP TABLE IF EXISTS `user_card_piece_39`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_card_piece_39` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `card_id` int(11) NOT NULL,
  `count` smallint(6) NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_card_index` (`user_id`,`card_id`)
) ENGINE=InnoDB AUTO_INCREMENT=419 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_card_piece_40`
--

DROP TABLE IF EXISTS `user_card_piece_40`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_card_piece_40` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `card_id` int(11) NOT NULL,
  `count` smallint(6) NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_card_index` (`user_id`,`card_id`)
) ENGINE=InnoDB AUTO_INCREMENT=499 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_card_piece_41`
--

DROP TABLE IF EXISTS `user_card_piece_41`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_card_piece_41` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `card_id` int(11) NOT NULL,
  `count` smallint(6) NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_card_index` (`user_id`,`card_id`)
) ENGINE=InnoDB AUTO_INCREMENT=210 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_card_piece_42`
--

DROP TABLE IF EXISTS `user_card_piece_42`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_card_piece_42` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `card_id` int(11) NOT NULL,
  `count` smallint(6) NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_card_index` (`user_id`,`card_id`)
) ENGINE=InnoDB AUTO_INCREMENT=87 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_card_piece_43`
--

DROP TABLE IF EXISTS `user_card_piece_43`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_card_piece_43` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `card_id` int(11) NOT NULL,
  `count` smallint(6) NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_card_index` (`user_id`,`card_id`)
) ENGINE=InnoDB AUTO_INCREMENT=207 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_card_piece_44`
--

DROP TABLE IF EXISTS `user_card_piece_44`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_card_piece_44` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `card_id` int(11) NOT NULL,
  `count` smallint(6) NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_card_index` (`user_id`,`card_id`)
) ENGINE=InnoDB AUTO_INCREMENT=252 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_card_piece_45`
--

DROP TABLE IF EXISTS `user_card_piece_45`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_card_piece_45` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `card_id` int(11) NOT NULL,
  `count` smallint(6) NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_card_index` (`user_id`,`card_id`)
) ENGINE=InnoDB AUTO_INCREMENT=162 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_card_piece_46`
--

DROP TABLE IF EXISTS `user_card_piece_46`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_card_piece_46` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `card_id` int(11) NOT NULL,
  `count` smallint(6) NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_card_index` (`user_id`,`card_id`)
) ENGINE=InnoDB AUTO_INCREMENT=135 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_card_piece_47`
--

DROP TABLE IF EXISTS `user_card_piece_47`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_card_piece_47` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `card_id` int(11) NOT NULL,
  `count` smallint(6) NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_card_index` (`user_id`,`card_id`)
) ENGINE=InnoDB AUTO_INCREMENT=910 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_card_piece_48`
--

DROP TABLE IF EXISTS `user_card_piece_48`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_card_piece_48` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `card_id` int(11) NOT NULL,
  `count` smallint(6) NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_card_index` (`user_id`,`card_id`)
) ENGINE=InnoDB AUTO_INCREMENT=390 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_card_piece_49`
--

DROP TABLE IF EXISTS `user_card_piece_49`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_card_piece_49` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `card_id` int(11) NOT NULL,
  `count` smallint(6) NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_card_index` (`user_id`,`card_id`)
) ENGINE=InnoDB AUTO_INCREMENT=455 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_card_piece_50`
--

DROP TABLE IF EXISTS `user_card_piece_50`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_card_piece_50` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `card_id` int(11) NOT NULL,
  `count` smallint(6) NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_card_index` (`user_id`,`card_id`)
) ENGINE=InnoDB AUTO_INCREMENT=130 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_card_piece_51`
--

DROP TABLE IF EXISTS `user_card_piece_51`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_card_piece_51` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `card_id` int(11) NOT NULL,
  `count` smallint(6) NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_card_index` (`user_id`,`card_id`)
) ENGINE=InnoDB AUTO_INCREMENT=356 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_card_piece_52`
--

DROP TABLE IF EXISTS `user_card_piece_52`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_card_piece_52` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `card_id` int(11) NOT NULL,
  `count` smallint(6) NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_card_index` (`user_id`,`card_id`)
) ENGINE=InnoDB AUTO_INCREMENT=325 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_card_piece_53`
--

DROP TABLE IF EXISTS `user_card_piece_53`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_card_piece_53` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `card_id` int(11) NOT NULL,
  `count` smallint(6) NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_card_index` (`user_id`,`card_id`)
) ENGINE=InnoDB AUTO_INCREMENT=485 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_card_piece_54`
--

DROP TABLE IF EXISTS `user_card_piece_54`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_card_piece_54` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `card_id` int(11) NOT NULL,
  `count` smallint(6) NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_card_index` (`user_id`,`card_id`)
) ENGINE=InnoDB AUTO_INCREMENT=196 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_card_piece_55`
--

DROP TABLE IF EXISTS `user_card_piece_55`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_card_piece_55` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `card_id` int(11) NOT NULL,
  `count` smallint(6) NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_card_index` (`user_id`,`card_id`)
) ENGINE=InnoDB AUTO_INCREMENT=776 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_card_piece_56`
--

DROP TABLE IF EXISTS `user_card_piece_56`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_card_piece_56` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `card_id` int(11) NOT NULL,
  `count` smallint(6) NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_card_index` (`user_id`,`card_id`)
) ENGINE=InnoDB AUTO_INCREMENT=136 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_card_piece_57`
--

DROP TABLE IF EXISTS `user_card_piece_57`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_card_piece_57` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `card_id` int(11) NOT NULL,
  `count` smallint(6) NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_card_index` (`user_id`,`card_id`)
) ENGINE=InnoDB AUTO_INCREMENT=997 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_card_piece_58`
--

DROP TABLE IF EXISTS `user_card_piece_58`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_card_piece_58` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `card_id` int(11) NOT NULL,
  `count` smallint(6) NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_card_index` (`user_id`,`card_id`)
) ENGINE=InnoDB AUTO_INCREMENT=345 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_card_piece_59`
--

DROP TABLE IF EXISTS `user_card_piece_59`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_card_piece_59` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `card_id` int(11) NOT NULL,
  `count` smallint(6) NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_card_index` (`user_id`,`card_id`)
) ENGINE=InnoDB AUTO_INCREMENT=173 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_card_piece_60`
--

DROP TABLE IF EXISTS `user_card_piece_60`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_card_piece_60` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `card_id` int(11) NOT NULL,
  `count` smallint(6) NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_card_index` (`user_id`,`card_id`)
) ENGINE=InnoDB AUTO_INCREMENT=215 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_card_piece_61`
--

DROP TABLE IF EXISTS `user_card_piece_61`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_card_piece_61` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `card_id` int(11) NOT NULL,
  `count` smallint(6) NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_card_index` (`user_id`,`card_id`)
) ENGINE=InnoDB AUTO_INCREMENT=378 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_card_piece_62`
--

DROP TABLE IF EXISTS `user_card_piece_62`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_card_piece_62` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `card_id` int(11) NOT NULL,
  `count` smallint(6) NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_card_index` (`user_id`,`card_id`)
) ENGINE=InnoDB AUTO_INCREMENT=115 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_card_piece_63`
--

DROP TABLE IF EXISTS `user_card_piece_63`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_card_piece_63` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `card_id` int(11) NOT NULL,
  `count` smallint(6) NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_card_index` (`user_id`,`card_id`)
) ENGINE=InnoDB AUTO_INCREMENT=60 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_card_piece_64`
--

DROP TABLE IF EXISTS `user_card_piece_64`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_card_piece_64` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `card_id` int(11) NOT NULL,
  `count` smallint(6) NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_card_index` (`user_id`,`card_id`)
) ENGINE=InnoDB AUTO_INCREMENT=205 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_card_piece_65`
--

DROP TABLE IF EXISTS `user_card_piece_65`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_card_piece_65` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `card_id` int(11) NOT NULL,
  `count` smallint(6) NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_card_index` (`user_id`,`card_id`)
) ENGINE=InnoDB AUTO_INCREMENT=162 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_card_piece_66`
--

DROP TABLE IF EXISTS `user_card_piece_66`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_card_piece_66` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `card_id` int(11) NOT NULL,
  `count` smallint(6) NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_card_index` (`user_id`,`card_id`)
) ENGINE=InnoDB AUTO_INCREMENT=48 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_card_piece_67`
--

DROP TABLE IF EXISTS `user_card_piece_67`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_card_piece_67` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `card_id` int(11) NOT NULL,
  `count` smallint(6) NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_card_index` (`user_id`,`card_id`)
) ENGINE=InnoDB AUTO_INCREMENT=484 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_card_piece_68`
--

DROP TABLE IF EXISTS `user_card_piece_68`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_card_piece_68` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `card_id` int(11) NOT NULL,
  `count` smallint(6) NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_card_index` (`user_id`,`card_id`)
) ENGINE=InnoDB AUTO_INCREMENT=78 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_card_piece_69`
--

DROP TABLE IF EXISTS `user_card_piece_69`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_card_piece_69` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `card_id` int(11) NOT NULL,
  `count` smallint(6) NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_card_index` (`user_id`,`card_id`)
) ENGINE=InnoDB AUTO_INCREMENT=761 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_card_piece_70`
--

DROP TABLE IF EXISTS `user_card_piece_70`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_card_piece_70` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `card_id` int(11) NOT NULL,
  `count` smallint(6) NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_card_index` (`user_id`,`card_id`)
) ENGINE=InnoDB AUTO_INCREMENT=180 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_card_piece_71`
--

DROP TABLE IF EXISTS `user_card_piece_71`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_card_piece_71` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `card_id` int(11) NOT NULL,
  `count` smallint(6) NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_card_index` (`user_id`,`card_id`)
) ENGINE=InnoDB AUTO_INCREMENT=2362 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_card_piece_72`
--

DROP TABLE IF EXISTS `user_card_piece_72`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_card_piece_72` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `card_id` int(11) NOT NULL,
  `count` smallint(6) NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_card_index` (`user_id`,`card_id`)
) ENGINE=InnoDB AUTO_INCREMENT=353 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_card_piece_73`
--

DROP TABLE IF EXISTS `user_card_piece_73`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_card_piece_73` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `card_id` int(11) NOT NULL,
  `count` smallint(6) NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_card_index` (`user_id`,`card_id`)
) ENGINE=InnoDB AUTO_INCREMENT=334 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_card_piece_74`
--

DROP TABLE IF EXISTS `user_card_piece_74`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_card_piece_74` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `card_id` int(11) NOT NULL,
  `count` smallint(6) NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_card_index` (`user_id`,`card_id`)
) ENGINE=InnoDB AUTO_INCREMENT=773 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_card_piece_75`
--

DROP TABLE IF EXISTS `user_card_piece_75`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_card_piece_75` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `card_id` int(11) NOT NULL,
  `count` smallint(6) NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_card_index` (`user_id`,`card_id`)
) ENGINE=InnoDB AUTO_INCREMENT=736 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_card_piece_76`
--

DROP TABLE IF EXISTS `user_card_piece_76`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_card_piece_76` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `card_id` int(11) NOT NULL,
  `count` smallint(6) NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_card_index` (`user_id`,`card_id`)
) ENGINE=InnoDB AUTO_INCREMENT=392 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_card_piece_77`
--

DROP TABLE IF EXISTS `user_card_piece_77`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_card_piece_77` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `card_id` int(11) NOT NULL,
  `count` smallint(6) NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_card_index` (`user_id`,`card_id`)
) ENGINE=InnoDB AUTO_INCREMENT=186 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_card_piece_78`
--

DROP TABLE IF EXISTS `user_card_piece_78`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_card_piece_78` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `card_id` int(11) NOT NULL,
  `count` smallint(6) NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_card_index` (`user_id`,`card_id`)
) ENGINE=InnoDB AUTO_INCREMENT=806 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_card_piece_79`
--

DROP TABLE IF EXISTS `user_card_piece_79`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_card_piece_79` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `card_id` int(11) NOT NULL,
  `count` smallint(6) NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_card_index` (`user_id`,`card_id`)
) ENGINE=InnoDB AUTO_INCREMENT=166 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_card_piece_80`
--

DROP TABLE IF EXISTS `user_card_piece_80`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_card_piece_80` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `card_id` int(11) NOT NULL,
  `count` smallint(6) NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_card_index` (`user_id`,`card_id`)
) ENGINE=InnoDB AUTO_INCREMENT=271 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_card_piece_81`
--

DROP TABLE IF EXISTS `user_card_piece_81`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_card_piece_81` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `card_id` int(11) NOT NULL,
  `count` smallint(6) NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_card_index` (`user_id`,`card_id`)
) ENGINE=InnoDB AUTO_INCREMENT=257 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_card_piece_82`
--

DROP TABLE IF EXISTS `user_card_piece_82`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_card_piece_82` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `card_id` int(11) NOT NULL,
  `count` smallint(6) NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_card_index` (`user_id`,`card_id`)
) ENGINE=InnoDB AUTO_INCREMENT=1391 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_card_piece_83`
--

DROP TABLE IF EXISTS `user_card_piece_83`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_card_piece_83` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `card_id` int(11) NOT NULL,
  `count` smallint(6) NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_card_index` (`user_id`,`card_id`)
) ENGINE=InnoDB AUTO_INCREMENT=167 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_card_piece_84`
--

DROP TABLE IF EXISTS `user_card_piece_84`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_card_piece_84` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `card_id` int(11) NOT NULL,
  `count` smallint(6) NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_card_index` (`user_id`,`card_id`)
) ENGINE=InnoDB AUTO_INCREMENT=541 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_card_piece_85`
--

DROP TABLE IF EXISTS `user_card_piece_85`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_card_piece_85` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `card_id` int(11) NOT NULL,
  `count` smallint(6) NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_card_index` (`user_id`,`card_id`)
) ENGINE=InnoDB AUTO_INCREMENT=251 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_card_piece_86`
--

DROP TABLE IF EXISTS `user_card_piece_86`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_card_piece_86` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `card_id` int(11) NOT NULL,
  `count` smallint(6) NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_card_index` (`user_id`,`card_id`)
) ENGINE=InnoDB AUTO_INCREMENT=733 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_card_piece_87`
--

DROP TABLE IF EXISTS `user_card_piece_87`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_card_piece_87` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `card_id` int(11) NOT NULL,
  `count` smallint(6) NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_card_index` (`user_id`,`card_id`)
) ENGINE=InnoDB AUTO_INCREMENT=1111 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_card_piece_88`
--

DROP TABLE IF EXISTS `user_card_piece_88`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_card_piece_88` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `card_id` int(11) NOT NULL,
  `count` smallint(6) NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_card_index` (`user_id`,`card_id`)
) ENGINE=InnoDB AUTO_INCREMENT=271 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_card_piece_89`
--

DROP TABLE IF EXISTS `user_card_piece_89`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_card_piece_89` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `card_id` int(11) NOT NULL,
  `count` smallint(6) NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_card_index` (`user_id`,`card_id`)
) ENGINE=InnoDB AUTO_INCREMENT=561 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_card_piece_90`
--

DROP TABLE IF EXISTS `user_card_piece_90`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_card_piece_90` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `card_id` int(11) NOT NULL,
  `count` smallint(6) NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_card_index` (`user_id`,`card_id`)
) ENGINE=InnoDB AUTO_INCREMENT=367 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_card_piece_91`
--

DROP TABLE IF EXISTS `user_card_piece_91`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_card_piece_91` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `card_id` int(11) NOT NULL,
  `count` smallint(6) NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_card_index` (`user_id`,`card_id`)
) ENGINE=InnoDB AUTO_INCREMENT=367 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_card_piece_92`
--

DROP TABLE IF EXISTS `user_card_piece_92`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_card_piece_92` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `card_id` int(11) NOT NULL,
  `count` smallint(6) NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_card_index` (`user_id`,`card_id`)
) ENGINE=InnoDB AUTO_INCREMENT=407 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_card_piece_93`
--

DROP TABLE IF EXISTS `user_card_piece_93`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_card_piece_93` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `card_id` int(11) NOT NULL,
  `count` smallint(6) NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_card_index` (`user_id`,`card_id`)
) ENGINE=InnoDB AUTO_INCREMENT=327 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_card_piece_94`
--

DROP TABLE IF EXISTS `user_card_piece_94`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_card_piece_94` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `card_id` int(11) NOT NULL,
  `count` smallint(6) NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_card_index` (`user_id`,`card_id`)
) ENGINE=InnoDB AUTO_INCREMENT=593 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_card_piece_95`
--

DROP TABLE IF EXISTS `user_card_piece_95`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_card_piece_95` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `card_id` int(11) NOT NULL,
  `count` smallint(6) NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_card_index` (`user_id`,`card_id`)
) ENGINE=InnoDB AUTO_INCREMENT=127 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_card_piece_96`
--

DROP TABLE IF EXISTS `user_card_piece_96`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_card_piece_96` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `card_id` int(11) NOT NULL,
  `count` smallint(6) NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_card_index` (`user_id`,`card_id`)
) ENGINE=InnoDB AUTO_INCREMENT=314 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_card_piece_97`
--

DROP TABLE IF EXISTS `user_card_piece_97`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_card_piece_97` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `card_id` int(11) NOT NULL,
  `count` smallint(6) NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_card_index` (`user_id`,`card_id`)
) ENGINE=InnoDB AUTO_INCREMENT=438 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_card_piece_98`
--

DROP TABLE IF EXISTS `user_card_piece_98`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_card_piece_98` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `card_id` int(11) NOT NULL,
  `count` smallint(6) NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_card_index` (`user_id`,`card_id`)
) ENGINE=InnoDB AUTO_INCREMENT=116 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_card_piece_99`
--

DROP TABLE IF EXISTS `user_card_piece_99`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_card_piece_99` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `card_id` int(11) NOT NULL,
  `count` smallint(6) NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_card_index` (`user_id`,`card_id`)
) ENGINE=InnoDB AUTO_INCREMENT=441 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_daily_quest_20141016`
--

DROP TABLE IF EXISTS `user_daily_quest_20141016`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_daily_quest_20141016` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `quest_id` int(11) NOT NULL,
  `finished_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_quest_idx` (`user_id`,`quest_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_daily_quest_20141017`
--

DROP TABLE IF EXISTS `user_daily_quest_20141017`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_daily_quest_20141017` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `quest_id` int(11) NOT NULL,
  `finished_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_quest_idx` (`user_id`,`quest_id`)
) ENGINE=InnoDB AUTO_INCREMENT=47 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_daily_quest_20141018`
--

DROP TABLE IF EXISTS `user_daily_quest_20141018`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_daily_quest_20141018` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `quest_id` int(11) NOT NULL,
  `finished_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_quest_idx` (`user_id`,`quest_id`)
) ENGINE=InnoDB AUTO_INCREMENT=30 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_daily_quest_20141019`
--

DROP TABLE IF EXISTS `user_daily_quest_20141019`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_daily_quest_20141019` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `quest_id` int(11) NOT NULL,
  `finished_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_quest_idx` (`user_id`,`quest_id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_daily_quest_20141020`
--

DROP TABLE IF EXISTS `user_daily_quest_20141020`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_daily_quest_20141020` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `quest_id` int(11) NOT NULL,
  `finished_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_quest_idx` (`user_id`,`quest_id`)
) ENGINE=InnoDB AUTO_INCREMENT=62 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_daily_quest_20141021`
--

DROP TABLE IF EXISTS `user_daily_quest_20141021`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_daily_quest_20141021` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `quest_id` int(11) NOT NULL,
  `finished_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_quest_idx` (`user_id`,`quest_id`)
) ENGINE=InnoDB AUTO_INCREMENT=99 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_daily_quest_20141022`
--

DROP TABLE IF EXISTS `user_daily_quest_20141022`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_daily_quest_20141022` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `quest_id` int(11) NOT NULL,
  `finished_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_quest_idx` (`user_id`,`quest_id`)
) ENGINE=InnoDB AUTO_INCREMENT=1906 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_daily_quest_20141023`
--

DROP TABLE IF EXISTS `user_daily_quest_20141023`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_daily_quest_20141023` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `quest_id` int(11) NOT NULL,
  `finished_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_quest_idx` (`user_id`,`quest_id`)
) ENGINE=InnoDB AUTO_INCREMENT=1251 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_daily_quest_20141024`
--

DROP TABLE IF EXISTS `user_daily_quest_20141024`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_daily_quest_20141024` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `quest_id` int(11) NOT NULL,
  `finished_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_quest_idx` (`user_id`,`quest_id`)
) ENGINE=InnoDB AUTO_INCREMENT=1030 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_daily_quest_20141025`
--

DROP TABLE IF EXISTS `user_daily_quest_20141025`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_daily_quest_20141025` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `quest_id` int(11) NOT NULL,
  `finished_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_quest_idx` (`user_id`,`quest_id`)
) ENGINE=InnoDB AUTO_INCREMENT=889 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_daily_quest_20141026`
--

DROP TABLE IF EXISTS `user_daily_quest_20141026`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_daily_quest_20141026` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `quest_id` int(11) NOT NULL,
  `finished_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_quest_idx` (`user_id`,`quest_id`)
) ENGINE=InnoDB AUTO_INCREMENT=849 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_daily_quest_20141027`
--

DROP TABLE IF EXISTS `user_daily_quest_20141027`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_daily_quest_20141027` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `quest_id` int(11) NOT NULL,
  `finished_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_quest_idx` (`user_id`,`quest_id`)
) ENGINE=InnoDB AUTO_INCREMENT=833 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_daily_quest_20141028`
--

DROP TABLE IF EXISTS `user_daily_quest_20141028`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_daily_quest_20141028` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `quest_id` int(11) NOT NULL,
  `finished_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_quest_idx` (`user_id`,`quest_id`)
) ENGINE=InnoDB AUTO_INCREMENT=826 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_daily_quest_20141029`
--

DROP TABLE IF EXISTS `user_daily_quest_20141029`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_daily_quest_20141029` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `quest_id` int(11) NOT NULL,
  `finished_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_quest_idx` (`user_id`,`quest_id`)
) ENGINE=InnoDB AUTO_INCREMENT=766 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_daily_quest_20141030`
--

DROP TABLE IF EXISTS `user_daily_quest_20141030`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_daily_quest_20141030` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `quest_id` int(11) NOT NULL,
  `finished_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_quest_idx` (`user_id`,`quest_id`)
) ENGINE=InnoDB AUTO_INCREMENT=668 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_daily_quest_20141031`
--

DROP TABLE IF EXISTS `user_daily_quest_20141031`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_daily_quest_20141031` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `quest_id` int(11) NOT NULL,
  `finished_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_quest_idx` (`user_id`,`quest_id`)
) ENGINE=InnoDB AUTO_INCREMENT=588 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_daily_quest_20141101`
--

DROP TABLE IF EXISTS `user_daily_quest_20141101`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_daily_quest_20141101` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `quest_id` int(11) NOT NULL,
  `finished_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_quest_idx` (`user_id`,`quest_id`)
) ENGINE=InnoDB AUTO_INCREMENT=559 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_daily_quest_20141102`
--

DROP TABLE IF EXISTS `user_daily_quest_20141102`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_daily_quest_20141102` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `quest_id` int(11) NOT NULL,
  `finished_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_quest_idx` (`user_id`,`quest_id`)
) ENGINE=InnoDB AUTO_INCREMENT=479 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_daily_quest_20141103`
--

DROP TABLE IF EXISTS `user_daily_quest_20141103`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_daily_quest_20141103` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `quest_id` int(11) NOT NULL,
  `finished_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_quest_idx` (`user_id`,`quest_id`)
) ENGINE=InnoDB AUTO_INCREMENT=495 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_daily_quest_20141104`
--

DROP TABLE IF EXISTS `user_daily_quest_20141104`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_daily_quest_20141104` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `quest_id` int(11) NOT NULL,
  `finished_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_quest_idx` (`user_id`,`quest_id`)
) ENGINE=InnoDB AUTO_INCREMENT=270 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_daily_quest_20141105`
--

DROP TABLE IF EXISTS `user_daily_quest_20141105`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_daily_quest_20141105` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `quest_id` int(11) NOT NULL,
  `finished_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_quest_idx` (`user_id`,`quest_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_daily_quest_20141106`
--

DROP TABLE IF EXISTS `user_daily_quest_20141106`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_daily_quest_20141106` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `quest_id` int(11) NOT NULL,
  `finished_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_quest_idx` (`user_id`,`quest_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_daily_quest_20141107`
--

DROP TABLE IF EXISTS `user_daily_quest_20141107`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_daily_quest_20141107` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `quest_id` int(11) NOT NULL,
  `finished_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_quest_idx` (`user_id`,`quest_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_daily_quest_20141108`
--

DROP TABLE IF EXISTS `user_daily_quest_20141108`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_daily_quest_20141108` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `quest_id` int(11) NOT NULL,
  `finished_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_quest_idx` (`user_id`,`quest_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_daily_quest_20141109`
--

DROP TABLE IF EXISTS `user_daily_quest_20141109`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_daily_quest_20141109` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `quest_id` int(11) NOT NULL,
  `finished_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_quest_idx` (`user_id`,`quest_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_daily_quest_20141110`
--

DROP TABLE IF EXISTS `user_daily_quest_20141110`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_daily_quest_20141110` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `quest_id` int(11) NOT NULL,
  `finished_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_quest_idx` (`user_id`,`quest_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_daily_quest_20141111`
--

DROP TABLE IF EXISTS `user_daily_quest_20141111`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_daily_quest_20141111` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `quest_id` int(11) NOT NULL,
  `finished_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_quest_idx` (`user_id`,`quest_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_daily_quest_20141112`
--

DROP TABLE IF EXISTS `user_daily_quest_20141112`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_daily_quest_20141112` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `quest_id` int(11) NOT NULL,
  `finished_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_quest_idx` (`user_id`,`quest_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_daily_quest_20141113`
--

DROP TABLE IF EXISTS `user_daily_quest_20141113`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_daily_quest_20141113` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `quest_id` int(11) NOT NULL,
  `finished_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_quest_idx` (`user_id`,`quest_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_daily_quest_20141114`
--

DROP TABLE IF EXISTS `user_daily_quest_20141114`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_daily_quest_20141114` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `quest_id` int(11) NOT NULL,
  `finished_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_quest_idx` (`user_id`,`quest_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_daily_quest_20141115`
--

DROP TABLE IF EXISTS `user_daily_quest_20141115`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_daily_quest_20141115` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `quest_id` int(11) NOT NULL,
  `finished_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_quest_idx` (`user_id`,`quest_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_daily_quest_20141116`
--

DROP TABLE IF EXISTS `user_daily_quest_20141116`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_daily_quest_20141116` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `quest_id` int(11) NOT NULL,
  `finished_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_quest_idx` (`user_id`,`quest_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_daily_quest_20141117`
--

DROP TABLE IF EXISTS `user_daily_quest_20141117`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_daily_quest_20141117` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `quest_id` int(11) NOT NULL,
  `finished_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_quest_idx` (`user_id`,`quest_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_daily_quest_20141118`
--

DROP TABLE IF EXISTS `user_daily_quest_20141118`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_daily_quest_20141118` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `quest_id` int(11) NOT NULL,
  `finished_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_quest_idx` (`user_id`,`quest_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_daily_quest_20141119`
--

DROP TABLE IF EXISTS `user_daily_quest_20141119`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_daily_quest_20141119` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `quest_id` int(11) NOT NULL,
  `finished_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_quest_idx` (`user_id`,`quest_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_daily_quest_20141120`
--

DROP TABLE IF EXISTS `user_daily_quest_20141120`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_daily_quest_20141120` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `quest_id` int(11) NOT NULL,
  `finished_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_quest_idx` (`user_id`,`quest_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_daily_quest_20141121`
--

DROP TABLE IF EXISTS `user_daily_quest_20141121`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_daily_quest_20141121` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `quest_id` int(11) NOT NULL,
  `finished_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_quest_idx` (`user_id`,`quest_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_daily_quest_20141122`
--

DROP TABLE IF EXISTS `user_daily_quest_20141122`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_daily_quest_20141122` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `quest_id` int(11) NOT NULL,
  `finished_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_quest_idx` (`user_id`,`quest_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_daily_quest_20141123`
--

DROP TABLE IF EXISTS `user_daily_quest_20141123`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_daily_quest_20141123` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `quest_id` int(11) NOT NULL,
  `finished_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_quest_idx` (`user_id`,`quest_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_daily_quest_20141124`
--

DROP TABLE IF EXISTS `user_daily_quest_20141124`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_daily_quest_20141124` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `quest_id` int(11) NOT NULL,
  `finished_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_quest_idx` (`user_id`,`quest_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_daily_quest_20141125`
--

DROP TABLE IF EXISTS `user_daily_quest_20141125`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_daily_quest_20141125` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `quest_id` int(11) NOT NULL,
  `finished_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_quest_idx` (`user_id`,`quest_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_daily_quest_20141126`
--

DROP TABLE IF EXISTS `user_daily_quest_20141126`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_daily_quest_20141126` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `quest_id` int(11) NOT NULL,
  `finished_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_quest_idx` (`user_id`,`quest_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_daily_quest_20141127`
--

DROP TABLE IF EXISTS `user_daily_quest_20141127`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_daily_quest_20141127` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `quest_id` int(11) NOT NULL,
  `finished_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_quest_idx` (`user_id`,`quest_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_daily_quest_20141128`
--

DROP TABLE IF EXISTS `user_daily_quest_20141128`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_daily_quest_20141128` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `quest_id` int(11) NOT NULL,
  `finished_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_quest_idx` (`user_id`,`quest_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_daily_quest_20141129`
--

DROP TABLE IF EXISTS `user_daily_quest_20141129`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_daily_quest_20141129` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `quest_id` int(11) NOT NULL,
  `finished_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_quest_idx` (`user_id`,`quest_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_daily_quest_20141130`
--

DROP TABLE IF EXISTS `user_daily_quest_20141130`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_daily_quest_20141130` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `quest_id` int(11) NOT NULL,
  `finished_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_quest_idx` (`user_id`,`quest_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_daily_quest_20141201`
--

DROP TABLE IF EXISTS `user_daily_quest_20141201`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_daily_quest_20141201` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `quest_id` int(11) NOT NULL,
  `finished_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_quest_idx` (`user_id`,`quest_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_daily_quest_20141202`
--

DROP TABLE IF EXISTS `user_daily_quest_20141202`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_daily_quest_20141202` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `quest_id` int(11) NOT NULL,
  `finished_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_quest_idx` (`user_id`,`quest_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_daily_quest_20141203`
--

DROP TABLE IF EXISTS `user_daily_quest_20141203`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_daily_quest_20141203` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `quest_id` int(11) NOT NULL,
  `finished_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_quest_idx` (`user_id`,`quest_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_daily_quest_20141204`
--

DROP TABLE IF EXISTS `user_daily_quest_20141204`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_daily_quest_20141204` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `quest_id` int(11) NOT NULL,
  `finished_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_quest_idx` (`user_id`,`quest_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_daily_quest_20141205`
--

DROP TABLE IF EXISTS `user_daily_quest_20141205`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_daily_quest_20141205` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `quest_id` int(11) NOT NULL,
  `finished_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_quest_idx` (`user_id`,`quest_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_daily_quest_20141206`
--

DROP TABLE IF EXISTS `user_daily_quest_20141206`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_daily_quest_20141206` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `quest_id` int(11) NOT NULL,
  `finished_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_quest_idx` (`user_id`,`quest_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_daily_quest_20141207`
--

DROP TABLE IF EXISTS `user_daily_quest_20141207`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_daily_quest_20141207` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `quest_id` int(11) NOT NULL,
  `finished_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_quest_idx` (`user_id`,`quest_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_daily_quest_20141208`
--

DROP TABLE IF EXISTS `user_daily_quest_20141208`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_daily_quest_20141208` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `quest_id` int(11) NOT NULL,
  `finished_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_quest_idx` (`user_id`,`quest_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_daily_quest_20141209`
--

DROP TABLE IF EXISTS `user_daily_quest_20141209`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_daily_quest_20141209` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `quest_id` int(11) NOT NULL,
  `finished_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_quest_idx` (`user_id`,`quest_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_daily_quest_20141210`
--

DROP TABLE IF EXISTS `user_daily_quest_20141210`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_daily_quest_20141210` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `quest_id` int(11) NOT NULL,
  `finished_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_quest_idx` (`user_id`,`quest_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_daily_quest_20141211`
--

DROP TABLE IF EXISTS `user_daily_quest_20141211`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_daily_quest_20141211` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `quest_id` int(11) NOT NULL,
  `finished_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_quest_idx` (`user_id`,`quest_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_daily_quest_20141212`
--

DROP TABLE IF EXISTS `user_daily_quest_20141212`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_daily_quest_20141212` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `quest_id` int(11) NOT NULL,
  `finished_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_quest_idx` (`user_id`,`quest_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_daily_quest_20141213`
--

DROP TABLE IF EXISTS `user_daily_quest_20141213`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_daily_quest_20141213` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `quest_id` int(11) NOT NULL,
  `finished_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_quest_idx` (`user_id`,`quest_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_daily_quest_20141214`
--

DROP TABLE IF EXISTS `user_daily_quest_20141214`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_daily_quest_20141214` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `quest_id` int(11) NOT NULL,
  `finished_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_quest_idx` (`user_id`,`quest_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_daily_quest_20141215`
--

DROP TABLE IF EXISTS `user_daily_quest_20141215`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_daily_quest_20141215` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `quest_id` int(11) NOT NULL,
  `finished_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_quest_idx` (`user_id`,`quest_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_daily_quest_20141216`
--

DROP TABLE IF EXISTS `user_daily_quest_20141216`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_daily_quest_20141216` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `quest_id` int(11) NOT NULL,
  `finished_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_quest_idx` (`user_id`,`quest_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_daily_quest_20141217`
--

DROP TABLE IF EXISTS `user_daily_quest_20141217`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_daily_quest_20141217` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `quest_id` int(11) NOT NULL,
  `finished_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_quest_idx` (`user_id`,`quest_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_daily_quest_20141218`
--

DROP TABLE IF EXISTS `user_daily_quest_20141218`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_daily_quest_20141218` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `quest_id` int(11) NOT NULL,
  `finished_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_quest_idx` (`user_id`,`quest_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_daily_quest_20141219`
--

DROP TABLE IF EXISTS `user_daily_quest_20141219`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_daily_quest_20141219` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `quest_id` int(11) NOT NULL,
  `finished_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_quest_idx` (`user_id`,`quest_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_daily_quest_20141220`
--

DROP TABLE IF EXISTS `user_daily_quest_20141220`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_daily_quest_20141220` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `quest_id` int(11) NOT NULL,
  `finished_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_quest_idx` (`user_id`,`quest_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_daily_quest_20141221`
--

DROP TABLE IF EXISTS `user_daily_quest_20141221`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_daily_quest_20141221` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `quest_id` int(11) NOT NULL,
  `finished_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_quest_idx` (`user_id`,`quest_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_daily_quest_20141222`
--

DROP TABLE IF EXISTS `user_daily_quest_20141222`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_daily_quest_20141222` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `quest_id` int(11) NOT NULL,
  `finished_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_quest_idx` (`user_id`,`quest_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_daily_quest_20141223`
--

DROP TABLE IF EXISTS `user_daily_quest_20141223`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_daily_quest_20141223` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `quest_id` int(11) NOT NULL,
  `finished_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_quest_idx` (`user_id`,`quest_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_daily_quest_20141224`
--

DROP TABLE IF EXISTS `user_daily_quest_20141224`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_daily_quest_20141224` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `quest_id` int(11) NOT NULL,
  `finished_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_quest_idx` (`user_id`,`quest_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_daily_quest_20141225`
--

DROP TABLE IF EXISTS `user_daily_quest_20141225`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_daily_quest_20141225` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `quest_id` int(11) NOT NULL,
  `finished_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_quest_idx` (`user_id`,`quest_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_daily_quest_20141226`
--

DROP TABLE IF EXISTS `user_daily_quest_20141226`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_daily_quest_20141226` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `quest_id` int(11) NOT NULL,
  `finished_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_quest_idx` (`user_id`,`quest_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_daily_quest_20141227`
--

DROP TABLE IF EXISTS `user_daily_quest_20141227`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_daily_quest_20141227` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `quest_id` int(11) NOT NULL,
  `finished_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_quest_idx` (`user_id`,`quest_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_daily_quest_20141228`
--

DROP TABLE IF EXISTS `user_daily_quest_20141228`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_daily_quest_20141228` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `quest_id` int(11) NOT NULL,
  `finished_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_quest_idx` (`user_id`,`quest_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_daily_quest_20141229`
--

DROP TABLE IF EXISTS `user_daily_quest_20141229`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_daily_quest_20141229` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `quest_id` int(11) NOT NULL,
  `finished_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_quest_idx` (`user_id`,`quest_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_daily_quest_20141230`
--

DROP TABLE IF EXISTS `user_daily_quest_20141230`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_daily_quest_20141230` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `quest_id` int(11) NOT NULL,
  `finished_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_quest_idx` (`user_id`,`quest_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_daily_quest_20141231`
--

DROP TABLE IF EXISTS `user_daily_quest_20141231`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_daily_quest_20141231` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `quest_id` int(11) NOT NULL,
  `finished_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_quest_idx` (`user_id`,`quest_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_daily_quest_20150101`
--

DROP TABLE IF EXISTS `user_daily_quest_20150101`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_daily_quest_20150101` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `quest_id` int(11) NOT NULL,
  `finished_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_quest_idx` (`user_id`,`quest_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_daily_quest_20150102`
--

DROP TABLE IF EXISTS `user_daily_quest_20150102`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_daily_quest_20150102` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `quest_id` int(11) NOT NULL,
  `finished_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_quest_idx` (`user_id`,`quest_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_daily_quest_20150103`
--

DROP TABLE IF EXISTS `user_daily_quest_20150103`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_daily_quest_20150103` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `quest_id` int(11) NOT NULL,
  `finished_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_quest_idx` (`user_id`,`quest_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_daily_quest_20150104`
--

DROP TABLE IF EXISTS `user_daily_quest_20150104`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_daily_quest_20150104` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `quest_id` int(11) NOT NULL,
  `finished_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_quest_idx` (`user_id`,`quest_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_daily_quest_20150105`
--

DROP TABLE IF EXISTS `user_daily_quest_20150105`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_daily_quest_20150105` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `quest_id` int(11) NOT NULL,
  `finished_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_quest_idx` (`user_id`,`quest_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_daily_quest_20150106`
--

DROP TABLE IF EXISTS `user_daily_quest_20150106`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_daily_quest_20150106` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `quest_id` int(11) NOT NULL,
  `finished_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_quest_idx` (`user_id`,`quest_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_daily_quest_20150107`
--

DROP TABLE IF EXISTS `user_daily_quest_20150107`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_daily_quest_20150107` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `quest_id` int(11) NOT NULL,
  `finished_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_quest_idx` (`user_id`,`quest_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_daily_quest_20150108`
--

DROP TABLE IF EXISTS `user_daily_quest_20150108`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_daily_quest_20150108` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `quest_id` int(11) NOT NULL,
  `finished_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_quest_idx` (`user_id`,`quest_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_daily_quest_20150109`
--

DROP TABLE IF EXISTS `user_daily_quest_20150109`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_daily_quest_20150109` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `quest_id` int(11) NOT NULL,
  `finished_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_quest_idx` (`user_id`,`quest_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_daily_quest_20150110`
--

DROP TABLE IF EXISTS `user_daily_quest_20150110`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_daily_quest_20150110` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `quest_id` int(11) NOT NULL,
  `finished_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_quest_idx` (`user_id`,`quest_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_daily_quest_20150111`
--

DROP TABLE IF EXISTS `user_daily_quest_20150111`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_daily_quest_20150111` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `quest_id` int(11) NOT NULL,
  `finished_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_quest_idx` (`user_id`,`quest_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_daily_quest_20150112`
--

DROP TABLE IF EXISTS `user_daily_quest_20150112`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_daily_quest_20150112` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `quest_id` int(11) NOT NULL,
  `finished_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_quest_idx` (`user_id`,`quest_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_daily_quest_20150113`
--

DROP TABLE IF EXISTS `user_daily_quest_20150113`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_daily_quest_20150113` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `quest_id` int(11) NOT NULL,
  `finished_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_quest_idx` (`user_id`,`quest_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_daily_quest_20150114`
--

DROP TABLE IF EXISTS `user_daily_quest_20150114`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_daily_quest_20150114` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `quest_id` int(11) NOT NULL,
  `finished_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_quest_idx` (`user_id`,`quest_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_daily_quest_20150115`
--

DROP TABLE IF EXISTS `user_daily_quest_20150115`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_daily_quest_20150115` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `quest_id` int(11) NOT NULL,
  `finished_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_quest_idx` (`user_id`,`quest_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_deck`
--

DROP TABLE IF EXISTS `user_deck`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_deck` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `pos` tinyint(1) NOT NULL,
  `user_card_id` int(11) NOT NULL DEFAULT '0',
  `equip_1` int(11) NOT NULL DEFAULT '0',
  `equip_2` int(11) NOT NULL DEFAULT '0',
  `equip_3` int(11) NOT NULL DEFAULT '0',
  `equip_4` int(11) NOT NULL DEFAULT '0',
  `dragon_ball_1` int(11) NOT NULL DEFAULT '0',
  `dragon_ball_2` int(11) NOT NULL DEFAULT '0',
  `dragon_ball_3` int(11) NOT NULL DEFAULT '0',
  `dragon_ball_4` int(11) NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_pos` (`user_id`,`pos`)
) ENGINE=InnoDB AUTO_INCREMENT=14635 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_dragon_ball`
--

DROP TABLE IF EXISTS `user_dragon_ball`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_dragon_ball` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL DEFAULT '0',
  `dragon_ball_id` int(11) NOT NULL DEFAULT '0',
  `level` tinyint(4) NOT NULL DEFAULT '1',
  `exp` int(11) NOT NULL DEFAULT '0',
  `user_card_id` int(11) NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `card_dragon_ball_idx` (`user_id`,`user_card_id`,`dragon_ball_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_dragon_ball_00`
--

DROP TABLE IF EXISTS `user_dragon_ball_00`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_dragon_ball_00` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL DEFAULT '0',
  `dragon_ball_id` int(11) NOT NULL DEFAULT '0',
  `level` tinyint(4) NOT NULL DEFAULT '1',
  `exp` int(11) NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id_idx` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_dragon_ball_01`
--

DROP TABLE IF EXISTS `user_dragon_ball_01`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_dragon_ball_01` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL DEFAULT '0',
  `dragon_ball_id` int(11) NOT NULL DEFAULT '0',
  `level` tinyint(4) NOT NULL DEFAULT '1',
  `exp` int(11) NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id_idx` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_dragon_ball_02`
--

DROP TABLE IF EXISTS `user_dragon_ball_02`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_dragon_ball_02` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL DEFAULT '0',
  `dragon_ball_id` int(11) NOT NULL DEFAULT '0',
  `level` tinyint(4) NOT NULL DEFAULT '1',
  `exp` int(11) NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id_idx` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_dragon_ball_03`
--

DROP TABLE IF EXISTS `user_dragon_ball_03`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_dragon_ball_03` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL DEFAULT '0',
  `dragon_ball_id` int(11) NOT NULL DEFAULT '0',
  `level` tinyint(4) NOT NULL DEFAULT '1',
  `exp` int(11) NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id_idx` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_dragon_ball_04`
--

DROP TABLE IF EXISTS `user_dragon_ball_04`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_dragon_ball_04` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL DEFAULT '0',
  `dragon_ball_id` int(11) NOT NULL DEFAULT '0',
  `level` tinyint(4) NOT NULL DEFAULT '1',
  `exp` int(11) NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id_idx` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_dragon_ball_05`
--

DROP TABLE IF EXISTS `user_dragon_ball_05`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_dragon_ball_05` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL DEFAULT '0',
  `dragon_ball_id` int(11) NOT NULL DEFAULT '0',
  `level` tinyint(4) NOT NULL DEFAULT '1',
  `exp` int(11) NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id_idx` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=55 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_dragon_ball_06`
--

DROP TABLE IF EXISTS `user_dragon_ball_06`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_dragon_ball_06` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL DEFAULT '0',
  `dragon_ball_id` int(11) NOT NULL DEFAULT '0',
  `level` tinyint(4) NOT NULL DEFAULT '1',
  `exp` int(11) NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id_idx` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_dragon_ball_07`
--

DROP TABLE IF EXISTS `user_dragon_ball_07`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_dragon_ball_07` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL DEFAULT '0',
  `dragon_ball_id` int(11) NOT NULL DEFAULT '0',
  `level` tinyint(4) NOT NULL DEFAULT '1',
  `exp` int(11) NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id_idx` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_dragon_ball_08`
--

DROP TABLE IF EXISTS `user_dragon_ball_08`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_dragon_ball_08` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL DEFAULT '0',
  `dragon_ball_id` int(11) NOT NULL DEFAULT '0',
  `level` tinyint(4) NOT NULL DEFAULT '1',
  `exp` int(11) NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id_idx` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_dragon_ball_09`
--

DROP TABLE IF EXISTS `user_dragon_ball_09`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_dragon_ball_09` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL DEFAULT '0',
  `dragon_ball_id` int(11) NOT NULL DEFAULT '0',
  `level` tinyint(4) NOT NULL DEFAULT '1',
  `exp` int(11) NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id_idx` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=69 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_dragon_ball_10`
--

DROP TABLE IF EXISTS `user_dragon_ball_10`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_dragon_ball_10` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL DEFAULT '0',
  `dragon_ball_id` int(11) NOT NULL DEFAULT '0',
  `level` tinyint(4) NOT NULL DEFAULT '1',
  `exp` int(11) NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id_idx` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=30 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_dragon_ball_11`
--

DROP TABLE IF EXISTS `user_dragon_ball_11`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_dragon_ball_11` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL DEFAULT '0',
  `dragon_ball_id` int(11) NOT NULL DEFAULT '0',
  `level` tinyint(4) NOT NULL DEFAULT '1',
  `exp` int(11) NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id_idx` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=99 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_dragon_ball_12`
--

DROP TABLE IF EXISTS `user_dragon_ball_12`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_dragon_ball_12` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL DEFAULT '0',
  `dragon_ball_id` int(11) NOT NULL DEFAULT '0',
  `level` tinyint(4) NOT NULL DEFAULT '1',
  `exp` int(11) NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id_idx` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_dragon_ball_13`
--

DROP TABLE IF EXISTS `user_dragon_ball_13`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_dragon_ball_13` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL DEFAULT '0',
  `dragon_ball_id` int(11) NOT NULL DEFAULT '0',
  `level` tinyint(4) NOT NULL DEFAULT '1',
  `exp` int(11) NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id_idx` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_dragon_ball_14`
--

DROP TABLE IF EXISTS `user_dragon_ball_14`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_dragon_ball_14` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL DEFAULT '0',
  `dragon_ball_id` int(11) NOT NULL DEFAULT '0',
  `level` tinyint(4) NOT NULL DEFAULT '1',
  `exp` int(11) NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id_idx` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_dragon_ball_15`
--

DROP TABLE IF EXISTS `user_dragon_ball_15`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_dragon_ball_15` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL DEFAULT '0',
  `dragon_ball_id` int(11) NOT NULL DEFAULT '0',
  `level` tinyint(4) NOT NULL DEFAULT '1',
  `exp` int(11) NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id_idx` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=62 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_dragon_ball_16`
--

DROP TABLE IF EXISTS `user_dragon_ball_16`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_dragon_ball_16` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL DEFAULT '0',
  `dragon_ball_id` int(11) NOT NULL DEFAULT '0',
  `level` tinyint(4) NOT NULL DEFAULT '1',
  `exp` int(11) NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id_idx` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_dragon_ball_17`
--

DROP TABLE IF EXISTS `user_dragon_ball_17`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_dragon_ball_17` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL DEFAULT '0',
  `dragon_ball_id` int(11) NOT NULL DEFAULT '0',
  `level` tinyint(4) NOT NULL DEFAULT '1',
  `exp` int(11) NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id_idx` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=142 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_dragon_ball_18`
--

DROP TABLE IF EXISTS `user_dragon_ball_18`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_dragon_ball_18` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL DEFAULT '0',
  `dragon_ball_id` int(11) NOT NULL DEFAULT '0',
  `level` tinyint(4) NOT NULL DEFAULT '1',
  `exp` int(11) NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id_idx` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_dragon_ball_19`
--

DROP TABLE IF EXISTS `user_dragon_ball_19`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_dragon_ball_19` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL DEFAULT '0',
  `dragon_ball_id` int(11) NOT NULL DEFAULT '0',
  `level` tinyint(4) NOT NULL DEFAULT '1',
  `exp` int(11) NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id_idx` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=51 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_dragon_ball_20`
--

DROP TABLE IF EXISTS `user_dragon_ball_20`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_dragon_ball_20` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL DEFAULT '0',
  `dragon_ball_id` int(11) NOT NULL DEFAULT '0',
  `level` tinyint(4) NOT NULL DEFAULT '1',
  `exp` int(11) NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id_idx` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=55 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_dragon_ball_21`
--

DROP TABLE IF EXISTS `user_dragon_ball_21`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_dragon_ball_21` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL DEFAULT '0',
  `dragon_ball_id` int(11) NOT NULL DEFAULT '0',
  `level` tinyint(4) NOT NULL DEFAULT '1',
  `exp` int(11) NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id_idx` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_dragon_ball_22`
--

DROP TABLE IF EXISTS `user_dragon_ball_22`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_dragon_ball_22` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL DEFAULT '0',
  `dragon_ball_id` int(11) NOT NULL DEFAULT '0',
  `level` tinyint(4) NOT NULL DEFAULT '1',
  `exp` int(11) NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id_idx` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_dragon_ball_23`
--

DROP TABLE IF EXISTS `user_dragon_ball_23`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_dragon_ball_23` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL DEFAULT '0',
  `dragon_ball_id` int(11) NOT NULL DEFAULT '0',
  `level` tinyint(4) NOT NULL DEFAULT '1',
  `exp` int(11) NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id_idx` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_dragon_ball_24`
--

DROP TABLE IF EXISTS `user_dragon_ball_24`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_dragon_ball_24` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL DEFAULT '0',
  `dragon_ball_id` int(11) NOT NULL DEFAULT '0',
  `level` tinyint(4) NOT NULL DEFAULT '1',
  `exp` int(11) NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id_idx` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_dragon_ball_25`
--

DROP TABLE IF EXISTS `user_dragon_ball_25`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_dragon_ball_25` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL DEFAULT '0',
  `dragon_ball_id` int(11) NOT NULL DEFAULT '0',
  `level` tinyint(4) NOT NULL DEFAULT '1',
  `exp` int(11) NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id_idx` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_dragon_ball_26`
--

DROP TABLE IF EXISTS `user_dragon_ball_26`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_dragon_ball_26` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL DEFAULT '0',
  `dragon_ball_id` int(11) NOT NULL DEFAULT '0',
  `level` tinyint(4) NOT NULL DEFAULT '1',
  `exp` int(11) NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id_idx` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_dragon_ball_27`
--

DROP TABLE IF EXISTS `user_dragon_ball_27`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_dragon_ball_27` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL DEFAULT '0',
  `dragon_ball_id` int(11) NOT NULL DEFAULT '0',
  `level` tinyint(4) NOT NULL DEFAULT '1',
  `exp` int(11) NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id_idx` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=29 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_dragon_ball_28`
--

DROP TABLE IF EXISTS `user_dragon_ball_28`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_dragon_ball_28` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL DEFAULT '0',
  `dragon_ball_id` int(11) NOT NULL DEFAULT '0',
  `level` tinyint(4) NOT NULL DEFAULT '1',
  `exp` int(11) NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id_idx` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=38 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_dragon_ball_29`
--

DROP TABLE IF EXISTS `user_dragon_ball_29`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_dragon_ball_29` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL DEFAULT '0',
  `dragon_ball_id` int(11) NOT NULL DEFAULT '0',
  `level` tinyint(4) NOT NULL DEFAULT '1',
  `exp` int(11) NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id_idx` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=23 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_dragon_ball_30`
--

DROP TABLE IF EXISTS `user_dragon_ball_30`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_dragon_ball_30` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL DEFAULT '0',
  `dragon_ball_id` int(11) NOT NULL DEFAULT '0',
  `level` tinyint(4) NOT NULL DEFAULT '1',
  `exp` int(11) NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id_idx` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=32 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_dragon_ball_31`
--

DROP TABLE IF EXISTS `user_dragon_ball_31`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_dragon_ball_31` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL DEFAULT '0',
  `dragon_ball_id` int(11) NOT NULL DEFAULT '0',
  `level` tinyint(4) NOT NULL DEFAULT '1',
  `exp` int(11) NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id_idx` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_dragon_ball_32`
--

DROP TABLE IF EXISTS `user_dragon_ball_32`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_dragon_ball_32` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL DEFAULT '0',
  `dragon_ball_id` int(11) NOT NULL DEFAULT '0',
  `level` tinyint(4) NOT NULL DEFAULT '1',
  `exp` int(11) NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id_idx` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=26 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_dragon_ball_33`
--

DROP TABLE IF EXISTS `user_dragon_ball_33`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_dragon_ball_33` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL DEFAULT '0',
  `dragon_ball_id` int(11) NOT NULL DEFAULT '0',
  `level` tinyint(4) NOT NULL DEFAULT '1',
  `exp` int(11) NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id_idx` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_dragon_ball_34`
--

DROP TABLE IF EXISTS `user_dragon_ball_34`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_dragon_ball_34` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL DEFAULT '0',
  `dragon_ball_id` int(11) NOT NULL DEFAULT '0',
  `level` tinyint(4) NOT NULL DEFAULT '1',
  `exp` int(11) NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id_idx` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_dragon_ball_35`
--

DROP TABLE IF EXISTS `user_dragon_ball_35`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_dragon_ball_35` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL DEFAULT '0',
  `dragon_ball_id` int(11) NOT NULL DEFAULT '0',
  `level` tinyint(4) NOT NULL DEFAULT '1',
  `exp` int(11) NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id_idx` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=18 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_dragon_ball_36`
--

DROP TABLE IF EXISTS `user_dragon_ball_36`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_dragon_ball_36` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL DEFAULT '0',
  `dragon_ball_id` int(11) NOT NULL DEFAULT '0',
  `level` tinyint(4) NOT NULL DEFAULT '1',
  `exp` int(11) NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id_idx` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_dragon_ball_37`
--

DROP TABLE IF EXISTS `user_dragon_ball_37`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_dragon_ball_37` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL DEFAULT '0',
  `dragon_ball_id` int(11) NOT NULL DEFAULT '0',
  `level` tinyint(4) NOT NULL DEFAULT '1',
  `exp` int(11) NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id_idx` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_dragon_ball_38`
--

DROP TABLE IF EXISTS `user_dragon_ball_38`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_dragon_ball_38` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL DEFAULT '0',
  `dragon_ball_id` int(11) NOT NULL DEFAULT '0',
  `level` tinyint(4) NOT NULL DEFAULT '1',
  `exp` int(11) NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id_idx` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=28 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_dragon_ball_39`
--

DROP TABLE IF EXISTS `user_dragon_ball_39`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_dragon_ball_39` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL DEFAULT '0',
  `dragon_ball_id` int(11) NOT NULL DEFAULT '0',
  `level` tinyint(4) NOT NULL DEFAULT '1',
  `exp` int(11) NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id_idx` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_dragon_ball_40`
--

DROP TABLE IF EXISTS `user_dragon_ball_40`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_dragon_ball_40` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL DEFAULT '0',
  `dragon_ball_id` int(11) NOT NULL DEFAULT '0',
  `level` tinyint(4) NOT NULL DEFAULT '1',
  `exp` int(11) NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id_idx` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_dragon_ball_41`
--

DROP TABLE IF EXISTS `user_dragon_ball_41`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_dragon_ball_41` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL DEFAULT '0',
  `dragon_ball_id` int(11) NOT NULL DEFAULT '0',
  `level` tinyint(4) NOT NULL DEFAULT '1',
  `exp` int(11) NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id_idx` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_dragon_ball_42`
--

DROP TABLE IF EXISTS `user_dragon_ball_42`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_dragon_ball_42` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL DEFAULT '0',
  `dragon_ball_id` int(11) NOT NULL DEFAULT '0',
  `level` tinyint(4) NOT NULL DEFAULT '1',
  `exp` int(11) NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id_idx` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_dragon_ball_43`
--

DROP TABLE IF EXISTS `user_dragon_ball_43`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_dragon_ball_43` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL DEFAULT '0',
  `dragon_ball_id` int(11) NOT NULL DEFAULT '0',
  `level` tinyint(4) NOT NULL DEFAULT '1',
  `exp` int(11) NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id_idx` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_dragon_ball_44`
--

DROP TABLE IF EXISTS `user_dragon_ball_44`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_dragon_ball_44` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL DEFAULT '0',
  `dragon_ball_id` int(11) NOT NULL DEFAULT '0',
  `level` tinyint(4) NOT NULL DEFAULT '1',
  `exp` int(11) NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id_idx` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_dragon_ball_45`
--

DROP TABLE IF EXISTS `user_dragon_ball_45`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_dragon_ball_45` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL DEFAULT '0',
  `dragon_ball_id` int(11) NOT NULL DEFAULT '0',
  `level` tinyint(4) NOT NULL DEFAULT '1',
  `exp` int(11) NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id_idx` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_dragon_ball_46`
--

DROP TABLE IF EXISTS `user_dragon_ball_46`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_dragon_ball_46` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL DEFAULT '0',
  `dragon_ball_id` int(11) NOT NULL DEFAULT '0',
  `level` tinyint(4) NOT NULL DEFAULT '1',
  `exp` int(11) NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id_idx` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_dragon_ball_47`
--

DROP TABLE IF EXISTS `user_dragon_ball_47`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_dragon_ball_47` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL DEFAULT '0',
  `dragon_ball_id` int(11) NOT NULL DEFAULT '0',
  `level` tinyint(4) NOT NULL DEFAULT '1',
  `exp` int(11) NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id_idx` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=147 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_dragon_ball_48`
--

DROP TABLE IF EXISTS `user_dragon_ball_48`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_dragon_ball_48` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL DEFAULT '0',
  `dragon_ball_id` int(11) NOT NULL DEFAULT '0',
  `level` tinyint(4) NOT NULL DEFAULT '1',
  `exp` int(11) NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id_idx` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=29 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_dragon_ball_49`
--

DROP TABLE IF EXISTS `user_dragon_ball_49`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_dragon_ball_49` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL DEFAULT '0',
  `dragon_ball_id` int(11) NOT NULL DEFAULT '0',
  `level` tinyint(4) NOT NULL DEFAULT '1',
  `exp` int(11) NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id_idx` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=26 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_dragon_ball_50`
--

DROP TABLE IF EXISTS `user_dragon_ball_50`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_dragon_ball_50` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL DEFAULT '0',
  `dragon_ball_id` int(11) NOT NULL DEFAULT '0',
  `level` tinyint(4) NOT NULL DEFAULT '1',
  `exp` int(11) NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id_idx` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_dragon_ball_51`
--

DROP TABLE IF EXISTS `user_dragon_ball_51`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_dragon_ball_51` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL DEFAULT '0',
  `dragon_ball_id` int(11) NOT NULL DEFAULT '0',
  `level` tinyint(4) NOT NULL DEFAULT '1',
  `exp` int(11) NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id_idx` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_dragon_ball_52`
--

DROP TABLE IF EXISTS `user_dragon_ball_52`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_dragon_ball_52` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL DEFAULT '0',
  `dragon_ball_id` int(11) NOT NULL DEFAULT '0',
  `level` tinyint(4) NOT NULL DEFAULT '1',
  `exp` int(11) NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id_idx` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_dragon_ball_53`
--

DROP TABLE IF EXISTS `user_dragon_ball_53`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_dragon_ball_53` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL DEFAULT '0',
  `dragon_ball_id` int(11) NOT NULL DEFAULT '0',
  `level` tinyint(4) NOT NULL DEFAULT '1',
  `exp` int(11) NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id_idx` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=32 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_dragon_ball_54`
--

DROP TABLE IF EXISTS `user_dragon_ball_54`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_dragon_ball_54` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL DEFAULT '0',
  `dragon_ball_id` int(11) NOT NULL DEFAULT '0',
  `level` tinyint(4) NOT NULL DEFAULT '1',
  `exp` int(11) NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id_idx` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_dragon_ball_55`
--

DROP TABLE IF EXISTS `user_dragon_ball_55`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_dragon_ball_55` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL DEFAULT '0',
  `dragon_ball_id` int(11) NOT NULL DEFAULT '0',
  `level` tinyint(4) NOT NULL DEFAULT '1',
  `exp` int(11) NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id_idx` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=35 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_dragon_ball_56`
--

DROP TABLE IF EXISTS `user_dragon_ball_56`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_dragon_ball_56` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL DEFAULT '0',
  `dragon_ball_id` int(11) NOT NULL DEFAULT '0',
  `level` tinyint(4) NOT NULL DEFAULT '1',
  `exp` int(11) NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id_idx` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_dragon_ball_57`
--

DROP TABLE IF EXISTS `user_dragon_ball_57`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_dragon_ball_57` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL DEFAULT '0',
  `dragon_ball_id` int(11) NOT NULL DEFAULT '0',
  `level` tinyint(4) NOT NULL DEFAULT '1',
  `exp` int(11) NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id_idx` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=95 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_dragon_ball_58`
--

DROP TABLE IF EXISTS `user_dragon_ball_58`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_dragon_ball_58` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL DEFAULT '0',
  `dragon_ball_id` int(11) NOT NULL DEFAULT '0',
  `level` tinyint(4) NOT NULL DEFAULT '1',
  `exp` int(11) NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id_idx` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_dragon_ball_59`
--

DROP TABLE IF EXISTS `user_dragon_ball_59`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_dragon_ball_59` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL DEFAULT '0',
  `dragon_ball_id` int(11) NOT NULL DEFAULT '0',
  `level` tinyint(4) NOT NULL DEFAULT '1',
  `exp` int(11) NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id_idx` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_dragon_ball_60`
--

DROP TABLE IF EXISTS `user_dragon_ball_60`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_dragon_ball_60` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL DEFAULT '0',
  `dragon_ball_id` int(11) NOT NULL DEFAULT '0',
  `level` tinyint(4) NOT NULL DEFAULT '1',
  `exp` int(11) NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id_idx` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_dragon_ball_61`
--

DROP TABLE IF EXISTS `user_dragon_ball_61`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_dragon_ball_61` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL DEFAULT '0',
  `dragon_ball_id` int(11) NOT NULL DEFAULT '0',
  `level` tinyint(4) NOT NULL DEFAULT '1',
  `exp` int(11) NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id_idx` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=26 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_dragon_ball_62`
--

DROP TABLE IF EXISTS `user_dragon_ball_62`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_dragon_ball_62` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL DEFAULT '0',
  `dragon_ball_id` int(11) NOT NULL DEFAULT '0',
  `level` tinyint(4) NOT NULL DEFAULT '1',
  `exp` int(11) NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id_idx` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_dragon_ball_63`
--

DROP TABLE IF EXISTS `user_dragon_ball_63`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_dragon_ball_63` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL DEFAULT '0',
  `dragon_ball_id` int(11) NOT NULL DEFAULT '0',
  `level` tinyint(4) NOT NULL DEFAULT '1',
  `exp` int(11) NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id_idx` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_dragon_ball_64`
--

DROP TABLE IF EXISTS `user_dragon_ball_64`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_dragon_ball_64` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL DEFAULT '0',
  `dragon_ball_id` int(11) NOT NULL DEFAULT '0',
  `level` tinyint(4) NOT NULL DEFAULT '1',
  `exp` int(11) NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id_idx` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_dragon_ball_65`
--

DROP TABLE IF EXISTS `user_dragon_ball_65`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_dragon_ball_65` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL DEFAULT '0',
  `dragon_ball_id` int(11) NOT NULL DEFAULT '0',
  `level` tinyint(4) NOT NULL DEFAULT '1',
  `exp` int(11) NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id_idx` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_dragon_ball_66`
--

DROP TABLE IF EXISTS `user_dragon_ball_66`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_dragon_ball_66` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL DEFAULT '0',
  `dragon_ball_id` int(11) NOT NULL DEFAULT '0',
  `level` tinyint(4) NOT NULL DEFAULT '1',
  `exp` int(11) NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id_idx` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_dragon_ball_67`
--

DROP TABLE IF EXISTS `user_dragon_ball_67`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_dragon_ball_67` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL DEFAULT '0',
  `dragon_ball_id` int(11) NOT NULL DEFAULT '0',
  `level` tinyint(4) NOT NULL DEFAULT '1',
  `exp` int(11) NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id_idx` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_dragon_ball_68`
--

DROP TABLE IF EXISTS `user_dragon_ball_68`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_dragon_ball_68` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL DEFAULT '0',
  `dragon_ball_id` int(11) NOT NULL DEFAULT '0',
  `level` tinyint(4) NOT NULL DEFAULT '1',
  `exp` int(11) NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id_idx` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_dragon_ball_69`
--

DROP TABLE IF EXISTS `user_dragon_ball_69`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_dragon_ball_69` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL DEFAULT '0',
  `dragon_ball_id` int(11) NOT NULL DEFAULT '0',
  `level` tinyint(4) NOT NULL DEFAULT '1',
  `exp` int(11) NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id_idx` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=91 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_dragon_ball_70`
--

DROP TABLE IF EXISTS `user_dragon_ball_70`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_dragon_ball_70` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL DEFAULT '0',
  `dragon_ball_id` int(11) NOT NULL DEFAULT '0',
  `level` tinyint(4) NOT NULL DEFAULT '1',
  `exp` int(11) NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id_idx` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_dragon_ball_71`
--

DROP TABLE IF EXISTS `user_dragon_ball_71`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_dragon_ball_71` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL DEFAULT '0',
  `dragon_ball_id` int(11) NOT NULL DEFAULT '0',
  `level` tinyint(4) NOT NULL DEFAULT '1',
  `exp` int(11) NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id_idx` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=164 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_dragon_ball_72`
--

DROP TABLE IF EXISTS `user_dragon_ball_72`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_dragon_ball_72` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL DEFAULT '0',
  `dragon_ball_id` int(11) NOT NULL DEFAULT '0',
  `level` tinyint(4) NOT NULL DEFAULT '1',
  `exp` int(11) NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id_idx` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_dragon_ball_73`
--

DROP TABLE IF EXISTS `user_dragon_ball_73`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_dragon_ball_73` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL DEFAULT '0',
  `dragon_ball_id` int(11) NOT NULL DEFAULT '0',
  `level` tinyint(4) NOT NULL DEFAULT '1',
  `exp` int(11) NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id_idx` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_dragon_ball_74`
--

DROP TABLE IF EXISTS `user_dragon_ball_74`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_dragon_ball_74` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL DEFAULT '0',
  `dragon_ball_id` int(11) NOT NULL DEFAULT '0',
  `level` tinyint(4) NOT NULL DEFAULT '1',
  `exp` int(11) NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id_idx` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=30 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_dragon_ball_75`
--

DROP TABLE IF EXISTS `user_dragon_ball_75`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_dragon_ball_75` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL DEFAULT '0',
  `dragon_ball_id` int(11) NOT NULL DEFAULT '0',
  `level` tinyint(4) NOT NULL DEFAULT '1',
  `exp` int(11) NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id_idx` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=35 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_dragon_ball_76`
--

DROP TABLE IF EXISTS `user_dragon_ball_76`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_dragon_ball_76` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL DEFAULT '0',
  `dragon_ball_id` int(11) NOT NULL DEFAULT '0',
  `level` tinyint(4) NOT NULL DEFAULT '1',
  `exp` int(11) NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id_idx` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=18 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_dragon_ball_77`
--

DROP TABLE IF EXISTS `user_dragon_ball_77`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_dragon_ball_77` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL DEFAULT '0',
  `dragon_ball_id` int(11) NOT NULL DEFAULT '0',
  `level` tinyint(4) NOT NULL DEFAULT '1',
  `exp` int(11) NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id_idx` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_dragon_ball_78`
--

DROP TABLE IF EXISTS `user_dragon_ball_78`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_dragon_ball_78` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL DEFAULT '0',
  `dragon_ball_id` int(11) NOT NULL DEFAULT '0',
  `level` tinyint(4) NOT NULL DEFAULT '1',
  `exp` int(11) NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id_idx` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=82 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_dragon_ball_79`
--

DROP TABLE IF EXISTS `user_dragon_ball_79`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_dragon_ball_79` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL DEFAULT '0',
  `dragon_ball_id` int(11) NOT NULL DEFAULT '0',
  `level` tinyint(4) NOT NULL DEFAULT '1',
  `exp` int(11) NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id_idx` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_dragon_ball_80`
--

DROP TABLE IF EXISTS `user_dragon_ball_80`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_dragon_ball_80` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL DEFAULT '0',
  `dragon_ball_id` int(11) NOT NULL DEFAULT '0',
  `level` tinyint(4) NOT NULL DEFAULT '1',
  `exp` int(11) NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id_idx` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_dragon_ball_81`
--

DROP TABLE IF EXISTS `user_dragon_ball_81`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_dragon_ball_81` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL DEFAULT '0',
  `dragon_ball_id` int(11) NOT NULL DEFAULT '0',
  `level` tinyint(4) NOT NULL DEFAULT '1',
  `exp` int(11) NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id_idx` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_dragon_ball_82`
--

DROP TABLE IF EXISTS `user_dragon_ball_82`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_dragon_ball_82` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL DEFAULT '0',
  `dragon_ball_id` int(11) NOT NULL DEFAULT '0',
  `level` tinyint(4) NOT NULL DEFAULT '1',
  `exp` int(11) NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id_idx` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=235 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_dragon_ball_83`
--

DROP TABLE IF EXISTS `user_dragon_ball_83`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_dragon_ball_83` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL DEFAULT '0',
  `dragon_ball_id` int(11) NOT NULL DEFAULT '0',
  `level` tinyint(4) NOT NULL DEFAULT '1',
  `exp` int(11) NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id_idx` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_dragon_ball_84`
--

DROP TABLE IF EXISTS `user_dragon_ball_84`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_dragon_ball_84` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL DEFAULT '0',
  `dragon_ball_id` int(11) NOT NULL DEFAULT '0',
  `level` tinyint(4) NOT NULL DEFAULT '1',
  `exp` int(11) NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id_idx` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=34 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_dragon_ball_85`
--

DROP TABLE IF EXISTS `user_dragon_ball_85`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_dragon_ball_85` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL DEFAULT '0',
  `dragon_ball_id` int(11) NOT NULL DEFAULT '0',
  `level` tinyint(4) NOT NULL DEFAULT '1',
  `exp` int(11) NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id_idx` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_dragon_ball_86`
--

DROP TABLE IF EXISTS `user_dragon_ball_86`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_dragon_ball_86` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL DEFAULT '0',
  `dragon_ball_id` int(11) NOT NULL DEFAULT '0',
  `level` tinyint(4) NOT NULL DEFAULT '1',
  `exp` int(11) NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id_idx` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=37 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_dragon_ball_87`
--

DROP TABLE IF EXISTS `user_dragon_ball_87`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_dragon_ball_87` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL DEFAULT '0',
  `dragon_ball_id` int(11) NOT NULL DEFAULT '0',
  `level` tinyint(4) NOT NULL DEFAULT '1',
  `exp` int(11) NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id_idx` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=117 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_dragon_ball_88`
--

DROP TABLE IF EXISTS `user_dragon_ball_88`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_dragon_ball_88` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL DEFAULT '0',
  `dragon_ball_id` int(11) NOT NULL DEFAULT '0',
  `level` tinyint(4) NOT NULL DEFAULT '1',
  `exp` int(11) NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id_idx` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_dragon_ball_89`
--

DROP TABLE IF EXISTS `user_dragon_ball_89`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_dragon_ball_89` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL DEFAULT '0',
  `dragon_ball_id` int(11) NOT NULL DEFAULT '0',
  `level` tinyint(4) NOT NULL DEFAULT '1',
  `exp` int(11) NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id_idx` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=58 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_dragon_ball_90`
--

DROP TABLE IF EXISTS `user_dragon_ball_90`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_dragon_ball_90` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL DEFAULT '0',
  `dragon_ball_id` int(11) NOT NULL DEFAULT '0',
  `level` tinyint(4) NOT NULL DEFAULT '1',
  `exp` int(11) NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id_idx` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_dragon_ball_91`
--

DROP TABLE IF EXISTS `user_dragon_ball_91`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_dragon_ball_91` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL DEFAULT '0',
  `dragon_ball_id` int(11) NOT NULL DEFAULT '0',
  `level` tinyint(4) NOT NULL DEFAULT '1',
  `exp` int(11) NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id_idx` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=112 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_dragon_ball_92`
--

DROP TABLE IF EXISTS `user_dragon_ball_92`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_dragon_ball_92` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL DEFAULT '0',
  `dragon_ball_id` int(11) NOT NULL DEFAULT '0',
  `level` tinyint(4) NOT NULL DEFAULT '1',
  `exp` int(11) NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id_idx` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_dragon_ball_93`
--

DROP TABLE IF EXISTS `user_dragon_ball_93`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_dragon_ball_93` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL DEFAULT '0',
  `dragon_ball_id` int(11) NOT NULL DEFAULT '0',
  `level` tinyint(4) NOT NULL DEFAULT '1',
  `exp` int(11) NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id_idx` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_dragon_ball_94`
--

DROP TABLE IF EXISTS `user_dragon_ball_94`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_dragon_ball_94` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL DEFAULT '0',
  `dragon_ball_id` int(11) NOT NULL DEFAULT '0',
  `level` tinyint(4) NOT NULL DEFAULT '1',
  `exp` int(11) NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id_idx` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=78 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_dragon_ball_95`
--

DROP TABLE IF EXISTS `user_dragon_ball_95`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_dragon_ball_95` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL DEFAULT '0',
  `dragon_ball_id` int(11) NOT NULL DEFAULT '0',
  `level` tinyint(4) NOT NULL DEFAULT '1',
  `exp` int(11) NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id_idx` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_dragon_ball_96`
--

DROP TABLE IF EXISTS `user_dragon_ball_96`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_dragon_ball_96` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL DEFAULT '0',
  `dragon_ball_id` int(11) NOT NULL DEFAULT '0',
  `level` tinyint(4) NOT NULL DEFAULT '1',
  `exp` int(11) NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id_idx` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_dragon_ball_97`
--

DROP TABLE IF EXISTS `user_dragon_ball_97`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_dragon_ball_97` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL DEFAULT '0',
  `dragon_ball_id` int(11) NOT NULL DEFAULT '0',
  `level` tinyint(4) NOT NULL DEFAULT '1',
  `exp` int(11) NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id_idx` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_dragon_ball_98`
--

DROP TABLE IF EXISTS `user_dragon_ball_98`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_dragon_ball_98` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL DEFAULT '0',
  `dragon_ball_id` int(11) NOT NULL DEFAULT '0',
  `level` tinyint(4) NOT NULL DEFAULT '1',
  `exp` int(11) NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id_idx` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_dragon_ball_99`
--

DROP TABLE IF EXISTS `user_dragon_ball_99`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_dragon_ball_99` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL DEFAULT '0',
  `dragon_ball_id` int(11) NOT NULL DEFAULT '0',
  `level` tinyint(4) NOT NULL DEFAULT '1',
  `exp` int(11) NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id_idx` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=20 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_elite_mission_00`
--

DROP TABLE IF EXISTS `user_elite_mission_00`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_elite_mission_00` (
  `role_id` bigint(20) unsigned NOT NULL,
  `section_id` int(10) unsigned NOT NULL,
  `best_point` tinyint(4) DEFAULT NULL,
  `nattempt` int(10) unsigned NOT NULL DEFAULT '0',
  `npass` int(10) unsigned NOT NULL DEFAULT '0',
  `nfail` int(10) unsigned NOT NULL DEFAULT '0',
  `nwipe` int(10) unsigned NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime DEFAULT NULL,
  UNIQUE KEY `idx_rolesection` (`role_id`,`section_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_elite_mission_01`
--

DROP TABLE IF EXISTS `user_elite_mission_01`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_elite_mission_01` (
  `role_id` bigint(20) unsigned NOT NULL,
  `section_id` int(10) unsigned NOT NULL,
  `best_point` tinyint(4) DEFAULT NULL,
  `nattempt` int(10) unsigned NOT NULL DEFAULT '0',
  `npass` int(10) unsigned NOT NULL DEFAULT '0',
  `nfail` int(10) unsigned NOT NULL DEFAULT '0',
  `nwipe` int(10) unsigned NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime DEFAULT NULL,
  UNIQUE KEY `idx_rolesection` (`role_id`,`section_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_elite_mission_02`
--

DROP TABLE IF EXISTS `user_elite_mission_02`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_elite_mission_02` (
  `role_id` bigint(20) unsigned NOT NULL,
  `section_id` int(10) unsigned NOT NULL,
  `best_point` tinyint(4) DEFAULT NULL,
  `nattempt` int(10) unsigned NOT NULL DEFAULT '0',
  `npass` int(10) unsigned NOT NULL DEFAULT '0',
  `nfail` int(10) unsigned NOT NULL DEFAULT '0',
  `nwipe` int(10) unsigned NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime DEFAULT NULL,
  UNIQUE KEY `idx_rolesection` (`role_id`,`section_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_elite_mission_03`
--

DROP TABLE IF EXISTS `user_elite_mission_03`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_elite_mission_03` (
  `role_id` bigint(20) unsigned NOT NULL,
  `section_id` int(10) unsigned NOT NULL,
  `best_point` tinyint(4) DEFAULT NULL,
  `nattempt` int(10) unsigned NOT NULL DEFAULT '0',
  `npass` int(10) unsigned NOT NULL DEFAULT '0',
  `nfail` int(10) unsigned NOT NULL DEFAULT '0',
  `nwipe` int(10) unsigned NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime DEFAULT NULL,
  UNIQUE KEY `idx_rolesection` (`role_id`,`section_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_elite_mission_04`
--

DROP TABLE IF EXISTS `user_elite_mission_04`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_elite_mission_04` (
  `role_id` bigint(20) unsigned NOT NULL,
  `section_id` int(10) unsigned NOT NULL,
  `best_point` tinyint(4) DEFAULT NULL,
  `nattempt` int(10) unsigned NOT NULL DEFAULT '0',
  `npass` int(10) unsigned NOT NULL DEFAULT '0',
  `nfail` int(10) unsigned NOT NULL DEFAULT '0',
  `nwipe` int(10) unsigned NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime DEFAULT NULL,
  UNIQUE KEY `idx_rolesection` (`role_id`,`section_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_elite_mission_05`
--

DROP TABLE IF EXISTS `user_elite_mission_05`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_elite_mission_05` (
  `role_id` bigint(20) unsigned NOT NULL,
  `section_id` int(10) unsigned NOT NULL,
  `best_point` tinyint(4) DEFAULT NULL,
  `nattempt` int(10) unsigned NOT NULL DEFAULT '0',
  `npass` int(10) unsigned NOT NULL DEFAULT '0',
  `nfail` int(10) unsigned NOT NULL DEFAULT '0',
  `nwipe` int(10) unsigned NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime DEFAULT NULL,
  UNIQUE KEY `idx_rolesection` (`role_id`,`section_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_elite_mission_06`
--

DROP TABLE IF EXISTS `user_elite_mission_06`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_elite_mission_06` (
  `role_id` bigint(20) unsigned NOT NULL,
  `section_id` int(10) unsigned NOT NULL,
  `best_point` tinyint(4) DEFAULT NULL,
  `nattempt` int(10) unsigned NOT NULL DEFAULT '0',
  `npass` int(10) unsigned NOT NULL DEFAULT '0',
  `nfail` int(10) unsigned NOT NULL DEFAULT '0',
  `nwipe` int(10) unsigned NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime DEFAULT NULL,
  UNIQUE KEY `idx_rolesection` (`role_id`,`section_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_elite_mission_07`
--

DROP TABLE IF EXISTS `user_elite_mission_07`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_elite_mission_07` (
  `role_id` bigint(20) unsigned NOT NULL,
  `section_id` int(10) unsigned NOT NULL,
  `best_point` tinyint(4) DEFAULT NULL,
  `nattempt` int(10) unsigned NOT NULL DEFAULT '0',
  `npass` int(10) unsigned NOT NULL DEFAULT '0',
  `nfail` int(10) unsigned NOT NULL DEFAULT '0',
  `nwipe` int(10) unsigned NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime DEFAULT NULL,
  UNIQUE KEY `idx_rolesection` (`role_id`,`section_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_elite_mission_08`
--

DROP TABLE IF EXISTS `user_elite_mission_08`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_elite_mission_08` (
  `role_id` bigint(20) unsigned NOT NULL,
  `section_id` int(10) unsigned NOT NULL,
  `best_point` tinyint(4) DEFAULT NULL,
  `nattempt` int(10) unsigned NOT NULL DEFAULT '0',
  `npass` int(10) unsigned NOT NULL DEFAULT '0',
  `nfail` int(10) unsigned NOT NULL DEFAULT '0',
  `nwipe` int(10) unsigned NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime DEFAULT NULL,
  UNIQUE KEY `idx_rolesection` (`role_id`,`section_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_elite_mission_09`
--

DROP TABLE IF EXISTS `user_elite_mission_09`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_elite_mission_09` (
  `role_id` bigint(20) unsigned NOT NULL,
  `section_id` int(10) unsigned NOT NULL,
  `best_point` tinyint(4) DEFAULT NULL,
  `nattempt` int(10) unsigned NOT NULL DEFAULT '0',
  `npass` int(10) unsigned NOT NULL DEFAULT '0',
  `nfail` int(10) unsigned NOT NULL DEFAULT '0',
  `nwipe` int(10) unsigned NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime DEFAULT NULL,
  UNIQUE KEY `idx_rolesection` (`role_id`,`section_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_elite_mission_10`
--

DROP TABLE IF EXISTS `user_elite_mission_10`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_elite_mission_10` (
  `role_id` bigint(20) unsigned NOT NULL,
  `section_id` int(10) unsigned NOT NULL,
  `best_point` tinyint(4) DEFAULT NULL,
  `nattempt` int(10) unsigned NOT NULL DEFAULT '0',
  `npass` int(10) unsigned NOT NULL DEFAULT '0',
  `nfail` int(10) unsigned NOT NULL DEFAULT '0',
  `nwipe` int(10) unsigned NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime DEFAULT NULL,
  UNIQUE KEY `idx_rolesection` (`role_id`,`section_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_elite_mission_11`
--

DROP TABLE IF EXISTS `user_elite_mission_11`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_elite_mission_11` (
  `role_id` bigint(20) unsigned NOT NULL,
  `section_id` int(10) unsigned NOT NULL,
  `best_point` tinyint(4) DEFAULT NULL,
  `nattempt` int(10) unsigned NOT NULL DEFAULT '0',
  `npass` int(10) unsigned NOT NULL DEFAULT '0',
  `nfail` int(10) unsigned NOT NULL DEFAULT '0',
  `nwipe` int(10) unsigned NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime DEFAULT NULL,
  UNIQUE KEY `idx_rolesection` (`role_id`,`section_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_elite_mission_12`
--

DROP TABLE IF EXISTS `user_elite_mission_12`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_elite_mission_12` (
  `role_id` bigint(20) unsigned NOT NULL,
  `section_id` int(10) unsigned NOT NULL,
  `best_point` tinyint(4) DEFAULT NULL,
  `nattempt` int(10) unsigned NOT NULL DEFAULT '0',
  `npass` int(10) unsigned NOT NULL DEFAULT '0',
  `nfail` int(10) unsigned NOT NULL DEFAULT '0',
  `nwipe` int(10) unsigned NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime DEFAULT NULL,
  UNIQUE KEY `idx_rolesection` (`role_id`,`section_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_elite_mission_13`
--

DROP TABLE IF EXISTS `user_elite_mission_13`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_elite_mission_13` (
  `role_id` bigint(20) unsigned NOT NULL,
  `section_id` int(10) unsigned NOT NULL,
  `best_point` tinyint(4) DEFAULT NULL,
  `nattempt` int(10) unsigned NOT NULL DEFAULT '0',
  `npass` int(10) unsigned NOT NULL DEFAULT '0',
  `nfail` int(10) unsigned NOT NULL DEFAULT '0',
  `nwipe` int(10) unsigned NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime DEFAULT NULL,
  UNIQUE KEY `idx_rolesection` (`role_id`,`section_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_elite_mission_14`
--

DROP TABLE IF EXISTS `user_elite_mission_14`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_elite_mission_14` (
  `role_id` bigint(20) unsigned NOT NULL,
  `section_id` int(10) unsigned NOT NULL,
  `best_point` tinyint(4) DEFAULT NULL,
  `nattempt` int(10) unsigned NOT NULL DEFAULT '0',
  `npass` int(10) unsigned NOT NULL DEFAULT '0',
  `nfail` int(10) unsigned NOT NULL DEFAULT '0',
  `nwipe` int(10) unsigned NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime DEFAULT NULL,
  UNIQUE KEY `idx_rolesection` (`role_id`,`section_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_elite_mission_15`
--

DROP TABLE IF EXISTS `user_elite_mission_15`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_elite_mission_15` (
  `role_id` bigint(20) unsigned NOT NULL,
  `section_id` int(10) unsigned NOT NULL,
  `best_point` tinyint(4) DEFAULT NULL,
  `nattempt` int(10) unsigned NOT NULL DEFAULT '0',
  `npass` int(10) unsigned NOT NULL DEFAULT '0',
  `nfail` int(10) unsigned NOT NULL DEFAULT '0',
  `nwipe` int(10) unsigned NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime DEFAULT NULL,
  UNIQUE KEY `idx_rolesection` (`role_id`,`section_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_elite_mission_16`
--

DROP TABLE IF EXISTS `user_elite_mission_16`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_elite_mission_16` (
  `role_id` bigint(20) unsigned NOT NULL,
  `section_id` int(10) unsigned NOT NULL,
  `best_point` tinyint(4) DEFAULT NULL,
  `nattempt` int(10) unsigned NOT NULL DEFAULT '0',
  `npass` int(10) unsigned NOT NULL DEFAULT '0',
  `nfail` int(10) unsigned NOT NULL DEFAULT '0',
  `nwipe` int(10) unsigned NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime DEFAULT NULL,
  UNIQUE KEY `idx_rolesection` (`role_id`,`section_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_elite_mission_17`
--

DROP TABLE IF EXISTS `user_elite_mission_17`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_elite_mission_17` (
  `role_id` bigint(20) unsigned NOT NULL,
  `section_id` int(10) unsigned NOT NULL,
  `best_point` tinyint(4) DEFAULT NULL,
  `nattempt` int(10) unsigned NOT NULL DEFAULT '0',
  `npass` int(10) unsigned NOT NULL DEFAULT '0',
  `nfail` int(10) unsigned NOT NULL DEFAULT '0',
  `nwipe` int(10) unsigned NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime DEFAULT NULL,
  UNIQUE KEY `idx_rolesection` (`role_id`,`section_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_elite_mission_18`
--

DROP TABLE IF EXISTS `user_elite_mission_18`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_elite_mission_18` (
  `role_id` bigint(20) unsigned NOT NULL,
  `section_id` int(10) unsigned NOT NULL,
  `best_point` tinyint(4) DEFAULT NULL,
  `nattempt` int(10) unsigned NOT NULL DEFAULT '0',
  `npass` int(10) unsigned NOT NULL DEFAULT '0',
  `nfail` int(10) unsigned NOT NULL DEFAULT '0',
  `nwipe` int(10) unsigned NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime DEFAULT NULL,
  UNIQUE KEY `idx_rolesection` (`role_id`,`section_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_elite_mission_19`
--

DROP TABLE IF EXISTS `user_elite_mission_19`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_elite_mission_19` (
  `role_id` bigint(20) unsigned NOT NULL,
  `section_id` int(10) unsigned NOT NULL,
  `best_point` tinyint(4) DEFAULT NULL,
  `nattempt` int(10) unsigned NOT NULL DEFAULT '0',
  `npass` int(10) unsigned NOT NULL DEFAULT '0',
  `nfail` int(10) unsigned NOT NULL DEFAULT '0',
  `nwipe` int(10) unsigned NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime DEFAULT NULL,
  UNIQUE KEY `idx_rolesection` (`role_id`,`section_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_elite_mission_20`
--

DROP TABLE IF EXISTS `user_elite_mission_20`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_elite_mission_20` (
  `role_id` bigint(20) unsigned NOT NULL,
  `section_id` int(10) unsigned NOT NULL,
  `best_point` tinyint(4) DEFAULT NULL,
  `nattempt` int(10) unsigned NOT NULL DEFAULT '0',
  `npass` int(10) unsigned NOT NULL DEFAULT '0',
  `nfail` int(10) unsigned NOT NULL DEFAULT '0',
  `nwipe` int(10) unsigned NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime DEFAULT NULL,
  UNIQUE KEY `idx_rolesection` (`role_id`,`section_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_elite_mission_21`
--

DROP TABLE IF EXISTS `user_elite_mission_21`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_elite_mission_21` (
  `role_id` bigint(20) unsigned NOT NULL,
  `section_id` int(10) unsigned NOT NULL,
  `best_point` tinyint(4) DEFAULT NULL,
  `nattempt` int(10) unsigned NOT NULL DEFAULT '0',
  `npass` int(10) unsigned NOT NULL DEFAULT '0',
  `nfail` int(10) unsigned NOT NULL DEFAULT '0',
  `nwipe` int(10) unsigned NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime DEFAULT NULL,
  UNIQUE KEY `idx_rolesection` (`role_id`,`section_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_elite_mission_22`
--

DROP TABLE IF EXISTS `user_elite_mission_22`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_elite_mission_22` (
  `role_id` bigint(20) unsigned NOT NULL,
  `section_id` int(10) unsigned NOT NULL,
  `best_point` tinyint(4) DEFAULT NULL,
  `nattempt` int(10) unsigned NOT NULL DEFAULT '0',
  `npass` int(10) unsigned NOT NULL DEFAULT '0',
  `nfail` int(10) unsigned NOT NULL DEFAULT '0',
  `nwipe` int(10) unsigned NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime DEFAULT NULL,
  UNIQUE KEY `idx_rolesection` (`role_id`,`section_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_elite_mission_23`
--

DROP TABLE IF EXISTS `user_elite_mission_23`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_elite_mission_23` (
  `role_id` bigint(20) unsigned NOT NULL,
  `section_id` int(10) unsigned NOT NULL,
  `best_point` tinyint(4) DEFAULT NULL,
  `nattempt` int(10) unsigned NOT NULL DEFAULT '0',
  `npass` int(10) unsigned NOT NULL DEFAULT '0',
  `nfail` int(10) unsigned NOT NULL DEFAULT '0',
  `nwipe` int(10) unsigned NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime DEFAULT NULL,
  UNIQUE KEY `idx_rolesection` (`role_id`,`section_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_elite_mission_24`
--

DROP TABLE IF EXISTS `user_elite_mission_24`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_elite_mission_24` (
  `role_id` bigint(20) unsigned NOT NULL,
  `section_id` int(10) unsigned NOT NULL,
  `best_point` tinyint(4) DEFAULT NULL,
  `nattempt` int(10) unsigned NOT NULL DEFAULT '0',
  `npass` int(10) unsigned NOT NULL DEFAULT '0',
  `nfail` int(10) unsigned NOT NULL DEFAULT '0',
  `nwipe` int(10) unsigned NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime DEFAULT NULL,
  UNIQUE KEY `idx_rolesection` (`role_id`,`section_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_elite_mission_25`
--

DROP TABLE IF EXISTS `user_elite_mission_25`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_elite_mission_25` (
  `role_id` bigint(20) unsigned NOT NULL,
  `section_id` int(10) unsigned NOT NULL,
  `best_point` tinyint(4) DEFAULT NULL,
  `nattempt` int(10) unsigned NOT NULL DEFAULT '0',
  `npass` int(10) unsigned NOT NULL DEFAULT '0',
  `nfail` int(10) unsigned NOT NULL DEFAULT '0',
  `nwipe` int(10) unsigned NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime DEFAULT NULL,
  UNIQUE KEY `idx_rolesection` (`role_id`,`section_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_elite_mission_26`
--

DROP TABLE IF EXISTS `user_elite_mission_26`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_elite_mission_26` (
  `role_id` bigint(20) unsigned NOT NULL,
  `section_id` int(10) unsigned NOT NULL,
  `best_point` tinyint(4) DEFAULT NULL,
  `nattempt` int(10) unsigned NOT NULL DEFAULT '0',
  `npass` int(10) unsigned NOT NULL DEFAULT '0',
  `nfail` int(10) unsigned NOT NULL DEFAULT '0',
  `nwipe` int(10) unsigned NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime DEFAULT NULL,
  UNIQUE KEY `idx_rolesection` (`role_id`,`section_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_elite_mission_27`
--

DROP TABLE IF EXISTS `user_elite_mission_27`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_elite_mission_27` (
  `role_id` bigint(20) unsigned NOT NULL,
  `section_id` int(10) unsigned NOT NULL,
  `best_point` tinyint(4) DEFAULT NULL,
  `nattempt` int(10) unsigned NOT NULL DEFAULT '0',
  `npass` int(10) unsigned NOT NULL DEFAULT '0',
  `nfail` int(10) unsigned NOT NULL DEFAULT '0',
  `nwipe` int(10) unsigned NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime DEFAULT NULL,
  UNIQUE KEY `idx_rolesection` (`role_id`,`section_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_elite_mission_28`
--

DROP TABLE IF EXISTS `user_elite_mission_28`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_elite_mission_28` (
  `role_id` bigint(20) unsigned NOT NULL,
  `section_id` int(10) unsigned NOT NULL,
  `best_point` tinyint(4) DEFAULT NULL,
  `nattempt` int(10) unsigned NOT NULL DEFAULT '0',
  `npass` int(10) unsigned NOT NULL DEFAULT '0',
  `nfail` int(10) unsigned NOT NULL DEFAULT '0',
  `nwipe` int(10) unsigned NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime DEFAULT NULL,
  UNIQUE KEY `idx_rolesection` (`role_id`,`section_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_elite_mission_29`
--

DROP TABLE IF EXISTS `user_elite_mission_29`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_elite_mission_29` (
  `role_id` bigint(20) unsigned NOT NULL,
  `section_id` int(10) unsigned NOT NULL,
  `best_point` tinyint(4) DEFAULT NULL,
  `nattempt` int(10) unsigned NOT NULL DEFAULT '0',
  `npass` int(10) unsigned NOT NULL DEFAULT '0',
  `nfail` int(10) unsigned NOT NULL DEFAULT '0',
  `nwipe` int(10) unsigned NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime DEFAULT NULL,
  UNIQUE KEY `idx_rolesection` (`role_id`,`section_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_elite_mission_30`
--

DROP TABLE IF EXISTS `user_elite_mission_30`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_elite_mission_30` (
  `role_id` bigint(20) unsigned NOT NULL,
  `section_id` int(10) unsigned NOT NULL,
  `best_point` tinyint(4) DEFAULT NULL,
  `nattempt` int(10) unsigned NOT NULL DEFAULT '0',
  `npass` int(10) unsigned NOT NULL DEFAULT '0',
  `nfail` int(10) unsigned NOT NULL DEFAULT '0',
  `nwipe` int(10) unsigned NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime DEFAULT NULL,
  UNIQUE KEY `idx_rolesection` (`role_id`,`section_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_elite_mission_31`
--

DROP TABLE IF EXISTS `user_elite_mission_31`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_elite_mission_31` (
  `role_id` bigint(20) unsigned NOT NULL,
  `section_id` int(10) unsigned NOT NULL,
  `best_point` tinyint(4) DEFAULT NULL,
  `nattempt` int(10) unsigned NOT NULL DEFAULT '0',
  `npass` int(10) unsigned NOT NULL DEFAULT '0',
  `nfail` int(10) unsigned NOT NULL DEFAULT '0',
  `nwipe` int(10) unsigned NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime DEFAULT NULL,
  UNIQUE KEY `idx_rolesection` (`role_id`,`section_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_elite_mission_32`
--

DROP TABLE IF EXISTS `user_elite_mission_32`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_elite_mission_32` (
  `role_id` bigint(20) unsigned NOT NULL,
  `section_id` int(10) unsigned NOT NULL,
  `best_point` tinyint(4) DEFAULT NULL,
  `nattempt` int(10) unsigned NOT NULL DEFAULT '0',
  `npass` int(10) unsigned NOT NULL DEFAULT '0',
  `nfail` int(10) unsigned NOT NULL DEFAULT '0',
  `nwipe` int(10) unsigned NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime DEFAULT NULL,
  UNIQUE KEY `idx_rolesection` (`role_id`,`section_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_elite_mission_33`
--

DROP TABLE IF EXISTS `user_elite_mission_33`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_elite_mission_33` (
  `role_id` bigint(20) unsigned NOT NULL,
  `section_id` int(10) unsigned NOT NULL,
  `best_point` tinyint(4) DEFAULT NULL,
  `nattempt` int(10) unsigned NOT NULL DEFAULT '0',
  `npass` int(10) unsigned NOT NULL DEFAULT '0',
  `nfail` int(10) unsigned NOT NULL DEFAULT '0',
  `nwipe` int(10) unsigned NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime DEFAULT NULL,
  UNIQUE KEY `idx_rolesection` (`role_id`,`section_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_elite_mission_34`
--

DROP TABLE IF EXISTS `user_elite_mission_34`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_elite_mission_34` (
  `role_id` bigint(20) unsigned NOT NULL,
  `section_id` int(10) unsigned NOT NULL,
  `best_point` tinyint(4) DEFAULT NULL,
  `nattempt` int(10) unsigned NOT NULL DEFAULT '0',
  `npass` int(10) unsigned NOT NULL DEFAULT '0',
  `nfail` int(10) unsigned NOT NULL DEFAULT '0',
  `nwipe` int(10) unsigned NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime DEFAULT NULL,
  UNIQUE KEY `idx_rolesection` (`role_id`,`section_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_elite_mission_35`
--

DROP TABLE IF EXISTS `user_elite_mission_35`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_elite_mission_35` (
  `role_id` bigint(20) unsigned NOT NULL,
  `section_id` int(10) unsigned NOT NULL,
  `best_point` tinyint(4) DEFAULT NULL,
  `nattempt` int(10) unsigned NOT NULL DEFAULT '0',
  `npass` int(10) unsigned NOT NULL DEFAULT '0',
  `nfail` int(10) unsigned NOT NULL DEFAULT '0',
  `nwipe` int(10) unsigned NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime DEFAULT NULL,
  UNIQUE KEY `idx_rolesection` (`role_id`,`section_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_elite_mission_36`
--

DROP TABLE IF EXISTS `user_elite_mission_36`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_elite_mission_36` (
  `role_id` bigint(20) unsigned NOT NULL,
  `section_id` int(10) unsigned NOT NULL,
  `best_point` tinyint(4) DEFAULT NULL,
  `nattempt` int(10) unsigned NOT NULL DEFAULT '0',
  `npass` int(10) unsigned NOT NULL DEFAULT '0',
  `nfail` int(10) unsigned NOT NULL DEFAULT '0',
  `nwipe` int(10) unsigned NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime DEFAULT NULL,
  UNIQUE KEY `idx_rolesection` (`role_id`,`section_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_elite_mission_37`
--

DROP TABLE IF EXISTS `user_elite_mission_37`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_elite_mission_37` (
  `role_id` bigint(20) unsigned NOT NULL,
  `section_id` int(10) unsigned NOT NULL,
  `best_point` tinyint(4) DEFAULT NULL,
  `nattempt` int(10) unsigned NOT NULL DEFAULT '0',
  `npass` int(10) unsigned NOT NULL DEFAULT '0',
  `nfail` int(10) unsigned NOT NULL DEFAULT '0',
  `nwipe` int(10) unsigned NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime DEFAULT NULL,
  UNIQUE KEY `idx_rolesection` (`role_id`,`section_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_elite_mission_38`
--

DROP TABLE IF EXISTS `user_elite_mission_38`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_elite_mission_38` (
  `role_id` bigint(20) unsigned NOT NULL,
  `section_id` int(10) unsigned NOT NULL,
  `best_point` tinyint(4) DEFAULT NULL,
  `nattempt` int(10) unsigned NOT NULL DEFAULT '0',
  `npass` int(10) unsigned NOT NULL DEFAULT '0',
  `nfail` int(10) unsigned NOT NULL DEFAULT '0',
  `nwipe` int(10) unsigned NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime DEFAULT NULL,
  UNIQUE KEY `idx_rolesection` (`role_id`,`section_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_elite_mission_39`
--

DROP TABLE IF EXISTS `user_elite_mission_39`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_elite_mission_39` (
  `role_id` bigint(20) unsigned NOT NULL,
  `section_id` int(10) unsigned NOT NULL,
  `best_point` tinyint(4) DEFAULT NULL,
  `nattempt` int(10) unsigned NOT NULL DEFAULT '0',
  `npass` int(10) unsigned NOT NULL DEFAULT '0',
  `nfail` int(10) unsigned NOT NULL DEFAULT '0',
  `nwipe` int(10) unsigned NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime DEFAULT NULL,
  UNIQUE KEY `idx_rolesection` (`role_id`,`section_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_elite_mission_40`
--

DROP TABLE IF EXISTS `user_elite_mission_40`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_elite_mission_40` (
  `role_id` bigint(20) unsigned NOT NULL,
  `section_id` int(10) unsigned NOT NULL,
  `best_point` tinyint(4) DEFAULT NULL,
  `nattempt` int(10) unsigned NOT NULL DEFAULT '0',
  `npass` int(10) unsigned NOT NULL DEFAULT '0',
  `nfail` int(10) unsigned NOT NULL DEFAULT '0',
  `nwipe` int(10) unsigned NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime DEFAULT NULL,
  UNIQUE KEY `idx_rolesection` (`role_id`,`section_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_elite_mission_41`
--

DROP TABLE IF EXISTS `user_elite_mission_41`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_elite_mission_41` (
  `role_id` bigint(20) unsigned NOT NULL,
  `section_id` int(10) unsigned NOT NULL,
  `best_point` tinyint(4) DEFAULT NULL,
  `nattempt` int(10) unsigned NOT NULL DEFAULT '0',
  `npass` int(10) unsigned NOT NULL DEFAULT '0',
  `nfail` int(10) unsigned NOT NULL DEFAULT '0',
  `nwipe` int(10) unsigned NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime DEFAULT NULL,
  UNIQUE KEY `idx_rolesection` (`role_id`,`section_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_elite_mission_42`
--

DROP TABLE IF EXISTS `user_elite_mission_42`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_elite_mission_42` (
  `role_id` bigint(20) unsigned NOT NULL,
  `section_id` int(10) unsigned NOT NULL,
  `best_point` tinyint(4) DEFAULT NULL,
  `nattempt` int(10) unsigned NOT NULL DEFAULT '0',
  `npass` int(10) unsigned NOT NULL DEFAULT '0',
  `nfail` int(10) unsigned NOT NULL DEFAULT '0',
  `nwipe` int(10) unsigned NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime DEFAULT NULL,
  UNIQUE KEY `idx_rolesection` (`role_id`,`section_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_elite_mission_43`
--

DROP TABLE IF EXISTS `user_elite_mission_43`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_elite_mission_43` (
  `role_id` bigint(20) unsigned NOT NULL,
  `section_id` int(10) unsigned NOT NULL,
  `best_point` tinyint(4) DEFAULT NULL,
  `nattempt` int(10) unsigned NOT NULL DEFAULT '0',
  `npass` int(10) unsigned NOT NULL DEFAULT '0',
  `nfail` int(10) unsigned NOT NULL DEFAULT '0',
  `nwipe` int(10) unsigned NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime DEFAULT NULL,
  UNIQUE KEY `idx_rolesection` (`role_id`,`section_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_elite_mission_44`
--

DROP TABLE IF EXISTS `user_elite_mission_44`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_elite_mission_44` (
  `role_id` bigint(20) unsigned NOT NULL,
  `section_id` int(10) unsigned NOT NULL,
  `best_point` tinyint(4) DEFAULT NULL,
  `nattempt` int(10) unsigned NOT NULL DEFAULT '0',
  `npass` int(10) unsigned NOT NULL DEFAULT '0',
  `nfail` int(10) unsigned NOT NULL DEFAULT '0',
  `nwipe` int(10) unsigned NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime DEFAULT NULL,
  UNIQUE KEY `idx_rolesection` (`role_id`,`section_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_elite_mission_45`
--

DROP TABLE IF EXISTS `user_elite_mission_45`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_elite_mission_45` (
  `role_id` bigint(20) unsigned NOT NULL,
  `section_id` int(10) unsigned NOT NULL,
  `best_point` tinyint(4) DEFAULT NULL,
  `nattempt` int(10) unsigned NOT NULL DEFAULT '0',
  `npass` int(10) unsigned NOT NULL DEFAULT '0',
  `nfail` int(10) unsigned NOT NULL DEFAULT '0',
  `nwipe` int(10) unsigned NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime DEFAULT NULL,
  UNIQUE KEY `idx_rolesection` (`role_id`,`section_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_elite_mission_46`
--

DROP TABLE IF EXISTS `user_elite_mission_46`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_elite_mission_46` (
  `role_id` bigint(20) unsigned NOT NULL,
  `section_id` int(10) unsigned NOT NULL,
  `best_point` tinyint(4) DEFAULT NULL,
  `nattempt` int(10) unsigned NOT NULL DEFAULT '0',
  `npass` int(10) unsigned NOT NULL DEFAULT '0',
  `nfail` int(10) unsigned NOT NULL DEFAULT '0',
  `nwipe` int(10) unsigned NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime DEFAULT NULL,
  UNIQUE KEY `idx_rolesection` (`role_id`,`section_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_elite_mission_47`
--

DROP TABLE IF EXISTS `user_elite_mission_47`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_elite_mission_47` (
  `role_id` bigint(20) unsigned NOT NULL,
  `section_id` int(10) unsigned NOT NULL,
  `best_point` tinyint(4) DEFAULT NULL,
  `nattempt` int(10) unsigned NOT NULL DEFAULT '0',
  `npass` int(10) unsigned NOT NULL DEFAULT '0',
  `nfail` int(10) unsigned NOT NULL DEFAULT '0',
  `nwipe` int(10) unsigned NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime DEFAULT NULL,
  UNIQUE KEY `idx_rolesection` (`role_id`,`section_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_elite_mission_48`
--

DROP TABLE IF EXISTS `user_elite_mission_48`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_elite_mission_48` (
  `role_id` bigint(20) unsigned NOT NULL,
  `section_id` int(10) unsigned NOT NULL,
  `best_point` tinyint(4) DEFAULT NULL,
  `nattempt` int(10) unsigned NOT NULL DEFAULT '0',
  `npass` int(10) unsigned NOT NULL DEFAULT '0',
  `nfail` int(10) unsigned NOT NULL DEFAULT '0',
  `nwipe` int(10) unsigned NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime DEFAULT NULL,
  UNIQUE KEY `idx_rolesection` (`role_id`,`section_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_elite_mission_49`
--

DROP TABLE IF EXISTS `user_elite_mission_49`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_elite_mission_49` (
  `role_id` bigint(20) unsigned NOT NULL,
  `section_id` int(10) unsigned NOT NULL,
  `best_point` tinyint(4) DEFAULT NULL,
  `nattempt` int(10) unsigned NOT NULL DEFAULT '0',
  `npass` int(10) unsigned NOT NULL DEFAULT '0',
  `nfail` int(10) unsigned NOT NULL DEFAULT '0',
  `nwipe` int(10) unsigned NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime DEFAULT NULL,
  UNIQUE KEY `idx_rolesection` (`role_id`,`section_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_elite_mission_50`
--

DROP TABLE IF EXISTS `user_elite_mission_50`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_elite_mission_50` (
  `role_id` bigint(20) unsigned NOT NULL,
  `section_id` int(10) unsigned NOT NULL,
  `best_point` tinyint(4) DEFAULT NULL,
  `nattempt` int(10) unsigned NOT NULL DEFAULT '0',
  `npass` int(10) unsigned NOT NULL DEFAULT '0',
  `nfail` int(10) unsigned NOT NULL DEFAULT '0',
  `nwipe` int(10) unsigned NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime DEFAULT NULL,
  UNIQUE KEY `idx_rolesection` (`role_id`,`section_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_elite_mission_51`
--

DROP TABLE IF EXISTS `user_elite_mission_51`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_elite_mission_51` (
  `role_id` bigint(20) unsigned NOT NULL,
  `section_id` int(10) unsigned NOT NULL,
  `best_point` tinyint(4) DEFAULT NULL,
  `nattempt` int(10) unsigned NOT NULL DEFAULT '0',
  `npass` int(10) unsigned NOT NULL DEFAULT '0',
  `nfail` int(10) unsigned NOT NULL DEFAULT '0',
  `nwipe` int(10) unsigned NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime DEFAULT NULL,
  UNIQUE KEY `idx_rolesection` (`role_id`,`section_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_elite_mission_52`
--

DROP TABLE IF EXISTS `user_elite_mission_52`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_elite_mission_52` (
  `role_id` bigint(20) unsigned NOT NULL,
  `section_id` int(10) unsigned NOT NULL,
  `best_point` tinyint(4) DEFAULT NULL,
  `nattempt` int(10) unsigned NOT NULL DEFAULT '0',
  `npass` int(10) unsigned NOT NULL DEFAULT '0',
  `nfail` int(10) unsigned NOT NULL DEFAULT '0',
  `nwipe` int(10) unsigned NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime DEFAULT NULL,
  UNIQUE KEY `idx_rolesection` (`role_id`,`section_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_elite_mission_53`
--

DROP TABLE IF EXISTS `user_elite_mission_53`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_elite_mission_53` (
  `role_id` bigint(20) unsigned NOT NULL,
  `section_id` int(10) unsigned NOT NULL,
  `best_point` tinyint(4) DEFAULT NULL,
  `nattempt` int(10) unsigned NOT NULL DEFAULT '0',
  `npass` int(10) unsigned NOT NULL DEFAULT '0',
  `nfail` int(10) unsigned NOT NULL DEFAULT '0',
  `nwipe` int(10) unsigned NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime DEFAULT NULL,
  UNIQUE KEY `idx_rolesection` (`role_id`,`section_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_elite_mission_54`
--

DROP TABLE IF EXISTS `user_elite_mission_54`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_elite_mission_54` (
  `role_id` bigint(20) unsigned NOT NULL,
  `section_id` int(10) unsigned NOT NULL,
  `best_point` tinyint(4) DEFAULT NULL,
  `nattempt` int(10) unsigned NOT NULL DEFAULT '0',
  `npass` int(10) unsigned NOT NULL DEFAULT '0',
  `nfail` int(10) unsigned NOT NULL DEFAULT '0',
  `nwipe` int(10) unsigned NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime DEFAULT NULL,
  UNIQUE KEY `idx_rolesection` (`role_id`,`section_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_elite_mission_55`
--

DROP TABLE IF EXISTS `user_elite_mission_55`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_elite_mission_55` (
  `role_id` bigint(20) unsigned NOT NULL,
  `section_id` int(10) unsigned NOT NULL,
  `best_point` tinyint(4) DEFAULT NULL,
  `nattempt` int(10) unsigned NOT NULL DEFAULT '0',
  `npass` int(10) unsigned NOT NULL DEFAULT '0',
  `nfail` int(10) unsigned NOT NULL DEFAULT '0',
  `nwipe` int(10) unsigned NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime DEFAULT NULL,
  UNIQUE KEY `idx_rolesection` (`role_id`,`section_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_elite_mission_56`
--

DROP TABLE IF EXISTS `user_elite_mission_56`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_elite_mission_56` (
  `role_id` bigint(20) unsigned NOT NULL,
  `section_id` int(10) unsigned NOT NULL,
  `best_point` tinyint(4) DEFAULT NULL,
  `nattempt` int(10) unsigned NOT NULL DEFAULT '0',
  `npass` int(10) unsigned NOT NULL DEFAULT '0',
  `nfail` int(10) unsigned NOT NULL DEFAULT '0',
  `nwipe` int(10) unsigned NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime DEFAULT NULL,
  UNIQUE KEY `idx_rolesection` (`role_id`,`section_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_elite_mission_57`
--

DROP TABLE IF EXISTS `user_elite_mission_57`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_elite_mission_57` (
  `role_id` bigint(20) unsigned NOT NULL,
  `section_id` int(10) unsigned NOT NULL,
  `best_point` tinyint(4) DEFAULT NULL,
  `nattempt` int(10) unsigned NOT NULL DEFAULT '0',
  `npass` int(10) unsigned NOT NULL DEFAULT '0',
  `nfail` int(10) unsigned NOT NULL DEFAULT '0',
  `nwipe` int(10) unsigned NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime DEFAULT NULL,
  UNIQUE KEY `idx_rolesection` (`role_id`,`section_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_elite_mission_58`
--

DROP TABLE IF EXISTS `user_elite_mission_58`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_elite_mission_58` (
  `role_id` bigint(20) unsigned NOT NULL,
  `section_id` int(10) unsigned NOT NULL,
  `best_point` tinyint(4) DEFAULT NULL,
  `nattempt` int(10) unsigned NOT NULL DEFAULT '0',
  `npass` int(10) unsigned NOT NULL DEFAULT '0',
  `nfail` int(10) unsigned NOT NULL DEFAULT '0',
  `nwipe` int(10) unsigned NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime DEFAULT NULL,
  UNIQUE KEY `idx_rolesection` (`role_id`,`section_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_elite_mission_59`
--

DROP TABLE IF EXISTS `user_elite_mission_59`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_elite_mission_59` (
  `role_id` bigint(20) unsigned NOT NULL,
  `section_id` int(10) unsigned NOT NULL,
  `best_point` tinyint(4) DEFAULT NULL,
  `nattempt` int(10) unsigned NOT NULL DEFAULT '0',
  `npass` int(10) unsigned NOT NULL DEFAULT '0',
  `nfail` int(10) unsigned NOT NULL DEFAULT '0',
  `nwipe` int(10) unsigned NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime DEFAULT NULL,
  UNIQUE KEY `idx_rolesection` (`role_id`,`section_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_elite_mission_60`
--

DROP TABLE IF EXISTS `user_elite_mission_60`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_elite_mission_60` (
  `role_id` bigint(20) unsigned NOT NULL,
  `section_id` int(10) unsigned NOT NULL,
  `best_point` tinyint(4) DEFAULT NULL,
  `nattempt` int(10) unsigned NOT NULL DEFAULT '0',
  `npass` int(10) unsigned NOT NULL DEFAULT '0',
  `nfail` int(10) unsigned NOT NULL DEFAULT '0',
  `nwipe` int(10) unsigned NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime DEFAULT NULL,
  UNIQUE KEY `idx_rolesection` (`role_id`,`section_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_elite_mission_61`
--

DROP TABLE IF EXISTS `user_elite_mission_61`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_elite_mission_61` (
  `role_id` bigint(20) unsigned NOT NULL,
  `section_id` int(10) unsigned NOT NULL,
  `best_point` tinyint(4) DEFAULT NULL,
  `nattempt` int(10) unsigned NOT NULL DEFAULT '0',
  `npass` int(10) unsigned NOT NULL DEFAULT '0',
  `nfail` int(10) unsigned NOT NULL DEFAULT '0',
  `nwipe` int(10) unsigned NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime DEFAULT NULL,
  UNIQUE KEY `idx_rolesection` (`role_id`,`section_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_elite_mission_62`
--

DROP TABLE IF EXISTS `user_elite_mission_62`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_elite_mission_62` (
  `role_id` bigint(20) unsigned NOT NULL,
  `section_id` int(10) unsigned NOT NULL,
  `best_point` tinyint(4) DEFAULT NULL,
  `nattempt` int(10) unsigned NOT NULL DEFAULT '0',
  `npass` int(10) unsigned NOT NULL DEFAULT '0',
  `nfail` int(10) unsigned NOT NULL DEFAULT '0',
  `nwipe` int(10) unsigned NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime DEFAULT NULL,
  UNIQUE KEY `idx_rolesection` (`role_id`,`section_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_elite_mission_63`
--

DROP TABLE IF EXISTS `user_elite_mission_63`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_elite_mission_63` (
  `role_id` bigint(20) unsigned NOT NULL,
  `section_id` int(10) unsigned NOT NULL,
  `best_point` tinyint(4) DEFAULT NULL,
  `nattempt` int(10) unsigned NOT NULL DEFAULT '0',
  `npass` int(10) unsigned NOT NULL DEFAULT '0',
  `nfail` int(10) unsigned NOT NULL DEFAULT '0',
  `nwipe` int(10) unsigned NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime DEFAULT NULL,
  UNIQUE KEY `idx_rolesection` (`role_id`,`section_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_elite_mission_64`
--

DROP TABLE IF EXISTS `user_elite_mission_64`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_elite_mission_64` (
  `role_id` bigint(20) unsigned NOT NULL,
  `section_id` int(10) unsigned NOT NULL,
  `best_point` tinyint(4) DEFAULT NULL,
  `nattempt` int(10) unsigned NOT NULL DEFAULT '0',
  `npass` int(10) unsigned NOT NULL DEFAULT '0',
  `nfail` int(10) unsigned NOT NULL DEFAULT '0',
  `nwipe` int(10) unsigned NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime DEFAULT NULL,
  UNIQUE KEY `idx_rolesection` (`role_id`,`section_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_elite_mission_65`
--

DROP TABLE IF EXISTS `user_elite_mission_65`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_elite_mission_65` (
  `role_id` bigint(20) unsigned NOT NULL,
  `section_id` int(10) unsigned NOT NULL,
  `best_point` tinyint(4) DEFAULT NULL,
  `nattempt` int(10) unsigned NOT NULL DEFAULT '0',
  `npass` int(10) unsigned NOT NULL DEFAULT '0',
  `nfail` int(10) unsigned NOT NULL DEFAULT '0',
  `nwipe` int(10) unsigned NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime DEFAULT NULL,
  UNIQUE KEY `idx_rolesection` (`role_id`,`section_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_elite_mission_66`
--

DROP TABLE IF EXISTS `user_elite_mission_66`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_elite_mission_66` (
  `role_id` bigint(20) unsigned NOT NULL,
  `section_id` int(10) unsigned NOT NULL,
  `best_point` tinyint(4) DEFAULT NULL,
  `nattempt` int(10) unsigned NOT NULL DEFAULT '0',
  `npass` int(10) unsigned NOT NULL DEFAULT '0',
  `nfail` int(10) unsigned NOT NULL DEFAULT '0',
  `nwipe` int(10) unsigned NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime DEFAULT NULL,
  UNIQUE KEY `idx_rolesection` (`role_id`,`section_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_elite_mission_67`
--

DROP TABLE IF EXISTS `user_elite_mission_67`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_elite_mission_67` (
  `role_id` bigint(20) unsigned NOT NULL,
  `section_id` int(10) unsigned NOT NULL,
  `best_point` tinyint(4) DEFAULT NULL,
  `nattempt` int(10) unsigned NOT NULL DEFAULT '0',
  `npass` int(10) unsigned NOT NULL DEFAULT '0',
  `nfail` int(10) unsigned NOT NULL DEFAULT '0',
  `nwipe` int(10) unsigned NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime DEFAULT NULL,
  UNIQUE KEY `idx_rolesection` (`role_id`,`section_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_elite_mission_68`
--

DROP TABLE IF EXISTS `user_elite_mission_68`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_elite_mission_68` (
  `role_id` bigint(20) unsigned NOT NULL,
  `section_id` int(10) unsigned NOT NULL,
  `best_point` tinyint(4) DEFAULT NULL,
  `nattempt` int(10) unsigned NOT NULL DEFAULT '0',
  `npass` int(10) unsigned NOT NULL DEFAULT '0',
  `nfail` int(10) unsigned NOT NULL DEFAULT '0',
  `nwipe` int(10) unsigned NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime DEFAULT NULL,
  UNIQUE KEY `idx_rolesection` (`role_id`,`section_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_elite_mission_69`
--

DROP TABLE IF EXISTS `user_elite_mission_69`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_elite_mission_69` (
  `role_id` bigint(20) unsigned NOT NULL,
  `section_id` int(10) unsigned NOT NULL,
  `best_point` tinyint(4) DEFAULT NULL,
  `nattempt` int(10) unsigned NOT NULL DEFAULT '0',
  `npass` int(10) unsigned NOT NULL DEFAULT '0',
  `nfail` int(10) unsigned NOT NULL DEFAULT '0',
  `nwipe` int(10) unsigned NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime DEFAULT NULL,
  UNIQUE KEY `idx_rolesection` (`role_id`,`section_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_elite_mission_70`
--

DROP TABLE IF EXISTS `user_elite_mission_70`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_elite_mission_70` (
  `role_id` bigint(20) unsigned NOT NULL,
  `section_id` int(10) unsigned NOT NULL,
  `best_point` tinyint(4) DEFAULT NULL,
  `nattempt` int(10) unsigned NOT NULL DEFAULT '0',
  `npass` int(10) unsigned NOT NULL DEFAULT '0',
  `nfail` int(10) unsigned NOT NULL DEFAULT '0',
  `nwipe` int(10) unsigned NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime DEFAULT NULL,
  UNIQUE KEY `idx_rolesection` (`role_id`,`section_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_elite_mission_71`
--

DROP TABLE IF EXISTS `user_elite_mission_71`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_elite_mission_71` (
  `role_id` bigint(20) unsigned NOT NULL,
  `section_id` int(10) unsigned NOT NULL,
  `best_point` tinyint(4) DEFAULT NULL,
  `nattempt` int(10) unsigned NOT NULL DEFAULT '0',
  `npass` int(10) unsigned NOT NULL DEFAULT '0',
  `nfail` int(10) unsigned NOT NULL DEFAULT '0',
  `nwipe` int(10) unsigned NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime DEFAULT NULL,
  UNIQUE KEY `idx_rolesection` (`role_id`,`section_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_elite_mission_72`
--

DROP TABLE IF EXISTS `user_elite_mission_72`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_elite_mission_72` (
  `role_id` bigint(20) unsigned NOT NULL,
  `section_id` int(10) unsigned NOT NULL,
  `best_point` tinyint(4) DEFAULT NULL,
  `nattempt` int(10) unsigned NOT NULL DEFAULT '0',
  `npass` int(10) unsigned NOT NULL DEFAULT '0',
  `nfail` int(10) unsigned NOT NULL DEFAULT '0',
  `nwipe` int(10) unsigned NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime DEFAULT NULL,
  UNIQUE KEY `idx_rolesection` (`role_id`,`section_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_elite_mission_73`
--

DROP TABLE IF EXISTS `user_elite_mission_73`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_elite_mission_73` (
  `role_id` bigint(20) unsigned NOT NULL,
  `section_id` int(10) unsigned NOT NULL,
  `best_point` tinyint(4) DEFAULT NULL,
  `nattempt` int(10) unsigned NOT NULL DEFAULT '0',
  `npass` int(10) unsigned NOT NULL DEFAULT '0',
  `nfail` int(10) unsigned NOT NULL DEFAULT '0',
  `nwipe` int(10) unsigned NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime DEFAULT NULL,
  UNIQUE KEY `idx_rolesection` (`role_id`,`section_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_elite_mission_74`
--

DROP TABLE IF EXISTS `user_elite_mission_74`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_elite_mission_74` (
  `role_id` bigint(20) unsigned NOT NULL,
  `section_id` int(10) unsigned NOT NULL,
  `best_point` tinyint(4) DEFAULT NULL,
  `nattempt` int(10) unsigned NOT NULL DEFAULT '0',
  `npass` int(10) unsigned NOT NULL DEFAULT '0',
  `nfail` int(10) unsigned NOT NULL DEFAULT '0',
  `nwipe` int(10) unsigned NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime DEFAULT NULL,
  UNIQUE KEY `idx_rolesection` (`role_id`,`section_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_elite_mission_75`
--

DROP TABLE IF EXISTS `user_elite_mission_75`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_elite_mission_75` (
  `role_id` bigint(20) unsigned NOT NULL,
  `section_id` int(10) unsigned NOT NULL,
  `best_point` tinyint(4) DEFAULT NULL,
  `nattempt` int(10) unsigned NOT NULL DEFAULT '0',
  `npass` int(10) unsigned NOT NULL DEFAULT '0',
  `nfail` int(10) unsigned NOT NULL DEFAULT '0',
  `nwipe` int(10) unsigned NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime DEFAULT NULL,
  UNIQUE KEY `idx_rolesection` (`role_id`,`section_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_elite_mission_76`
--

DROP TABLE IF EXISTS `user_elite_mission_76`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_elite_mission_76` (
  `role_id` bigint(20) unsigned NOT NULL,
  `section_id` int(10) unsigned NOT NULL,
  `best_point` tinyint(4) DEFAULT NULL,
  `nattempt` int(10) unsigned NOT NULL DEFAULT '0',
  `npass` int(10) unsigned NOT NULL DEFAULT '0',
  `nfail` int(10) unsigned NOT NULL DEFAULT '0',
  `nwipe` int(10) unsigned NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime DEFAULT NULL,
  UNIQUE KEY `idx_rolesection` (`role_id`,`section_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_elite_mission_77`
--

DROP TABLE IF EXISTS `user_elite_mission_77`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_elite_mission_77` (
  `role_id` bigint(20) unsigned NOT NULL,
  `section_id` int(10) unsigned NOT NULL,
  `best_point` tinyint(4) DEFAULT NULL,
  `nattempt` int(10) unsigned NOT NULL DEFAULT '0',
  `npass` int(10) unsigned NOT NULL DEFAULT '0',
  `nfail` int(10) unsigned NOT NULL DEFAULT '0',
  `nwipe` int(10) unsigned NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime DEFAULT NULL,
  UNIQUE KEY `idx_rolesection` (`role_id`,`section_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_elite_mission_78`
--

DROP TABLE IF EXISTS `user_elite_mission_78`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_elite_mission_78` (
  `role_id` bigint(20) unsigned NOT NULL,
  `section_id` int(10) unsigned NOT NULL,
  `best_point` tinyint(4) DEFAULT NULL,
  `nattempt` int(10) unsigned NOT NULL DEFAULT '0',
  `npass` int(10) unsigned NOT NULL DEFAULT '0',
  `nfail` int(10) unsigned NOT NULL DEFAULT '0',
  `nwipe` int(10) unsigned NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime DEFAULT NULL,
  UNIQUE KEY `idx_rolesection` (`role_id`,`section_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_elite_mission_79`
--

DROP TABLE IF EXISTS `user_elite_mission_79`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_elite_mission_79` (
  `role_id` bigint(20) unsigned NOT NULL,
  `section_id` int(10) unsigned NOT NULL,
  `best_point` tinyint(4) DEFAULT NULL,
  `nattempt` int(10) unsigned NOT NULL DEFAULT '0',
  `npass` int(10) unsigned NOT NULL DEFAULT '0',
  `nfail` int(10) unsigned NOT NULL DEFAULT '0',
  `nwipe` int(10) unsigned NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime DEFAULT NULL,
  UNIQUE KEY `idx_rolesection` (`role_id`,`section_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_elite_mission_80`
--

DROP TABLE IF EXISTS `user_elite_mission_80`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_elite_mission_80` (
  `role_id` bigint(20) unsigned NOT NULL,
  `section_id` int(10) unsigned NOT NULL,
  `best_point` tinyint(4) DEFAULT NULL,
  `nattempt` int(10) unsigned NOT NULL DEFAULT '0',
  `npass` int(10) unsigned NOT NULL DEFAULT '0',
  `nfail` int(10) unsigned NOT NULL DEFAULT '0',
  `nwipe` int(10) unsigned NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime DEFAULT NULL,
  UNIQUE KEY `idx_rolesection` (`role_id`,`section_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_elite_mission_81`
--

DROP TABLE IF EXISTS `user_elite_mission_81`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_elite_mission_81` (
  `role_id` bigint(20) unsigned NOT NULL,
  `section_id` int(10) unsigned NOT NULL,
  `best_point` tinyint(4) DEFAULT NULL,
  `nattempt` int(10) unsigned NOT NULL DEFAULT '0',
  `npass` int(10) unsigned NOT NULL DEFAULT '0',
  `nfail` int(10) unsigned NOT NULL DEFAULT '0',
  `nwipe` int(10) unsigned NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime DEFAULT NULL,
  UNIQUE KEY `idx_rolesection` (`role_id`,`section_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_elite_mission_82`
--

DROP TABLE IF EXISTS `user_elite_mission_82`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_elite_mission_82` (
  `role_id` bigint(20) unsigned NOT NULL,
  `section_id` int(10) unsigned NOT NULL,
  `best_point` tinyint(4) DEFAULT NULL,
  `nattempt` int(10) unsigned NOT NULL DEFAULT '0',
  `npass` int(10) unsigned NOT NULL DEFAULT '0',
  `nfail` int(10) unsigned NOT NULL DEFAULT '0',
  `nwipe` int(10) unsigned NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime DEFAULT NULL,
  UNIQUE KEY `idx_rolesection` (`role_id`,`section_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_elite_mission_83`
--

DROP TABLE IF EXISTS `user_elite_mission_83`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_elite_mission_83` (
  `role_id` bigint(20) unsigned NOT NULL,
  `section_id` int(10) unsigned NOT NULL,
  `best_point` tinyint(4) DEFAULT NULL,
  `nattempt` int(10) unsigned NOT NULL DEFAULT '0',
  `npass` int(10) unsigned NOT NULL DEFAULT '0',
  `nfail` int(10) unsigned NOT NULL DEFAULT '0',
  `nwipe` int(10) unsigned NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime DEFAULT NULL,
  UNIQUE KEY `idx_rolesection` (`role_id`,`section_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_elite_mission_84`
--

DROP TABLE IF EXISTS `user_elite_mission_84`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_elite_mission_84` (
  `role_id` bigint(20) unsigned NOT NULL,
  `section_id` int(10) unsigned NOT NULL,
  `best_point` tinyint(4) DEFAULT NULL,
  `nattempt` int(10) unsigned NOT NULL DEFAULT '0',
  `npass` int(10) unsigned NOT NULL DEFAULT '0',
  `nfail` int(10) unsigned NOT NULL DEFAULT '0',
  `nwipe` int(10) unsigned NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime DEFAULT NULL,
  UNIQUE KEY `idx_rolesection` (`role_id`,`section_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_elite_mission_85`
--

DROP TABLE IF EXISTS `user_elite_mission_85`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_elite_mission_85` (
  `role_id` bigint(20) unsigned NOT NULL,
  `section_id` int(10) unsigned NOT NULL,
  `best_point` tinyint(4) DEFAULT NULL,
  `nattempt` int(10) unsigned NOT NULL DEFAULT '0',
  `npass` int(10) unsigned NOT NULL DEFAULT '0',
  `nfail` int(10) unsigned NOT NULL DEFAULT '0',
  `nwipe` int(10) unsigned NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime DEFAULT NULL,
  UNIQUE KEY `idx_rolesection` (`role_id`,`section_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_elite_mission_86`
--

DROP TABLE IF EXISTS `user_elite_mission_86`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_elite_mission_86` (
  `role_id` bigint(20) unsigned NOT NULL,
  `section_id` int(10) unsigned NOT NULL,
  `best_point` tinyint(4) DEFAULT NULL,
  `nattempt` int(10) unsigned NOT NULL DEFAULT '0',
  `npass` int(10) unsigned NOT NULL DEFAULT '0',
  `nfail` int(10) unsigned NOT NULL DEFAULT '0',
  `nwipe` int(10) unsigned NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime DEFAULT NULL,
  UNIQUE KEY `idx_rolesection` (`role_id`,`section_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_elite_mission_87`
--

DROP TABLE IF EXISTS `user_elite_mission_87`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_elite_mission_87` (
  `role_id` bigint(20) unsigned NOT NULL,
  `section_id` int(10) unsigned NOT NULL,
  `best_point` tinyint(4) DEFAULT NULL,
  `nattempt` int(10) unsigned NOT NULL DEFAULT '0',
  `npass` int(10) unsigned NOT NULL DEFAULT '0',
  `nfail` int(10) unsigned NOT NULL DEFAULT '0',
  `nwipe` int(10) unsigned NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime DEFAULT NULL,
  UNIQUE KEY `idx_rolesection` (`role_id`,`section_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_elite_mission_88`
--

DROP TABLE IF EXISTS `user_elite_mission_88`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_elite_mission_88` (
  `role_id` bigint(20) unsigned NOT NULL,
  `section_id` int(10) unsigned NOT NULL,
  `best_point` tinyint(4) DEFAULT NULL,
  `nattempt` int(10) unsigned NOT NULL DEFAULT '0',
  `npass` int(10) unsigned NOT NULL DEFAULT '0',
  `nfail` int(10) unsigned NOT NULL DEFAULT '0',
  `nwipe` int(10) unsigned NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime DEFAULT NULL,
  UNIQUE KEY `idx_rolesection` (`role_id`,`section_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_elite_mission_89`
--

DROP TABLE IF EXISTS `user_elite_mission_89`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_elite_mission_89` (
  `role_id` bigint(20) unsigned NOT NULL,
  `section_id` int(10) unsigned NOT NULL,
  `best_point` tinyint(4) DEFAULT NULL,
  `nattempt` int(10) unsigned NOT NULL DEFAULT '0',
  `npass` int(10) unsigned NOT NULL DEFAULT '0',
  `nfail` int(10) unsigned NOT NULL DEFAULT '0',
  `nwipe` int(10) unsigned NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime DEFAULT NULL,
  UNIQUE KEY `idx_rolesection` (`role_id`,`section_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_elite_mission_90`
--

DROP TABLE IF EXISTS `user_elite_mission_90`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_elite_mission_90` (
  `role_id` bigint(20) unsigned NOT NULL,
  `section_id` int(10) unsigned NOT NULL,
  `best_point` tinyint(4) DEFAULT NULL,
  `nattempt` int(10) unsigned NOT NULL DEFAULT '0',
  `npass` int(10) unsigned NOT NULL DEFAULT '0',
  `nfail` int(10) unsigned NOT NULL DEFAULT '0',
  `nwipe` int(10) unsigned NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime DEFAULT NULL,
  UNIQUE KEY `idx_rolesection` (`role_id`,`section_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_elite_mission_91`
--

DROP TABLE IF EXISTS `user_elite_mission_91`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_elite_mission_91` (
  `role_id` bigint(20) unsigned NOT NULL,
  `section_id` int(10) unsigned NOT NULL,
  `best_point` tinyint(4) DEFAULT NULL,
  `nattempt` int(10) unsigned NOT NULL DEFAULT '0',
  `npass` int(10) unsigned NOT NULL DEFAULT '0',
  `nfail` int(10) unsigned NOT NULL DEFAULT '0',
  `nwipe` int(10) unsigned NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime DEFAULT NULL,
  UNIQUE KEY `idx_rolesection` (`role_id`,`section_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_elite_mission_92`
--

DROP TABLE IF EXISTS `user_elite_mission_92`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_elite_mission_92` (
  `role_id` bigint(20) unsigned NOT NULL,
  `section_id` int(10) unsigned NOT NULL,
  `best_point` tinyint(4) DEFAULT NULL,
  `nattempt` int(10) unsigned NOT NULL DEFAULT '0',
  `npass` int(10) unsigned NOT NULL DEFAULT '0',
  `nfail` int(10) unsigned NOT NULL DEFAULT '0',
  `nwipe` int(10) unsigned NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime DEFAULT NULL,
  UNIQUE KEY `idx_rolesection` (`role_id`,`section_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_elite_mission_93`
--

DROP TABLE IF EXISTS `user_elite_mission_93`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_elite_mission_93` (
  `role_id` bigint(20) unsigned NOT NULL,
  `section_id` int(10) unsigned NOT NULL,
  `best_point` tinyint(4) DEFAULT NULL,
  `nattempt` int(10) unsigned NOT NULL DEFAULT '0',
  `npass` int(10) unsigned NOT NULL DEFAULT '0',
  `nfail` int(10) unsigned NOT NULL DEFAULT '0',
  `nwipe` int(10) unsigned NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime DEFAULT NULL,
  UNIQUE KEY `idx_rolesection` (`role_id`,`section_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_elite_mission_94`
--

DROP TABLE IF EXISTS `user_elite_mission_94`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_elite_mission_94` (
  `role_id` bigint(20) unsigned NOT NULL,
  `section_id` int(10) unsigned NOT NULL,
  `best_point` tinyint(4) DEFAULT NULL,
  `nattempt` int(10) unsigned NOT NULL DEFAULT '0',
  `npass` int(10) unsigned NOT NULL DEFAULT '0',
  `nfail` int(10) unsigned NOT NULL DEFAULT '0',
  `nwipe` int(10) unsigned NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime DEFAULT NULL,
  UNIQUE KEY `idx_rolesection` (`role_id`,`section_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_elite_mission_95`
--

DROP TABLE IF EXISTS `user_elite_mission_95`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_elite_mission_95` (
  `role_id` bigint(20) unsigned NOT NULL,
  `section_id` int(10) unsigned NOT NULL,
  `best_point` tinyint(4) DEFAULT NULL,
  `nattempt` int(10) unsigned NOT NULL DEFAULT '0',
  `npass` int(10) unsigned NOT NULL DEFAULT '0',
  `nfail` int(10) unsigned NOT NULL DEFAULT '0',
  `nwipe` int(10) unsigned NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime DEFAULT NULL,
  UNIQUE KEY `idx_rolesection` (`role_id`,`section_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_elite_mission_96`
--

DROP TABLE IF EXISTS `user_elite_mission_96`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_elite_mission_96` (
  `role_id` bigint(20) unsigned NOT NULL,
  `section_id` int(10) unsigned NOT NULL,
  `best_point` tinyint(4) DEFAULT NULL,
  `nattempt` int(10) unsigned NOT NULL DEFAULT '0',
  `npass` int(10) unsigned NOT NULL DEFAULT '0',
  `nfail` int(10) unsigned NOT NULL DEFAULT '0',
  `nwipe` int(10) unsigned NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime DEFAULT NULL,
  UNIQUE KEY `idx_rolesection` (`role_id`,`section_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_elite_mission_97`
--

DROP TABLE IF EXISTS `user_elite_mission_97`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_elite_mission_97` (
  `role_id` bigint(20) unsigned NOT NULL,
  `section_id` int(10) unsigned NOT NULL,
  `best_point` tinyint(4) DEFAULT NULL,
  `nattempt` int(10) unsigned NOT NULL DEFAULT '0',
  `npass` int(10) unsigned NOT NULL DEFAULT '0',
  `nfail` int(10) unsigned NOT NULL DEFAULT '0',
  `nwipe` int(10) unsigned NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime DEFAULT NULL,
  UNIQUE KEY `idx_rolesection` (`role_id`,`section_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_elite_mission_98`
--

DROP TABLE IF EXISTS `user_elite_mission_98`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_elite_mission_98` (
  `role_id` bigint(20) unsigned NOT NULL,
  `section_id` int(10) unsigned NOT NULL,
  `best_point` tinyint(4) DEFAULT NULL,
  `nattempt` int(10) unsigned NOT NULL DEFAULT '0',
  `npass` int(10) unsigned NOT NULL DEFAULT '0',
  `nfail` int(10) unsigned NOT NULL DEFAULT '0',
  `nwipe` int(10) unsigned NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime DEFAULT NULL,
  UNIQUE KEY `idx_rolesection` (`role_id`,`section_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_elite_mission_99`
--

DROP TABLE IF EXISTS `user_elite_mission_99`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_elite_mission_99` (
  `role_id` bigint(20) unsigned NOT NULL,
  `section_id` int(10) unsigned NOT NULL,
  `best_point` tinyint(4) DEFAULT NULL,
  `nattempt` int(10) unsigned NOT NULL DEFAULT '0',
  `npass` int(10) unsigned NOT NULL DEFAULT '0',
  `nfail` int(10) unsigned NOT NULL DEFAULT '0',
  `nwipe` int(10) unsigned NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime DEFAULT NULL,
  UNIQUE KEY `idx_rolesection` (`role_id`,`section_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_equip`
--

DROP TABLE IF EXISTS `user_equip`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_equip` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL DEFAULT '0',
  `equip_id` smallint(6) NOT NULL DEFAULT '0',
  `level` smallint(6) NOT NULL DEFAULT '1',
  `deck_pos` int(11) NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_deck_idx` (`user_id`,`deck_pos`,`equip_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_equip_00`
--

DROP TABLE IF EXISTS `user_equip_00`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_equip_00` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL DEFAULT '0',
  `equip_id` smallint(6) NOT NULL DEFAULT '0',
  `level` smallint(6) NOT NULL DEFAULT '1',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id_idx` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=140 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_equip_01`
--

DROP TABLE IF EXISTS `user_equip_01`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_equip_01` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL DEFAULT '0',
  `equip_id` smallint(6) NOT NULL DEFAULT '0',
  `level` smallint(6) NOT NULL DEFAULT '1',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id_idx` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=107 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_equip_02`
--

DROP TABLE IF EXISTS `user_equip_02`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_equip_02` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL DEFAULT '0',
  `equip_id` smallint(6) NOT NULL DEFAULT '0',
  `level` smallint(6) NOT NULL DEFAULT '1',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id_idx` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=112 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_equip_03`
--

DROP TABLE IF EXISTS `user_equip_03`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_equip_03` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL DEFAULT '0',
  `equip_id` smallint(6) NOT NULL DEFAULT '0',
  `level` smallint(6) NOT NULL DEFAULT '1',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id_idx` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=241 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_equip_04`
--

DROP TABLE IF EXISTS `user_equip_04`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_equip_04` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL DEFAULT '0',
  `equip_id` smallint(6) NOT NULL DEFAULT '0',
  `level` smallint(6) NOT NULL DEFAULT '1',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id_idx` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=262 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_equip_05`
--

DROP TABLE IF EXISTS `user_equip_05`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_equip_05` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL DEFAULT '0',
  `equip_id` smallint(6) NOT NULL DEFAULT '0',
  `level` smallint(6) NOT NULL DEFAULT '1',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id_idx` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=575 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_equip_06`
--

DROP TABLE IF EXISTS `user_equip_06`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_equip_06` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL DEFAULT '0',
  `equip_id` smallint(6) NOT NULL DEFAULT '0',
  `level` smallint(6) NOT NULL DEFAULT '1',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id_idx` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=224 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_equip_07`
--

DROP TABLE IF EXISTS `user_equip_07`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_equip_07` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL DEFAULT '0',
  `equip_id` smallint(6) NOT NULL DEFAULT '0',
  `level` smallint(6) NOT NULL DEFAULT '1',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id_idx` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=520 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_equip_08`
--

DROP TABLE IF EXISTS `user_equip_08`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_equip_08` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL DEFAULT '0',
  `equip_id` smallint(6) NOT NULL DEFAULT '0',
  `level` smallint(6) NOT NULL DEFAULT '1',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id_idx` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=446 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_equip_09`
--

DROP TABLE IF EXISTS `user_equip_09`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_equip_09` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL DEFAULT '0',
  `equip_id` smallint(6) NOT NULL DEFAULT '0',
  `level` smallint(6) NOT NULL DEFAULT '1',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id_idx` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=441 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_equip_10`
--

DROP TABLE IF EXISTS `user_equip_10`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_equip_10` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL DEFAULT '0',
  `equip_id` smallint(6) NOT NULL DEFAULT '0',
  `level` smallint(6) NOT NULL DEFAULT '1',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id_idx` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=365 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_equip_11`
--

DROP TABLE IF EXISTS `user_equip_11`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_equip_11` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL DEFAULT '0',
  `equip_id` smallint(6) NOT NULL DEFAULT '0',
  `level` smallint(6) NOT NULL DEFAULT '1',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id_idx` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=907 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_equip_12`
--

DROP TABLE IF EXISTS `user_equip_12`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_equip_12` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL DEFAULT '0',
  `equip_id` smallint(6) NOT NULL DEFAULT '0',
  `level` smallint(6) NOT NULL DEFAULT '1',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id_idx` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=179 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_equip_13`
--

DROP TABLE IF EXISTS `user_equip_13`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_equip_13` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL DEFAULT '0',
  `equip_id` smallint(6) NOT NULL DEFAULT '0',
  `level` smallint(6) NOT NULL DEFAULT '1',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id_idx` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=183 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_equip_14`
--

DROP TABLE IF EXISTS `user_equip_14`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_equip_14` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL DEFAULT '0',
  `equip_id` smallint(6) NOT NULL DEFAULT '0',
  `level` smallint(6) NOT NULL DEFAULT '1',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id_idx` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=154 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_equip_15`
--

DROP TABLE IF EXISTS `user_equip_15`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_equip_15` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL DEFAULT '0',
  `equip_id` smallint(6) NOT NULL DEFAULT '0',
  `level` smallint(6) NOT NULL DEFAULT '1',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id_idx` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=519 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_equip_16`
--

DROP TABLE IF EXISTS `user_equip_16`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_equip_16` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL DEFAULT '0',
  `equip_id` smallint(6) NOT NULL DEFAULT '0',
  `level` smallint(6) NOT NULL DEFAULT '1',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id_idx` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=236 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_equip_17`
--

DROP TABLE IF EXISTS `user_equip_17`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_equip_17` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL DEFAULT '0',
  `equip_id` smallint(6) NOT NULL DEFAULT '0',
  `level` smallint(6) NOT NULL DEFAULT '1',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id_idx` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=923 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_equip_18`
--

DROP TABLE IF EXISTS `user_equip_18`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_equip_18` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL DEFAULT '0',
  `equip_id` smallint(6) NOT NULL DEFAULT '0',
  `level` smallint(6) NOT NULL DEFAULT '1',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id_idx` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=211 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_equip_19`
--

DROP TABLE IF EXISTS `user_equip_19`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_equip_19` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL DEFAULT '0',
  `equip_id` smallint(6) NOT NULL DEFAULT '0',
  `level` smallint(6) NOT NULL DEFAULT '1',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id_idx` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=426 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_equip_20`
--

DROP TABLE IF EXISTS `user_equip_20`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_equip_20` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL DEFAULT '0',
  `equip_id` smallint(6) NOT NULL DEFAULT '0',
  `level` smallint(6) NOT NULL DEFAULT '1',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id_idx` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=424 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_equip_21`
--

DROP TABLE IF EXISTS `user_equip_21`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_equip_21` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL DEFAULT '0',
  `equip_id` smallint(6) NOT NULL DEFAULT '0',
  `level` smallint(6) NOT NULL DEFAULT '1',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id_idx` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=52 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_equip_22`
--

DROP TABLE IF EXISTS `user_equip_22`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_equip_22` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL DEFAULT '0',
  `equip_id` smallint(6) NOT NULL DEFAULT '0',
  `level` smallint(6) NOT NULL DEFAULT '1',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id_idx` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=93 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_equip_23`
--

DROP TABLE IF EXISTS `user_equip_23`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_equip_23` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL DEFAULT '0',
  `equip_id` smallint(6) NOT NULL DEFAULT '0',
  `level` smallint(6) NOT NULL DEFAULT '1',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id_idx` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=159 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_equip_24`
--

DROP TABLE IF EXISTS `user_equip_24`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_equip_24` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL DEFAULT '0',
  `equip_id` smallint(6) NOT NULL DEFAULT '0',
  `level` smallint(6) NOT NULL DEFAULT '1',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id_idx` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=171 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_equip_25`
--

DROP TABLE IF EXISTS `user_equip_25`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_equip_25` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL DEFAULT '0',
  `equip_id` smallint(6) NOT NULL DEFAULT '0',
  `level` smallint(6) NOT NULL DEFAULT '1',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id_idx` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=96 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_equip_26`
--

DROP TABLE IF EXISTS `user_equip_26`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_equip_26` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL DEFAULT '0',
  `equip_id` smallint(6) NOT NULL DEFAULT '0',
  `level` smallint(6) NOT NULL DEFAULT '1',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id_idx` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=221 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_equip_27`
--

DROP TABLE IF EXISTS `user_equip_27`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_equip_27` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL DEFAULT '0',
  `equip_id` smallint(6) NOT NULL DEFAULT '0',
  `level` smallint(6) NOT NULL DEFAULT '1',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id_idx` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=191 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_equip_28`
--

DROP TABLE IF EXISTS `user_equip_28`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_equip_28` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL DEFAULT '0',
  `equip_id` smallint(6) NOT NULL DEFAULT '0',
  `level` smallint(6) NOT NULL DEFAULT '1',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id_idx` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=377 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_equip_29`
--

DROP TABLE IF EXISTS `user_equip_29`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_equip_29` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL DEFAULT '0',
  `equip_id` smallint(6) NOT NULL DEFAULT '0',
  `level` smallint(6) NOT NULL DEFAULT '1',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id_idx` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=235 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_equip_30`
--

DROP TABLE IF EXISTS `user_equip_30`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_equip_30` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL DEFAULT '0',
  `equip_id` smallint(6) NOT NULL DEFAULT '0',
  `level` smallint(6) NOT NULL DEFAULT '1',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id_idx` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=255 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_equip_31`
--

DROP TABLE IF EXISTS `user_equip_31`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_equip_31` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL DEFAULT '0',
  `equip_id` smallint(6) NOT NULL DEFAULT '0',
  `level` smallint(6) NOT NULL DEFAULT '1',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id_idx` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=159 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_equip_32`
--

DROP TABLE IF EXISTS `user_equip_32`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_equip_32` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL DEFAULT '0',
  `equip_id` smallint(6) NOT NULL DEFAULT '0',
  `level` smallint(6) NOT NULL DEFAULT '1',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id_idx` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=243 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_equip_33`
--

DROP TABLE IF EXISTS `user_equip_33`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_equip_33` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL DEFAULT '0',
  `equip_id` smallint(6) NOT NULL DEFAULT '0',
  `level` smallint(6) NOT NULL DEFAULT '1',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id_idx` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=267 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_equip_34`
--

DROP TABLE IF EXISTS `user_equip_34`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_equip_34` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL DEFAULT '0',
  `equip_id` smallint(6) NOT NULL DEFAULT '0',
  `level` smallint(6) NOT NULL DEFAULT '1',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id_idx` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=141 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_equip_35`
--

DROP TABLE IF EXISTS `user_equip_35`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_equip_35` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL DEFAULT '0',
  `equip_id` smallint(6) NOT NULL DEFAULT '0',
  `level` smallint(6) NOT NULL DEFAULT '1',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id_idx` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=462 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_equip_36`
--

DROP TABLE IF EXISTS `user_equip_36`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_equip_36` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL DEFAULT '0',
  `equip_id` smallint(6) NOT NULL DEFAULT '0',
  `level` smallint(6) NOT NULL DEFAULT '1',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id_idx` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=182 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_equip_37`
--

DROP TABLE IF EXISTS `user_equip_37`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_equip_37` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL DEFAULT '0',
  `equip_id` smallint(6) NOT NULL DEFAULT '0',
  `level` smallint(6) NOT NULL DEFAULT '1',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id_idx` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=167 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_equip_38`
--

DROP TABLE IF EXISTS `user_equip_38`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_equip_38` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL DEFAULT '0',
  `equip_id` smallint(6) NOT NULL DEFAULT '0',
  `level` smallint(6) NOT NULL DEFAULT '1',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id_idx` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=811 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_equip_39`
--

DROP TABLE IF EXISTS `user_equip_39`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_equip_39` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL DEFAULT '0',
  `equip_id` smallint(6) NOT NULL DEFAULT '0',
  `level` smallint(6) NOT NULL DEFAULT '1',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id_idx` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=312 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_equip_40`
--

DROP TABLE IF EXISTS `user_equip_40`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_equip_40` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL DEFAULT '0',
  `equip_id` smallint(6) NOT NULL DEFAULT '0',
  `level` smallint(6) NOT NULL DEFAULT '1',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id_idx` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=233 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_equip_41`
--

DROP TABLE IF EXISTS `user_equip_41`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_equip_41` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL DEFAULT '0',
  `equip_id` smallint(6) NOT NULL DEFAULT '0',
  `level` smallint(6) NOT NULL DEFAULT '1',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id_idx` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=176 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_equip_42`
--

DROP TABLE IF EXISTS `user_equip_42`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_equip_42` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL DEFAULT '0',
  `equip_id` smallint(6) NOT NULL DEFAULT '0',
  `level` smallint(6) NOT NULL DEFAULT '1',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id_idx` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=84 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_equip_43`
--

DROP TABLE IF EXISTS `user_equip_43`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_equip_43` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL DEFAULT '0',
  `equip_id` smallint(6) NOT NULL DEFAULT '0',
  `level` smallint(6) NOT NULL DEFAULT '1',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id_idx` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=182 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_equip_44`
--

DROP TABLE IF EXISTS `user_equip_44`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_equip_44` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL DEFAULT '0',
  `equip_id` smallint(6) NOT NULL DEFAULT '0',
  `level` smallint(6) NOT NULL DEFAULT '1',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id_idx` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=232 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_equip_45`
--

DROP TABLE IF EXISTS `user_equip_45`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_equip_45` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL DEFAULT '0',
  `equip_id` smallint(6) NOT NULL DEFAULT '0',
  `level` smallint(6) NOT NULL DEFAULT '1',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id_idx` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=126 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_equip_46`
--

DROP TABLE IF EXISTS `user_equip_46`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_equip_46` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL DEFAULT '0',
  `equip_id` smallint(6) NOT NULL DEFAULT '0',
  `level` smallint(6) NOT NULL DEFAULT '1',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id_idx` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=111 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_equip_47`
--

DROP TABLE IF EXISTS `user_equip_47`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_equip_47` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL DEFAULT '0',
  `equip_id` smallint(6) NOT NULL DEFAULT '0',
  `level` smallint(6) NOT NULL DEFAULT '1',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id_idx` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=1666 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_equip_48`
--

DROP TABLE IF EXISTS `user_equip_48`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_equip_48` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL DEFAULT '0',
  `equip_id` smallint(6) NOT NULL DEFAULT '0',
  `level` smallint(6) NOT NULL DEFAULT '1',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id_idx` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=372 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_equip_49`
--

DROP TABLE IF EXISTS `user_equip_49`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_equip_49` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL DEFAULT '0',
  `equip_id` smallint(6) NOT NULL DEFAULT '0',
  `level` smallint(6) NOT NULL DEFAULT '1',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id_idx` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=347 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_equip_50`
--

DROP TABLE IF EXISTS `user_equip_50`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_equip_50` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL DEFAULT '0',
  `equip_id` smallint(6) NOT NULL DEFAULT '0',
  `level` smallint(6) NOT NULL DEFAULT '1',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id_idx` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=147 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_equip_51`
--

DROP TABLE IF EXISTS `user_equip_51`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_equip_51` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL DEFAULT '0',
  `equip_id` smallint(6) NOT NULL DEFAULT '0',
  `level` smallint(6) NOT NULL DEFAULT '1',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id_idx` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=265 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_equip_52`
--

DROP TABLE IF EXISTS `user_equip_52`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_equip_52` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL DEFAULT '0',
  `equip_id` smallint(6) NOT NULL DEFAULT '0',
  `level` smallint(6) NOT NULL DEFAULT '1',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id_idx` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=320 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_equip_53`
--

DROP TABLE IF EXISTS `user_equip_53`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_equip_53` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL DEFAULT '0',
  `equip_id` smallint(6) NOT NULL DEFAULT '0',
  `level` smallint(6) NOT NULL DEFAULT '1',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id_idx` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=344 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_equip_54`
--

DROP TABLE IF EXISTS `user_equip_54`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_equip_54` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL DEFAULT '0',
  `equip_id` smallint(6) NOT NULL DEFAULT '0',
  `level` smallint(6) NOT NULL DEFAULT '1',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id_idx` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=190 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_equip_55`
--

DROP TABLE IF EXISTS `user_equip_55`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_equip_55` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL DEFAULT '0',
  `equip_id` smallint(6) NOT NULL DEFAULT '0',
  `level` smallint(6) NOT NULL DEFAULT '1',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id_idx` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=328 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_equip_56`
--

DROP TABLE IF EXISTS `user_equip_56`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_equip_56` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL DEFAULT '0',
  `equip_id` smallint(6) NOT NULL DEFAULT '0',
  `level` smallint(6) NOT NULL DEFAULT '1',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id_idx` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=154 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_equip_57`
--

DROP TABLE IF EXISTS `user_equip_57`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_equip_57` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL DEFAULT '0',
  `equip_id` smallint(6) NOT NULL DEFAULT '0',
  `level` smallint(6) NOT NULL DEFAULT '1',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id_idx` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=776 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_equip_58`
--

DROP TABLE IF EXISTS `user_equip_58`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_equip_58` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL DEFAULT '0',
  `equip_id` smallint(6) NOT NULL DEFAULT '0',
  `level` smallint(6) NOT NULL DEFAULT '1',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id_idx` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=330 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_equip_59`
--

DROP TABLE IF EXISTS `user_equip_59`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_equip_59` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL DEFAULT '0',
  `equip_id` smallint(6) NOT NULL DEFAULT '0',
  `level` smallint(6) NOT NULL DEFAULT '1',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id_idx` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=74 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_equip_60`
--

DROP TABLE IF EXISTS `user_equip_60`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_equip_60` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL DEFAULT '0',
  `equip_id` smallint(6) NOT NULL DEFAULT '0',
  `level` smallint(6) NOT NULL DEFAULT '1',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id_idx` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=193 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_equip_61`
--

DROP TABLE IF EXISTS `user_equip_61`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_equip_61` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL DEFAULT '0',
  `equip_id` smallint(6) NOT NULL DEFAULT '0',
  `level` smallint(6) NOT NULL DEFAULT '1',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id_idx` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=285 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_equip_62`
--

DROP TABLE IF EXISTS `user_equip_62`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_equip_62` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL DEFAULT '0',
  `equip_id` smallint(6) NOT NULL DEFAULT '0',
  `level` smallint(6) NOT NULL DEFAULT '1',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id_idx` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=77 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_equip_63`
--

DROP TABLE IF EXISTS `user_equip_63`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_equip_63` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL DEFAULT '0',
  `equip_id` smallint(6) NOT NULL DEFAULT '0',
  `level` smallint(6) NOT NULL DEFAULT '1',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id_idx` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=61 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_equip_64`
--

DROP TABLE IF EXISTS `user_equip_64`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_equip_64` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL DEFAULT '0',
  `equip_id` smallint(6) NOT NULL DEFAULT '0',
  `level` smallint(6) NOT NULL DEFAULT '1',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id_idx` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=254 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_equip_65`
--

DROP TABLE IF EXISTS `user_equip_65`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_equip_65` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL DEFAULT '0',
  `equip_id` smallint(6) NOT NULL DEFAULT '0',
  `level` smallint(6) NOT NULL DEFAULT '1',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id_idx` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=134 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_equip_66`
--

DROP TABLE IF EXISTS `user_equip_66`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_equip_66` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL DEFAULT '0',
  `equip_id` smallint(6) NOT NULL DEFAULT '0',
  `level` smallint(6) NOT NULL DEFAULT '1',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id_idx` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=41 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_equip_67`
--

DROP TABLE IF EXISTS `user_equip_67`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_equip_67` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL DEFAULT '0',
  `equip_id` smallint(6) NOT NULL DEFAULT '0',
  `level` smallint(6) NOT NULL DEFAULT '1',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id_idx` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=263 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_equip_68`
--

DROP TABLE IF EXISTS `user_equip_68`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_equip_68` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL DEFAULT '0',
  `equip_id` smallint(6) NOT NULL DEFAULT '0',
  `level` smallint(6) NOT NULL DEFAULT '1',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id_idx` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=84 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_equip_69`
--

DROP TABLE IF EXISTS `user_equip_69`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_equip_69` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL DEFAULT '0',
  `equip_id` smallint(6) NOT NULL DEFAULT '0',
  `level` smallint(6) NOT NULL DEFAULT '1',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id_idx` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=551 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_equip_70`
--

DROP TABLE IF EXISTS `user_equip_70`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_equip_70` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL DEFAULT '0',
  `equip_id` smallint(6) NOT NULL DEFAULT '0',
  `level` smallint(6) NOT NULL DEFAULT '1',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id_idx` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=159 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_equip_71`
--

DROP TABLE IF EXISTS `user_equip_71`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_equip_71` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL DEFAULT '0',
  `equip_id` smallint(6) NOT NULL DEFAULT '0',
  `level` smallint(6) NOT NULL DEFAULT '1',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id_idx` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=822 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_equip_72`
--

DROP TABLE IF EXISTS `user_equip_72`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_equip_72` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL DEFAULT '0',
  `equip_id` smallint(6) NOT NULL DEFAULT '0',
  `level` smallint(6) NOT NULL DEFAULT '1',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id_idx` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=317 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_equip_73`
--

DROP TABLE IF EXISTS `user_equip_73`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_equip_73` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL DEFAULT '0',
  `equip_id` smallint(6) NOT NULL DEFAULT '0',
  `level` smallint(6) NOT NULL DEFAULT '1',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id_idx` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=261 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_equip_74`
--

DROP TABLE IF EXISTS `user_equip_74`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_equip_74` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL DEFAULT '0',
  `equip_id` smallint(6) NOT NULL DEFAULT '0',
  `level` smallint(6) NOT NULL DEFAULT '1',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id_idx` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=389 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_equip_75`
--

DROP TABLE IF EXISTS `user_equip_75`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_equip_75` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL DEFAULT '0',
  `equip_id` smallint(6) NOT NULL DEFAULT '0',
  `level` smallint(6) NOT NULL DEFAULT '1',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id_idx` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=441 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_equip_76`
--

DROP TABLE IF EXISTS `user_equip_76`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_equip_76` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL DEFAULT '0',
  `equip_id` smallint(6) NOT NULL DEFAULT '0',
  `level` smallint(6) NOT NULL DEFAULT '1',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id_idx` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=270 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_equip_77`
--

DROP TABLE IF EXISTS `user_equip_77`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_equip_77` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL DEFAULT '0',
  `equip_id` smallint(6) NOT NULL DEFAULT '0',
  `level` smallint(6) NOT NULL DEFAULT '1',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id_idx` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=115 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_equip_78`
--

DROP TABLE IF EXISTS `user_equip_78`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_equip_78` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL DEFAULT '0',
  `equip_id` smallint(6) NOT NULL DEFAULT '0',
  `level` smallint(6) NOT NULL DEFAULT '1',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id_idx` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=706 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_equip_79`
--

DROP TABLE IF EXISTS `user_equip_79`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_equip_79` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL DEFAULT '0',
  `equip_id` smallint(6) NOT NULL DEFAULT '0',
  `level` smallint(6) NOT NULL DEFAULT '1',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id_idx` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=216 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_equip_80`
--

DROP TABLE IF EXISTS `user_equip_80`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_equip_80` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL DEFAULT '0',
  `equip_id` smallint(6) NOT NULL DEFAULT '0',
  `level` smallint(6) NOT NULL DEFAULT '1',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id_idx` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=166 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_equip_81`
--

DROP TABLE IF EXISTS `user_equip_81`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_equip_81` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL DEFAULT '0',
  `equip_id` smallint(6) NOT NULL DEFAULT '0',
  `level` smallint(6) NOT NULL DEFAULT '1',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id_idx` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=214 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_equip_82`
--

DROP TABLE IF EXISTS `user_equip_82`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_equip_82` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL DEFAULT '0',
  `equip_id` smallint(6) NOT NULL DEFAULT '0',
  `level` smallint(6) NOT NULL DEFAULT '1',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id_idx` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=1322 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_equip_83`
--

DROP TABLE IF EXISTS `user_equip_83`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_equip_83` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL DEFAULT '0',
  `equip_id` smallint(6) NOT NULL DEFAULT '0',
  `level` smallint(6) NOT NULL DEFAULT '1',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id_idx` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=197 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_equip_84`
--

DROP TABLE IF EXISTS `user_equip_84`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_equip_84` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL DEFAULT '0',
  `equip_id` smallint(6) NOT NULL DEFAULT '0',
  `level` smallint(6) NOT NULL DEFAULT '1',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id_idx` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=399 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_equip_85`
--

DROP TABLE IF EXISTS `user_equip_85`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_equip_85` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL DEFAULT '0',
  `equip_id` smallint(6) NOT NULL DEFAULT '0',
  `level` smallint(6) NOT NULL DEFAULT '1',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id_idx` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=152 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_equip_86`
--

DROP TABLE IF EXISTS `user_equip_86`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_equip_86` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL DEFAULT '0',
  `equip_id` smallint(6) NOT NULL DEFAULT '0',
  `level` smallint(6) NOT NULL DEFAULT '1',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id_idx` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=439 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_equip_87`
--

DROP TABLE IF EXISTS `user_equip_87`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_equip_87` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL DEFAULT '0',
  `equip_id` smallint(6) NOT NULL DEFAULT '0',
  `level` smallint(6) NOT NULL DEFAULT '1',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id_idx` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=635 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_equip_88`
--

DROP TABLE IF EXISTS `user_equip_88`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_equip_88` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL DEFAULT '0',
  `equip_id` smallint(6) NOT NULL DEFAULT '0',
  `level` smallint(6) NOT NULL DEFAULT '1',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id_idx` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=153 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_equip_89`
--

DROP TABLE IF EXISTS `user_equip_89`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_equip_89` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL DEFAULT '0',
  `equip_id` smallint(6) NOT NULL DEFAULT '0',
  `level` smallint(6) NOT NULL DEFAULT '1',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id_idx` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=558 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_equip_90`
--

DROP TABLE IF EXISTS `user_equip_90`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_equip_90` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL DEFAULT '0',
  `equip_id` smallint(6) NOT NULL DEFAULT '0',
  `level` smallint(6) NOT NULL DEFAULT '1',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id_idx` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=241 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_equip_91`
--

DROP TABLE IF EXISTS `user_equip_91`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_equip_91` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL DEFAULT '0',
  `equip_id` smallint(6) NOT NULL DEFAULT '0',
  `level` smallint(6) NOT NULL DEFAULT '1',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id_idx` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=240 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_equip_92`
--

DROP TABLE IF EXISTS `user_equip_92`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_equip_92` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL DEFAULT '0',
  `equip_id` smallint(6) NOT NULL DEFAULT '0',
  `level` smallint(6) NOT NULL DEFAULT '1',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id_idx` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=177 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_equip_93`
--

DROP TABLE IF EXISTS `user_equip_93`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_equip_93` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL DEFAULT '0',
  `equip_id` smallint(6) NOT NULL DEFAULT '0',
  `level` smallint(6) NOT NULL DEFAULT '1',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id_idx` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=173 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_equip_94`
--

DROP TABLE IF EXISTS `user_equip_94`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_equip_94` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL DEFAULT '0',
  `equip_id` smallint(6) NOT NULL DEFAULT '0',
  `level` smallint(6) NOT NULL DEFAULT '1',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id_idx` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=484 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_equip_95`
--

DROP TABLE IF EXISTS `user_equip_95`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_equip_95` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL DEFAULT '0',
  `equip_id` smallint(6) NOT NULL DEFAULT '0',
  `level` smallint(6) NOT NULL DEFAULT '1',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id_idx` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=92 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_equip_96`
--

DROP TABLE IF EXISTS `user_equip_96`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_equip_96` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL DEFAULT '0',
  `equip_id` smallint(6) NOT NULL DEFAULT '0',
  `level` smallint(6) NOT NULL DEFAULT '1',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id_idx` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=155 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_equip_97`
--

DROP TABLE IF EXISTS `user_equip_97`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_equip_97` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL DEFAULT '0',
  `equip_id` smallint(6) NOT NULL DEFAULT '0',
  `level` smallint(6) NOT NULL DEFAULT '1',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id_idx` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=316 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_equip_98`
--

DROP TABLE IF EXISTS `user_equip_98`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_equip_98` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL DEFAULT '0',
  `equip_id` smallint(6) NOT NULL DEFAULT '0',
  `level` smallint(6) NOT NULL DEFAULT '1',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id_idx` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=128 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_equip_99`
--

DROP TABLE IF EXISTS `user_equip_99`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_equip_99` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL DEFAULT '0',
  `equip_id` smallint(6) NOT NULL DEFAULT '0',
  `level` smallint(6) NOT NULL DEFAULT '1',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id_idx` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=270 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_formation`
--

DROP TABLE IF EXISTS `user_formation`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_formation` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `type` tinyint(1) NOT NULL,
  `pos_1` tinyint(1) NOT NULL DEFAULT '0',
  `pos_2` tinyint(1) NOT NULL DEFAULT '0',
  `pos_3` tinyint(1) NOT NULL DEFAULT '0',
  `pos_4` tinyint(1) NOT NULL DEFAULT '0',
  `pos_5` tinyint(1) NOT NULL DEFAULT '0',
  `pos_6` tinyint(1) NOT NULL DEFAULT '0',
  `pos_7` tinyint(1) NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_type` (`user_id`,`type`)
) ENGINE=InnoDB AUTO_INCREMENT=4879 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_item`
--

DROP TABLE IF EXISTS `user_item`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_item` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `item_id` tinyint(2) NOT NULL,
  `sub_id` smallint(4) NOT NULL DEFAULT '1',
  `count` smallint(6) NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `item_idx` (`user_id`,`item_id`,`sub_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_mail`
--

DROP TABLE IF EXISTS `user_mail`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_mail` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(10) unsigned NOT NULL,
  `from_uid` int(11) DEFAULT '0',
  `type` tinyint(4) NOT NULL DEFAULT '0',
  `text_id` int(11) NOT NULL DEFAULT '0',
  `mail_text` text,
  `attachment` varchar(1024) DEFAULT NULL,
  `status` tinyint(4) DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00' ON UPDATE CURRENT_TIMESTAMP,
  `created_at` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  `from_name` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_user` (`user_id`),
  KEY `idx_t` (`created_at`)
) ENGINE=InnoDB AUTO_INCREMENT=30089 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_mission`
--

DROP TABLE IF EXISTS `user_mission`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_mission` (
  `role_id` bigint(20) unsigned NOT NULL,
  `section_id` int(10) unsigned NOT NULL,
  `best_point` tinyint(4) DEFAULT NULL,
  `nattempt` int(10) unsigned NOT NULL DEFAULT '0',
  `npass` int(10) unsigned NOT NULL DEFAULT '0',
  `nfail` int(10) unsigned NOT NULL DEFAULT '0',
  `nwipe` int(10) unsigned NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime DEFAULT NULL,
  UNIQUE KEY `idx_rolesection` (`role_id`,`section_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_mission2`
--

DROP TABLE IF EXISTS `user_mission2`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_mission2` (
  `role_id` bigint(20) unsigned NOT NULL,
  `section_id` int(10) unsigned NOT NULL,
  `best_point` tinyint(4) DEFAULT NULL,
  `nattempt` int(10) unsigned NOT NULL DEFAULT '0',
  `npass` int(10) unsigned NOT NULL DEFAULT '0',
  `nfail` int(10) unsigned NOT NULL DEFAULT '0',
  `nwipe` int(10) unsigned NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime DEFAULT NULL,
  UNIQUE KEY `idx_rolesection` (`role_id`,`section_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_mission_0`
--

DROP TABLE IF EXISTS `user_mission_0`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_mission_0` (
  `id` bigint(20) unsigned NOT NULL,
  `section_id` int(10) unsigned NOT NULL,
  `star` int(10) unsigned NOT NULL DEFAULT '0',
  `count` int(10) unsigned NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL,
  KEY `id` (`id`,`section_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_mission_00`
--

DROP TABLE IF EXISTS `user_mission_00`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_mission_00` (
  `role_id` bigint(20) unsigned NOT NULL,
  `section_id` int(10) unsigned NOT NULL,
  `best_point` tinyint(4) DEFAULT NULL,
  `nattempt` int(10) unsigned NOT NULL DEFAULT '0',
  `npass` int(10) unsigned NOT NULL DEFAULT '0',
  `nfail` int(10) unsigned NOT NULL DEFAULT '0',
  `nwipe` int(10) unsigned NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime DEFAULT NULL,
  UNIQUE KEY `idx_rolesection` (`role_id`,`section_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_mission_01`
--

DROP TABLE IF EXISTS `user_mission_01`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_mission_01` (
  `role_id` bigint(20) unsigned NOT NULL,
  `section_id` int(10) unsigned NOT NULL,
  `best_point` tinyint(4) DEFAULT NULL,
  `nattempt` int(10) unsigned NOT NULL DEFAULT '0',
  `npass` int(10) unsigned NOT NULL DEFAULT '0',
  `nfail` int(10) unsigned NOT NULL DEFAULT '0',
  `nwipe` int(10) unsigned NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime DEFAULT NULL,
  UNIQUE KEY `idx_rolesection` (`role_id`,`section_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_mission_02`
--

DROP TABLE IF EXISTS `user_mission_02`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_mission_02` (
  `role_id` bigint(20) unsigned NOT NULL,
  `section_id` int(10) unsigned NOT NULL,
  `best_point` tinyint(4) DEFAULT NULL,
  `nattempt` int(10) unsigned NOT NULL DEFAULT '0',
  `npass` int(10) unsigned NOT NULL DEFAULT '0',
  `nfail` int(10) unsigned NOT NULL DEFAULT '0',
  `nwipe` int(10) unsigned NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime DEFAULT NULL,
  UNIQUE KEY `idx_rolesection` (`role_id`,`section_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_mission_03`
--

DROP TABLE IF EXISTS `user_mission_03`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_mission_03` (
  `role_id` bigint(20) unsigned NOT NULL,
  `section_id` int(10) unsigned NOT NULL,
  `best_point` tinyint(4) DEFAULT NULL,
  `nattempt` int(10) unsigned NOT NULL DEFAULT '0',
  `npass` int(10) unsigned NOT NULL DEFAULT '0',
  `nfail` int(10) unsigned NOT NULL DEFAULT '0',
  `nwipe` int(10) unsigned NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime DEFAULT NULL,
  UNIQUE KEY `idx_rolesection` (`role_id`,`section_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_mission_04`
--

DROP TABLE IF EXISTS `user_mission_04`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_mission_04` (
  `role_id` bigint(20) unsigned NOT NULL,
  `section_id` int(10) unsigned NOT NULL,
  `best_point` tinyint(4) DEFAULT NULL,
  `nattempt` int(10) unsigned NOT NULL DEFAULT '0',
  `npass` int(10) unsigned NOT NULL DEFAULT '0',
  `nfail` int(10) unsigned NOT NULL DEFAULT '0',
  `nwipe` int(10) unsigned NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime DEFAULT NULL,
  UNIQUE KEY `idx_rolesection` (`role_id`,`section_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_mission_05`
--

DROP TABLE IF EXISTS `user_mission_05`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_mission_05` (
  `role_id` bigint(20) unsigned NOT NULL,
  `section_id` int(10) unsigned NOT NULL,
  `best_point` tinyint(4) DEFAULT NULL,
  `nattempt` int(10) unsigned NOT NULL DEFAULT '0',
  `npass` int(10) unsigned NOT NULL DEFAULT '0',
  `nfail` int(10) unsigned NOT NULL DEFAULT '0',
  `nwipe` int(10) unsigned NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime DEFAULT NULL,
  UNIQUE KEY `idx_rolesection` (`role_id`,`section_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_mission_06`
--

DROP TABLE IF EXISTS `user_mission_06`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_mission_06` (
  `role_id` bigint(20) unsigned NOT NULL,
  `section_id` int(10) unsigned NOT NULL,
  `best_point` tinyint(4) DEFAULT NULL,
  `nattempt` int(10) unsigned NOT NULL DEFAULT '0',
  `npass` int(10) unsigned NOT NULL DEFAULT '0',
  `nfail` int(10) unsigned NOT NULL DEFAULT '0',
  `nwipe` int(10) unsigned NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime DEFAULT NULL,
  UNIQUE KEY `idx_rolesection` (`role_id`,`section_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_mission_07`
--

DROP TABLE IF EXISTS `user_mission_07`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_mission_07` (
  `role_id` bigint(20) unsigned NOT NULL,
  `section_id` int(10) unsigned NOT NULL,
  `best_point` tinyint(4) DEFAULT NULL,
  `nattempt` int(10) unsigned NOT NULL DEFAULT '0',
  `npass` int(10) unsigned NOT NULL DEFAULT '0',
  `nfail` int(10) unsigned NOT NULL DEFAULT '0',
  `nwipe` int(10) unsigned NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime DEFAULT NULL,
  UNIQUE KEY `idx_rolesection` (`role_id`,`section_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_mission_08`
--

DROP TABLE IF EXISTS `user_mission_08`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_mission_08` (
  `role_id` bigint(20) unsigned NOT NULL,
  `section_id` int(10) unsigned NOT NULL,
  `best_point` tinyint(4) DEFAULT NULL,
  `nattempt` int(10) unsigned NOT NULL DEFAULT '0',
  `npass` int(10) unsigned NOT NULL DEFAULT '0',
  `nfail` int(10) unsigned NOT NULL DEFAULT '0',
  `nwipe` int(10) unsigned NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime DEFAULT NULL,
  UNIQUE KEY `idx_rolesection` (`role_id`,`section_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_mission_09`
--

DROP TABLE IF EXISTS `user_mission_09`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_mission_09` (
  `role_id` bigint(20) unsigned NOT NULL,
  `section_id` int(10) unsigned NOT NULL,
  `best_point` tinyint(4) DEFAULT NULL,
  `nattempt` int(10) unsigned NOT NULL DEFAULT '0',
  `npass` int(10) unsigned NOT NULL DEFAULT '0',
  `nfail` int(10) unsigned NOT NULL DEFAULT '0',
  `nwipe` int(10) unsigned NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime DEFAULT NULL,
  UNIQUE KEY `idx_rolesection` (`role_id`,`section_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_mission_10`
--

DROP TABLE IF EXISTS `user_mission_10`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_mission_10` (
  `role_id` bigint(20) unsigned NOT NULL,
  `section_id` int(10) unsigned NOT NULL,
  `best_point` tinyint(4) DEFAULT NULL,
  `nattempt` int(10) unsigned NOT NULL DEFAULT '0',
  `npass` int(10) unsigned NOT NULL DEFAULT '0',
  `nfail` int(10) unsigned NOT NULL DEFAULT '0',
  `nwipe` int(10) unsigned NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime DEFAULT NULL,
  UNIQUE KEY `idx_rolesection` (`role_id`,`section_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_mission_11`
--

DROP TABLE IF EXISTS `user_mission_11`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_mission_11` (
  `role_id` bigint(20) unsigned NOT NULL,
  `section_id` int(10) unsigned NOT NULL,
  `best_point` tinyint(4) DEFAULT NULL,
  `nattempt` int(10) unsigned NOT NULL DEFAULT '0',
  `npass` int(10) unsigned NOT NULL DEFAULT '0',
  `nfail` int(10) unsigned NOT NULL DEFAULT '0',
  `nwipe` int(10) unsigned NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime DEFAULT NULL,
  UNIQUE KEY `idx_rolesection` (`role_id`,`section_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_mission_12`
--

DROP TABLE IF EXISTS `user_mission_12`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_mission_12` (
  `role_id` bigint(20) unsigned NOT NULL,
  `section_id` int(10) unsigned NOT NULL,
  `best_point` tinyint(4) DEFAULT NULL,
  `nattempt` int(10) unsigned NOT NULL DEFAULT '0',
  `npass` int(10) unsigned NOT NULL DEFAULT '0',
  `nfail` int(10) unsigned NOT NULL DEFAULT '0',
  `nwipe` int(10) unsigned NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime DEFAULT NULL,
  UNIQUE KEY `idx_rolesection` (`role_id`,`section_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_mission_13`
--

DROP TABLE IF EXISTS `user_mission_13`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_mission_13` (
  `role_id` bigint(20) unsigned NOT NULL,
  `section_id` int(10) unsigned NOT NULL,
  `best_point` tinyint(4) DEFAULT NULL,
  `nattempt` int(10) unsigned NOT NULL DEFAULT '0',
  `npass` int(10) unsigned NOT NULL DEFAULT '0',
  `nfail` int(10) unsigned NOT NULL DEFAULT '0',
  `nwipe` int(10) unsigned NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime DEFAULT NULL,
  UNIQUE KEY `idx_rolesection` (`role_id`,`section_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_mission_14`
--

DROP TABLE IF EXISTS `user_mission_14`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_mission_14` (
  `role_id` bigint(20) unsigned NOT NULL,
  `section_id` int(10) unsigned NOT NULL,
  `best_point` tinyint(4) DEFAULT NULL,
  `nattempt` int(10) unsigned NOT NULL DEFAULT '0',
  `npass` int(10) unsigned NOT NULL DEFAULT '0',
  `nfail` int(10) unsigned NOT NULL DEFAULT '0',
  `nwipe` int(10) unsigned NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime DEFAULT NULL,
  UNIQUE KEY `idx_rolesection` (`role_id`,`section_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_mission_15`
--

DROP TABLE IF EXISTS `user_mission_15`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_mission_15` (
  `role_id` bigint(20) unsigned NOT NULL,
  `section_id` int(10) unsigned NOT NULL,
  `best_point` tinyint(4) DEFAULT NULL,
  `nattempt` int(10) unsigned NOT NULL DEFAULT '0',
  `npass` int(10) unsigned NOT NULL DEFAULT '0',
  `nfail` int(10) unsigned NOT NULL DEFAULT '0',
  `nwipe` int(10) unsigned NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime DEFAULT NULL,
  UNIQUE KEY `idx_rolesection` (`role_id`,`section_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_mission_16`
--

DROP TABLE IF EXISTS `user_mission_16`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_mission_16` (
  `role_id` bigint(20) unsigned NOT NULL,
  `section_id` int(10) unsigned NOT NULL,
  `best_point` tinyint(4) DEFAULT NULL,
  `nattempt` int(10) unsigned NOT NULL DEFAULT '0',
  `npass` int(10) unsigned NOT NULL DEFAULT '0',
  `nfail` int(10) unsigned NOT NULL DEFAULT '0',
  `nwipe` int(10) unsigned NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime DEFAULT NULL,
  UNIQUE KEY `idx_rolesection` (`role_id`,`section_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_mission_17`
--

DROP TABLE IF EXISTS `user_mission_17`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_mission_17` (
  `role_id` bigint(20) unsigned NOT NULL,
  `section_id` int(10) unsigned NOT NULL,
  `best_point` tinyint(4) DEFAULT NULL,
  `nattempt` int(10) unsigned NOT NULL DEFAULT '0',
  `npass` int(10) unsigned NOT NULL DEFAULT '0',
  `nfail` int(10) unsigned NOT NULL DEFAULT '0',
  `nwipe` int(10) unsigned NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime DEFAULT NULL,
  UNIQUE KEY `idx_rolesection` (`role_id`,`section_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_mission_18`
--

DROP TABLE IF EXISTS `user_mission_18`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_mission_18` (
  `role_id` bigint(20) unsigned NOT NULL,
  `section_id` int(10) unsigned NOT NULL,
  `best_point` tinyint(4) DEFAULT NULL,
  `nattempt` int(10) unsigned NOT NULL DEFAULT '0',
  `npass` int(10) unsigned NOT NULL DEFAULT '0',
  `nfail` int(10) unsigned NOT NULL DEFAULT '0',
  `nwipe` int(10) unsigned NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime DEFAULT NULL,
  UNIQUE KEY `idx_rolesection` (`role_id`,`section_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_mission_19`
--

DROP TABLE IF EXISTS `user_mission_19`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_mission_19` (
  `role_id` bigint(20) unsigned NOT NULL,
  `section_id` int(10) unsigned NOT NULL,
  `best_point` tinyint(4) DEFAULT NULL,
  `nattempt` int(10) unsigned NOT NULL DEFAULT '0',
  `npass` int(10) unsigned NOT NULL DEFAULT '0',
  `nfail` int(10) unsigned NOT NULL DEFAULT '0',
  `nwipe` int(10) unsigned NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime DEFAULT NULL,
  UNIQUE KEY `idx_rolesection` (`role_id`,`section_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_mission_20`
--

DROP TABLE IF EXISTS `user_mission_20`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_mission_20` (
  `role_id` bigint(20) unsigned NOT NULL,
  `section_id` int(10) unsigned NOT NULL,
  `best_point` tinyint(4) DEFAULT NULL,
  `nattempt` int(10) unsigned NOT NULL DEFAULT '0',
  `npass` int(10) unsigned NOT NULL DEFAULT '0',
  `nfail` int(10) unsigned NOT NULL DEFAULT '0',
  `nwipe` int(10) unsigned NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime DEFAULT NULL,
  UNIQUE KEY `idx_rolesection` (`role_id`,`section_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_mission_21`
--

DROP TABLE IF EXISTS `user_mission_21`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_mission_21` (
  `role_id` bigint(20) unsigned NOT NULL,
  `section_id` int(10) unsigned NOT NULL,
  `best_point` tinyint(4) DEFAULT NULL,
  `nattempt` int(10) unsigned NOT NULL DEFAULT '0',
  `npass` int(10) unsigned NOT NULL DEFAULT '0',
  `nfail` int(10) unsigned NOT NULL DEFAULT '0',
  `nwipe` int(10) unsigned NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime DEFAULT NULL,
  UNIQUE KEY `idx_rolesection` (`role_id`,`section_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_mission_22`
--

DROP TABLE IF EXISTS `user_mission_22`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_mission_22` (
  `role_id` bigint(20) unsigned NOT NULL,
  `section_id` int(10) unsigned NOT NULL,
  `best_point` tinyint(4) DEFAULT NULL,
  `nattempt` int(10) unsigned NOT NULL DEFAULT '0',
  `npass` int(10) unsigned NOT NULL DEFAULT '0',
  `nfail` int(10) unsigned NOT NULL DEFAULT '0',
  `nwipe` int(10) unsigned NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime DEFAULT NULL,
  UNIQUE KEY `idx_rolesection` (`role_id`,`section_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_mission_23`
--

DROP TABLE IF EXISTS `user_mission_23`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_mission_23` (
  `role_id` bigint(20) unsigned NOT NULL,
  `section_id` int(10) unsigned NOT NULL,
  `best_point` tinyint(4) DEFAULT NULL,
  `nattempt` int(10) unsigned NOT NULL DEFAULT '0',
  `npass` int(10) unsigned NOT NULL DEFAULT '0',
  `nfail` int(10) unsigned NOT NULL DEFAULT '0',
  `nwipe` int(10) unsigned NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime DEFAULT NULL,
  UNIQUE KEY `idx_rolesection` (`role_id`,`section_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_mission_24`
--

DROP TABLE IF EXISTS `user_mission_24`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_mission_24` (
  `role_id` bigint(20) unsigned NOT NULL,
  `section_id` int(10) unsigned NOT NULL,
  `best_point` tinyint(4) DEFAULT NULL,
  `nattempt` int(10) unsigned NOT NULL DEFAULT '0',
  `npass` int(10) unsigned NOT NULL DEFAULT '0',
  `nfail` int(10) unsigned NOT NULL DEFAULT '0',
  `nwipe` int(10) unsigned NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime DEFAULT NULL,
  UNIQUE KEY `idx_rolesection` (`role_id`,`section_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_mission_25`
--

DROP TABLE IF EXISTS `user_mission_25`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_mission_25` (
  `role_id` bigint(20) unsigned NOT NULL,
  `section_id` int(10) unsigned NOT NULL,
  `best_point` tinyint(4) DEFAULT NULL,
  `nattempt` int(10) unsigned NOT NULL DEFAULT '0',
  `npass` int(10) unsigned NOT NULL DEFAULT '0',
  `nfail` int(10) unsigned NOT NULL DEFAULT '0',
  `nwipe` int(10) unsigned NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime DEFAULT NULL,
  UNIQUE KEY `idx_rolesection` (`role_id`,`section_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_mission_26`
--

DROP TABLE IF EXISTS `user_mission_26`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_mission_26` (
  `role_id` bigint(20) unsigned NOT NULL,
  `section_id` int(10) unsigned NOT NULL,
  `best_point` tinyint(4) DEFAULT NULL,
  `nattempt` int(10) unsigned NOT NULL DEFAULT '0',
  `npass` int(10) unsigned NOT NULL DEFAULT '0',
  `nfail` int(10) unsigned NOT NULL DEFAULT '0',
  `nwipe` int(10) unsigned NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime DEFAULT NULL,
  UNIQUE KEY `idx_rolesection` (`role_id`,`section_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_mission_27`
--

DROP TABLE IF EXISTS `user_mission_27`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_mission_27` (
  `role_id` bigint(20) unsigned NOT NULL,
  `section_id` int(10) unsigned NOT NULL,
  `best_point` tinyint(4) DEFAULT NULL,
  `nattempt` int(10) unsigned NOT NULL DEFAULT '0',
  `npass` int(10) unsigned NOT NULL DEFAULT '0',
  `nfail` int(10) unsigned NOT NULL DEFAULT '0',
  `nwipe` int(10) unsigned NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime DEFAULT NULL,
  UNIQUE KEY `idx_rolesection` (`role_id`,`section_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_mission_28`
--

DROP TABLE IF EXISTS `user_mission_28`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_mission_28` (
  `role_id` bigint(20) unsigned NOT NULL,
  `section_id` int(10) unsigned NOT NULL,
  `best_point` tinyint(4) DEFAULT NULL,
  `nattempt` int(10) unsigned NOT NULL DEFAULT '0',
  `npass` int(10) unsigned NOT NULL DEFAULT '0',
  `nfail` int(10) unsigned NOT NULL DEFAULT '0',
  `nwipe` int(10) unsigned NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime DEFAULT NULL,
  UNIQUE KEY `idx_rolesection` (`role_id`,`section_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_mission_29`
--

DROP TABLE IF EXISTS `user_mission_29`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_mission_29` (
  `role_id` bigint(20) unsigned NOT NULL,
  `section_id` int(10) unsigned NOT NULL,
  `best_point` tinyint(4) DEFAULT NULL,
  `nattempt` int(10) unsigned NOT NULL DEFAULT '0',
  `npass` int(10) unsigned NOT NULL DEFAULT '0',
  `nfail` int(10) unsigned NOT NULL DEFAULT '0',
  `nwipe` int(10) unsigned NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime DEFAULT NULL,
  UNIQUE KEY `idx_rolesection` (`role_id`,`section_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_mission_30`
--

DROP TABLE IF EXISTS `user_mission_30`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_mission_30` (
  `role_id` bigint(20) unsigned NOT NULL,
  `section_id` int(10) unsigned NOT NULL,
  `best_point` tinyint(4) DEFAULT NULL,
  `nattempt` int(10) unsigned NOT NULL DEFAULT '0',
  `npass` int(10) unsigned NOT NULL DEFAULT '0',
  `nfail` int(10) unsigned NOT NULL DEFAULT '0',
  `nwipe` int(10) unsigned NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime DEFAULT NULL,
  UNIQUE KEY `idx_rolesection` (`role_id`,`section_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_mission_31`
--

DROP TABLE IF EXISTS `user_mission_31`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_mission_31` (
  `role_id` bigint(20) unsigned NOT NULL,
  `section_id` int(10) unsigned NOT NULL,
  `best_point` tinyint(4) DEFAULT NULL,
  `nattempt` int(10) unsigned NOT NULL DEFAULT '0',
  `npass` int(10) unsigned NOT NULL DEFAULT '0',
  `nfail` int(10) unsigned NOT NULL DEFAULT '0',
  `nwipe` int(10) unsigned NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime DEFAULT NULL,
  UNIQUE KEY `idx_rolesection` (`role_id`,`section_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_mission_32`
--

DROP TABLE IF EXISTS `user_mission_32`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_mission_32` (
  `role_id` bigint(20) unsigned NOT NULL,
  `section_id` int(10) unsigned NOT NULL,
  `best_point` tinyint(4) DEFAULT NULL,
  `nattempt` int(10) unsigned NOT NULL DEFAULT '0',
  `npass` int(10) unsigned NOT NULL DEFAULT '0',
  `nfail` int(10) unsigned NOT NULL DEFAULT '0',
  `nwipe` int(10) unsigned NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime DEFAULT NULL,
  UNIQUE KEY `idx_rolesection` (`role_id`,`section_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_mission_33`
--

DROP TABLE IF EXISTS `user_mission_33`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_mission_33` (
  `role_id` bigint(20) unsigned NOT NULL,
  `section_id` int(10) unsigned NOT NULL,
  `best_point` tinyint(4) DEFAULT NULL,
  `nattempt` int(10) unsigned NOT NULL DEFAULT '0',
  `npass` int(10) unsigned NOT NULL DEFAULT '0',
  `nfail` int(10) unsigned NOT NULL DEFAULT '0',
  `nwipe` int(10) unsigned NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime DEFAULT NULL,
  UNIQUE KEY `idx_rolesection` (`role_id`,`section_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_mission_34`
--

DROP TABLE IF EXISTS `user_mission_34`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_mission_34` (
  `role_id` bigint(20) unsigned NOT NULL,
  `section_id` int(10) unsigned NOT NULL,
  `best_point` tinyint(4) DEFAULT NULL,
  `nattempt` int(10) unsigned NOT NULL DEFAULT '0',
  `npass` int(10) unsigned NOT NULL DEFAULT '0',
  `nfail` int(10) unsigned NOT NULL DEFAULT '0',
  `nwipe` int(10) unsigned NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime DEFAULT NULL,
  UNIQUE KEY `idx_rolesection` (`role_id`,`section_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_mission_35`
--

DROP TABLE IF EXISTS `user_mission_35`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_mission_35` (
  `role_id` bigint(20) unsigned NOT NULL,
  `section_id` int(10) unsigned NOT NULL,
  `best_point` tinyint(4) DEFAULT NULL,
  `nattempt` int(10) unsigned NOT NULL DEFAULT '0',
  `npass` int(10) unsigned NOT NULL DEFAULT '0',
  `nfail` int(10) unsigned NOT NULL DEFAULT '0',
  `nwipe` int(10) unsigned NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime DEFAULT NULL,
  UNIQUE KEY `idx_rolesection` (`role_id`,`section_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_mission_36`
--

DROP TABLE IF EXISTS `user_mission_36`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_mission_36` (
  `role_id` bigint(20) unsigned NOT NULL,
  `section_id` int(10) unsigned NOT NULL,
  `best_point` tinyint(4) DEFAULT NULL,
  `nattempt` int(10) unsigned NOT NULL DEFAULT '0',
  `npass` int(10) unsigned NOT NULL DEFAULT '0',
  `nfail` int(10) unsigned NOT NULL DEFAULT '0',
  `nwipe` int(10) unsigned NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime DEFAULT NULL,
  UNIQUE KEY `idx_rolesection` (`role_id`,`section_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_mission_37`
--

DROP TABLE IF EXISTS `user_mission_37`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_mission_37` (
  `role_id` bigint(20) unsigned NOT NULL,
  `section_id` int(10) unsigned NOT NULL,
  `best_point` tinyint(4) DEFAULT NULL,
  `nattempt` int(10) unsigned NOT NULL DEFAULT '0',
  `npass` int(10) unsigned NOT NULL DEFAULT '0',
  `nfail` int(10) unsigned NOT NULL DEFAULT '0',
  `nwipe` int(10) unsigned NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime DEFAULT NULL,
  UNIQUE KEY `idx_rolesection` (`role_id`,`section_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_mission_38`
--

DROP TABLE IF EXISTS `user_mission_38`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_mission_38` (
  `role_id` bigint(20) unsigned NOT NULL,
  `section_id` int(10) unsigned NOT NULL,
  `best_point` tinyint(4) DEFAULT NULL,
  `nattempt` int(10) unsigned NOT NULL DEFAULT '0',
  `npass` int(10) unsigned NOT NULL DEFAULT '0',
  `nfail` int(10) unsigned NOT NULL DEFAULT '0',
  `nwipe` int(10) unsigned NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime DEFAULT NULL,
  UNIQUE KEY `idx_rolesection` (`role_id`,`section_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_mission_39`
--

DROP TABLE IF EXISTS `user_mission_39`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_mission_39` (
  `role_id` bigint(20) unsigned NOT NULL,
  `section_id` int(10) unsigned NOT NULL,
  `best_point` tinyint(4) DEFAULT NULL,
  `nattempt` int(10) unsigned NOT NULL DEFAULT '0',
  `npass` int(10) unsigned NOT NULL DEFAULT '0',
  `nfail` int(10) unsigned NOT NULL DEFAULT '0',
  `nwipe` int(10) unsigned NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime DEFAULT NULL,
  UNIQUE KEY `idx_rolesection` (`role_id`,`section_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_mission_40`
--

DROP TABLE IF EXISTS `user_mission_40`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_mission_40` (
  `role_id` bigint(20) unsigned NOT NULL,
  `section_id` int(10) unsigned NOT NULL,
  `best_point` tinyint(4) DEFAULT NULL,
  `nattempt` int(10) unsigned NOT NULL DEFAULT '0',
  `npass` int(10) unsigned NOT NULL DEFAULT '0',
  `nfail` int(10) unsigned NOT NULL DEFAULT '0',
  `nwipe` int(10) unsigned NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime DEFAULT NULL,
  UNIQUE KEY `idx_rolesection` (`role_id`,`section_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_mission_41`
--

DROP TABLE IF EXISTS `user_mission_41`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_mission_41` (
  `role_id` bigint(20) unsigned NOT NULL,
  `section_id` int(10) unsigned NOT NULL,
  `best_point` tinyint(4) DEFAULT NULL,
  `nattempt` int(10) unsigned NOT NULL DEFAULT '0',
  `npass` int(10) unsigned NOT NULL DEFAULT '0',
  `nfail` int(10) unsigned NOT NULL DEFAULT '0',
  `nwipe` int(10) unsigned NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime DEFAULT NULL,
  UNIQUE KEY `idx_rolesection` (`role_id`,`section_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_mission_42`
--

DROP TABLE IF EXISTS `user_mission_42`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_mission_42` (
  `role_id` bigint(20) unsigned NOT NULL,
  `section_id` int(10) unsigned NOT NULL,
  `best_point` tinyint(4) DEFAULT NULL,
  `nattempt` int(10) unsigned NOT NULL DEFAULT '0',
  `npass` int(10) unsigned NOT NULL DEFAULT '0',
  `nfail` int(10) unsigned NOT NULL DEFAULT '0',
  `nwipe` int(10) unsigned NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime DEFAULT NULL,
  UNIQUE KEY `idx_rolesection` (`role_id`,`section_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_mission_43`
--

DROP TABLE IF EXISTS `user_mission_43`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_mission_43` (
  `role_id` bigint(20) unsigned NOT NULL,
  `section_id` int(10) unsigned NOT NULL,
  `best_point` tinyint(4) DEFAULT NULL,
  `nattempt` int(10) unsigned NOT NULL DEFAULT '0',
  `npass` int(10) unsigned NOT NULL DEFAULT '0',
  `nfail` int(10) unsigned NOT NULL DEFAULT '0',
  `nwipe` int(10) unsigned NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime DEFAULT NULL,
  UNIQUE KEY `idx_rolesection` (`role_id`,`section_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_mission_44`
--

DROP TABLE IF EXISTS `user_mission_44`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_mission_44` (
  `role_id` bigint(20) unsigned NOT NULL,
  `section_id` int(10) unsigned NOT NULL,
  `best_point` tinyint(4) DEFAULT NULL,
  `nattempt` int(10) unsigned NOT NULL DEFAULT '0',
  `npass` int(10) unsigned NOT NULL DEFAULT '0',
  `nfail` int(10) unsigned NOT NULL DEFAULT '0',
  `nwipe` int(10) unsigned NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime DEFAULT NULL,
  UNIQUE KEY `idx_rolesection` (`role_id`,`section_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_mission_45`
--

DROP TABLE IF EXISTS `user_mission_45`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_mission_45` (
  `role_id` bigint(20) unsigned NOT NULL,
  `section_id` int(10) unsigned NOT NULL,
  `best_point` tinyint(4) DEFAULT NULL,
  `nattempt` int(10) unsigned NOT NULL DEFAULT '0',
  `npass` int(10) unsigned NOT NULL DEFAULT '0',
  `nfail` int(10) unsigned NOT NULL DEFAULT '0',
  `nwipe` int(10) unsigned NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime DEFAULT NULL,
  UNIQUE KEY `idx_rolesection` (`role_id`,`section_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_mission_46`
--

DROP TABLE IF EXISTS `user_mission_46`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_mission_46` (
  `role_id` bigint(20) unsigned NOT NULL,
  `section_id` int(10) unsigned NOT NULL,
  `best_point` tinyint(4) DEFAULT NULL,
  `nattempt` int(10) unsigned NOT NULL DEFAULT '0',
  `npass` int(10) unsigned NOT NULL DEFAULT '0',
  `nfail` int(10) unsigned NOT NULL DEFAULT '0',
  `nwipe` int(10) unsigned NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime DEFAULT NULL,
  UNIQUE KEY `idx_rolesection` (`role_id`,`section_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_mission_47`
--

DROP TABLE IF EXISTS `user_mission_47`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_mission_47` (
  `role_id` bigint(20) unsigned NOT NULL,
  `section_id` int(10) unsigned NOT NULL,
  `best_point` tinyint(4) DEFAULT NULL,
  `nattempt` int(10) unsigned NOT NULL DEFAULT '0',
  `npass` int(10) unsigned NOT NULL DEFAULT '0',
  `nfail` int(10) unsigned NOT NULL DEFAULT '0',
  `nwipe` int(10) unsigned NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime DEFAULT NULL,
  UNIQUE KEY `idx_rolesection` (`role_id`,`section_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_mission_48`
--

DROP TABLE IF EXISTS `user_mission_48`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_mission_48` (
  `role_id` bigint(20) unsigned NOT NULL,
  `section_id` int(10) unsigned NOT NULL,
  `best_point` tinyint(4) DEFAULT NULL,
  `nattempt` int(10) unsigned NOT NULL DEFAULT '0',
  `npass` int(10) unsigned NOT NULL DEFAULT '0',
  `nfail` int(10) unsigned NOT NULL DEFAULT '0',
  `nwipe` int(10) unsigned NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime DEFAULT NULL,
  UNIQUE KEY `idx_rolesection` (`role_id`,`section_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_mission_49`
--

DROP TABLE IF EXISTS `user_mission_49`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_mission_49` (
  `role_id` bigint(20) unsigned NOT NULL,
  `section_id` int(10) unsigned NOT NULL,
  `best_point` tinyint(4) DEFAULT NULL,
  `nattempt` int(10) unsigned NOT NULL DEFAULT '0',
  `npass` int(10) unsigned NOT NULL DEFAULT '0',
  `nfail` int(10) unsigned NOT NULL DEFAULT '0',
  `nwipe` int(10) unsigned NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime DEFAULT NULL,
  UNIQUE KEY `idx_rolesection` (`role_id`,`section_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_mission_50`
--

DROP TABLE IF EXISTS `user_mission_50`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_mission_50` (
  `role_id` bigint(20) unsigned NOT NULL,
  `section_id` int(10) unsigned NOT NULL,
  `best_point` tinyint(4) DEFAULT NULL,
  `nattempt` int(10) unsigned NOT NULL DEFAULT '0',
  `npass` int(10) unsigned NOT NULL DEFAULT '0',
  `nfail` int(10) unsigned NOT NULL DEFAULT '0',
  `nwipe` int(10) unsigned NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime DEFAULT NULL,
  UNIQUE KEY `idx_rolesection` (`role_id`,`section_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_mission_51`
--

DROP TABLE IF EXISTS `user_mission_51`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_mission_51` (
  `role_id` bigint(20) unsigned NOT NULL,
  `section_id` int(10) unsigned NOT NULL,
  `best_point` tinyint(4) DEFAULT NULL,
  `nattempt` int(10) unsigned NOT NULL DEFAULT '0',
  `npass` int(10) unsigned NOT NULL DEFAULT '0',
  `nfail` int(10) unsigned NOT NULL DEFAULT '0',
  `nwipe` int(10) unsigned NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime DEFAULT NULL,
  UNIQUE KEY `idx_rolesection` (`role_id`,`section_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_mission_52`
--

DROP TABLE IF EXISTS `user_mission_52`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_mission_52` (
  `role_id` bigint(20) unsigned NOT NULL,
  `section_id` int(10) unsigned NOT NULL,
  `best_point` tinyint(4) DEFAULT NULL,
  `nattempt` int(10) unsigned NOT NULL DEFAULT '0',
  `npass` int(10) unsigned NOT NULL DEFAULT '0',
  `nfail` int(10) unsigned NOT NULL DEFAULT '0',
  `nwipe` int(10) unsigned NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime DEFAULT NULL,
  UNIQUE KEY `idx_rolesection` (`role_id`,`section_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_mission_53`
--

DROP TABLE IF EXISTS `user_mission_53`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_mission_53` (
  `role_id` bigint(20) unsigned NOT NULL,
  `section_id` int(10) unsigned NOT NULL,
  `best_point` tinyint(4) DEFAULT NULL,
  `nattempt` int(10) unsigned NOT NULL DEFAULT '0',
  `npass` int(10) unsigned NOT NULL DEFAULT '0',
  `nfail` int(10) unsigned NOT NULL DEFAULT '0',
  `nwipe` int(10) unsigned NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime DEFAULT NULL,
  UNIQUE KEY `idx_rolesection` (`role_id`,`section_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_mission_54`
--

DROP TABLE IF EXISTS `user_mission_54`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_mission_54` (
  `role_id` bigint(20) unsigned NOT NULL,
  `section_id` int(10) unsigned NOT NULL,
  `best_point` tinyint(4) DEFAULT NULL,
  `nattempt` int(10) unsigned NOT NULL DEFAULT '0',
  `npass` int(10) unsigned NOT NULL DEFAULT '0',
  `nfail` int(10) unsigned NOT NULL DEFAULT '0',
  `nwipe` int(10) unsigned NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime DEFAULT NULL,
  UNIQUE KEY `idx_rolesection` (`role_id`,`section_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_mission_55`
--

DROP TABLE IF EXISTS `user_mission_55`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_mission_55` (
  `role_id` bigint(20) unsigned NOT NULL,
  `section_id` int(10) unsigned NOT NULL,
  `best_point` tinyint(4) DEFAULT NULL,
  `nattempt` int(10) unsigned NOT NULL DEFAULT '0',
  `npass` int(10) unsigned NOT NULL DEFAULT '0',
  `nfail` int(10) unsigned NOT NULL DEFAULT '0',
  `nwipe` int(10) unsigned NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime DEFAULT NULL,
  UNIQUE KEY `idx_rolesection` (`role_id`,`section_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_mission_56`
--

DROP TABLE IF EXISTS `user_mission_56`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_mission_56` (
  `role_id` bigint(20) unsigned NOT NULL,
  `section_id` int(10) unsigned NOT NULL,
  `best_point` tinyint(4) DEFAULT NULL,
  `nattempt` int(10) unsigned NOT NULL DEFAULT '0',
  `npass` int(10) unsigned NOT NULL DEFAULT '0',
  `nfail` int(10) unsigned NOT NULL DEFAULT '0',
  `nwipe` int(10) unsigned NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime DEFAULT NULL,
  UNIQUE KEY `idx_rolesection` (`role_id`,`section_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_mission_57`
--

DROP TABLE IF EXISTS `user_mission_57`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_mission_57` (
  `role_id` bigint(20) unsigned NOT NULL,
  `section_id` int(10) unsigned NOT NULL,
  `best_point` tinyint(4) DEFAULT NULL,
  `nattempt` int(10) unsigned NOT NULL DEFAULT '0',
  `npass` int(10) unsigned NOT NULL DEFAULT '0',
  `nfail` int(10) unsigned NOT NULL DEFAULT '0',
  `nwipe` int(10) unsigned NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime DEFAULT NULL,
  UNIQUE KEY `idx_rolesection` (`role_id`,`section_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_mission_58`
--

DROP TABLE IF EXISTS `user_mission_58`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_mission_58` (
  `role_id` bigint(20) unsigned NOT NULL,
  `section_id` int(10) unsigned NOT NULL,
  `best_point` tinyint(4) DEFAULT NULL,
  `nattempt` int(10) unsigned NOT NULL DEFAULT '0',
  `npass` int(10) unsigned NOT NULL DEFAULT '0',
  `nfail` int(10) unsigned NOT NULL DEFAULT '0',
  `nwipe` int(10) unsigned NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime DEFAULT NULL,
  UNIQUE KEY `idx_rolesection` (`role_id`,`section_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_mission_59`
--

DROP TABLE IF EXISTS `user_mission_59`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_mission_59` (
  `role_id` bigint(20) unsigned NOT NULL,
  `section_id` int(10) unsigned NOT NULL,
  `best_point` tinyint(4) DEFAULT NULL,
  `nattempt` int(10) unsigned NOT NULL DEFAULT '0',
  `npass` int(10) unsigned NOT NULL DEFAULT '0',
  `nfail` int(10) unsigned NOT NULL DEFAULT '0',
  `nwipe` int(10) unsigned NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime DEFAULT NULL,
  UNIQUE KEY `idx_rolesection` (`role_id`,`section_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_mission_60`
--

DROP TABLE IF EXISTS `user_mission_60`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_mission_60` (
  `role_id` bigint(20) unsigned NOT NULL,
  `section_id` int(10) unsigned NOT NULL,
  `best_point` tinyint(4) DEFAULT NULL,
  `nattempt` int(10) unsigned NOT NULL DEFAULT '0',
  `npass` int(10) unsigned NOT NULL DEFAULT '0',
  `nfail` int(10) unsigned NOT NULL DEFAULT '0',
  `nwipe` int(10) unsigned NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime DEFAULT NULL,
  UNIQUE KEY `idx_rolesection` (`role_id`,`section_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_mission_61`
--

DROP TABLE IF EXISTS `user_mission_61`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_mission_61` (
  `role_id` bigint(20) unsigned NOT NULL,
  `section_id` int(10) unsigned NOT NULL,
  `best_point` tinyint(4) DEFAULT NULL,
  `nattempt` int(10) unsigned NOT NULL DEFAULT '0',
  `npass` int(10) unsigned NOT NULL DEFAULT '0',
  `nfail` int(10) unsigned NOT NULL DEFAULT '0',
  `nwipe` int(10) unsigned NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime DEFAULT NULL,
  UNIQUE KEY `idx_rolesection` (`role_id`,`section_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_mission_62`
--

DROP TABLE IF EXISTS `user_mission_62`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_mission_62` (
  `role_id` bigint(20) unsigned NOT NULL,
  `section_id` int(10) unsigned NOT NULL,
  `best_point` tinyint(4) DEFAULT NULL,
  `nattempt` int(10) unsigned NOT NULL DEFAULT '0',
  `npass` int(10) unsigned NOT NULL DEFAULT '0',
  `nfail` int(10) unsigned NOT NULL DEFAULT '0',
  `nwipe` int(10) unsigned NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime DEFAULT NULL,
  UNIQUE KEY `idx_rolesection` (`role_id`,`section_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_mission_63`
--

DROP TABLE IF EXISTS `user_mission_63`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_mission_63` (
  `role_id` bigint(20) unsigned NOT NULL,
  `section_id` int(10) unsigned NOT NULL,
  `best_point` tinyint(4) DEFAULT NULL,
  `nattempt` int(10) unsigned NOT NULL DEFAULT '0',
  `npass` int(10) unsigned NOT NULL DEFAULT '0',
  `nfail` int(10) unsigned NOT NULL DEFAULT '0',
  `nwipe` int(10) unsigned NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime DEFAULT NULL,
  UNIQUE KEY `idx_rolesection` (`role_id`,`section_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_mission_64`
--

DROP TABLE IF EXISTS `user_mission_64`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_mission_64` (
  `role_id` bigint(20) unsigned NOT NULL,
  `section_id` int(10) unsigned NOT NULL,
  `best_point` tinyint(4) DEFAULT NULL,
  `nattempt` int(10) unsigned NOT NULL DEFAULT '0',
  `npass` int(10) unsigned NOT NULL DEFAULT '0',
  `nfail` int(10) unsigned NOT NULL DEFAULT '0',
  `nwipe` int(10) unsigned NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime DEFAULT NULL,
  UNIQUE KEY `idx_rolesection` (`role_id`,`section_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_mission_65`
--

DROP TABLE IF EXISTS `user_mission_65`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_mission_65` (
  `role_id` bigint(20) unsigned NOT NULL,
  `section_id` int(10) unsigned NOT NULL,
  `best_point` tinyint(4) DEFAULT NULL,
  `nattempt` int(10) unsigned NOT NULL DEFAULT '0',
  `npass` int(10) unsigned NOT NULL DEFAULT '0',
  `nfail` int(10) unsigned NOT NULL DEFAULT '0',
  `nwipe` int(10) unsigned NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime DEFAULT NULL,
  UNIQUE KEY `idx_rolesection` (`role_id`,`section_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_mission_66`
--

DROP TABLE IF EXISTS `user_mission_66`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_mission_66` (
  `role_id` bigint(20) unsigned NOT NULL,
  `section_id` int(10) unsigned NOT NULL,
  `best_point` tinyint(4) DEFAULT NULL,
  `nattempt` int(10) unsigned NOT NULL DEFAULT '0',
  `npass` int(10) unsigned NOT NULL DEFAULT '0',
  `nfail` int(10) unsigned NOT NULL DEFAULT '0',
  `nwipe` int(10) unsigned NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime DEFAULT NULL,
  UNIQUE KEY `idx_rolesection` (`role_id`,`section_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_mission_67`
--

DROP TABLE IF EXISTS `user_mission_67`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_mission_67` (
  `role_id` bigint(20) unsigned NOT NULL,
  `section_id` int(10) unsigned NOT NULL,
  `best_point` tinyint(4) DEFAULT NULL,
  `nattempt` int(10) unsigned NOT NULL DEFAULT '0',
  `npass` int(10) unsigned NOT NULL DEFAULT '0',
  `nfail` int(10) unsigned NOT NULL DEFAULT '0',
  `nwipe` int(10) unsigned NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime DEFAULT NULL,
  UNIQUE KEY `idx_rolesection` (`role_id`,`section_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_mission_68`
--

DROP TABLE IF EXISTS `user_mission_68`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_mission_68` (
  `role_id` bigint(20) unsigned NOT NULL,
  `section_id` int(10) unsigned NOT NULL,
  `best_point` tinyint(4) DEFAULT NULL,
  `nattempt` int(10) unsigned NOT NULL DEFAULT '0',
  `npass` int(10) unsigned NOT NULL DEFAULT '0',
  `nfail` int(10) unsigned NOT NULL DEFAULT '0',
  `nwipe` int(10) unsigned NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime DEFAULT NULL,
  UNIQUE KEY `idx_rolesection` (`role_id`,`section_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_mission_69`
--

DROP TABLE IF EXISTS `user_mission_69`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_mission_69` (
  `role_id` bigint(20) unsigned NOT NULL,
  `section_id` int(10) unsigned NOT NULL,
  `best_point` tinyint(4) DEFAULT NULL,
  `nattempt` int(10) unsigned NOT NULL DEFAULT '0',
  `npass` int(10) unsigned NOT NULL DEFAULT '0',
  `nfail` int(10) unsigned NOT NULL DEFAULT '0',
  `nwipe` int(10) unsigned NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime DEFAULT NULL,
  UNIQUE KEY `idx_rolesection` (`role_id`,`section_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_mission_70`
--

DROP TABLE IF EXISTS `user_mission_70`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_mission_70` (
  `role_id` bigint(20) unsigned NOT NULL,
  `section_id` int(10) unsigned NOT NULL,
  `best_point` tinyint(4) DEFAULT NULL,
  `nattempt` int(10) unsigned NOT NULL DEFAULT '0',
  `npass` int(10) unsigned NOT NULL DEFAULT '0',
  `nfail` int(10) unsigned NOT NULL DEFAULT '0',
  `nwipe` int(10) unsigned NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime DEFAULT NULL,
  UNIQUE KEY `idx_rolesection` (`role_id`,`section_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_mission_71`
--

DROP TABLE IF EXISTS `user_mission_71`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_mission_71` (
  `role_id` bigint(20) unsigned NOT NULL,
  `section_id` int(10) unsigned NOT NULL,
  `best_point` tinyint(4) DEFAULT NULL,
  `nattempt` int(10) unsigned NOT NULL DEFAULT '0',
  `npass` int(10) unsigned NOT NULL DEFAULT '0',
  `nfail` int(10) unsigned NOT NULL DEFAULT '0',
  `nwipe` int(10) unsigned NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime DEFAULT NULL,
  UNIQUE KEY `idx_rolesection` (`role_id`,`section_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_mission_72`
--

DROP TABLE IF EXISTS `user_mission_72`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_mission_72` (
  `role_id` bigint(20) unsigned NOT NULL,
  `section_id` int(10) unsigned NOT NULL,
  `best_point` tinyint(4) DEFAULT NULL,
  `nattempt` int(10) unsigned NOT NULL DEFAULT '0',
  `npass` int(10) unsigned NOT NULL DEFAULT '0',
  `nfail` int(10) unsigned NOT NULL DEFAULT '0',
  `nwipe` int(10) unsigned NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime DEFAULT NULL,
  UNIQUE KEY `idx_rolesection` (`role_id`,`section_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_mission_73`
--

DROP TABLE IF EXISTS `user_mission_73`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_mission_73` (
  `role_id` bigint(20) unsigned NOT NULL,
  `section_id` int(10) unsigned NOT NULL,
  `best_point` tinyint(4) DEFAULT NULL,
  `nattempt` int(10) unsigned NOT NULL DEFAULT '0',
  `npass` int(10) unsigned NOT NULL DEFAULT '0',
  `nfail` int(10) unsigned NOT NULL DEFAULT '0',
  `nwipe` int(10) unsigned NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime DEFAULT NULL,
  UNIQUE KEY `idx_rolesection` (`role_id`,`section_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_mission_74`
--

DROP TABLE IF EXISTS `user_mission_74`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_mission_74` (
  `role_id` bigint(20) unsigned NOT NULL,
  `section_id` int(10) unsigned NOT NULL,
  `best_point` tinyint(4) DEFAULT NULL,
  `nattempt` int(10) unsigned NOT NULL DEFAULT '0',
  `npass` int(10) unsigned NOT NULL DEFAULT '0',
  `nfail` int(10) unsigned NOT NULL DEFAULT '0',
  `nwipe` int(10) unsigned NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime DEFAULT NULL,
  UNIQUE KEY `idx_rolesection` (`role_id`,`section_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_mission_75`
--

DROP TABLE IF EXISTS `user_mission_75`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_mission_75` (
  `role_id` bigint(20) unsigned NOT NULL,
  `section_id` int(10) unsigned NOT NULL,
  `best_point` tinyint(4) DEFAULT NULL,
  `nattempt` int(10) unsigned NOT NULL DEFAULT '0',
  `npass` int(10) unsigned NOT NULL DEFAULT '0',
  `nfail` int(10) unsigned NOT NULL DEFAULT '0',
  `nwipe` int(10) unsigned NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime DEFAULT NULL,
  UNIQUE KEY `idx_rolesection` (`role_id`,`section_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_mission_76`
--

DROP TABLE IF EXISTS `user_mission_76`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_mission_76` (
  `role_id` bigint(20) unsigned NOT NULL,
  `section_id` int(10) unsigned NOT NULL,
  `best_point` tinyint(4) DEFAULT NULL,
  `nattempt` int(10) unsigned NOT NULL DEFAULT '0',
  `npass` int(10) unsigned NOT NULL DEFAULT '0',
  `nfail` int(10) unsigned NOT NULL DEFAULT '0',
  `nwipe` int(10) unsigned NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime DEFAULT NULL,
  UNIQUE KEY `idx_rolesection` (`role_id`,`section_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_mission_77`
--

DROP TABLE IF EXISTS `user_mission_77`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_mission_77` (
  `role_id` bigint(20) unsigned NOT NULL,
  `section_id` int(10) unsigned NOT NULL,
  `best_point` tinyint(4) DEFAULT NULL,
  `nattempt` int(10) unsigned NOT NULL DEFAULT '0',
  `npass` int(10) unsigned NOT NULL DEFAULT '0',
  `nfail` int(10) unsigned NOT NULL DEFAULT '0',
  `nwipe` int(10) unsigned NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime DEFAULT NULL,
  UNIQUE KEY `idx_rolesection` (`role_id`,`section_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_mission_78`
--

DROP TABLE IF EXISTS `user_mission_78`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_mission_78` (
  `role_id` bigint(20) unsigned NOT NULL,
  `section_id` int(10) unsigned NOT NULL,
  `best_point` tinyint(4) DEFAULT NULL,
  `nattempt` int(10) unsigned NOT NULL DEFAULT '0',
  `npass` int(10) unsigned NOT NULL DEFAULT '0',
  `nfail` int(10) unsigned NOT NULL DEFAULT '0',
  `nwipe` int(10) unsigned NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime DEFAULT NULL,
  UNIQUE KEY `idx_rolesection` (`role_id`,`section_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_mission_79`
--

DROP TABLE IF EXISTS `user_mission_79`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_mission_79` (
  `role_id` bigint(20) unsigned NOT NULL,
  `section_id` int(10) unsigned NOT NULL,
  `best_point` tinyint(4) DEFAULT NULL,
  `nattempt` int(10) unsigned NOT NULL DEFAULT '0',
  `npass` int(10) unsigned NOT NULL DEFAULT '0',
  `nfail` int(10) unsigned NOT NULL DEFAULT '0',
  `nwipe` int(10) unsigned NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime DEFAULT NULL,
  UNIQUE KEY `idx_rolesection` (`role_id`,`section_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_mission_80`
--

DROP TABLE IF EXISTS `user_mission_80`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_mission_80` (
  `role_id` bigint(20) unsigned NOT NULL,
  `section_id` int(10) unsigned NOT NULL,
  `best_point` tinyint(4) DEFAULT NULL,
  `nattempt` int(10) unsigned NOT NULL DEFAULT '0',
  `npass` int(10) unsigned NOT NULL DEFAULT '0',
  `nfail` int(10) unsigned NOT NULL DEFAULT '0',
  `nwipe` int(10) unsigned NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime DEFAULT NULL,
  UNIQUE KEY `idx_rolesection` (`role_id`,`section_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_mission_81`
--

DROP TABLE IF EXISTS `user_mission_81`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_mission_81` (
  `role_id` bigint(20) unsigned NOT NULL,
  `section_id` int(10) unsigned NOT NULL,
  `best_point` tinyint(4) DEFAULT NULL,
  `nattempt` int(10) unsigned NOT NULL DEFAULT '0',
  `npass` int(10) unsigned NOT NULL DEFAULT '0',
  `nfail` int(10) unsigned NOT NULL DEFAULT '0',
  `nwipe` int(10) unsigned NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime DEFAULT NULL,
  UNIQUE KEY `idx_rolesection` (`role_id`,`section_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_mission_82`
--

DROP TABLE IF EXISTS `user_mission_82`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_mission_82` (
  `role_id` bigint(20) unsigned NOT NULL,
  `section_id` int(10) unsigned NOT NULL,
  `best_point` tinyint(4) DEFAULT NULL,
  `nattempt` int(10) unsigned NOT NULL DEFAULT '0',
  `npass` int(10) unsigned NOT NULL DEFAULT '0',
  `nfail` int(10) unsigned NOT NULL DEFAULT '0',
  `nwipe` int(10) unsigned NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime DEFAULT NULL,
  UNIQUE KEY `idx_rolesection` (`role_id`,`section_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_mission_83`
--

DROP TABLE IF EXISTS `user_mission_83`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_mission_83` (
  `role_id` bigint(20) unsigned NOT NULL,
  `section_id` int(10) unsigned NOT NULL,
  `best_point` tinyint(4) DEFAULT NULL,
  `nattempt` int(10) unsigned NOT NULL DEFAULT '0',
  `npass` int(10) unsigned NOT NULL DEFAULT '0',
  `nfail` int(10) unsigned NOT NULL DEFAULT '0',
  `nwipe` int(10) unsigned NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime DEFAULT NULL,
  UNIQUE KEY `idx_rolesection` (`role_id`,`section_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_mission_84`
--

DROP TABLE IF EXISTS `user_mission_84`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_mission_84` (
  `role_id` bigint(20) unsigned NOT NULL,
  `section_id` int(10) unsigned NOT NULL,
  `best_point` tinyint(4) DEFAULT NULL,
  `nattempt` int(10) unsigned NOT NULL DEFAULT '0',
  `npass` int(10) unsigned NOT NULL DEFAULT '0',
  `nfail` int(10) unsigned NOT NULL DEFAULT '0',
  `nwipe` int(10) unsigned NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime DEFAULT NULL,
  UNIQUE KEY `idx_rolesection` (`role_id`,`section_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_mission_85`
--

DROP TABLE IF EXISTS `user_mission_85`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_mission_85` (
  `role_id` bigint(20) unsigned NOT NULL,
  `section_id` int(10) unsigned NOT NULL,
  `best_point` tinyint(4) DEFAULT NULL,
  `nattempt` int(10) unsigned NOT NULL DEFAULT '0',
  `npass` int(10) unsigned NOT NULL DEFAULT '0',
  `nfail` int(10) unsigned NOT NULL DEFAULT '0',
  `nwipe` int(10) unsigned NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime DEFAULT NULL,
  UNIQUE KEY `idx_rolesection` (`role_id`,`section_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_mission_86`
--

DROP TABLE IF EXISTS `user_mission_86`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_mission_86` (
  `role_id` bigint(20) unsigned NOT NULL,
  `section_id` int(10) unsigned NOT NULL,
  `best_point` tinyint(4) DEFAULT NULL,
  `nattempt` int(10) unsigned NOT NULL DEFAULT '0',
  `npass` int(10) unsigned NOT NULL DEFAULT '0',
  `nfail` int(10) unsigned NOT NULL DEFAULT '0',
  `nwipe` int(10) unsigned NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime DEFAULT NULL,
  UNIQUE KEY `idx_rolesection` (`role_id`,`section_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_mission_87`
--

DROP TABLE IF EXISTS `user_mission_87`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_mission_87` (
  `role_id` bigint(20) unsigned NOT NULL,
  `section_id` int(10) unsigned NOT NULL,
  `best_point` tinyint(4) DEFAULT NULL,
  `nattempt` int(10) unsigned NOT NULL DEFAULT '0',
  `npass` int(10) unsigned NOT NULL DEFAULT '0',
  `nfail` int(10) unsigned NOT NULL DEFAULT '0',
  `nwipe` int(10) unsigned NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime DEFAULT NULL,
  UNIQUE KEY `idx_rolesection` (`role_id`,`section_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_mission_88`
--

DROP TABLE IF EXISTS `user_mission_88`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_mission_88` (
  `role_id` bigint(20) unsigned NOT NULL,
  `section_id` int(10) unsigned NOT NULL,
  `best_point` tinyint(4) DEFAULT NULL,
  `nattempt` int(10) unsigned NOT NULL DEFAULT '0',
  `npass` int(10) unsigned NOT NULL DEFAULT '0',
  `nfail` int(10) unsigned NOT NULL DEFAULT '0',
  `nwipe` int(10) unsigned NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime DEFAULT NULL,
  UNIQUE KEY `idx_rolesection` (`role_id`,`section_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_mission_89`
--

DROP TABLE IF EXISTS `user_mission_89`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_mission_89` (
  `role_id` bigint(20) unsigned NOT NULL,
  `section_id` int(10) unsigned NOT NULL,
  `best_point` tinyint(4) DEFAULT NULL,
  `nattempt` int(10) unsigned NOT NULL DEFAULT '0',
  `npass` int(10) unsigned NOT NULL DEFAULT '0',
  `nfail` int(10) unsigned NOT NULL DEFAULT '0',
  `nwipe` int(10) unsigned NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime DEFAULT NULL,
  UNIQUE KEY `idx_rolesection` (`role_id`,`section_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_mission_90`
--

DROP TABLE IF EXISTS `user_mission_90`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_mission_90` (
  `role_id` bigint(20) unsigned NOT NULL,
  `section_id` int(10) unsigned NOT NULL,
  `best_point` tinyint(4) DEFAULT NULL,
  `nattempt` int(10) unsigned NOT NULL DEFAULT '0',
  `npass` int(10) unsigned NOT NULL DEFAULT '0',
  `nfail` int(10) unsigned NOT NULL DEFAULT '0',
  `nwipe` int(10) unsigned NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime DEFAULT NULL,
  UNIQUE KEY `idx_rolesection` (`role_id`,`section_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_mission_91`
--

DROP TABLE IF EXISTS `user_mission_91`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_mission_91` (
  `role_id` bigint(20) unsigned NOT NULL,
  `section_id` int(10) unsigned NOT NULL,
  `best_point` tinyint(4) DEFAULT NULL,
  `nattempt` int(10) unsigned NOT NULL DEFAULT '0',
  `npass` int(10) unsigned NOT NULL DEFAULT '0',
  `nfail` int(10) unsigned NOT NULL DEFAULT '0',
  `nwipe` int(10) unsigned NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime DEFAULT NULL,
  UNIQUE KEY `idx_rolesection` (`role_id`,`section_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_mission_92`
--

DROP TABLE IF EXISTS `user_mission_92`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_mission_92` (
  `role_id` bigint(20) unsigned NOT NULL,
  `section_id` int(10) unsigned NOT NULL,
  `best_point` tinyint(4) DEFAULT NULL,
  `nattempt` int(10) unsigned NOT NULL DEFAULT '0',
  `npass` int(10) unsigned NOT NULL DEFAULT '0',
  `nfail` int(10) unsigned NOT NULL DEFAULT '0',
  `nwipe` int(10) unsigned NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime DEFAULT NULL,
  UNIQUE KEY `idx_rolesection` (`role_id`,`section_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_mission_93`
--

DROP TABLE IF EXISTS `user_mission_93`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_mission_93` (
  `role_id` bigint(20) unsigned NOT NULL,
  `section_id` int(10) unsigned NOT NULL,
  `best_point` tinyint(4) DEFAULT NULL,
  `nattempt` int(10) unsigned NOT NULL DEFAULT '0',
  `npass` int(10) unsigned NOT NULL DEFAULT '0',
  `nfail` int(10) unsigned NOT NULL DEFAULT '0',
  `nwipe` int(10) unsigned NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime DEFAULT NULL,
  UNIQUE KEY `idx_rolesection` (`role_id`,`section_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_mission_94`
--

DROP TABLE IF EXISTS `user_mission_94`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_mission_94` (
  `role_id` bigint(20) unsigned NOT NULL,
  `section_id` int(10) unsigned NOT NULL,
  `best_point` tinyint(4) DEFAULT NULL,
  `nattempt` int(10) unsigned NOT NULL DEFAULT '0',
  `npass` int(10) unsigned NOT NULL DEFAULT '0',
  `nfail` int(10) unsigned NOT NULL DEFAULT '0',
  `nwipe` int(10) unsigned NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime DEFAULT NULL,
  UNIQUE KEY `idx_rolesection` (`role_id`,`section_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_mission_95`
--

DROP TABLE IF EXISTS `user_mission_95`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_mission_95` (
  `role_id` bigint(20) unsigned NOT NULL,
  `section_id` int(10) unsigned NOT NULL,
  `best_point` tinyint(4) DEFAULT NULL,
  `nattempt` int(10) unsigned NOT NULL DEFAULT '0',
  `npass` int(10) unsigned NOT NULL DEFAULT '0',
  `nfail` int(10) unsigned NOT NULL DEFAULT '0',
  `nwipe` int(10) unsigned NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime DEFAULT NULL,
  UNIQUE KEY `idx_rolesection` (`role_id`,`section_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_mission_96`
--

DROP TABLE IF EXISTS `user_mission_96`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_mission_96` (
  `role_id` bigint(20) unsigned NOT NULL,
  `section_id` int(10) unsigned NOT NULL,
  `best_point` tinyint(4) DEFAULT NULL,
  `nattempt` int(10) unsigned NOT NULL DEFAULT '0',
  `npass` int(10) unsigned NOT NULL DEFAULT '0',
  `nfail` int(10) unsigned NOT NULL DEFAULT '0',
  `nwipe` int(10) unsigned NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime DEFAULT NULL,
  UNIQUE KEY `idx_rolesection` (`role_id`,`section_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_mission_97`
--

DROP TABLE IF EXISTS `user_mission_97`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_mission_97` (
  `role_id` bigint(20) unsigned NOT NULL,
  `section_id` int(10) unsigned NOT NULL,
  `best_point` tinyint(4) DEFAULT NULL,
  `nattempt` int(10) unsigned NOT NULL DEFAULT '0',
  `npass` int(10) unsigned NOT NULL DEFAULT '0',
  `nfail` int(10) unsigned NOT NULL DEFAULT '0',
  `nwipe` int(10) unsigned NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime DEFAULT NULL,
  UNIQUE KEY `idx_rolesection` (`role_id`,`section_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_mission_98`
--

DROP TABLE IF EXISTS `user_mission_98`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_mission_98` (
  `role_id` bigint(20) unsigned NOT NULL,
  `section_id` int(10) unsigned NOT NULL,
  `best_point` tinyint(4) DEFAULT NULL,
  `nattempt` int(10) unsigned NOT NULL DEFAULT '0',
  `npass` int(10) unsigned NOT NULL DEFAULT '0',
  `nfail` int(10) unsigned NOT NULL DEFAULT '0',
  `nwipe` int(10) unsigned NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime DEFAULT NULL,
  UNIQUE KEY `idx_rolesection` (`role_id`,`section_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_mission_99`
--

DROP TABLE IF EXISTS `user_mission_99`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_mission_99` (
  `role_id` bigint(20) unsigned NOT NULL,
  `section_id` int(10) unsigned NOT NULL,
  `best_point` tinyint(4) DEFAULT NULL,
  `nattempt` int(10) unsigned NOT NULL DEFAULT '0',
  `npass` int(10) unsigned NOT NULL DEFAULT '0',
  `nfail` int(10) unsigned NOT NULL DEFAULT '0',
  `nwipe` int(10) unsigned NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime DEFAULT NULL,
  UNIQUE KEY `idx_rolesection` (`role_id`,`section_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_mission_tl2`
--

DROP TABLE IF EXISTS `user_mission_tl2`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_mission_tl2` (
  `role_id` bigint(20) unsigned NOT NULL,
  `section_id` int(10) unsigned NOT NULL,
  `best_point` tinyint(4) DEFAULT NULL,
  `nattempt` int(10) unsigned NOT NULL DEFAULT '0',
  `npass` int(10) unsigned NOT NULL DEFAULT '0',
  `nfail` int(10) unsigned NOT NULL DEFAULT '0',
  `nwipe` int(10) unsigned NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime DEFAULT NULL,
  UNIQUE KEY `idx_rolesection` (`role_id`,`section_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_mission_tl3`
--

DROP TABLE IF EXISTS `user_mission_tl3`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_mission_tl3` (
  `role_id` bigint(20) unsigned NOT NULL,
  `section_id` int(10) unsigned NOT NULL,
  `best_point` tinyint(4) DEFAULT NULL,
  `nattempt` int(10) unsigned NOT NULL DEFAULT '0',
  `npass` int(10) unsigned NOT NULL DEFAULT '0',
  `nfail` int(10) unsigned NOT NULL DEFAULT '0',
  `nwipe` int(10) unsigned NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime DEFAULT NULL,
  UNIQUE KEY `idx_rolesection` (`role_id`,`section_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_mission_tl4`
--

DROP TABLE IF EXISTS `user_mission_tl4`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_mission_tl4` (
  `role_id` bigint(20) unsigned NOT NULL,
  `section_id` int(10) unsigned NOT NULL,
  `best_point` tinyint(4) DEFAULT NULL,
  `nattempt` int(10) unsigned NOT NULL DEFAULT '0',
  `npass` int(10) unsigned NOT NULL DEFAULT '0',
  `nfail` int(10) unsigned NOT NULL DEFAULT '0',
  `nwipe` int(10) unsigned NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime DEFAULT NULL,
  UNIQUE KEY `idx_rolesection` (`role_id`,`section_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_mission_tl5`
--

DROP TABLE IF EXISTS `user_mission_tl5`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_mission_tl5` (
  `role_id` bigint(20) unsigned NOT NULL,
  `section_id` int(10) unsigned NOT NULL,
  `best_point` tinyint(4) DEFAULT NULL,
  `nattempt` int(10) unsigned NOT NULL DEFAULT '0',
  `npass` int(10) unsigned NOT NULL DEFAULT '0',
  `nfail` int(10) unsigned NOT NULL DEFAULT '0',
  `nwipe` int(10) unsigned NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime DEFAULT NULL,
  UNIQUE KEY `idx_rolesection` (`role_id`,`section_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_mission_tl6`
--

DROP TABLE IF EXISTS `user_mission_tl6`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_mission_tl6` (
  `role_id` bigint(20) unsigned NOT NULL,
  `section_id` int(10) unsigned NOT NULL,
  `best_point` tinyint(4) DEFAULT NULL,
  `nattempt` int(10) unsigned NOT NULL DEFAULT '0',
  `npass` int(10) unsigned NOT NULL DEFAULT '0',
  `nfail` int(10) unsigned NOT NULL DEFAULT '0',
  `nwipe` int(10) unsigned NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime DEFAULT NULL,
  UNIQUE KEY `idx_rolesection` (`role_id`,`section_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_purchase_record_2014_10`
--

DROP TABLE IF EXISTS `user_purchase_record_2014_10`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_purchase_record_2014_10` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` bigint(20) unsigned NOT NULL,
  `store_id` smallint(6) NOT NULL,
  `commodity_id` smallint(6) NOT NULL,
  `count` smallint(6) NOT NULL,
  `cost` int(11) NOT NULL,
  `currency` varchar(20) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6643 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_purchase_record_2014_11`
--

DROP TABLE IF EXISTS `user_purchase_record_2014_11`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_purchase_record_2014_11` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` bigint(20) unsigned NOT NULL,
  `store_id` smallint(6) NOT NULL,
  `commodity_id` smallint(6) NOT NULL,
  `count` smallint(6) NOT NULL,
  `cost` int(11) NOT NULL,
  `currency` varchar(20) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1257 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_purchase_record_2014_12`
--

DROP TABLE IF EXISTS `user_purchase_record_2014_12`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_purchase_record_2014_12` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` bigint(20) unsigned NOT NULL,
  `store_id` smallint(6) NOT NULL,
  `commodity_id` smallint(6) NOT NULL,
  `count` smallint(6) NOT NULL,
  `cost` int(11) NOT NULL,
  `currency` varchar(20) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_purchase_record_honorstore`
--

DROP TABLE IF EXISTS `user_purchase_record_honorstore`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_purchase_record_honorstore` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` bigint(20) unsigned NOT NULL,
  `store_id` smallint(6) NOT NULL,
  `commodity_id` smallint(6) NOT NULL,
  `count` smallint(6) NOT NULL,
  `cost` int(11) NOT NULL,
  `currency` varchar(20) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_quest`
--

DROP TABLE IF EXISTS `user_quest`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_quest` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `quest_id` int(11) NOT NULL,
  `finished_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_quest_idx` (`user_id`,`quest_id`)
) ENGINE=InnoDB AUTO_INCREMENT=33049 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_refresh_purchase_record_2014_10`
--

DROP TABLE IF EXISTS `user_refresh_purchase_record_2014_10`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_refresh_purchase_record_2014_10` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` bigint(20) unsigned NOT NULL,
  `store_id` smallint(6) NOT NULL,
  `commodity_id` smallint(6) NOT NULL,
  `count` smallint(6) NOT NULL,
  `cost` int(11) NOT NULL,
  `currency` varchar(20) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2659 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_refresh_purchase_record_2014_11`
--

DROP TABLE IF EXISTS `user_refresh_purchase_record_2014_11`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_refresh_purchase_record_2014_11` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` bigint(20) unsigned NOT NULL,
  `store_id` smallint(6) NOT NULL,
  `commodity_id` smallint(6) NOT NULL,
  `count` smallint(6) NOT NULL,
  `cost` int(11) NOT NULL,
  `currency` varchar(20) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=977 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_refresh_purchase_record_2014_12`
--

DROP TABLE IF EXISTS `user_refresh_purchase_record_2014_12`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_refresh_purchase_record_2014_12` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` bigint(20) unsigned NOT NULL,
  `store_id` smallint(6) NOT NULL,
  `commodity_id` smallint(6) NOT NULL,
  `count` smallint(6) NOT NULL,
  `cost` int(11) NOT NULL,
  `currency` varchar(20) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `worship_log_20141016`
--

DROP TABLE IF EXISTS `worship_log_20141016`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `worship_log_20141016` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `god_id` tinyint(3) NOT NULL,
  `worship_id` smallint(6) NOT NULL,
  `god_level` tinyint(3) NOT NULL DEFAULT '0',
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_idx` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `worship_log_20141017`
--

DROP TABLE IF EXISTS `worship_log_20141017`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `worship_log_20141017` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `god_id` tinyint(3) NOT NULL,
  `worship_id` smallint(6) NOT NULL,
  `god_level` tinyint(3) NOT NULL DEFAULT '0',
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_idx` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `worship_log_20141018`
--

DROP TABLE IF EXISTS `worship_log_20141018`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `worship_log_20141018` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `god_id` tinyint(3) NOT NULL,
  `worship_id` smallint(6) NOT NULL,
  `god_level` tinyint(3) NOT NULL DEFAULT '0',
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_idx` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `worship_log_20141019`
--

DROP TABLE IF EXISTS `worship_log_20141019`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `worship_log_20141019` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `god_id` tinyint(3) NOT NULL,
  `worship_id` smallint(6) NOT NULL,
  `god_level` tinyint(3) NOT NULL DEFAULT '0',
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_idx` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `worship_log_20141020`
--

DROP TABLE IF EXISTS `worship_log_20141020`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `worship_log_20141020` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `god_id` tinyint(3) NOT NULL,
  `worship_id` smallint(6) NOT NULL,
  `god_level` tinyint(3) NOT NULL DEFAULT '0',
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_idx` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `worship_log_20141021`
--

DROP TABLE IF EXISTS `worship_log_20141021`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `worship_log_20141021` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `god_id` tinyint(3) NOT NULL,
  `worship_id` smallint(6) NOT NULL,
  `god_level` tinyint(3) NOT NULL DEFAULT '0',
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_idx` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `worship_log_20141022`
--

DROP TABLE IF EXISTS `worship_log_20141022`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `worship_log_20141022` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `god_id` tinyint(3) NOT NULL,
  `worship_id` smallint(6) NOT NULL,
  `god_level` tinyint(3) NOT NULL DEFAULT '0',
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_idx` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=65 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `worship_log_20141023`
--

DROP TABLE IF EXISTS `worship_log_20141023`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `worship_log_20141023` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `god_id` tinyint(3) NOT NULL,
  `worship_id` smallint(6) NOT NULL,
  `god_level` tinyint(3) NOT NULL DEFAULT '0',
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_idx` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=161 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `worship_log_20141024`
--

DROP TABLE IF EXISTS `worship_log_20141024`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `worship_log_20141024` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `god_id` tinyint(3) NOT NULL,
  `worship_id` smallint(6) NOT NULL,
  `god_level` tinyint(3) NOT NULL DEFAULT '0',
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_idx` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=172 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `worship_log_20141025`
--

DROP TABLE IF EXISTS `worship_log_20141025`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `worship_log_20141025` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `god_id` tinyint(3) NOT NULL,
  `worship_id` smallint(6) NOT NULL,
  `god_level` tinyint(3) NOT NULL DEFAULT '0',
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_idx` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=201 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `worship_log_20141026`
--

DROP TABLE IF EXISTS `worship_log_20141026`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `worship_log_20141026` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `god_id` tinyint(3) NOT NULL,
  `worship_id` smallint(6) NOT NULL,
  `god_level` tinyint(3) NOT NULL DEFAULT '0',
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_idx` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=208 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `worship_log_20141027`
--

DROP TABLE IF EXISTS `worship_log_20141027`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `worship_log_20141027` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `god_id` tinyint(3) NOT NULL,
  `worship_id` smallint(6) NOT NULL,
  `god_level` tinyint(3) NOT NULL DEFAULT '0',
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_idx` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=223 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `worship_log_20141028`
--

DROP TABLE IF EXISTS `worship_log_20141028`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `worship_log_20141028` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `god_id` tinyint(3) NOT NULL,
  `worship_id` smallint(6) NOT NULL,
  `god_level` tinyint(3) NOT NULL DEFAULT '0',
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_idx` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=216 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `worship_log_20141029`
--

DROP TABLE IF EXISTS `worship_log_20141029`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `worship_log_20141029` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `god_id` tinyint(3) NOT NULL,
  `worship_id` smallint(6) NOT NULL,
  `god_level` tinyint(3) NOT NULL DEFAULT '0',
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_idx` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=235 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `worship_log_20141030`
--

DROP TABLE IF EXISTS `worship_log_20141030`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `worship_log_20141030` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `god_id` tinyint(3) NOT NULL,
  `worship_id` smallint(6) NOT NULL,
  `god_level` tinyint(3) NOT NULL DEFAULT '0',
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_idx` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=302 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `worship_log_20141031`
--

DROP TABLE IF EXISTS `worship_log_20141031`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `worship_log_20141031` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `god_id` tinyint(3) NOT NULL,
  `worship_id` smallint(6) NOT NULL,
  `god_level` tinyint(3) NOT NULL DEFAULT '0',
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_idx` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=222 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `worship_log_20141101`
--

DROP TABLE IF EXISTS `worship_log_20141101`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `worship_log_20141101` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `god_id` tinyint(3) NOT NULL,
  `worship_id` smallint(6) NOT NULL,
  `god_level` tinyint(3) NOT NULL DEFAULT '0',
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_idx` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=192 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `worship_log_20141102`
--

DROP TABLE IF EXISTS `worship_log_20141102`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `worship_log_20141102` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `god_id` tinyint(3) NOT NULL,
  `worship_id` smallint(6) NOT NULL,
  `god_level` tinyint(3) NOT NULL DEFAULT '0',
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_idx` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=193 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `worship_log_20141103`
--

DROP TABLE IF EXISTS `worship_log_20141103`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `worship_log_20141103` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `god_id` tinyint(3) NOT NULL,
  `worship_id` smallint(6) NOT NULL,
  `god_level` tinyint(3) NOT NULL DEFAULT '0',
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_idx` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=196 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `worship_log_20141104`
--

DROP TABLE IF EXISTS `worship_log_20141104`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `worship_log_20141104` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `god_id` tinyint(3) NOT NULL,
  `worship_id` smallint(6) NOT NULL,
  `god_level` tinyint(3) NOT NULL DEFAULT '0',
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_idx` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=63 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `worship_log_20141105`
--

DROP TABLE IF EXISTS `worship_log_20141105`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `worship_log_20141105` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `god_id` tinyint(3) NOT NULL,
  `worship_id` smallint(6) NOT NULL,
  `god_level` tinyint(3) NOT NULL DEFAULT '0',
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_idx` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `worship_log_20141106`
--

DROP TABLE IF EXISTS `worship_log_20141106`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `worship_log_20141106` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `god_id` tinyint(3) NOT NULL,
  `worship_id` smallint(6) NOT NULL,
  `god_level` tinyint(3) NOT NULL DEFAULT '0',
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_idx` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `worship_log_20141107`
--

DROP TABLE IF EXISTS `worship_log_20141107`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `worship_log_20141107` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `god_id` tinyint(3) NOT NULL,
  `worship_id` smallint(6) NOT NULL,
  `god_level` tinyint(3) NOT NULL DEFAULT '0',
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_idx` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `worship_log_20141108`
--

DROP TABLE IF EXISTS `worship_log_20141108`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `worship_log_20141108` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `god_id` tinyint(3) NOT NULL,
  `worship_id` smallint(6) NOT NULL,
  `god_level` tinyint(3) NOT NULL DEFAULT '0',
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_idx` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `worship_log_20141109`
--

DROP TABLE IF EXISTS `worship_log_20141109`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `worship_log_20141109` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `god_id` tinyint(3) NOT NULL,
  `worship_id` smallint(6) NOT NULL,
  `god_level` tinyint(3) NOT NULL DEFAULT '0',
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_idx` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `worship_log_20141110`
--

DROP TABLE IF EXISTS `worship_log_20141110`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `worship_log_20141110` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `god_id` tinyint(3) NOT NULL,
  `worship_id` smallint(6) NOT NULL,
  `god_level` tinyint(3) NOT NULL DEFAULT '0',
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_idx` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `worship_log_20141111`
--

DROP TABLE IF EXISTS `worship_log_20141111`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `worship_log_20141111` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `god_id` tinyint(3) NOT NULL,
  `worship_id` smallint(6) NOT NULL,
  `god_level` tinyint(3) NOT NULL DEFAULT '0',
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_idx` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `worship_log_20141112`
--

DROP TABLE IF EXISTS `worship_log_20141112`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `worship_log_20141112` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `god_id` tinyint(3) NOT NULL,
  `worship_id` smallint(6) NOT NULL,
  `god_level` tinyint(3) NOT NULL DEFAULT '0',
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_idx` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `worship_log_20141113`
--

DROP TABLE IF EXISTS `worship_log_20141113`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `worship_log_20141113` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `god_id` tinyint(3) NOT NULL,
  `worship_id` smallint(6) NOT NULL,
  `god_level` tinyint(3) NOT NULL DEFAULT '0',
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_idx` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `worship_log_20141114`
--

DROP TABLE IF EXISTS `worship_log_20141114`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `worship_log_20141114` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `god_id` tinyint(3) NOT NULL,
  `worship_id` smallint(6) NOT NULL,
  `god_level` tinyint(3) NOT NULL DEFAULT '0',
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_idx` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `worship_log_20141115`
--

DROP TABLE IF EXISTS `worship_log_20141115`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `worship_log_20141115` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `god_id` tinyint(3) NOT NULL,
  `worship_id` smallint(6) NOT NULL,
  `god_level` tinyint(3) NOT NULL DEFAULT '0',
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_idx` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `worship_log_20141116`
--

DROP TABLE IF EXISTS `worship_log_20141116`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `worship_log_20141116` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `god_id` tinyint(3) NOT NULL,
  `worship_id` smallint(6) NOT NULL,
  `god_level` tinyint(3) NOT NULL DEFAULT '0',
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_idx` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `worship_log_20141117`
--

DROP TABLE IF EXISTS `worship_log_20141117`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `worship_log_20141117` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `god_id` tinyint(3) NOT NULL,
  `worship_id` smallint(6) NOT NULL,
  `god_level` tinyint(3) NOT NULL DEFAULT '0',
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_idx` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `worship_log_20141118`
--

DROP TABLE IF EXISTS `worship_log_20141118`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `worship_log_20141118` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `god_id` tinyint(3) NOT NULL,
  `worship_id` smallint(6) NOT NULL,
  `god_level` tinyint(3) NOT NULL DEFAULT '0',
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_idx` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `worship_log_20141119`
--

DROP TABLE IF EXISTS `worship_log_20141119`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `worship_log_20141119` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `god_id` tinyint(3) NOT NULL,
  `worship_id` smallint(6) NOT NULL,
  `god_level` tinyint(3) NOT NULL DEFAULT '0',
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_idx` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `worship_log_20141120`
--

DROP TABLE IF EXISTS `worship_log_20141120`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `worship_log_20141120` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `god_id` tinyint(3) NOT NULL,
  `worship_id` smallint(6) NOT NULL,
  `god_level` tinyint(3) NOT NULL DEFAULT '0',
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_idx` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `worship_log_20141121`
--

DROP TABLE IF EXISTS `worship_log_20141121`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `worship_log_20141121` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `god_id` tinyint(3) NOT NULL,
  `worship_id` smallint(6) NOT NULL,
  `god_level` tinyint(3) NOT NULL DEFAULT '0',
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_idx` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `worship_log_20141122`
--

DROP TABLE IF EXISTS `worship_log_20141122`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `worship_log_20141122` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `god_id` tinyint(3) NOT NULL,
  `worship_id` smallint(6) NOT NULL,
  `god_level` tinyint(3) NOT NULL DEFAULT '0',
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_idx` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `worship_log_20141123`
--

DROP TABLE IF EXISTS `worship_log_20141123`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `worship_log_20141123` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `god_id` tinyint(3) NOT NULL,
  `worship_id` smallint(6) NOT NULL,
  `god_level` tinyint(3) NOT NULL DEFAULT '0',
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_idx` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `worship_log_20141124`
--

DROP TABLE IF EXISTS `worship_log_20141124`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `worship_log_20141124` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `god_id` tinyint(3) NOT NULL,
  `worship_id` smallint(6) NOT NULL,
  `god_level` tinyint(3) NOT NULL DEFAULT '0',
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_idx` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `worship_log_20141125`
--

DROP TABLE IF EXISTS `worship_log_20141125`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `worship_log_20141125` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `god_id` tinyint(3) NOT NULL,
  `worship_id` smallint(6) NOT NULL,
  `god_level` tinyint(3) NOT NULL DEFAULT '0',
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_idx` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `worship_log_20141126`
--

DROP TABLE IF EXISTS `worship_log_20141126`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `worship_log_20141126` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `god_id` tinyint(3) NOT NULL,
  `worship_id` smallint(6) NOT NULL,
  `god_level` tinyint(3) NOT NULL DEFAULT '0',
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_idx` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `worship_log_20141127`
--

DROP TABLE IF EXISTS `worship_log_20141127`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `worship_log_20141127` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `god_id` tinyint(3) NOT NULL,
  `worship_id` smallint(6) NOT NULL,
  `god_level` tinyint(3) NOT NULL DEFAULT '0',
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_idx` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `worship_log_20141128`
--

DROP TABLE IF EXISTS `worship_log_20141128`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `worship_log_20141128` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `god_id` tinyint(3) NOT NULL,
  `worship_id` smallint(6) NOT NULL,
  `god_level` tinyint(3) NOT NULL DEFAULT '0',
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_idx` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `worship_log_20141129`
--

DROP TABLE IF EXISTS `worship_log_20141129`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `worship_log_20141129` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `god_id` tinyint(3) NOT NULL,
  `worship_id` smallint(6) NOT NULL,
  `god_level` tinyint(3) NOT NULL DEFAULT '0',
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_idx` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `worship_log_20141130`
--

DROP TABLE IF EXISTS `worship_log_20141130`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `worship_log_20141130` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `god_id` tinyint(3) NOT NULL,
  `worship_id` smallint(6) NOT NULL,
  `god_level` tinyint(3) NOT NULL DEFAULT '0',
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_idx` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `worship_log_20141201`
--

DROP TABLE IF EXISTS `worship_log_20141201`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `worship_log_20141201` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `god_id` tinyint(3) NOT NULL,
  `worship_id` smallint(6) NOT NULL,
  `god_level` tinyint(3) NOT NULL DEFAULT '0',
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_idx` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `worship_log_20141202`
--

DROP TABLE IF EXISTS `worship_log_20141202`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `worship_log_20141202` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `god_id` tinyint(3) NOT NULL,
  `worship_id` smallint(6) NOT NULL,
  `god_level` tinyint(3) NOT NULL DEFAULT '0',
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_idx` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `worship_log_20141203`
--

DROP TABLE IF EXISTS `worship_log_20141203`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `worship_log_20141203` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `god_id` tinyint(3) NOT NULL,
  `worship_id` smallint(6) NOT NULL,
  `god_level` tinyint(3) NOT NULL DEFAULT '0',
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_idx` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `worship_log_20141204`
--

DROP TABLE IF EXISTS `worship_log_20141204`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `worship_log_20141204` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `god_id` tinyint(3) NOT NULL,
  `worship_id` smallint(6) NOT NULL,
  `god_level` tinyint(3) NOT NULL DEFAULT '0',
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_idx` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `worship_log_20141205`
--

DROP TABLE IF EXISTS `worship_log_20141205`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `worship_log_20141205` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `god_id` tinyint(3) NOT NULL,
  `worship_id` smallint(6) NOT NULL,
  `god_level` tinyint(3) NOT NULL DEFAULT '0',
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_idx` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `worship_log_20141206`
--

DROP TABLE IF EXISTS `worship_log_20141206`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `worship_log_20141206` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `god_id` tinyint(3) NOT NULL,
  `worship_id` smallint(6) NOT NULL,
  `god_level` tinyint(3) NOT NULL DEFAULT '0',
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_idx` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `worship_log_20141207`
--

DROP TABLE IF EXISTS `worship_log_20141207`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `worship_log_20141207` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `god_id` tinyint(3) NOT NULL,
  `worship_id` smallint(6) NOT NULL,
  `god_level` tinyint(3) NOT NULL DEFAULT '0',
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_idx` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `worship_log_20141208`
--

DROP TABLE IF EXISTS `worship_log_20141208`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `worship_log_20141208` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `god_id` tinyint(3) NOT NULL,
  `worship_id` smallint(6) NOT NULL,
  `god_level` tinyint(3) NOT NULL DEFAULT '0',
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_idx` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `worship_log_20141209`
--

DROP TABLE IF EXISTS `worship_log_20141209`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `worship_log_20141209` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `god_id` tinyint(3) NOT NULL,
  `worship_id` smallint(6) NOT NULL,
  `god_level` tinyint(3) NOT NULL DEFAULT '0',
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_idx` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `worship_log_20141210`
--

DROP TABLE IF EXISTS `worship_log_20141210`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `worship_log_20141210` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `god_id` tinyint(3) NOT NULL,
  `worship_id` smallint(6) NOT NULL,
  `god_level` tinyint(3) NOT NULL DEFAULT '0',
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_idx` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `worship_log_20141211`
--

DROP TABLE IF EXISTS `worship_log_20141211`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `worship_log_20141211` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `god_id` tinyint(3) NOT NULL,
  `worship_id` smallint(6) NOT NULL,
  `god_level` tinyint(3) NOT NULL DEFAULT '0',
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_idx` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `worship_log_20141212`
--

DROP TABLE IF EXISTS `worship_log_20141212`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `worship_log_20141212` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `god_id` tinyint(3) NOT NULL,
  `worship_id` smallint(6) NOT NULL,
  `god_level` tinyint(3) NOT NULL DEFAULT '0',
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_idx` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `worship_log_20141213`
--

DROP TABLE IF EXISTS `worship_log_20141213`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `worship_log_20141213` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `god_id` tinyint(3) NOT NULL,
  `worship_id` smallint(6) NOT NULL,
  `god_level` tinyint(3) NOT NULL DEFAULT '0',
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_idx` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `worship_log_20141214`
--

DROP TABLE IF EXISTS `worship_log_20141214`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `worship_log_20141214` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `god_id` tinyint(3) NOT NULL,
  `worship_id` smallint(6) NOT NULL,
  `god_level` tinyint(3) NOT NULL DEFAULT '0',
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_idx` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `worship_log_20141215`
--

DROP TABLE IF EXISTS `worship_log_20141215`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `worship_log_20141215` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `god_id` tinyint(3) NOT NULL,
  `worship_id` smallint(6) NOT NULL,
  `god_level` tinyint(3) NOT NULL DEFAULT '0',
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_idx` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `worship_log_20141216`
--

DROP TABLE IF EXISTS `worship_log_20141216`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `worship_log_20141216` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `god_id` tinyint(3) NOT NULL,
  `worship_id` smallint(6) NOT NULL,
  `god_level` tinyint(3) NOT NULL DEFAULT '0',
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_idx` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `worship_log_20141217`
--

DROP TABLE IF EXISTS `worship_log_20141217`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `worship_log_20141217` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `god_id` tinyint(3) NOT NULL,
  `worship_id` smallint(6) NOT NULL,
  `god_level` tinyint(3) NOT NULL DEFAULT '0',
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_idx` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `worship_log_20141218`
--

DROP TABLE IF EXISTS `worship_log_20141218`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `worship_log_20141218` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `god_id` tinyint(3) NOT NULL,
  `worship_id` smallint(6) NOT NULL,
  `god_level` tinyint(3) NOT NULL DEFAULT '0',
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_idx` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `worship_log_20141219`
--

DROP TABLE IF EXISTS `worship_log_20141219`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `worship_log_20141219` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `god_id` tinyint(3) NOT NULL,
  `worship_id` smallint(6) NOT NULL,
  `god_level` tinyint(3) NOT NULL DEFAULT '0',
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_idx` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `worship_log_20141220`
--

DROP TABLE IF EXISTS `worship_log_20141220`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `worship_log_20141220` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `god_id` tinyint(3) NOT NULL,
  `worship_id` smallint(6) NOT NULL,
  `god_level` tinyint(3) NOT NULL DEFAULT '0',
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_idx` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `worship_log_20141221`
--

DROP TABLE IF EXISTS `worship_log_20141221`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `worship_log_20141221` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `god_id` tinyint(3) NOT NULL,
  `worship_id` smallint(6) NOT NULL,
  `god_level` tinyint(3) NOT NULL DEFAULT '0',
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_idx` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `worship_log_20141222`
--

DROP TABLE IF EXISTS `worship_log_20141222`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `worship_log_20141222` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `god_id` tinyint(3) NOT NULL,
  `worship_id` smallint(6) NOT NULL,
  `god_level` tinyint(3) NOT NULL DEFAULT '0',
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_idx` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `worship_log_20141223`
--

DROP TABLE IF EXISTS `worship_log_20141223`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `worship_log_20141223` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `god_id` tinyint(3) NOT NULL,
  `worship_id` smallint(6) NOT NULL,
  `god_level` tinyint(3) NOT NULL DEFAULT '0',
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_idx` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `worship_log_20141224`
--

DROP TABLE IF EXISTS `worship_log_20141224`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `worship_log_20141224` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `god_id` tinyint(3) NOT NULL,
  `worship_id` smallint(6) NOT NULL,
  `god_level` tinyint(3) NOT NULL DEFAULT '0',
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_idx` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `worship_log_20141225`
--

DROP TABLE IF EXISTS `worship_log_20141225`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `worship_log_20141225` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `god_id` tinyint(3) NOT NULL,
  `worship_id` smallint(6) NOT NULL,
  `god_level` tinyint(3) NOT NULL DEFAULT '0',
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_idx` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `worship_log_20141226`
--

DROP TABLE IF EXISTS `worship_log_20141226`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `worship_log_20141226` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `god_id` tinyint(3) NOT NULL,
  `worship_id` smallint(6) NOT NULL,
  `god_level` tinyint(3) NOT NULL DEFAULT '0',
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_idx` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `worship_log_20141227`
--

DROP TABLE IF EXISTS `worship_log_20141227`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `worship_log_20141227` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `god_id` tinyint(3) NOT NULL,
  `worship_id` smallint(6) NOT NULL,
  `god_level` tinyint(3) NOT NULL DEFAULT '0',
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_idx` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `worship_log_20141228`
--

DROP TABLE IF EXISTS `worship_log_20141228`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `worship_log_20141228` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `god_id` tinyint(3) NOT NULL,
  `worship_id` smallint(6) NOT NULL,
  `god_level` tinyint(3) NOT NULL DEFAULT '0',
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_idx` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `worship_log_20141229`
--

DROP TABLE IF EXISTS `worship_log_20141229`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `worship_log_20141229` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `god_id` tinyint(3) NOT NULL,
  `worship_id` smallint(6) NOT NULL,
  `god_level` tinyint(3) NOT NULL DEFAULT '0',
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_idx` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `worship_log_20141230`
--

DROP TABLE IF EXISTS `worship_log_20141230`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `worship_log_20141230` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `god_id` tinyint(3) NOT NULL,
  `worship_id` smallint(6) NOT NULL,
  `god_level` tinyint(3) NOT NULL DEFAULT '0',
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_idx` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `worship_log_20141231`
--

DROP TABLE IF EXISTS `worship_log_20141231`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `worship_log_20141231` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `god_id` tinyint(3) NOT NULL,
  `worship_id` smallint(6) NOT NULL,
  `god_level` tinyint(3) NOT NULL DEFAULT '0',
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_idx` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `worship_log_20150101`
--

DROP TABLE IF EXISTS `worship_log_20150101`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `worship_log_20150101` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `god_id` tinyint(3) NOT NULL,
  `worship_id` smallint(6) NOT NULL,
  `god_level` tinyint(3) NOT NULL DEFAULT '0',
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_idx` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `worship_log_20150102`
--

DROP TABLE IF EXISTS `worship_log_20150102`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `worship_log_20150102` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `god_id` tinyint(3) NOT NULL,
  `worship_id` smallint(6) NOT NULL,
  `god_level` tinyint(3) NOT NULL DEFAULT '0',
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_idx` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `worship_log_20150103`
--

DROP TABLE IF EXISTS `worship_log_20150103`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `worship_log_20150103` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `god_id` tinyint(3) NOT NULL,
  `worship_id` smallint(6) NOT NULL,
  `god_level` tinyint(3) NOT NULL DEFAULT '0',
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_idx` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `worship_log_20150104`
--

DROP TABLE IF EXISTS `worship_log_20150104`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `worship_log_20150104` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `god_id` tinyint(3) NOT NULL,
  `worship_id` smallint(6) NOT NULL,
  `god_level` tinyint(3) NOT NULL DEFAULT '0',
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_idx` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `worship_log_20150105`
--

DROP TABLE IF EXISTS `worship_log_20150105`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `worship_log_20150105` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `god_id` tinyint(3) NOT NULL,
  `worship_id` smallint(6) NOT NULL,
  `god_level` tinyint(3) NOT NULL DEFAULT '0',
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_idx` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `worship_log_20150106`
--

DROP TABLE IF EXISTS `worship_log_20150106`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `worship_log_20150106` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `god_id` tinyint(3) NOT NULL,
  `worship_id` smallint(6) NOT NULL,
  `god_level` tinyint(3) NOT NULL DEFAULT '0',
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_idx` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `worship_log_20150107`
--

DROP TABLE IF EXISTS `worship_log_20150107`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `worship_log_20150107` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `god_id` tinyint(3) NOT NULL,
  `worship_id` smallint(6) NOT NULL,
  `god_level` tinyint(3) NOT NULL DEFAULT '0',
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_idx` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `worship_log_20150108`
--

DROP TABLE IF EXISTS `worship_log_20150108`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `worship_log_20150108` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `god_id` tinyint(3) NOT NULL,
  `worship_id` smallint(6) NOT NULL,
  `god_level` tinyint(3) NOT NULL DEFAULT '0',
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_idx` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `worship_log_20150109`
--

DROP TABLE IF EXISTS `worship_log_20150109`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `worship_log_20150109` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `god_id` tinyint(3) NOT NULL,
  `worship_id` smallint(6) NOT NULL,
  `god_level` tinyint(3) NOT NULL DEFAULT '0',
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_idx` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `worship_log_20150110`
--

DROP TABLE IF EXISTS `worship_log_20150110`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `worship_log_20150110` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `god_id` tinyint(3) NOT NULL,
  `worship_id` smallint(6) NOT NULL,
  `god_level` tinyint(3) NOT NULL DEFAULT '0',
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_idx` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `worship_log_20150111`
--

DROP TABLE IF EXISTS `worship_log_20150111`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `worship_log_20150111` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `god_id` tinyint(3) NOT NULL,
  `worship_id` smallint(6) NOT NULL,
  `god_level` tinyint(3) NOT NULL DEFAULT '0',
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_idx` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `worship_log_20150112`
--

DROP TABLE IF EXISTS `worship_log_20150112`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `worship_log_20150112` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `god_id` tinyint(3) NOT NULL,
  `worship_id` smallint(6) NOT NULL,
  `god_level` tinyint(3) NOT NULL DEFAULT '0',
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_idx` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `worship_log_20150113`
--

DROP TABLE IF EXISTS `worship_log_20150113`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `worship_log_20150113` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `god_id` tinyint(3) NOT NULL,
  `worship_id` smallint(6) NOT NULL,
  `god_level` tinyint(3) NOT NULL DEFAULT '0',
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_idx` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `worship_log_20150114`
--

DROP TABLE IF EXISTS `worship_log_20150114`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `worship_log_20150114` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `god_id` tinyint(3) NOT NULL,
  `worship_id` smallint(6) NOT NULL,
  `god_level` tinyint(3) NOT NULL DEFAULT '0',
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_idx` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `worship_log_20150115`
--

DROP TABLE IF EXISTS `worship_log_20150115`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `worship_log_20150115` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `god_id` tinyint(3) NOT NULL,
  `worship_id` smallint(6) NOT NULL,
  `god_level` tinyint(3) NOT NULL DEFAULT '0',
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_idx` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2014-11-04 17:10:43
