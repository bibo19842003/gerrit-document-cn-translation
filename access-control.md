# Gerrit Code Review - Access Controls

在 gerrit 中，访问控制是基于群组来实现的。配置权限时，只能为群组配置权限。

要查看或者编辑某个具体 project 的访问控制的配置，需要先进入这个 project 的页面，如：`https://gerrit-review.googlesource.com/admin/repos/` 。然后点击 `Access` 链接，如：
`https://gerrit-review.googlesource.com/admin/repos/gerrit,access`，这个时候就可以查看或者编辑了。

## System Groups

Gerrit 有以下默认的系统群组：

* Anonymous Users
* Change Owner
* Project Owners
* Registered Users

系统群组被赋予了特殊的权限控制。


### Anonymous Users

所有的用户默认都在这个系统提供的群组里，包括注册和未注册的用户。

管理员和 project-owner 可以给这个群组添加 change 的访问权限，添加后，用户不需登录系统就可以进行访问。除了读权限以外，其他的权限需要都需要进行认证。

### Project Owners

可以对具体的 project 做权限控制。

管理员可以在 `All-Projects` 中做一个基础的权限配置，然后 project-owner 根据实际情况在具体的 project 中做一些权限的定制扩展。


### Change Owner

此群组可以用作对 change 的评估，可以给 change 打分，但打分不影响 change 的最终合入。

### Registered Users

所有登录过系统的用户，默认在此系统群组中。

Registered users 如果有 `Read` 权限，那么可以对相应的 change 发表评论。

## Predefined Groups

Predefined groups 与 system groups 不同，predefined groups 在 gerrit 初始化的时候系统创建的，并且有唯一的 UUIDs；不同的初始化目录，UUIDs 也是不一样的。

Gerrit 有两个 predefined groups:

* Administrators
* Non-Interactive Users


### Administrators

管理员群组，默认被赋予了 'Administrate Server' 权限，可以进行权限配置。

即使用户在管理员群组中，如果没有 'Administrate Server' 权限，那么还是没有管理员权限。

### Non-Interactive-Users

gerrit 初始化的时候，系统默认给 `Non-Interactive Users` 添加了 'Priority BATCH' 和 'Stream Events' 权限。

此群组中的用户不能在网页上做相关操作，只能通过命令行进行操作。

`Non-Interactive Users` 与 `interactive users` 的线程池是分开的，互相独立的。

一般来说，CI 帐号需要添加到 `Non-Interactive Users` 群组，如果 CI 帐号使用的线程较多的话，不会影响 `interactive users` 的正常使用。

如果帐号同时在 `Non-Interactive Users` 和 `interactive users` 群组中，那么把此帐号视为 `interactive users` 。

## Account Groups

Account groups 可以包含 0 个或多个成员，群组 owner 可以添加和删除人员或群组。

每个群组都有一个 owner 群组，owner 的权限如下：

* 向群组添加用户或群组
* 从群组删除用户或群组
* 更改群组名称
* 更改群组描述
* 更改 owner 群组

允许将 owner 群组设置为自身群组，这样群组成员可以自己管理群组。

对于新创建的群组，系统会自动将 owner 设置为自身群组，并把群组创建人添加到群组中。这样的话，群组的创建人就可以自行添加成员，更改群组描述及 owner 了。

有时，同时会创建两个群组，如：`Foo` 和 `Foo-admin`，`Foo-admin` 分别是 `Foo` 和 `Foo-admin` 的 owner 群组。`Foo-admin` 成员可以控制 `Foo` 群组中的成员，但没有 `Foo` 群组的访问控制权限。

## LDAP Groups

LDAP groups 属于 Account Groups 并在 LDAP 系统中进行维护。LDAP groups 不会在 gerrit 中直接出现，加上前缀 "ldap/" 后，就可以在 gerrit 中使用了。如 LDAP groups `foo-project`，加前缀后的名称为 `ldap/foo-project`。

## Project Access Control Lists

全局的访问控制权限可以在 `All-Projects` 中进行配置。project 间的继承关系可以通过命令 [gerrit set-project-parent](cmd-set-project-parent.md) 来实现。

每个 project 可以按需求进行单独的权限配置。

用户可以根据权限设置来对打分项进行打分。如，用户是 `Foo Leads` 群组成员，并且在 project 中配置了如下权限：

