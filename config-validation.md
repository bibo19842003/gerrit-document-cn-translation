# Gerrit Code Review - Plugin-based Validation

Gerrit 提供了相关接口，允许 [Plugins](dev-plugins.md) 在某些操作上执行校验操作。

## New commit validation

Plugins 使用 `CommitValidationListener` 接口可以对新的 commit 执行一些额外的校验操作。

如果 commit 的验证失败了，plugin 会向 git 客户端返回相关的信息。

通过 `git push` 上传的 commit 会经过校验，通过 web UI 生成的 commit 也会经过校验。

另外，gerrit 有一个 plugin，可以校验 commit-msg 的长度。

## User ref operations validation

Plugin 使用 `RefOperationValidationListener` 接口可以对用户的分支执行一些额外的校验操作。包括 ref 的创建，删除，更新。

若校验没有通过，gerrit 会抛出异常，并且阻止 refs 的更新。

## Pre-merge validation

Plugins 使用 `MergeValidationListener` 接口可以对 commit 合入代码库之前做一些校验的操作。

如果校验没有通过，plugin 会抛出 merge 失败的异常。

## On submit validation

Plugins 使用 `OnSubmitValidationListener` 接口可以对点击 submit 按钮的操作进行校验。

当放弃 submit 操作的时候，plugin 会抛出异常。

## Pre-upload validation

Plugins 使用 `UploadValidationListener` 接口可以对 upload 操作（clone, fetch, pull）做校验。校验在 gerrit 向 git 客户端发送 pack 时执行。 

如果校验时 upload 识别，那么 plugin 会向客户端抛出异常。

## New project validation

Plugins 使用 `ProjectCreationValidationListener` 接口可以对创建 project 的参数做额外的校验。

例如：强制按照某个规范来给 project 命名。

## New group validation

Plugins 使用 `GroupCreationValidationListener` 接口可以对新建 group 的参数做校验。

例如：强制按照某个规范来给 group 命名。

## Assignee validation

Plugins 使用 `AssigneeValidationListener` 接口可以在为 change 分配处理人之前，对 assignees 做校验。

## Hashtag validation

Plugins 使用 `HashtagValidationListener` 接口可以为 change 添加或移除 hashtags 做校验。

## Outgoing e-mail validation

此接口为 plugin 提供了一个过滤 e-mail 的 low-level 的 API。Plugins 使用 `OutgoingEmailValidationListener` 接口可以对外发的邮件进行过滤。

## Account activation validation

Plugins 使用 `AccountActivationValidationListener` 接口可以对 API（Gerrit REST API 或 Java extension API）设置账户状态（生效、失效）的时候进行校验。

