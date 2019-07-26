# Gerrit Code Review - Change-Ids

## Description

Gerrit 需要识别出哪些 commit 属于同一个 review。例如，因为某个 change 需要修改，这个时候需要将修改后的 commit 上传到这个 change 上面。由于 commit-msg 底部的相同 change-id，Gerrit 允许将两个 commit 提交到相同的 change 上。通过 Change-Id, Gerrit 可以自动将 change 的新老版本进行关联，甚至与 cherry-picks 和 rebases 操作进行关联。

为了在 Gerrit 上完成 cherry-pick 操作，Change-Id 必须找 commit-msg 的底部，可以与 [Signed-off-by](user-signedoffby.md), must be Acked-by 或其他信息在一起，如下：

```
  $ git log -1
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

上面的例子中, `Ic8aaa0728a43936cd4c6e1ed590e01ba8f0fbf5b` 是被赋予的 change-id，change-id 和 commit-id 是的概念是不一样的。为了避免混淆，change-id 以大写字母 `I` 开头。

Change-Id 在 gerrit 上面可以不是唯一的。在不同的分支，或者不同的 project 中可以重复；但在同一个 project 的 同一个分支上是不能重复的。

## Creation

Change-Ids 是在客户端 commit 的时候生成的。gerrit 提供了一个标准的 'commit-msg' hook，在 commit-msg 底部没有 change-id 的情况下，这个 hook 可以在 `git commit` 的时候自动生成 change-id 并将其自动添加到 commit-msg 中。

可以执行下面命令将 hook 从 gerrit 下载到本地的 project 中：

```
  $ curl -Lo .git/hooks/commit-msg http://review.example.com/tools/hooks/commit-msg
```

或:

```
  $ scp -p -P 29418 john.doe@review.example.com:hooks/commit-msg .git/hooks/
```

并且需要给 hook 添加可执行权限：

```
  $ chmod u+x .git/hooks/commit-msg
```

更多细节，可以参考 [commit-msg](cmd-hook-commit-msg.md)。

## Change Upload

在向 `+refs/for/*+` 或 `+refs/heads/*+` 上传 commit 的时候，gerrit 会试图查找和当前上传 commit 相关的 review，与之匹配的属性如下：

* Change-Id
* Repository name
* Branch name

属性全都相同，才认为是匹配。下面是不同场景的描述：

* 创建新的 change

 如果匹配的 review 没有找到，那么 gerrit 会创建一个新的 change。

* 更新已有的 change

 如果找到了匹配的 change，gerrit 会把 commit 当作这个 change 的新的 patch-set。

* 关闭 change

 如果匹配到了 review，并且 commit 是直接向 `refs/heads/*` 推送，那么 gerrit 会把 change 关闭并标识为 merged 状态。

如果 Change-Id 在 commit-msg 底部不存在，gerrit 会自动生成一个 change-id 并在网页上显示。如果此 change 要更新，可将网页上的 change-id 复制到新的 commit-msg 中。

默认，gerrit 会阻止没有 change-id 的 commit-id 的推送，如下报错：

```
  ! [remote rejected] HEAD -> refs/for/master (missing Change-Id in commit
  message footer)
```

如果不想阻止没有 change-id 的 commit 的推送，可以在 project 中将 "Require Change-Id in commit message" 设置为 "FALSE"。

## Git Tasks

### 创建新 commit

当创建新的 commit 之前，要确保 'commit-msg' hook 已经在本地的 proejct 中。执行 git commit 后，git 会在 commit-msg 中自动生成 change-id。

### amend commit

执行 `git commit --amend` 命令时，如果不修改 commit-msg 中的 change-id，那么可以使用生成的 commit 来更新已有的 change。

### rebase commit

执行 rebase 操作的时候，如果不修改 commit-msg 中的 change-id，那么可以使被 rebase 的 commit 来更新已有的 change。

### squash commit

squash 一些 commit 时候，会有多个 change-id，保留一个 change-id 即可，然后在 gerrit 上将其他的 change-id 关联的 change 关闭。

### cherry-picki commit

执行 cherry-picking 命令时，如果保持 change-id 不变，那么会更新当前的 change，此操作在 `fast-forward-only` 合入策略的 project 中比较适用。

执行 cherry-picking 命令时，如果变更 change-id ，那么会生成一个新的 change，此操作在移植 commit 的时候比较适用。

### 更新 commit

如果 commit-msg 中没有 change-id，那么可以使用 amend 命令后，手动在 commit-msg 底部添加 change-id 信息，然后就可以将 commit 上传来更新已有的 change 了。

