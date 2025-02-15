#!/usr/bin/env bash
#启动docker容器的bash脚本；
MONITOR_HOME_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )/../.." && pwd )"
# BASH_SOURCE[0]是这个脚本文件的地址,private-note/docker/scripts/monitor_docker_run.sh
# dirname BASH_SOURCE[0] 是这个脚本文件所在的目录, private-note/docker/scripts
# cd private-note/docker/scripts/../.. 就是 cd private-note, 
# 然后pwd就是获取private-note的绝对路径.

display=""
if [ -z ${DISPLAY} ];then 
    display=":1"
else
    display="${DISPLAY}"
fi
# -z参数表示检测字符串是否为空, 如果$DISPLAY为空, 那么为true.
# 注意[ -z $DISPLAY ] 中括号两边都要求是空格!!!

local_host="$(hostname)"
user="${USER}"
uid="$(id -u)"
group="$(id -g -n)"
gid="$(id -g)"
# id命令能获得uid(用户ID)/gid(主组id,root默认属于这个组)/以及当前用户所属的组的id(有默认的主组0还有附加组docker组)
# id -u获得用户id(root为0), 
# id -g用户所在组,root在主组, -n表示用名字(root)而不是数字(0)

echo "stop and rm docker" 
docker stop linux_monitor > /dev/null
docker rm -v -f linux_monitor > /dev/null
# -v 表示volumes卷, -f 表示force.

echo "start docker"
docker run -it -d \
--name linux_monitor \
-e DISPLAY=$display \
--privileged=true \
-e DOCKER_USER="${user}" \
-e USER="${user}" \
-e DOCKER_USER_ID="${uid}" \
-e DOCKER_GRP="${group}" \
-e DOCKER_GRP_ID="${gid}" \
-e XDG_RUNTIME_DIR=$XDG_RUNTIME_DIR \
-v ${MONITOR_HOME_DIR}:/work \
-v ${XDG_RUNTIME_DIR}:${XDG_RUNTIME_DIR} \
--net host \
linux:monitor

# XDG_RUNTIME_DIR与display这些与桌面显示有关, 跳过.
# --net host 容器将共享主机的网络堆栈，使用主机的 IP 地址和端口。
