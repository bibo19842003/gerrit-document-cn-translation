# Gerrit Code Review - Command Line Tools

## Client

可以使用 scp, wget, curl 命令从 Gerrit 服务器下载文件。

```
$ scp -p -P 29418 john.doe@review.example.com:bin/gerrit-cherry-pick ~/bin/
$ scp -p -P 29418 john.doe@review.example.com:hooks/commit-msg .git/hooks/

$ curl -Lo ~/bin/gerrit-cherry-pick http://review.example.com/tools/bin/gerrit-cherry-pick
$ curl -Lo .git/hooks/commit-msg http://review.example.com/tools/hooks/commit-msg
```

### Commands

**[gerrit-cherry-pick](cmd-cherry-pick.md)**
	下载及 cherry-pick change (commit)。

### Hooks

用户可以从 Gerrit 下载 hook 到本地的 Git repository 里面。

**[commit-msg](cmd-hook-commit-msg.md)**
	用于在 commit-msg 中自动生成 `Change-Id` 。

## Server

Gerrit 没有提供一个内部交互的 shell，可以通过客户端执行一些命令来和 Gerrit 服务器进行交互：

```
  $ ssh -p 29418 review.example.com gerrit ls-projects
```

### User Commands

**[gerrit apropos](cmd-apropos.md)**
	搜索 Gerrit 的文档的索引

**[gerrit ban-commit](cmd-ban-commit.md)**
	禁止 commit 的合入

**[gerrit create-branch](cmd-create-branch.md)**
	创建分支

**[gerrit ls-groups](cmd-ls-groups.md)**
	列出用户可以看到的群组

**[gerrit ls-members](cmd-ls-members.md)**
	列出用户可见群组的成员

**[gerrit ls-projects](cmd-ls-projects.md)**
	列出用户可以看到的 project

**[gerrit query](cmd-query.md)**
	从 index 中搜索 change

**gerrit receive-pack**
	已废弃，请参考 `git receive-pack`

**[gerrit rename-group](cmd-rename-group.md)**
	群组更名

**[gerrit review](cmd-review.md)**
	命令行评审 change

**[gerrit set-head](cmd-set-head.md)**
	修改 project 的默认 HEAD

**[gerrit set-project](cmd-set-project.md)**
	修改 project 的设置

**[gerrit set-project-parent](cmd-set-project-parent.md)**
	修改 project 的继承关系

**[gerrit set-reviewers](cmd-set-reviewers.md)**
	添加或移除评审人员

**[gerrit set-topic](cmd-set-topic.md)**
	设置 change 的 topic

**[gerrit stream-events](cmd-stream-events.md)**
	实时监听事件

**[gerrit version](cmd-version.md)**
	显示 gerrit 版本号

**[git receive-pack](cmd-receive-pack.md)**
	git 服务器端的命令，与客户端命令 `git push` 对应。

**git upload-pack**
	git 服务器端的命令，与客户端命令 `git fetch` 对应。

### Administrator Commands

**[gerrit close-connection](cmd-close-connection.md)**
	关闭具体的 SSH 链接

**[gerrit convert-ref-storage](cmd-convert-ref-storage.md)**
	将 ref storage 转换为 reftable (目前为试验阶段)

**[gerrit create-account](cmd-create-account.md)**
	创建用户

**[gerrit create-group](cmd-create-group.md)**
	创建用户群组

**[gerrit create-project](cmd-create-project.md)**
	创建 project

**[gerrit flush-caches](cmd-flush-caches.md)**
	刷新内存中缓存

**[gerrit gc](cmd-gc.md)**
	对 project 执行 gc

**[gerrit index activate](cmd-index-activate.md)**
	启用最新版本的索引

**[gerrit index start](cmd-index-start.md)**
	在线执行索引操作

**[gerrit index changes](cmd-index-changes.md)**
	对 change 执行索引操作

**[gerrit index changes-in-project](cmd-index-changes-in-project.md)**
	对 project 中的所有 change 执行索引操作

**[gerrit logging ls-level](cmd-logging-ls-level.md)**
	显示 log 的级别

**[gerrit logging set-level](cmd-logging-set-level.md)**
	设置 log 的级别

**[gerrit ls-user-refs](cmd-ls-user-refs.md)**
	显示用户可以访问的 refs

**[gerrit plugin add](cmd-plugin-install.md)**
	命令 'gerrit plugin install' 简写

**[gerrit plugin enable](cmd-plugin-enable.md)**
	启用 plugin

**[gerrit plugin install](cmd-plugin-install.md)**
	安装 plugin

**[gerrit plugin ls](cmd-plugin-ls.md)**
	显示已安装的 plugin

**[gerrit plugin reload](cmd-plugin-reload.md)**
	重载 plugin

**[gerrit plugin remove](cmd-plugin-remove.md)**
	禁用 plugin

**[gerrit plugin rm](cmd-plugin-remove.md)**
	命令 'gerrit plugin remove' 简写

**[gerrit reload-config](cmd-reload-config.md)**
	重载 gerrit.config

**[gerrit set-account](cmd-set-account.md)**
	更改用户的设置
**[gerrit sequence set](cmd-sequence-set.md)**
	设置新的 sequence 值

**[gerrit sequence show](cmd-sequence-show.md)**
	显示当前的 sequence 值

**[gerrit set-members](cmd-set-members.md)**
	设置群组成员

**[gerrit show-caches](cmd-show-caches.md)**
	显示当前缓存的信息

**[gerrit show-connections](cmd-show-connections.md)**
	显示与服务器链接的客户端的 SSH 链接

**[gerrit show-queue](cmd-show-queue.md)**
	显示后台的任务队列信息，包括 replication 信息。

**[gerrit test-submit rule](cmd-test-submit-rule.md)**
	测试 prolog submit 是否可用

**[gerrit test-submit type](cmd-test-submit-type.md)**
	测试 prolog submit 类型

**[kill](cmd-kill.md)**
	取消或放弃指定的后台任务

**[ps](cmd-show-queue.md)**
	命令 'gerrit show-queue' 的简写

**[suexec](cmd-suexec.md)**
	执行指定用户有权限执行的命令

### Trace

通过参数 `--trace` 和 `--trace-id <trace-id>` 来启动对 SSH 命令执行动作的跟踪，推荐使用参数 `--trace-id <trace-id>`。

```
  $ ssh -p 29418 review.example.com gerrit create-project --trace --trace-id issue/123 foo/bar
```

如果忽略 `--trace-id <trace-id>` 参数，系统会自动分发一个 trace-id 。

```
  $ ssh -p 29418 review.example.com gerrit create-project --trace foo/bar
```

启用 trace 后， `error_log` 中会有 `trace-id` 的标识。与执行命令相关的 log 都会用 `trace-id` 进行标识。系统自动分发的标识如下：

```
  TRACE_ID: 1534174322774-7edf2a7b
```

如果指定 `trace-id` ，那么查询 log 会方便一些。

