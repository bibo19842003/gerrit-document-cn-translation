# no new changes

原因是向服务器端推送 commit 的时候，由于本地没有新的 commit，不能生成 change，所以提示此错误。

如果本地有一个新的 commit，但还是遇到这个报错，可参考下面步骤解决：

 * 本地是否生成了新的 commit，可以通过 git log 查看。
 * 推送的时候，本地分支写的是否正确。

如果仍然报这个错误，那么需要在 gerrit 的搜索框中搜索一下 commit-id，看看有没有相关的 change。

一般来说，每个 commit-id 只能推送一次生成评审，意味着：

 * 如果 change 被 abondan 了，不能重新推送，需要将其 restore。
 * 不能回退 patch-set 的版本，patch-set 版本只能递增。
 * 如果 commit 推送到了某个分支进行评审，那么不能将其推送到这个 project 的其他分支进行评审。
 * 如果 commit 被直接推送入库，那么这个 commit 不能再走评审流程。(直接推送入库的 commit 在 gerrit 上是搜索不到的)

如果要重新推送这个 commit，可以用 amend 参数重新生成 commit(生成新的 commit-id)，再进行推送。

