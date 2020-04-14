FROM golang:1.12


MAINTAINER fooldoc <www.fooldoc.com>
#-------初始化--------
ADD docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
ADD docker-init.sh /usr/local/bin/docker-init.sh
ADD go.sh  /etc/profile.d/go.sh
RUN chmod +x /usr/local/bin/docker-entrypoint.sh \
    && chmod +x /usr/local/bin/docker-init.sh \
    && chmod 755 /etc/profile.d/go.sh \
    && bash /usr/local/bin/docker-init.sh
ENTRYPOINT docker-entrypoint.sh
