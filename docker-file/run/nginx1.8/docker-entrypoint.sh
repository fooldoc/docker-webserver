#!/bin/bash
#启动nginx

www_log_path="wwwlog"
mkdir -p /$www_log_path/nginx
chmod 740 -R /$www_log_path
chown -R web:web /$www_log_path

chown -R web:web /weblog/

${work}/nginx start

tail -f /dev/null