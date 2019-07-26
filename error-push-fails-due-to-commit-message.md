# Push fails due to commit message

有时是 commit-msg 的原因导致推送失败。

如果是最后一个 commit 的 message 有问题的话，可以使用下面的命令进行修改：

```
  $ git commit --amend
```

如果是多个 commit 的 message 需要修改的话，需要使用 git rebase 的交互方式来进行处理。

有时，commit-hook 会自动向 commit-msg 中插入或更新信息。如果信息在已存在的 commit 中缺失，重新 commit 的话会重新执行 commit-hook，这样信息就会更新进去了。使用 git rebase 的交互方式来进行处理的时候，要确认 commit 被重新生成。


