#!/bin/zsh

set -e

# Script directory
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PKUVPN_SCRIPT="$SCRIPT_DIR/pkuvpn"

# Ensure the script is executable
chmod +x "$PKUVPN_SCRIPT"

# Create symlink in user's local bin directory
LOCAL_BIN="$HOME/.local/bin"
mkdir -p "$LOCAL_BIN"

SYMLINK_PATH="$LOCAL_BIN/pkuvpn"

# Remove old symlink if it exists
if [[ -L "$SYMLINK_PATH" ]]; then
	rm "$SYMLINK_PATH"
fi

# Create new symlink
ln -s "$PKUVPN_SCRIPT" "$SYMLINK_PATH"

echo "✓ pkuvpn 命令已安装到 $SYMLINK_PATH"
echo ""
echo "请确保 ~/.local/bin 在你的 PATH 中。"
echo "如果之前没有添加，请在 ~/.zshrc 中添加以下内容："
echo ""
echo "  export PATH=\"\$HOME/.local/bin:\$PATH\""
echo ""
echo "然后执行: source ~/.zshrc"
echo ""
echo "之后就可以直接使用命令："
echo "  pkuvpn setup                  # 设置 IAAA 凭据"
echo "  pkuvpn set-sudo-nopasswd     # 配置 sudo 免密"
echo "  pkuvpn start                 # 启动 VPN"
echo "  pkuvpn stop                  # 停止 VPN"