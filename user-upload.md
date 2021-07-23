# Gerrit Code Review - Uploading Changes

Gerrit 支持 3 种方法 upload change:

* `repo upload`, 创建 change，走评审流程
* `git push`, 创建 change，走评审流程
* `git push`, 不走评审流程，直接合入代码库

上面 3 种方法都需要用户和 Gerrrit 进行认证。

Gerrit 使用下面协议可以 upload change： SSH 和 HTTP/HTTPS。协议需要管理员在服务器端进行配置。

## HTTP/HTTPS

Gerrit 安装后，如果没有配置支持 SSH 认证，那么用户必须通过 HTTP/HTTPS 认证。

用户认证使用的是 `BasicAuth` , 依赖于 `auth.gitBasicAuthPolicy` 的值，认证通过以下几种方式验证：

* 如果是 `HTTP`，那么需要在用户 `settings` 页面点击 `HTTP Credentials` ，产生随机密码。
* 如果是 `LDAP` ，那么使用 LDAP 密码
* 如果是 `HTTP_LDAP`, 那么可以使用上面两种认证方式。

如果 `gitBasicAuthPolicy` 设置为 `LDAP` 或 `HTTP_LDAP`，并且用户使用 LDAP 的用户名密码认证，那么 git 客户端需要将 `http.cookieFile` 配置相应的本地文件，否则在进行认证的时候会频繁的连接服务器并增加服务器的负载。

当配置 HTTP 认证时，再次点击 `HTTP Credentials` 后，会重新产生密码，原先的密码会失效。

如果配置文件配置了 `HTTP password URL`，参考 [系统配置](config-gerrit.md) 的 httpPasswordUrl 部分，那么需要用户点击 `Obtain Password` 来获取密码；如果没有配置此 URL ，那么点击`Generate Password` 来获取密码。

## SSH

如果通过 SSH 协议 upload change，Gerrit 支持两种形式：publickey 和 kerberos 。

### Public keys

为了向 Gerrit 上添加一个新的 SSH key, 可以将 `id_rsa.pub` 或 `id_dsa.pub` 文件内容贴到文本框中，然后点击 `add` 按钮。Gerrit 目前只支持 SSH version 2 的 public keys。key 支持 OpenSSH 格式(文件以 `ssh-rsa` 或 `ssh-dss` 开头) 和 RFC 4716 格式(文件以 `---- BEGIN SSH2 PUBLIC KEY ----` 开头)。

通常，SSH keys 存储在用户的 `~/.ssh` 目录下。可以用下面命令生成 SSH keys ：

```shell
  ssh-keygen -t rsa
```

此时可以用下面命令复制文件内容，然后贴到 Gerrit 上面。

```shell
  cat ~/.ssh/id_rsa.pub
```

**NOTE:**
*如果用户配置了 `passphrase` 并且频繁 upload changes 的时候，可以考虑使用 `ssh-agent`, 这样可以避免每次输入 `passphrase`。*

### Kerberos

kerberos-enabled 服务器在 SSO 环境中可以不做其他的配置。

SSH 客户端需要开启 kerberos 认证。对于 OpenSSH ，参数 `GSSAPIAuthentication` 需要设置为 `yes`。

一些 Linux 系统 (Debian, Ubuntu) 的默认设置为 `yes`，如果不是这个设置，需要在本地手动修改，参考如下：

```
  Host gerrit.mydomain.tld
      GSSAPIAuthentication yes
```

### Testing Connections

客户端可以使用命令行验证配置的 SSH 认证是否可用，默认情况下，gerrit 的 SSHD 端口号是 29418 ，验证操作如下：
```
  $ ssh -p 29418 sshusername@hostname

    ****    Welcome to Gerrit Code Review    ****

    Hi John Doe, you have successfully connected over SSH.

    Unfortunately, interactive shells are disabled.
    To clone a hosted Git repository, use:

    git clone ssh://sshusername@hostname:29418/REPOSITORY_NAME.git

  Connection to hostname closed.
```

上面的命令中，`sshusername` 是 `Settings` 页面的 `Profile` 标签页中的 `Username` 。

可以通过网页来获取 Gerrit 配置的 SSHD 端口号，访问链接 `http://'hostname'/ssh_info`, 页面会显示端口号。或者使用如下命令来获取：

```
  $ curl http://hostname/ssh_info
  hostname 29418
```

执行命令后，如果返回值是 `NOT_AVAILABLE` ，那么说明服务器出现了问题。

### OpenSSH Host entry

如果频繁的向同一个 Gerrit 服务器 upload change，那么可以考虑在配置文件 `~/.ssh/config` 中添加 SSH `Host` 信息。相当于 alias 一条命令，这样可以方便一些，如下：

