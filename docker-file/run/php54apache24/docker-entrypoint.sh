#!/bin/bash
#可以把hosts文件放到docker容器的的这个位置/work/webconfig/host/4399/hosts
#注意这个路径是自己外部挂载进来的，这样才能实现宿主机与容器一致
#然后本地hosts追加一行#-------------这行开始的hosts会被同步到docker-------------------，关键字，这样可以实现本地与docker分开并且hosts可以一致
#这样就可以解决每次重新start容器，hosts丢失的问题，还能实现本地+docker同步，并且可以备份迁移
set_hosts(){

if [ -s "/work/webconfig/host/4399/hosts" ]; then
line=`sed -n '/#-------------这行开始的hosts会被同步到docker-------------------/=' /work/webconfig/host/4399/hosts`
data=`sed -n "$line,$"p /work/webconfig/host/4399/hosts`
cat>>/tmp/hosts<<EOF
$data
EOF
localhost_host="127.0.0.1"
#这个docker的ip 从外部变量传递过来
docker_host=$HOST_IP
sed -i -r "s#$localhost_host\s#$docker_host #" /tmp/hosts
data=`sed -n "1,$"p /tmp/hosts`
cat>>/etc/hosts<<EOF
$data
EOF


else
        echo "文件不存在跳过hosts自动同步！"
fi
}
set_hosts


web_log_path=weblog
web_path="web"
mkdir -p /$web_log_path/apache
mkdir -p /$web_log_path/php
mkdir -p /$web_log_path/web/dev
mkdir -p /$web_log_path/web/lct
mkdir -p /$web_log_path/web/pro
mkdir -p /$web_log_path/cli/dev
mkdir -p /$web_log_path/cli/lct
mkdir -p /$web_log_path/cli/pro
mkdir -p /$web_log_path/crontab/dev
mkdir -p /$web_log_path/crontab/lct
mkdir -p /$web_log_path/crontab/pro

chmod 740 -R /$web_log_path
chown -R web:web /$web_log_path

mkdir -p /$web_path
mkdir -p /webresource
chmod 740 -R /$web_path
chown -R web:web /$web_path
chmod 740 -R /webresource
chown -R web:web /webresource

set_php_variable(){
	local key=$1
	local value=$2
	if grep -q -E "^$key\s*=" $php_run_path/etc/php.ini;then
		sed -i -r "s#^$key\s*=.*#$key=$value#" $php_run_path/etc/php.ini
	else
		sed -i -r "s#;\s*$key\s*=.*#$key=$value#" $php_run_path/etc/php.ini
	fi

	if ! grep -q -E "^$key\s*=" $php_run_path/etc/php.ini;then
		echo "$key=$value" >> $php_run_path/etc/php.ini
	fi
}

set_php_variable disable_functions "checkdnsrr,chgrp,chown,chroot,dl,error_log,ftp_connect,ftp_get,ftp_login,ftp_pasv,getmxrr,getservbyname,getservbyport,gzcompress,gzopen,gzpassthru,highlight_file,ini_alter,ini_restore,openlog,passthru,pfsockopen,popen,popepassthru,posix_ctermid,posix_get_last_error,posix_getcwd,posix_getegid,posix_geteuid,posix_getgid,posix_getgrgid,posix_getgrnam,posix_getgroups,posix_getlogin,posix_getpgid,posix_getpgrp,posix_getpid,posix_getppid,posix_getpwnam,posix_getpwuid,posix_getrlimit,posix_getsid,posix_getuid,posix_isatty,posix_kill,posix_mkfifo,posix_setegid,posix_seteuid,posix_setgid,posix_setpgid,posix_setsid,posix_setuid,posix_strerror,posix_times,posix_ttyname,posix_uname,proc_close,proc_get_status,proc_open,readlink,scandir,set_time_limit,show_source,socket_accept,socket_bind,socket_listen,stream_socket_accept,stream_socket_client,stream_socket_server,stream_socket_srver,symlink,syslog,system,zlib.compress"

crond

chown -R web:web /weblog/
chown -R web:web /var/logs/kafka_event

${work}/httpd start
tail -f /dev/null