# 使用 Gerrit 进行工作: 一个案例

为了理解 Gerrit 是如何工作的, 我们可以参考一个 change 的整个生命周期．这个例子使用的 Gerrit 服务器配置如下：

* *Hostname*: gerrithost
* *HTTP interface port*: 80
* *SSH interface port*: 29418

在这次演练中, 我们将要跟谁两个开发者, Max 和 Hannah, 因为他们在 +RecipeBook+ 项目中生成了一个 change 并且做了评审．我们会通过下面的阶段跟踪这个 change　:
* 本地生成 change.
* 服务器端生成 Review.
* 评审 change.
* 再次评审 change.
* 验证 change.
* 提交 change.

说明: 此项目及相关命令在这个章节仅用作演示．

### 生成 Change

开发人员 Max 决定要为项目  +RecipeBook+ 生成一个 change. 地一步是下载所要修改的代码，可以使用 `git clone` 命令下载:
```
git clone ssh://gerrithost:29418/RecipeBook.git RecipeBook
```
Max 下载代码后，用了一系列的命令为他的 commits 添加了 [Change-Id](user-changeid.md)．这个 ID 可以把相同 change 的不同版本的评审记录联系到一起．

```shell
scp -p -P 29418 gerrithost:hooks/commit-msg RecipeBook/.git/hooks/
chmod u+x .git/hooks/commit-msg
```

说明: 若要了解添加 change-id 及 commit 的 message hook 更多信息，可以参考 [commit-msg Hook](cmd-hook-commit-msg.md)

### 服务器端生成 Review

Max's 下一步需要把他的 change 推送到 Gerrit 服务器，然后其他贡献者就可以评审了．他使用了这个命令 `git push origin HEAD:refs/for/master` 进行推送，相关步骤如下:
```shell
$ <work>
$ git commit
[master 3cc9e62] Change to a proper, yeast based pizza dough.
 1 file changed, 10 insertions(+), 5 deletions(-)
$ git push origin HEAD:refs/for/master
Counting objects: 3, done.
Delta compression using up to 8 threads.
Compressing objects: 100% (2/2), done.
Writing objects: 100% (3/3), 532 bytes | 0 bytes/s, done.
Total 3 (delta 0), reused 0 (delta 0)
remote: Processing changes: new: 1, done
remote:
remote: New Changes:
remote:   http://gerrithost/#/c/RecipeBook/+/702 Change to a proper, yeast based pizza dough.
remote:
To ssh://gerrithost:29418/RecipeBook
 * [new branch]      HEAD -> refs/for/master
```

注意分支 `refs/for/master` . Gerrit 使用这个分支为 master 分支生成 reviews．如果 Max 选择将其推送到其他不同的分支，他会把命令修改为 `git push origin HEAD:refs/for/<branch_name>`. Gerrit 会为每个分支接收来自`refs/for/<branch_name>` 的推送.

命令会输出一个含有网页的链接信息，Max 可以使用这个链接对他的 commit 进行评审．点击这个链接会产生一个类似下面图片的网页．
Gerrit Code Review Screen
[Gerrit Review Screen](images/intro-quick-new-review.png)

