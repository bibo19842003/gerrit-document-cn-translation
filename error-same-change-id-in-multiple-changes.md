# same Change-Id in multiple changes

向 gerrit 推送 commit 的时候，如果本地新 commit 之间或者新 commit 与历史记录中的 commit 的 change-id 有重复的话，会报此错误。

## Example

下面是一个例子说明。最近两个 commit ，有相同的 change-id。

```
  $ git log
  commit 13d381265ffff88088e1af88d0e2c2c1143743cd
  Author: John Doe <john.doe@example.com>
  Date:   Thu Dec 16 10:15:48 2010 +0100

      another commit

      Change-Id: I93478acac09965af91f03c82e55346214811ac79

  commit ca45e125145b12fe9681864b123bc9daea501bf7
  Author: John Doe <john.doe@example.com>
  Date:   Thu Dec 16 10:12:54 2010 +0100

      one commit

      Change-Id: I93478acac09965af91f03c82e55346214811ac79

  $ git push ssh://JohnDoe@host:29418/myProject HEAD:refs/for/master
  Counting objects: 8, done.
  Delta compression using up to 2 threads.
  Compressing objects: 100% (2/2), done.
  Writing objects: 100% (6/6), 558 bytes, done.
  Total 6 (delta 0), reused 0 (delta 0)
  To ssh://JohnDoe@host:29418/myProject
  ! [remote rejected] HEAD -> refs/for/master (same Change-Id in multiple changes.
  Squash the commits with the same Change-Id or ensure Change-Ids are unique for each commit)
  error: failed to push some refs to 'ssh://JohnDoe@host:29418/myProject'

```

如果这两个 commit 要更新一个 change 的修改，那么可以 squash 的方式来解决。squash 后，再推向 gerrit。

可以通过 `git rebase -i` 方式来 squash commit，操作如下。

```
  $ git rebase -i HEAD~2

  pick ca45e12 one commit
  squash 13d3812 another commit

  [detached HEAD ab37207] squashed commit
   1 files changed, 3 insertions(+), 0 deletions(-)
  Successfully rebased and updated refs/heads/master.

  $ git log
  commit ab37207d33647685801dba36cb4fd51f3eb73507
  Author: John Doe <john.doe@example.com>
  Date:   Thu Dec 16 10:12:54 2010 +0100

      squashed commit

      Change-Id: I93478acac09965af91f03c82e55346214811ac79

  $ git push ssh://JohnDoe@host:29418/myProject HEAD:refs/for/master
  Counting objects: 5, done.
  Writing objects: 100% (3/3), 307 bytes, done.
  Total 3 (delta 0), reused 0 (delta 0)
  To ssh://JohnDoe@host:29418/myProject
   * [new branch]      HEAD -> refs/for/master
```

如果要为服务器上的两个 change 更新 patch-set，那么要保证 commit-msg 中的 change-id 与 change 中的 change-id 保持一致。


