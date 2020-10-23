# Gerrit Code Review - Email Notifications

## 说明

当 change 有更新的时候，Gerrit 会自动给相关用户发邮件。

## User Level Settings

用户可以在 watched project 中配置邮件订阅，操作如下：Settings > Watched Projects 

需要明确 Watched Projects 。如果 project 对用户可见，那么用户可以 watch 。

[changes 搜索的表达式](user-search.md) 可以进行过滤，如：`branch:master` 可以搜索到 master 分支上的相关信息。如果过滤条件设置在 `All-Projects` 层级，那么其他的 project 会继承。

对于新的 change 或 patch-set ，不会给 change 的 owner 发通知邮件。

如果在 `user preferences` 设置中启动了 `Every comment` ，那么系统会给 change 添加评论的用户发送通知邮件。

## Project Level Settings

Project-owner 和管理员可以配置 project 层级的通知邮件。通知邮件的配置存储在 project 的 `refs/meta/config` 分支中的 `project.config` 文件。

`refs/meta/config` 分支的权限需要单独配置，具体可以参考 [访问控制](access-control.md)。

本地初始化 git 仓及编辑配置文件：
```shell
  mkdir cfg_dir
  cd cfg_dir
  git init
```

从 Gerrit 下载配置文件：
```shell
  git fetch ssh://localhost:29418/project refs/meta/config
  git checkout FETCH_HEAD
```

可以使用命令 `git config` 向文件 `project.config` 添加邮箱地址：
```
  git config -f project.config --add notify.team.email team-address@example.com
  git config -f project.config --add notify.team.email paranoid-manager@example.com
```

查看文件 `project.config` 的 `notify` 部分：
```shell
  [notify "team"]
  	email = team-address@example.com
  	email = paranoid-manager@example.com
```

每个 `notify` 部分的名字在 `project.config` 文件中要唯一。此名字不会做任何匹配，不过可以在 gerrit 页面上进行搜索使用。

本地 commit 后，push 到 Gerrit：
```shell
  git commit -a -m "Notify team-address@example.com of changes"
  git push ssh://localhost:29418/project HEAD:refs/meta/config
```

**notify.<name>.email**

 邮箱列表，每行配置一个邮箱。

 Gerrit 上的内部群组的命名格式：`group NAME` 。如果用 UUID 标识群组名称，那么要和 `groups` 文件中的 UUID 保持一致。

**notify.<name>.type**

 邮件通知的类型，如果不配置，那么默认所有类型都会发送邮件。

 * `new_changes`: 新建 change
 * `new_patchsets`: 新的 patch-set
 * `all_comments`: change 的新评论
 * `submitted_changes`: change 被 submit
 * `abandoned_changes`: change 被 abandon
 * `all`: 所有通知类型

 和上面配置邮箱类似，每种类型配置一行。

**notify.<name>.header**

 邮件头部显示接收人的方式。`BCC` 方式为默认配置。每个 notify 中，只能配置一种方式，不能配置多种方式。

* `to`: 主送。地址所有人可见。
* `cc`: 抄送。地址所有人可见。
* `bcc`: 密送。隐藏地址。

**notify.<name>.filter**

  [changes 搜索表达式](user-search.md) 可以用在此处作为 change 邮件通知的过滤。格式为：Git-style ，字符如果需要转义，那么需要加双引号，如：`filter = branch:\"^(maint|stable)-.*\"`。单引号是非法的，会被忽略。

 如果 notify 模块处只有 email 地址，系统会忽略读权限控制并认为当前的过滤条件是正确的。project-owner 可以添加过滤条件，如：`visibleto:groupname` 
```shell
  [notify "Developers"]
  	email = team-address@example.com
  	filter = visibleto:Developers
```

 如果收件群组是一个内部群组，那么系统会自动校验这个内部群组，因此，不用添加过滤条件： `visibleto:` 。

## Email Footers

change 的通知邮件包含了 change 的一些元数据，元数据在邮件的页脚处。对于 HTML emails 来说，页脚是隐藏的，不过可以通过 HTML 的源信息进行查看。

用户可以在邮件的页脚使用过滤条件或规则，例如：Gmail 可以使用下面的格式过滤评审人员：

```shell
  "Gerrit-Reviewer: Your Name <your.email@example.com>"
```

**Gerrit-MessageType**

 change 的状态类型，如下：

 * abandon
 * comment
 * deleteReviewer
 * deleteVote
 * merged
 * newchange
 * newpatchset
 * restore
 * revert
 * setassignee

**Gerrit-Change-Id**

 change-id，如：`I3443af49fcdc16ca941ee7cf2b5e33c1106f3b1d`

**Gerrit-Change-Number**

 change 号，如：`92191`

**Gerrit-PatchSet**

 patch-set 号，如：`7`

**Gerrit-Owner**

 change 的 owner ，如：`Owner Name <owner@example.com>`

**Gerrit-Reviewer**

 change 的评审人员列表，如：

```
  Gerrit-Reviewer: Reviewer One <one@example.com>
  Gerrit-Reviewer: Reviewer Two <two@example.com>
```

**Gerrit-CC**

 change 的 CC 人员列表，如：
```
  Gerrit-CC: User One <one@example.com>
  Gerrit-CC: User Two <two@example.com>
```

**Gerrit-Project**

 change 所在的 project 名称

**Gerrit-Branch**

 change 合入到的目标分支名称

**Gerrit-Comment-Date**

 发布评论的日期

**Gerrit-HasComments**

 是否进行了评论，如： `Gerrit-HasComments: Yes`

**Gerrit-HasLabels**

 是否进行了打分，如： `Gerrit-HasLabels: No`

**Gerrit-Comment-In-Reply-To**

 是否对评论进行了回复，如：

```shell
  Gerrit-Comment-In-Reply-To: User Name <user@example.com>
```
