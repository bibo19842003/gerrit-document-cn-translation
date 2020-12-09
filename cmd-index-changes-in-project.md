# gerrit index changes in project

## NAME
gerrit index changes in project - 对 project 中的所有 change 执行索引操作

## SYNOPSIS
```
ssh -p <port> <host> gerrit index changes-in-project <PROJECT> [<PROJECT> ...]
```

## DESCRIPTION
对 project 中的所有 change 执行索引操作

## ACCESS
需要有管理员权限，或者有 `Maintain Server` 权限。

## SCRIPTING
建议在脚本中执行此命令

## OPTIONS
**<PROJECT>**
    必要; project 的名称

## EXAMPLES
对 project: MyProject, NiceProject 中的所有 change 执行索引操作

```
$ ssh -p 29418 user@review.example.com gerrit index changes-in-project MyProject NiceProject
```

