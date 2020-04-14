FROM base/nginx1.8:v1

MAINTAINER fooldoc <www.fooldoc.com>

ENV work /work
ENV download_cdn http://soft1.vpser.net
ENV user_group_web web
ENV wgetrun  wget -c --progress=bar:force --prefer-family=IPv4 --no-check-certificate
ENV nginx_run_path /usr/local/nginx
RUN mkdir ${work}
WORKDIR ${work}

ADD jemalloc_install.sh ${work}/jemalloc_install.sh

#把整个文件夹给仍进去


RUN groupadd ${user_group_web} && useradd -g ${user_group_web} ${user_group_web} -M -s /bin/false \
    && chmod +x ${work}/jemalloc_install.sh

#官网地址：https://github.com/jemalloc/jemalloc/releases/download/5.2.0/jemalloc-5.2.0.tar.bz2
#加速地址 http://soft1.vpser.net/lib/jemalloc/jemalloc-5.2.0.tar.bz2


ENV jemalloc jemalloc-5.2.0
RUN ${wgetrun} -O ${jemalloc}.tar.bz2  ${download_cdn}/lib/jemalloc/${jemalloc}.tar.bz2 \
    && tar -jxvf ${jemalloc}.tar.bz2 \
    && cd ${jemalloc} \
    && ./configure \
    && make \
    && make install \
    && cd ../ && rm -rf ${jemalloc} ${jemalloc}.tar.bz2 \
    && bash ${work}/jemalloc_install.sh

# http://nginx.org/download/nginx-1.8.1.tar.gz
ENV nginx nginx-1.8.1
RUN ${wgetrun} -O ${nginx}.tar.gz  http://nginx.org/download/${nginx}.tar.gz


RUN tar zxvf ${nginx}.tar.gz \
    && cd ${nginx} \
    && ./configure --user=${user_group_web} --group=${user_group_web} --prefix=${nginx_run_path} --with-http_ssl_module --with-http_sub_module --with-http_stub_status_module --with-pcre --with-http_secure_link_module --with-http_gzip_static_module --with-ld-opt='-ljemalloc' --with-http_spdy_module --with-ipv6 \
    && make \
    && make install \
    && cd ../ && rm -rf ${nginx} ${nginx}.tar.gz


