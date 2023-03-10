#!/bin/bash

# 获取用户输入的端口号
read -p "请输入要杀死服务的端口号：" port

# 查找该端口号对应的进程并杀死它
if [[ $(sudo netstat -tulpn | grep ":$port ") ]]; then
    pid=$(sudo netstat -tulpn | grep ":$port " | awk '{print $7}' | cut -d '/' -f 1)
    sudo kill -9 "$pid"
    echo "端口 $port 对应的服务已被杀死."
else
    echo "端口 $port 没有对应的服务在运行."
fi