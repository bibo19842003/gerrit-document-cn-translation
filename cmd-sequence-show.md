# gerrit sequence show

## NAME
gerrit sequence 用于显示当前的 sequence 数值

## SYNOPSIS
```
ssh -p <port> <host> gerrit sequence show <NAME>
```

## DESCRIPTION
Gerrit 可以维护 account, group, change 即将自动生成的 sequence 数值。sequences 数值存放在 `refs/sequences/accounts`, `refs/sequences/groups`
和 `refs/sequences/changes` 下面的 UTF-8 文本中。上面提到的 refs 存放在与之对应的 `All-Users` 和 `All-Projects` project 中。

此命令用来显示当前 sequence 的数值。

[sequence-set](cmd-sequence-set.md) 可以显示当前 sequence 的数值。

## ACCESS
此命令需要有 'Administrators' 权限。

## SCRIPTING
此命令可以在脚本中应用。

## OPTIONS
**<NAME>**
  当前可以显示的 Sequence:
    * accounts
    * groups
    * changes

## 例子
显示当前的 'changes' sequence 数值:

```
$ ssh -p 29418 review.example.com gerrit sequence show changes
42
```

