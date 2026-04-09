#!/bin/zsh

# PKU-VPN Uninstall Script
# This script removes all modifications and records made by the pkuvpn installation

set -e

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo "${YELLOW}PKU-VPN 卸载脚本${NC}"
echo "========================================"
echo ""
echo "此脚本将清理以下内容："
echo "  1. 符号链接: ~/.local/bin/pkuvpn"
echo "  2. macOS 钥匙串中的 IAAA 凭据"
echo "  3. sudo 免密配置: /etc/sudoers.d/pkuvpn"
echo "  4. VPN 日志文件: ~/.pkuvpn.log"
echo "  5. 运行中的 VPN 进程"
echo ""
read "confirm?确认卸载？[y/N] "

if [[ "$confirm" != "y" && "$confirm" != "Y" ]]; then
    echo "卸载已取消"
    exit 0
fi

echo ""
echo "开始卸载..."
echo ""

# 1. Stop any running VPN connections
echo -n "1. 停止运行中的 VPN 进程..."
if pgrep -f "openconnect.*vpn.pku.edu.cn" >/dev/null 2>&1; then
    pids=$(pgrep -f "openconnect.*vpn.pku.edu.cn")
    for pid in $pids; do
        if sudo -n true >/dev/null 2>&1; then
            sudo -n kill -TERM "$pid" 2>/dev/null || true
        else
            sudo kill -TERM "$pid" 2>/dev/null || true
        fi
    done
    sleep 1
    # Force kill if still running
    for pid in $pids; do
        if ps -p "$pid" >/dev/null 2>&1; then
            if sudo -n true >/dev/null 2>&1; then
                sudo -n kill -9 "$pid" 2>/dev/null || true
            else
                sudo kill -9 "$pid" 2>/dev/null || true
            fi
        fi
    done
    echo " ${GREEN}✓${NC}"
else
    echo " ${GREEN}✓${NC} (无运行的进程)"
fi

# 2. Remove symlink
echo -n "2. 移除符号链接 ~/.local/bin/pkuvpn..."
SYMLINK_PATH="$HOME/.local/bin/pkuvpn"
if [[ -L "$SYMLINK_PATH" ]]; then
    rm "$SYMLINK_PATH"
    echo " ${GREEN}✓${NC}"
else
    echo " ${GREEN}✓${NC} (不存在)"
fi

# 3. Remove keychain entries
echo -n "3. 清理 macOS 钥匙串中的 IAAA 凭据..."
PKUVPN_KEYCHAIN_USER_SERVICE="PKU-VPN-IAAA-USER"
PKUVPN_KEYCHAIN_PASS_SERVICE="PKU-VPN-IAAA-PASS"

# Remove username entry
if security find-generic-password -a "$USER" -s "$PKUVPN_KEYCHAIN_USER_SERVICE" >/dev/null 2>&1; then
    security delete-generic-password -a "$USER" -s "$PKUVPN_KEYCHAIN_USER_SERVICE" >/dev/null 2>&1 || true
fi

# Remove password entry
if security find-generic-password -a "$USER" -s "$PKUVPN_KEYCHAIN_PASS_SERVICE" >/dev/null 2>&1; then
    security delete-generic-password -a "$USER" -s "$PKUVPN_KEYCHAIN_PASS_SERVICE" >/dev/null 2>&1 || true
fi
echo " ${GREEN}✓${NC}"

# 4. Remove sudo configuration
echo -n "4. 移除 sudo 免密配置 /etc/sudoers.d/pkuvpn..."
SUDOERS_FILE="/etc/sudoers.d/pkuvpn"
if [[ -f "$SUDOERS_FILE" ]]; then
    if sudo -n true >/dev/null 2>&1; then
        sudo -n rm "$SUDOERS_FILE"
    else
        sudo rm "$SUDOERS_FILE"
    fi
    echo " ${GREEN}✓${NC}"
else
    echo " ${GREEN}✓${NC} (不存在)"
fi

# 5. Remove log file
echo -n "5. 删除日志文件 ~/.pkuvpn.log..."
LOG_FILE="$HOME/.pkuvpn.log"
if [[ -f "$LOG_FILE" ]]; then
    rm "$LOG_FILE"
    echo " ${GREEN}✓${NC}"
else
    echo " ${GREEN}✓${NC} (不存在)"
fi

echo ""
echo "========================================"
echo "${GREEN}✓ 卸载完成！${NC}"
echo ""
echo "你的计算机已还原到使用 PKU-VPN 之前的状态。"
echo ""
