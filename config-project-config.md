# Gerrit Code Review - Project Configuration File Format

此章节描述了 project 的配置文件的格式以及访问链接的模型。

网页对 project 所配置的权限，都保存在配置文件中，这个文件在 project 的 `refs/meta/config` 分支下。可以直接修改这个配置文件，然后推送到服务器。

## The refs/meta/config namespace

此分支下存放了 3 中类型的文件，不同的文件对应了不同的权限模型。如果有此分支的读权限，可以将此分支下载到本地。和其他分支一样，可以对此分支上传 commit 并对其评审。如果要用工具自动更新权限的话，需要帐号有 `refs/meta/config` 分支的直接 push 权限。

## Property inheritance

如果 project 的属性中设置了 `INHERIT`，那么父 project 的配置可以继承并直接使用了。如果在父 project 中没有设置此属性，那么此属性的默认值是 `FALSE`。

## The file project.config

`project.config` 文件包含了群组的权限配置信息和所继承的 project 信息。

此文件的格式与 `Git config` 的文件格式是一致的，因此可以使用 `git config` 命令对此文件进行写入。

下面是 `git config` 命令的用法：

```
$ git config -f project.config project.description "Rights inherited by all other projects"
```

下面是 `project.config` 文件的格式：

```
[project]
       description = Rights inherited by all other projects
[access "refs/*"]
       read = group Administrators
[access "refs/heads/*"]
        label-Your-Label-Here = -1..+1 group Administrators
[capability]
       administrateServer = group Administrators
[receive]
       requireContributorAgreement = false
[label "Your-Label-Here"]
        function = MaxWithBlock
        value = -1 Your -1 Description
        value =  0 Your No score Description
        value = +1 Your +1 Description
```

从上面可以看出，文件主要有几个部分组成。

每个 project 只有一组 `project` section 的信息，不能有多组。

每个 reference ，如  `refs/*` `refs/heads/*` 只能对应一组 `access` section。

每个 project 只有一组 `receive` section 的信息，不能有多组。

每个 project 只有一组 `submit` section 的信息，不能有多组。

`capability` section 只能在 `All-Projects` 中进行配置，并且只能有一组信息，此属性是属于服务器 project 的全局配置。

`label` section 可以配置多组，如：`Code-Review` `Verified`。

`commentlink` section 可以添加自定义的 project 配置的链接。project.config 与 gerrit.config 的 `commentlink` section 的格式是一致的。

### Project section

project section 包括了 project 的配置信息。

相关的 key 如下:

**description**

 project 的描述。

state:

 用来设置 project 的状态，一个 project 有下面几个状态：

    `Active`:

        project 处于激活状态，用户可以访问并可以根据权限配置来对 project 进行修改。

    `Read Only`:

        project 处于只读状态，禁止所有的修改操作，即使有 push 权限，在 push 的时候也会报错。

        如果把状态设置为 `Active` ，那么就又可以对 project 进行修改了。

    `Hidden`:

        project 处于隐藏状态，只有管理员和 project owner 可以访问，即使其他用户有读权限服务器上也看不到此 project。

### Receive section

receive section 包括了 receive 相关的配置。

**receive.requireContributorAgreement**

 上传的 commit 中是否包含完整的贡献者声明。默认属性值是 `INHERIT`。如果 `All-Project` 启用了这个参数，某个 project 若不需要启用的话，需要将值设置为 false。若要启用此参数，需要先在 gerrit.config 文件中配置 `auth.contributorAgreements`。

**receive.requireSignedOffBy**

Sign-off 可以在 project 中进行配置使用，例如 Linux kernel 使用这个功能。Sign-off 是 commit-msg 中结尾的一行信息，此信息描述了谁是这个 commit 作者。Sign-off 的主要用途是用来跟踪 commit 的作者是谁。此处的默认值是 `INHERIT`，属性值从父 project 继承。

**receive.requireChangeId**

`Require Change-Id in commit message` 选项描述了待评审的 commit 的 commit-msg 底部中是否需要 [change-id](user-changeid.md)。如果设置了需要 `change-id`，那么 gerrit 会对 commit 进行校验，如果没有 `change-id` 的话，会报错：[missing Change-Id in commit message footer](error-missing-changeid.md)。

建议启用这个参数并且应用 `commit-msg hook` (或者类似 EGit 的其他工具) 来自动生成 Change-Id。如果使用这种方法的话，那么在对 change 重新工作、rebase 操作和更新 patch-set 的时候会方便一些。

如果没有启用这个设置，commit 上传的时候是不会对 change-id 进行校验的，但更新 patch-set 的时候，需要手动在 commit-msg 中插入 change-id。

