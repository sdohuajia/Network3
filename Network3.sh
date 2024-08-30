#!/bin/bash

# 确保脚本在出现错误时会立即退出
set -e

# 检查是否以root用户运行脚本
if [ "$(id -u)" != "0" ]; then
    echo "此脚本需要以root用户权限运行。"
    echo "请尝试使用 'sudo -i' 命令切换到root用户，然后再次运行此脚本。"
    exit 1
fi

# 确保 screen 已安装
if ! command -v screen &> /dev/null; then
    echo "screen 未安装，正在安装..."
    sudo apt-get install -y screen
fi

# 主菜单函数
function main_menu() {
    while true; do
        clear
        echo "脚本由大赌社区哈哈哈哈编写，推特 @ferdie_jhovie，免费开源，请勿相信收费"
        echo "================================================================"
        echo "节点社区 Telegram 群组: https://t.me/niuwuriji"
        echo "节点社区 Telegram 频道: https://t.me/niuwuriji"
        echo "节点社区 Discord 社群: https://discord.gg/GbMV5EcNWF"
        echo "退出脚本，请按键盘ctrl c退出即可"
        echo "请选择要执行的操作:"
        echo "1) 安装并启动节点"
        echo "2) 获取私钥"
        echo "3) 退出"
        echo -n "选择一个选项 [1-3]: "
        read OPTION

        case $OPTION in
        1) install_and_start_node ;;
        2) get_private_key ;;
        3) exit 0 ;;
        *) echo "无效选项，请重新输入。" ;;
        esac

        echo "按任意键返回主菜单..."
        read -n 1
    done
}

# 安装并启动节点函数
install_and_start_node() {
    # 更新系统包列表
    sudo apt update

    # 安装所需的软件包
    sudo apt install -y wget curl make clang pkg-config libssl-dev build-essential jq lz4 gcc unzip snapd
    sudo apt-get install -y net-tools

    # 下载、解压并清理文件
    echo "下载并解压节点软件包..."
    wget https://network3.io/ubuntu-node-v2.1.0.tar
    tar -xf ubuntu-node-v2.1.0.tar
    rm -rf ubuntu-node-v2.1.0.tar

    # 检查目录是否存在
    if [ ! -d "ubuntu-node" ]; then
        echo "目录 ubuntu-node 不存在，请检查下载和解压是否成功。"
        exit 1
    fi

    # 提示并进入目录
    echo "进入 ubuntu-node 目录..."
    cd ubuntu-node

    # 检查并创建 screen 会话
    if screen -list | grep -q "network3"; then
        echo "检测到已有名为 'network3' 的 screen 会话。"
    else
        echo "创建新的 screen 会话 'network3'..."
        screen -S network3 -dm
    fi

    # 启动节点
    echo "启动节点..."
    screen -S network3 -p 0 -X stuff 'sudo bash manager.sh up\n'

    echo "脚本执行完毕。"
    echo "按任意键返回主菜单..."
    read -n 1
    main_menu
}

# 获取私钥函数
get_private_key() {
    echo "获取私钥..."
    cd ubuntu-node
    sudo bash manager.sh key
    echo "按任意键返回主菜单..."
    read -n 1
    main_menu
}

# 调用主菜单函数，开始执行主菜单逻辑
main_menu
