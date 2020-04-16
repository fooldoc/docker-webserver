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
6. 解决企业电脑与自己电脑环境配置真正的高度统一!


安装
========
1. 切换到root帐号权限,
2. 根目录下授权可执行权限:
chmod +x install.sh
3. 执行命令:
bash install.sh
选择安装docker
选择安装docker-compose 

使用说明
========

### 设计说明 ###
1. 目录 docker-file 存放所有源码编译的Dockerfile文件
base : 基础层Dockerfile文件,只编译服务所需yum相关脚本
core : 核心层主要是编译服务的各种安装包等
run  : 服务可以使用的最外层容器,该层主要处理一些动态型脚本,在本地快速更改脚本重新编译容器生效提供了快捷操作
run层里面有两个shell文件
docker-init.sh :主要是对应服务的基础编译相关配置,正常大家是不需要去关心这个文件的
docker-entrypoint.sh :这个是容器启动入口文件,大家在改对应容器服务的配置,比如改Php.ini配置,都可以在这里做操作,相关方法已经实现了,复用就行了


三层架构设计,并不会使镜像变大!因为每一层都会删除各种垃圾安装包,所以不用担心这个问题.
另外这样设计的目的在于,本地开发使用各种服务不同的场景可以快速的新增每一层所需的服务,比如你只改改该服务的配置文件,
那么你只需要复制一层run层即可,比如你需要拥有不同版本的服务,那么正常情况下版本改动比较小的话,你只需要加core层与run层即可!
这样设计的目的是快速使用镜像缓存!并且架构清晰!如果单层结构镜像缓存失效得重现编译,非常浪费开发时间!

2. 目录 docker-compose 属于应用层了
base : 只是为了快速编译base层镜像
core : 只是为了快速编译core层镜像
run  : run层才是我们真在的应用层

### 使用前部署配置 ###
需要自行修改的配置如下:
1.docker-compose, run层 应用层肯定是需要大家根据自己的服务来配置的,大家可以参考我的模板自行修改配置,
针对docker-compose的参数配置,大家可以直接看跟目录下config文件夹里面的的all.yml文件和docker-compose.yml涵盖了大部分的配置可以当作文档使用
2.另外需要特别修改的几个配置如下:
1)修改变量IP:
webphp54+webphp7的 docker-compose.yml
有个配置:
  environment:
    - HOST_IP=172.17.0.1

这个参数是必填的,传递HOST_IP这个参数到容器里面,大家自行执行命令:
ifconfig 
然后查看docker0的ip自己修改填入该项
2)修改host文件同步地址
environment:
    - HOST_PATH=/xxx/hosts
    
这个参数是选填的,主要作用是把你设置路径的hosts文件同步到docker容器里面,可以做到同步宿主机的部分hosts到容器里面解决host双向问题,
使用的话就是 hosts文件里面 必须加一行:
#-------------这行开始的hosts会被同步到docker-------------------
加了这行之后,以这行为分割,往下的host都会被同步到docker容器里面,往上的则不会,这样就可以宿主机与容器共用,还能满足宿主机单独的host场景.

### 开始使用容器服务 ###
执行命令:
bash install.sh
选择安装服务,或者是自己到docker-compose用命令行自主编译启动容器都行,命令行只是便捷操作而已!
PS:安装mysql的时候初始化会卡住几分钟,耐心等待即可

### 如何保持公司电脑与自己电脑环境配置高度统一 ###
将所有配置搞到私人仓库,举个例子:
.ssh
/etc/hosts
nginx,apache各种配置
全部搞到私人仓库,然后挂载到docker容器里面,这样就高度保持一致的服务,针对hosts文件,可以从私人仓库软连接到宿主机,
然后挂载到容器里面,接下来利用我已经处理好的配置一下即可实现,宿主机与容器双向同步了!

#===============================================================================
#   SYSTEM REQUIRED:  docker-webserver
#   DESCRIPTION:  源码编译docker-webserver
#   AUTHOR: fooldoc
#   微信公众号: 傻瓜文档
#   博客:www.fooldoc.com
#   EMAIL: 949477774@qq.com
#   time:2020-02-09
#===============================================================================