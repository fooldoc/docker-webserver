FROM centos:7

MAINTAINER fooldoc <www.fooldoc.com>


#ADD CentOS7-Base-163.repo /etc/yum.repos.d/CentOS7-Base-163.repo
#RUN mv /etc/yum.repos.d/CentOS7-Base-163.repo /etc/yum.repos.d/CentOS-Base.repo
#RUN yum clean all && yum makecache
RUN yum install -y wget vim bzip2 gcc gcc-c++ automake autoconf libtool make net-tools \
    && yum install epel-release -y \
    #cmake3需要epel-release
    && yum install cmake3 -y \
    #Install_Boost
    && yum install python-devel -y  \
    #Cannot find appropriate system libraries for WITH_SSL=system. Make sure you have specified a supported SSL version
    && yum install ncurses-devel openssl-devel -y \
    && yum clean all

CMD ["/usr/sbin/init"]
