FROM centos:7

MAINTAINER fooldoc <www.fooldoc.com>

RUN yum install -y wget vim bzip2 gcc gcc-c++ automake autoconf libtool make net-tools \
    && yum install epel-release -y \
    #*** [xml/apr_xml.lo] Error 1
    #configure: error: mod_ssl has been requested but can not be built due to prerequisite failures
    && yum install cmake3 expat-devel openssl-devel -y \
	&& yum install -y gcc-g77 flex bison make ncurses-devel patch bzip2-devel zlib-devel libjpeg-devel libpng-devel libtiff-devel freetype-devel gettext-devel pam-devel libxml2-devel pcre-devel curl curl-devel libcurl-devel openldap-devel readline-devel \
	#memcached专用
	&& yum install -y libevent-devel \
	#php54 专用
	&& yum install libmcrypt-devel -y \
	#cron
    && yum install -y crontabs \
    && yum install -y unzip zip \
	&& yum clean all

CMD ["/usr/sbin/init"]
