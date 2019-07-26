# gerrit ban-commit

## NAME
gerrit ban-commit - 禁止 commit 的合入

## SYNOPSIS
```
_ssh_ -p <port> <host> _gerrit ban-commit_
  [--reason <REASON>]
  <PROJECT>
  <COMMIT> ...
```

## DESCRIPTION
标识 commit 禁止合入某 repository。Gerrit 会拒绝含有禁止 commit 的推送，并返回客户端报错信息：[contains banned commit ...](error-contains-banned-commit.md)

**NOTE:**
*此命令用于标识禁止合入的 commit，但不会从服务器端删除此 commit。*

## ACCESS
project owner 和 管理员有此权限。

## SCRIPTING
建议在脚本中执行此命令

## OPTIONS
**<PROJECT>**
	必填参数; 禁止合入 commit 所在的 project 名称

**<COMMIT>**
	必填参数; 要禁止合入的 commit

**--reason**
	禁止 commit 合入的原因.

## EXAMPLES
进制 commit `421919d015c062fd28901fe144a78a555d0b5984` 在 project `myproject` 中合入:

```shell
	$ ssh -p 29418 review.example.com gerrit ban-commit myproject \
	421919d015c062fd28901fe144a78a555d0b5984
```

