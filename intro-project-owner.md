# Project-Owner 指南

本文是 Gerrit 的 Project-Owner 指南．主要说明了如何对 project 定制工作流程．

## Project-Owner

project-owner 的职责是在 Gerrit 中管理所在的 project，可以对 `refs/*` 进行权限控制．project-owner 有权限对 project 实施权限控制和一些其他的配置．

project-owner 是 project 的管理员，需要比普通用户具备更多的 Git/Gerrit 相关知识．通常，一个团队有 2-3 名 project-owner 就可以了．

## Access Rights

project-owner 可以编辑所在的 project 的访问控制列表，并且能给不同的群组配置权限．

Gerrit 的权限管理非常灵活，具体配置可以参考 [访问控制](link:access-control.md).

### 编辑 Access Rights

查看 project 的 access-right

* 打开 Gerrit 网页
* 点击菜单 `Projects` > `List` 
* 找到所要查找的 project ,并点击进去
* 然后点击菜单 `Access` 

点击 `Edit` 按钮使其变为可编辑模式，点击 `Save Changes` 按钮可以进行保存．`Commit Message` 输入框中可以填写修改原因，此输入框为非必填．

project 的权限配置存储在 `refs/meta/config`　分支中的 `project.config` 文件. 更多细节可参考 [Project 的配置文件格式](config-project-config.md)．`refs/meta/config` 这个分支的 log 记录了 project 的配置及权限的变更过程，良好的 `Commit Message`　书写规范会更好的记录变更原因．

如果 Gerrit 集成了 gitweb，那么可以直接在网页上查看文件 `project.config` 的修改记录．否则只能 clone 到本地进行查看修改的 log　了，相关命令如下:

```
  $ git fetch ssh://localhost:29418/project refs/meta/config
  $ git checkout FETCH_HEAD
  $ git log project.config
```

非 project-owner 在编辑 access-right 后，可以点击按钮 `Save for Review` 生成一个新的 change ，review 通过后，配置会生效．

### Inheritance

新创建的 project 可以从 parent-project 继承相关的 access-right．Gerrit 上的 project 的继承关系是一个树形的结构，`All-Projects` 默认作为 root-project，每个 project 只能有一个 parent-project ，不能有多个 parent-project ．

project 的网页中，会显示 access-right 权限，如果要查看 parent-project 的信息，可以点击链接: `Rights Inherit From`.

如果设置 `BLOCK-rule` ，被继承的 access-right 会被重载．`BLOCK-rule` 用来限制继承下来的一些权限．如果BLOCK-rule 与继承的权限有冲突，以 BLOCK-rule 权限为准．

如果一些 project 需要相同的权限配置，那么可以在一个共用的 parent-project 中维护 access-right．如果要直接修改 project 的 parent-project，需要联系 Gerrit 的管理员；或者在 project 页面，通过 change 的方式来完成 parent-project 的修改．

### References

权限配置是在references(refs) 上设置的．分支的命名空间是: `refs/heads/`，tags 的命名空间是: `refs/tags/`.另外，还有一些特别的命名空间，可以参考 [访问控制](access-control.md) 的 special 和 magic 章节．

access-right 可以为具体的命名空间配置权限，如：`refs/heads/master` ，也可以用正则表达式配置权限．

ref 如果以 `/*` 结尾，那么此 ref 包含了子目录的所有的命名空间，如： `refs/heads/*` 表示包含所有的分支．

正则表达式必须以 `^` 开头，`^refs/heads/rel-.*` 表明所有以 `rel-*` 开头的分支．

### Groups

access-right 可以通过群组来设置权限，支持 Gerrit 内部的群组并且可以集成 Gerrit　外的群组．

Gerrit 页面点击 `Groups` > `List` 可以查看并编辑内部群组．

Gerrit 内部群组可以包含用户和群组(包括内部群组和外部群组)． 

每个 Gerrit 内部群组需要配置一个 owner-group，此 owner-group 用于管理内部群组相关信息，如：成员，群组信息等．如果 owner-group 是内部群组本身，那么这个群组里的成员可以自行管理群组．当为区分角色建立的不同的内部群组时，这些群组的 owner-group 建议配置成 project 的管理群组．

群组参数: `Make group visible to all registered users.`: Gerrit　用户可以查看此群组．

网页上点击 `Groups` > `Create New Group` 可以新建内部群组，这个权限是受控的，具体可以参考 [访问控制](access-control.md) 的 createGroup 章节．

