# invalid author

向 gerrit 推送 commit 的时候，gerrit 会校验 commit 的 author 及 email 是否在系统中存在，如果不存在，会返回报错信息："invalid author"。如果不做校验，可以在系统中对 'Forge Author' 进行设置。

报错主要是两方面原因：

 * commit 的 author 或 email 没有在系统中注册
 * commit 的 author 没有 'Forge Author' 权限

## Incorrect configuration of the e-mail address on client or server side

commit 的 author 或 email 没有在系统中注册

### Configuration of e-mail address in Gerrit

Gerrit 页面 'Settings -> Identities' 可以检查 email；'Settings -> Contact Information' 可以注册新的邮箱。

### Incorrect author information

每个 commit 中都会包含 author 信息，可以使用 git 命令查看 'user.name' 和 'user.email'。

```
  $ git config -l
  ...
  user.name=John Doe
  user.email=john.doe@example.com
  ...
```

git commit 的时候会调用 git 配置文件中的信息来生成 author 相关的信息，如："John Doe <john.doe@example.com>" 为 author 相关信息。

可以使用 git 命令查看历史的 commit 信息。

```
  $ git log
  commit cbe31bdba7d14963eb42f7e1e0eef1fe58698c05
  Author: John Doe <john.doe@example.com>
  Date:   Mon Dec 20 15:36:33 2010 +0100

      my commit

```

可以使用 `git config` 命令配置帐号信息，如下：

```
  $ git config user.name "John Doe"
  $
  $ git config user.email john.doe@example.com
  $
```

git commit 的时候，可以使用 `--amend` 参数来更新 commit 的 author 信息：

```
  $ git commit --amend --author "John Doe <john.doe@example.com>"
```

如果要更新多个 commit 中的 author 信息，那么操作有些复杂。这个时候需要使用 git rebase 的交互式操作来完成，操作时，要选 `edit` ，然后再 `amend` 进行修改。

下面是修改最近 3 个 commit 的 author 的例子:

```
  $ git rebase -i HEAD~3

  edit 51f0d47 one commit
  edit 7299690 another commit
  edit 304ad96 one more commit

  Stopped at 51f0d47... one commit
  You can amend the commit now, with

          git commit --amend

  Once you are satisfied with your changes, run

          git rebase --continue

  $ git commit --amend --author "John Doe <john.doe@example.com>"
  [detached HEAD baea1e4] one commit
   Author: John Doe <john.doe@example.com>
   1 files changed, 4 insertions(+), 1 deletions(-)

  $ git rebase --continue

  ...
```

可以根据 [Git documentation](http://www.kernel.org/pub/software/scm/git/docs/git-rebase.html) 了解更多 rebase 操作。


## Missing privileges to push commits of other users

commit 的 author 没有 'Forge Author' 权限。

