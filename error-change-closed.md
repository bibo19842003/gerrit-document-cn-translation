# change ... closed

当向 gerrit 推送一个已关闭的 change 的时候，会报这个错误。

## When Pushing a Commit

当向 gerrit 推送一个已关闭的 change 的时候，会报这个错误。关闭的状态包括 submitted，merged，abandoned。

如果要上传一个已经合入状态的 patch-set，那么需要移除 commit-msg 中老的 change-id 信息，并填写一个新的 change-id。

如果要上传一个已经 abondan 状态的 patch-set，那么可以在网页上进行 restore 操作。

## When Submitting a Review Label

如果使用 [ssh 命令进行 review](cmd-review.md) 处于关闭状态的 change，同样也会报这个错误。

