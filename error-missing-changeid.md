# commit xxxxxxx: missing Change-Id in message footer

原因是 commit-msg 底部缺少 Change-Id 。

可以通过 [git log](http://www.kernel.org/pub/software/scm/git/docs/git-log.html) 查看 commit-msg 信息。

[commit hook](cmd-hook-commit-msg.md) 会自动在 commit-msg 的底部生成 change-id。

## Missing Change-Id in the commit message

原因是 commit-msg 底部缺少 Change-Id 。

