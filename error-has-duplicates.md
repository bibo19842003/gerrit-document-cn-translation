# ... has duplicates

gerrit 系统中，同一个 project 的 同一个分支上的 change-id 不能重复。如果报此错误，说明含有此 change-id 的 commit 已经合入到此 project 的这个分支上了。

如果要将 commit 推送到 gerrit 上，可以修改此 commit 的 message 信息。

