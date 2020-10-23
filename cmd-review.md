# gerrit review

## NAME
gerrit review - 命令行评审 change

## SYNOPSIS
```
ssh -p <port> <host> gerrit review
  [--project <PROJECT> | -p <PROJECT>]
  [--branch <BRANCH> | -b <BRANCH>]
  [--message <MESSAGE> | -m <MESSAGE>]
  [--notify <NOTIFYHANDLING> | -n <NOTIFYHANDLING>]
  [--submit | -s]
  [--abandon | --restore]
  [--rebase]
  [--move <BRANCH>]
  [--json | -j]
  [--verified <N>] [--code-review <N>]
  [--label Label-Name=<N>]
  [--tag TAG]
  {COMMIT | CHANGENUMBER,PATCHSET}...
```

## DESCRIPTION
用命令行对 change 进行一些行为操作，如：评审等。

命令行中，patch-set 需要按照具体的格式来书写，'CHANGEID,PATCHSET', 如：'8242,2', 或者 'COMMIT' 格式。

如果 patch-set 使用 'COMMIT' 格式，支持完整和缩写的 commit SHA-1。如果同一个 commit-id 出现在多个 project 中，需要指定 `--project` 参数；如果出现在多个 branch 中，需要指定 `--branch` 参数。

## OPTIONS

**--project**
**-p**
	project 名称

**--branch**
**-b**
	branch 名称

**--message**
**-m**
	评审信息。需要和 json 参数一起使用。

**--json**
**-j**
	json 格式输入。

**--notify**
**-n**
	给指定用户发送通知邮件，仅在生成 chaneg 的时候生效。
* NONE: 不发送邮件
* OWNER: 给 owner 发送邮件
* OWNER_REVIEWERS: 给 owner 及评审人员发送邮件
* ALL: 给所有相关人员发送邮件 (owner, reviewer, watcher，starred)

**--help**
**-h**
	显示帮助信息。

**--abandon**
	Abandon 指定 change

**--restore**
	恢复已经 abandon 的 change

**--rebase**
	Rebase 指定 change

**--move**
	移动指定 change

**--submit**
**-s**
	Submit 指定 patch-set

**--code-review**
**--verified**
	打分

**--label**
	明确打分项名称

**--tag**
**-t**
	集成 CI 系统后，通过 CI 自动打分或者

## ACCESS
需要 SSH 访问权限

## SCRIPTING
建议在脚本中执行此命令。

## EXAMPLES

给 change (commit: c0ff33) 打分 "Verified +1"
```
$ ssh -p 29418 review.example.com gerrit review --verified +1 8242,2
```

给 change 号 8242 的第二个 patch-set 打分 "Code-Review +2"
```
$ ssh -p 29418 review.example.com gerrit review --code-review +2 8242,2
```

project 的定制 label:"mylabel" 打分:
```
$ ssh -p 29418 review.example.com gerrit review --label mylabel=+1 8242,2
```

添加评论 "Build Successful"，需要两级引用，一级是本地 shell 需要，另一级是服务器解析参数需要。
```
$ ssh -p 29418 review.example.com gerrit review -m '"Build Successful"' 8242,2
```

将未合入的 change 打分 "Verified +1" "Code-Review +2"，并合入
```
$ ssh -p 29418 review.example.com gerrit review \
  --verified +1 \
  --code-review +2 \
  --submit \
  --project this/project \
  $(git rev-list origin/master..HEAD)
```

Abandon change:
```
$ ssh -p 29418 review.example.com gerrit review --abandon 8242,2
```

## SEE ALSO

* [访问控制](access-control.md)

