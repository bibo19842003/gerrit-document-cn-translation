# Gerrit Code Review - System Design

## Objective

Gerrit 是一个基于 web 的代码评审系统，可以进行在线代码评审，并用 git 来存储相关代码和文件。

Gerrit 通过 side-by-side 的方式查看代码的修改，并允许在线编辑文件等等的一些功能，让评审变得更方便。

Gerrit 简化了 git 仓的维护，如：通过权限管控来向 git 仓提交修改，而不是维护者手动的将需要的修改合入到 git 仓。此功能可以更集中地使用Git。 

## Background

Google 基于 perforce 开发了 Mondrian，用于代码评审。Mondrian 并不是开源软件，仅在 google 内部使用。

Guido 开发了 Rietveld 工具，此工具为开源软件，包含了部分 Mondrian 的功能，仅支持 svn，不支持 perforce。并不像 Mondrian 那样需要强制评审才可以将代码合入。

Git 是一个分布式的版本控制工具。本身没有权限控制的机制，如果多人维护一个 git 仓的话，会有很多协作的问题。

Gitosis 可以将 git 仓集中进行管理，通过网络安全协议来限制访问，与 perforce 仅允许通过网络端口进行访问有些类似。Gitosis 允许多个维护人员同时管理同一个 project。

`Android Open Source Project` (AOSP) 由 google 创建，并开源，定期发布 Android 操作系统。AOSP 使用 git 作为版本控制工具。google 内部使用过 Mondrian 的工程师，强烈建议 AOSP 要使用更好的代码评审工具。

Gerrit Code Review 起始于 Rietveld ，并应用于 AOSP。很快，基于 Rietveld 创建了一个新的分支，并添加了权限控制的功能，但 Guido 并不想让 Rietveld 代码库变得更复杂。由于添加了许多功能，代码也有了很大的变化，因此需要一个新的名字来给项目命名。这时想到了荷兰建筑师 `Gerrit Rietveld`，新的项目名称就诞生了：gerrit 。

Gerrit 2.x 对 Gerrit 进行了重写，开发语言从 python 改为了 Java。

自从 Gerrit 3.x 使用 [NoteDb](note-db.md) 取代了 SQL 数据库，因此所有的元数据目前存储在 git 仓中。

