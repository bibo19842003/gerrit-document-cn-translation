# gerrit gc

## NAME
gerrit gc - 对 project 执行 gc

## SYNOPSIS
```
ssh -p <port> <host> gerrit gc
  [--all]
  [--show-progress]
  [--aggressive]
  <NAME> ...
```

## DESCRIPTION
对 project 执行 gc 操作。

管理员需要对 gerrit 的 gc 制订一些策略。

因为配置文件重载后，会引起缓存的变化，这个是全局性的，对所有的 project 及用户都有影响。

## ACCESS
需要有管理员权限或者 `Run Garbage Collection` 权限

## SCRIPTING
建议在脚本中执行此命令

## OPTIONS
**<NAME>**
	对指定的 project 执行 gc

**--all**
	对所有的 project 执行 gc

**--show-progress**
	显示进度信息

**--aggressive**
	积极的 gc 操作

## EXAMPLES

对 project： 'myProject' 和 'yourProject' 执行 gc:
```
$ ssh -p 29418 review.example.com gerrit gc myProject yourProject
collecting garbage for "myProject":
...
done.

collecting garbage for "yourProject":
...
done.
```

对所有的 project 执行 gc:
```
$ ssh -p 29418 review.example.com gerrit gc --all
```