```
  $ cat ~/.ssh/config
  ...
  Host mygerrit
      Hostname git.example.com
      Port 29418
      User john.doe

  $ git clone mygerrit:myproject

  $ ssh mygerrit gerrit version

  $ scp -p mygerrit:hooks/commit-msg .git/hooks/
```

## git push

### Create Changes

可以用命令行创建新的 change ，格式如下：

```shell
  git push ssh://sshusername@hostname:29418/projectname HEAD:refs/for/branch
```

例如 `john.doe` 使用 git push 命令 upload change ，分支 `experimental` ，project `kernel/common`, Gerrit 服务器 `git.example.com` 

```shell
  git push ssh://john.doe@git.example.com:29418/kernel/common HEAD:refs/for/experimental
```

`git push` 会使新的 commit 在 gerrit 服务器上生成新的 change 。注意：分支 `refs/for/experimental` 在 gerrit 服务器上并不存在。

如果用户配置了邮件提醒，那么用户会收到通知邮件。

### Push Options

push 的时候可以添加一些参数，参考如下。

#### Email Notifications

`notify` 邮件提醒参数:

* `NONE`: 不发送通知邮件
* `OWNER`: 只给 change owner 发送通知
* `OWNER_REVIEWERS`: 只给 owner 和 评审列表中的人员发送。
* `ALL`: 给 change 的相关人员发送邮件，如：watcher，starred，CCs，committer，author 等。

参数默认配置为 `ALL`。

```
  git push ssh://bot@git.example.com:29418/kernel/common HEAD:refs/for/master%notify=NONE
```

同样，也可以给具体的人员发送通知邮件，格式参考如下：`notify-to='email'`, `notify-cc='email'` 或 `notify-bcc='email'` 。系统会自动将用户过滤，每次确保用户会收到一封邮件而不是多封邮件。参数中添加的人员，只是临时收到通知邮件，不是 change 的所有更新都会收到通知邮件。

```shell
  git push ssh://bot@git.example.com:29418/kernel/common HEAD:refs/for/master%notify=NONE,notify-to=a@a.com
```

#### Topic

topic 在逻辑上把相关的 change 集合到了一起，push 命令中需要加参数 `-o`，例如 topic 名称是 'driver/i42' ：

```
  git push ssh://john.doe@git.example.com:29418/kernel/common HEAD:refs/for/experimental%topic=driver/i42

  // this is the same as:
  git push ssh://john.doe@git.example.com:29418/kernel/common HEAD:refs/for/experimental -o topic=driver/i42
```

#### Hashtag

hashtag 在逻辑上把相关的 change 集合到了一起，push 命令中需要加参数 `hashtag` 或 `t` 。
```
  // these are all equivalent
  git push ssh://john.doe@git.example.com:29418/kernel/common HEAD:refs/for/experimental%hashtag=stable-fix
  git push ssh://john.doe@git.example.com:29418/kernel/common HEAD:refs/for/experimental%t=stable-fix
  git push ssh://john.doe@git.example.com:29418/kernel/common HEAD:refs/for/experimental -o hashtag=stable-fix
  git push ssh://john.doe@git.example.com:29418/kernel/common HEAD:refs/for/experimental -o t=stable-fix
```

#### Private Changes

如果要生成或者变成 private change ，需要加参数 `private`

```shell
  git push ssh://john.doe@git.example.com:29418/kernel/common HEAD:refs/for/master%private
```

忽略 `private` 参数并不会将 private change 移除 private 属性， 如果要移除 private 属性，需要加参数 `remove-private` :

```shell
  git push ssh://john.doe@git.example.com:29418/kernel/common HEAD:refs/for/master%remove-private
```

#### Work-In-Progress Changes

如果要生成或者变成 `work-in-progress` (`wip`) ，需要加参数 `wip`

```shell
  git push ssh://john.doe@git.example.com:29418/kernel/common HEAD:refs/for/master%wip
```

忽略 `wip` 参数并不会将 private change 移除 wip 属性， 如果要移除 wip 属性，需要加参数 `ready` :

```shell
  git push ssh://john.doe@git.example.com:29418/kernel/common HEAD:refs/for/master%ready
```

只有 change owner, project owner 和管理员可以添加参数 `work-in-progress` 和 `ready` 。

用户可以在 web 上配置此参数的默认值，点击 `用户名` -> `Settings` -> `Preferences`，然后可以配置新 change 的 `work-in-progress` 的默认值。

#### Patch Set Description

`patch set description` 可以通过参数 `message` (`m`) 来添加，如：