* [Mondrian Code Review On The Web](http://video.google.com/videoplay?docid=-8502904076440714866)
* [Rietveld - Code Review for Subversion](https://github.com/rietveld-codereview/rietveld)
* [Gitosis README](http://eagain.net/gitweb/?p=gitosis.git;a=blob;f=README.rst;hb=HEAD)
* [Android Open Source Project](http://source.android.com/)

## Overview

开发人员在本地做了一个或多个的修改，然后通过命令行 `git push` 或内置 `git push` 命令的 GUI 来将修改推送到 gerrit 上。用户的认证和数据传递可以通过 SSH 和 HTTP 协议来完成。

每个 Git commit 在客户端的电脑上创建，推送到 gerrit 后生成 change，每个 change 的评审记录都存放在 NoteDb 中。

change 生成后，系统会给相关的评审人员发送通知邮件。邮件中有评审的链接。评审人员可以在 `git push` 的时候添加，也可以在 change 的页面进行添加。

评审人员可以在网页上做 side-by-side 的查看，也可以发布相关的评论。评论发布后，系统会给相关人员发送通知邮件。

评审人员会对 change 进行打分，表明 change 是否应该合入或者需要上传新的补丁。

对 change 的打分都通过后，可以点击 submit 按钮进行合入。

## Infrastructure

用户可以通过浏览器向 gerrit 服务器发送请求。请求会通过 JSON 格式进行传递。大多数的响应小于 1 KB。

Gerrit 的 HTTP 服务器端组件由标准的 Java servlet 实现，因此可以在任何 J2EE servlet 容器中运行。Tomcat 或 Jetty 是不错的选择，因为他们是是高质量的开源的 servlet 容器，并且方便下载。

用户可以通过 SSH 协议进行上传相关操作，因此 Gerrit 的 servlet 启动了后台线程，通过独立的 SSH 端口接收用户的 SSH 连接。SSH 客户端直接与此端口通信。

服务器端的数据存储到不同的目录中：

* Git repository data
* Gerrit metadata

Git 仓的数据主要存储的是提交的数据和相关记录。gerrit 通过 JGit 的 lib 文件来对 git 仓进行相关操作。git 仓可以存储在本地，也可以存储在 NFS 或 SMB。本地存储的效率要比远程存储的效率高一些。

Gerrit metadata 包含了 change 的相关评审记录，目前存储在 git 仓中。

如果使用 OpenID 作为用户认证的方式，需要选择一个稳定可靠的 OpenID 提供商来提供服务。

* [Git Repository Format](http://www.kernel.org/pub/software/scm/git/docs/gitrepository-layout.html)
* [OpenID Specifications](http://openid.net/developers/specs/)


## Internationalization and Localization

作为一个开源项目的代码评审系统，语言选择了世界通用的英语，gerrit 不会把国际化和本地化的工作放在首位。

大多数用户使用英语书写 change 描述和评论，因此用户界面也是英文的。

gerrit 目前不支持 Right-to-left (RTL) 。


## Accessibility Considerations

Gerrit 尽可能使用文本显示而不用图标显示，因为这样比较易读，容易理解。

使用标准的 HTML 超链接，不使用 HTML div 或 span tag 的点击监听。主要有两个好处。第一个是超链接可以体现导航操作；第二个是用户可以在浏览器中使用‘在新的标签页打开/新的窗口打开’的功能。

如果可能，Gerrit 使用 DOM 的 ARIA 属性为屏幕阅读器提供提示。

## Browser Compatibility

gerrit 建议使用可以支持 JavaScript 的浏览器。

在客户端上，gerrit 是一个纯 JavaScript 的应用，所以浏览器需要支持 JavaScript ，才能与 gerrit web 应用进行链接。例如 `lynx`, `wget`, `curl` 以及部分搜索引擎的爬虫是不能访问到 gerrit 内容的。

支持 JavaScript 的浏览器有很多，但不同的操作系统支持的标准还不一样。

有一些开源的浏览器可以使用，如 Firefox 和 Chromium。

gerrit 存储的大部分内容也可以通过其他方式获取，如 gitweb 或者 `git://` 协议。现有的大部分爬虫可以爬取 gitweb 的 HTML 上面的内容。有的爬虫甚至可以爬取数据库，如 `ohloh.net`。因此，爬虫对 gerrit 的部署没有什么影响。

## Product Integration

Gerrit 可以通过超链接的方式与 gitweb 集成。

Gerrit 可以与 `git-daemon` 集成，然后用户可以使用 `git://` 协议下载 git 仓。 

Gerrit 可以与 OpenID 提供商集成，便于用户的认证，如：`Google Accounts` 等。

管理员可以通过设置 "reliable OpenID providers" 来限制 OpenID 帐号的相关访问。

Gerrit 可以与 SSO 系统集成，但不能同时与 OpenID 集成。

安装 gerrit 的时候，管理员可以在 HTML 的 header 或 footer 添加追踪用户行为的代码片段，如：`Google Analytics`。每个实例的配置都需要手动完成。

## Privacy Considerations

Gerrit 存储的用户信息如下：

* Full Name
* Preferred Email Address
* Mailing Address '(Optional, Encrypted)'
* Country '(Optional, Encrypted)'
* Phone Number '(Optional, Encrypted)'
* Fax Number '(Optional, Encrypted)'

`full name` 和 `preferred email address` 字段信息可以被任何一个用户在 change 页面看到。

用户的名称和邮箱地址以未加密的形式存储在 [All-Users](config-accounts.md) 。

收集的 mail, country, phone ，fax numbers 这些信息主要用于 project 的负责人在特殊情况下方便联系上传 change 的用户，如遇到了法律问题。

一些敏感字段会被 `GnuPG public key` 加密，并存储在另一个系统中，和 gerrit 数据隔离。Gerrit 无法访问与之匹配的 `private key`，因此不能将信息解密。这些敏感字段会一次性写入，即使是帐号的所有者也不能恢复先前的数据。

## Spam and Abuse Considerations

Gerrit 不对 change 或评论中的垃圾邮箱做检查。因为对于垃圾邮件的发送者来说，难度较大，并且回报较少。

## Latency

Gerrit 的目标是在服务器和客户端之间，通过 JSON 方式来传递数据，来实现每页的请求低于 250 ms。但是，由于大多数服务（网络，硬件，元数据数据库）都不受 gerrit 开发人员的控制，因此无法对延迟做出保证。

## Scalability

Gerrit 设计初衷是支持大规模的部署，相关参数如下：

_Design Parameters_

|Parameter        | Default Maximum | Estimated Maximum
| :------| :------| :------|
|Projects         |         1,000   | 10,000
|Contributors     |         1,000   | 50,000
|Changes/Day      |           100   |  2,000
|Revisions/Change |            20   |     20
|Files/Change     |            50   | 16,000
|Comments/File    |           100   |    100
|Reviewers/Change |             8   |      8


默认配置的状态下，gerrit 按照 "Default Maximum" 性能来运行。在有足够大的内存情况下，管理员可以修改 gerrit.config 文件，如：JVM 和 `cache.*.memoryLimit` 及相关参数来让 gerrit 发挥更大的性能，直到接近 "Estimated Maximum"。

### Discussion

很少有单一的开源项目使用了多个 git 仓库，gerrit 把每一个 git 仓库视为一个 project，所以这是 10,000 上限的原因。如果一个站点超过了 1,000 个 project，那么需要上调  [`cache.projects.memoryLimit`](config-gerrit.md) 参数。

几乎没有 1000 个开发者的开源项目。通过使用 android 系统的手机开发公司的 PR 声明，暂将其定为 1,000。

gerrit 服务器预估可以支持 50,000 个开发者，如果有超过 1,000 的活动账户，在有足够多的 RAM 情况下，可以上调 [`cache.accounts.memoryLimit`](config-gerrit.md) 参数。

100 个 change 是根据 android 历史开发数据计算出来的。代码的修改和评审需要一定的时间。平均每个工程师花费在 change 上的书写代码及单元测试的时长为 4-6 小时。一天当中的其他时间花费在会议，面试，培训，午餐等事情上。每个工程师差不多 1 到 2 天会合入一个修改。以 linux 内核为例，平均每天会合入 79 个修改。如果每天的合入超过了 100 个，需要上调 [`cache.diff.memoryLimit`](config-gerrit.md) 和 `cache.diff_intraline.memoryLimit` 参数。

### CPU Usage - Web UI

一个 change 的评审及合入平均需要 `4+F+F*C` 次的 HTTP 请求。`F` 为修改的文件数量；`C` 为对每个文件的评论的数量；4 表示为：加载评审人的 dashboar，加载 change 的详细信息，发布评论及评论后的 change 信息的重载的环节数。

此 WAG 预估每天的 HTTP 请求在 216,000 以下(QPD)。按每天 8 小时工作计算，每秒大概 7.5 次搜索 (QPS)。

```
  QPD = Changes_Day * Revisions_Change * Reviewers_Change * (4 +  F +  F * C)
      = 2,000       * 2                * 1                * (4 + 10 + 10 * 4)
      = 216,000
  QPS = QPD / 8_Hours / 60_Minutes / 60_Seconds
      = 7.5
```

一个处理器在使用 loopback 接口的时候，gerrit 可以在 60 ms 内处理大多数的请求。在单核的 CPU 系统中，处理能力是 16 QPS。上面描述的 `Estimated Maximum` 的负载，双核 CPU 系统就可以搞定。

以 linux 内核为例，每天 79 个 change，8,532 次搜索，按一天 8小时工作计算，低于 0.29 QPS 。

### CPU Usage - Git over SSH/HTTP

一个 24 core 的服务器每秒可以同时处理 25 个 `git fetch` 的操作。问题是每个操作需要 1 个完整的 core，因为计算的时候需要与服务器端的 CPU 绑定。25 个并发可以支持数百个开发人员和 50 个自动构建服务器对 change 的构建使用(此数据来自实际的使用)。

由于 git 本身是一个分布式的工具，用户不需要频繁地链接 `gerrit 中心服务器`，使用 `git fetch` 的时候可以从 [replica mode](pgm-daemon.md) 的服务器进行下载，这样可以减少中心服务器的负载。如果需要大规模部署的时候，建议使用横向扩展。

用户在非常慢的网络链接下 (例如：通过家庭的 DSL 链接 VPN)，此时瓶颈在网络上，而不是服务器端的 CPU，这种情况下，CPU 的 core 会与其他用户共享。在服务器端网络链接低于 `10 MiB/sec` 的情况下，适用于 core 共享的配置方式。

如果服务器的网络接口的速率是 `1 Gib/sec` (Gigabit 端口)，不论服务器有多少 core，系统只能以 `10 MiB/sec` 的速度为 10 个用户同时提供服务。

### Disk Usage

linux 内核平均每次的提交在压缩后大约是 `2 KiB`。应用 `estimated maximum` 配置，一年的时间，10,000 个 project 大概增加了 1.4 GiB 的空间。这个空间只包括源代码的修改量，不包括二进制文件，如：镜像或媒体文件。

gerrit 可以处理数千兆字节大小的 git 仓；如果存储二进制文件的话，可以存储 800MB 大小的文件。可以把大的二进制仓拆分为多个小的二进制仓，这样可以避免下载不需要的文件。

## Redundancy & Reliability

Gerrit 认为本地存储的数据始终可用。如果本地数据损坏，gerrit 会将错误返回给客户端。

Gerrit 认为 metadata 数据库始终在线并且可用。如果查询失败会立即停止操作并将错误返回给客户端，失败后不做重试。

本地的存储系统和 metadata 数据库，有一个出现问题的话，会影响 gerrit 的正常使用。如果有预算，可以部署负载均衡系统，便于提供稳定的服务。

大多数的可靠性部署采用热备的方式，当出问题的时候，可以手动切换到备用系统。

如果遇到大的灾难，gerrit 会停机一些时间。由于 git 是一个分布式的工具，开发者可以在本地继续修改代码，待 gerrit 恢复后，再将 commit 进行上传。

### Backups

可以使用 replication plugin 来备份 git 仓中的数据。plugin 安装后，可以修改 `'$site_path'/etc/replication.conf` 配置文件来完成备份。

## Logging Plan

Gerrit 自身不支持 log 的维护。

发布的评论，包含发布的时间，因此用户可以自己判断评论是什么时候发布的，评论是否是最新。只存储时间戳，用户的 IP 地址不存储。

使用 `git push` 命令更新 change 的时候，gerrit 会识别更新 change 的账户。当 change 合入的时候，git 的 reflog 会更新，但这些 log 并不会进行 replication 的操作，用户也不会看到这些 log，只有管理员在回溯问题的时候有可能会查看这些数据。这样的 log 有的时候会浪费空间，JGit 在未来的版本中，有可能会取消这些 log，gerrit 到时候会使用这个特性。

部署在 gerrit 前面的服务器 (如：反向代理服务器) 或者 servlet 容器会记录访问日志，日志可以用于相关的数据分析。但这些不是 gerrit 的使用范围了。


