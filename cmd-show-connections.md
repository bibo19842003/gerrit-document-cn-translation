# gerrit show-connections

## NAME
gerrit show-connections - 显示与服务器链接的客户端的 SSH 链接

## SYNOPSIS
```
_ssh_ -p <port> <host> _gerrit show-connections_
  [--numeric | -n]
```

## DESCRIPTION
显示与服务器链接的客户端的 SSH 链接

## ACCESS
需要有管理员权限或 'View Connections' 权限。

## SCRIPTING
建议交互使用

## OPTIONS
**--numeric**
**-n**
	用 IP 地址显示客户端名字。

**--wide**
**-w**
	设置输出信息的宽度显示 (默认是 80 个字符长度)

## DISPLAY

**Session**
	session 识别的字符串。

**Start**
	链接的开始时间。服务器配置 MINA backend 才会显示。

**Idle**
	此链接最后一次传递数据到现在的持续时间。服务器配置 MINA backend 才会显示。

**User**
	用户名称。如果使用参数 `-n`，则显示用户的 id。

**Remote Host**
	主机名称，如果使用参数 `-n`，则显示的是 IP。

## EXAMPLES

反向 DNS 查找 (默认):
```
$ ssh -p 29418 review.example.com gerrit show-connections
Session     Start     Idle   User            Remote Host
--------------------------------------------------------------
3abf31e6 20:09:02 00:00:00  jdoe            jdoe-desktop.example.com
```

非反向 DNS 查找:
```
$ ssh -p 29418 review.example.com gerrit show-connections -n
Session     Start     Idle   User            Remote Host
--------------------------------------------------------------
3abf31e6 20:09:02 00:00:00  a/1001240       10.0.0.1
```

