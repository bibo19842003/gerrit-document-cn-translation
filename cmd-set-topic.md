# gerrit set-topic

## NAME
gerrit set-topic 为一个或多个 change 设置 topic

## SYNOPSIS
```
ssh -p <port> <host> gerrit set-topic
  <CHANGE>
  [ --topic <TOPIC> | -t <TOPIC> ]
```

## DESCRIPTION
为指定的 change 设置 topic

## ACCESS
需要有修改 topic 的权限。

## SCRIPTING
可以在脚本中执行

## OPTIONS
**<CHANGE>**
	Required; change id.

**--topic**
**-topic**
	有效的 topic 名称

## 例子
设置 topic 为 "MyTopic": change "I6686e64a788365bd252df69ae5b3ec9d65aaf068", "MyProject", branch "master" .

```
$ ssh -p 29418 user@review.example.com gerrit set-topic MyProject~master~I6686e64a788365bd252df69ae5b3ec9d65aaf068 --topic MyTopic
```

