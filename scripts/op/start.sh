#!/bin/bash

if [ $UID -ne 0 ]; then
	echo "Superuser privileges are required to run this script."
	exit 1
fi
echo "note: make sure all server is stoped state"

# web server
echo "start nginx..."
#nginx

# php-fpm
echo "starting php5-fpm..."
/etc/init.d/php5-fpm start

# redis server
echo "start redis..."
redis-server  /home/cap/redis/redis-default/redis.conf
redis-server  /home/cap/redis/redis-1/redis.conf

# rank server
#cd /home/zcc/data


POMELO_HOME=/home/zcc/ws/cap-wspush
# pomelo server
echo "start pomelo server..."
cd $POMELO_HOME/game-server
screen -d -m pomelo start 

# pomelo worker
echo "start pomelo worker..."
cd $POMELO_HOME/pomelo_worker
./pushworker

# resque worker
echo "start resque worker..."
DEPLOY_HOME=/usr/share/nginx/www/nami-server
cd $DEPLOY_HOME/scripts/worker/presque/
# resque worker
screen -d -m bash start_presque_worker.sh

echo "all server started"

