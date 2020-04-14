FROM core/php54apache24:v1

MAINTAINER fooldoc <www.fooldoc.com>

ENV rdkafka rdkafka-4.0.3
RUN ${wgetrun} -O ${rdkafka}.tgz http://pecl.php.net/get/${rdkafka}.tgz \
    && tar zxvf ${rdkafka}.tgz \
    && cd ${rdkafka} \
    && ${php_run_path}/bin/phpize \
    && ./configure --with-php-config=${php_run_path}/bin/php-config \
    && make \
    && make install \
    && cd ../ && rm -rf ${rdkafka} ${rdkafka}.tgz

#-------初始化--------
ADD docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
ADD docker-init.sh /usr/local/bin/docker-init.sh
ADD public.sh ${work}/public.sh
#crontab 追加
ADD cron/root /var/spool/cron/root
#把整个文件夹给仍进去
ADD apache/ ${work}/apache
#把整个文件夹给仍进去
ADD php/ ${work}/php

RUN chmod +x /usr/local/bin/docker-entrypoint.sh \
    && chmod +x /usr/local/bin/docker-init.sh \
    && chmod +x ${work}/public.sh \
    && bash /usr/local/bin/docker-init.sh

ENTRYPOINT docker-entrypoint.sh
