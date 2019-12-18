# Gerrit 在 Linux 上的快速入门
以下内容说明如何在 Linux 系统上快速安装使用。

**NOTE:**
*本快速入门仅用于演示。此 Gerrit 安装案例不要在生产环境中使用，如需在生产环境中使用，请参考 [安装指导](install.md)*

### 开始之前
必备环境:
* 任意风格的 Linux 的服务器，MacOS，或者 Berkeley Software Distribution (BSD)。
* Java SE Runtime Environment 的版本为 1.8，不兼容 1.9 及后续版本。

### 下载 Gerrit
在要安装 Gerrit 的 Linux 机器上:
* 打开下载页面
* 下载所需要的安装包

如果要查看历史版本安装包，可参考[Gerrit Code Review: Releases](https://gerrit-releases.storage.googleapis.com/index.html)
下面是 Gerrit 3.0.3 安装步骤:

```
wget https://gerrit-releases.storage.googleapis.com/gerrit-3.0.3.war
```

注意：如果要从源码构建安装，请参考 [Gerrit Code Review: 开发者设置](dev-readme.md)

### 安装及初始化 Gerrit

命令如下：

```
export GERRIT_SITE=~/gerrit_testsite
java -jar gerrit*.war init --batch --dev -d $GERRIT_SITE

```

此命令有两个参数：

* `--batch` 为 Gerrit 配置文件设置一些默认参数，如果要了解更多参数，可以参考 [Gerrit 配置](config-gerrit.md).
* `--dev` 设置 Gerrit 服务器的认证方式，`DEVELOPMENT_BECOME_ANY_ACCOUNT`, 此参数可以切换用户用来了解 Gerrit 如何工作，更多设置可以参考 [Gerrit Code Review: Developer Setup](dev-readme.md)

命令执行后，相关信息在终端窗口显示如下：

```
Generating SSH host key ... rsa(simple)... done
Initialized /home/gerrit/gerrit_testsite
Executing /home/gerrit/gerrit_testsite/bin/gerrit.sh start
Starting Gerrit Code Review: OK
```

最后一行信息确认了 Gerrit service 正在运行:

`Starting Gerrit Code Review: OK`.

### 更新设置: listen URL

强烈建议：为了外部链接访问此 Gerrit 应用，可以把 URL 从 `*` 修改为`localhost`，如：

```
git config --file $GERRIT_SITE/etc/gerrit.config httpd.listenUrl 'http://localhost:8080'
```

### 重启 Gerrit service

修改 authentication type 和 listen URL　参数后，重启 Gerrit 服务才会生效：
```
$GERRIT_SITE/bin/gerrit.sh restart
```

### 访问 Gerrit

可通过下面的链接访问安装好的 Gerrit :
```
http://localhost:8080
```

### 下一步

现在 Gerrit 在运行了，可以访问并学习 Gerrit．更多安装信息可以参考:[安装指导](install.md).


