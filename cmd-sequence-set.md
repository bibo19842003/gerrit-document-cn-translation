# gerrit sequence set

## NAME
gerrit sequence 用户设置 sequence 值

## SYNOPSIS
```
_ssh_ -p <port> <host> _gerrit sequence set_ <NAME> <VALUE>
```

## DESCRIPTION
Gerrit 可以维护 account, group, change 即将自动生成的 sequence 数值。sequences 数值存放在 `refs/sequences/accounts`, `refs/sequences/groups`
和 `refs/sequences/changes` 下面的 UTF-8 文本中。上面提到的 refs 存放在与之对应的 `All-Users` 和 `All-Projects` project 中。

此命令可以为 sequence 设置新的数值。

[sequence-show](cmd-sequence-show.md) 可以显示当前 sequence 的数值。

## ACCESS
此命令需要有 'Administrators' 权限。

## SCRIPTING
此命令可以在脚本中应用。

## OPTIONS
**<NAME>**
  当前可以设置的 Sequence:
    * accounts
    * groups
    * changes

**<VALUE>**
  sequence 新的值

## 例子
为 'changes' sequence 设置新的值:

```
$ ssh -p 29418 review.example.com gerrit sequence set changes 42
The value for the changes sequence was set to 42.
```

