#!/bin/sh

install_php54(){
cd $compose_base_dir
docker-compose build
cd $compose_core_dir/mysql8.0
docker-compose build
cd $compose_core_dir/nginx1.8
docker-compose build
cd $compose_core_dir/php54apache24
docker-compose build
cd $compose_run_dir/webphp54
docker-compose build --no-cache
docker-compose up -d
}
install_php73(){
cd $compose_base_dir
docker-compose build
cd $compose_core_dir/mysql8.0
docker-compose build
cd $compose_core_dir/nginx1.8
docker-compose build
cd $compose_core_dir/php7apache24
docker-compose build
cd $compose_run_dir/webphp7
docker-compose build --no-cache
docker-compose up -d
}

install_kafka(){
cd $compose_run_dir/kafka
docker-compose up -d
}
install_redis(){
cd $compose_run_dir/redis
docker-compose up -d
}
install_memcached(){
cd $compose_run_dir/memcached
docker-compose up -d
}
install_elasticsearch(){
cd $compose_run_dir/elasticsearch
docker-compose up -d
}

