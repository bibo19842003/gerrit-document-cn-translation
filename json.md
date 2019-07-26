# Gerrit Code Review - JSON Data

JSON 格式的数据流可以被众多软件程序使用，下面是数据结果的描述，JSON 数据中有的字段有可能会省略，要灵活处理。

## change
change 要么是正在被评审，要么已经是评审过了。

**project** Project 名称

**branch** Branch 名称

**topic** Topic 名称

**id** Change-ID

**number** Change 号 (已废弃).

**subject** change 的描述

**owner** Owner 信息

**url** change 的 URL

**commitMessage** commit Message

**hashtags** hashtag 名称

**createdOn** change 创建的日期时间，用 UNIX epoch 表示

**lastUpdated** change 最后更新的日期时间，用 UNIX epoch 表示

**open** change 是否处于 open 状态，用布尔值表示

**status** change 的状态

* **NEW** Change 处于评审中

* **MERGED** Change 已经合入到了代码库

* **ABANDONED** Change 被 abandon

**private** change 是否为 private 状态，用布尔值表示

**wip** change 是否为 wip 状态，用布尔值表示

**comments** 评论内容

**trackingIds** trackingid 信息

**currentPatchSet** 当前 patch-set 信息

**patchSets** 所有 patch-set 信息

**dependsOn** 依赖的 change 的信息

**neededBy** 被依赖的 change 信息

**submitRecords** change 的 submit 按钮状态 (已经合入代码库或可以合入代码库)

**allReviewers** 评审列表中的人员信息

## trackingid
issue-tracking-system 的链接

**system** 系统的名称，来自文件 gerrit.config

**id** commit-msg 中问题的 Id 号

## account
用户帐号信息

**name** 用户全名

**email** 用户的 email

**username** 用户名称

## patchSet
patchset 信息

**number** patchset 号

**revision** commit-id

**parents** 父节点信息

**ref** change 在服务器端的命名空间

**uploader** commit 上传人员信息

**author** patch-set 作者信息

**createdOn** patch-set 创建时间

**kind** change 的类型

* **REWORK** 非传统内容类型

* **TRIVIAL_REBASE** 与新的父节点无冲突

* **MERGE_FIRST_PARENT_UPDATE** 与第一父节点无冲突

* **NO_CODE_CHANGE** 文件无变化。相同的 tree, parent tree

* **NO_CHANGE** 无变化。相同的 commit-msg, tree, parent tree

**approvals** 打分记录

**comments** 评论信息

**files** 所修改的文件列表

**sizeInsertions** 增加行数

**sizeDeletions** 删除行数

## approval
patch-set 的打分记录

**type** 打分项名称

**description**  评论描述

**value** 打分值

**oldValue** 上一次打分值（如果只有一次打分，那么显示当前打分值）

**grantedOn** 最后一次打分时间

**by** 打分人

## refUpdate
ref 信息

**oldRev** 更新前的 commit-id

**newRev** 更新后的 commit-id。如果值是 0 (`0000000000000000000000000000000000000000`)，说明此 ref 已删除

**refName** change 在服务器端的命名空间

**project** project 名称

## submitRecord
change 的打分明细

**status** change 的 submit 状态

* **OK** change 已提交或可以提交

* **NOT_READY** 需要继续打分

* **RULE_ERROR** 服务器端错误

**labels** 打分项描述

**requirements** 当前 change 的合入还需要的打分

## requirement
change 的合入需要的打分说明

**fallbackText** 描述信息

**type** 打分说明的字符串缩写

**data** (可选) 数据结构的链接。

## label
打分的信息

**label** 打分项的名称

**status** 打分项的状态

* **OK** 通过

* **REJECT** 不通过

* **NEED** 有瑕疵，但可以通过

* **MAY** 非必要打分项

* **IMPOSSIBLE** 需要评审，但未配置权限

**by** 评审人信息

## dependency
patch-set 的依赖信息

**id** Change-id

**number** Change 号

**revision** Patch-set 的 commit-id

**ref** Ref 名称

**isCurrentPatchSet** 是否为最新 patch-set

## message
评审人员对 change 的评论

**timestamp** 评论生成的时间

**reviewer** 评审人

**message** 评审内容

## patchsetComment
评审人员添加的 patch-set 的评论

**file** 评论的文件名称

**line** 文件的行号

**reviewer** 评审人

**message** 评审内容

## file
所修改的文件信息

**file** 文件名称。如果是重命名文件，显示命名后的名称

**fileOld** 文件名称。如果是重命名文件，显示命名前的名称

**type** 文件的类型

* **ADDED** 添加

* **MODIFIED** 修改

* **DELETED** 删除

* **RENAMED** 重命名

* **COPIED** 复制

* **REWRITE** 重写（修改的太多了）

**insertions** 增加行数

**deletions**  删除行数

## SEE ALSO

* [gerrit stream-events](cmd-stream-events.md)
* [命令行搜索](cmd-query.md)

