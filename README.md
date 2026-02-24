<div align="center">

[**中文**](README.md) | [**English**](README_EN.md)

</div>

# 🚀 Xray 一键脚本

**全自动、模块化的 Xray 部署脚本**

[![Top Language](https://img.shields.io/github/languages/top/ISFZY/Xray-Auto?style=flat-square&color=5D6D7E)](https://github.com/ISFZY/Xray-Auto/search?l=Shell)
[![Xray Core](https://img.shields.io/badge/Core-Xray-blue?style=flat-square)](https://github.com/XTLS/Xray-core)
[![License](https://img.shields.io/badge/License-MIT-orange?style=flat-square)](LICENSE)
[![GitHub release (latest by date including pre-releases)](https://img.shields.io/github/v/release/ISFZY/Xray-Auto?include_prereleases&style=flat-square&color=blue&refresh=1)](https://github.com/ISFZY/Xray-Auto/releases)

本项目是一个高度模块化的 Shell 脚本，用于在 Linux 服务器上快速部署基于 **Xray** 核心的代理服务。支持最新的 **Vision** 和 **XHTTP** 协议，并集成了由 Reality 驱动的 SNI 伪装技术。

---

## ✨ 功能特性 (Features)

* **📦 模块化设计**: 代码分为 Core、Lib、Tools 三大模块，逻辑清晰。
* **🔒 最新协议**: 支持 Vision 和 XHTTP 协议，集成 Reality 伪装。
* **🛡️ 安全加固**: 自动配置 Fail2ban 和防火墙。
* **🛠️ 丰富工具箱**: 内置 WARP、BBR、端口管理、SNI 优选等工具。


## 📋 环境要求 (Requirements)

* **操作系统**: Debian 10+, Ubuntu 20.04+ (推荐 Debian 11/12)
* **架构**: amd64, arm64
* **权限**: 需要 `root` 权限
* **端口**: 默认使用高位随机端口 (Vision) 和 (XHTTP)
* **客户端**: 请确保你的代理端支持该种协议（如 Shadowrocket, V2rayN...)


## 📥 快速安装 (Quick Start)

### 🚀 推荐：一键安装 (Bootstrap)

使用 `root` 用户运行以下命令即可。引导脚本会自动安装 Git、克隆仓库并启动安装程序。

```bash
bash <(curl -sL https://raw.githubusercontent.com/ISFZY/Xray-Auto/main/bootstrap.sh)

```


### 🛠️ 备用：手动安装 (Manual)

如果你无法连接 GitHub Raw，可以尝试手动克隆：

```bash
# 1. 安装 Git
apt update && apt install -y git

# 2. 克隆仓库
git clone https://github.com/ISFZY/Xray-Auto.git xray-install

# 3. 运行脚本
cd xray-install
chmod +x install.sh
./install.sh

```
**📥 安装 精简版 (lite.sh)**
```bash
bash <(curl -sL https://raw.githubusercontent.com/ISFZY/Xray-Auto/main/lite.sh)

```

## 🗑️ 卸载 (Uninstall)

如果你想彻底移除 Xray 及相关配置，请运行（或服务端输入`remove`）：

```bash
bash <(curl -sL https://raw.githubusercontent.com/ISFZY/Xray-Auto/main/tools/remove.sh)

```


## 🎮 使用指南 (Usage)

安装完成后，脚本会将管理工具注册到系统路径。你可以直接在终端输入以下命令：

| 命令 | 功能 | 说明 |
| :--- | :--- | :--- |
| `info` | **主面板（Admin）** | 查看节点链接、二维码、服务状态及快捷菜单。 |
| `user` | **多用户管理（User）** | 查询、添加，删除用户。 |
| `ports` | **端口管理** | 修改 SSH、Vision、XHTTP 端口并自动放行防火墙。 |
| `net` | **网络策略** | 切换 IPv4/IPv6 优先策略，或强制单栈模式。 |
| `xw` | **WARP 管理** | 安装 Cloudflare WARP 用于 Netflix/ChatGPT 分流。 |
| `bbr` | **内核优化** | 开启/关闭 BBR 加速，调整队列算法 (FQ/FQ_CODEL)。 |
| `sni` | **伪装域管理** | 自动测速优选 SNI 域名，或手动指定。 |
| `bt` | **审计管理** | 一键开启/关闭 BT 下载拦截和私有 IP 拦截。 |
| `swap` | **内存管理** | 添加、删除 Swap 分区，调整 Swappiness 亲和度。 |
| `f2b` | **Fail2ban** | 查看封禁 IP、解封 IP、调整封禁策略。 |
| `backup` | **备份与恢复** | 查询、备份，恢复配置。 |
| `sniff` | **流量嗅探** | 开启/关闭 流量嗅探及其日志。 |
| `zone` | **时区管理** | 时区与时间设置。 |
| `update` | **更新** | 更新 Xray core 和 Geodata 数据库。 |
| `remove` | **一键卸载** | 移除Xray及全部安装。 |


### 📝 客户端配置参考
| 参数 | 值 (示例) | 说明 |
| :--- | :--- | :--- |
| **地址 (Address)** | `1.2.3.4` 或 `[2001::1]` | 服务器 IP |
| **端口 (Port)** | `443` | 安装时设置的端口 |
| **用户 ID (UUID)** | `de305d54-...` | 输入 `info` 获取 |
| **流控 (Flow)** | `xtls-rprx-vision` | **仅 Vision 节点填写** |
| **传输协议 (Network)**| `tcp` 或 `xhttp` | Vision 选 TCP，xhttp 选 xhttp |
| **伪装域名 (SNI)** | `www.microsoft.com` | 输入 `info` 获取 |
| **指纹 (Fingerprint)**| `chrome` | |
| **Public Key** | `B9s...` | 输入 `info` 获取 |
| **ShortId** | `a1b2...` | 输入 `info` 获取 |
| **路径 (Path)** | `/8d39f310` | **仅 xhttp 节点填写** |


## 📂 项目结构 (Structure)

本项目采用模块化架构，目录结构如下：

```text
.
├── bootstrap.sh       # 一键引导脚本 (下载、校验、启动)
├── install.sh         # 主安装入口 (流程编排、锁机制)
├── lib/
│   └── utils.sh       # 公共函数库 (UI、日志、颜色、Task执行器)
├── core/              # 核心安装流程
│   ├── 1_env.sh       # 环境检查与初始化
│   ├── 2_install.sh   # 依赖与 Xray 核心安装
│   ├── 3_system.sh    # 系统配置 (防火墙、内核)
│   └── 4_config.sh    # 生成配置与启动服务
└── tools/             # 独立管理工具 (安装后部署到 /usr/local/bin)
    ├── info.sh
    ├── ports.sh
    ├── net.sh
    ├── ...
```


## ⚠️ 免责声明（Disclaimer）

1.  **仅供科研与学习**: 本项目仅用于**网络技术研究、学习交流及系统测试**。请勿将本脚本用于任何违反国家法律法规的用途。
2.  **法律合规**: 使用本脚本时，请务必遵守您所在国家/地区以及服务器所在地的法律法规。严禁用于涉及政治、宗教、色情、诈骗等非法内容的传播。一切因违规使用产生的法律后果，由使用者自行承担，作者不承担任何连带责任。
3.  **无担保条款**: 本软件按“原样”提供，不提供任何形式的明示或暗示担保。作者不对因使用本脚本而导致的任何直接或间接损失（包括但不限于数据丢失、系统崩溃、IP 被封锁、服务器被服务商暂停等）负责。
4.  **第三方组件**: 本脚本集成了第三方开源程序（如 Xray-core），其版权和责任归原作者所有。本脚本作者不对第三方程序的安全性或稳定性做出保证。
5.  **许可证**: 本项目遵循 **GNU General Public License v3.0** 开源协议，详细条款请参阅仓库内的 `LICENSE` 文件。

**Made with ❤️ by ISFZY**
