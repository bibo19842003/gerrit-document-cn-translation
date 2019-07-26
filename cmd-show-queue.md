# gerrit show-queue

## NAME
gerrit show-queue - 显示后台的任务队列信息，包括 replication 信息。

## SYNOPSIS
```
_ssh_ -p <port> <host> _gerrit show-queue_
_ssh_ -p <port> <host> _ps_
```

## DESCRIPTION
显示后台的任务队列信息，包括 replication 信息和内部计划信息(类似 cron)。

任务完成或者取消会从队列中移除。

## ACCESS
需要有管理员权限或 'View Queue' 权限。

## SCRIPTING
建议交互使用

## OPTIONS
**--wide**
**-w**
	设置输出信息的宽度显示 (默认是 80 个字符长度)

**--by-queue**
**-q**
	显示 queue 信息。

## DISPLAY

**Task**
	任务标识符。[kill](cmd-kill.md) 可以通过标识符终止任务。

**State**
	如果是运行中, 空白显示。

 * 'done' 任务完成，但还没来得及从队列中移除
 * 'killed' 任务被终止，但每没来得及从队列中移除
 * 'waiting' 任务在等待执行

**Command**
	简要描述执行的动作

## EXAMPLES

下面的队列信息包含了 project：`tools/gerrit.git` 的两个 replication 任务，分别向 `dst1` 和 `dst2` 着两个远端系统进行推送:

```
$ ssh -p 29418 review.example.com gerrit show-queue
Task     State                 Command
------------------------------------------------------------------------------
7aae09b2 14:31:15.435          mirror dst1:/home/git/tools/gerrit.git
9ad09d27 14:31:25.434          mirror dst2:/var/cache/tools/gerrit.git
------------------------------------------------------------------------------
2 tasks
```

