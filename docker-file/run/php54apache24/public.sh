#!/bin/sh

Download_Files()
{
    local URL=$1
    local FileName=$2
    echo $install_dir
    cd $install_dir/
    if [ -s "${FileName}" ]; then
        echo "${FileName} [found]"
    else
        echo "Notice: ${FileName} not found!!!download now..."
        wget -c --progress=bar:force --prefer-family=IPv4 --no-check-certificate ${URL}
    fi
}

#杀掉进程
kill_pid(){
	local processType=$1
	local content=$2
	
	if [[ $processType == "port" ]]; then
		local port=$content
		if [[ `netstat -nlpt | awk '{print $4}' | grep ":${port}$"` != "" ]]; then
			processName=`netstat -nlp | grep -E ":${port} +" | awk '{print $7}' | awk -F'/' '{print $2}' | awk -F'.' 'NR==1{print $1}'`
			pid=`netstat -nlp | grep -E ":${port} +" | awk '{print $7}' | awk -F'/' 'NR==1{print $1}'`
			yes_or_no "We found port $port is occupied by process $processName.would you like to kill this process [Y/n]: " "kill $pid" "echo 'will not kill this process.'"
			if [[ $yn == "y" ]];then
				echo "gonna be kill $processName process,please wait for 5 seconds..."
				sleep 5
				if [[ `ps aux | awk '{print $2}' | grep "^${pid}$"` == "" ]]; then
					echo "kill ${processName} successfully."
				else
					echo "kill ${processName} failed."
				fi
				sleep 2
			fi			
		fi

	elif [[ $processType == "socket" ]]; then
		local socket=$content
		if [[ `netstat -nlp | awk '$1 ~/unix/{print $10}' | grep "^$socket$"` != "" ]]; then
			processName=`netstat -nlp | grep ${socket} | awk '{print $9}' | awk -F'/' '{print $2}'`
			pid=`netstat -nlp | grep $socket | awk '{print $9}' | awk -F'/' '{print $1}'`
			yes_or_no "We found socket $socket is occupied by process $processName.would you like to kill this proess [Y/n]: " "kill $pid" "echo 'will not kill this process.'"
			if [[ $yn == "y" ]];then
				echo "gonna be kill $processName process,please wait for 5 seconds..."
				sleep 5
				if [[ `ps aux | awk '{print $2}' | grep "^${pid}$"` == "" ]]; then
					echo "kill ${processName} successfully."
				else
					echo "kill ${processName} failed."
				fi
				sleep 2
			fi			
		fi
	else
		echo "unknow processType."
	fi

}

