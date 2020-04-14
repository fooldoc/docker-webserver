#!/bin/bash
crond
chown -R web:web /weblog/
${work}/httpd start
tail -f /dev/null