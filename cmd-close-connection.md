# gerrit close-connection

## NAME
gerrit close-connection - 关闭具体的 SSH 链接

## SYNOPSIS
```
ssh -p <port> <host> gerrit close-connection <SESSION_ID> [--wait]
```

## DESCRIPTION
关闭具体的 SSH 链接

关闭的操作默认是异步进行的，使用参数 `--wait` 可以等待链接关闭。

命令中需要明确 `SESSION_ID`，否则会报错。

## ACCESS
需要管理员权限

## SCRIPTING
建议交互方式使用

## OPTIONS

`--wait` : 等待链接关闭。

