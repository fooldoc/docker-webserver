# docker-webserver:提供web服务lnmp,lanmp,php,apache,nginx,mysql,redis,memcached,kafka等各种服务

支持系统环境
========
* Liunx
* Windows
* Mac
* 任何支持安装docker docker-compose的系统

功能介绍
========
1. 一键傻瓜式安装docker
2. 一键傻瓜式安装docker-compose
3. 一键启动,停止,关闭,编译docker-compose服务,没有docker,docker-compose基础的都可以傻瓜式使用
4. dockerfile源码编译lnmp,lanmp,php,apache,nginx,mysql,redis,memcached,kafka等各种服务
5. 适合对象:开发本地环境使用,快速搭建web服务,方便在企业中进行开发等,个人博客站使用,docker兴趣爱好者学习使用



安装&使用说明
========
1. 切换到root帐号权限,
2. 根目录下授权可执行权限:
chmod +x install.sh
3. 执行命令:
bash install.sh

############################################################################

#############################################################################

请选择要执行的操作

一键源码编译webserver服务，包含php+mysql+apache+nginx,注意是源码自主编译非直接拉官方的源
############################################################################
1) 安装docker,如果安装不成功，可能是源的问题，自己处理或者自行安装！官网地址：https://docs.docker.com/install/
2) 安装docker-compose,如果安装不成功自行安装，这个安装最简单了！官网地址：https://docs.docker.com/compose/install/
3) 一键删除docker，安装前如果不确定自己系统有没有可以执行一次
4) 安装服务列表(支持重新编译)
5) 启动服务列表
6) 删除服务列表
7) 停止服务列表