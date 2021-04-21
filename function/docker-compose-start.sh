#!/bin/sh

start_php54(){
cd $compose_run_dir/webphp54
docker-compose up -d
}
start_php73(){
cd $compose_run_dir/webphp7
docker-compose up -d
}

start_kafka(){
cd $compose_run_dir/kafka
docker-compose up -d
}
start_redis(){
cd $compose_run_dir/redis
docker-compose up -d
}
start_memcached(){
cd $compose_run_dir/memcached
docker-compose up -d
}
start_elasticsearch(){
cd $compose_run_dir/elasticsearch
docker-compose up -d
}


start_elasticsearch751(){
cd $compose_run_dir/elasticsearch751
docker-compose up -d
}

start_node811(){
cd $compose_run_dir/node811
docker-compose up -d
}
