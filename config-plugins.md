# Plugins

Gerrit 可以安装 plugin 来扩展功能。

## Plugin Installation

Plugin 安装比较容易，把 jar 文件放到 `$site_path/plugins/` 目录下就可以了。需要等一段时间，待服务器重新加载了，就可以使用了。

由于缓存的原因，安装 plugin 后，建议刷新一些客户端网页的缓存，这样就可以在网页中立刻看到安装的 plugin 了，否则要等待一段时间才可以看到。

Plugins 可以通过 [REST API](rest-api-plugins.md) 和 [SSH](cmd-plugin-install.md) 进行安装。

## Plugin Development

如何开发 plugin 可以参考 [Plugins 开发说明](dev-plugins.md)。

如果在 `Apache License 2.0` 协议下共享 plugin，可以把 plugin 的代码存放在 [gerrit-review](https://gerrit-review.googlesource.com)。可以给 [Gerrit mailing list](https://groups.google.com/forum/#!forum/repo-discuss) 发送邮件，请求在 `gerrit-review` 上面创建一个 project。请求人会成为新 project 的 owner，owner 可以根据 gerrit 的版本来创建对应的开发分支。

## Core Plugins

[Core plugins](dev-core-plugins.md) 默认打包在 Gerrit war 文件中，在 [初始化 Gerrit](pgm-init.md) 的时候进行安装。

需要说明的是，下面的文档及配置的链接都属于 plugin 的 master 分支。gerrit 不同的版本，使用的 plugin 的分支有可能不一样，请参考与 gerrit 对应的 plugin 分支。

### codemirror-editor

polygerrit 的 CodeMirror plugin

[Project](https://gerrit-review.googlesource.com/admin/repos/plugins/codemirror-editor) |

### commit-message-length-validator

用来检查上传 commit 的 commit-msg 的长度，如果超过长度，会向客户端返回相关报错信息。

[Project](https://gerrit-review.googlesource.com/admin/repos/plugins/commit-message-length-validator) |
[Documentation](https://gerrit.googlesource.com/plugins/commit-message-length-validator/+doc/master/src/main/resources/Documentation/about.md) |
[Configuration](https://gerrit.googlesource.com/plugins/commit-message-length-validator/+doc/master/src/main/resources/Documentation/config.md)

### delete-project

用于删除 project.

[Project](https://gerrit-review.googlesource.com/admin/repos/plugins/delete-project) |
[Documentation](https://gerrit.googlesource.com/plugins/delete-project/+doc/master/src/main/resources/Documentation/about.md) |
[Configuration](https://gerrit.googlesource.com/plugins/delete-project/+doc/master/src/main/resources/Documentation/config.md)

### download-commands

用于网页上显示 change 和 project 的下载命令。

[Project](https://gerrit-review.googlesource.com/admin/repos/plugins/download-commands) |
[Documentation](https://gerrit.googlesource.com/plugins/download-commands/+doc/master/src/main/resources/Documentation/about.md) |
[Configuration](https://gerrit.googlesource.com/plugins/download-commands/+doc/master/src/main/resources/Documentation/config.md)

### gitiles

与 Gerrit 服务器一起运行 Gitiles。Gitiles，可以网页浏览 project 中的信息，如 commit ，branch 等。功能类似 gitweb 。

[Project](https://gerrit-review.googlesource.com/admin/repos/plugins/gitiles)

### hooks

gerrit 服务器端的 hook。

[Project](https://gerrit-review.googlesource.com/admin/repos/plugins/hooks) |
[Documentation](https://gerrit.googlesource.com/plugins/hooks/+doc/master/src/main/resources/Documentation/about.md) |
[Configuration](https://gerrit.googlesource.com/plugins/hooks/+doc/master/src/main/resources/Documentation/config.md)

### plugin-manager

此 plugin 可以根据运行的 gerrit 来提供可以使用的 plugin 列表。默认从 `GerritForge CI` 下载相关 plugin，但此 plugin 不能修改其他 plugin 的配置，若要修改配置，需要对应的参考说明文档进行手动修改。

[Project](https://gerrit-review.googlesource.com/admin/repos/plugins/plugin-manager) |
[Documentation](https://gerrit.googlesource.com/plugins/plugin-manager/+doc/master/src/main/resources/Documentation/about.md) |
[Configuration](https://gerrit.googlesource.com/plugins/plugin-manager/+doc/master/src/main/resources/Documentation/config.md)

### replication

refs 有更新时，自动将 refs 推送到其他服务器。用于镜像代码。

[Project](https://gerrit-review.googlesource.com/admin/repos/plugins/replication) |
[Documentation](https://gerrit.googlesource.com/plugins/replication/+doc/master/src/main/resources/Documentation/about.md) |
[Configuration](https://gerrit.googlesource.com/plugins/replication/+doc/master/src/main/resources/Documentation/config.md)

### reviewnotes

在 `refs/notes/review` 分支，存储 change 的评审相关信息。

[Project](https://gerrit-review.googlesource.com/admin/repos/plugins/reviewnotes) |
[Documentation](https://gerrit.googlesource.com/plugins/reviewnotes/+doc/master/src/main/resources/Documentation/about.md)

### singleusergroup

将单一用户视为群组使用。配置权限的时候比较有用。

### webhooks

将 gerrit 事件信息传到远端的 http 服务器。

[Project](https://gerrit-review.googlesource.com/admin/repos/plugins/webhooks) |
[Documentation](https://gerrit.googlesource.com/plugins/webhooks/+doc/master/src/main/resources/Documentation/about.md) |
[Configuration](https://gerrit.googlesource.com/plugins/webhooks/+doc/master/src/main/resources/Documentation/config.md)

## Other Plugins

除了 core plugins 以外，gerrit 还有很多的 plugin，这些 plugin 由不同的组织进行开发和维护，gerrit 不保证这些 plugin 可以正常运行。

Gerrit 并没有为这些 plugin 提供二进制文件，不过可以在公共的 CI 服务器上进行下载 plugin 的 jar 文件：

* [CI Server from GerritForge](https://gerrit-ci.gerritforge.com)

下面是 plugin 的一个概览，有可能不是全部的。更多 plugin 可以访问：[gerrit-review](https://gerrit-review.googlesource.com/admin/repos/?filter=plugins%252F)。

需要说明的是，下面的文档及配置的链接都属于 plugin 的 master 分支。gerrit 不同的版本，使用的 plugin 的分支有可能不一样，请参考与 gerrit 对应的 plugin 分支。需要注意的是，有的时候 plugin 的 master 分支兼容多个 gerrit 版本，此时是没有与 gerrit 对应的 stable 分支的。

### admin-console

此 Plugin 只提供了管理员的功能，计划执行简单的管理员任务。

[Project](https://gerrit-review.googlesource.com/admin/repos/plugins/admin-console) |
[Documentation](https://gerrit.googlesource.com/plugins/admin-console/+doc/master/src/main/resources/Documentation/about.md)

### analytics

用于从 project 提取 commit 及其 review 的相关数据并通过 SSH 或 REST API 来显示度量信息。度量信息以 JSON 格式显示，每行显示一条记录信息，可以通过大数据工具对其归档，如 `Apache Spark` 。

[Project](https://gerrit-review.googlesource.com/admin/repos/plugins/analytics) |
[Documentation](https://gerrit.googlesource.com/plugins/analytics/+doc/master/README.md)

### avatars-external

用于从其他的路径加载 avatar 图像。

[Project](https://gerrit-review.googlesource.com/admin/repos/plugins/avatars-external) |
[Documentation](https://gerrit.googlesource.com/plugins/avatars-external/+doc/master/src/main/resources/Documentation/about.md) |
[Configuration](https://gerrit.googlesource.com/plugins/avatars-external/+doc/master/src/main/resources/Documentation/config.md)

### avatars-gravatar

用于从 Gravatar 获取图像。

[Project](https://gerrit-review.googlesource.com/admin/repos/plugins/avatars-gravatar)

### branch-network

用于 `HTML5 Canvas` 图形化显示分支的节点信息。

[Project](https://gerrit-review.googlesource.com/admin/repos/plugins/branch-network) |
[Documentation](https://gerrit.googlesource.com/plugins/branch-network/+doc/master/src/main/resources/Documentation/about.md) |
[Configuration](https://gerrit.googlesource.com/plugins/branch-network/+doc/master/src/main/resources/Documentation/config.md)

### changemessage

在 change 页面显示静态的通知信息。

[Project](https://gerrit-review.googlesource.com/admin/repos/plugins/changemessage) |
[Plugin Documentation](https://gerrit.googlesource.com/plugins/changemessage/+doc/master/src/main/resources/Documentation/about.md) |
[Configuration](https://gerrit.googlesource.com/plugins/changemessage/+doc/master/src/main/resources/Documentation/config.md)

### checks

为 CI 与 Gerrit 的集成提供了 REST API 和 UI 的扩展。

[Project](https://gerrit-review.googlesource.com/admin/repos/plugins/checks) |
[Plugin Documentation](https://gerrit.googlesource.com/plugins/checks/+doc/master/README.md)

### egit

为使用 EGit 提供了简单的扩展。

plugin 为 EGit 添加了相关的下载命令，并允许将 change 的 ref 复制到剪贴板。因为 EGit 下载 change 需要 ref 的信息。

[Project](https://gerrit-review.googlesource.com/admin/repos/plugins/egit) |
[Documentation](https://gerrit.googlesource.com/plugins/egit/+doc/master/src/main/resources/Documentation/about.md)

### emoticons

可以在 comment 中显示表情图片。

[Project](https://gerrit-review.googlesource.com/admin/repos/plugins/emoticons) |
[Documentation](https://gerrit.googlesource.com/plugins/emoticons/+doc/master/src/main/resources/Documentation/about.md) |
[Configuration](https://gerrit.googlesource.com/plugins/emoticons/+doc/master/src/main/resources/Documentation/config.md)

### find-owners

此 plugin 提供了：
    (1) change 的 review 功能按钮：`[FIND OWNERS]`，可以把 change 文件的 owner 作为评审人员
    (2) 需要 文件的 owner 进行 Code-Review +1，否则 change 不能合入。

[Project](https://gerrit-review.googlesource.com/admin/repos/plugins/find-owners) |
[Documentation](https://gerrit.googlesource.com/plugins/find-owners/+doc/master/src/main/resources/Documentation/about.md) |
[Configuration](https://gerrit.googlesource.com/plugins/find-owners/+doc/master/src/main/resources/Documentation/config.md)

### gitblit

与 Gerrit 服务器一起运行 GitBlit。GitBlit，可以网页浏览 project 中的信息，如 commit ，branch 等。功能类似 gitweb 。

[Project](https://gerrit-review.googlesource.com/admin/repos/plugins/gitblit)

### github

与 GitHub 集成: replication, pull-request to Change-Sets

[Project](https://gerrit-review.googlesource.com/admin/repos/plugins/github)

### healthcheck

此 plugin 可以与监控系统集成，监控系统通过 API 获取一些 gerrit 数据，用于对 gerrit 服务器的监控。

[Project](https://gerrit-review.googlesource.com/admin/repos/plugins/healthcheck) |
[Documentation](https://gerrit.googlesource.com/plugins/healthcheck/+doc/master/src/main/resources/Documentation/about.md) |
[Configuration](https://gerrit.googlesource.com/plugins/healthcheck/+doc/master/src/main/resources/Documentation/config.md)

### imagare

允许用户上传图片，便于 change 评审。

[Project](https://gerrit-review.googlesource.com/admin/repos/plugins/imagare) |
[Documentation](https://gerrit.googlesource.com/plugins/imagare/+doc/master/src/main/resources/Documentation/about.md) |
[Configuration](https://gerrit.googlesource.com/plugins/imagare/+doc/master/src/main/resources/Documentation/config.md)

### importer

用于将 project 从一个 gerrit 服务器导入到另外一个 gerrit 服务器。commit，change，评审记录，评论等会一并导入。

[Project](https://gerrit-review.googlesource.com/admin/repos/plugins/importer) |
[Documentation](https://gerrit.googlesource.com/plugins/importer/+doc/master/src/main/resources/Documentation/about.md)

### Issue Tracker System Plugins

用于与 issue tracker systems (ITS) 集成，如下：

[its-base Project](https://gerrit-review.googlesource.com/admin/repos/plugins/its-base) |
[its-base Documentation](https://gerrit.googlesource.com/plugins/its-base/+doc/master/src/main/resources/Documentation/about.md) |
[its-base Configuration](https://gerrit.googlesource.com/plugins/its-base/+doc/master/src/main/resources/Documentation/config.md)

#### its-bugzilla

与 Bugzilla 集成

[Project](https://gerrit-review.googlesource.com/admin/repos/plugins/its-bugzilla) |
[Documentation](https://gerrit.googlesource.com/plugins/its-bugzilla/+doc/master/src/main/resources/Documentation/about.md)

#### its-jira

与 Jira 集成

[Project](https://gerrit-review.googlesource.com/admin/repos/plugins/its-jira) |
[Configuration](https://gerrit.googlesource.com/plugins/its-jira/+doc/master/src/main/resources/Documentation/config.md)

#### its-phabricator

与 Phabricator 集成

[Project](https://gerrit-review.googlesource.com/admin/repos/plugins/its-phabricator) |
[Configuration](https://gerrit.googlesource.com/plugins/its-phabricator/+doc/master/src/main/resources/Documentation/config.md)

#### its-rtc

与 IBM Rational Team Concert (RTC) 集成

[Project](https://gerrit-review.googlesource.com/admin/repos/plugins/its-rtc) |
[Configuration](https://gerrit.googlesource.com/plugins/its-rtc/+doc/master/src/main/resources/Documentation/config.md)

#### its-storyboard

与 Storyboard（任务跟踪系统）集成

[Project](https://gerrit-review.googlesource.com/admin/repos/plugins/its-storyboard) |
[Documentation](https://gerrit.googlesource.com/plugins/its-storyboard/+doc/master/src/main/resources/Documentation/about.md)

### javamelody

用于实时监控 gerrit 服务器性能。

[Project](https://gerrit-review.googlesource.com/admin/repos/plugins/javamelody) |
[Documentation](https://gerrit.googlesource.com/plugins/javamelody/+doc/master/src/main/resources/Documentation/about.md) |
[Configuration](https://gerrit.googlesource.com/plugins/javamelody/+doc/master/src/main/resources/Documentation/config.md)

### labelui

用表格的形式显示 change 的打分情况。

[Project](https://gerrit-review.googlesource.com/admin/repos/plugins/labelui) |
[Documentation](https://gerrit.googlesource.com/plugins/labelui/+doc/master/src/main/resources/Documentation/about.md)

### menuextender

管理员可以在网页的顶部扩展菜单

[Project](https://gerrit-review.googlesource.com/admin/repos/plugins/menuextender) |
[Documentation](https://gerrit.googlesource.com/plugins/menuextender/+doc/master/src/main/resources/Documentation/about.md) |
[Configuration](https://gerrit.googlesource.com/plugins/menuextender/+doc/master/src/main/resources/Documentation/config.md)

### metrics-reporter-elasticsearch

使用 Elasticsearch 显示 gerrit 度量数据

[Project](https://gerrit-review.googlesource.com/admin/repos/plugins/metrics-reporter-elasticsearch).

### metrics-reporter-graphite

使用 Graphite 显示 gerrit 度量数据

[Project](https://gerrit-review.googlesource.com/admin/repos/plugins/metrics-reporter-graphite).

### metrics-reporter-jmx

使用 JMX 显示 gerrit 度量数据

[Project](https://gerrit-review.googlesource.com/admin/repos/plugins/metrics-reporter-jmx).

### metrics-reporter-prometheus

使用 Prometheus 显示 gerrit 度量数据

[Project](https://gerrit-review.googlesource.com/admin/repos/plugins/metrics-reporter-prometheus).

### motd

客户端使用 pulling/fetching/cloning 操作时，服务器端会向客户端发送一些自定义的信息。

[Project](https://gerrit-review.googlesource.com/admin/repos/plugins/motd) |
[Documentation](https://gerrit.googlesource.com/plugins/motd/+doc/master/src/main/resources/Documentation/about.md) |
[Configuration](https://gerrit.googlesource.com/plugins/motd/+doc/master/src/main/resources/Documentation/config.md)

### OAuth authentication provider

Gerrit 使用 OAuth2 协议进行认证。支持的 OAuth2 供应商如下：

* AirVantage
* Bitbucket
* CAS
* CoreOS Dex
* Facebook
* GitHub
* GitLab
* Google
* Keycloak
* Office365

[Project](https://gerrit-review.googlesource.com/admin/repos/plugins/oauth) |
[Configuration](https://gerrit.googlesource.com/plugins/oauth/+doc/master/src/main/resources/Documentation/config.md)

### owners

需要对 project 的文件目录添加 owner，change 评审时，强制对应的 owner 进行评审。

[Project](https://gerrit-review.googlesource.com/admin/repos/plugins/owners) |
[Documentation](https://gerrit.googlesource.com/plugins/owners/+doc/master/README.md)

### project-download-commands

自定义添加 project 的相关下载命令。

[Project](https://gerrit-review.googlesource.com/admin/repos/plugins/project-download-commands) |
[Documentation](https://gerrit.googlesource.com/plugins/project-download-commands/+doc/master/src/main/resources/Documentation/about.md) |
[Configuration](https://gerrit.googlesource.com/plugins/project-download-commands/+doc/master/src/main/resources/Documentation/config.md)

### quota

对 project 实施限额，如：数量，大小。

[Project](https://gerrit-review.googlesource.com/admin/repos/plugins/quota) |
[Documentation](https://gerrit.googlesource.com/plugins/quota/+doc/master/src/main/resources/Documentation/about.md)
[Configuration](https://gerrit.googlesource.com/plugins/quota/+doc/master/src/main/resources/Documentation/config.md)

### rabbitmq

将 Gerrit events 发布到 [RabbitMQ](https://www.rabbitmq.com/) 系统。

[Project](https://gerrit-review.googlesource.com/admin/repos/plugins/rabbitmq)
[Configuration](https://gerrit.googlesource.com/plugins/rabbitmq/+/master/src/main/resources/Documentation/config.md)

### readonly

使 gerrit 服务器只读，不能写（包括：git pushes, HTTP PUT/POST/DELETE requests, SSH commands）。

[Project](https://gerrit-review.googlesource.com/admin/repos/plugins/readonly) |
[Documentation](https://gerrit.googlesource.com/plugins/readonly/+doc/master/src/main/resources/Documentation/about.md) |
[Configuration](https://gerrit.googlesource.com/plugins/readonly/+doc/master/src/main/resources/Documentation/config.md)

### ref-protection

用于防止 commit 丢失。

在 `refs/backups/` 命名空间下备份删除的 refs。

[Project](https://gerrit-review.googlesource.com/admin/repos/plugins/ref-protection) |
[Documentation](https://gerrit.googlesource.com/plugins/ref-protection/+doc/master/src/main/resources/Documentation/about.md)

### reparent

project-owner 可以设置 `parent project`。

[Project](https://gerrit-review.googlesource.com/admin/repos/plugins/reparent) |
[Documentation](https://gerrit.googlesource.com/plugins/reparent/+doc/master/src/main/resources/Documentation/about.md) |
[Configuration](https://gerrit.googlesource.com/plugins/reparent/+doc/master/src/main/resources/Documentation/config.md)

### review-strategy

用于配置 review 策略。

[Project](https://gerrit-review.googlesource.com/admin/repos/plugins/review-strategy) |
[Documentation](https://gerrit.googlesource.com/plugins/review-strategy/+doc/master/src/main/resources/Documentation/about.md)

### reviewers

为 change 自动添加评审人员。

[Project](https://gerrit-review.googlesource.com/admin/repos/plugins/reviewers) |
[Documentation](https://gerrit.googlesource.com/plugins/reviewers/+doc/master/src/main/resources/Documentation/about.md) |
[Configuration](https://gerrit.googlesource.com/plugins/reviewers/+doc/master/src/main/resources/Documentation/config.md)

### reviewers-by-blame

根据 `git blame` 算法，自动向 change 添加评审人员。对于 change 的评审文件，使用 `git blame` 计算出文件新增行数最多的 author，然后把 author 作为评审人员添加到评审列表中。

[Project](https://gerrit-review.googlesource.com/admin/repos/plugins/reviewers-by-blame) |
[Documentation](https://gerrit.googlesource.com/plugins/reviewers-by-blame/+doc/master/src/main/resources/Documentation/about.md) |
[Configuration](https://gerrit.googlesource.com/plugins/reviewers-by-blame/+doc/master/src/main/resources/Documentation/config.md)

### scripting/groovy-provider

提供了一个 Groovy 运行的环境。

[Project](https://gerrit-review.googlesource.com/admin/repos/plugins/scripting/groovy-provider) |
[Documentation](https://gerrit.googlesource.com/plugins/scripting/groovy-provider/+doc/master/src/main/resources/Documentation/about.md)

### SAML2 authentication provider

使用 SAML2 协议进行认证

[Project](https://gerrit-review.googlesource.com/admin/repos/plugins/saml)

### scripting/scala-provider

提供了一个 Scala 运行的环境。

[Project](https://gerrit-review.googlesource.com/admin/repos/plugins/scripting/scala-provider) |
[Documentation](https://gerrit.googlesource.com/plugins/scripting/scala-provider/+doc/master/src/main/resources/Documentation/about.md)

### scripts

脚本，用于 gerrit 功能的扩展，有点类似 plugin。

Groovy 和 Scala 脚本需要 gerrit 安装 `scripting/*-provider` plugin。

[Project](https://gerrit-review.googlesource.com/admin/repos/plugins/scripts)
[Documentation](https://gerrit.googlesource.com/plugins/scripts/+doc/master/README.md)

### server-config

此 plugin 可以上传或下载 gerrit 的配置文件，比如 `etc/gerrit.config`。

[Project](https://gerrit-review.googlesource.com/admin/repos/plugins/server-config)

### serviceuser

允许创建 service-user。

service-user 用来 gerrit 和其他系统的集成。比如与 jenkins 系统的集成，service-user 需要在 jenkins 中运行 `Gerrit Trigger Plugin`，因此需要 gerrit 相关的 read 和 stream-events 的权限，但不允许此用户登录 gerrit，不允许推送 commit 和 tags。

[Project](https://gerrit-review.googlesource.com/admin/repos/plugins/serviceuser) |
[Documentation](https://gerrit.googlesource.com/plugins/serviceuser/+doc/master/src/main/resources/Documentation/about.md) |
[Configuration](https://gerrit.googlesource.com/plugins/serviceuser/+doc/master/src/main/resources/Documentation/config.md)

### uploadvalidator

可以为每个 project 配置 upload 的校验。

Project-owner 可以配置对 commit 的校验，比如：根据文件名阻止文件的上传，commit-msg 需要有 footers 等。然后 gerrit 会拒绝 commit 的推送。

[Project](https://gerrit-review.googlesource.com/admin/repos/plugins/uploadvalidator) |
[Documentation](https://gerrit.googlesource.com/plugins/uploadvalidator/+doc/master/src/main/resources/Documentation/about.md) |
[Configuration](https://gerrit.googlesource.com/plugins/uploadvalidator/+doc/master/src/main/resources/Documentation/config.md)

### verify-status

此 plugin 为存储 change 的测试数据提供了一个独立的空间，可以在页面上查看这些测试数据。数据可以存放在数据库或一个完全独立的数据空间。

[Project](https://gerrit-review.googlesource.com/admin/repos/plugins/verify-status) |
[Documentation](https://gerrit.googlesource.com/plugins/verify-status/+doc/master/src/main/resources/Documentation/about.md) |
[Configuration](https://gerrit.googlesource.com/plugins/verify-status/+doc/master/src/main/resources/Documentation/database.md)

### websession-flatfile

此 plugin 用 flatfile 替代了 gerrit 内置的基于 H2 的 websession 缓存。此 plugin 用于 multi-master 的部署。

[Project](https://gerrit-review.googlesource.com/admin/repos/plugins/websession-flatfile) |
[Documentation](https://gerrit.googlesource.com/plugins/websession-flatfile/+doc/master/src/main/resources/Documentation/about.md) |
[Configuration](https://gerrit.googlesource.com/plugins/websession-flatfile/+doc/master/src/main/resources/Documentation/config.md)

### x-docs

将文档作为 HTML 页面显示。

[Project](https://gerrit-review.googlesource.com/admin/repos/plugins/x-docs) |
[Documentation](https://gerrit.googlesource.com/plugins/x-docs/+doc/master/src/main/resources/Documentation/about.md) |
[Configuration](https://gerrit.googlesource.com/plugins/x-docs/+doc/master/src/main/resources/Documentation/config.md)


上面的非 `core plugins` 描述已在官方指南中移除，现保留只用于存档，具体的 plugin 信息请参考官方的 [plugin 描述](https://www.gerritcodereview.com/plugins.html)。
