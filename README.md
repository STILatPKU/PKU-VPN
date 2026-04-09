# pkuvpn

使用open connect连接北大VPN，实现VPN和clashX代理同时启动。灵感来自于[这里](https://github.com/zhuozhiyongde/PKU-VPN)和[这里](https://github.com/PKUfudawei/pkuvpn/)。

在使用前，请确保你已经**细心且完全**地阅读了此文档，**包括 Q&A 部分**。

## 安装和配置

1. clone 本项目到本地

2. 在项目目录执行安装脚本：

   ```shell
   ./install.sh
   ```

   这会在 `~/.local/bin` 中创建 `pkuvpn` 命令的符号链接。

3. 检查 `~/.local/bin` 是否在 PATH 中。如果不在，在 `~/.zshrc` 中添加：

   ```zsh
   export PATH="$HOME/.local/bin:$PATH"
   ```

   然后执行：

   ```shell
   source ~/.zshrc
   ```

4. 现在你就可以在任何地方使用 `pkuvpn` 命令了！接下来执行设置命令，把 IAAA 账号密码安全保存到 macOS 钥匙串：

   ```shell
   pkuvpn setup
   ```

5. 在终端输入 `brew install openconnect` 下载 openconnect 库。

6. 如果你希望后续 `pkuvpn start` 连管理员密码也不再输入，可执行（一次性配置 sudo 白名单）：

   ```shell
   pkuvpn set-sudo-nopasswd
   ```

## 使用方式

* 连接 VPN：在终端输入 `pkuvpn start`。IAAA 账号密码从 macOS 钥匙串读取，不再每次输入。若已执行 `pkuvpn set-sudo-nopasswd`，管理员密码也无需每次输入。连接过程中需要保持窗口开启。
* 如果提示要求输入Token Code，输入手机号的第4至7位。
* 断开 VPN：使用 `ctrl+C` 终止 VPN 链接进程。你也可以在另一个终端窗口中使用`pkuvpn stop`命令。

## 卸载方式

如果你想完全卸载 pkuvpn 并清理所有相关的修改和记录，执行卸载脚本：

```shell
./uninstall.sh
```

此脚本会清理以下内容：

* 符号链接：`~/.local/bin/pkuvpn`
* macOS 钥匙串中保存的 IAAA 用户名和密码
* sudo 免密配置：`/etc/sudoers.d/pkuvpn`
* VPN 日志文件：`~/.pkuvpn.log`
* 运行中的 VPN 进程

卸载后你的计算机将还原到使用 pkuvpn 前的状态。

## Q&A

### 我输入了`pkuvpn start`，命令行有我看不懂的报错，现在输入什么都没反应？

open connect可能会报不影响使用的错。不用关闭终端窗口，检查是否已经连接成功。可以连接就暂时不用处理。

### 一段时间之后，VPN隧道断裂?

这是一个已知错误，VPN似乎会在大约十几二十分钟之后自动断开。我暂时也没有办法，请重新连接。
