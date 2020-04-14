FROM base/mysql8.0:v1

MAINTAINER fooldoc <www.fooldoc.com>
ENV work /work
ENV mysql_run_path /usr/local/mysql
ENV wgetrun  wget -c --progress=bar:force --prefer-family=IPv4 --no-check-certificate
ENV download_cdn http://soft1.vpser.net
RUN mkdir ${work}
WORKDIR ${work}
#------初始化end---------
#命令拆分，不能不会走缓存和上面的和再一起不会走缓存，真神奇，怀疑是命令过长导致
RUN ln -s /usr/bin/cmake3 /usr/bin/cmake \
    && groupadd mysql && useradd -g mysql mysql -M -s /bin/false


#------初始化end---------
ENV mysql mysql-8.0.13
#使用mysql包自带boost的
ENV boost_path ${work}/${mysql}/boost/boost_1_67_0
#现在都使用自带boost包的mysql了

#官网地址：https://github.com/jemalloc/jemalloc/releases/download/5.2.0/jemalloc-5.2.0.tar.bz2
#加速地址 http://soft1.vpser.net/lib/jemalloc/jemalloc-5.2.0.tar.bz2
ENV jemalloc jemalloc-5.2.0
RUN ${wgetrun} -O ${jemalloc}.tar.bz2  ${download_cdn}/lib/jemalloc/${jemalloc}.tar.bz2 \
    && tar -jxvf ${jemalloc}.tar.bz2 \
    && cd ${jemalloc} \
    && ./configure \
    && make \
    && make install \
    && cd ../ && rm -rf ${jemalloc} ${jemalloc}.tar.bz2
#ENV cmake cmake-3.16.3
#ENV cmake_run_path /usr/local/cmake
#RUN wget -O ${cmake}.tar.gz  https://github.com/Kitware/CMake/releases/download/v3.16.3/cmake-3.16.3.tar.gz \
#    && tar zxvf ${cmake}.tar.gz \
#    && cd ${cmake} \
#    && /configure --prefix=${cmake_run_path} \
#   && make \
#   && make install
#个人服务器总内存为2G，内存不够安装8.0－－－－－创建交换分区 并 开启－－－－－
#RUN dd if=/dev/zero of=/swapfile bs=64M count=16 \
#    && mkswap /swapfile \
#    && swapon /swapfile
# 这里会报错－－－交换分区

#RUN ${wgetrun} -O boost_1_67_0.tar.bz2 https://dl.bintray.com/boostorg/release/1.67.0/source/boost_1_67_0.tar.bz2 \
#    &&  tar -jxvf boost_1_67_0.tar.bz2 -C ${work}/
#tar -jxvf 需要先安装 bzip2
#RUN wget -O boost_1_67_0.tar.bz2 http://soft1.vpser.net/lib/boost/boost_1_67_0.tar.bz2 \
#    &&  tar -jxvf boost_1_67_0.tar.bz2 -C /work/
# 官方下载地址　注意看这个是自带boost包的
 #https://dev.mysql.com/get/Downloads/MySQL-8.0/mysql-boost-8.0.13.tar.gz

RUN cd ${work} \
    && ${wgetrun} -O ${mysql}.tar.gz  ${download_cdn}/datebase/mysql/${mysql}.tar.gz \
    && tar zxvf ${mysql}.tar.gz \
    && cd ${mysql} \
    && cmake -DCMAKE_INSTALL_PREFIX=${mysql_run_path} -DSYSCONFDIR=/etc -DWITH_MYISAM_STORAGE_ENGINE=1 -DWITH_INNOBASE_STORAGE_ENGINE=1 -DWITH_PARTITION_STORAGE_ENGINE=1 -DWITH_FEDERATED_STORAGE_ENGINE=1 -DEXTRA_CHARSETS=all -DDEFAULT_CHARSET=utf8mb4 -DDEFAULT_COLLATION=utf8mb4_general_ci -DWITH_EMBEDDED_SERVER=1 -DENABLED_LOCAL_INFILE=1 -DWITH_BOOST=${boost_path} \
    && make \
    && make install \
    && cd ../ && rm -rf ${mysql} ${mysql}.tar.gz

##----------安装完成后可以关闭交换分区 并删除交换分区 文件－－－－－－－－－－
##RUN swapoff /swapfile \
##    && rm -rf /swapfile
#
#RUN yum clean all

