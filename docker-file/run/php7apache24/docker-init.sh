#!/bin/bash
ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
# 必须此权限才可以,启动crontab
chmod 644 /var/spool/cron/root

apache_conf=${work}/apache
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
#----apache-----------------
apache_run_path=/usr/local/apache
#单个安装还是一键全部安装，区别在与配置文件是否加上LoadModule php5_module        modules/libphp5.so,防止单个安装启动不了

#-------------复制 配置文件----------------

mv $apache_run_path/conf/extra/httpd-vhosts.conf $apache_run_path/conf/extra/httpd-vhosts.conf.old
mv $apache_run_path/conf/httpd.conf $apache_run_path/conf/http.conf.old
mv $apache_run_path/conf/extra/httpd-default.conf $apache_run_path/conf/extra/httpd-default.conf.old
if [ ! -f "${apache_run_path}/conf/extra/mod_remoteip.conf" ];then
echo "文件不存在"
else
mv $apache_run_path/conf/extra/mod_remoteip.conf $apache_run_path/conf/extra/mod_remoteip.conf.old
fi
mkdir -p $apache_run_path/conf/vhost

\cp $apache_conf/httpd24-php7-lnmpa.conf $apache_run_path/conf/httpd.conf
\cp $apache_conf/httpd24-vhosts-lnmpa.conf $apache_run_path/conf/extra/httpd-vhosts.conf
\cp $apache_conf/httpd-default.conf $apache_run_path/conf/extra/httpd-default.conf
\cp $apache_conf/mod_remoteip.conf $apache_run_path/conf/extra/mod_remoteip.conf

chmod 644 $apache_run_path/conf/extra/*
chmod 644 $apache_run_path/conf/httpd.conf


#-------------php相关设置---------------------------
php_bin=$php_run_path/bin
php_conf=${work}/php
mkdir -p /usr/local/php/{etc,conf.d}
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
config_php73(){
    sed -i -r ':a;N;$!ba;s/\;error_log\s*=\s*syslog/error_log=\/weblog\/php\/php_errors.log/' $php_run_path/etc/php.ini
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
#配置CLI专用php ini文件
config_php_no_disable_ini(){
   \cp ${php_run_path}/etc/php.ini ${php_run_path}/etc/php.no_disable.ini
   set_disable_ini_php_variable	memory_limit 256M
   set_disable_ini_php_variable	disable_functions
   set_disable_ini_php_variable max_execution_time 0
}
set_opcache(){
if [ -s $php_run_path/etc/php.ini ] && grep ';opcache.enable=1' $php_run_path/etc/php.ini;then
echo 'has'
else
sed -i -r '/;opcache.enable=0/a\;开关打开\nopcache.enable=1\n; 可用内存, 酌情而定, 单位 megabytes\nopcache.memory_consumption=128\n;最大缓存的文件数目, 命中率不到 100% 的话, 可以试着提高这个值\nopcache.max_accelerated_files=5000\n;Opcache 会在一定时间内去检查文件的修改时间, 这里设置检查的时间周期, 默认为 2, 单位为秒\nopcache.revalidate_freq=240\n;interned string 的内存大小, 也可调\nopcache.interned_strings_buffer=8\n;是否快速关闭, 打开后在PHP Request Shutdown的时候回收内存的速度会提高\nopcache.fast_shutdown=1\n;不保存文件/函数的注释\nopcache.save_comments=0\n' $php_run_path/etc/php.ini

sed -i -r '/;opcache.enable=0/a\;开关打开\nopcache.enable=1\n; 可用内存, 酌情而定, 单位 megabytes\nopcache.memory_consumption=128\n;最大缓存的文件数目, 命中率不到 100% 的话, 可以试着提高这个值\nopcache.max_accelerated_files=5000\n;Opcache 会在一定时间内去检查文件的修改时间, 这里设置检查的时间周期, 默认为 2, 单位为秒\nopcache.revalidate_freq=240\n;interned string 的内存大小, 也可调\nopcache.interned_strings_buffer=8\n;是否快速关闭, 打开后在PHP Request Shutdown的时候回收内存的速度会提高\nopcache.fast_shutdown=1\n;不保存文件/函数的注释\nopcache.save_comments=0\n' $php_run_path/etc/php.no_disable.ini
fi
}

#获取php phpize安装的so文件位置
get_php_extension_dir(){
#先匹配出该行，然后从第16个字符切割，然后去掉最后一个符号    然后转化路径增加\来转义  \/usr\/local\/php\/lib\/php\/extensions\/no-debug-non-zts-20100525
#要将sed 赋予一个变量 要用 $(sed xxx) 包围起来
php_config_run_path=$(sed -n '/extension_dir=/p' ${php_run_path}/bin/php-config|cut -c16- |sed 's/.$//'|sed 's/[/]/\\\//g')
echo php_config_run_path路径=$php_config_run_path;
php_config_run_path_origin=$(sed -n '/extension_dir=/p' ${php_run_path}/bin/php-config|cut -c16- |sed 's/.$//')
echo php_config_run_path_origin路径=$php_config_run_path_origin;
}
#修改php.ini 扩展目录
set_php_extension_dir(){
get_php_extension_dir
#草这句命令纠结了很久。。带参数key后 需要把$! 前面加上 \
sed -i -r ":a;N;\$!ba;s/\;\s*extension_dir\s*=\s*\"\.\/\"/extension_dir=\"${php_config_run_path}\"/" $php_run_path/etc/php.no_disable.ini
sed -i -r ":a;N;\$!ba;s/\;\s*extension_dir\s*=\s*\"\.\/\"/extension_dir=\"${php_config_run_path}\"/" $php_run_path/etc/php.ini

}
#加载扩展so文件
set_php_extension_so(){
local key=$1
if grep -q -E "$key" $php_run_path/etc/php.ini;then
        echo "已存在$key文件"
else
#在php.ini 中 匹配到 ； extension_dir =  然后在这一行前面 加上  so扩展文件引入， shell脚本太难写了。。在匹配行之后 sed不懂怎么写
sed -i "0,/\;\s*extension_dir/{//s/.*/extension=\"$key\"\n&/}" $php_run_path/etc/php.ini

