# Basic Gerrit Walkthrough -- For GitHub Users


[说明]
```
此文章主要面向的是 Github 的深度用户，简洁地描述了如何在 Gerrit 上做 code review。
```

过程为：下载代码，做修改，生成 change，发起评审，迭代修改，最终提交合入到服务器。详细的过程可以参考：[Gerrit 演练](intro-gerrit-walkthrough.md) 。[Gerrit 指南](index.md) 对相关的概念和配置有详细的说明。

## tl;dr

Gerrit 的代码 review 和 submit 与 Github 有所不同：

* 下载代码后，需要添加 commit-msg hook，可以参考 [commit-msg hook 示例](https://gerrit-review.googlesource.com/admin/repos/gerrit);
* review 的是 branch 的一个 commit。
* 可以使用命令 `git push origin HEAD:refs/for/master` 将本地的 commit 在 Gerrit 上生成 change，进行 review
* 根据实际情况进行代码 review，并对评审结果打分。
* 默认情况下，如果要将 change 合入，Code-Review 需要有 +2 的打分，并且没有 -2 的打分

## 1. Cloning a Repository

[说明]
```
假设本地的代码修改需要评审，而不是直接 push 到服务器上。
```

首先使用 `git clone` 命令下载代码。

对于 Gerrit 来说，下载代码后，还需要下载, [commit-msg hook](https://gerrit-review.googlesource.com/Documentation/user-changeid.html) 脚本，此脚本可以在 commit 的时候在 commit-msg 中生成 Gerrit 的 Change-Id，此 ID 可以跟踪评审的过程。

## 2. Making a Change

*Branches*

现在，本地的机器上已经有了最新的代码，可以做修改了。

对于 Github 来说，需要创建一个新的分支，再做修改，然后 commit，，此分支有可能会包含多个 commit，可以将新分支推送动远端的服务器，这样既可以备份代码又可以共享代码。

对应 Gerrit 来说，本地创建一个新的分支并做修改，然后 commit。与 Github 不同的是，不能直接将本地分支直接推送的 Gerrit 服务器上，因为需要代码 review。

*Commits*
对应 Gerrit 来说，一个 commit 是 代码 review 的最小单元，多个 commit 会生成多个 change 进行代码 review；对于 Github 来说，一个 branch 可以有多个 commit 一起进行 

![](images/user-review-ui-change-relation-chain.png[Relation chain display on the change page.]

## 3. Asking for Code Review

现在开始做代码 review 了。对于 GitHub, 在 web 页面上创建 `pull request` 。 对于 Gerrit，将本地的 commit 推送到 Gerrit 上生成 change 后，就可以评审了。

## 4. Reviewing a Change

进行对应的评审，评审过程省略200字。

## 5. Iterating on the Change

评审后，代码有可能需要更新。

## 6. Submitting a Change

对于 Gerrit，评审通过后，点击 submit 按钮合入代码。合入的时候，若有冲突，需要本地更新代码，通过 patch 的方式更新 change，重新评审，最终合入代码。
