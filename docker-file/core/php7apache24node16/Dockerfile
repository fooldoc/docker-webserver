FROM core/php7apache24:v1

RUN curl -sL https://rpm.nodesource.com/setup_16.x | bash - \
    && yum install nodejs -y \
    && yum install atk java-atk-wrapper at-spi2-atk gtk3 libXt -y

RUN ${wgetrun} https://cdn.npm.taobao.org/dist/chromium-browser-snapshots/Linux_x64/901912/chrome-linux.zip