这个是 Gerrit code review 的页面, 其他的贡献者可以对他的 commit 进行评审．Max 可以执行如下的工作:
* 查看 change 的 [差异](user-review-ui.md#diff-preferences)
* 写 [评论](user-review-ui.md#inline-comments) 或者 [回复](user-review-ui.md#reply) 回复评审者的建议或者分析
* 为这个 change [添加评审人员](intro-user.md#adding-reviewers)

在这种请看下, Max 选择了手动添加团队中的高级开发人员 Hannah 进行评审．

### 评审 Change

现在，高级开发人员 Hannah 将要对 Max 的 change 进行评审．

之前提到的, Max 选择了手动的方式添加 Hannah 成为评审人员. Gerrit 提供了其他的方法查找 change, 如下:
* 使用 [search](link:user-search.md) 功能
* 在 *Changes* 菜单中选择 *Open* 
* 设置 [邮件提醒](user-notify.md) 用来通知评审人员

因为 Max 添加 Hannah 作为评审人员, 她收到了关于这个 change 的评审邮件．她在网页中打开这个评审链接． 

注意 *Label status* 部分:

```
Label Status Needs label:
             * Code-Review
             * Verified
```
这两行表明了在 change 合入之前需要完成的检查任务．默认的 Gerrit 工作流需要两部分检查:

* *Code-Review*. 这项检查代码的策略，风格等相关的标准规范
* *Verified*. 主要检查代码编译，测试等

一般来说, *Code-Review* 检查需要开发人员查看代码, *Verified* 需要通过服务器的自动构建来完成，如:　[Gerrit Trigger　Jenkins Plugin](https://wiki.jenkins-ci.org/display/JENKINS/Gerrit+Trigger).

重要: Code-Review 和 Verified 在 Gerrit 中需要不同的权限．需要团队中将这两个任务单独分开来完成．例如:自动处理的环节只能用有 Verified 的权限，不能有 Code-Review　权限．

评审链接的网页打开后, Hannah 可以评审 Max 的 change 了. 她可以用 unified 或者 side-by-side 方式来评审代码．
两种方式都可以添加 [评论](user-review-ui.md#inline-comments) 或者 [回复](user-review-ui.md#reply) 其他开发者的留言.

Hannah 选择了使用 side-by-side 方式:
Side By Side Patch View
[Adding a Comment](images/intro-quick-review-line-comment.png)

Hannah 评审了 change. 她点击了 *REPLY* 按钮，这个操作可以对 change 进行打分.

Reviewing the Change
[Reviewing the Change](images/intro-quick-reviewing-the-change.png)

对 Hannah 和 Max 的团队来说, code-review 的打分区间是 -2 到 2．相关分数选项如下:
* `+2 Looks good to me, approved`　可以提交
* `+1 Looks good to me, but someone else must approve`　需要其他人员的同意
* `0 No score`　不发表意见
* `-1 I would prefer that you didn't submit this`　不建议提交
* `-2 Do not submit`　不能提交

另外,  change 必须有之手一个 `+2` 打分 并且没有 `-2` 打分才允许 submit. 在这里，两个 `+1` 不等于 `+2`

说明: 上面的打分机制是默认设置的，如要定制打分规则，可以参考 [Project 的配置文件格式](config-project-config.md) .

Hannah 在 Max 的 change中注意到了一个有可能的问题, 因此她选择了`-1` .她在 *Cover Message* 的文本框中写了一些反馈信息，然后点下了 *SEND* 按钮. 她的打分和反馈对其他人来说是可以见的．

## 再次评审 Change

不久, Max 决定检查一下他的 change 并且注意到了 Hannah 的反馈．他打开了代码文件并按照她的反馈进行了修改．因为 Max 的 change 含有 change-id，因此他根据常规的 git 操作更新了他之前的 commit:
* 检出 commit
* amend commit
* 推送 commit 到 Gerrit

```shell
$ <checkout first commit>
$ <rework>
$ git commit --amend
[master 30a6f44] Change to a proper, yeast based pizza dough.
 Date: Fri Jun 8 16:28:23 2018 +0200
 1 file changed, 10 insertions(+), 5 deletions(-)
$ git push origin HEAD:refs/for/master
Counting objects: 3, done.
Delta compression using up to 8 threads.
Compressing objects: 100% (2/2), done.
Writing objects: 100% (3/3), 528 bytes | 0 bytes/s, done.
Total 3 (delta 0), reused 0 (delta 0)
remote: Processing changes: updated: 1, done
remote:
remote: Updated Changes:
remote:   http://gerrithost/#/c/RecipeBook/+/702 Change to a proper, yeast based pizza dough.
remote:
To ssh://gerrithost:29418/RecipeBook
 * [new branch]      HEAD -> refs/for/master
```

这次命令的输出和 Max 的第一次输出有点不一样．这次，输出结果是 change 被 updated 了．

重新上传修改后的 commit 后，Max 回到了 Gerrit 网页, 查看 change，并比较前后两次修改的差异，确定新的修改包含了 Hannahs 的建议后，点下 *DONE* 按钮，然后让 Hannah 重新评审 change．

当 Hannah 再次查看 Max 的 change, 发现已经包含了她的反馈，然后将之前的打分修改为 `+2`.

### 验证 Change

Hannah 打的 `+2` 意味着 Max 的 change 满足 *Needs Review*　审核．不过在 change 合入之前还需要通过 *Needs　Verified* 的审核．

Verified 此项审核意味着 change 可以正常工作．这种类型的审核一般涉及的任务如下：编译成功，单元测试通过等．一个 Verified 审核可以根据实际情况配置多个任务．

说明: 此案例是 Gerrit 默认的工作流程. Verified 审核可以定制也可以移除．

Verified 通常使用自动化的方式来处理，如：[Gerrit Trigger Jenkins Plugin](https://wiki.jenkins-ci.org/display/JENKINS/Gerrit+Trigger)．然而，有的时候需要手动执行验证，比如评审人员需要了解 change 的运行机制．为了适应类似的情况，Gerrit 让每个 change 作为一个分支来存在．Gerrit UI 包含一个链接：[*download*](user-review-us.md#download) 可以让评审人员方便下载 change．
如果要手动执行 Verified ,　需要有 [Verified] permission(config-labels.html#label_Verified) 权限．
Hannah 有这个权限，所有她可以对Max 的 change 手动给 Verified 打分．

注意: 有 Verified 权限的人员可以看作是验证人员，验证人员和评审人员可以是同一个人，也可以是不同的人．

Verifying the Change
[Verifying the Change](images/intro-quick-verifying.png)

与 code-review 审核不一样, Verified 审核结果是成功或者失败．Hannah 可以打分 `+1` 或者 `-1`. change 至少要有一个 `+1` 并且没有`-1` 才可以合入．

Hannah 为 verified 打了 `+1`. Max 的 change 现在可以准备被 submit　了.

### 提交 Change

Max 现在准备 submit 他的 change. 他在网页上打开了这个 change 页面并点击了 *SUBMIT* 按钮.

此刻，Max 的 change 已经合入了 repository 的 master 分支，并且成为了 project 的一部分．

### 下一步

这个演示提供了 Gerrit 默认工作流程中的 change　大致演变过程，如果想了解更多，可以：
* 阅读 [用户基本指南](intro-user.md) 
* 参考 [项目 Owner 指南](intro-project-owner.md) 学习更多的 Gerrit 配置新，包括权限配置，Verified配置等

