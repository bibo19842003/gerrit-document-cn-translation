# commit xxxxxxx: multiple Change-Id lines in message footer

原因是 commit-msg 底部有多条 Change-Id 信息。

可以通过 [git log](http://www.kernel.org/pub/software/scm/git/docs/git-log.html) 查看 commit-msg 信息。

如果要更新 change 中的 patch-set，可以在 commit-msg 中将已有的 chang-id 信息删除，然后把网页上的 change-id 拷贝过来。

如果要生成新的 change ，可以将多余的 change-id 删除，确保留下的 change-id 在 gerrit 服务器上没有出现过。

## SEE ALSO

* [change-id](user-changeid.md)


