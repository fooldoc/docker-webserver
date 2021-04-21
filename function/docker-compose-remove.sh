#!/bin/sh

remove_php54(){
cd $compose_run_dir/webphp54
docker-compose stop
docker-compose rm
}
remove_php73(){
cd $compose_run_dir/webphp7
docker-compose stop
docker-compose rm
}

remove_kafka(){
cd $compose_run_dir/kafka
docker-compose stop
docker-compose rm
}
remove_redis(){
cd $compose_run_dir/redis
docker-compose stop
docker-compose rm
}
remove_memcached(){
cd $compose_run_dir/memcached
docker-compose stop
docker-compose rm
}
remove_elasticsearch(){
cd $compose_run_dir/elasticsearch
docker-compose stop
docker-compose rm
}

remove_elasticsearch751(){
cd $compose_run_dir/elasticsearch751
docker-compose stop
docker-compose rm
}

remove_node811(){
cd $compose_run_dir/node811
docker-compose stop
docker-compose rm
}