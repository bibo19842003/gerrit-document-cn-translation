# Changes

每个 change 表示了一个评审的 commit，change 通过 `change-id` 进行识别。

当 change 合入的时候，只有 patch-set 的最新版本才会合入到代码库。

change 的页面，有如下相关信息：

* 当前的及之前的 patch-set
* change 的相关属性，如：owner，project，branch
* comment 信息
* 打分的相关情况
* change-id

## Change properties

当打开一个 change 页面的时候，review 页面会显示一些 change 的属性信息。

_Change Properties_

|Property|Description
| :------| :------|
|Updated|change 最后一次更新的时间
|Owner|创建 change 的人员
|Assignee|change 的评审负责人
|Reviewers|change 的评审人员
|CC|关注 change 的人员，但不需要评审
|Project|project 名称
|Branch|change 要合入的目标分支
|Topic|topic
|Strategy|change 合入的方式
|Code Review| change 评审的状态

另外，gerrit 还会显示一些自定义 label 的状态，不过需要 label 已经在服务器上进行了配置，可以参考 [Review Labels](config-labels.md)。

## Change Message

紧挨着 change properties 的是 change message。就是 commit 的 message 信息。可以点击 *Edit* 进行编辑。

通常情况下，change message 包含 Change-Id，可以通过 Change-Id 进行 change 的搜索。

## Related Changes

有时，一个 change 会依赖另外一个 change，这些 change 的信息会以分组的列表形式进行显示。

* 关联关系。change 之间有父子关系，而不是 topic 的关系。
* Merge 冲突。与当前 change 有冲突的 change。
* Submitted Together。有相同 topic 的 change。

## Topics

Changes 可以通过 topic 进行分组。使用 topic 标识后，搜索有关联的 change 会更加的方便。具有相同 topic 的 change 会在页面的 *Relation Chain* 部分显示。

通过 topic 对 change 分组是有必要的，因为有的时候需要多个 change 一起来实现新的功能。

topic 可以在 change 页面设置；同样，也可以通过 `git push` 命令来实现。

## Submit strategies

project 可以指定 change 合入到代码库中的方式。

下面描述了可支持的合入方式。

_Submit Strategies_

|Strategy|Description
| :------| :------|
|Fast Forward Only|不生成 merge 节点。在 change 合入之前，所有的合并操作需要在客户端完成。目标分支的代码必须要少于 change 所在分支的代码。
|Merge If Necessary|默认的代码合入方式。线性合入时，不产生 merge 节点；非线性合入时，产生 merge 节点。
|Always Merge|总是生成 merge 节点。即使在线性合入的时候，也会产生。如果用户想要使用 `git log --first-parent` 命令读取 log 可以使用此方式。
|Cherry Pick|总是 cherry-pick 方式合入 patch-set，可以忽略 change 的继承关系。合入后，会在目标分支上创建一个新的 commit。对 change 执行 pick 操作后，会在 commit-msg 的底部添加打分的相关信息。change 的 committer 会变为 submitter，author 保持不变。说明：使用此种合入方式，gerrit 会忽略 change 间的依赖关系，除非同时启用了 `change.submitWholeTopic` 及多个 change 使用了相同的 topic。也就是说，使用此种合入方式，submitter 需要记住合入 change 的顺序。
|Rebase if Necessary|若是线性合入的话，commit 直接合入；如果是非线性合入，那么会执行 rebase 操作。
|Rebase Always|与 `Cherry Pick` 类似，但不会忽略依赖关系。即使是线性合入，也会生成新的 patch-set 合入。

project-owner 有权限修改 change 合入到代码库的方式。

## Change-Id

Gerrit 使用 Change-Id 来标识 change。例如，开发人员对 project 上传了一个 change，评审人员提出建议需要修改代码，这时开发人员基于最新的代码做完修改后，手动修改了 change-id 的信息，和之前的保持一致，然后进行上传。此时，在原来的 change 上面生成了一个新的 patch-set。

Change-Ids 附加到 commit-msg 的底部，参考如下：

```
commit 29a6bb1a059aef021ac39d342499191278518d1d
Author: A. U. Thor <author@example.com>
Date: Thu Aug 20 12:46:50 2009 -0700

    Improve foo widget by attaching a bar.

    We want a bar, because it improves the foo by providing more
    wizbangery to the dowhatimeanery.

    Bug: #42
    Change-Id: Ic8aaa0728a43936cd4c6e1ed590e01ba8f0fbf5b
    Signed-off-by: A. U. Thor <author@example.com>
    CC: R. E. Viewer <reviewer@example.com>
```

Gerrit 需要在 commit-msg 的底部（最后一段）有 Change-Id 的信息。change-id 可以与 Signed-off-by, CC 或其他信息结合在一起。

另外， Change-Id 与 commit-id 有些类似，为了避免混淆，change-id 以 `I` 开头。

添加 Change-Id 的方式有几种，标准的方式是使用 git 的 [commit-msg hook](cmd-hook-commit-msg.md) 自动在新的 commit 中生成 change-id。

