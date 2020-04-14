#!/bin/bash
#启动nginx

chown -R web:web /weblog/

${work}/nginx start

tail -f /dev/null