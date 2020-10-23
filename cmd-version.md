# gerrit version

## NAME
gerrit version - 显示 gerrit 版本号

## SYNOPSIS
```
ssh -p <port> <host> gerrit version
```

## DESCRIPTION
显示 gerrit 版本号，显示的信息以 `gerrit version` 开头。

`git describe` 命令可以生成版本号字符串。官方发布的 Gerrit 版本号与 Gerrit 源码中的 tag 是对应的。如果从其他的 commit(非官方发布的 tag) 构建 Gerrit，那么构建出的版本号格式为 `<tagname>-<n>-g<sha1>`，`<n>` 是基于`<tagname>` 做了几个提交， `<sha1>` 为 commit 的 7 个字符的简写。

## ACCESS
需要 SSH 访问权限

## SCRIPTING
建议在脚本中执行此命令。

## EXAMPLES

```
$ ssh -p 29418 review.example.com gerrit version
gerrit version 2.4.2
```

