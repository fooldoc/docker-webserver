FROM centos:7

MAINTAINER fooldoc <www.fooldoc.com>
RUN yum install -y wget vim bzip2 gcc gcc-c++ automake autoconf libtool make net-tools \
    && yum install openssl-devel -y \
    && yum install gcc-g77 flex bison make ncurses-devel patch -y \
	&& yum install -y bzip2-devel zlib-devel libjpeg-devel libpng-devel libtiff-devel freetype-devel gettext-devel \
	&& yum install -y pam-devel libxml2-devel pcre-devel curl curl-devel libcurl-devel openldap-devel readline-devel \
	&& yum clean all

CMD ["/usr/sbin/init"]