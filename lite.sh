#!/bin/bash

# --- 基础变量与日志文件 ---
LOG_FILE="/tmp/xray_install.log"
> $LOG_FILE

# --- 颜色与提示函数 ---
GREEN="\033[32m"
RED="\033[31m"
YELLOW="\033[33m"
BLUE="\033[36m"
PLAIN="\033[0m"

info()    { echo -e "${BLUE}[ INFO ]${PLAIN} $1"; }
success() { echo -e "${GREEN}[  OK  ]${PLAIN} $1"; }
warn()    { echo -e "${YELLOW}[ WARN ]${PLAIN} $1"; }
error()   { echo -e "${RED}[FAILED]${PLAIN} $1\n${YELLOW}>> 请查看错误日志获取详细信息: cat $LOG_FILE ${PLAIN}"; exit 1; }

# --- 1. 系统环境强制检查 ---
if [ ! -f /etc/debian_version ]; then
    error "本脚本仅支持 Debian 或 Ubuntu 系统！CentOS/RedHat 请勿运行。"
fi

if [[ $EUID -ne 0 ]]; then
    error "This script must be run as root!"
fi

clear
echo ""
info "${YELLOW}      开始部署 Xray-Auto Lite ${PLAIN}"
echo ""

# --- 2. 系统初始化与核心依赖 ---
timedatectl set-ntp true >> $LOG_FILE 2>&1
export DEBIAN_FRONTEND=noninteractive

info "1/7 - 正在更新系统源并静默安装核心依赖 (请稍候 1-3 分钟)..."
apt-get update -qq >> $LOG_FILE 2>&1
apt-get -y -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" upgrade >> $LOG_FILE 2>&1

DEPENDENCIES="curl wget tar unzip fail2ban rsyslog chrony iptables iptables-persistent qrencode"
apt-get install -y $DEPENDENCIES >> $LOG_FILE 2>&1

# --- 时间校准 ---
info "2/7 - 正在校准系统时间..."
systemctl enable chrony >> $LOG_FILE 2>&1
systemctl restart chrony >> $LOG_FILE 2>&1
sleep 2
chronyc makestep >> $LOG_FILE 2>&1

# --- 3. 二次检查与自动修复 ---
info "3/7 - 正在验证底层依赖的完整性..."

CHECK_LIST=(
    "curl:curl"
    "wget:wget"
    "unzip:unzip"
    "fail2ban-client:fail2ban"
    "chronyc:chrony"
    "iptables:iptables"
    "netfilter-persistent:iptables-persistent"
    "qrencode:qrencode"
)

for item in "${CHECK_LIST[@]}"; do
    CMD="${item%%:*}"
    PKG="${item##*:}"
    
    if ! command -v "$CMD" &> /dev/null; then
        SUCCESS_FLAG=0
        for i in {1..3}; do
            warn "检测到组件 [$CMD] 缺失，尝试第 $i 次自动修复包 [$PKG]..."
            apt-get install -y "$PKG" >> $LOG_FILE 2>&1
            
            if command -v "$CMD" &> /dev/null; then
                success "组件 [$CMD] 第 $i 次尝试修复成功！"
                SUCCESS_FLAG=1
                break
            else
                if [ $i -lt 3 ]; then
                    warn "第 $i 次修复失败，等待 2 秒重试..."
                    sleep 2
                fi
            fi
        done
        
        if [ $SUCCESS_FLAG -eq 0 ]; then
            error "连续 3 次自动修复均失败！无法安装必备组件 [$PKG]。"
        fi
    fi
done
success "${GREEN}      核心依赖组均已就绪。${PLAIN}"
echo ""

# --- 4. 基础安全防护 (Fail2ban) ---
info "4/7 - 正在配置 SSH 与系统级安全防护..."
cat > /etc/fail2ban/jail.local << FAIL2BAN_EOF
[DEFAULT]
ignoreip = 127.0.0.1/8 ::1
bantime = 1d
findtime = 1d
maxretry = 3
bantime.increment = true
bantime.factor = 1
bantime.maxtime = 5w
backend = systemd
mode = normal

[sshd]
enabled = true
port = ssh
FAIL2BAN_EOF

systemctl restart rsyslog >> $LOG_FILE 2>&1 || warn "Rsyslog 未能成功重启，已跳过该环节"
systemctl enable fail2ban >> $LOG_FILE 2>&1
systemctl restart fail2ban >> $LOG_FILE 2>&1

