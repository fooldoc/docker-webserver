#!/bin/bash
ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
#载入函数
load_functions(){
	local function=$1
	if [[ -s ${work}/${function}.sh ]];then
		. ${work}/${function}.sh
	else
		echo "${work}/${function}.sh not found,shell can not be executed."
		exit 1
	fi
}
load_functions public
disable_selinux

nginx_conf=${work}/ng
#-------------复制 配置文件----------
web_log_path=weblog
web_path="web"

mkdir -p /weblog/nginx

mkdir -p /$web_log_path/nginx

chmod 740 -R /$web_log_path
chown -R web:web /$web_log_path

mkdir -p /$web_path
mkdir -p /webresource
chmod 740 -R /$web_path
chown -R web:web /$web_path
chmod 740 -R /webresource
chown -R web:web /webresource

mkdir -p $nginx_run_path/conf/vhost
\cp $nginx_conf/proxy.conf  $nginx_run_path/conf/vhost/
chmod 644 $nginx_run_path/conf/vhost/proxy.conf
\cp $nginx_conf/host_localhost.conf  $nginx_run_path/conf/vhost/host_localhost.conf
chmod 644 $nginx_run_path/conf/vhost/host_localhost.conf

mv $nginx_run_path/conf/nginx.conf $nginx_run_path/conf/nginx.conf.old
\cp $nginx_conf/nginx.conf  $nginx_run_path/conf/nginx.conf
chmod 644 $nginx_run_path/conf/nginx.conf

\cp $nginx_conf/nginx ${work}/nginx
chmod +x  ${work}/nginx
