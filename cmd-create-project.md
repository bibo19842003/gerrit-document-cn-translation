# gerrit create-project

## NAME
gerrit create-project - 创建 project

## SYNOPSIS
```
_ssh_ -p <port> <host> _gerrit create-project_
  [--owner <GROUP> ... | -o <GROUP> ...]
  [--parent <NAME> | -p <NAME> ]
  [--suggest-parents | -S ]
  [--permissions-only]
  [--description <DESC> | -d <DESC>]
  [--submit-type <TYPE> | -t <TYPE>]
  [--use-contributor-agreements | --ca]
  [--use-signed-off-by | --so]
  [--use-content-merge]
  [--create-new-change-for-all-not-in-target]
  [--require-change-id | --id]
  [[--branch <REF> | -b <REF>] ...]
  [--empty-commit]
  [--max-object-size-limit <N>]
  [--plugin-config <PARAM> ...]
  { <NAME> }
```

## DESCRIPTION
在 `gerrit.basePath` 下创建裸仓。

如果启用了 replication 功能，gerrit 会根据相关配置使用 SSH 命令在远端创建同样的裸仓。

## ACCESS
需要有管理员权限

## SCRIPTING
建议在脚本中执行此命令

## OPTIONS
**<NAME>**
	必要; 新建的 project 名称。如果名称以 `.git` 结尾，那么 `.git` 会被忽略。

**--branch**
**-b**
	可以创建分支，新分支的名称。

**--owner**
**-o**
	指定 project 的 owner

```
owner 信息如下:

* 群组的 UUID
* 群组的 ID
* 群组的具体名称
```

添加 owner 时，确保群组信息是准确的，命令行可以同时添加多个群组。

gerrit.config 中可以配置 project 的默认 owner ：`repository.*.ownerGroup`

**--parent**
**-p**
	新 project 所继承的 project 名称，默认为 `All-Projects`

**--suggest-parents**
**-S**
	显示当前系统的 parent project 列表。不能和其他参数一起使用。

**--permissions-only**
	只用作权限设置，用于被其他 project 继承。HEAD 会指向 'refs/meta/config'。

**--description**
**-d**
	新 project 描述。

 描述中如果有空格的话，需要加单引号 (') 如：`--full-name "'A description string'"`

**--submit-type**
**-t**
	change 合入代码库的方式。支持以下方式：

* FAST_FORWARD_ONLY: 线性合入
* MERGE_IF_NECESSARY: 必要的时候会创建 merge 节点
* REBASE_IF_NECESSARY: 必要的时候会 rebase 操作
* REBASE_ALWAYS: 总是 rebase 操作
* MERGE_ALWAYS: 总是 merge 操作
* CHERRY_PICK: cherry-pick


 默认设置是 MERGE_IF_NECESSARY ，默认设置可以更改，具体参考 [Project 的配置文件格式](config-project-config.md) 的相关部分。

**--use-content-merge**
	如果启用，Gerrit 将使用 3-way merge 的方式出来文件内容。此参数不能与 FAST_FORWARD_ONLY 一起使用。默认不启用。

**--use-contributor-agreements**
**--ca**
	如果启用，作者需要完成贡献说明，默认不启用。

**--use-signed-off-by**
--so:
	如果启用，commit-msg 需要包含 Signed-off-by ，默认不启用。

**--create-new-change-for-all-not-in-target**
--ncfa:
	如果启用，只有目标分支上未出现过的 commit 才能生成 change。为了避免一下产生大量的 change，meger 节点不允许上传。默认不启用。

**--require-change-id**
**--id**
	commit-msg 需要有 [change-id](user-changeid.md)。直接 push 不受此参数校验。

**--empty-commit**
	创建 project 的时候，生成一个空提交。

**--max-object-size-limit**
	object 大小的上限。支持的单位如下： 'k', 'm', 'g' 。

**--plugin-config**
	在 project 中配置 plugin。格式为：'<plugin-name>.<parameter-name>=<value>'

## EXAMPLES
创建 project： `tools/gerrit`:

```
$ ssh -p 29418 review.example.com gerrit create-project tools/gerrit.git
```

创建 project 并添加 描述:

```
$ ssh -p 29418 review.example.com gerrit create-project tool.git --description "'Tools used by build system'"
```

 描述中如果有空格的话，需要加单引号 (') 如：`--full-name "'A description string'"`

## REPLICATION
如果安装了 plugin: replication ，那么在创建 project 的时候系统会执行一个  Bourne shell 脚本:

```
mkdir -p '/base/project.git' && cd '/base/project.git' && git init --bare && git update-ref HEAD refs/heads/master
```

如果要成功执行上面的脚本，远端的系统需要安装 `git`。管理员也可以使用上买的命令创建 project。

在远端创建 project 的时候，可以基于开发接口 NewProjectCreatedListener 做新的定制。

## SEE ALSO

* [Project 配置](project-configuration.md)