Gerrit 还有一些系统群组，具体可以参考 [访问控制](access-control.md) 的 `system groups` 章节．

外部群组使用的时候需要加前缀，如：关联 LDAP　群组需要加前缀 `ldap/`.

如果安装了 [plugin:singleusergroup](https://gerrit-review.googlesource.com/admin/repos/plugins/singleusergroup) ，那么可以使用用户帐号直接配置权限．

### Common Access Rights

project 中的不同角色，如：开发人员，评审人员等，需要配置不同的权限．具体可以参考 [访问控制](access-control.md) 的 `role` 章节．

### Code-Review

Gerrit　的主要功能是 code-review 和带有权限控制的 Git 服务器．无论是评审还是直接 push 到代码库，都依赖权限控制．

为了生成 change 需要将 commit push 到 Gerrit 服务器，这个时候，需要有分支 `refs/for/<branch-name>` 的 push 权限.

生成 change 后，不仅会启动 review 流程，而且还会触发 verify　的自动构建．另外，还可以配置 submit 的类型：merge 或 rebase．如果目标分支在服务器上不存在，这时可以直接 push　入到代码库．不要认为 review 过程复杂就可以不做 review 直接将代码 push　到代码库，因为大量经验证明，这很愚蠢．

建议启动 push 的 auto-merge 功能，对代码的回溯是有帮助的．

### Project Options

project-owner　可以控制 project 的一些配置参数．

下列操作可以查看 project 参数:

* 打开 Gerrit 页面
* 点击 `Projects` > `List`
* 找到想要的 project，然后进行点击
* 点击 `General` 

### Submit 类型

submit 类型的选择和 content-merge 的设置是重要的．submit 类型指的是 change 合入到代码库的方式．[content-merge](project-configuration.md) 参见 `Project 配置` 的 `content merges` 章节，只的是 Gerrit 自动解决修改相同文件引起的冲突．(Git的冲突:同时修改同一个文件的同一行；Gerrit的冲突:修改同一个文件)

submit 类型的选择和 content-merge 的设置在保证代码完整的前提下，需要权衡开发过程中的舒适性．

最严格的 submit 类似是 `Fast Forward Only`，可以参考 [Project 配置](project-configuration.md) 的 `fast forward` 相关章节．此种类型要求线性合入，如果一个 change 合入后，这个分支上的其他 change 需要手动执行 rebase 操作后才能合入．显然，这种方式有些麻烦，如果 change 比较少的话，可以考虑此种方式．

最舒适的 submit 类似是 `Merge If Necessary`，尤其是启用 content-merge 的情况下，可以参考 [Project 配置](project-configuration.md) 的 `merge　if　necessary` 相关章节，因为手动执行 rebase 操作和手动解决冲突还是有些麻烦的．不过此类型也有弊端，如:两个 change 分别基于相同的代码做修改了同一个文件，一个 change 移除了某个类，而另一个 change 引用了这个类，如果启用了  content-merge 功能，那么待这两个 change 合入后，整个代码是有问题的．

`Prolog` 可以在不同的分支配置不同的 submit 类型.

其他的 submit 类型可以参考 [Project 的配置文件格式](config-project-config.md) 中的 `submit　type` 章节．

## Labels

code-review 的过程可以理解为对 [change](config-labels.md) 的不同 label 进行打分．Gerrit 默认的 label 只有 `Code-Review` 的打分，`Verified` 的打分需要单独配置，也可以自定义不同的 label，例如：某个 project 需要 IP-team 对 IP 进行确认，这个时候可以为 IP-team 自定义一个 `IP-Review` label　进行打分操作．

label 对 submit 的影响可以自定义．比如：需要最高的打分或者此打分仅用作参考不作为必须．影响可以自定义 submit rule 来实现．

label 需要关注的功能：如果 change 有了新的补丁，会自动复制打分，可以参考 [Labels 配置](config-labels.md) 的　copyAllScoresOnTrivialRebase　和 copyAllScoresIfNoCodeChange 相关章节．

### Submit Rules

submit-rule 是从逻辑角度来定义 change 什么时候可以被合入．默认情况下 change 的合入需要每个 label 有最高得分，没有最低得分．可以参考 [Prolog 说明](prolog-cookbook.md) 的 `submit rule` 部分．

submit-rule 可以根据 [Prolog 说明](prolog-cookbook.md) 来实现，并且每个 project 可以自定义 submit-rule，具体可以参考 [Prolog 说明](prolog-cookbook.md).

参考 [prolog 与 Change 的关系](prolog-change-facts.md) 会方便对 submit-rule 的测试．使用 prolog 方式定义 submit-rule 需要修改配置文件，此文件是受控的． 

submit-type 可以通过 Prolog 来实现，可以参考 [Prolog 说明](prolog-cookbook.md) 的 `SubmitTypePerBranch` 部分．

submit-rule 在文件 rules.pl 中进行维护，此文件所在 project 的分支为 `refs/meta/config`. 如何编写 submit-rule 可以参考 [Prolog 说明](prolog-cookbook.md) 的 `HowToWriteSubmitRules` 和 

## CI

CI 不仅仅可以更新代码库中的代码，也可以为 code-review 打分．在 change 合入代码库之前，可以使用 CI 对 change 进行自动化的构建和测试．通常 CI 会对 Verified 进行打分．

下面是与 Gerrit 集成的 CI 工具:

 * [Jenkins](http://jenkins-ci.org/) 的 plugin: [Gerrit Trigger](https://wiki.jenkins-ci.org/display/JENKINS/Gerrit+Trigger)

 * [Zuul](http://www.mediawiki.org/wiki/Continuous_integration/Zuul) 与 [Jenkins](http://jenkins-ci.org/)

CI 系统与 Gerrit 的集成需要 service-user ，service-user　用于访问 Gerrit. 可以通过 SSH 命令来创建 service-user，具体可以参考 [创建用户](cmd-create-account.md)．创建用户的权限可以在 global-capability 进行设置，或者联系管理员进行创建．

如果安装了 plugin: [serviceuser](https://gerrit-review.googlesource.com/admin/repos/plugins/serviceuser) ，那么可以在网页上创建 service-user，`People` > `Create Service User`. 

service-user　需要有代码读的权限，以及 Verified 打分权限．

CI 系统需要监听 Gerrit 的 stream-events，所以 service-user　还需要 `Stream Events` 的权限，可以参考 [访问控制](access-control.md) 的 `streamEvents` 章节．

## Commit Validation

Gerrit 可以对 [新的 commit 进行校验](https://gerrit-review.googlesource.com/Documentation/config-validation.html)，Gerrit 有 plugin 可以实现此功能，安装此 plugin 后，如果客户端推送 commit 失败，会有相关的提示信息．

相关 plugin 如下:

 * [uploadvalidator](https://gerrit-review.googlesource.com/admin/repos/plugins/uploadvalidator):

`uploadvalidator` 可以用来检验 commit 中被修改的文件等

 * [commit-message-length-validator](https://gerrit-review.googlesource.com/admin/repos/plugins/commit-message-length-validator)

The `commit-message-length-validator` 用来校验 commit-msg 长度

## Branch 管理员

project-owner 可以在网页上管理 project 的分支， `Projects` > `List` > <your project> > `Branches`，比如：创建分支，删除分支等，这些操作需要有对应的权限．

`HEAD` 为 project 的默认分支，clone 后，本地会根据默认分支检出相关文件．

## Email 通知

网页上 watch-project 后，可以选择相关事件接收通知邮件， `Settings` > `Watched Projects` ．change 的邮件通知可以参考 [changes 搜索](user-search.md) 的规则进行过滤．

如果 project-owner 让团队成员配置 watch 后，project-owner 就不用总发邮件来提醒大家了．

project-owner 可以为团队成员设置邮件提醒，在 `refs/meta/config` 分支的  `project.config` 文件中进行配置，可以参考：[邮件订阅](user-notify.md) 的 project 章节．

## Dashboards

Gerrit 为用户提供了 change 的相关 dashboard . 用户可以自定义 [Dashboards](user-dashboards.md).　project-owner　可以定制 project 层级的 dashboard 并分享给相关用户． `Projects` > `List` > <your project> > `Dashboards`.

## Issue-Tracker Integration

Gerrit　与 Issue-Tracker-Integration 的集成点：

 * Comment Links

comment-link 用来将 commit-msg 与 Issue-Tracker 系统中的 IDs 相链接．

 * Tracking IDs

Gerrit 可以将 commit-msg 底部的 IDs 添加到 index，然后就可以像搜索 change 一样搜索 IDs 了．可以参考 [系统配置](config-gerrit.md) 的 `tracking IDs` 章节．

 * Issue Tracker System Plugins

plugin 与 Issue-Tracker 相关系统的集成:
[Jira](https://gerrit-review.googlesource.com//admin/repos/plugins/its-jira),
[Bugzilla](https://gerrit-review.googlesource.com/admin/repos/plugins/its-bugzilla) 和
[IBM Rational Team Concert](https://gerrit-review.googlesource.com/admin/repos/plugins/its-rtc).
如果安装了 plugin，会自动的为 change 中的 IDs　链接到 Issue-Tracker 相关系统，或者当 change 关闭的时候自动关闭 Issue-Tracker 系统中的问题．安装 plugin 后，可以在页面启动或者关闭与 Issue-Tracker 系统的集成， `Projects` > `Lists` > <your project> > `General`.

## comment-link

Gerrit 可以为 commit-msg, summary comments 和 inline comments 中的字符串添加链接．字符串会按照预先定义的表达式规则进行匹配，然后高亮显示并添加超链接．

comment-link 可以全局配置，也可以按 project 层级配置．project 层级的 comment-link　在 `refs/meta/config` 分支  `project.config` 文件中进行配置，可以参考 [系统配置](config-gerrit.md) 的 `commentlink` 章节．

comment-link 用来将 commit-msg 中的 ID 与 Issue-Tracker 系统的 ID 相关联．如：commit-msg　底部的 `Bug` 信息与 Jira　系统相关联：

```
  [commentlink "myjira"]
    match = ([Bb][Uu][Gg]:\\s+)(\\S+)
    link =  https://myjira/browse/$2
```

## Reviewers

一般来说不需要详细地为每个 change 手动添加评审人员，因为开发人员 watch project 后，对应的 project 的 change 如果有变化的话都会收到相关邮件通知．

如果 change 的作者需要特殊的人员帮忙 review ,那么可以手动的将其添加到评审人员列表中，添加后，Gerrit 会给此评审人员发邮件提醒．

plugin: [reviewers](https://gerrit-review.googlesource.com/admin/repos/plugins/reviewers) 可以为 change 添加默认的评审人员．安装此 plugin 后，可以在网页 `reviewers Plugin` 部分进行配置． `Projects` > `List` > <your project> > `General`

plugin:[reviewers-by-blame](https://gerrit-review.googlesource.com/admin/repos/plugins/reviewers-by-blame) 基于 [git blame](https://www.kernel.org/pub/software/scm/git/docs/git-blame.html) 为 change 自动添加评审人员．plugin 先识别出文件修改处的作者，然后将作者自动添加到评审人员列表．安装此 plugin 后，可以在网页 `reviewers-by-blame Plugin` 部分进行配置． 

## Download Commands

change 页面中的 `Downloads` 下拉菜单，可以查到当前 patch-set 的下载命令．

下载命令的显示依赖于 plugin 的安装:

 * [download-commands](https://gerrit-review.googlesource.com/admin/repos/plugins/download-commands) plugin:

　`download-commands` plugin 用于显示默认的下载命令，如：`Checkout`, `Cherry Pick`, `Format Patch` 和 `Pull`.
　
　Gerrit 管理员可以配置 change 页面的下载命令显示．

 * [project-download-commands](https://gerrit-review.googlesource.com/admin/repos/plugins/project-download-commands) plugin:

　`project-download-commands` plugin 用于显示 project-specific 的下载命令．例如：此命令可以用来更新代码，触发构建，执行测试，或者部署环境．

　project-specific 下载命令需要在 `refs/meta/config` 分支的  `project.config` 文件中进行配置：
　
```
  [plugin "project-download-commands"]
    Build = git fetch ${url} ${ref} && git checkout FETCH_HEAD && bazel build ${project}
    Update = git fetch ${url} ${ref} && git checkout FETCH_HEAD && git submodule update
```

　Project-specific 下载命令的定义可以被继承．child-project 可以覆盖或者移除此下载命令．

## 与其他工具的集成

Gerrit 可以与一些工具集成:

 * Stream Events:

　使用 SSH 命令可以监听 Gerrit 的 [stream-events](cmd-stream-events.md) ．其他工具可以使用此命令来实现一些功能．

　`stream-events` 命令需要配置特殊权限，具体可以参考 [访问控制](access-control.md) 的 `Stream Events` 章节.

 * REST API:

　Gerrit 有丰富的 [REST API](rest-api.md) ，其他工具可以调用并实现一些功能．

 * Gerrit Plugins:

　Gerrit 可以通过 plugin 实现一些扩展功能：

　** 添加菜单，参考 [Plugins 开发](pg-plugin-admin-api.md) 的相关章节
　** 添加页面，参考 [Plugins 开发](pg-plugin-dev.md) 的相关章节
　** [检验](config-validation.md), 如：新的 commits
　** 添加新的 REST API 和 SSH　命令

　[Plugins 开发](dev-plugins.md) 描述了如何开发 plugin．

## Project 的生命周期

### 创建 Project

在 Gerrit　页面上依次点击 `Projects` > `Create Project` 可以创建 project. `Create Project` 受权限控制，可以在 `global capability` 中进行配置．也可以通过 REST 或者 SSH 命令进行创建．

创建 project 时，推荐要有初始化的 empty-commit，因为有些工具 clone 的时候认为没有 commit 的 project 是有问题的．如果要进行 import 操作的话，那么新建的 project 不需要 empty-commit．

### 其他版本工具向 Git 的迁移

其他版本工具如果要向 Git 迁移，不仅要迁移代码，而且要把历史记录进行迁移．下面是其他版本工具与 Git 的关系描述，如：VCS 到 Git 的集成，[Git 与 SVN](http://git-scm.com/book/en/Git-and-Other-Systems-Git-and-Subversion)，[SVN 到 Git 的集成](http://git-scm.com/book/en/Git-and-Other-Systems-Migrating-to-Git)，[Git 与 p4](http://git-scm.com/docs/git-p4)，[p4 到 Git 的集成](http://git-scm.com/book/en/Git-and-Other-Systems-Migrating-to-Git)．

其他版本工具如果要向 Git 迁移时，可以不做 code-review 直接向 Gerrit 推送代码．

迁移的时候，Gerrit 服务器需要配置 `Forge Committer`，可参考 [访问控制](access-control.md) 的 `Forge Committer` 章节．如果不配置 `Forge Committer`，可以使用命令
[git filter-branch](https://www.kernel.org/pub/software/scm/git/docs/git-filter-branch.html) 对所有的 commit 重新生成 committer 等信息，不过 commit 的 author　相关信息会保留，但签名的一些信息会丢失．

```
  $ git filter-branch --tag-name-filter cat --env-filter 'GIT_COMMITTER_NAME="John Doe"; GIT_COMMITTER_EMAIL="john.doe@example.com";' -- --all
```

如果 [系统配置](config-gerrit.md) 了 `max object size limit`，那么需要移除 `large objects`　后在进行推送．可以使用脚本 `reposize.sh` 在历史记录中找到 `large objects`:

```
  $ curl -Lo reposize.sh http://review.example.com:8080/tools/scripts/reposize.sh

or

  $ scp -p -P 29418 john.doe@review.example.com:scripts/reposize.sh .
```

可以使用 [git filter-branch](https://www.kernel.org/pub/software/scm/git/docs/git-filter-branch.html) 命令从分支的历史记录中移除 large objects :

```
  $ git filter-branch -f --index-filter 'git rm --cached --ignore-unmatch path/to/large-file.jar' -- --all
```

由于这个命令会重写分支上所有的 commit．

### 删除 Project

Gerrit 的核心功能不支持删除 project 操作，不过可以通过 [plugin:delete-project](https://gerrit-review.googlesource.com/admin/repos/plugins/delete-project) 来实现此操作．plugin:delete-project 安装后，在网页上点击:　`Projects` > `List` > <project> > `General` > `Delete`．`Delete Projects` 权限需要在 global-capability 中进行配置．Gerrit　管理员有 global-capability 的编辑权限．

如果不想删除 project ，可以把 project 的状态设置为 `ReadOnly` 或者`Hidden`，具体操作可以参考 [Project 配置](project-configuration.md) 的 state 相关部分．

### Project 的重新命名

Gerrit 的核心功能不支持删除 project 的重新命名操作.

如果安装了 plugin:[rename-project](https://gerrit-review.googlesource.com/admin/repos/plugins/rename-project), project 可以通过 ssh 命令 [rename-project](https://gerrit.googlesource.com/plugins/rename-project/+/refs/heads/master/src/main/resources/Documentation/cmd-rename.md) 对 project 进行重命名。

相关说明可以参考：[plugin 说明](https://gerrit.googlesource.com/plugins/rename-project/+/refs/heads/master/src/main/resources/Documentation/about.md).

如果不使用 `rename-project plugin`，可以按照下面操作来实现重命名:

* 用新名字创建 project
* 将老的 project 的 history 导入到新的 project 
* 删除老的 project

不过这个方法有弊端，会丢失 review 的记录，如：changes, review comments 等．


