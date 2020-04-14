#!/bin/bash
source /etc/profile
chown -R web:web /weblog/
${work}/mysql start
#初始化宿主机访问
$mysql_run_path/bin/mysql -uroot -proot  << EOF
CREATE USER 'root'@'${HOST_IP}' IDENTIFIED BY 'root';
grant all privileges on *.* to 'root'@'${HOST_IP}';
EOF
tail -f /dev/null