#显示菜单(单选)
display_menu(){
local soft=$1
local prompt="which ${soft} you'd select: "
eval local arr=(\${${soft}_arr[@]})
while true
do
	echo -e "#################### ${soft} setting ####################\n\n"
	for ((i=1;i<=${#arr[@]};i++ )); do echo -e "$i) ${arr[$i-1]}"; done
	echo
	read -p "${prompt}" $soft
	eval local select=\$$soft
	if [ "$select" == "" ] || [ "${arr[$soft-1]}" == ""  ];then
		prompt="input errors,please input a number: "
	else
		eval $soft=${arr[$soft-1]}
		eval echo "your selection: \$$soft"             
		break
	fi
done
}

#显示菜单(多选)
display_menu_multi(){
local soft=$1
local prompt="please input numbers(ie. 1 2 3): "
eval local arr=(\${${soft}_arr[@]})
local arr_len=${#arr[@]}

echo  "#################### $soft install ####################"
echo
for ((i=1;i<=$arr_len;i++ )); do echo -e "$i) ${arr[$i-1]}"; done
echo
while true
do
	read -p "${prompt}" select
	local select=($select)
	eval unset ${soft}_install
	unset wrong
	for j in ${select[@]}
	do
		if (! echo $j | grep -q -E "^[0-9]+$") || [[ $j -le 0 ]] || [[ $j -gt $arr_len ]];then
			prompt="input errors,please input numbers(ie. 1 2 3): ";
			wrong=1
			break
		elif [ "${arr[$j-1]}" == "do_not_install" ];then
			eval unset ${soft}_install
			eval ${soft}_install="do_not_install"
			break 2
		else
			eval ${soft}_install="\"\$${soft}_install ${arr[$j-1]}\""
			wrong=0
		fi
	done
	[ "$wrong" == 0 ] && break
done
eval echo -e "your selection \$${soft}_install"
}


#监控编译安装中是否有错误，有错误就停止安装,并把错误写入到文件/tmp/EattingWind_fwq.log
error_detect(){
local command=$1
local cur_soft=`pwd | awk -F'/' '{print $NF}'`
${command}
if [ $? != 0 ];then
	distro=`cat /etc/issue`
	version=`cat /proc/version`
	architecture=`uname -m`
	mem=`free -m`
	cat >>/tmp/EattingWind_fwq.log<<EOF
	EattingWind_fwq errors:
	distributions:$distro
	architecture:$architecture
	version:$version
	memery:
	${mem}
	Nginx: ${nginx}
	Nginx compile parameter:${nginx_configure_args}
	Apache compile parameter:${apache_configure_args}
	MySQL Server: $mysql
	MySQL compile parameter: ${mysql_configure_args}
	PHP Version: $php
	php compile parameter: ${php_configure_args}
	Other Software: ${other_soft_install[@]}
	issue:failed to install $cur_soft
EOF
	echo "#########################################################"
	echo "failed to install $cur_soft."    
	echo "执行安装错误！请将错误信息文件：/tmp/EattingWind_fwq.log发送给本作者949477774@qq.com"
	echo "email:949477774@qq.com"
	echo "#########################################################"
	exit 1
fi
}

#保证是在根用户下运行
need_root_priv(){
# Make sure only root can run our script
if [[ $EUID -ne 0 ]]; then
	echo "This script must be run as root" 1>&2
	exit 1
fi
}

#禁止selinux，因为在selinux下会出现很多意想不到的问题
disable_selinux(){
if [ -s /etc/selinux/config ] && grep 'SELINUX=enforcing' /etc/selinux/config; then
	sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/selinux/config
	setenforce 0
fi
}

#开机启动
boot_start(){
if check_sys packageManager apt;then
	update-rc.d -f $1 defaults
elif check_sys packageManager yum;then
	chkconfig --add $1
	chkconfig $1 on
fi
}

#关闭开机启动
boot_stop(){
if check_sys packageManager apt;then
	update-rc.d -f $1 remove
elif check_sys packageManager yum;then
	chkconfig $1 off
fi
}

#判断路径输入是否合法
filter_location(){
local location=$1
if ! echo $location | grep -q "^/";then
	while true
	do
		read -p "input error,please input location again." location
		echo $location | grep -q "^/" && echo $location && break
	done
else
	echo $location
fi
}

#下载软件
download_file(){
local url1=$1
local url2=$2
local filename=$3
if [ -s "${cur_dir}/soft/${filename}" ];then
	echo "${filename} is existed.check the file integrity."

	if check_integrity "${filename}";then
		echo "the file $filename is complete."
	else
		echo "the file $filename is incomplete.redownload now..."
		rm -f ${cur_dir}/soft/${filename}
		download_file "$url1" "$url2" "$filename"		
	fi

else
	[ ! -d "${cur_dir}/soft" ] && mkdir -p ${cur_dir}/soft
	cd ${cur_dir}/soft
	choose_url_download "$url1" "$url2" "$filename"
fi
}




#验证端口合法性
verify_port(){
	local port=$1
	if echo $port | grep -q -E "^[0-9]+$";then
		if [[ "$port" -lt 0 ]] || [[ "$port" -gt 65535 ]];then
			return 1
		else
			return 0
		fi	
	else
		return 1
	fi		
}


#判断命令是否存在
check_command_exist(){
local command=$1
if ! which $command > /dev/null;then
	echo "$command not found,please install it."
	exit 1
fi
}

#大写转换成小写
upcase_to_lowcase(){
words=$1
echo $words | tr '[A-Z]' '[a-z]'
}

#yes or no询问
yes_or_no(){
local prompt=$1
local yaction=$2
local naction=$3
while true; do
	read -p "${prompt}" yn
	yn=`upcase_to_lowcase $yn`
	case $yn in
		y ) eval "$yaction";break;;
		n ) eval "$naction";break;;
		* ) echo "input error,please only input y or n."
	esac
done
}

#安装编译工具
install_tool(){ 
	if check_sys packageManager apt;then
		apt-get -y update
		apt-get -y install gcc g++ make wget perl curl bzip2
	elif check_sys packageManager yum; then
		yum -y install gcc gcc-c++ make wget perl  curl bzip2 which
	fi

check_command_exist "gcc"
check_command_exist "g++"
check_command_exist "make"
check_command_exist "wget"
check_command_exist "perl"
}

#判断系统版本
check_sys(){
	local checkType=$1
	local value=$2

	local release=''
	local systemPackage=''
	local packageSupport=''

	if [[ -f /etc/redhat-release ]];then
		release="centos"
		systemPackage="yum"
		packageSupport=true

	elif cat /etc/issue | grep -q -E -i "debian";then
		release="debian"
		systemPackage="apt"
		packageSupport=true

	elif cat /etc/issue | grep -q -E -i "ubuntu";then
		release="ubuntu"
		systemPackage="apt"
		packageSupport=true

	elif cat /etc/issue | grep -q -E -i "centos|red hat|redhat";then
		release="centos"
		systemPackage="yum"
		packageSupport=true

	elif cat /proc/version | grep -q -E -i "debian";then
		release="debian"
		systemPackage="apt"
		packageSupport=true

	elif cat /proc/version | grep -q -E -i "ubuntu";then
		release="ubuntu"
		systemPackage="apt"
		packageSupport=true

	elif cat /proc/version | grep -q -E -i "centos|red hat|redhat";then
		release="centos"
		systemPackage="yum"
		packageSupport=true

	else
		release="unknow"
		systemPackage="unknow"
		packageSupport=false
	fi

	if [[ $checkType == "sysRelease" ]]; then
		if [ "$value" == "$release" ];then
			return 0
		else
			return 1
		fi

	elif [[ $checkType == "packageManager" ]]; then
		if [ "$value" == "$systemPackage" ];then
			return 0
		else
			return 1
		fi

	elif [[ $checkType == "packageSupport" ]]; then
		if $packageSupport;then
			return 0
		else
			return 1
		fi
	fi
}



#检测是否安装，存在就不安装了
check_installed(){
local command=$1
local location=$2
if [ -d "$location" ];then
	echo "$location found,skip the installation."
	add_to_env "$location"
else
	${command}
fi
}

#检测是否安装,带确认对话
check_installed_ask(){
local command=$1
local location=$2
if [ -d "$location" ];then
	#发现路径存在，是否删除安装
	yes_or_no "directory $location found,may be the software had installed,remove it and reinstall it [N/y]: " "rm -rf $location && ${command}" "echo 'do not reinstall this software.' "
else
	${command}
fi
}





#设置php参数
set_php_variable(){
	local key=$1
	local value=$2
	if grep -q -E "^$key\s*=" $php_location/etc/php.ini;then
		sed -i -r "s#^$key\s*=.*#$key=$value#" $php_location/etc/php.ini
	else
		sed -i -r "s#;\s*$key\s*=.*#$key=$value#" $php_location/etc/php.ini
	fi

	if ! grep -q -E "^$key\s*=" $php_location/etc/php.ini;then
		echo "$key=$value" >> $php_location/etc/php.ini
	fi
}

#不同系统环境 添加组 
add_group(){
        local addgroup=$1
        if check_sys packageManager apt;then
                adduser --group $addgroup
        elif check_sys packageManager yum; then
                groupadd $addgroup
        fi
}

Get_Dist_Name(){
    if grep -Eqi "CentOS" /etc/issue || grep -Eq "CentOS" /etc/*-release; then
        DISTRO='CentOS'
        PM='yum'
    elif grep -Eqi "Red Hat Enterprise Linux Server" /etc/issue || grep -Eq "Red Hat Enterprise Linux Server" /etc/*-release; then
        DISTRO='RHEL'
        PM='yum'
    elif grep -Eqi "Aliyun" /etc/issue || grep -Eq "Aliyun" /etc/*-release; then
        DISTRO='Aliyun'
        PM='yum'
    elif grep -Eqi "Fedora" /etc/issue || grep -Eq "Fedora" /etc/*-release; then
        DISTRO='Fedora'
        PM='yum'
    elif grep -Eqi "Amazon Linux" /etc/issue || grep -Eq "Amazon Linux" /etc/*-release; then
        DISTRO='Amazon'
        PM='yum'
    elif grep -Eqi "Debian" /etc/issue || grep -Eq "Debian" /etc/*-release; then
        DISTRO='Debian'
        PM='apt'
    elif grep -Eqi "Ubuntu" /etc/issue || grep -Eq "Ubuntu" /etc/*-release; then
        DISTRO='Ubuntu'
        PM='apt'
    elif grep -Eqi "Raspbian" /etc/issue || grep -Eq "Raspbian" /etc/*-release; then
        DISTRO='Raspbian'
        PM='apt'
    elif grep -Eqi "Deepin" /etc/issue || grep -Eq "Deepin" /etc/*-release; then
        DISTRO='Deepin'
        PM='apt'
    elif grep -Eqi "Mint" /etc/issue || grep -Eq "Mint" /etc/*-release; then
        DISTRO='Mint'
        PM='apt'
    elif grep -Eqi "Kali" /etc/issue || grep -Eq "Kali" /etc/*-release; then
        DISTRO='Kali'
        PM='apt'
    else
        DISTRO='unknow'
    fi
    Get_OS_Bit
}
Get_OS_Bit()
{
    if [[ `getconf WORD_BIT` = '32' && `getconf LONG_BIT` = '64' ]] ; then
        Is_64bit='y'
    else
        Is_64bit='n'
    fi
}
Install_LSB()
{
    echo "[+] Installing lsb..."
    if [ "$PM" = "yum" ]; then
        yum -y install redhat-lsb
    elif [ "$PM" = "apt" ]; then
        apt-get update
        apt-get --no-install-recommends install -y lsb-release
    fi
}
Get_Dist_Version()
{
    if [ -s /usr/bin/python3 ]; then
        eval ${DISTRO}_Version=`/usr/bin/python3 -c 'import platform; print(platform.linux_distribution()[1])'`
    elif [ -s /usr/bin/python2 ]; then
        eval ${DISTRO}_Version=`/usr/bin/python2 -c 'import platform; print platform.linux_distribution()[1]'`
    fi
    if [ $? -ne 0 ]; then
        Install_LSB
        eval ${DISTRO}_Version=`lsb_release -rs`
    fi
}