|Group           |Reference Name |Label      |Range|
| :------| :------| :------| :------|
|Anonymous Users |refs/heads/*   |Code-Review|-1..+1|
|Registered Users|refs/heads/*   |Code-Review|-1..+2|
|Foo Leads       |refs/heads/*   |Code-Review|-2..0|

上表中，如果打分范围是 `-2..+2`，那么 `Registered Users` 群组可以打最高分，`Foo Leads` 可以打最低分。

同样，也可以在 reference 层级上做权限控制。

可以为单一的 reference 进行权限配置，如：`refs/heads/master`，或者可以按 reference 的命名空间来配置权限，如：`refs/heads/*`。`refs/heads/*` 会包含下面的所有 reference :`refs/heads/master`, `refs/heads/experimental`, `refs/heads/release/1.0` 。

reference 名称可以用正则表达式，不过要以 `^` 开头。如：`^refs/heads/[a-z]{1,8}` ，会匹配长度上限为 8，字符类型为小写字符的分支名称。正则表达式中，`.` 为字符的通配符，`\.` 会进行转义。[dk.brics.automaton library](http://www.brics.dk/automaton/) 用来评估正则表达式的规则，并有相关的规则描述。建议分支名命名要短并且有效，如：`^refs/heads/.*/name` 不会生效，因为包含了无效的分支名称 `refs/heads//name`，但 `^refs/heads/.+/name` 是有效的命名。

reference 可以使用用户名或者账户的 ID 进行动态命名，如：为所有的开发人员提供一个个人的 sandbox 命名空间，`refs/heads/sandbox/${username}/*`，那么用户 joe 使用的是 'refs/heads/sandbox/joe/foo'。账户的 ID 可以用来让用户访问 `All-Users` 中自己的分支，如：`refs/users/${shardeduserid}` ，如果账户 ID 是 `1011123` ，那么会被解析成 'refs/users/23/1011123'。

为了确认用户是否有相关权限，gerrit 会检查所有配置文件的设置。如：用户在群组 `Foo Leads` 中，某 change 的待合入分支为 `refs/heads/qa`，相关权限设置如下：