fi

if grep -q -E "$key" $php_run_path/etc/php.no_disable.ini;then
        echo "已存在$key文件"
else
sed -i "0,/\;\s*extension_dir/{//s/.*/extension=\"$key\"\n&/}" $php_run_path/etc/php.no_disable.ini

fi

}


#-----------------------配置环境变量--------------------------------
ln -s ${php_run_path}/bin/php /usr/bin/php
#----------------复制配置文件----------
 #复制phpn ，快速方面使用命令的 phpn 去除 限制的函数的php.ini 执行
 \cp $php_conf/phpn /usr/local/bin/
 #这行再docker build的时候搞定
 #\cp $php73_path/php.ini-production ${php_run_path}/etc/php.ini
 #chmod 644 ${php_run_path}/etc/php.ini
#-------------修复php.ini-----------
config_php73
config_php_no_disable_ini
#开启opcache
#set_opcache
#---------------------memcached------------
#设置扩展so的路径
set_php_extension_dir
#在php.ini中引入so扩展文件
set_php_extension_so memcached.so
#判断是否存在
if [ -s "${php_config_run_path_origin}/memcached.so" ]; then
        echo "====== memcached installed successfully,======"
        echo "安装成功memcache！"
else
        echo "memcached 安装失败！请将错误信息发给作者！"
fi


#-------------------redis--------------
#设置扩展so的路径
set_php_extension_dir
#在php.ini中引入so扩展文件
set_php_extension_so redis.so
#判断是否存在
if [ -s "${php_config_run_path_origin}/redis.so" ]; then
        echo "====== Redis installed successfully,======"
        echo "安装成功redis！"
else
        echo "Redis 安装失败！请将错误信息发给作者！"
fi

#-------------------rdkafka--------------
#设置扩展so的路径
set_php_extension_dir
#在php.ini中引入so扩展文件
set_php_extension_so rdkafka.so
#判断是否存在
if [ -s "${php_config_run_path_origin}/rdkafka.so" ]; then
        echo "====== rdkafka installed successfully,======"
        echo "安装成功rdkafka！"
else
        echo "rdkafka 安装失败！请将错误信息发给作者！"
fi




#------------------------启动-------------------------
\cp $apache_conf/httpd ${work}/httpd
echo ${work}/httpd
chmod +x  ${work}/httpd