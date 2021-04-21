FROM elasticsearch:7.5.1


MAINTAINER fooldoc <www.fooldoc.com>
#-------初始化--------
ADD docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
ADD docker-init.sh /usr/local/bin/docker-init.sh

RUN chmod +x /usr/local/bin/docker-entrypoint.sh \
    && chmod +x /usr/local/bin/docker-init.sh \
    && bash /usr/local/bin/docker-init.sh

ENTRYPOINT docker-entrypoint.sh
