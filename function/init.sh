#!/bin/sh
#初始化安装
init_install(){
#需要root权限用户
need_root_priv

}

install_docker(){
if check_sys packageManager apt;then
    install_docker_ubuntu
elif check_sys packageManager yum;then
    install_docker_centos
fi
echo "docker安装完毕"
}

uninstall_docker(){
if check_sys packageManager apt;then
   apt-get remove docker docker-engine docker.io containerd runc -y
elif check_sys packageManager yum;then
   yum remove docker docker-client docker-client-latest docker-common docker-latest docker-latest-logrotate docker-logrotate docker-engine -y
fi
echo "docker卸载完毕"
}


install_docker_ubuntu(){
apt-get -y update
apt-get -y install apt-transport-https ca-certificates curl  gnupg-agent software-properties-common
curl -fsSL http://mirrors.aliyun.com/docker-ce/linux/ubuntu/gpg | sudo apt-key add -
add-apt-repository "deb [arch=amd64] http://mirrors.aliyun.com/docker-ce/linux/ubuntu $(lsb_release -cs) stable"
apt-get -y update
apt-get -y install docker-ce docker-ce-cli containerd.io

string=`apt-cache madison docker-ce|sed -n "1,1"p`
IFS="|"
array=($string)
docker_ce_version=${array[1]}
docker_ce_version=`echo $docker_ce_version |sed 's/ //g'`
echo "准备开始安装docker"
echo $docker_ce_version
apt-get -y  install docker-ce=${docker_ce_version} docker-ce-cli=${docker_ce_version} containerd.io

}
install_docker_centos(){
echo "准备开始安装docker"
yum install -y yum-utils device-mapper-persistent-data lvm2
yum-config-manager --add-rep https://download.docker.com/linux/centos/docker-ce.repo
yum install docker-ce docker-ce-cli containerd.io -y
}

install_docker_compose(){
echo "准备开始安装docker"
curl -L "https://github.com/docker/compose/releases/download/1.25.3/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose
echo "docker-compose安装完毕"
}