此处的默认值是 `INHERIT`，意味着属性值从父 project 继承下来。全局的默认值为 `true` 。

此参数目前已废弃，因为在当前 gerrit 版本及以后版本中，此参数的全局的默认值为 `true` 。

**receive.maxObjectSizeLimit**

gerrit receive-pack 时，接收 Git object 大小的最大值。如果 object 大小超过了上限，那么 commit 会被 gerrit 拒绝。如果把值设置为 0 ，那么系统将不做大小的检验。

project-owner 可以在 project 中设置这个参数。同样，可以在 `gerrit.config` 文件中设置 `receive.maxObjectSizeLimit` 来做全局配置。

此处，project 中 `project.config` 文件的设置值不能高于 `gerrit.config` 文件中的设置值。

如果在全局设置中启用了 `receive.inheritProjectmaxObjectSizeLimit` 设置，那么 project 会从父 project 继承这个值。否则，不会被继承。

默认值是 0。

支持的单位为 k, m, g 。

**receive.checkReceivedObjects**

此参数用来控制是否启用 JGit 对 receive object 的校验。

默认，gerrit 会对接收的 object 做校验。如果将变量设置为 `false`，那么系统不会对接收的 commit 进行校验。

若要把所谓不好的历史记录推送到 gerrit 的代码库，那么可以把参数设置为 `false`，这样，gerrit 就不会对 commit 做校验了。

默认值是 `true`, `false` 会取消对 object 的检验。

**receive.enableSignedPush**

是否在 project 中启用 server-side signed。可参考 [系统配置](config-gerrit.md) 中 `receive.enableSignedPush` 相关章节。

此处的默认值是 `INHERIT`，属性值从父 project 继承。

**receive.requireSignedPush**

此参数同 `receive.enableSignedPush`。

此处的默认值是 `INHERIT`，属性值从父 project 继承。

**receive.rejectImplicitMerges**

用来控制是否拒绝 `implicit merge`。如果设置为 `true`，那么 gerrit 将拒绝含有 `implicit merge` 的推送。

此参数只对 non-merge commit 进行校验。

此处的默认值是 `INHERIT`，属性值从父 project 继承。

**receive.createNewChangeForAllNotInTarget**

`create-new-change-for-all-not-in-target` 参数为 merge 操作提供了便利，因此在本地分支与目的分支没有公共父节点的情况下可以创建新的 change。

如果推送的最新节点是 merge 节点，那么此参数不会对此节点校验。

### Change section

change section 包括了对 change 的一些设置：

**change.privateByDefault**

新的 change 是否自动默认设置为 `private` 状态。

`private` 的相关操作可以参考 [上传 changes](user-upload.md) 的相关章节。

此处的默认值是 `INHERIT`，属性值从父 project 继承。

**change.workInProgressByDefault**

新的 change 是否自动默认设置为 `WIP` 状态。

`WIP` 的相关操作可以参考 [上传 changes](user-upload.md) 的相关章节。

此处的默认值是 `INHERIT`，属性值从父 project 继承。

### Submit section

submit section 包括了对 submit 的详细设置：

**submit.mergeContent**

当有冲突的时候，是否进行自动的合入操作。有效值为：'true', 'false', 'INHERIT'。默认值为：'INHERIT'。此参数可以通过下面操作修改：`Browse`> `Repositories` > my/project > `Allow content merges`.
 
**submit.action**

submit 的方式。有效值为 'fast forward only', 'merge if necessary', 'rebase if necessary', 'rebase always', 'merge always', 'cherry pick'。默认值为 'merge if necessary'。
 
**submit.matchAuthorToCommitterDate**

是否将 author 时间修改为 commit 的合入时间，这样 git log 默认会按合入时间对 commit 节点进行排序。有效值为 'true', 'false', 'INHERIT'。默认值为 'INHERIT'。建议在 `Cherry Pick`, `Rebase Always`, `Rebase If Necessary` 情况下启用此参数。

**ubmit.rejectEmptyCommit**

change 合入的时候是否拒绝 empty commit。上传 commit 的时候，并不少 empty commit，但由于执行 rebase 操作后，有可能使其变成 empty commit，此时如果将参数设置为 'true'，那么合入就会失败。分支的初始节点若是 empty commit，此种场景不受限制。

#### Submit Type

'submit.action': change 合入的方式。

如下操作可以进行修改：`Browse` > `Repositories` > my/project > 'Submit type'。
通常，合入的时候会把所依赖的 change 都进行合入，下面是例外情况：

下面的 submit 类型可以按照实际情况进行配置：

* Inherit