```shell
  git push ssh://john.doe@git.example.com:29418/kernel/common HEAD:refs/for/experimental%m=This_is_a_rebase_on_master%21
```

**NOTE:**
*git push refs 的时候，参数值不允许有空格，可以使用 '_' 或 '+' 字符来代替空格；`ascii 的 16 进制的数值` 可以表示其他的特殊字符。上面例子的参数值是：`This is a rebase on master!` 。*

为了避免 git ref 产生混淆，下面的字符要用 `ascii 的 16 进制的数值` 进行表示：" %^@.~-+_:/!"。有些特殊字符，如取反字符(~)在路径中不会被转义，从安全角度来说，建议非数字非字符的字符要用`ascii 的 16 进制的数值` 进行表示。

#### Publish Draft Comments

`publish-comments` 参数可以将 draft-comment 发布。

```shell
  git push ssh://john.doe@git.example.com:29418/kernel/common HEAD:refs/for/experimental%publish-comments
```

用户可以在 web 上配置 `Publish comments on push` 的默认值，点击 `用户名` -> `Settings` -> `Preferences`。

#### Review Labels

`label` (`l`) 参数用于打分。

```shell
  git push ssh://john.doe@git.example.com:29418/kernel/common HEAD:refs/for/experimental%l=Verified+1
```

`l='label[score]'` 参数可以给多个打分项打分。

```shell
  git push ssh://john.doe@git.example.com:29418/kernel/common HEAD:refs/for/experimental%l=Code-Review+1,l=Verified+1
```

参数值是可选的，如果不填写参数值，那么默认值是 +1 。

#### Change Edits

`edit` (`e`) 参数用于 edit change。

```shell
  git push ssh://john.doe@git.example.com:29418/kernel/common HEAD:refs/for/master%edit
```

对已存在的 change 才可以使用此参数。

**NOTE:**
*如果有 edit 状态的 change ，那么使用此参数后，服务器端的 edit 状态的 change 会被更新。*

#### Reviewers

`reviewer` (`r`) 和 `cc` 参数用于添加评审人员。

```shell
  git push ssh://john.doe@git.example.com:29418/kernel/common HEAD:refs/for/experimental%r=a@a.com,cc=b@o.com
```

`r='email'` 和 `cc='email'` 参数可以多次添加，系统发通知邮件的时候会自动去重。

如果经常往同一个分支推送评审，并且 change 的评审人员比较固定，那么可以参考下面的配置及操作，使 push 更加便利。

```
  $ cat .git/config
  ...
  [remote "exp"]
    url = ssh://john.doe@git.example.com:29418/kernel/common
    push = HEAD:refs/for/experimental%r=a@a.com,cc=b@o.com

  $ git push exp
```

#### Trace

`trace=<trace-id>` 参数用于跟踪定位。trace-id 建议给出具体的值。

```
  git push -o trace=issue/123 ssh://john.doe@git.example.com:29418/kernel/common HEAD:refs/for/master
```

如果没有明确 trace-id 值，那么系统会随机产生一个值。例如：

```
  git push -o trace ssh://john.doe@git.example.com:29418/kernel/common HEAD:refs/for/master
```

启动 trace 后，相关的调试信息会写入到 `error_log`，并有 trace-id 作为标识。下面是命令行返回的 trace-id： 

```
  remote: TRACE_ID: 1534174322774-7edf2a7b
```

明确 trace-id 后，分析定位问题会更加容易。

### Replace Changes

如果要给 change 生成新的 patch-set，那么 commit-msg 中要有 change-id 的信息。系统会根据 change-id 将 commit 匹配到对应的 change 中。

commit-msg 中的 Change-Id 如果与 change 中的不一致，本地可以使用 amend 命令，然后修改 Change-Id 。

关于 Change-Id 更多的描述，可以参考  [changeid](user-changeid.md) 章节。

### Bypass Review

Change 可以不经过评审，直接 push 到代码库。这个操作可以创建分支，打标签，或 force-update 分支的历史记录。

Gerrit 限制直接 push 到代码库的原因：

* `refs/heads/*`: 可以更新，创建，删除分支；或者重写分支的历史记录
* `refs/tags/*`: 创建标签

push 分支，需要配置权限。

* Update: 分支可以以 fast-forwarded 方式进行更新，这是一个安全的方式。但不能创建分支。
* Create: 创建新的分支，新名称不能和已有的分支名称重复。但不能更新分支。
* Delete: 删除分支。force-update 进行的是先删除再创建的操作。

`Create Annotated Tag` 配置的权限是 push annotated tags 。

Project-owner 有可能在发布新版本的时候进行打标签，因此需要 `Create Annotated Tag` 权限。

