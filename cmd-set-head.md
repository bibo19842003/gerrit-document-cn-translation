# gerrit set-head

## NAME
gerrit set-head - 修改 project 的默认 HEAD

## SYNOPSIS
```
_ssh_ -p <port> <host> _gerrit set-head_ <NAME>
  --new-head <REF>
```

## DESCRIPTION
修改 project 的默认 HEAD

此命令需要参数完整，不能省略参数

## ACCESS
需要有 project 的 owner 权限或者管理员权限。

## SCRIPTING
建议在脚本中执行此命令。

## OPTIONS
**<NAME>**
    必要; project 的名称。如果 project 以 `.git` 结尾，那么系统会忽略 `.git`

**--new-head**
    必要; 新的 HEAD 名称。如果分支以 `refs/heads/` 开头，那么系统会忽略这个开头。

## EXAMPLES
把 project `example` 的 HEAD 修改为 `stable-2.11`:

```
$ ssh -p 29418 review.example.com gerrit set-head example --new-head stable-2.11
```

