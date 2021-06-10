#!/bin/bash
#然后本地hosts追加一行#这行开始的hosts会被同步到docker，关键字，这样可以实现本地与docker分开并且hosts可以一致
#这样就可以解决每次重新start容器，hosts丢失的问题，还能实现本地+docker同步，并且可以备份迁移

docker_host=""
#解决mac系统host_ip可以传递docker.for.mac.host.internal来解析出ip
get_host_ip()
{
ADDR=$HOST_IP

TMPSTR=`ping ${ADDR} -c 1 | sed '1{s/[^(]*(//;s/).*//;q}'`

docker_host=${TMPSTR}
}
get_host_ip
set_hosts(){

if [ -s "$HOST_PATH" ]; then
line=`sed -n '/#这行开始的hosts会被同步到docker/=' $HOST_PATH`
data=`sed -n "$line,$"p $HOST_PATH`
rm -rf /tmp/hosts
cat>>/tmp/hosts<<EOF
$data
EOF
localhost_host="127.0.0.1"
#这个docker的ip 从外部变量传递过来
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
mkdir -p /$web_path
mkdir -p /webresource

chmod 740 -R /$web_path
chown -R web:web /$web_path
chmod 740 -R /webresource
chown -R web:web /webresource

chmod 740 -R /$web_log_path
chown -R web:web /$web_log_path
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
#自定义修改php.ini配置
config_php73(){
    set_php_variable error_log /weblog/php/php_errors.log
    set_php_variable post_max_size 50M
    set_php_variable error_reporting E_ALL
    set_php_variable date.timezone PRC
    set_php_variable expose_php Off
    set_php_variable request_order  "CGP"
    set_php_variable cgi.fix_pathinfo 0
    set_php_variable upload_max_filesize 50M
    set_php_variable display_errors Off
    set_php_variable log_errors On
    set_php_variable log_errors_max_len 1024
    set_php_variable disable_functions "checkdnsrr,chgrp,chown,chroot,dl,error_log,exec,ftp_connect,ftp_get,ftp_login,ftp_pasv,getmxrr,getservbyname,getservbyport,gzcompress,gzopen,gzpassthru,highlight_file,ini_alter,ini_restore,openlog,passthru,pfsockopen,popen,popepassthru,posix_ctermid,posix_get_last_error,posix_getcwd,posix_getegid,posix_geteuid,posix_getgid,posix_getgrgid,posix_getgrnam,posix_getgroups,posix_getlogin,posix_getpgid,posix_getpgrp,posix_getpid,posix_getppid,posix_getpwnam,posix_getpwuid,posix_getrlimit,posix_getsid,posix_getuid,posix_isatty,posix_kill,posix_mkfifo,posix_setegid,posix_seteuid,posix_setgid,posix_setpgid,posix_setsid,posix_setuid,posix_strerror,posix_times,posix_ttyname,posix_uname,proc_close,proc_get_status,proc_open,readlink,scandir,set_time_limit,shell_exec,show_source,socket_accept,socket_bind,socket_listen,stream_socket_accept,stream_socket_client,stream_socket_server,stream_socket_srver,symlink,syslog,system,zlib.compress"
    set_php_variable zend_extension opcache.so
    set_php_variable opcache.enable 1
    set_php_variable opcache.enable_cli 1
    set_php_variable opcache.fast_shutdown 1
    set_php_variable opcache.memory_consumption 128
    set_php_variable opcache.interned_strings_buffer 8
    set_php_variable opcache.max_accelerated_files 10000
    set_php_variable opcache.validate_timestamps 0
    set_php_variable opcache.revalidate_freq 60
}

set_disable_ini_php_variable(){
	local key=$1
	local value=$2
	if grep -q -E "^$key\s*=" $php_run_path/etc/php.no_disable.ini;then
		sed -i -r "s#^$key\s*=.*#$key=$value#" $php_run_path/etc/php.no_disable.ini
	else
		sed -i -r "s#;\s*$key\s*=.*#$key=$value#" $php_run_path/etc/php.no_disable.ini
	fi

	if ! grep -q -E "^$key\s*=" $php_run_path/etc/php.no_disable.ini;then
		echo "$key=$value" >> $php_run_path/etc/php.no_disable.ini
	fi
}
#自定义修改CLI模式下的php.ini配置
config_php_no_disable_ini(){
   set_disable_ini_php_variable	memory_limit 256M
   set_disable_ini_php_variable	disable_functions
   set_disable_ini_php_variable max_execution_time 0
}


config_php73
config_php_no_disable_ini
crond

${work}/httpd start
tail -f /dev/null