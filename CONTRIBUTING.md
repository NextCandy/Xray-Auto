# Contributing to This Project

First off, thank you for considering contributing to this project! It's people like you that make open source great.

## How to Contribute

### Reporting Bugs
If you find a bug, please check the existing GitHub issues to see if it has already been reported. If not, open a new issue and include:
* A clear and descriptive title.
* Detailed steps to reproduce the behavior.
* The expected behavior and what actually happened.
* Relevant environment details (OS, software version, etc.).

### Suggesting Enhancements
If you have an idea to improve the project, please open an issue to discuss it before writing any code. Provide a clear description of the feature and explain why it would be useful for the users.

### Pull Requests
We welcome pull requests! To submit a change, please follow these steps:
1. Fork the repository and create your working branch from the default branch.
2. If you have added code that should be tested, add tests.
3. Make sure your code follows the existing formatting and style of the project.
4. Update relevant documentation (such as `README.md`) if your changes require it.
5. Open a Pull Request with a clear title and a comprehensive description of the changes.

## Code of Conduct
By participating in this project, you agree to maintain a respectful and welcoming environment for everyone. Please be constructive in your communication.


## 🌐 服务器 (VPS) 选购建议

为了获得最佳的科学上网体验，建议您在选购 VPS 时注意以下几点：

* **线路质量 (Routing)**：
  * **电信用户**：优先选择 CN2 GIA 线路。
  * **联通用户**：优先选择 AS9929 或 AS4837 线路。
  * **移动用户**：优先选择 CMIN2 线路。
* **IP 纯净度**：尽量选择原生 IP (Native IP) 或未被滥用的机房。Reality 协议虽然能伪装流量，但如果目标 IP 已经被列入流媒体黑名单，您依然无法解锁 Netflix 或 Disney+。
* **虚拟化架构**：强烈建议选择 **KVM** 架构的服务器。OpenVZ (OVZ) 架构无法直接开启 BBR 加速，会严重影响晚高峰的吞吐速度。

### 📝 DMIT 介绍

DMIT 成立于 2017 年，总部位于美国纽约，但在香港和日本等地也设有分支或紧密的业务合作点。

• 成立初衷： 早期由一群对网络连接质量有极高要求的技术爱好者（主要为华人背景）创立。他们发现市面上缺乏能提供高稳定、高带宽、且针对亚洲方向深度优化的廉价 VPS，因此决定自行采购硬件并租用顶级数据中心。

• 成长历程： 真正让 DMIT 在圈内名声大噪的是它在 2018 年前后 推出的香港 CN2 GIA 服务。当时香港的 GIA 线路极其稀缺且价格昂贵，DMIT 以相对亲民的价格和极高的带宽冗余迅速占领了高端用户市场。

