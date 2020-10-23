# gerrit stream-events
## NAME
gerrit stream-events - 实时监听事件

## SYNOPSIS
```
ssh -p <port> <host> gerrit stream-events
```

## DESCRIPTION

实时监听服务器端的事件，并向客户端返回信息。监听事件受权限控制。

事件的输出格式为 JSON, 每行一个事件信息。

## ACCESS
需要有管理员权限或者 `streamEvents` 权限。

## SCRIPTING
建议在脚本中执行此命令。

## OPTIONS
**--subscribe|-s**
	监听具体的事件类型。

## EXAMPLES

```
$ ssh -p 29418 review.example.com gerrit stream-events
{"type":"comment-added",change:{"project":"tools/gerrit", ...}, ...}
{"type":"comment-added",change:{"project":"tools/gerrit", ...}, ...}
```

监听具体的事件类型:

```
$ ssh -p 29418 review.example.com gerrit stream-events \
   -s patchset-created -s ref-replicated
```

## SCHEMA
JSON 数据由下面信息组成：*change*, *patchSet*, *account* 等。

JSON 数据中有的字段有可能会省略，要灵活处理。

## EVENTS
### Assignee Changed

assignee 发生变化

**type** "assignee-changed"

**change** 参考 [JSON Data Formats](json.md)

**changer** 参考 [JSON Data Formats](json.md)

**oldAssignee** 修改之前的 Assignee

**eventCreatedOn** 事件创建时间，用 UNIX epoch 表示

### Change Abandoned

change abandon

**type** "change-abandoned"

**change** 参考 [JSON Data Formats](json.md)

**patchSet** 参考 [JSON Data Formats](json.md)

**abandoner** 参考 [JSON Data Formats](json.md)

**reason** abondan 原因

**eventCreatedOn** 事件创建时间，用 UNIX epoch 表示

### Change Deleted

删除 change

**type** "change-deleted"

**change** 参考 [JSON Data Formats](json.md)

**deleter** 参考 [JSON Data Formats](json.md)

### Change Merged

change 合入到代码库

**type** "change-merged"

**change** 参考 [JSON Data Formats](json.md)

**patchSet** 参考 [JSON Data Formats](json.md)

**submitter** 参考 [JSON Data Formats](json.md)

**newRev** 合入后的 revision 值

**eventCreatedOn** 事件创建时间，用 UNIX epoch 表示

### Change Restored

change restore

**type** "change-restored"

**change** 参考 [JSON Data Formats](json.md)

**patchSet** 参考 [JSON Data Formats](json.md)

**restorer** 参考 [JSON Data Formats](json.md)

**reason** retore 的原因

**eventCreatedOn** 事件创建时间，用 UNIX epoch 表示

### Comment Added

发布评论

**type** "comment-added"

**change** 参考 [JSON Data Formats](json.md)

**patchSet** 参考 [JSON Data Formats](json.md)

**author** 参考 [JSON Data Formats](json.md)

**approvals** 参考 [JSON Data Formats](json.md)

**comment** 发布的评论内容

**eventCreatedOn** 事件创建时间，用 UNIX epoch 表示

### Dropped Output

通知客户端：事件被丢弃

**type** "dropped-output"

### Hashtags Changed

hashtags 变更

**type** "hashtags-changed"

**change** 参考 [JSON Data Formats](json.md)

**editor** 参考 [JSON Data Formats](json.md)

**added** 添加的 change

**removed** 移除的 change

**hashtags** 变更后的 change

**eventCreatedOn** 事件创建时间，用 UNIX epoch 表示

### Project Created

创建 project

**type** "project-created"

**projectName** project 名称

**projectHead** project head 名称

**eventCreatedOn** 事件创建时间，用 UNIX epoch 表示

### Patchset Created

创建 patch-set

**type** "patchset-created"

**change** 参考 [JSON Data Formats](json.md)

**patchSet** 参考 [JSON Data Formats](json.md)

**uploader** 参考 [JSON Data Formats](json.md)

**eventCreatedOn** 事件创建时间，用 UNIX epoch 表示

### Ref Updated

分支更新

**type** "ref-updated"

**submitter** 参考 [JSON Data Formats](json.md)

**refUpdate** 参考 [JSON Data Formats](json.md)

**eventCreatedOn** 事件创建时间，用 UNIX epoch 表示

### Reviewer Added

添加评审人员

**type** "reviewer-added"

**change** 参考 [JSON Data Formats](json.md)

**patchSet** 参考 [JSON Data Formats](json.md)

**reviewer** 参考 [JSON Data Formats](json.md)

**adder** 参考 [JSON Data Formats](json.md)

**eventCreatedOn** 事件创建时间，用 UNIX epoch 表示

### Reviewer Deleted

移除评审人员

**type** "reviewer-deleted"

**change** 参考 [JSON Data Formats](json.md)

**patchSet** 参考 [JSON Data Formats](json.md)

**reviewer** 参考 [JSON Data Formats](json.md)

**remover** 参考 [JSON Data Formats](json.md)

**approvals** 参考 [JSON Data Formats](json.md)

**comment** Review comment cover message.

**eventCreatedOn** 事件创建时间，用 UNIX epoch 表示

### Topic Changed

topic 变更

**type** "topic-changed"

**change** 参考 [JSON Data Formats](json.md)

**changer** 参考 [JSON Data Formats](json.md)

**oldTopic** 变更前的 Topic 名称

**eventCreatedOn** 事件创建时间，用 UNIX epoch 表示

### Work In Progress State Changed

WIP 状态的变更

**type** wip-state-changed

**change** 参考 [JSON Data Formats](json.md)

**patchSet** 参考 [JSON Data Formats](json.md)

**changer** 参考 [JSON Data Formats](json.md)

**eventCreatedOn** 事件创建时间，用 UNIX epoch 表示

### Private State Changed

private 状态的变更

**type** private-state-changed

**change** 参考 [JSON Data Formats](json.md)

**patchSet** 参考 [JSON Data Formats](json.md)

**changer** 参考 [JSON Data Formats](json.md)

**eventCreatedOn** 事件创建时间，用 UNIX epoch 表示

### Vote Deleted

删除打分

**type** "vote-deleted"

**change** 参考 [JSON Data Formats](json.md)

**patchSet** 参考 [JSON Data Formats](json.md)

**reviewer** 参考 [JSON Data Formats](json.md)

**remover** 参考 [JSON Data Formats](json.md)

**approvals** 参考 [JSON Data Formats](json.md)

**comment** 评审信息

## SEE ALSO

* [JSON Data Formats](json.md)
* [访问控制](access-control.md)

