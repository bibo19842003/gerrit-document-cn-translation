# gerrit index activate

## NAME
gerrit index activate - 启用最新版本的索引

## SYNOPSIS
```
_ssh_ -p <port> <host> _gerrit index activate <INDEX>_
```

## DESCRIPTION
Gerrit 支持在线升级 index。升级 gerrit 版本后，需要对 index 的 schema 进行升级，可以在线对 index 的 schema 进行升级。如果 schema 升级成功，那么系统会启用新版本；如果失败，log 中会记录相关信息。

此命令的用途是在 schema 升级失败的情况下，启用 新版本的 schema。

## ACCESS
需要有管理员权限。

## SCRIPTING
建议在脚本中执行此命令

## OPTIONS
**<INDEX>**
  启用索引，支持的参数值：
 * changes
 * accounts
 * groups

## EXAMPLES
启用最新版本的索引:

```
$ ssh -p 29418 review.example.com gerrit index activate changes
```

