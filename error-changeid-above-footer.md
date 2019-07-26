# commit xxxxxxx: Change-Id must be in message footer

由于 commit-msg 的底部缺少 Change-Id 信息，会报此错误。

为了在页面上完成 cherry-pick 操作，commit-msg 中需要有 Change-Id 信息。

可以使用 [git log](http://www.kernel.org/pub/software/scm/git/docs/git-log.html) 命令来查看 commit-msg 的信息。


## Change-Id is contained in the commit message but not in the last paragraph

如果 Change-Id 在 commit-msg 的中间，而不是底部（最后一个段落），那么同样会报此错误。

为了避免在网页上 cherry-pick 报错，可以事先确认在 project 中是否配置了：commit-msg 中需要 Change-Id。

