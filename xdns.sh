#!/bin/bash

# 检查是否以root身份运行脚本
if [[ $EUID -ne 0 ]]; then
   echo "请以root身份运行此脚本" 
   exit 1
fi

# 显示使用说明
usage() {
    echo "用法: $0 <DNS服务器1> [<DNS服务器2> ...]"
    echo "示例: $0 8.8.8.8 8.8.4.4"
    exit 1
}

# 检查参数数量是否正确
if [ "$#" -lt 1 ]; then
    usage
fi

# 备份当前的resolv.conf
cp /etc/resolv.conf /etc/resolv.conf.bak

# 创建新的resolv.conf
echo "# 由 $0 生成" > /etc/resolv.conf

# 循环处理每个DNS服务器参数，并追加到resolv.conf中
for dns_server in "$@"; do
    echo "nameserver $dns_server" >> /etc/resolv.conf
done

echo "DNS服务器已更新:"
cat /etc/resolv.conf

echo "完成!"
