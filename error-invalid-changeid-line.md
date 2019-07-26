# invalid Change-Id line format in commit message footer

如果 commit-msg 底部的 Change-Id 格式有误，那么推送 commit 生成 change 的时候，会报此错误。

可以通过 [git log](http://www.kernel.org/pub/software/scm/git/docs/git-log.html) 查看 commit-msg 信息。

[commit hook](cmd-hook-commit-msg.md) 会自动在 commit-msg 的底部生成 change-id。

## SEE ALSO

* [change-id](user-changeid.md)


