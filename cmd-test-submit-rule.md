# gerrit test-submit rule

## NAME
gerrit test-submit rule - 测试 prolog 的 submit 在 change 上是否可用

## SYNOPSIS
```
_ssh_ -p <port> <host> _gerrit test-submit_ rule
  [-s]
  [--no-filters]
  CHANGE
```

## DESCRIPTION
提供一个方法来测试 prolog 的 [submit rules](prolog-cookbook.md) 是否可用

## OPTIONS
**-s**
	从输入读取 rules.pl 文件的内容。默认文件在 refs/meta/config 分支下。

**--no-filters**
	在指定的 chaneg 中，不运行父 project 的 submit_filter/2 

## ACCESS
需要有 change 的读权限。

## EXAMPLES

用输入的方式来测试 submit_rule ，并返回 JSON 格式的结果
```
cat rules.pl | ssh -p 29418 review.example.com gerrit test-submit rule -s I78f2c6673db24e4e92ed32f604c960dc952437d9
[
  {
    "status": "NOT_READY",
    "reject": {
      "Any-Label-Name": {}
    }
  }
]
```

测试实际应用的 submit_rule 是否生效，并忽略父 project 对此的影响。
```
$ ssh -p 29418 review.example.com gerrit test-submit rule I78f2c6673db24e4e92ed32f604c960dc952437d9 --no-filters
[
  {
    "status": "NOT_READY",
    "need": {
      "Code-Review": {}
      "Verified": {}
    }
  }
]
```

## SCRIPTING
建议通过交互方式或脚本方式来使用。

