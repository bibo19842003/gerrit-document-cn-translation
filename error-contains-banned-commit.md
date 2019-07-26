# contains banned commit ...

经 commit 推向评审的时候，如果此 commit 被 ban，或者它的祖先 comomit 被 ban 的话，会报此错误。

如果 commit 被识别为一个不好的 commit (比如侵犯了知识产权 ) 并且在代码库中被移除，这个时候本可以将 commit 标识为 ban 状态。gerrit 会阻止这样的 commit 并且会有错误提示： "contains banned commit ..."。

如果想要把基于 ban 状态生成的 commit 推送的服务器上，建议把这些 commit [cherry-pick](http://www.kernel.org/pub/software/scm/git/docs/git-cherry-pick.html) 到没有 ban 状态 commit 的分支上。

