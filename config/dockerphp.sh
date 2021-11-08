#!/bin/bash
docker_name="web_php54apache24_1"
php_path="/usr/local/php/bin/php"
docker_exec="sudo docker exec $docker_name $php_path"
pwd=`pwd`
array_name=()
if [ "$#" != "0" ];then
    j=0
	for i in "$@";do
		tmp=$(echo "$i"|sed s/\"/\\\\\"/g)
		array_name[$j]=$tmp
		#params=$params" \"$tmp\""
		j=$j+1
	done
fi
if [ "${array_name[1]}" == "." ];then
    docker_exec=$docker_exec" $pwd/${array_name[0]}"
else
    docker_exec=$docker_exec" ${array_name[0]}"
fi
echo $docker_exec
eval $docker_exec
