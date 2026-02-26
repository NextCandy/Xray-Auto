### 示例仅供参考，安装程序并未配置如下调优。请根据你的服务器进行更改调整，切勿盲目追求单线程极限调整，后果自负。
### 使用方法：直接选择任意一段复制后在服务器运行即可。

### eg1: 单用户
```bash
cat > /etc/sysctl.d/99-custom-network.conf <<EOF
# 启用 BBR 拥塞控制算法
net.core.default_qdisc = fq
net.ipv4.tcp_congestion_control = bbr

# 优化内存限制：追求单线程极限速度 (约 25MB 缓冲区)
net.core.rmem_max = 25000000
net.core.wmem_max = 25000000
net.ipv4.tcp_rmem = 4096 131072 25000000
net.ipv4.tcp_wmem = 4096 131072 25000000

# 全局 TCP 内存限制 (针对 1GB 内存系统安全线) (最高约 256MB)
net.ipv4.tcp_mem = 32768 49152 65536

# 保持中等规模队列，适合单用户环境
net.core.somaxconn = 1024
net.ipv4.tcp_max_syn_backlog = 1024
net.core.netdev_max_backlog = 1024
EOF

# 立即应用配置
sysctl -p /etc/sysctl.d/99-performance.conf

```

### eg2: 多用户
```bash
cat > /etc/sysctl.d/99-custom-network.conf <<EOF
net.core.default_qdisc = fq
net.ipv4.tcp_congestion_control = bbr

# 严格限制单连接最大使用约 4MB (4194304 bytes) 内存，防止个别连接榨干系统
net.core.rmem_max = 4194304
net.core.wmem_max = 4194304
net.ipv4.tcp_rmem = 4096 87380 4194304
net.ipv4.tcp_wmem = 4096 16384 4194304

# 全局 TCP 内存保持在 1GB 系统的安全线 (最高约 256MB)
net.ipv4.tcp_mem = 32768 49152 65536

# 适度增加队列以应对多用户的突发连接请求
net.core.somaxconn = 2048
net.ipv4.tcp_max_syn_backlog = 2048
net.core.netdev_max_backlog = 2048
EOF

# 立即应用配置
sysctl -p /etc/sysctl.d/99-performance.conf

```