新创建 project 的默认参数为 `inherit`，此默认参数可以通过全局设置 `defaultSubmitType` 进行修改。

Inherit 意味着继承 parent 的配置。`All-Projects` 中，配置的是 `Merge If Necessary`。

* Fast Forward Only

对于此方法，合入的时候 Gerrit 不会生成 merge 节点。merge 是可以合入的，不过需要在客户端生成后，经过评审才能合入。

为了合入 change, change 必须是目的分支的超集。
 
* Merge If Necessary

change 在非 fast-forwarded 情形下，合入的时候会生成 merge 节点。
 
* Always Merge

change 合入的时候就会生成 merge 节点。

* Cherry Pick

合入的时候执行 cherry-pick 操作，生成一个新的 commit。

合入的时候，gerrit 会自动在 commit-message 的尾部添加 change 的评审信息及 change 的链接；commit的信息中，committer 的信息会修改为 submitter 的信息，author 的信息不变。

此类型合入的时候会忽略所依赖的 change，除非启用了 `change.submitWholeTopic` 配置。如果多个 change 有依赖的关系，需要注意 change 的合入顺序。

* Rebase If Necessary

change 在非 fast-forwarded 情形下，合入的时候会进行 rebase 操作。

* Rebase Always

与 `Rebase If Necessary` 类似，不过合入的时候会生成一个新的 patchset，此 patchset 的 footer 和 `Cherry Pick` 的 footer 类似。

因此，`Rebase Always` 与 `Cherry Pick` 类似，但 `Rebase Always` 不会忽略所依赖的 change。

### Access section

access section 包含了 reference 的权限设置。配置权限时所涉及的群组，需要在 +groups+ 文件中有记录。

可参考 [访问控制](access-control.md) 的 `Access Categories` 章节。

### MIME Types section

`mimetype section` 的设置可以强制代码评审页面通过文件路径返回某些 MIME types。MIME types 可以使语法高亮。

```
[mimetype "text/x-c"]
  path = *.pkt
[mimetype "text/x-java"]
  path = api/current.txt
```

### Capability section

只能配置一组 +capability+ 信息，并且只能在 +All-Projects+ 中进行配置。此配置涉及到 gerrit 的全局配置。

可参考 [访问控制](access-control.md) 的 `Global Capabilities` 章节。

### Label section

请参考 [Custom Labels](config-labels.md) 相关章节。

### branchOrder section

定义了向其他分支移植 chaneg 的时候，待选分支的排列顺序。

**branchOrder.branch**

branch 名称，可以有多个值。此处的排序决定了待选分支的排列顺序。如：

```
[branchOrder]
  branch = master
  branch = stable-2.9
  branch = stable-2.8
  branch = stable-2.7
```

`branchOrder` section 可以被继承，这样的话，project 可以安装同一个规则来的分支进行排序。子 project 可以重载父 project 中的 `branchOrder` section。例如，将子 project 的 `branchOrder` 清空，那么就会取消继承。

section 中没有列出的分支不会做 mergeability 检查。如果 `branchOrder` section 没有定义，此时不会做 change 合入其他分支的 mergeability 检查。

### reviewer section

用于辅助评审，如：配置默认的评审人员，发送邮件等。

**reviewer.enableByEmail**

有效值为 `TRUE`，`FALSE`。此参数可以指定非注册用户为评审人员，可以给非注册的邮箱发送信息。

此设置仅适用于匿名用户可访问的 change。

默认值是 `INHERIT`, 从父 project 继承。如果父 project 都没有设置，那么默认值是 `FALSE`。

## The file groups

文件中的每个 group 都有一个 UUID 进行标识，因此对群组更名后，不用手动更新 `groups` 文件，系统会自动进行更新。

下面是 `All-Projects.git` 中默认的 `groups` 文件：

```
# UUID                                         Group Name
#
3d6da7dc4e99e6f6e5b5196e21b6f504fc530bba       Administrators
global:Anonymous-Users                         Anonymous Users
global:Change-Owner                            Change Owner
global:Project-Owners                          Project Owners
global:Registered-Users                        Registered Users
```

此文件不能通过 `git config` 命令写入。

当手动更新 `project.config` 文件的时候，要确保此文件中的 group 名称在 `groups` 文件中存在，否则 gerrit 会拒绝更改。

群组的 UUID 可以在群组的网页上查询或者命令行 [the +ls-groups+ SSH command](cmd-ls-groups.md) 添加参数 `-v` 进行显示。

## The file rules.pl

`rules.pl` 文件可以取代默认的 prolog，或者为 prolog 增加一些规则。

可以参考 [Prolog 说明](prolog-cookbook.md)。