### Skip Validation

即使用户有直接 push 到代码库的权限，默认情况下 Gerrit 的 plugin：validation 也会校验每一个新的提交，如：author/committer。可以参考 [校验](config-validation.md)。如果要忽略校验，可以添加参数 `skip-validation `。

```
git push -o skip-validation HEAD:master
```

使用 `skip-validation` 参数需要配置额外的权限。另外，下面的权限可以忽略 commit 的校验。 

* `Forge Author`，参考 [访问控制](access-control.md) forge_author 部分
* `Forge Committer`，参考 [访问控制](access-control.md) forge_committer 部分
* `Forge Server`，参考 [访问控制](access-control.md) forge_server 部分
* `Push Merge Commits`，参考 [访问控制](access-control.md) push_merge 部分

另外，project 配置需要注意：

* Project 不要配置 `require Signed-off-by` 权限。可参考 [Project 配置](project-configuration.md) 的 signed-off 部分。
* Project 不要配置 `refs/meta/reject-commits` 权限。

此参数只有在直接 push 的时候使用。有的时候在生成新 change 之前进行校验，此类型的校验不可跳过。

当直接 push [多个 commit](error-too-many-commits.md) 的时候，需要添加 `skip-validation` 参数。例如：当 push 多个 commit 的时候，有可能对 commit-msg 校验不过，需要重写 commit-msg ，这时 `skip-validation` 参数可以避免这种情况。


### Auto-Merge during Push

直接 push 的时候，可使 change 直接合入到代码库。当 commit 不想走评审流程，并且向把 commit 在系统中做个记录，这时可以使用这种方法。push 的时候添加参数 `%submit` ，再生成 change 后，系统会自动将 change 合入到代码库。参考如下：

```shell
  git push ssh://john.doe@git.example.com:29418/kernel/common HEAD:refs/for/master%submit
```

auto-merge 的情况下，submit-rules 不进行校验。如果 change 在合入的时候失败了，那么 change 会处于 open 状态，上传新 patch-set 的时候，可以添加 `%submit` 参数。

不过需要 push 人员有分支 `refs/for/<ref>` (如：refs/for/refs/heads/master) `Submit` 权限。`refs/for/<ref>` 分支与  `refs/heads/<ref>` 分支的 `Submit` 权限是不一样的。

### Selecting Merge Base

默认情况下，新的 commit 会生成新的 change，用户可以通过 `%base` 参数改变 merge base SHA-1 的节点。 

```shell
  git push ssh://john.doe@git.example.com:29418/kernel/common HEAD:refs/for/master%base=$(git rev-parse origin/master)
```

push merge 节点的时候可以添加多个 `%base` 参数，字符 `%` 只能出现一次，并且只能在第一个参数前面出现。

```shell
  git push ssh://john.doe@git.example.com:29418/kernel/common HEAD:refs/for/master%base=commit-id1,base=commit-id2
```

### Creating Changes for Merged Commits

通常, change 创建的时候，commit 并没有合入到目的分支。但在某些情况下，需要评审已经合入到目的分支的节点。让 merge 节点生成 change 需要添加参数 `%merged`:

```shell
  git push ssh://john.doe@git.example.com:29418/kernel/common my-merged-commit:refs/for/master%merged
```

上面的命令可以为 merge 节点（`my-merged-commit`）创建一个 change，这样不会创建出计划外的新 change。如果要创建多个新 change，建议 push 多次。


## repo upload

[repo](http://source.android.com/source/using-repo.html) 是一个管理多个 repository 的工具， 在 Android 项目中广泛使用。

### Create Changes

可以使用 `repo` 命令进行 upload change, 不过要确保 manifest.xml 文件配置正确。upload change 的过程中，`repo` 命令会调用 `http://'reviewhostname'/ssh_info` 来获取 SSHD 端口。

`repo upload` 会把新的 commit 上传到服务器并生成 change，然后相关人员会收到通知邮件，同样也可以在命令行中添加邮件提醒。

`repo upload` 更多操作，可参考 `repo help upload`.

### Replace Changes

`repo upload` 同样可以更新 patch-set，不过要确保 commit 中的 Change-Id 与 change中的 Change-Id 保持一致。

如果 Change-Id 不一致，可以使用 amend 命令进行修改。

关于 Change-Id 更多的描述，可以参考 [changeid](user-changeid.md) 章节。


## Gritty Details

Gerrit 维护了服务器上所有的 project 的更新。

Gerrit 可以通过权限对 project 层级做访问控制，这样可以避免信息泄漏。

Gerrit 与客户端协商后，才会进行数据传输，如果协商没有完成，那么是不会传输数据的。

