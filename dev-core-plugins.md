# Gerrit Code Review - Core Plugins

## 什么是 core plugins?

Core plugins 默认打包在 Gerrit 的 war 文件中。在进行 [Gerrit 安装](pgm-init.md) 的时候可以方便安装 core plugin，并且无需下载相关文件。

core plugins 在 gerrit project 中的[列表](https://gerrit.googlesource.com/gerrit/+/refs/heads/master/.gitmodules) ，这样可以方便与 gerrit 的源码下载。

core plugins 的开发维护可以参考 [Gerrit maintainers](dev-roles.md)，并且每个人都可以向社区进行[贡献](dev-contributing.md)。

增加 core plugin 新的 feature 是一项繁琐复杂的工作，因此需要参考一些文档：[涉及文档](dev-design-doc.md) 及 [开发说明](dev-contributing.md)。[engineering steering committee (ESC)](dev-processes.md) 是 gerrit 的权威组织，负责添加和移除 core plugin。

非 Gerrit 维护人员不能拥有 core plugin 的 [Owner](access-control.md) 权限。

## core plugins 有哪些?

参考[plugin 配置](config-plugins.md) 的 core-plugins 相关部分。

### Core Plugins 的标准

core plugin 需要满足下列标准：

1. License:

使用 [Apache License Version 2.0](http://www.apache.org/licenses/LICENSE-2.0) License 。

2. Hosting:

plugin 的源码存放在 [gerrit-review](https://gerrit-review.googlesource.com) 。

3. Scope:

plugin 的功能不能与现存的 core plugin 功能冲突，不能与 gerrit 计划的核心功能冲突。

4. Relevance:

plugin 的功能与 Gerrit 社区是强关联的:

   ** plugin 不需要额外安装，在 gerrit 进行安装的时候可以方便使用。
   ** 大多数的 gerrit 使用人员需要此功能。
   ** plugin 已被 gerrit 社区的相关人员广泛使用。
   ** 如果此 plutin 的功能与其他 plugin 的功能重复，此 plugin 需要 gerrit 社区的推荐才可以成为 core plugin。

plugin 是否与 Gerrit 社区是强关联的，需要进行讨论，如果有异议，需要 [engineering steering committee (ESC)](dev-processes.md)进行裁决。

5. Code Quality:

plugin 的代码是成熟稳定的，并且满足相关的测试要求。对于代码维护来说，不需要大量的修改。

6. Documentation:

plugin 的功能要有详细的文档说明。

7. Ownership:

plugin 的所有者如果不是 Gerrit 的维护人员，需要放弃代码的所有权。如果 plugin 的所有者不同意，可以尝试 fork 代码的方式来解决。

## 如何成为 core plugin

任何人都可以将 plugin 申请为 core plugin，但 plugin 需要满足上面所描述的标准。

1. core plugin 的申请:

按照模板填写 [Core Plugin 请求](https://bugs.chromium.org/p/gerrit/issues/entry?template=Core+Plugin+Request)。

2. Community Feedback:

任何人都可以对申请进行回复。对于发现的问题，至少需要保留 10 天才能关闭，目的是让更多的人来了解此 plugin。

3. ESC Decision:

ESC 可以向申请人或评论人提供更多的信息，用来做相关的决策。

任何的决策需要基于上面描述的标准来完成。

如果有人对 plugin 发布 issue 的话，那么至少 10 天以后，才能接受相关的申请。

ESC 评审过程中发现的问题需要添加到 issue 中。

如果申请被拒绝，有可能是上面的 Relevance 不满足导致的。

4. 成为 core plugin:

如果申请被接受，那么 gerrit 的维护人员会将其添加到 core plugin 中：

   ** 将 plugin 的代码存放在[gerrit-review](https://gerrit-review.googlesource.com/).
   ** 确保 plugin 的 project 继承于 [Public-Plugins](https://gerrit-review.googlesource.com/admin/repos/Public-Plugins)
   ** 移除 plugin 已配置的所有所有权限，因为需要使用已经继承的 project 的权限。
   ** 在 [Monorail](https://bugs.chromium.org/p/gerrit/adminComponents) 上面为 plugin 创建新的 component，并对此 plugin 标识已经发现的 issue。
   ** plugin 添加到 [Git submodule](https://gerrit.googlesource.com/gerrit/+/refs/heads/master/.gitmodule) 中。
   ** [plugins.bzl](https://gerrit.googlesource.com/gerrit/+/refs/heads/master/tools/bzl/plugins.bzl) 中注 register 此 plugin。
   ** 发布此 plugin 的[project 信息](https://www.gerritcodereview.com/news.html) 。

### Removing Core Plugins

下列情况 core plugin 会被移除：

1. 不尊重 license:

plugin 代码或者所使用的 libraries 不再遵循 `Apache License Version 2.0`

2. 功能越界:

plugin 功能超出了 Gerrit 的相关范围，或者与现有的 core plugin 功能相冲突，或与 Gerrit 的核心功能相冲突。

**NOTE:**
*plugin 会一直保留，直到执行可取代的方案。*

3. 功能不相关:

plugin 的功能与 Gerrit 的功能不相关:

   ** Gerrit 有了 plugin 提供的功能。
   ** plugin 不被广泛使用。
   ** 多个组织废弃使用某个 plugin，并同意从 core plugin 中移除。
   ** 功能与其他 plugin 冲突，并且没有特殊的推荐使用理由。
   ** plugin 的功能偏离了 Gerrit 的发展方向。

4. 代码质量降低:

plugin 的代码维护不及时，并且测试力度不够。

5. 文档不及时维护:

plugin 的文档不能正确描述其功能。

