# gerrit set-project

## NAME
gerrit set-project - 修改 project 的设置

## SYNOPSIS
```
ssh -p <port> <host> gerrit set-project
  [--description <DESC> | -d <DESC>]
  [--submit-type <TYPE> | -t <TYPE>]
  [--contributor-agreements <true|false|inherit>]
  [--signed-off-by <true|false|inherit>]
  [--content-merge <true|false|inherit>]
  [--change-id <true|false|inherit>]
  [--project-state <STATE> | --ps <STATE>]
  [--max-object-size-limit <N>]
  <NAME>
```

## DESCRIPTION
命令行修改 project 的设置。

## ACCESS
需要有 project 的 owner 权限或者管理员权限。

## SCRIPTING
建议在脚本中执行此命令。

## OPTIONS
**<NAME>**
    必要; project 的名字。

**--description**
**-d**
    project 的描述。如果有空格，需要单引号。描述需要加双引号，如：`--description "'A description string'"`。

**--submit-type**
**-t**
    change 合入代码库的方式。

* FAST_FORWARD_ONLY: 线性合入
* MERGE_IF_NECESSARY: 有需要的时候，merge 合入
* REBASE_IF_NECESSARY: 有需要的时候，rebase 合入
* REBASE_ALWAYS: 总是 rebase 合入
* MERGE_ALWAYS: 总是 merge 合入
* CHERRY_PICK: cherry-pick 合入

更多可以参考  [Project 的配置文件格式](config-project-config.md)。

**--content-merge**
    使用 3-way merge 操作。默认关闭。对 `FAST_FORWARD_ONLY` 无效。

**--contributor-agreements**
    启用贡献声明。默认关闭。

**--signed-off-by**
    commit-msg 中需要 Signed-off-by。默认关闭。

**--change-id**
    commit-msg 底部需要有 [change-id](user-changeid.md)。只对 upload 的 commit 有影响。

**--project-state**
**--ps**
    设置 project 的状态。

* ACTIVE: 激活状态，默认值。
* READ_ONLY: 只读状态。
* HIDDEN: 隐藏状态。只有 project owner 和管理员可以看到。

**--max-object-size-limit**
	定义 object 大小的上限。向 gerrit 推送的时候，如果 object 超过上限，那么 commit 会被 gerrit 拒绝。

 支持的单位为：'k', 'm', 'g' 

## EXAMPLES
将 project `example` 的状态修改为 hidden, 校验 change-id, 不使用 content merge ，合入方式为 'merge if necessary' :
```
$ ssh -p 29418 review.example.com gerrit set-project example --submit-type MERGE_IF_NECESSARY \
  --change-id true --content-merge false --project-state HIDDEN
```

