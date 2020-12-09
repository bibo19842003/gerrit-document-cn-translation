# gerrit index start

## NAME
gerrit index start - 在线执行索引操作

## SYNOPSIS
```
ssh -p <port> <host> gerrit index start <INDEX> [--force]
```

## DESCRIPTION
Gerrit 支持在线升级 index。升级 gerrit 版本后，需要对 index 的 schema 进行升级，可以在线对 index 的 schema 进行升级。如果 schema 升级成功，那么系统会启用新版本；如果失败，log 中会记录相关信息。

此命令不需要重启 gerrit，如果当前 schema 是最新版本，那么不会执行索引的操作。

[gerrit show-queue](cmd-show-queue.md) 可以显示在线索引的状态。

## ACCESS
需要有管理员权限。

## SCRIPTING
建议在脚本中执行此命令

## OPTIONS
**<INDEX>**
  重新执行 secondary index 的索引操作，支持的参数值如下：
 * changes
 * accounts
 * groups
 * projects

**--force**
  强制执行在线索引

## EXAMPLES
启动 'changes' 的在线索引操作:

```
$ ssh -p 29418 review.example.com gerrit index start changes
```

