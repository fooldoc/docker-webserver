FROM core/php7apache24:v1

MAINTAINER fooldoc <www.fooldoc.com>
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
    && chmod +x ${work}/public.sh

RUN bash /usr/local/bin/docker-init.sh
ENTRYPOINT docker-entrypoint.sh
