# gerrit rename-group

## NAME
gerrit rename-group - 内部群组更名

## SYNOPSIS
```
_ssh_ -p <port> <host> _gerrit rename-group_
  <GROUP>
  <NEWNAME>
```

## DESCRIPTION
内部群组更名

## ACCESS
需要有群组的 owner 权限或管理员权限。

## SCRIPTING
建议在脚本中执行此命令。

## OPTIONS
**<GROUP>**
	必填; 当前群组名称name of the group to be renamed.

**<NEWNAME>**
	必填; 新群组名称new name of the group.

## EXAMPLES
群组 "MyGroup" 更名为 "MyCommitters".

```
$ ssh -p 29418 user@review.example.com gerrit rename-group MyGroup MyCommitters
```

