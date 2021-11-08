FROM base/php54apache24:v1

MAINTAINER fooldoc <www.fooldoc.com>
ENV work /work
RUN mkdir /work
WORKDIR /work
#-------初始化--------
ENV apache_run_path /usr/local/apache
ENV user_group_web web
ENV wgetrun  wget -c --progress=bar:force --prefer-family=IPv4 --no-check-certificate
ENV download_cdn http://soft1.vpser.net
ENV php_run_path /usr/local/php

RUN ln -s /usr/bin/cmake3 /usr/bin/cmake \
    && cp -frp /usr/lib64/libldap* /usr/lib/ \
	&& groupadd ${user_group_web} && useradd -g ${user_group_web} ${user_group_web} -M -s /bin/false
#RUN yum install libtool-ltdl-devel -y
#-------初始化--------
#------git2.x安装-----
ENV git git-2.13.3
RUN yum install -y perl-ExtUtils-MakeMaker asciidoc xmlto
RUN ${wgetrun} https://www.kernel.org/pub/software/scm/git/${git}.tar.gz \
	&& tar zxf ${git}.tar.gz \
	&& cd ${git} \
	&& ./configure --prefix=/usr/local/git \
	&& make \
	&& make install \
	&& cd ../ && rm -rf ${git} ${git}.tar.gz \
	&& rm -rf /usr/bin/git \
	&& ln -s /usr/local/git/bin/git /usr/bin/git
# apr
ENV apr apr-1.6.3
ENV apr_run_path /usr/local/apr
RUN ${wgetrun} http://archive.apache.org/dist/apr/${apr}.tar.gz \
	&& tar zxf ${apr}.tar.gz \
	&& cd ${apr} \
	&& ./configure --prefix=${apr_run_path} \
	&& make \
	&& make install \
	&& cd ../ && rm -rf ${apr} ${apr}.tar.gz
# apr-util
ENV apr_util apr-util-1.6.1
ENV apr_util_run_path /usr/local/apr-util
RUN ${wgetrun} http://archive.apache.org/dist/apr/${apr_util}.tar.gz \
	&& tar zxf ${apr_util}.tar.gz \
	&& cd ${apr_util} \
	&& ./configure --prefix=${apr_util_run_path} --with-apr=${apr_run_path}/bin/apr-1-config \
	&& make  \
	&& make install \
	&& cd ../ && rm -rf ${apr_util} ${apr_util}.tar.gz

#安装pcre
ENV pcre_path pcre-8.42
ENV pcre_run_path /usr/local/pcre
RUN ${wgetrun} ${download_cdn}/web/pcre/${pcre_path}.tar.bz2 \
    && tar -jxvf ${pcre_path}.tar.bz2 \
    && cd ${pcre_path} \
    && ./configure --prefix=${pcre_run_path} --with-apr=${apr_run_path}/bin/apr-1-config \
    && make \
    && make install \
    && cd ../ && rm -rf ${pcre_path} ${pcre_path}.tar.bz2
#官网下载地址
#https://netix.dl.sourceforge.net/project/pcre/pcre/8.39/pcre-8.39.tar.bz2
#http://soft1.vpser.net/web/pcre/pcre-8.42.tar.bz2
#安装apache
#configure: error: mod_ssl has been requested but can not be built due to prerequisite failures
ENV apache httpd-2.4.38
RUN ${wgetrun} http://mirrors.sohu.com/apache/${apache}.tar.gz \
    && tar zxvf ${apache}.tar.gz \
    && cd ${apache} \
    && ./configure --prefix=${apache_run_path} --with-pcre=${pcre_run_path} --with-apr=${apr_run_path} --with-apr-util=${apr_util_run_path} --enable-mods-shared=most --enable-headers --enable-mime-magic --enable-proxy --enable-so --enable-rewrite --with-ssl --enable-ssl --enable-deflate --enable-mpms-shared=all --with-mpm=prefork --enable-remoteip \
    && make \
    && make install \
    && cd ../ && rm -rf ${apache} ${apache}.tar.gz

#安装php
#---------安装新版libzip----end-----------
ENV iconv_path libiconv-1.15
ENV iconv_run_path /usr/local/iconv
#安装libiconv(iconv函数需要用到)
# 官网下载地址　http://ftp.gnu.org/gnu/libiconv/libiconv-1.15.tar.gz
RUN ${wgetrun} ${download_cdn}/web/libiconv/${iconv_path}.tar.gz \
    && tar zxvf ${iconv_path}.tar.gz -C ${work}/ \
    && cd ${iconv_path} \
    && ./configure --prefix=${iconv_run_path} \
    && make \
    && make install \
    && cd ../ && rm -rf ${iconv_path} ${iconv_path}.tar.gz

# php 官网地址　https://www.php.net/distributions/php-7.3.14.tar.gz
#安装PHP
ENV php_path php-5.4.35
#是否开启是否安装php,fileinfo扩展，请注意查看自己的内存是否大于1G，如果没有请不要安装fileinfo扩展，否则编译报错 --enable-fileinfo  --disable-fileinfo
ENV with_fileinfo --disable-fileinfo
RUN ${wgetrun} http://mirrors.sohu.com/php/${php_path}.tar.gz \
    && tar zxvf ${php_path}.tar.gz -C ${work}/ \
    && cd ${php_path} \
    && ./configure --prefix=${php_run_path} --with-apxs2=${apache_run_path}/bin/apxs --with-config-file-path=${php_run_path}/etc  --enable-sockets --enable-mbstring --with-curl --enable-fpm --enable-zip --with-mcrypt  --enable-gd-native-ttf --with-gettext --enable-ftp --enable-bcmath --with-openssl --with-mhash --enable-soap  --with-iconv-dir=${iconv_run_path} --enable-xml --with-libxml-dir --disable-debug --enable-inline-optimization --disable-rpath --enable-mbregex --enable-shmop --enable-sysvsem --with-mysql=mysqlnd --with-mysqli=mysqlnd --with-pdo-mysql=mysqlnd --enable-pcntl --with-xmlrpc  --with-gd --with-jpeg-dir --with-zlib --with-png-dir --with-freetype-dir --enable-ctype --enable-session ${with_fileinfo} \
    && make \
    && make install \
    && cp ${work}/${php_path}/php.ini-production ${php_run_path}/etc/php.ini \
    && chmod 644 ${php_run_path}/etc/php.ini \
    && cd ../ && rm -rf ${php_path} ${php_path}.tar.gz
