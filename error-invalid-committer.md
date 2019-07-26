# invalid committer

向 gerrit 推送 commit 的时候，gerrit 会校验 commit 的 user 及 email 是否在系统中存在，如果不存在，会返回报错信息："invalid Committer"。如果不做校验，可以在系统中对 'Forge Committer' 进行设置。

报错主要是两方面原因：

 * commit 的 committer 或 email 没有在系统中注册
 * commit 的 committer 没有 'Forge Author' 权限

## Incorrect configuration of the e-mail address on client or server side

commit 的 committer 或 email 没有在系统中注册

### Configuration of e-mail address in Gerrit

Gerrit 页面 'Settings -> Identities' 可以检查 email；'Settings -> Contact Information' 可以注册新的邮箱。

### Incorrect committer information

每个 commit 中都会包含 committer 信息，可以使用 git 命令查看 'user.name' 和 'user.email'。

```
  $ git config -l
  ...
  user.name=John Doe
  user.email=john.doe@example.com
  ...
```

git commit 的时候会调用 git 配置文件中的信息来生成 committer 相关的信息，如："John Doe <john.doe@example.com>" 为 committer 相关信息。

可以使用 git 命令查看历史的 commit 信息, "git log --format=full":

```
  $ git log --format=full
  commit cbe31bdba7d14963eb42f7e1e0eef1fe58698c05
  Author: John Doe <john.doe@example.com>
  Commit: John Doe <john.doe@example.com>

      my commit

```

可以使用 `git config` 命令配置帐号信息，如下：

```
  $ git config user.name "John Doe"
  $
  $ git config user.email john.doe@example.com
  $
```

git commit 的时候，可以使用 `--amend` 参数来更新 commit 的 committer 信息。

可以根据 [Git documentation](http://www.kernel.org/pub/software/scm/git/docs/git-rebase.html) 了解更多 rebase 操作。

## Missing privileges to push commits that were committed by other users

commit 的 committer 没有 'Forge Committer' 权限。

