# gerrit create-branch

## NAME
gerrit create-branch - 创建分支

## SYNOPSIS
```
ssh -p <port> <host> gerrit create-branch
  <PROJECT>
  <NAME>
  <REVISION>
```

## DESCRIPTION
为 project 创建分支

## ACCESS
需要有 `Create Reference` 的权限

管理员默认没有此权限，如需权限，需要自行添加。

## SCRIPTING
建议在脚本中执行此命令

## OPTIONS
**<PROJECT>**
    必选; project 名称

**<NAME>**
    必选; 待创建的分支名称

**<REVISION>**
    必选; 从那个节点创建分支

## EXAMPLES
例如，在 'myproject' 中基于 'master' 分支创建 'newbranch' 分支

```
$ ssh -p 29418 review.example.com gerrit create-branch myproject newbranch master
```

