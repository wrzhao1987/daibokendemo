<?php
date_default_timezone_set('GMT');
require 'bad_job.php';
require 'job.php';
require 'php_error_job.php';

echo dirname(__FILE__);
require dirname(__FILE__).'/../bin/resque';
