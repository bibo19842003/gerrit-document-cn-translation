# 用户基本指南

这个是给 Gerrit 使用者的一个指南．这个指南说明了 Gerrit 的基本工作流程以及根据具体情况如何使用 Gerrit 

在这里，期望读者已经熟悉了 [Git](http://git-scm.com/) 的一些基本命令和使用流程．

### Gerrit 是什么

Gerrit 是一个 Git 服务器，为托管的 Git 仓实施 [访问控制](access-control.md) ，并且可以通过网页做 code-review.虽然 code-review 是 Gerrit 的核心功能，但对于开发团队来说也可以不做 code-review .

### Tools

Gerrit 使用 git 协议，这个意味着客户端只需要安装 git 即可, 例如：[git](http://git-scm.com) 或者 Eclipse 中的 [EGit](http://eclipse.org/egit/) .

对 Gerrit 来说，仍然有一些客户端工具可做选择：
  * [Mylyn Gerrit Connector](http://eclipse.org/mylyn/): Gerrit 与 Mylyn 集成
  * [Gerrit IntelliJ Plugin](https://github.com/uwolfer/gerrit-intellij-plugin): Gerrit 与 [IntelliJ Platform](http://www.jetbrains.com/idea/) 集成
  * [mGerrit](https://play.google.com/store/apps/details?id=com.jbirdvegas.mgerrit): Gerrit的 Android 客户端 
  * [Gertty](https://github.com/stackforge/gertty): Gerrit 的控制接口

### 从 Gerrit 下载 Project

可以使用 `git clone` 命令从 Gerrit 服务器上下载 Project.
*从 Gerrit 下载 Project*
```shell
  $ git clone ssh://gerrithost:29418/RecipeBook.git RecipeBook
  Cloning into RecipeBook...
```
下载命令可以在 Gerrit 的网页上找到，如： `Projects` > `List` > <project-name> > `General`.

Gerrit 支持 git　的 [SSH](user-upload.html#ssh) 和 [HTTP/HTTPS](user-upload.html#http) 协议.

**NOTE:**
*如要使用 SSH 协议，开发人员需要在 Gerrit [配置公钥](user-upload.html#ssh).*

### Code-Review 工作流程

Gerrit _Code-Review_ 意味着 每个 commit 合入代码库之前需要经过评审．
开发人员可以把 commit 上传到 Gerrit 生成 change. change 存储在 Gerrit 上，并且可以被下载和评审．只有评审通过后，才能合入到代码库中．

如果 change 有一些评论，开发人员可以根据实际情况修改代码，amend ,重新上传并进行评审．

### 上传 Change

可以向 gerrit 推送 commit 的方式生成 change .　commit 必须推送到 `refs/for/`，如：推送到的目的分支为：`refs/for/<target-branch>`.
前缀 `refs/for/` 是 Gerrit 用来识别 commit 是否需要经过评审的方法．如果目标分支名称是 maser ,那么所用推送的目的分支就是 `refs/heads/master`.

*commit 经过 Code-Review 评审 *
```shell
  $ git commit
  $ git push origin HEAD:refs/for/master

  // this is the same as:
  $ git commit
  $ git push origin HEAD:refs/for/refs/heads/master
```

*commit 不经过 Code-Review 评审 *
```shell
  $ git commit
  $ git push origin HEAD:master

  // this is the same as:
  $ git commit
  $ git push origin HEAD:refs/heads/master
```

**NOTE:**
*:如果向 Gerrit 推送失败，可以参考：[报错信息](error-messages.md).*

当 commit 被推送到 Gerrit　进行 review, Gerrit 会把 change 存储在一个特别的分支上，这个分支以 `refs/changes/` 开头．change 的 ref 格式为：`refs/changes/XX/YYYY/ZZ` ，`YYYY` 是 change　号码，`ZZ` 是 patch-set 号码 ，`XX` 是 change 号码的后两位，如：`refs/changes/20/884120/1`. 

可以下载 change 进行本地的相关验证．

*下载 Change*
```shell
  $ git fetch https://gerrithost/myProject refs/changes/74/67374/2 && git checkout FETCH_HEAD
```

**NOTE:**
*fetch 的[下载命令](user-review-ui.html#download) 可以在 change　的页面复制．*

前缀 `refs/for/` 用来与 Gerrit 的"Pushing for Review" 概念相关联．从 git　角度来说，每次都推送到了相同的分支，如： `refs/for/master` ，但实际上，每个 commit 都推送到了 `refs/changes/` 开头的分支下面，因此 Gerrit 生成了未关闭状态的 change．

change 由 [Change-Id](user-changeid.md), 元数据(project 名称，分支名称等)，补丁，评论，打分等部分组成．一个 patch-set 是一次 git 的 commit. change 中的每个 patch-set 都代表了 change 的一个版本，并且以最新的版本为准．change 中通过评审的最新patch-set会合入到代码库中，其余的历史版本不会合入．

Change-Id 对 Gerrit 来说是重要的，因为 Change-Id 决定了一个 commit 推向 Gerrit 的时候是生成一个新的 change　还是在已有的 change 上生成新的 patch-set ．

Change-Id 是一个以大写字母 `I` 开头的 SHA-1 值．一般来说可以在 commit 的 message 底部看到这个值．

```
  Improve foo widget by attaching a bar.

  We want a bar, because it improves the foo by providing more
  wizbangery to the dowhatimeanery.

  Bug: #42
  Change-Id: Ic8aaa0728a43936cd4c6e1ed590e01ba8f0fbf5b
  Signed-off-by: A. U. Thor <author@example.com>
```

如果 commit 的 message 中有 Change-Id ，一旦 commit 被推向 Gerrit 待生成生成评审的时候，Gerrit 会检查这个 Change-Id 是否在此 project 的分支上存在，如果存在，Gerrit 会在 change 上生成一个新的 patch-set；如果不存在，那么使用这个 Change-Id 生成新的 change．

如果 commit 的 message 中没有有 Change-Id ，那么 commit 被推向 Gerrit 待生成生成评审的时候，Gerrit 会自动创建一个新的 change　并为这个 change 生成一个 Change-Id ．因为在这种情况下 commit 的 message 中不包含 Change-Id，如果在此基础上要再生成新的 patch-set，那么在 commit 的时候，需要手动在 message 中添加 Change-Id.
project 若配置了对 待生成 review 的 commit 中的 message 里面的 Change-Id 检验，那么可以减少新 change 代替 patch-set 的风险．没有 Change-Id 的 commit 被推送时，如果报错了，可以参考案例
[commit 的 message 缺少 Change-Id](error-missing-changeid.md).

amend 和 rebase 这样的操作会使 commit 保留原来的 Change-Id ，因此在这样的操作后，如过要推送生成 review　的话，那么会在之前的 change 上生成新的 patch-set.

*生成新 Patch-Set*
```
  $ git commit --amend
  $ git push origin HEAD:refs/for/master
```

Change-Id 对某 project 的某 branch 来说是唯一的．例如此 project 中的另外一个 branch　为了修复某问题，可以把其他分支上的 commit cherry-picke 过来，那个这个 commit 有有了同样的 Change-Id 值．Gerrit　网页上用"search"方法查找 Change-Id，可以把所有分支的同样的问题修复都查找出来．

Change-Id 可以通过 `commit-msg` hook 自动生成．

客户端上，如果为 clone 的方式下载的 repository 自动安装 `commit-msg` 可以参考：[git 模板](http://git-scm.com/docs/git-init#_template_directory).

### 评审 Change

生成 change 后，评审人员可以通过网页进行评审．评审人员可以直接查看被修改的代码及一些相关评论，然后写下自己的评论并在 review-label 上打分．
[changes 评审](user-review-ui.md) 的章节说明了评审代码的相关操作．
根据个人喜好可以配置代码 diff 的显示，具体操作可参考 [changes 评审](user-review-ui.md) 章节的相关操作．

### 上传新的 patch-set

如果评审代码时，发现需要重新修改代码，那么可以在原来的 change 上生成一个新的 patch-set．

如果要在本地 amend 当前最新的 patch-set ，可以通过命令先将其下载．下载命令可以在评审页面上查找．

commit-message 中包含的 [Change-Id](user-changeid.md) 是可以修改的．如果 commit-message 包含了 Change-Id ,那么在执行 amend 后， Change-Id 会被保留下来．

*推送 Patch-Set*
```
  // fetch and checkout the change
  // (checkout command copied from change screen)
  $ git fetch https://gerrithost/myProject refs/changes/74/67374/2 && git checkout FETCH_HEAD

  // rework the change
  $ git add <path-of-reworked-file>
  ...

  // amend commit
  $ git commit --amend

  // push patch set
  $ git push origin HEAD:refs/for/master
```

**NOTE:**
*不要 amend 已经合入到代码库中的 commit．*

可以配置 patch-set 邮催用来通知相关人员进行 review.

### 并行开发多个功能

Code-review 需要花费一些时间，在这个时间里，开发人员可以完成其他功能的开发．每个功能的开发需要在不同的开发分支上来完成，建议开发分支基于代码的最新状态拉出．
这样可以使 change 之间没有依赖并且可以单独进行 review ,反之，会产生依赖关系．依赖的说明可以参考 [changes 评审](user-review-ui.md) 相关章节．

### Watch Project

[watch project](user-notify.md) 可以得知 changes 的消息．关注后，如果 project 有新的 change 或者 change 有变更，Gerrit 会发出邮件提醒．
可以配置事件类型或者通过正则表达式对邮件进行过滤(user-search.md)．例如： '+branch:master file:^.*\.txt$+'  maser 分支上 txt 类型的后缀文件有修改的话，开发人员才会收到邮件提醒．

通常，团队成员会对所在的 project 进行关注，因为关注后，便于 review .

Project-owner 可以参考 [邮件相关配置](intro-project-owner.md)

### 添加评审人员

添加评审人员后，被添加的评审人员会收到相关的邮件通知．

添加评审人员的目的是让相关人员进行代码评审．通常，团队成员可以关注 project　而不用每个 change 手动添加评审人员，特殊情况用来手动添加评审人员．

[自动添加review人员的插件](intro-project-owner.html#reviewers) 可以通过project-owner 和 Gerrit 管理员进行部署．

### Dashboards

Gerrit 支持不同条件的 change 的查询．查询结果可以通过页面显示出来．可以保存这个页面的路径便于以后使用．

一些 change 的查询集可以组成 dashboard. dashboard 页面由不同的 change 查询集组成，每个查询集有自己的标题．

默认的 dashboard 在页面： `My` > `Changes`. dashboard 由下面部分组成：outgoing reviews, incoming reviews 和 recently closed changes.

用户可以自己[定制 dashboards](user-dashboards.md). Dashboards 添加到浏览器的书签后，可以方便后续的再次使用．

页面的 *My menu* 部分可以添加自定义查询和 dashboard．

Dashboards 对于自定义查询 changes 是非常有用的．比如，不同的 dashboards 可以对不同的 project 进行关注．

**NOTE:**
*查询的时候，可以使用一些条件对结果进行过滤，具体可以参考：[查询](user-search.md)*

Project-owner 可以共享 dashboard . project 的 dashboard 可以页面查看：`Projects` > `List` > <project-name> > `Dashboards`.

### Submit Change

Submit Change 意味着把代码合入到代码库中．Submit 是受权限控制的，如果有权限，可以在页面上点击 Submit 按钮．

每个打分项需要至少一个最高分并且没有最低分，这个时候才可以点击 Submit 按钮．每个 project 可以自定义自己的打分规则（包括打分项，分数等）．

change 合入代码库的时候是可以选择合入方式的，可以参考：[合入方式](config-project-config.md)相关部分．

点击 submit 的时候，有可能因为冲突导致合入失败．这种情况下，需要开发人员在本地 rebase 这个 change，解决冲突后上传 commit 作为新的 patch-set 继续评审．

如果是路径冲突导致 change 不能合入，页面上会有加粗的红色字体 `Cannot Merge` 作为提示.

### Rebase Change

当 change 在 review 状态时，目标分支是向前演进的．在这种情况下，change 可以 rebase 到目标分支的最新节点．如果没有冲突的话可以，可以在网页点击 rebase 按钮直接完成，否则需要在本地完成．

*本地 rebase Change*
```
  // update the remote tracking branches
  $ git fetch

  // fetch and checkout the change
  // (checkout command copied from change screen)
  $ git fetch https://gerrithost/myProject refs/changes/74/67374/2 && git checkout FETCH_HEAD

  // do the rebase
  $ git rebase origin/master

  // resolve conflicts if needed and stage the conflict resolution
  ...
  $ git add <path-of-file-with-conflicts-resolved>

  // continue the rebase
  $ git rebase --continue

  // push the commit with the conflict resolution as new patch set
  $ git push origin HEAD:refs/for/master
```

在 Gerrit 上没有解决冲突的操作，需要手动在本地解决．如果必须用手动方式解决冲突，那么此情况依赖于 submit 的方式，此方式可以在 project 中配置．

如果没有特殊情况，不要在 Gerrit 上执行 rebase 操作，因为 patch-set 会被更新，进而会给评审人员发送不必要的邮件．
然而， 如果 change 长时间没有合入到代码库，那么偶尔执行一下 rebase 操作还是有意义的，开发人员可以看到 rebase 后的 commit 节点对应着目标分支的最新节点．

**NOTE:**
*不要对已经合入到代码库的 commit 进行 rebase 操作．*

### Abandon/Restore Change

有时，code-review 的时候，发现 change 糟糕透了，这时应该放弃评审．这种情况下，可以点击 abandoned 按钮，点击后，此 change 不会出现在 open　列表中了．abandoned　后，也可以点击 restore 进行恢复．

### 使用 Topic

Change 可以按照 topic 进行分组．这个功能十分有用，因为在搜索框中可以方便的查询到有关联的 change．在评审页面的"same topic"导航栏中也找到相关联的 change．

有时一个特性的开发需要多个 change 来完成，这个时候可以用 topic 对这些 change 进行统一标识．

topic 的标识可以在 review 页面来完成，也可以通过命令行来完成（命令行可以参考 [推送](user-upload.md) 的topic章节）．

即使相同 topic 的多个 change 在不同的 project 中，Gerrit 仍然可以一次将这些 change 同时 submit ，不过需要对配置文件添加相关信息，可以参考：[系统配置](config-gerrit.md) 的 change.submitWholeTopic 章节

*Topic 通过 Push 命令实现*
```
  $ git push origin HEAD:refs/for/master%topic=multi-master

  // this is the same as:
  $ git push origin HEAD:refs/heads/master -o topic=multi-master
```

### 使用 Hashtag

Hashtag 与 topic 类似．一个 change 只能有一个 topic，但可以有多个 hashtag；一组相同 topic 的 change 可以一次同时 submit , 但 hashtag 却不可以这样操作．

hashtag 功能只能在 [NoteDb](note-db.md) 中体现．

*Hashtag 通过 Push 命令实现*
```
  $ git push origin HEAD:refs/for/master%t=stable-bugfix

  // this is the same as:
  $ git push origin HEAD:refs/heads/master -o t=stable-bugfix
```

### Work-in-Progress Changes

Work-in-Progress (WIP) 状态的 changes 对任何用户都是可见的，但不需要进行评审．

当把 change 的状态标识为 Work-in-Progress:

* 评审人员需需要进行评审的相关操作，如：添加或者移除评审人员，提交评论等．
* 此状态的 change 不会出现在评审人员的 dashboard 中．

change 的 WIP 状态是有意义的，如下情况:
* 只完成了部分的代码修改，但需要进行相关的测试并且暂不需要评审
* 在 review 过程中，发现需要重新修改代码并上传 patch-set，在 patch-set 上传之前，并不希望相关人员对代码进行评审

可以通过命令行或者在网页上直接操作把 change 设置状态为 Work-in-Progress．
如果使用命令行，需要添加参数：`%wip` .

```
  $ git push origin HEAD:refs/for/master%wip
```
另外, 可以在网页上点击 *WIP* 按钮.

同样，也可以把 WIP 状态修改为待评审的状态．
命令行需要添加参数：`%ready` .

```
  $ git push origin HEAD:refs/for/master%ready
```
另外, 可以在网页上点击 *Ready* 按钮进行状态切换.

change 的 `work-in-progress` 和 `ready` 状态切换是受权限控制的，默认情况下Change owners, project owners, 管理员是有这个权限的，其他人员需要此权限，需要单独配置．

在 PolyGerrit 风格的页面中, 可以在 *More* 菜单中选择 *WIP* 进行设置．如果页面的头部变成了黄色，表明已经切换到了 WIP 状态．如果要切换回 ready 状态，可以点击按钮 *Start Review*.

### Private Change

Private 状态的 change 默认只有 change-owner 可以看到．如果其他人员想查看此状态的 change ,需要在 *global capability* 中配置权限，具体可参考 [访问控制](access-control.md) 的 *private　changes* 章节．Private 状态的 changes 在一些情况下是有用的:

* change 暂时不想公开，只想要少数的人员看到

* change 暂时不想公开，开发人员自己先预评审

* 可以中转数据，中转后再将此 Private Change 删除．比如把数据推送动某设备上，然后其他开发人员通过下载 change 的方式就可以从此设备下载了．

涉及到安全方面的修复，请*不要*使用 private change。对于安全方面的修复，请参考后面的介绍。

push 命令可以生成 private change, 需要添加参数：`private` .

*推送 private change*
```
  $ git commit
  $ git push origin HEAD:refs/for/master%private
```

命令行可以使用参数 `remove-private` 来取消 private 状态．
也可以在网页上点击 *private* 和 *non-private* 按钮进行状态切换．

private-change 的评审人员需要手动添加，系统不会自动添加．

private-change 需要给 CI 帐号单独添加权限．

### Pitfalls

如果使用 private change，需要注意如下事项：

* 如果 private change 合入到了一个所有人都可以访问的分支上时，那么这个 change 的 private 标识会自动移除。此时，对于安全方面的修复来说，使用 private change 是一个错误的选择，因为安全修复需要再保密一段时间，直到发布新的 release .

* 如果向 private change 推送了一个 non-private change，那么其他人员可以通过 parent 关系查看之前的 private change．

* 如果做了一系列的 private change，并且其中的一个需要共享给评审人员，那么这个评审人员可以通过 commit 的 parent 关系查看到先前的 private change．

### Ignoring Or Marking Changes As 'Reviewed'

被 ignore 的 change 不会在 dashboard 中的 'Incoming　Reviews' 部分出现，并且相关的邮件提醒也会暂停．
当某开发人员被添加到评审人列表中，但此开发人员不想参与评审又不想从人员列表中移除时，可以使用此功能．

另外, 如果评审人员不想完全 ignore 那个 change, 可以将其状态标识为:'Reviewed'. 'Reviewed' 意味着在新的 patch-set 更新前，此 change 在 dashboard　中不会被高亮显示．

### Inline Edit

[线上编辑 change](user-inline-edit.md) 功能是有用的，因为小的修改可以直接在网页上完成，并直接生成新的 pathc-set．

### Project 管理员

每个 project 都有一个 [project 管理员](intro-project-owner.md).
Project 管理员可以控制此 project 的访问权限及评审流程．

### 不做 Code-Review

Gerrit 的 code-review 不是强制的．

*直接 Push 合入到代码库，不做 Code-Review*
```
  $ git commit
  $ git push origin HEAD:master

  // this is the same as:
  $ git commit
  $ git push origin HEAD:refs/heads/master
```

**NOTE:**
*直接 Push 合入到代码库，不做 Code-Review 是受权限控制的．需要对目标分支 `refs/heads/<branch-name>` 有 push 权限．*

**NOTE:**
*如果目的分支在 Gerrit 上不存在，那么不需要做 Code-Review ，可以直接 Push 到代码库．如果认为 Code-Review 是一个复杂的流程，进而不用 Code-Review ,那么这时一个糟糕的想法．*

**NOTE:**
*project-owner 有时可以开启 auto-merge 功能．因为有的 commit 不需要 review ,可以直接合入到代码库中．auto-merge 功能开启后，push　时添加一个特殊参数可以在 Gerrit 上生成 change 记录，如果 push 不用此参数的话，那么不会生成 change 记录．*

### User-Ref

User 的数据在 `All-Users` 中的 User-Ref 存储．User-Ref 是根据帐号的 account-id 命名的．User-Ref 格式为: `refs/users/nn/accountid` ,其中 `nn` 是 account-id 的后两位．

### Preferences

一些参数可以控制 Gerrit 页面的显示．用户可以按照自己的喜好进行设置：`Settings` > `Preferences`.
用户个性设置的参数存放在 `preferences.config` 文件里，此文件是 `git config` 风格的文件，这个文件存储在 User-Ref 中．

下面是个性化的设置:

  * `Date/Time 格式`:
　日期和时间的格式.

  * `Email Notifications`:
　用于设置邮件提醒.
    * `Enabled`:
　启动邮件提醒.
    * `Every comment`:
　评论触发邮件提醒．
    * `Disabled`:
　关闭邮件提醒.

  * `Email 格式`:
　设置邮件格式. 即使管理员取消了 HTML 格式的邮件，此处也不受影响．
    * `纯文本`:
　邮件值只包含纯文本格式.
    * `HTML 和纯文本`:
　邮件值支持 HTML 和纯文本格式.

  * `默认 merge 节点的父节点`:
　用来配置 change 页面`Diff Against`下拉菜单的默认 merge 节点的父节点．
    * `Auto Merge`:
　在 change 页面`Diff Against`的下拉菜单为 merge-commit 配置默认的 `Auto Merge` 节点.
    * `First Parent`:
　在 change 页面`Diff Against`的下拉菜单为 merge-commit 配置默认的 `Parent 1` 节点.

  * `Diff View`:
　选择默认的 diff view，一个是 Side-by-Side diff view ，另一个是 Unified diff ．

  * `显示 Header / Footer`:
　是否显示网页的 header 和 footer .

  * `Change-Table 中的时间显示`:
　Change-Table 中的时间显示方式，'12 days ago' 或者 'Apr 15'.

  * `Change-Size 的显示方式`:
　用色彩条显示 Change-Size．如果取消，则用数字的方式显示，如：'+297, -63'.

  * `change-ID 的显示`:
　是否在 change 列表或者 dashboard 中显示 change-ID.

  * `文件名称的显示`:
　在 change 页面中是否显示修改文件的全路径．

  * `Inline-Edit 时插入 Signed-off`:
　Inline-Edit 时是否插入 Signed-off.

  * `通过 push 发布 comment`:
　是否可以通过 push 发布 comment，默认是可以的．

  * `使用 Flash-Clipboard-Widget`:
　是否启用 Flash-clipboard-widget. 如果启用并且安装了 Flash 插件，Gerrit 提供一个 copy-to-clipboard 图标用于复制相关信息，如：Change-Ids, commit IDs 等．这个参数只有安装了 Flash 插件并且 JavaScript Clipboard API 不能使用的情况下才可以使用．

  * `work-in-progress 的默认设置`:
　对新生成的 change 是否设置成 WIP 状态．

另外，`My` 下的子菜单也可以定制，可以让页面切换更加方便．

### Reply by Email

Gerrit 会给用户发送通知邮件，在某些特定情况下还会回复邮件，可以参考：[系统配置](config-gerrit.md) 的 receiveemail 章节．

Gerrit 自动回复邮件的场景，如下:

* 新 comments 的通知
* 新 labels 的添加或者移除的通知

Gerrit 支持多种邮件客户端，如:

* Gmail
* Gmail Mobile

Gerrit 支持解析返回的 comment 类型如下:

* Change messages
* Inline comments
* File comments

需要说明的是只能用于发送对原始的通知邮件中 comment 的回复.

Gerrit 可以解析用户回复的 HTML 和 plaintext 格式的邮件. 有的邮件客户端可以从收到的 HTML 格式的邮件中提取文本，然后作为引用进行回复．这种情况下，Gerrit 支持解析 change-message.为了解决这个问题，我们可以假设收到一个文本邮件：例如

```
有人对 change 发布了 comment.
(https://gerrit-review.googlesource.com/123123 )

Change subject: My new change
......................................................................

Patch Set 3:

Just a couple of smaller things I found.

https://gerrit-review.googlesource.com/#/c/123123/3/MyFile.java
File
MyFile.java:

https://gerrit-review.googlesource.com/#/c/123123/3/MyFile@420
PS3, Line 420:     someMethodCall(param);
Seems to be failing the tests.

--
To view, visit https://gerrit-review.googlesource.com/123123
To unsubscribe, visit https://gerrit-review.googlesource.com/settings

(Footers omitted for brevity, must be included in all emails)
```

用户响应的示例：
```
Thanks, I'll fix it.
> Some User has posted comments on this change.
> (https://gerrit-review.googlesource.com/123123 )
>
> Change subject: My new change
> ......................................................................
>
>
> Patch Set 3:
>
> Just a couple of smaller things I found.
>
> https://gerrit-review.googlesource.com/#/c/123123/3/MyFile.java
> File
> MyFile.java:
Rename this file to File.java
>
> https://gerrit-review.googlesource.com/#/c/123123/3/MyFile@420
> PS3, Line 420:     someMethodCall(param);
> Seems to be failing the tests.
>
Yeah, I see why, let me try again.
>
> --
> To view, visit https://gerrit-review.googlesource.com/123123
> To unsubscribe, visit https://gerrit-review.googlesource.com/settings
>
> (Footers omitted for brevity, must be included in all emails)
```

在这种情况下，Gerrit 会把 change-message ("Thanks, I'll fix it.")，file-comment ("Rename this file to File.java") 作为对 inline-comment ("Yeah, I see why, let me try again.")的回复.

## Security Fixes

如果发现了安全方面的漏洞，那么需要进行保密，直到在新的 release 中进行发布。这意味着，开发及评审过程中，需要对其进行保密。

如果一个仓库是公开的并且赋予了可读权限，在修复安全问题的时候建议复制出一个新的仓库，并且在新的仓库中进行安全问题的修复。此新仓库需要严格控制读权限，在修复安全问题并发布新的 release 后，再将问题的修复合入到之前的公开仓库中。

尽管可以在仓库中可以拉出一个安全问题修复的分支，并严格控制新分支的权限，但并不推荐这样做，因为有权限设置方面的风险，如果权限设置错误，那么不相关的人员有可能对此分支进行访问。

对于安全问题的修复使用 privaet change 是非常非常不推荐的，上面已经进行过描述，可以参考上面的 `pitfalls` 部分。 

