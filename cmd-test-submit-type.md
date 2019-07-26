# gerrit test-submit type

## NAME
gerrit test-submit type - 对 change 测试 prolog submit 的类型

## SYNOPSIS
```
_ssh_ -p <port> <host> _gerrit test-submit_ type
  [-s]
  [--no-filters]
  CHANGE
```

## DESCRIPTION
提供一个方法测试 prolog submit 的类型。

## OPTIONS
**-s**
	从输入读取 rules.pl 文件的内容。默认文件在 refs/meta/config 分支下。

**--no-filters**
	在指定的 chaneg 中，不运行父 project 的 submit_filter/2 

## ACCESS
需要有 change 的读权限。

## EXAMPLES

用输入的方式来测试 submit_type 并返回 submit 类型。
```
cat rules.pl | ssh -p 29418 review.example.com gerrit test-submit type -s I78f2c6673db24e4e92ed32f604c960dc952437d9
"MERGE_IF_NECESSARY"
```

测试并返回实际应用的 submit_type ，并忽略父 project 对此的影响。
```
$ ssh -p 29418 review.example.com gerrit test-submit type I78f2c6673db24e4e92ed32f604c960dc952437d9 --no-filters
"MERGE_IF_NECESSARY"
```

## SCRIPTING
建议通过交互方式或脚本方式来使用。

