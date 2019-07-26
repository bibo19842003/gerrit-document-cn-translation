# Gerrit Code Review - Contributing

## Introduction

Gerrit 的使命是成为优秀的 [管理 open source project 的主机](https://gerrit-review.googlesource.com/)，目前是一个十分受欢迎的项目。

## Contributor License Agreement

在向 gerrit 社区贡献代码之前，需要签署贡献者声明，可按以下步骤操作：

* 点击 https://gerrit-review.googlesource.com/ 页面的右上角的 'Sign In'
* 使用 Google 账户登录
* 在 setting 页面中，点击 [Agreements](https://gerrit-review.googlesource.com/#/settings/agreements) 标签页
* 点击 'New Contributor Agreement' 并按说明操作

可参考下面实际的声明：

* [Individual Agreement](https://cla.developers.google.com/about/google-individual)
* [Corporate Agreement](https://cla.developers.google.com/about/google-corporate)

## Code Review

Gerrit 作为一个代码评审工具，其代码的修改需要经过评审才能合入到代码库。若要开始贡献代码，需要将本地的 commit 上传到 gerrit 服务器进行评审。为了加快 change 的合入，可以参考下面的操作指导。查看未合入的 `gerrit` project 的 change，可以点击 [here](https://gerrit-review.googlesource.com/#/q/status:open+project:gerrit)。

如果列表中的 change 有些多的话，那么对于刚刚生成的 change 来说，等待评审的时间也会相对于长一些。如果 change 的 patch-set 总变更的话，会延长代码的评审时间。如果帮助评审其他人的 change 的话，会减少评审人员的负担。即使对 gerrit 的内部机制不熟悉，如果能试着下载进行测试，或对新的特性做一些评论，这对评审人员来说，也是巨大的帮助。如果 change 按照描述可以正常工作，若是有权限的话，可以 +1 code-review 。

最后，对评审者的回复越快，越有利于 change 的合入。在更新 patch-set 后，要对每一条评论进行回复；如果评审人员建议上传新的 patch-set，若不想上传的话，要详细说明原因。

## Review Criteria

对于修改的代码来说，质量要高一些，不要让小的问题来分散评审人员的经历，比方说空格问题。另外，社区需要大家的帮忙，需要大家对代码的贡献。

### Commit Message

commit-msg 的格式要规范，这样便于评审代码：

  * 每行不要超过 72 个字符
  * 描述要简要
  * 段落之间要使用空白行隔开
  * 可以添加一个或多个解释性的段落
  * 使用现在的时态 
  * 在描述此提交之前的状态时使用过去时
  * 如果修复问题的话，需要有 `Bug: Issue <#>` 行描述；如果是新特性，需要有 `Feature: Issue <#>` 行的描述。
  * 需要有 `Change-Id` 行

### Setting up Vim for Git commit message

Git 默认使用 Vim 作为 commit-msg 的编辑器。将下面的信息添加到 `$HOME/.vimrc` 文件中用来配置对 commit-msg 的相关格式的约束：

```
  " Enable spell checking, which is not on by default for commit messages.
  au FileType gitcommit setlocal spell

  " Reset textwidth if you've previously overridden it.
  au FileType gitcommit setlocal textwidth=72
```

### A sample good Gerrit commit message:

```
  Add sample commit message to guidelines doc

  The original patch set for the contributing guidelines doc did not
  include a sample commit message, this new patchset does.  Hopefully this
  makes things a bit clearer since examples can sometimes help when
  explanations don't.

  Note that the body of this commit message can be several paragraphs, and
  that I word wrap it at 72 characters.  Also note that I keep the summary
  line under 50 characters since it is often truncated by tools which
  display just the git summary.

  Bug: Issue 98765605
  Change-Id: Ic4a7c07eeb98cdeaf44e9d231a65a51f3fceae52
```

`Change-Id` 行，由本地的 git hook 生成。可以通过下面的命令进行安装：

```
  cp ./gerrit-server/src/main/resources/com/google/gerrit/server/tools/root/hooks/commit-msg .git/hooks/
  chmod +x .git/hooks/commit-msg
```

如果为 core plugins 工作，submodules 中同样需要安装此 hook：

```
  export hook=$(pwd)/.git/hooks/commit-msg
  git submodule foreach 'cp -p "$hook" "$(git rev-parse --git-dir)/hooks/"'
```

为了方便推送，可以执行命令添加如下配置：

```
  git remote add gerrit https://gerrit.googlesource.com/gerrit
```

HTTPS 的链接方式需要用户名和密码，可以点击 'Obtain Password' 来获取，如： [HTTP Password tab of the user settings page](https://gerrit-review.googlesource.com/#/settings/http-password)。

### Style

此项目有一个 Eclipse 的警告免费代码的策略。Eclipse 配置被添加到 git 中，我们希望修改成警告免费。

不强制使用 Eclipse 编辑代码。仅仅是请求开发人员提供带有 `Eclipse's warning free` 的 patch。如果因为一些其他的原因不能使用 Eclipse 进行验证，并且 patch 中没有相关的 `Eclipse's warning free` 说明，若是在 change 的评论中说明原因，那么评审人员还是愿意对此 change 进行评审的。本想通过 gerrit CI 自动化实现，但现在还没有完成。

Gerrit 的代码风格参考 [Google Java Style Guide](https://google.github.io/styleguide/javaguide.html)。

为了统一 Java 源码的风格，Gerrit 使用 [`google-java-format`](https://github.com/google/google-java-format) 工具(version 1.7)进行代码风格的格式化操作。使用 [`buildifier`](https://github.com/bazelbuild/buildtools/tree/master/buildifier) 工具(version 0.26.0) 来对 bazel 的 BUILD, WORKSPACE 和 .bzl 文件进行格式化操作。这些工具根据代码风格指导自动处理代码的格式，简化了代码的评审过程，减少了相关的耗时，乏味和有争议的讨论。

可以本地的机器上下载并运行 `google-java-format` 工具，或者使用 `./tools/setup_gjf.sh` 脚本来下载。由于工具不同的版本之间有差异，请使用文中提到的工具版本。

在考虑规则之外的代码风格时，通常是匹配所修改的代码的附近的的样式。

此外，Gerrit 中的空白行也是有要求的，如：

  * 类和方法之间有空白行
  * 类的前面，方法的后面不要添加空白行

新代码中，什么时候使用 `final`，什么时候不使用：

总是:

  * final fields: 将字段标记为 final，并在构造函数或者声明中进行初始化
  * final static fields: 清晰的表达目的
  * 在匿名的的类中使用

偶尔:

  * final 类: 适当使用，如 API 限制
  * final 方法: 同 final 类

绝不:

  * 本地变量：混在代码中间，降低代码的可读性。当将代码复制到新的位置时，可以移除 final
  * 方法的参数：同本地变量

### Code Organization

如何合理的使用类和方法，下面是 gerrit 使用的一些规则：

  * 确保新文件的顶部包含标准版权的标识（从哪个文件复制的，更新的时间）。
  * 类中要有 log 相关函数。
  * 在类中定义静态接口。
  * 在类中定义静态接口后，还有定义非静态接口。
  * 对静态类型，静态成员，静态方法的定义，从可访问性的角度（公共到私有）进行降序排列
  * 定义实例类型，实例成员，构造函数，和实例方法。
  * 常见的例外，如：私有的静态方法，有可能出现在实例方法的附近或是顶部。
  * 如果没有特殊的原因，相同实例字段的 getter 和 setter 要尽量近一些
  * 如果使用 injection ，那么 类的 factory 需要放到实例成员之前。
  * 注释放到关键字 (`final`, `private`, 等) 之前，如： `@Assisted @Nullable final type varName`。
  * 在同一个 try-with-resources 模块中可以打开多个 AutoCloseable 资源，而不是嵌套 try-with-resources 模块并不必要地增加缩进。

哇，这么多！别担心，你会养成好习惯的，并且大部分代码都是以这种方式组织的; 因此，注意正在编辑的类，可能会很容易接受。新的类要稍微麻烦一点; 有可能在创建它们时需要返回查阅此部分。

### Design

下面是编写代码时需要记住的一些设计方面的方向：

  * 大多数的客户端页面应该执行一个 RPC 来用于加载，因此会保持低延迟。也有例外，比如使用 RPC 加载大量的数据集，如果对数据集进行切分，那么会加快页面加载的速度。一般来说，页面加载的话在 100ms 内完成，大多数的操作都是这种情况，除非数据没有使用 gerrit 的缓存架构。在反映较慢的情况下，可以考虑在页面显示后，使用另外一个 RPC 来填充数据来解决长时间加载的情况（或者缓存这些数据）。
  * `@Inject` 应该在构造函数中使用，而不是在字段中。例外是 ssh 命令，因为 ssh 命令在 gerrit 的开发过程中完成的比较早。为了保持一致，新的 ssh 命令需要遵从老的模式。
  * 不要让仓库的对象 (git 或 schema) 一直打开。要将每次打开的 A.close() 放到 finally{} 代码块中。
  * 启用 RPC 更新 git 仓库（包括对 notedb 的操作）的时候，不要移除 UI 组件，因为有可能产生新的操作。比如，链接比较慢的时候，有能导致多次的 submit 操作。如果禁用了操作按钮，那么用户则无法再次 submit，并且会看到 gerrit 处于繁忙状态。
  * ... Guava (之前称为 Google Collections) 也是如此。

### Tests

  * 为新代码做一些测试，有助于 change 的合入。

### Change Size/Number of Files Touched

现在，描述一些 change 的大小。通常，越小越好。别把混淆的东西放到一起，因为修改了一个，没有修改另外一个，系统有可能会崩溃。

  * 如果完成了一个新的特性，并且是一个大的特性，可以视图从逻辑上将其切分成几个小特性。如果有问题的话，也是小特性上的问题。
  * 功能中可以进行单独的 bug 修复。bug 修复的评审相对要容易一些，因为不需要特性的评审。如果将新特性和 bug 修复放到一起的话，会使评审变得困难，因为二者没有清晰的界限。
  * 拆分出的小 change 要支持重构。如果新的特性需要重构，那么依赖于小的 change 的重构。
  * 将功能从逻辑上拆分成几个小的 change，有一些难度。例如：添加一个新的功能，如果可以的话，UI 部分和 ssh 命令单独的分开。
  * 代码的修改要和 commit-msg 的描述相吻合。如果发现问题的时候，可以使用 `git revert` 紧急操作，这样可以避免过多的 revert 修改。
  * 可以使用 topic 将单独的 change 联系起来

## Process

### Development in stable branches

稳定的分支是要趋于稳定的。意味着稳定的分支上只做 bug 的修复，但也有如下的例外：

  * 要从稳定分支发布一个新版本的时候，gerrit 社区的维护人员会讨论是否需要将未完成的特性添加到新的版本中，因为新特性阻碍了新版本的发布。如果需要这些新特性，那么新特性需要在第一个候选发布版本前完成。
  * 为了发布一个稳定的版本，有可能会创建几个候选的版本。当生成第一个候选版本以后，稳定分支上不再接受新的特性。如果仍有新的特性需要合入，那么需要 gerrit 社区的维护人员进行讨论，看看对新版本是否有重大的风险。
  * 候选版本完成后，稳定分支只接受 bug 修复和文档的更新。这些更新将在下一个小版本中体现。
  * 对应小版本来说，只有特别重要的特性，gerrit 社区才允许添加。
  * 版本发布者有责任评估新特性的风险，并要根据 gerrit 社区的结论来决定发布时机。
  * 越老的稳定分支，理论上说是更稳定。因为稳定分支只接收 bug 修复和相关的安全更新。

### Backporting to stable branches

有时会在稳定分支上发布 bug 修复版本。

即使在没有新的版本计划的情况下，也鼓励开发人员关注稳定分支，便于修复问题。

稳定分支合入 bug 的修复后，主干分支要对其进行 merge，便于主干上 bug 的修复。

### Finding starter projects to work on

已在问题跟踪系统中创建了一个 [StarterProject](https://bugs.chromium.org/p/gerrit/issues/list?can=2&q=label%3AStarterProject) 目录，用于 gerrit 任务的分配。

### Upgrading Libraries

如果 gerrit 所依赖的 lib 文件有新版本的话，比如添加了新的特性或者修复了 bug ，那么 gerrit 会根据实际情况对所依赖的 lib 文件进行更新。不过也有例外，gerrit 创建出新的 release 分支后，会在主线上把所依赖的 lib 文件都更新到最新的版本，release 分支没有特殊情况的话不进行更新。

### Deprecating features

Gerrit 应该越来越稳定并且值添加永久使用的功能。有时，需要移除不使用的特性用来保持代码的清洁。下面的过程描述了如何从 gerrit 移除不需要的特性：

  * 确认特性不再被任何人使用，或者此特性阻碍了当前的开发进度。
  * 如果提供了一个类似的功能，并将用户迁移到了这个新功能上，那么可以忽略下文。
  * 文档和 releasenotes 中需要标识功能已废除。
  * 如果可以的话，在任何一个用户可见的页面中标识此功能已废除。例如：想要废弃 git push 的某个参数，此时需要为 git 的响应添加一个 message 用来通知用户。
  * 如果可以的话，使用 `@Deprecated` 和 `@RemoveAfter(x.xx)` 注释代码。另外，也可以使用 `// DEPRECATED, remove after x.xx` (其中 x.xx 是版本号)
  * 默认情况下，配置中不要显示废弃的功能。(管理员要关闭已废弃的功能)。
  * 在下一个版本的分支中，移除所废弃功能的相关代码。

可以根据邮件列表，询问特性是否可以废弃。如果没有人使用这个特性，那么特性可以直接在下个版本中移除。