|Group            |Reference Name|Label      |Range   |Exclusive|
| :------| :------| :------| :------| :------|
|Registered Users |refs/heads/*  |Code-Review| -1..+1 | |
|Foo Leads        |refs/heads/*  |Code-Review| -2..+2 | |
|QA Leads         |refs/heads/qa |Code-Review| -2..+2 | |

上面的 reference 使用了通配符，所有群组 `Foo Leads` 有效的打分区间是 `-2..+2`。

Gerrit 在 reference 层级上支持 exclusive 的权限配置方式（取消父 project 的权限继承；取消含有通配符的 reference 在此的影响）：

例如，如果要在 reference 层级上配置 exclusive 方式的权限，可以勾选 `refs/heads/qa` 分支后面的 exclusive 标识。

用户在 `Foo Leads` 群组中，某 change 的待合入分支为 `refs/heads/qa`，相关权限设置如下：

|Group           |Reference Name|Label      |Range   |Exclusive|
| :------| :------| :------| :------| :------|
|Registered Users|refs/heads/*  |Code-Review| -1..+1 | |
|Foo Leads       |refs/heads/*  |Code-Review| -2..+2 | |
|QA Leads        |refs/heads/qa |Code-Review| -2..+2 |X|

这时，此用户没有这个 change 的 `Code-Review` 打分权限，因为 `refs/heads/qa` 分支做了 exclusive 的标识。

如果要给群组 `Foo Leads` 添加 `refs/heads/qa` 分支的 `Code-Review` 的权限，需要单独为此配置权限，如下：

|Group           |Reference Name|Category   |Range   |Exclusive|
| :------| :------| :------| :------| :------|
|Registered Users|refs/heads/*  |Code-Review| -1..+1 | |
|Foo Leads       |refs/heads/*  |Code-Review| -2..+2 | |
|QA Leads        |refs/heads/qa |Code-Review| -2..+2 |X|
|Foo Leads       |refs/heads/qa |Code-Review| -2..+2 | |


### OpenID Authentication

如果 Gerrit 配置了 OpenID 认证，那么帐号有效的群组仅为 `Anonymous Users` 和 `Registered Users`，除非 OpenID 帐号与 `gerrit.config` 中的 `auth.trustedOpenID` 有多条配置匹配。

### All Projects

默认情况下，其他的 project 的权限都继承于 `All-Projects`。全局设置中的权限，只能被继承，不能在其他的 project 中做修改。

有了 `Administrate Server` 权限，才可以修改 `All-Projects` 的权限设置。默认情况下，`Administrators` 群组有这个权限。

这个 project 的所有权不能分配给其他的群组，这是系统的限制。因为所有权要是分配给了其他群组，那么其他的群组也就间接有了管理员的权限。

### Per-Project

在 `All-Projects` 的 ACL 识别之前完成对 per-project 的 ACL 的识别，并允许某些权限重载。比如在父 project 设置了 `read` 权限，这时可以在当前的 project 中设置 'DENY' 权限来拒绝某个群组的访问。

## Special and magic references

git 使用了两个 reference 命名空间，一个是 branch，另一个是 tag:

* +refs/heads/*+
* +refs/tags/*+

然而，gerrit 将 `refs/*` 下的其他一些 reference 作为特殊用途使用。

### Special references

这些特别的 references 存放了 project 的配置文件，存放了 change 的一些信息等。

#### refs/changes/*

在这个命名空间下，存放的是 change 的 patch-set 相关嘻嘻能，每个 change 都有一个独立的命名空间。此命名空间的格式如下：

```
'refs/changes/'<last two digits of change number>/
  <change number>/
  <patch set number>
```

#### refs/meta/config

project 存放配置文件所使用的分支，此分支有几个重要的文件：`project.config`, `groups`, `rules.pl`。这些文件实现了访问控制和 change 的 review 管理。

#### refs/meta/dashboards/*

可以参考 [User Dashboards](user-dashboards.md)。

#### refs/notes/review

用来存储 change 的 review 信息。此功能需要 plugin：`reviewnotes` 来支持。

### Magic references

和常规的 git push 操作相比，添加了一些特定的功能。

#### refs/for/<branch ref>

`refs/for/<branch ref>` 此命名空间用于向 gerrit 推送 commit，然后生成或更新 change。

可以参考 [Upload changes](user-upload.md) 的 `push create` 相关章节。

## Access Categories

Gerrit 有几个权限类别用于在 project 设置权限。

### Abandon

此权限用来 abandon change。

change 的 owner，project 的 owner，已经管理员有此权限。

### Create Reference

创建新 reference 的权限，如：branch，tag。

为了推送 lightweight (non-annotated) tags，需要在 `refs/tags/*` 命名空间下添加 `Create Reference` 和 `Push`权限。

### Delete Reference

删除 reference，比如：branch，tag。但不能更新 reference。

可以在网页上直接删除，或者用 push 命令及 -f 参数删除。

### Forge Author

gerrit 会对 commit 的 authoer 和 committer 做检验，检验 email 是否在系统中存在，如果不存在，gerrit 将拒绝接收 commit。此权限可以忽略检验。

如果有一个 patch 来自第三方，那么这个时候添加这个权限显得很必要了，否则这个 commit 会被 gerrit 拒绝。

默认情况下，`Registered Users` 用户有此权限，不过管理员可以变更权限设置。

### Forge Committer

与 `Forge Author` 类似。

### Forge Server

与 `Forge Author` 类似。

### Owner

`Owner` 权限可以修改 project 的配置:

* 修改 project 描述信息
* 修改权限配置

可以为某群组在分支上添加 owner 权限，那么这个群组就有管理这个分支的权限了。

`All-Projects` 中的 `Owner` 权限是失效的。

### Push

用于向 gerrit 推送 commit。可以生成 change 进行评审，也可以不经过评审直接入到代码库上。

#### Direct Push

commit 不经过评审，直接合入到代码库。

* Force option

 启用此参数，会重写分支的历史记录，有可能丢失已有的 commit 节点。

#### Upload To Code Review

上传 commit，生成 change，评审通过后，才能合入到代码库。需要给命名空间 `refs/for/refs/heads/BRANCH` 添加 `Push` 权限，然后用户往 `refs/for/BRANCH` 分支推送 commit 的话，就会在gerrit 上生成 change 了。

* Force option

 `refs/for/refs/heads/*` 不支持此参数，即使启用也不会生效。

### Add Patch Set

用于更新 change 的 patch-set。此权限需要在 `refs/for/*` 下面进行配置。change owner 如果没有此权限，仍然可以更新 change。

默认情况下，`Registered Users` 在 `refs/for/*` 命名空间下有此权限。

### Push Merge Commits

`Push Merge Commit` 权限允许用户向 gerrit 推送 merge 节点。

### Create Annotated Tag

推送 annotated tag 的权限。如下： 

```
  git push ssh://USER@HOST:PORT/PROJECT tag v1.0
```

或:

```
  git push https://HOST/PROJECT tag v1.0
```

tag 需要通过 `git tag -a` 命令生成。

当项目到一定阶段的时候，此 tag 可以用作发布。

向 gerrit 推送此类型 tag 的时候，服务器会校验 committer 的信息，可以通过 `Forge Committer Identity` 这个权限来忽略校验。

推送 lightweight (非 annotated) tag, 需要有 `refs/tags/*` 命名空间的 `Create Reference` 权限。

删除或覆盖已有的 tag，需要在 `refs/tags/*` 命名空间下有 `Push` 及参数 force 的权限。

如果推送的 annotated tag 的 commit 节点在 gerrit 服务器上没有出现过，那么需要在 `refs/tags/*` 命名空间下添加 `Push` 权限。`refs/tags/*` 命名空间下添加 `Push` 权限并不允许更新 annotated tag，只能强制覆盖。

### Create Signed Tag

向代码库推送 Signed 类型的 tag ，命令如下：

```
  git push ssh://USER@HOST:PORT/PROJECT tag v1.0
```

或:

```
  git push https://HOST/PROJECT tag v1.0
```

tag 需要通过命令 `git tag -s` 来创建。

### Read

`Read` 权限可以查看 change, comments, code diffs, 下载代码等。

这个权限有一个特殊之处，由于 per-project 的权限识别在 All-projects 之前，如果 per-project 的 `Read` 权限设置了 'DENY'，即使 All-projects 中设置了 'ALLOW'，那么用户也没有这个 project 的 `Read` 权限。

比如，`All-Projects` 中 `Read` 权限赋予了 `Anonymous Users`，那么用户可以访问 change，下载代码。此时，新增了一个 project，`Read` 权限给 `Anonymous Users` 设置了 'DENY'，给 project-owner 设置了 `Read` ，那么只有 project-owner 可以访问这个新增的 project 了。

### Rebase

在 web 页面可以点击 `Rebase Change` 按钮。

change 的 owner 和有 submit 权限的用户默认有 rebase 的权限。

另外，如果用户更新了 change 的 patch-set ，那么此用户对此 change 有 rebase 的权限。

### Remove Reviewer

可以把评审人员从评审列表中移除。

Change 的 owner 如果没有此权限的话，那么可以将打 0 分或正分的用户从评审列表中移除。

Project 的 owner 和管理员默认有 `Remove Reviewer` 权限。

用户如果没有此权限的话，那么可以从列表中将自己移除。

### Review Labels

对于 project 中的打分项 `My-Name`，对应的权限设置是 `label-My-Name`。

Gerrit 预置了 'Code-Review' 打分项，用户也可以 [自定义打分项](config-labels.md)。

### Submit

此权限允许用户点击 submit 按钮。

点击 submit 按钮后会将 change 合入到代码库。

只有打分项都通过了才可以点击 submit 按钮。

`refs/meta/config` 这个分支只有 project-owner 和管理员才可以点击 submit 按钮，其他角色的用户即使有此权限，也不生效。

### Submit (On Behalf Of)

代表其他用户使用 `Submit` 权限。

此权限在 `project.config` 文件中对应名称为 `submitAs` 。

### View Private Changes

查看 private changes 和 编辑状态下的 change。

如果用户没有 `View Private Changes` 权限，那么 change-owner 可以给指定的用户添加此权限。

### Delete Own Changes

删除用户自己生成的但未合入到代码库的 change，如：open，abondaned 状态的 change 可以被删除。

### Delete Changes

可以删除其他用户非合入状态的 change，open 或 adandoned 状态的可以删除。

有了这个权限意味着有了 `Delete Own Changes` 权限。

管理员即使没有这个权限也可以删除 change。

### Edit Topic Name

编辑 change 的 topic 权限。

change-owner, branch-owner, project-owner 和管理员默认有此权限。

'Force Edit' 如果配置权限时勾选了此标识，那么可以编辑关闭状态 change 的 topic。

### Edit Hashtags

编辑 change 的 hashtags 权限。

change-owner, branch-owner, project-owner 和管理员默认有此权限。

### Edit Assignee

编辑 change 的 Assignee 权限。

change-owner, ref-owner, 当前的 Assignee 和管理员默认有此权限。

## Examples of typical roles in a project

下面是 project 中典型角色的权限配置的案例。

### Contributor

对于普通贡献者或普通开发人员来说，可以添加如下权限：下载代码，推送 patch-set，小范围的打分（不能影响 change 的合入）。

建议权限如下：

* `Read`: 'refs/heads/\*'， 'refs/tags/*'
* `Push`: 'refs/for/refs/heads/*'
* `Code-Review`: 'refs/heads/*' 打分区间 '-1' to '+1' 

### Developer

此角色为核心开发人员。需要更深层次的代码评审，因此要比普通开发人员的权限要多一些。

建议权限如下：

* `Read`: 'refs/heads/\*', 'refs/tags/*'
* `Push`: 'refs/for/refs/heads/*'
* `Push merge commit`: 'refs/for/refs/heads/*'
* `Forge Author Identity`: 'refs/heads/*'
* `Code-Review`: 'refs/heads/*' 打分区间 '-2' to '+2' 
* `Verified`: 'refs/heads/*' 打分区间 '-1' to '+1' （无 CI 系统的情况下）
* `Submit`: 'refs/heads/*'

对于小型项目或者测试的分支来说，可以添加直接 push 的权限。

可选的权限如下：

* `Push`: 'refs/heads/*'
* `Push merge commit`: 'refs/heads/*'

### CI system

CI 系统会把 change 下载下来，然后进行构建和做一些其他的检查，最后在发布一下执行的结果。

常用的 CI 工具 Jenkins/Hudson 可通过 [gerrit-trigger plugin](https://wiki.jenkins-ci.org/display/JENKINS/Gerrit+Trigger) 与 gerrit 集成，并可以对构建作出相关标识：

* 启动构建
* 构建成功
* 测试失败
* 构建失败

通常，只有 CI 帐号可以对 `Verified` 进行打分，这样可以确保合入代码库的 change 都通过了相关的构建或者测试。

如果构建失败，那么 CI 帐号会对 `Verified` 打 `-1` 分，即使有用户打了 `+1`, 此 change 也不会合入。

建议权限如下：

* `Read`: 'refs/heads/\*', 'refs/tags/*'
* `Code-Review`: 'refs/heads/*' 打分区间 '-1' to '0' 
* `Verified`: 'refs/heads/*' 打分区间 '0' to '+1'

可选的权限如下：

* `Code-Review`: 'refs/heads/*' 打分区间 '-1' to '+1' 
* `Push`: 'refs/for/refs/heads/*'

### Integrator

Integrators 角色有点像核心的开发人员，但有着更多的权限。可以创建 branch 和 tag。

建议权限如下：

* 核心开发人员权限
* `Push`: 'refs/heads/*'
* `Push merge commit`: 'refs/heads/*'
* `Forge Committer Identity`: 'refs/for/refs/heads/*'
* `Create Reference`: 'refs/heads/*'
* `Create Annotated Tag`: 'refs/tags/*'


### Project owner

project-owner 角色比 Integrators 权限更大，可以删除 branch。并且可以管理 project 的权限。

**WARNING:**
*此角色需要对 git 比较了解，对配置管理有着深刻的理解。*

建议权限如下：

* Integrator 权限
* `Push`: 'refs/heads/\*', 'refs/tags/*'

可选的权限如下：

* `Owner`: 所管理的 project。

### Administrator

administrator 角色在 gerrit 中的权限是最大的。默认 `Administrators` 群组中的成员有此权限。

需要的权限如下:

* `Administrate Server` 权限

建议权限如下：

* `Project-owner` 权限
* 任何一个 `capabilities` 权限

## Enforcing site wide access policies

如果某群组 `refs/*` 配置了 `Owner` 权限，那么这个群组的成员可以管理这个 project 的权限。

在合作开发的过程中，需要配置一些必要的权限。比如，没有人可以更新或者删除 tag，即使管理员或者 project-owner 也不能这样操作。

### 'BLOCK' access rule

'BLOCK' 会移除用户的相关权限。'BLOCK' 会被子 project 继承。

例如，用户在 'Foo Users' 群组中，试图向 'refs/heads/mater' 进行推送，这个时候推送会被阻止，也就是失败。

|Project      | Inherits From    |Reference Name |Permissions            |
| :------| :------| :------| :------|
|All-Projects | -                |refs/*         |push = block Foo Users |
|Foo          | All-Projects     |refs/heads/*   |push = Foo Users       |

'BLOCK' 权限的识别是从上而下，也就是说先从父 project 开始识别。识别到 'BLOCK' 规则后，会立刻应用此规则。

```
All-Projects: project.config
  [access "refs/heads/*"]
    push = block group X

child-project: project.config
  [access "refs/heads/*"]
    exclusiveGroupPermissions = push
    push = group X
```

上面的例子中，群组 X 即使配置了 Exclusive 权限，仍然没有 push 权限。

'BLOCK' 可以阻止任何一种类型的 'push' 操作；如果勾选了 `force` 参数，那么只能阻止 `push -f` 了。

同样，也可以阻止打分范围。不允许群组 X 打 `-2` 和 `+2`,但可以打 `-1..+1`，参考配置如下：

```
  [access "refs/heads/*"]
    label-Code-Review = block -2..+2 group X
```

'BLOCK' 'min..max' 可以解释为：不允许在 '-INFINITE..min' 和 'max..INFINITE' 区间打分。对于上面的示例，'-1..+1' 不受影响。

### 'BLOCK' 和 'ALLOW' 在相同的 section 中

当 project 中，如果同一个的 section 同时配置了 'BLOCK' 和 'ALLOW' 规则，那么 'ALLOW' 会重载 'BLOCK' 规则:

```
  [access "refs/heads/*"]
    push = block group X
    push = group Y
```

此时，如果一个用户同时在 群组 Y 和 X 中，那么此用户仍然有 push 权限。

### 'BLOCK' 和 'ALLOW' 在同一个 project 中并做了 Exclusive 标识

当 project 包含 'BLOCK' 和 'ALLOW' 规则，并且在具体的 reference 上使用 Exclusive 标识的情况下，有 Exclusive 标识的 'ALLOW' 会重载 'BLOCK' 规则: 

```
  [access "refs/*"]
    read = block group X

  [access "refs/heads/*"]
    exclusiveGroupPermissions = read
    read = group X
```

这种情况下，群组 X 中的用户仍然有 'refs/heads/*' 的读权限。

**NOTE:**
*'ALLOW' 重载 'BLOCK' 只会发生在同一个 project 的同一个 section 中。同一个 project 的不同 section 或者是继承的 project 的任何 section 中，不会重载。*

### Examples

下面是使用 'BLOCK' 规则的示例。

#### 不允许更新或删除 tag

在合作开发中，要确保对每一个标签（或版本）可以进行重复的构建，主要用于回溯，此时需要在 "`All-Projects`" 对 'Anonymous Users' 设置 block 'push' 的权限，如下：

```
  [access "refs/tags/*"]
    push = block group Anonymous Users
```

有时，仍然需要生成 tag，例如我们给 project-owner 添加此权限，对上面的配置进行扩展，如下：

```
  [access "refs/tags/*"]
    push = block group Anonymous Users
    create = group Project Owners
    pushTag = group Project Owners
```

#### Let only a dedicated group vote in a special category

有 release 相关分支，对 change 的合入十分的严格，添加了一个新的打分项 'Release-Process'，并且只有 'Release Engineers' 群组的成员可以对其打分，其他成员组不允许打分，配置参考如下：

```
  [access "refs/heads/stable*"]
    label-Release-Process = block -1..+1 group Anonymous Users
    label-Release-Process = -1..+1 group Release Engineers
```

## Global Capabilities

全局设置需要有管理员权限。

全局设置需要在 `All-Projects` 中进行操作。

下面是对全局的设置项的描述：

### Access Database

查看 git 仓中的 review 相关数据。

### Administrate Server

这个权限太大了，有此权限的用户不仅可以配置权限，并且还默认拥有了 capability 中所有的权限。

大多数的 gerrit 实例中，文件系统和数据库管理员需要添加此权限。

虽然用户被赋予了此权限，并不意味着用户自动有了所有的权限。比方说打分权限，submit 权限，如果需要的话，还得再次添加。

### Batch Changes Limit

设置批量上传 change 数量的上限，此设置会重载 `gerrit.config` 文件中的 'receive.maxBatchChanges' 设置。

### Create Account

使用 [account creation over the ssh prompt](cmd-create-account.md) 命令创建用户，包括 non-interactive 角色的用户（此用户用于 CI 系统）。

### Create Group

创建 gerrit 内部群组。

### Create Project

创建 project。

### Email Reviewers

允许或拒绝向 reviewers 和 watchers 发送邮件。可以用来拒绝构建机器人向 change 的 reviewers 和 watchers 发送邮件。相反，只有 change 的 author 和 star 人员会收到邮件。此规则的 allow 优先级要高于 deny；在没有规则限制的情况下，此处默认设置是允许发送邮件。

### Flush Caches

使用 [flush some or all Gerrit caches via ssh](cmd-flush-caches.md) 命令刷新 gerrit 的缓存。

**NOTE:**
*此权限与 show-caches 命令的权限不同。*

### Kill Task

使用 [kill command over ssh](cmd-kill.md) 命令终止服务器端与客户端的链接。如：replication，upload-pack，receive-pack 操作等。

### Maintain Server

基本的维护服务器的权限，如：刷新缓存，重新构建 change 的索引。但不包括数据库的读写和维护用户权限的权限。

拥有的权限如下:

* Flush Caches
* Kill Task
* Run Garbage Collection
* View Caches
* View Queue

### Modify Account

使用 [modify accounts over the ssh prompt](cmd-set-account.md) 命令来更新帐号设置。

### Priority

此权限允许 'Non-Interactive Users' 用户使用保留的线程池（参考 [系统配置](config-gerrit.md) 的 batchThreads 部分）。线程池是一个二进制的值。

此权限有三种模式，如下：

**No capability configured.**
 用户没有被赋予任何 priority 权限，默认工作在 'INTERACTIVE' 线程池。

**'BATCH'**
 如果为 'Non-Interactive Users' 配置了线程池，并且用户被赋予了 'BATCH' 权限，那么此用户会在这个独立的线程池中工作。

**'INTERACTIVE'**
 如果用户赋予了 'INTERACTIVE' 权限，即使被赋予了 'BATCH' 权限，此用户仍然在 'INTERACTIVE' 线程池。

### Query Limit

设置返回搜索结果数量的上限。默认值是 500 条信息。

此设置不仅应用在命令行搜索 [`gerrit query`](cmd-query.md)，还应用在网页上的搜索。

### Read As

用户模仿其他用户进行读操作。

### Run As

模仿其他用户做一些操作，如 SSH 命令 [suexec](cmd-suexec.md)。

不能模仿管理员 `Administrate Server` 权限包含的操作。但可以模仿相关用户对 `refs/meta/config` 分支进行修改。

管理员默认没有这个权限，需要手动添加。

### Run Garbage Collection

可以在 project 中执行 gc 操作。gerrit 的 gc 和 git gc 不一样。gerrit gc 主要对 git 仓的 object 执行 hashmap 操作，进而可以加少大型 git 仓的下载时间。

### Stream Events

监听 gerrit 的 `stream event`，可以参考 [stream Gerrit events via ssh](cmd-stream-events.md) 

### View Access

查看 project 的权限配置。

### View All Accounts

可以查看所有的 gerrit 中的用户（不包括具体的用户信息），此权限和 [accounts.visibility](config-gerrit.md) 权限不一样。

### View Caches

查看 gerrit 内部缓存情况，可以参考 [look at some or all Gerrit caches via ssh](cmd-show-caches.md)

### View Connections

查询客户端与 gerrit 服务器的链接状态。可以参考 [look at Gerrit's current connections via ssh](cmd-show-connections.md)

### View Plugins

查看已安装的 plugin。

### View Queue

查看 gerrit 执行任务的队列情况，可以参考 [look at the Gerrit task queue via ssh](cmd-show-queue.md)

## Permission evaluation reference

权限按照下面的规则进行识别：

* PermisssionRule: 一系列配置项的组合，如 {ALLOW, DENY, BLOCK} ，群组，打分范围，是否 'exclusive'。

* Permission: 按权限名称对 PermissionRule 进行分组，如：read，push。

* AccessSection: ref 样式的 permission 的列表。

下面是 [project.config](config-project-config.md) 文件中的内容:

```
  # An AccessSection
  [access "refs/heads/stable/*"]
     exclusiveGroupPermissions = create

     # Each of the following lines corresponds to a PermissionRule
     # The next two PermissionRule together form the "read" Permission
     read = group Administrators
     read = group Registered Users

     # A Permission with a block and block-override
     create = block group Registered Users
     create = group Project Owners

     # A Permission and PermissionRule for a label
     label-Code-Review = -2..+2 group Project Owners
```

### Ref permissions

访问 refs 时，可以被 blocked, allowed, denied。

#### BLOCK

对于 block 权限，标识为 BLOCK 的规则都经过了识别，如果有一条规则匹配，那么就拒绝用户的访问。

此规则按照继承的顺序排序，自上而下，从 All-Projects 开始匹配。在 project 中，先匹配具体的 reference 的规则。自上而下的方式，可以让系统中所有的 project 都执行 BLOCK 的规则。

BLOCK 规则也有例外，比如在同一个 project 中： 

1. 在同一个 Permission 下添加 ALLOW PermissionRules，此时 ALLOW 会重载 BLOCK 的配置。

2. 在更详细的 reference 中配置了 ALLOW ，并且都标识了 "exclusive"，那么 ALLOW 会重载 BLOCK 的配置。

3. BLOCK `anonymous users` 并不包括管理员群组中的成员。

上面的描述并不是不执行 BLOCK 规则，而是在处理 ALLOW/DENY 进程的时候被赋予了其他的权限，下面有相关的描述。

#### ALLOW

对于 allow 权限，所有的 ALLOW/DENY 规则都会经过识别，如果有规则匹配上，那么就会应用此规则。

在 project 中，先匹配具体的 reference 的规则。如果没有匹配到相应的规则，再从父 project 中进行匹配，直到 `All-Projects`。

这样的规则排序方式，便于 project-owner 优先使用自己定义的规则。

#### DENY

DENY 与 ALLOW 一起进行处理。

按照上面的描述，在 ALLOW/DENY 处理的过程中，规则逐条的进行匹配。在每一个 permission 中，只能使用一条 ALLOW/DENY 的规则，如果第一条是 DENY 规则，后面的 ALLOW 规则会被忽略。

DENY 有时会让人迷惑，因为此规则只能在给定的 reference 下执行。父 project 可以通过某些方法来取消 DENY 规则的影响，比如添加更通用的 reference 或添加其他的群组。

#### DENY/ALLOW example

例如 ref "refs/a" 及以下配置:
```

child-project: project.config
    [access "refs/a"]
      read = deny group A

All-Projects: project.config
    [access "refs/a"]
      read = group A      # ALLOW
    [access "refs/*"]
      read = group B      # ALLOW
```

首先，"refs/a" 配置了 "read = DENY group A" ；其次，"refs/a" 又配置了 "read = ALLOW group A" ，由于后者的 permission, ref-pattern, group 与前者相同，所以后面的规则会被忽略。

DENY 规则并不影响 "refs/*", 因为后面的规则的 ref-pattern, group 与前者不同。如果群组 B 是 群组 A 的超集，那么群组 B 的成员可以访问 "refs/a"。

#### Double use of exclusive

'exclusive' 权限在 BLOCK 和 ALLOW/DENY 处理过程中会被识别：当处理 BLOCK 时，'exclusive' 会终止向下的匹配；当处理 ALLOW/DENY 时，'exclusive' 会终止向上的规则匹配 。

#### Force permission

'force' 只能在 ALLOW 和 BLOCK 上配置。如果是 ALLOW，'force' 参数会使操作的范围大一些，allow force 和 非 force 的操作；如果是 BLOCK，'force' 参数会缩小操作的范围，仅仅 block force 的操作。

### Labels

Labels 的机制都是一样的，如下：

* 'force' 设置不影响打分的范围

* BLOCK 描述了具体的群组不能打分，如

```
  label-Code-Review = block -2..+2 group Anonymous Users
```

 上面的配置将阻止所有的用户在 -2...+2 区间打分

* DENY ，同 BLOCK，并有警告

* BLOCK ，多个配置会取并集，如：

```
All-Projects: project.config
     label-Code-Review = block -2..+1 group A

Child-Project: project-config
     label-Code-Review = block -1..+2 group A
```

 此时，群组 A 中的成员在所有的子 project 中不能给 Code-Review 打分。

* ALLOW ，多个配置会取并集，如：

```
     label-Code-Review = -2..+1 group A
     label-Code-Review = -1..+2 group B
```

 同时在 A B 群组中的用户，对 Code-Review 打分的范围为 -2..2

