# daemon

## NAME
daemon - Gerrit 服务

## SYNOPSIS
```
_java_ -jar gerrit.war _daemon_
  -d <SITE_PATH>
  [--enable-httpd | --disable-httpd]
  [--enable-sshd | --disable-sshd]
  [--console-log]
  [--slave]
  [--headless]
  [--init]
  [-s]
```

## DESCRIPTION
在本地根据 `<SITE_PATH>/etc` 路径下的 `gerrit.config` 配置文件来运行 Gerrit 服务。

## OPTIONS

**-d**
**--site-path**
	gerrit 的初始化目录，用于存放 gerrit 的配置文件，数据文件，log 等文件。

**--enable-httpd**
**--disable-httpd**
	启用 (或禁用) 内置的 HTTP 服务。默认启用。与 --slave 参数一起使用时，此参数为禁用模式。

**--enable-sshd**
**--disable-sshd**
	启用 (或禁用) 内置的 SSH 服务，默认启用。

**--slave**
	以 slave 模式运行 gerrit，客户端只能读不能写。比如：不能创建 change，不能更新 channge 等。

 此参数自动启用 '--enable-sshd'。

**--console-log**
	向控制台发送信息，而不写入 `$site_path/logs/error_log`。

**--headless**
	不启用 gerrit 网页服务。

**--init**
	执行初始化或者升级操作。

**--s**
	控制台启用 [Gerrit Inspector](dev-inspector.md)。`Gerrit Inspector` 为 gerrit 内置的调试工作。

 此参数需要从 [Jython distribution](http://www.jython.org) 下载 'jython.jar' ，然后放到目录 '$site_path/lib'。

## CONTEXT
此命令用于初始化 gerrit 或升级 gerrit。

## LOGGING
错误和告警信息会自动写入 '$site_path/logs/error_log'，每天 12:00 AM GMT 会自动将 log 打包，并重新开始存储。

## KNOWN ISSUES
Slave 模式下，caches 不会与 master 机器同步。下面是 slave 模式下的建议设置，减少 cache 的 maxAge 时间，便于系统在较短的时间内启动加载未缓存的信息。

```
[cache "accounts"]
  maxAge = 5 min
[cache "diff"]
  maxAge = 5 min
[cache "groups"]
  maxAge = 5 min
[cache "projects"]
  maxAge = 5 min
[cache "sshkeys"]
  maxAge = 5 min
```

如果配置了 LDAP ，需要加入下面设置:
```
[cache "ldap_groups"]
  maxAge = 5 min
[cache "ldap_usernames"]
  maxAge = 5 min
```

master 与 slave 的 cache 自动同步，在未来的版本中实现。

