FROM core/nginx1.8:v1

MAINTAINER fooldoc <www.fooldoc.com>

ADD docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
ADD docker-init.sh /usr/local/bin/docker-init.sh
ADD ng ${work}/ng
ADD public.sh ${work}/public.sh

#把整个文件夹给仍进去

RUN chmod +x /usr/local/bin/docker-entrypoint.sh \
    && chmod +x /usr/local/bin/docker-init.sh \
    && chmod +x ${work}/public.sh \
    && bash /usr/local/bin/docker-init.sh

EXPOSE 80
ENTRYPOINT docker-entrypoint.sh


