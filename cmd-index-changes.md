# gerrit index changes

## NAME
gerrit index changes - 对 change 执行索引操作

## SYNOPSIS
```
ssh -p <port> <host> gerrit index changes <CHANGE> [<CHANGE> ...]
```

## DESCRIPTION
对一个或多个 change 执行索引操作。

## ACCESS
需要有管理员权限，或者有 `Maintain Server` 权限，或者是 change 的 owner。

## SCRIPTING
建议在脚本中执行此命令

## OPTIONS
**--CHANGE**
    必要; 要被执行索引操作的 change

## EXAMPLES
对 1 号和 2 号 change 执行索引操作

```
$ ssh -p 29418 user@review.example.com gerrit index changes 1 2
```

