#!/bin/bash

# 定义帮助文本
help_text="
用法：$0 [选项] [参数]
选项：
  -h, --help          显示此帮助信息
  -a, --allow PORT    允许指定端口
  -c, --close PORT    关闭指定端口
  -l, --list          查看所有开放的端口
  -C, --clear         清空所有开放的端口
  -d, --default       恢复默认策略
  -s, --status        查看防火墙状态
参数：
  PORT                要开放或关闭的端口号
"

# 解析参数
while [[ $# -gt 0 ]]
do
key="$1"

case $key in
    -h|--help)
    echo "$help_text"
    exit
    ;;
    -a|--allow)
    PORT="$2"
    if [[ -z "$PORT" ]]; then
        echo "未指定端口号"
        exit 1
    fi
    # 开放指定端口
    sudo firewall-cmd --zone=public --add-port="$PORT"/tcp --permanent >/dev/null
    sudo firewall-cmd --reload >/dev/null
    echo "已开放端口 $PORT"
    exit
    ;;
    -c|--close)
    PORT="$2"
    if [[ -z "$PORT" ]]; then
        echo "未指定端口号"
        exit 1
    fi
    # 关闭指定端口
    sudo firewall-cmd --zone=public --remove-port="$PORT"/tcp --permanent >/dev/null
    sudo firewall-cmd --reload >/dev/null
    echo "已关闭端口 $PORT"
    exit
    ;;
    -l|--list)
    # 查看所有开放的端口
    sudo firewall-cmd --list-ports
    exit
    ;;
    -C|--clear)
    # 清空所有开放的端口
    sudo firewall-cmd --zone=public --remove-port=all --permanent >/dev/null
    sudo firewall-cmd --reload >/dev/null
    echo "已清空所有开放的端口"
    exit
    ;;
    -d|--default)
    # 恢复默认策略
    sudo firewall-cmd --zone=public --set-default-zone=default >/dev/null
    sudo firewall-cmd --reload >/dev/null
    echo "已恢复默认策略"
    exit
    ;;
    -s|--status)
    # 查看防火墙状态
    sudo systemctl status firewalld
    exit
    ;;
    *)
    echo "未知选项 $key"
    echo "$help_text"
    exit 1
    ;;
esac
done

# 如果没有参数，显示帮助信息
if [[ $# -eq 0 ]]; then
    echo "$help_text"
fi