# --- 5. 核心底层优化 (IPv4优先 / 内存安全TCP调优) ---
info "5/7 - 正在应用内核网络优化 (适配 1GB 内存防 OOM)..."

sed -i 's/^#precedence ::ffff:0:0\/96  100/precedence ::ffff:0:0\/96  100/' /etc/gai.conf

# 内存安全型网络调优 (适配 1GB 物理内存且无 Swap 的纯净 Docker 环境)
cat << SYSCTL_EOF > /etc/sysctl.d/99-performance.conf
net.core.default_qdisc = fq
net.ipv4.tcp_congestion_control = bbr
net.core.rmem_max = 8388608
net.core.wmem_max = 8388608
net.ipv4.tcp_rmem = 4096 87380 8388608
net.ipv4.tcp_wmem = 4096 16384 8388608
net.ipv4.tcp_mem = 24576 32768 49152
net.core.somaxconn = 1024
net.ipv4.tcp_max_syn_backlog = 1024
net.core.netdev_max_backlog = 1024
SYSCTL_EOF
sysctl -p /etc/sysctl.d/99-performance.conf >> $LOG_FILE 2>&1

# --- 6. 安装 Xray 核心 ---
info "6/7 - 正在安装并配置 Xray 核心服务..."
bash -c "$(curl -sL https://github.com/XTLS/Xray-install/raw/main/install-release.sh)" @ install --without-geodata >> $LOG_FILE 2>&1
mkdir -p /usr/local/share/xray/
wget -q -O /usr/local/share/xray/geoip.dat https://github.com/Loyalsoldier/v2ray-rules-dat/releases/latest/download/geoip.dat >> $LOG_FILE 2>&1
wget -q -O /usr/local/share/xray/geosite.dat https://github.com/Loyalsoldier/v2ray-rules-dat/releases/latest/download/geosite.dat >> $LOG_FILE 2>&1

# --- 7. 生成 Xray 配置 ---
XRAY_BIN="/usr/local/bin/xray"
SNI_HOST="www.icloud.com"

UUID=$($XRAY_BIN uuid)
KEYS=$($XRAY_BIN x25519)
PRIVATE_KEY=$(echo "$KEYS" | grep "Private" | awk '{print $2}')
PUBLIC_KEY=$(echo "$KEYS" | grep -E "Public|Password" | awk '{print $2}')
SHORT_ID=$(openssl rand -hex 8)

if [[ -z "$UUID" || -z "$PRIVATE_KEY" || -z "$PUBLIC_KEY" ]]; then
    error "核心凭证生成失败，请确认 Xray 已成功安装。"
fi

mkdir -p /usr/local/etc/xray/
cat > /usr/local/etc/xray/config.json <<CONFIG_EOF
{
  "log": { "loglevel": "warning" },
  "dns": { "servers": [ "localhost" ] },
  "inbounds": [
    {
      "port": 443,
      "protocol": "vless",
      "settings": {
        "clients": [ { "id": "${UUID}", "flow": "xtls-rprx-vision" } ],
        "decryption": "none"
      },
      "streamSettings": {
        "network": "tcp",
        "security": "reality",
        "realitySettings": {
          "show": false,
          "dest": "${SNI_HOST}:443",
          "serverNames": [ "${SNI_HOST}", "icloud.com" ],
          "privateKey": "${PRIVATE_KEY}",
          "shortIds": [ "${SHORT_ID}" ],
          "fingerprint": "chrome"
        }
      },
      "sniffing": { "enabled": true, "destOverride": [ "http", "tls", "quic" ], "routeOnly": true }
    }
  ],
  "outbounds": [
    { "protocol": "freedom", "tag": "direct" },
    { "protocol": "blackhole", "tag": "block" }
  ],
  "routing": {
    "domainStrategy": "IPIfNonMatch",
    "rules": [
      { "type": "field", "ip": [ "geoip:private" ], "outboundTag": "block" },
      { "type": "field", "protocol": [ "bittorrent" ], "outboundTag": "block" }
    ]
  }
}
CONFIG_EOF

