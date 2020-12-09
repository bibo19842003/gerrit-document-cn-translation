# gerrit set-members

## NAME
gerrit set-members - 设置群组成员

## SYNOPSIS
```
ssh -p <port> <host> gerrit set-members
  [--add USER ...]
  [--remove USER ...]
  [--include GROUP ...]
  [--exclude GROUP ...]
  [--]
  <GROUP> ...
```

## DESCRIPTION
设置群组成员

## OPTIONS
**<GROUP>**
	必要; 群组名称。

**--add**
**-a**
	添加成员的名称。

**--remove**
**-r**
	删除成员的名称。

**--include**
**-i**
	包含的群组名称。

**--exclude**
**-e**
	不涉及的群组名称。

The `set-members` command is processing the options in the following
order: `--remove`, `--exclude`, `--add`, `--include`

## ACCESS
需要 SSH 访问权限

## SCRIPTING
建议在脚本中执行此命令

## EXAMPLES

群组 my-committers 和 my-verifiers 添加成员 alice 和 bob，删除成员 eve
```
$ ssh -p 29418 review.example.com gerrit set-members \
  -a alice@example.com -a bob@example.com \
  -r eve@example.com my-committers my-verifiers
```

群组 my-friends 被包含在群组 my-committers, 但需要排除 my-committers 中的子群组： my-testers 
```
$ ssh -p 29418 review.example.com gerrit set-members \
  -i my-friends -e my-testers my-committers
```

