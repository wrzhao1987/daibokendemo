<?php
// Find and initialize Composer
require_once __DIR__ . '/../../../lib/php-resque/vendor/autoload.php';

if (!class_exists('Composer\Autoload\ClassLoader', false)) {
	die(
		'You need to set up the project dependencies using the following commands:' . PHP_EOL .
		'curl -s http://getcomposer.org/installer | php' . PHP_EOL .
		'php composer.phar install' . PHP_EOL
	);
}
