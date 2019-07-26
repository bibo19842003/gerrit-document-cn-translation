# Gerrit Code Review - Mail Templates

Gerrit 使用 [Closure Templates](https://developers.google.com/closure/templates/) (Soy) 作为邮件标准，用来发送邮件。如果标准不重载，可以使用内置的默认模板。这些默认的模板可以当作例子来使用，管理员可以复制并进行简单的修改。

```
**兼容性说明：**
之前，Velocity Template Language（VTL）被用作 Gerrit 电子邮件的模板语言。现在已经移除了对 VTL 的支持，转而使用 Soy，并且不再支持 Velocity 模板。
```

## Template Locations and Extensions

默认的邮件模板存放在 `'$site_path'/etc/mail` 目录，以 `.soy.example` 结尾。修改这些文件不影响 gerrit 的正常使用。如果要定制模板的话，可以复制对应文件，然后去掉 `.example`，最后进行内容修改。

## Supported Mail Templates

gerrit 发送的邮件至少需要一个模板的支持。下面是模板的列表。change 邮件需要两个模板的支持，一个用来设置 subject，另一个用来设置 footer(参考下面的 `ChangeSubject.soy` 和 `ChangeFooter.soy`)。

gerrit 支持 HTML 和 纯文本类型的邮件。邮件模板名称中，如果含有 Html 字样，则为 HTML 类型模板。比如，对于 "Abandoned" 邮件，`Abandoned.soy` 为文本类型；`AbandonedHtml.soy` 为 HTML 类型。

### Abandoned.soy and AbandonedHtml.soy

"Abandoned" 模板，change 被 abandon 的信息。属于 `ChangeEmail`：参考 `ChangeSubject.soy` 和 `ChangeFooter`。

### AddKey.soy and AddKeyHtml.soy

AddKey 模板，帐号添加 SSH and GPG 的信息。如果管理员给其他用户添加的时候，则不发送邮件通知。

### ChangeFooter.soy and ChangeFooterHtml.soy

ChangeFooter 模板，邮箱底部，change 的相关信息。属于 `ChangeEmail` 的一部分。

### ChangeSubject.soy

`ChangeSubject.soy` 模板，邮箱的 subject 信息。 

### Comment.soy

`Comment.soy` 模板，用户向 change 发布的评论信息。是一种 `ChangeEmail`，参考 `ChangeSubject.soy`, ChangeFooter and CommentFooter。

### CommentFooter.soy and CommentFooterHtml.soy

CommentFooter 模板，邮箱底部，用户向 change 发布评论的信息。可参考 `ChangeSubject.soy`, Comment 和 ChangeFooter。

### DeleteKey.soy and DeleteKeyHtml.soy

DeleteKey 模板会根据从用户账户中删除的 SSH 或 GPG 密钥来确定邮件的内容。当管理员删除其他用户信息的时候，系统不会发送邮件。

### DeleteVote.soy and DeleteVoteHtml.soy

DeleteVote 模板，change 的打分被移除的相关信息。属于 `ChangeEmail`，参考 `ChangeSubject.soy`, ChangeFooter。

### DeleteReviewer.soy and DeleteReviewerHtml.soy

DeleteReviewer 模板，change 的 评审人员被移除的信息。属于 `ChangeEmail`，参考 `ChangeSubject.soy`, ChangeFooter。

### Footer.soy and FooterHtml.soy

Footer 模板，在 ChangeFooter 和 CommentFooterwill 后面添加的信息。

### HttpPasswordUpdate.soy and HttpPasswordUpdateHtml.soy

HttpPasswordUpdate 模板会根据用户添加或修改或删除 HTTP 密码来确定邮件内容。 

### Merged.soy and MergedHtml.soy

Merged 模板，change 合入代码库的信息。属于 `ChangeEmail`，参考 `ChangeSubject.soy`, ChangeFooter。

### NewChange.soy and NewChangeHtml.soy

NewChange 模板，新 change 的信息。属于 `ChangeEmail`，参考 `ChangeSubject.soy`, ChangeFooter。

### RegisterNewEmail.soy

`RegisterNewEmail.soy` 模板，注册新邮箱的信息。

### ReplacePatchSet.soy and ReplacePatchSetHtml.soy

ReplacePatchSet 模板，change 新 patch-set 生成的信息。属于 `ChangeEmail`，参考 `ChangeSubject.soy`, ChangeFooter。

### Restored.soy and RestoredHtml.soy

Restored 模板，change 被 restore 的信息。属于 `ChangeEmail`，参考 `ChangeSubject.soy`, ChangeFooter。

### Reverted.soy and RevertedHtml.soy

Reverted 模板，change 被 revert 的信息。属于 `ChangeEmail`，参考 `ChangeSubject.soy`, ChangeFooter。

### SetAssignee.soy and SetAssigneeHtml.soy

SetAssignee 模板，change 分配给相关人员执行的信息。属于 `ChangeEmail`，参考 `ChangeSubject.soy`, ChangeFooter。

## Mail Variables and Methods

邮件模板通过 Soy 的上下文可以访问和显示当前可用的对象。

### Warning

如果邮箱模板有问题，那么系统不会发送邮件。

### All OutgoingEmails

所有发出的邮件可以使用如下变量：

**$email.settingsUrl**

用户个人设置的地址。

**$email.gerritHost**

Gerrit 主机的名称。

**$email.gerritUrl**

Gerrit 网页地址。

**$messageClass**

一个包含 messageClass 的字符串。

### Change Emails

Change 相关的邮件模板使用下面的数据变量。另外，所有系统发送的邮件都可以使用如下变量。

**$changeId**

当前 change 的 Id (`Change.Key`).

**$coverLetter**

`ChangeMessage` 的文本信息。

**$fromName**

邮件的发送人。

**$email.unifiedDiff**

change 的 diff 信息。

**$email.changeDetail**

change 的具体信息，包括 commit-msg。

**$email.changeUrl**

change 的 URL。

**$email.includeDiff**

是否在邮件中显示 change 的 diff。

**$change.subject**

当前 change 的 subject。

**$change.originalSubject**

当前 change 的第一个 patch-set 的 subject。

**$change.shortSubject**

change 的 subject，此 subject 的长度为 72 个字符，超过部分用省略号表示。

**$change.shortOriginalSubject**

change 的第一个 patch-set 的 subject，此 subject 的长度为 72 个字符，超过部分用省略号表示。

**$change.ownerEmail**

change owner 的 邮件地址。.

**$branch.shortName**

change 目标分支的名称。

**$projectName**

change 的 project 名称。

**$shortProjectName**

project 缩写的名称

**$instanceAndProjectName**

Gerrit i地址及 project 名称。

**$addInstanceNameInSubject**

email 的 subject 是否包含 gerrit 地址。


**$sshHost**

Gerrit 的 SSH 主机名。

**$patchSet.patchSetId**

当前的 patch-set 号。

**$patchSet.refname**

patch-set 的 ref 名称。

**$patchSetInfo.authorName**

patch-set 的 author 名字。

**$patchSetInfo.authorEmail**

patch-set 的 author 邮箱地址。