DMIT分为三个网络类型，Premium (Pro)、Eyeball (Eb)、Tier1 (T1)，现在还提供免费更换IP的服务，服务详情查看 [TOS](https://www.dmit.io/pages/tos)【IP Replacement Policy】。
| 网络类型 | 线路 | 适用场景 |
| :--- | :--- | :--- |
| Premium (Pro) | IPv4:三网CN2 GIA / IPv6:电联9929+移动CMIN2 | 全场景（适合代理网络）【推荐】 |
| Eyeball (Eb) | 电联9929+移动CMIN2 | 全场景（适合代理网络）【推荐】 |
| Tier1 (T1) | 国际优化，无中国优化 | 国际访问（便宜，适合建站）|

#### I. DMIT EyeBall (Eb) 套餐

| 套餐名称 | CPU | 内存 | 硬盘 | 流量 | 网速 | 价格 | 购买链接(含aff) | 备注 |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| LAX.AN4.EB.Intro | 1vCPU | 1GB | 10GB SSD | 500GB/月 | 1Gbps | 29.9$/年 | [限时购买](https://www.dmit.io/aff.php?aff=13908&pid=231) | 美西 **【推荐】** |
| LAX.AN4.EB.WEE | 1vCPU | 1GB | 20GB SSD | 1000GB/月 | 1Gbps | 39.9$/年 | [限时购买](https://www.dmit.io/aff.php?aff=13908&pid=188) | 美西 **【推荐】** |
| LAX.AN4.EB.CORONA | 1vCPU | 1GB | 20GB SSD | 2000GB/月 | 2Gbps | 49.9$/年 | [限时购买](https://www.dmit.io/aff.php?aff=13908&pid=218) | 美西 **【推荐】** |
| LAX.AN4.EB.FONTANA | 2vCPU | 2GB | 40GB SSD | 4000GB/月 | 4Gbps | 100$/年 | [限时购买](https://www.dmit.io/aff.php?aff=13908&pid=219) | 美西 **【推荐】** |
| HKG.AN4.EB.WEEv2 | 1vCPU | 1GB | 20GB SSD | 450GB/月 | 500Mbps | 179.9$/年 | [限时购买](https://www.dmit.io/aff.php?aff=13908&pid=209) | 香港 **【推荐】** |
| TYO.AN4.EB.WEE | 1vCPU | 1GB | 20GB SSD | 450GB/月 | 500Mbps | 154.9$/年 | [限时购买](https://www.dmit.io/aff.php?aff=13908&pid=220) | 东京 **【推荐】** |
| LAX.AN5.EB.TINY | 1vCPU | 2GB | 20GB SSD | 1500GB/月 | 2Gbps | 88.88$/年 | [点击购买](https://www.dmit.io/aff.php?aff=13908&pid=189) | 美西 **【推荐】** |


#### II. DMIT Premium (Pro)套餐

| 套餐名称 | CPU | 内存 | 硬盘 | 流量 | 带宽 | 价格 | 购买链接(含aff) | 备注 |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| LAX.AN4.Pro.Wee | 1vCPU | 1GB | 10GB SSD | 500GB/月 | 500Mbps | 39.9$/年 | [限时购买](https://www.dmit.io/aff.php?aff=13908&pid=183) | 美西 **【推荐】** |
| LAX.AN4.Pro.MALIBU | 1vCPU | 1GB | 20GB SSD | 1000GB/月 | 1Gbps | 49.9$/年 | [限时购买](https://www.dmit.io/aff.php?aff=13908&pid=186) | 美西 **【推荐】** |
| LAX.AN4.PRO.PalmSpring  | 2vCPU | 2GB | 40GB SSD | 2000GB/月 | 2Gbps | 100$/年 | [限时购买](https://www.dmit.io/aff.php?aff=13908&pid=182) | 美西 **【推荐】** |
| HKG.AN4.PRO.Victoria | 1vCPU | 2GB | 60GB SSD | 500GB/月 | 500Mbps | 298.88$/年 | [限时购买](https://www.dmit.io/aff.php?aff=13908&a=add&pid=178) | 香港 **【推荐】**  |
| TYO.AN4.PRO.Shinagawa | 1vCPU | 2GB | 60GB SSD | 500GB/月 | 500Mbps | 199$/年 | [限时购买](https://www.dmit.io/aff.php?aff=13908&pid=179) | 东京 **【推荐】** |
| LAX.AN5.Pro.TINY | 1vCPU | 2GB | 20GB SSD | 1500GB/月 | 2Gbps | 88.88$/年 | [点击购买](https://www.dmit.io/aff.php?aff=13908&a=add&pid=100) | 美西 **【推荐】** |
| LAX.AN5.Pro.Pocket | 2vCPU | 2GB | 40GB SSD | 1500GB/月 | 4Gbps | 14.90$/月 | [点击购买](https://www.dmit.io/aff.php?aff=13908&a=add&pid=137) | 美西 |
| LAX.AN5.Pro.STARTER | 2vCPU | 2GB | 80GB SSD | 3000GB/月 | 10Gbps | 29.90$/月 | [点击购买](https://www.dmit.io/aff.php?aff=13908&a=add&pid=56) | 美西 |
| LAX.AN5.Pro.MINI | 4vCPU | 4GB | 80GB SSD | 5000GB/月 | 10Gbps | 58.88$/月 | [点击购买](https://www.dmit.io/aff.php?aff=13908&a=add&pid=58) | 美西 |
| HKG.AS3.Pro.TINY | 1vCPU | 1GB | 20GB SSD | 500GB/月 | 1Gbps | 39.90$/月 | [点击购买](https://www.dmit.io/aff.php?aff=13908&a=add&pid=123) | 香港 |
| HKG.AS3.Pro.STARTER | 1vCPU | 2GB | 40GB SSD | 1000GB/月 | 1Gbps | 79.90$/月 | [点击购买](https://www.dmit.io/aff.php?aff=13908&a=add&pid=124) | 香港 |
| HKG.AS3.Pro.MINI | 2vCPU | 2GB | 60GB SSD | 1500GB/月 | 1Gbps | 119.90$/月 | [点击购买](https://www.dmit.io/aff.php?aff=13908&a=add&pid=125) | 香港 |
| HKG.AS3.Pro.MICRO | 4vCPU | 4GB | 80GB SSD | 2000GB/月 | 1Gbps | 159.90$/月 | [点击购买](https://www.dmit.io/aff.php?aff=13908&a=add&pid=126) | 香港 |
| TYO.AS3.Pro.TINY | 1vCPU | 1GB | 20GB SSD | 500GB/月 | 1Gbps | 21.90$/月 | [点击购买](https://www.dmit.io/aff.php?aff=13908&a=add&pid=138) | 东京 |
| TYO.AS3.Pro.STARTER | 1vCPU | 2GB | 40GB SSD | 1000GB/月 | 1Gbps | 39.90$/月 | [点击购买](https://www.dmit.io/aff.php?aff=13908&a=add&pid=139) | 东京 |
| TYO.AS3.Pro.MINI | 2vCPU | 2GB | 60GB SSD | 2000GB/月 | 1Gbps | 79.90$/月 | [点击购买](https://www.dmit.io/aff.php?aff=13908&a=add&pid=140) | 东京 |
| TYO.AS3.Pro.MINI | 4vCPU | 4GB | 80GB SSD | 4000GB/月 | 1Gbps | 159.90$/月 | [点击购买](https://www.dmit.io/aff.php?aff=13908&a=add&pid=141) | 东京 |

*IP被墙，每15天可免费更换一次 IP（Eyeball, Premium系列满足15天即可）。
详情参阅商家tos或手册：https://docs.dmit.io/zh/guide/faq/ip

*退款政策，3天内流量不超过30GB全额退，1个月内剩余价值退（扣除支付网关费用）
详情参阅商家tos或手册：https://docs.dmit.io/zh/guide/faq/refund
