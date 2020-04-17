#!/bin/bash
#===============================================================================
#   SYSTEM REQUIRED:  docker-webserver
#   DESCRIPTION:  源码编译docker-webserver
#   AUTHOR: fooldoc
#   微信公众号: 傻瓜文档
#   博客:www.fooldoc.com
#   EMAIL: 949477774@qq.com
#   time:2020-02-09
#===============================================================================
cur_dir=`pwd`
MemTotal=`free -m | grep Mem | awk '{print  $2}'`
conf_dir=$cur_dir/conf
compose_base_dir=$cur_dir/docker-compose/base
compose_core_dir=$cur_dir/docker-compose/core
compose_run_dir=$cur_dir/docker-compose/run
#载入函数
load_functions(){
	local function=$1
	if [[ -s $cur_dir/function/${function}.sh ]];then
		. $cur_dir/function/${function}.sh
	else
		echo "$cur_dir/function/${function}.sh not found,shell can not be executed."
		exit 1
	fi
}
#配置linux
main(){
#开始载入
load_functions public
load_functions init
load_functions docker-compose-install
load_functions docker-compose-start
load_functions docker-compose-stop
load_functions docker-compose-remove
clear
echo "#############################################################################"
echo
echo "SYSTEM REQUIRED:  docker-webserver"
echo "DESCRIPTION:  源码编译docker-webserver"
echo "AUTHOR: fooldoc"
echo "微信公众号: 傻瓜文档"
echo "EMAIL:949477774@qq.com"
echo "time:2020-02-09"
echo "博客：http://www.fooldoc.com"
echo "note:本脚使用兼容处理方式，支持各种重复执行安装！"
echo "warning:如安装失败请将/tmp/fooldoc_docker-webserver.log文件发予作者"
echo
echo "############################################################################"
echo
#初始化配置
init_install

#菜单
memu_index
}

#菜单
memu_index(){
echo "#############################################################################"
echo
echo "请选择要执行的操作"
echo
echo "一键源码编译webserver服务，包含php+mysql+apache+nginx,注意是源码自主编译非直接拉官方的源"
echo "############################################################################"
echo "1) 安装docker,如果安装不成功，可能是源的问题，自己处理或者自行安装！官网地址：https://docs.docker.com/install/"
echo "2) 安装docker-compose,如果安装不成功自行安装，这个安装最简单了！官网地址：https://docs.docker.com/compose/install/"
echo "3) 一键删除docker，安装前如果不确定自己系统有没有可以执行一次"
echo "4) 安装服务列表(支持重新编译)"
echo "5) 启动服务列表"
echo "6) 删除服务列表"
echo "7) 停止服务列表"
read menu_select
case $menu_select in
1)
    install_docker
	;;
2)
	install_docker_compose
        ;;
3)
	uninstall_docker
        ;;
4)
	memu_install
        ;;
5)
	memu_start
        ;;
6)
	memu_remove
        ;;
7)
	memu_stop
        ;;
esac
}

memu_install(){
echo "#############################################################################"
echo
echo "请选择要执行的操作"
echo
echo "安装docker-compose服务列表(支持重新编译)"
echo "############################################################################"
echo "1) 一键安装服务：php7.3+nginx+apache+mysql(注意该服务与下面的服务php5.4冲突,只能启用一个)"
echo "2) 一键安装服务：php5.4+nginx+apache+mysql(注意该服务与上面的服务php7.3冲突,只能启用一个)"
echo "3) 一键安装服务：kafka"
echo "4) 一键安装服务：memcached"
echo "5) 一键安装服务：redis"
echo "6) 一键安装服务：elasticsearch"
read menu_select
case $menu_select in
1)
	install_php73
        ;;
2)
	install_php54
        ;;
3)
	install_kafka
        ;;
4)
	install_memcached
        ;;
5)
	install_redis
        ;;
6)
	install_elasticsearch
        ;;
esac
}

memu_start(){
echo "#############################################################################"
echo
echo "请选择要执行的操作"
echo
echo "启动docker-compose服务列表"
echo "############################################################################"
echo "1) 一键启动服务：php7.3+nginx+apache+mysql(注意该服务与下面的服务php5.4冲突,只能启用一个)"
echo "2) 一键启动服务：php5.4+nginx+apache+mysql(注意该服务与上面的服务php7.3冲突,只能启用一个)"
echo "3) 一键启动服务：kafka"
echo "4) 一键启动服务：memcached"
echo "5) 一键启动服务：redis"
echo "6) 一键启动服务：elasticsearch"
read menu_select
case $menu_select in
1)
	start_php73
        ;;
2)
	start_php54
        ;;
3)
	start_kafka
        ;;
4)
	start_memcached
        ;;
5)
	start_redis
        ;;
6)
	start_elasticsearch
        ;;
esac
}

memu_stop(){
echo "#############################################################################"
echo
echo "请选择要执行的操作"
echo
echo "停止docker-compose服务列表"
echo "############################################################################"
echo "1) 一键停止服务：php7.3+nginx+apache+mysql(注意该服务与下面的服务php5.4冲突,只能启用一个)"
echo "2) 一键停止服务：php5.4+nginx+apache+mysql(注意该服务与上面的服务php7.3冲突,只能启用一个)"
echo "3) 一键停止服务：kafka"
echo "4) 一键停止服务：memcached"
echo "5) 一键停止服务：redis"
echo "6) 一键停止服务：elasticsearch"
read menu_select
case $menu_select in
1)
	stop_php73
        ;;
2)
	stop_php54
        ;;
3)
	stop_kafka
        ;;
4)
	stop_memcached
        ;;
5)
	stop_redis
        ;;
6)
	stop_elasticsearch
        ;;
esac
}

memu_remove(){
echo "#############################################################################"
echo
echo "请选择要执行的操作"
echo
echo "删除docker-compose服务列表"
echo "############################################################################"
echo "1) 一键删除服务：php7.3+nginx+apache+mysql(注意该服务与下面的服务php5.4冲突,只能启用一个)"
echo "2) 一键删除服务：php5.4+nginx+apache+mysql(注意该服务与上面的服务php7.3冲突,只能启用一个)"
echo "3) 一键删除服务：kafka"
echo "4) 一键删除服务：memcached"
echo "5) 一键删除服务：redis"
echo "6) 一键删除服务：elasticsearch"
read menu_select
case $menu_select in
1)
	remove_php73
        ;;
2)
	remove_php54
        ;;
3)
	remove_kafka
        ;;
4)
	remove_memcached
        ;;
5)
	remove_redis
        ;;
6)
	remove_elasticsearch
        ;;
esac
}

########从这里开始运行程序######
main 2>&1 | tee -a /tmp/fooldoc_docker-webserver.log




