#!/bin/bash
set -e

echo "===== CT8 稳定版 sing-box 安装脚本 ====="

# 自动生成 UUID
UUID=$(cat /proc/sys/kernel/random/uuid)
echo "自动生成 UUID: $UUID"

# 创建并进入工作目录
BASE=~/ct8-sing-box
mkdir -p "$BASE"
cd "$BASE"

# 下载 sing-box（仅下载一次）
if [ ! -f sing-box ]; then
  echo "[*] 正在下载 sing‑box 最新 Linux AMD64 可执行文件..."
  curl -L -o singbox.tar.gz \
    https://github.com/SagerNet/sing-box/releases/download/v1.8.0/sing-box-1.8.0-linux-amd64.tar.gz
  tar -xzf singbox.tar.gz
  mv sing-box-*/sing-box ./
  chmod +x sing-box
  rm -rf singbox.tar.gz sing-box-*/
fi

# 写入基础配置（WebSocket + VMess）
cat > config.json <<EOF
{
  "log": { "level": "info" },
  "inbounds": [
    {
      "type": "vmess",
      "listen": "0.0.0.0",
      "listen_port": 2080,
      "users": [
        { "uuid": "$UUID" }
      ]
    }
  ],
  "outbounds": [
    { "type": "direct" }
  ]
}
EOF

echo "===== 安装完成！以下是运行方式 ====="
echo "cd $BASE && ./sing-box run -c config.json"
echo
echo "📌 注意："
echo "- 脚本默认前台运行，按 Ctrl+C 可退出。"
echo "- CT8 容易杀掉后台进程，不建议后台 daemon 模式。"
echo "- 如果需要后台运行，可用： nohup ./sing-box run -c config.json > sing-box.log 2>&1 &"

echo
echo "✅ 推荐步骤："
echo "  1. 执行：bash <(curl -Ls https://raw.githubusercontent.com/lisiyong0707/ibmfree-linux-jeoyblog-/main/ct8-lite.sh)"
echo "  2. 按提示进入工作目录，直接运行 sing-box"
echo "  3. 若提前退出脚本，可手动用 nohup 重启"

