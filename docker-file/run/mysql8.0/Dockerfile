FROM core/mysql8.0:v1

MAINTAINER fooldoc <www.fooldoc.com>
ADD docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
ADD docker-init.sh /usr/local/bin/docker-init.sh
ADD public.sh ${work}/public.sh
#------初始化end---------
RUN  chmod +x /usr/local/bin/docker-entrypoint.sh \
     && chmod +x /usr/local/bin/docker-init.sh \
     && chmod +x ${work}/public.sh \
     && bash /usr/local/bin/docker-init.sh

# 服务
EXPOSE 3306
ENTRYPOINT docker-entrypoint.sh


