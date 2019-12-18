# Gerrit Code Review - Standalone Daemon Installation Guide

## 需要

为了运行 Gerrit 服务, 需要如下：the following requirement must be met on the host:

* JRE, version 1.8 [下载](http://www.oracle.com/technetwork/java/javase/downloads/index.html)

Gerrit 目前不支持 Java 9 及以后版本。

## 配置 Java 的加密方式（可选）

从 Oracle 下载 _Java Cryptography Extension (JCE) Unlimited Strength Jurisdiction Policy Files_ 并安装到 JRE 后，这些加密方式：_AES128CTR_, _AES256CTR_,_ARCFOUR256_, 和  _ARCFOUR128_ 可使用。

```说明：
安装 JCE 扩展是可选的，安装出口限制后可以使用。
```

 * 下载 JCE 文件

    [JDK7 JCE policy files](http://www.oracle.com/technetwork/java/javase/downloads/jce-7-download-432124.html)
    [JDK8 JCE policy files](http://www.oracle.com/technetwork/java/javase/downloads/jce8-download-2133166.html)
 * 解压下载文件

下载的压缩包包括下列文件：

|文件名称 |描述
| :------| :------|
|README.txt |Information about JCE and installation guide
|local_policy.jar |Unlimited strength local policy file
|US_export_policy.jar |Unlimited strength US export policy file

 * 按照 `README.txt` 安装策政策文件。

## 下载 Gerrit

可以从 [Gerrit Releases site](https://gerrit-releases.storage.googleapis.com/index.html) 下载 gerrit 官方提供的二进制包。

下载 `*.war` 文件，然后可以更名为 `gerrit.war`。

如果从源码构建出二进制包，可以参考 [开发者指导](dev-readme.md)。

## 初始化

Gerrit 把一些配置文件，SSH keys，和 git 仓默认存放在 `$site_path` 目录下。

git 仓默认存放在 `$site_path` 目录下，也可以放到其他的路径下。

初始化相关命令如下：

```
  sudo adduser gerrit
  sudo su gerrit

  java -jar gerrit.war init -d /path/to/your/gerrit_application_directory
```

```说明：
初始化的时候，如果新创建的用户没有当前目录的相关权限，可以使用其他用户先创建目录，然后更改目录权限即可。
```

如果使用交互式安装，那么安装过程中会有一些列的配置需要输入。如果使用非交互式安装，配置信息都按默认来设置。初始化过程结束后，可以查看 `$site_path/etc/gerrit.config` 这个配置文件了。

安装过程中会提示下载 JARs 文件，这个下载是可选的，如果下载失败了，可以手动进行下载并放到指定位置。

安装结束后，daemon 会自动在后台运行，并可以通过浏览器进行访问。 

```
  Initialized /home/gerrit/review_site
  Executing /home/gerrit/review_site/bin/gerrit.sh start
  Starting Gerrit Code Review: OK
  Waiting for server to start ... OK
  Opening browser ...
```

浏览器打开链接后，进行登录，第一个登录用户会自动成为管理员。

## 安装完成

现在 Gerrit 已经安装并运行，现在可以对 project 进行相关设置了。

## Project 设置

可以参考 [Project 配置](project-configuration.md)。


## Start/Stop Daemon

gerrit.sh 在初始化后生成，此脚本可以控制 Gerrit-daemon 的在后台运行：

```
  review_site/bin/gerrit.sh start
  review_site/bin/gerrit.sh stop
  review_site/bin/gerrit.sh restart
```

可以配置 daemon 在开机时自动运行。

取消 `$site_path/bin/gerrit.sh` 脚本中的 3 行注释：

```
 chkconfig: 3 99 99
 description: Gerrit Code Review
 processname: gerrit
```

将脚本 `gerrit.sh` 链接到 `rc3.d` 目录下:

```
  sudo ln -snf `pwd`/review_site/bin/gerrit.sh /etc/init.d/gerrit
  sudo ln -snf /etc/init.d/gerrit /etc/rc3.d/S90gerrit
```

Gerrit 默认使用 servlet container: Jetty ,如果要使用其他 servlet container ，可以参考 [J2EE installation](install-j2ee.html)。

## Windows 上的安装使用

`ssh-keygen` 命令在 gerrit 初始化阶段会生成 `SSH host keys`，如果安装了 [Git for Windows](https://git-for-windows.github.io/) ，在初始化之前，需要将 git 执行文件的路径及 ssh-keygen 的路径添加到环境变量中：

```
  PATH=%PATH%;c:\Program Files\Git\usr\bin
```

重要：上面的路径不要加双引号。

初始化后，运行 daemon :

```
  cd C:\MY\GERRIT\SITE
  java.exe -jar bin\gerrit.war daemon --console-log
```

终止运行可以按 Ctrl+C.

### Gerrit 作为 Windows 服务

可以参考：[Apache Commons Daemon Procrun](http://commons.apache.org/proper/commons-daemon/procrun.html)。

安装命令如下:

```
  prunsrv.exe //IS//Gerrit --DisplayName="Gerrit Code Review" --Startup=auto ^
        --Jvm="C:\Program Files\Java\jre1.8.0_65\bin\server\jvm.dll" ^
        --Classpath=C:\MY\GERRIT\SITE\bin\gerrit.war ^
        --LogPath=C:\MY\GERRIT\SITE\logs ^
        --StartPath=C:\MY\GERRIT\SITE ^
        --StartMode=jvm --StopMode=jvm ^
        --StartClass=com.google.gerrit.launcher.GerritLauncher --StartMethod=daemonStart ^
        --StopClass=com.google.gerrit.launcher.GerritLauncher --StopMethod=daemonStop
```

## Gerrit 定制

Gerrit 定制可以参考下面文档：

* [Reverse Proxy](config-reverseproxy.md)
* [Single Sign-On Systems](config-sso.md)
* [Themes](config-themes.md)
* [Gitweb Integration](config-gitweb.md)
* [Other System Settings](config-gerrit.md)
* [Automatic Site Initialization on Startup](config-auto-site-initialization.md)

## Anonymous Access

如果设置 anonymous 可以下载 project ，那么未加密的 `git://` 协议比加密的 `ssh://` 协议要更高效。

* [man git-daemon](http://www.kernel.org/pub/software/scm/git/docs/git-daemon.html)


## Plugins

plugin 存放在 `review_site/plugins` 目录下。

## 其他参考文档

* [git-daemon](http://www.kernel.org/pub/software/scm/git/docs/git-daemon.html)

