#!/bin/sh

stop_php54(){
cd $compose_run_dir/webphp54
docker-compose stop
}
stop_php73(){
cd $compose_run_dir/webphp7
docker-compose stop
}

stop_kafka(){
cd $compose_run_dir/kafka
docker-compose stop
}
stop_redis(){
cd $compose_run_dir/redis
docker-compose stop
}
stop_memcached(){
cd $compose_run_dir/memcached
docker-compose stop
}
stop_elasticsearch(){
cd $compose_run_dir/elasticsearch
docker-compose stop
}

stop_elasticsearch751(){
cd $compose_run_dir/elasticsearch751
docker-compose stop
}


stop_node811(){
cd $compose_run_dir/node811
docker-compose stop
}
