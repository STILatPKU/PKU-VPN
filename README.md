# 前言

受够了 Pulse Secure 的丑陋界面、不兼容 ClashX、老是开机重启然后以其巨丑的图标大大咧咧占据我的菜单栏的各种问题，但因为自己技术过菜，也不知道怎么绕过这个程序启动北大 VPN，前段时间在 Github 上看见了 [这个项目](https://github.com/PKUfudawei/pkuvpn/)，下载试了试发现真的可以用，并且完全可以做到和 ClashX 同时开启（同时挂梯子+学校 VPN），于是在此记录一下。

在使用前，请确保你已经**细心且完全**地阅读了此文档，**包括 Q&A 部分**。

# 配置方式

1. clone 本项目到本地，无需在脚本中写入任何密码。

2. 将整个文件夹（保证文件夹命名为 PKU-VPN）复制到你的`~/`目录下

3. 在项目目录执行初始化脚本：

   ```shell
   bash ~/PKU-VPN/init.sh
   ```

   这会在 `~/.local/bin` 中创建 `pkuvpn` 命令的符号链接。

4. 检查 `~/.local/bin` 是否在 PATH 中。如果不在，在 `~/.zshrc` 中添加：

   ```zsh
   export PATH="$HOME/.local/bin:$PATH"
   ```

   然后执行：

   ```shell
   source ~/.zshrc
   ```

5. 现在你就可以在任何地方使用 `pkuvpn` 命令了！首次执行初始化，把 IAAA 账号密码安全保存到 macOS 钥匙串：

   ```shell
   pkuvpn setup
   ```

6. 在终端输入 `brew install openconnect` 下载 openconnect 库。

7. 如果你希望后续 `pkuvpn start` 连管理员密码也不再输入，可执行（一次性配置 sudo 白名单）：

   ```shell
   pkuvpn set-sudo-nopasswd
   ```

# 使用方式

* 连接 VPN：在终端输入 `pkuvpn start`。IAAA 账号密码从 macOS 钥匙串读取，不再每次输入。若已执行 `pkuvpn set-sudo-nopasswd`，管理员密码也无需每次输入。连接过程中需要保持窗口开启。
* 断开 VPN：首先，使用 `ctrl+C` 终止 VPN 链接进程。然后重新打开一个终端窗口，输入 `pkuvpn stop` 即可。

# Q&A

## 一段时间之后，VPN隧道断裂?

这是一个已知错误，VPN似乎会在大约十几二十分钟之后自动断开。我暂时也没有办法，请重新连接。