# --- 8. 部署附加工具与防火墙 ---
info "7/7 - 正在配置系统附加工具与防火墙规则..."
mkdir -p /etc/systemd/system/xray.service.d
echo -e "[Service]\nLimitNOFILE=infinity\nLimitNPROC=infinity\nTasksMax=infinity\nRestart=on-failure\nRestartSec=5" > /etc/systemd/system/xray.service.d/override.conf
systemctl daemon-reload >> $LOG_FILE 2>&1
sed -i 's/^#SystemMaxUse=/SystemMaxUse=200M/g' /etc/systemd/journald.conf
systemctl restart systemd-journald >> $LOG_FILE 2>&1

# 地理规则自动更新定时任务
echo -e "#!/bin/bash\nwget -q -O /usr/local/share/xray/geoip.dat https://github.com/Loyalsoldier/v2ray-rules-dat/releases/latest/download/geoip.dat\nwget -q -O /usr/local/share/xray/geosite.dat https://github.com/Loyalsoldier/v2ray-rules-dat/releases/latest/download/geosite.dat\nsystemctl restart xray" > /usr/local/bin/update_geoip.sh && chmod +x /usr/local/bin/update_geoip.sh
(crontab -l 2>/dev/null; echo "0 4 * * 2 /usr/local/bin/update_geoip.sh >/dev/null 2>&1") | sort -u | crontab -

# 持久化防火墙规则
iptables -I INPUT -p tcp -m multiport --dports 22,80,443,5555,8008,8443 -j ACCEPT >> $LOG_FILE 2>&1
netfilter-persistent save >> $LOG_FILE 2>&1

# --- 9. 启动服务与结果输出 ---
systemctl enable xray >> $LOG_FILE 2>&1
systemctl restart xray >> $LOG_FILE 2>&1

# 分别探测 IPv4 和 IPv6，增加 3 秒超时防止卡死
IPV4=$(curl -s4 --max-time 3 ip.sb)
IPV6=$(curl -s6 --max-time 3 ip.sb)
HOST_TAG=$(hostname | tr ' ' '.')
if [ -z "$HOST_TAG" ]; then HOST_TAG="XrayServer"; fi

success "${GREEN}      部署成功！${PLAIN}"
echo ""
echo "=================================================================="
echo "服务器配置  :"
echo "------------------------------------------------------------------"
if [ -n "$IPV4" ]; then
    echo -e "IPv4        : ${BLUE}${IPV4}${PLAIN}"
fi
if [ -n "$IPV6" ]; then
    echo -e "IPv6        : ${BLUE}${IPV6}${PLAIN}"
fi
echo -e "Port        : ${BLUE}443${PLAIN}"
echo -e "SNI         : ${BLUE}${SNI_HOST}${PLAIN}"
echo -e "ShortId     : ${BLUE}${SHORT_ID}${PLAIN}"
echo -e "UUID        : ${BLUE}${UUID}${PLAIN}"
echo -e "Public Key  : ${BLUE}${PUBLIC_KEY}${PLAIN} (客户端)"
echo -e "Private Key : ${RED}${PRIVATE_KEY}${PLAIN} (服务端)"
echo "------------------------------------------------------------------"
echo ""

# 如果存在 IPv4，则生成 IPv4 的链接和二维码
if [ -n "$IPV4" ]; then
    LINK_V4="vless://${UUID}@${IPV4}:443?security=reality&encryption=none&pbk=${PUBLIC_KEY}&headerType=none&fp=chrome&type=tcp&flow=xtls-rprx-vision&sni=${SNI_HOST}&sid=${SHORT_ID}#${HOST_TAG}-IPv4"
    info "IPv4 链接:"
    echo -e "${GREEN}${LINK_V4}${PLAIN}"
    echo ""
    info "IPv4 QR码:"
    qrencode -t ANSIUTF8 "${LINK_V4}"
    echo ""
fi

# 如果存在 IPv6，则生成 IPv6 的链接和二维码
if [ -n "$IPV6" ]; then
    LINK_V6="vless://${UUID}@[${IPV6}]:443?security=reality&encryption=none&pbk=${PUBLIC_KEY}&headerType=none&fp=chrome&type=tcp&flow=xtls-rprx-vision&sni=${SNI_HOST}&sid=${SHORT_ID}#${HOST_TAG}-IPv6"
    info "IPv6 链接:"
    echo -e "${GREEN}${LINK_V6}${PLAIN}"
    echo ""
    info "IPv6 QR码:"
    qrencode -t ANSIUTF8 "${LINK_V6}"
    echo ""
fi
