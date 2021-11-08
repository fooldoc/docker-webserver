#!/bin/sh

jemalloc_install(){
#lsof -n | grep jemalloc 查看
if [ -s /etc/ld.so.conf.d/local.conf ] && grep "/usr/local/lib" /etc/ld.so.conf.d/local.conf;then
echo 'has'
else
cat>>/etc/ld.so.conf.d/local.conf<<EOF
/usr/local/lib
EOF
fi
/sbin/ldconfig
ln -s /usr/local/lib/libjemalloc.so /usr/lib/libjemalloc.so
}
jemalloc_install