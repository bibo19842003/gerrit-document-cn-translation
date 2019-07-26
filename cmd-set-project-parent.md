# gerrit set-project-parent

## NAME
gerrit set-project-parent - 修改 project 的继承关系

## SYNOPSIS
```
_ssh_ -p <port> <host> _gerrit set-project-parent_
  [--parent <NAME>]
  [--children-of <NAME>]
  [--exclude <NAME>]
  <NAME> ...
```

## DESCRIPTION
修改 project 的继承关系。每个 project 都会从其他的 project 继承权限，默认继承的是 `All-Projects`。

## ACCESS
需要有管理员权限。

## SCRIPTING
建议在脚本中执行此命令。

## OPTIONS
**--parent**
	要继承的 project 名称。默认是 `All-Projects`.

**--children-of**
	对子 project 执行递归操作。

**--exclude**
	指定的子 project 不做递归操作。
## EXAMPLES
设置 `kernel/omap` 继承 `kernel/common`:

```
$ ssh -p 29418 review.example.com gerrit set-project-parent --parent kernel/common kernel/omap
```

`myParent` 下所有的子 project 继承 `myOtherParent`:

```
$ ssh -p 29418 review.example.com gerrit set-project-parent \
  --children-of myParent --parent myOtherParent
```

## SEE ALSO

* [访问控制](access-control.md)

