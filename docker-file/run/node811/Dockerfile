FROM node:14.16.0-slim

# system local config
RUN true \
    # debian china mirrors
    && sed -i 's/deb.debian.org/mirrors.ustc.edu.cn/g' /etc/apt/sources.list \
    && sed -i 's/security.debian.org/mirrors.ustc.edu.cn/g' /etc/apt/sources.list \
    # timezone to china
    && ln -sf /usr/share/zoneinfo/PRC /etc/localtime

RUN apt-get update \
    && apt-get install -y \
    # node-sass 等编译依赖
    make gcc g++ python \
    # 命令行工具 zsh
    curl wget vim git

ADD docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh

RUN chmod +x /usr/local/bin/docker-entrypoint.sh

# RUN wget https://github.cosm/robbyrussell/oh-my-zsh/raw/master/tools/install.sh -O - | zsh || true
#RUN sh -c "$(wget https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O -)"

#RUN npm config set registry https://registry.npm.taobao.org
#RUN npm install -g @vue/cli-init
#RUN npm install -g cnpm --registry=http://registry.npm.taobao.org
#RUN npm install -g n
#RUN n stable
#RUN npm install -g vue-cli

#RUN npm install --save-dev webpack-cli -g
#RUN npm install webpack -g
RUN mkdir /work

WORKDIR /work

# 给这个目录执行权限，x是执行权限
RUN chmod +x /work



ENTRYPOINT docker-entrypoint.sh
#CMD ["zsh"]