#!/bin/bash
declare -A map
#配置docker容器的名字
docker_name="web_php54apache24_1"
#配置要映射的容器命令:
map["php"]="/usr/local/php/bin/php"
map["bash"]="/bin/bash"

pwd=`pwd`
array_name=()
if [ "$#" != "0" ];then
    j=0
	for i in "$@";do
		tmp=$(echo "$i"|sed s/\"/\\\\\"/g)
		array_name[$j]=$tmp
		#params=$params" \"$tmp\""
		j=$((${j} + 1))
	done
fi
docker_exec=""

if [ "${map[${array_name[0]}]}" != ""  ];then
    docker_exec="sudo docker exec $docker_name ${map[${array_name[0]}]}"
else
    docker_exec="sudo docker exec $docker_name ${array_name[0]}"
fi

execline=""
if [ "${array_name[${j}-1]}" == "." ];then
    for ((i=0;i<${#array_name[@]};i++))
    do
        if [ "$i" == "0" ] || [ "${array_name[$i]}" == "." ] ;then
            continue
        fi
        execline=$execline" $pwd/${array_name[$i]} "
    done
else
      for ((i=0;i<${#array_name[@]};i++))
        do
              if [ "$i" == "0" ] || [ "${array_name[$i]}" == "." ] ;then
                       continue
                   fi
            execline=$execline" ${array_name[$i]} "
        done
fi
docker_exec=$docker_exec" $execline"

echo $docker_exec
eval $docker_exec

