<?php
ini_set('display_errors', 1);
error_reporting(E_ALL);
date_default_timezone_set('GMT');
openlog("queue-cap", LOG_PID|LOG_PERROR, LOG_LOCAL0);
require 'arena.php';
require 'fragindex.php';
require 'user.php';
require 'mission.php';
require 'battle.php';
require 'item.php';
require 'deck.php';
require 'equip.php';
require 'dball.php';
require 'card.php';
require 'kpi.php';

echo dirname(__FILE__)."\n";
require dirname(__FILE__).'/../../../lib/php-resque/bin/resque';