#
#-----------------------------------------安装服务端memcache---------------------------
#官网下载地址：https://www.memcached.org/files/memcached-1.5.14.tar.gz
#高速下载地址：http://soft1.vpser.net/web/memcached/memcached-1.5.14.tar.gz
#-----安装扩展memcache
#如果gcc7或者gcc8的版本则需要该步骤
#if gcc -dumpversion|grep -q "^[78]"; then
#      patch -p1 < $package_dir/memcached/libmemcached-1.0.18-gcc7.patch
# fi
#官网下载地址：https://launchpad.net/libmemcached/1.0/1.0.18/+download/libmemcached-1.0.18.tar.gz
#高速下载地址：http://soft1.vpser.net/web/libmemcached/libmemcached-1.0.18.tar.gz
ENV libmemcached libmemcached-1.0.18
RUN ${wgetrun} ${download_cdn}/web/libmemcached/${libmemcached}.tar.gz \
    && tar zxvf ${libmemcached}.tar.gz -C ${work}/ \
    && cd ${libmemcached} \
    && ./configure --prefix=/usr/local/libmemcached  --with-memcached \
    && make \
    && make install \
    && cd ../ && rm -rf ${libmemcached} ${libmemcached}.tar.gz
#----安装php7Memcached---
#官网下载地址：http://pecl.php.net/get/memcached-3.1.4.tgz
#高速下载地址：http://soft1.vpser.net/web/php-memcached/memcached-3.1.4.tgz
ENV phpmemcached memcached-2.2.0
RUN ${wgetrun} ${download_cdn}/web/php-memcached/${phpmemcached}.tgz \
    && tar zxvf ${phpmemcached}.tgz -C ${work}/ \
    && cd ${phpmemcached} \
    && ${php_run_path}/bin/phpize \
    && ./configure --enable-memcached --with-php-config=${php_run_path}/bin/php-config --with-libmemcached-dir=/usr/local/libmemcached/ \
    && make \
    && make install \
    && cd ../ && rm -rf ${phpmemcached} ${phpmemcached}.tgz


#-----------安装redis扩展---------------
#官网下载地址：http://pecl.php.net/get/redis-5.1.0.tgz
ENV redis redis-4.3.0
RUN ${wgetrun} http://pecl.php.net/get/${redis}.tgz \
    && tar zxvf ${redis}.tgz -C ${work}/ \
    && cd ${redis} \
    && ${php_run_path}/bin/phpize \
    && ./configure --with-php-config=${php_run_path}/bin/php-config \
    && make \
    && make install \
    && cd ../ && rm -rf ${redis} ${redis}.tgz

#-----------安装rdkafka扩展---------------
ENV librdkafka librdkafka-1.3.0
RUN ${wgetrun} -O ${librdkafka}.tar.gz https://github.com/edenhill/librdkafka/archive/v1.3.0.tar.gz \
    && tar zxvf ${librdkafka}.tar.gz \
    && cd ${librdkafka} \
    && ./configure \
    && make \
    && make install \
    && cd ../ && rm -rf ${librdkafka}.tar.gz

ENV rdkafka rdkafka-3.0.5
RUN ${wgetrun} -O ${rdkafka}.tgz http://pecl.php.net/get/${rdkafka}.tgz \
    && tar zxvf ${rdkafka}.tgz \
    && cd ${rdkafka} \
    && ${php_run_path}/bin/phpize \
    && ./configure --with-php-config=${php_run_path}/bin/php-config \
    && make \
    && make install \
    && cd ../ && rm -rf ${rdkafka} ${rdkafka}.tgz

#svn 安装
ENV svn subversion-1.14.1
RUN ${wgetrun} http://archive.apache.org/dist/subversion/${svn}.tar.gz \
    && tar zxvf ${svn}.tar.gz \
    && ${wgetrun} https://www.sqlite.org/2015/sqlite-amalgamation-3081101.zip \
    && unzip sqlite-amalgamation-3081101.zip \
    && mv sqlite-amalgamation-3081101 ${svn}/sqlite-amalgamation \
    && cd ${svn} \
    && ./configure --prefix=/usr/local/subversion --with-apr=/usr/local/apr --with-apr-util=/usr/local/apr-util --with-lz4=internal --with-utf8proc=internal \
    && make \
    && make install \
    && cd ../ && rm -rf ${svn} ${svn}.tar.gz

ENV mongo mongodb-1.2.11
RUN ${wgetrun} http://pecl.php.net/get/${mongo}.tgz \
        && tar zxf ${mongo}.tgz \
        && cd ${mongo} \
        && ${php_run_path}/bin/phpize \
        && ./configure --with-php-config=${php_run_path}/bin/php-config \
        && make \
        && make install \
        && cd ../ && rm -rf ${mongo} && rm -f ${mongo}.tgz