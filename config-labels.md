# Gerrit Code Review - Review Labels

评审 change 的时候，需要进行打分，打分的规则可以自定义的。gerrit 预置了 `Code-Review` 打分项。

## Label: Code-Review

`Code-Review` 打分项是预置的。这个打分项源自 `Android Open Source Project`，含义为‘代码写的不错’。

分值区间如下:

* -2 禁止合入

如果 commit 的代码质量非常糟糕，那么 change 是不能合入到代码库的。所以评审人员需要打此分，禁止 change 的合入。

*Any -2 blocks submit.*

* -1 不建议合入

代码有一些瑕疵，但由于不是这个 project 的 owner，所以是否禁止合入还需要 owner 来定夺。

*Does not block submit.*

* 0 无建议

不准备评审代码，或者看了代码之后给不出意见。

* +1 还需要其他人员评审

代码看上去还不错，但此评审人员没有 `+2` 的权限。

* +2 可以合入

代码不错，可以合入。

*Any +2 enables submit.*

要使 patch-set 处于可合入状态，需要有 `+2 Looks good to me, approved` ，但没有 `-2 Do not submit`。

如果不喜欢 `Code-Review` 这个打分项，那么将 `[label "Code-Review"]` 部分在 `All-Projects` 中的 `project.config` 文件里面移除。

`label.Code-Review.value` 这个字段对应了打分项的描述和打分值，如果想要修改描述和取值范围可以在 `project.config` 文件中修改。

`MaxWithBlock` 意味着阻止 patch-set 合入对应的分值，即使有最高的得分也不能合入。

## Label: Verified

`Verified` 打分项同样来自 `Android Open Source Project`，含义为‘编译，单元测试’。集成 CI 工具后，可以通过 CI 工具对 change 的 `Verified` 打分项打分。

首次安装 gerrit 时，`Verified` 的使用是一个可选项。如果后续想使用 `Verified`，那么可以向 `All-Projects` 的 `project.config` 文件添加如下内容：

```
  [label "Verified"]
      function = MaxWithBlock
      value = -1 Fails
      value = 0 No score
      value = +1 Verified
      copyAllScoresIfNoCodeChange = true
```

分值范围如下:

* -1 Fails

编译报错或者单元测试没有通过。

*Any -1 blocks submit.*

* 0 No score

没有执行编译或者测试的任务。

* +1 Verified

编译成功已经单元测试通过。

*Any +1 enables submit.*

要使 patch-set 处于可合入状态，需要有 `+1 Verified` ，并且没有 `-1 Fails`。

另外，若要修改 `Verified` 的描述和取值范围，可以参考上面 `Code-Review` 的修改。

## Customized Labels

管理员和 project owner 可以定制打分项，或者可以从其他的 project 继承打分项。

定制打分项可以参考上面 `Code-Review` 的修改

同预置的打分项(如 `Code-Review`)一样，需要给定制的打分项设置权限。定制的打分项在 project.config 配置好以后，网页上就可以对其设置权限了。

打分项在 `project.config` 文件中修改，默认的情况下，打分项需要在 `All-Projects` 中进行定义。

### Inheritance

打分项可以被子 project 继承，同样也可以被子 project 重载或移除。

在子 project 中重载一个打分项的话，那么它的属性都会被重载。

如果要移除子 project 中的打分项，可将此打分项置空，这样就可以用默认值(`function = MaxWithBlock`,`defaultValue = 0` 并且没有其他的打分值)重载了。

### Layout

多个打分项会按字母的顺序进行排列。

### `label.Label-Name`

打分项的名称，只能由字母和字符 `-` 组成。

### `label.Label-Name.value`

这个是一对多的键值对，不过需要按格式 `"<#> 值 描述"` 来添加。 The `<#>` 可以是正数也可以是负数， `+` 可以省略。

### `label.Label-Name.defaultValue`

打分项的默认值。默认值必须在打分的范围区间内。这是一个可选参数，如果不设置，默认是 0 。

### `label.Label-Name.function`

用于评估打分项状态。如果自定义了 `submit rule`，那么此函数会失效。

函数的有效值如下:

* `MaxWithBlock` (默认)

即使有了最高打分，如果有最低打分的话，那么 change 将不能合入，不过需要事先定义最低的负的分值。

* `AnyWithBlock`

如果有负分，那么 change 将不能合入，不过需要事先定义最低的负的分值。

* `MaxNoBlock`

最低的打分不会影响 change 的合入。

* `NoBlock`/`NoOp`

打分对 change 的合入无任何影响。仅用于提示信息。

* `PatchSetLock`

`PatchSetLock` 的功能是锁定 patch-set，即不能创建新的 patch-set，不能 rebase，不能 abondan。`PatchSetLock` 的打分，不影响 change 的合入。当 CI 验证 change 的时候，可以看出此功能的作用。 

此功能受权限控制，有权限的帐号可以进行锁定操作。

取值范围是 0 到 1。 0 (解锁) ，1 (锁定)。

### `label.Label-Name.allowPostSubmit`

如果值是 `true`, 那么 change 在合入后仍然可以打分；如果是 `false`，那么 change 合入后，网页不会出现打分项，即不能对关闭的 change 进行打分。

默认值是 `true`。

### `label.Label-Name.copyMinScore`

如果值是 `true`, 最低的负分会在 change 的下一个 patch-set 上保留。默认值是 `false`，但 All-Projects 例外，默认值是 `true`。

### `label.Label-Name.copyMaxScore`

如果值是 `true`, 最高的正分会在 change 的下一个 patch-set 上保留。默认值是 `false`。

### `label.Label-Name.copyAllScoresOnMergeFirstParentUpdate`

如果值是 `true`, 对于 change 的新 patch-set 来说，要是新、老 patch-set 都是 merge 节点，并且新的 patch-set 有一个父节点发生了变更，这时之前的 patch-set 上的打分会自动的复制到新的 patch-set 上面。

默认值是 `false`。

### `label.Label-Name.copyAllScoresOnTrivialRebase`

如果值是 `true`, 对于 change 的新 patch-set 来说，要是 trivial rebase 操作，那么之前的 patch-set 上的打分会自动的复制到新的 patch-set 上面。trivial rebase：commit message ，code delta 和之前的 patch-set 相同，执行了 rebase 操作。

默认值是 `false`。

### `label.Label-Name.copyAllScoresIfNoCodeChange`

如果值是 `true`, 对于 change 的新 patch-set 来说，要是 parent tree, code delta 与之前的 patch-set 一致的话，换句话说只有 commit-msg 不一样，那么之前的 patch-set 上的打分会自动的复制到新的 patch-set 上面。

默认值是 `false`。

### `label.Label-Name.copyAllScoresIfNoChange`

如果值是 `true`, 对于 change 的新 patch-set 来说，要是 parent tree, code delta, 及 commit 与之前的 patch-set 一致的话，换句话说只有 commit-id 不一样，那么之前的 patch-set 上的打分会自动的复制到新的 patch-set 上面。

默认值是 `true`。

### `label.Label-Name.canOverride`

如果值是 `false`，那么子 project 不能重载此打分项。默认值是 `true`。

### `label.Label-Name.branch`

打分项在指定的分支上体现，其他分支的 change 不会显示此打分项。如下：

```
  [label "Video-Qualify"]
      branch = refs/heads/video-1.0/*
      branch = refs/heads/video-1.1/Kino
```

这时只有 *only* 上面描述分支的 change 会显示打分项：`Video-Qualify`。

**NOTE:**
*页面上在 `access` 部分给分支配置权限时，此打分项会作为权限设置和其他的打分项一起显示出来，如果对未指定的分支上设置了此打分项，那么那些未指定的分支会自动忽略这个权限设置。*
*此打分项的设置不受定制的 rule。pl 的影响。*
*分支的格式类似 ref 的格式，但不包括这两种格式 `ref/${username}` `ref/${shardeduserid}` 。*

### `label.Label-Name.ignoreSelfApproval`

如果值是 `true`, 上传 patch-set 的人员打的最高分无效，如果要合入，需要非上传 patch-set 的人员打最高分。

默认值是 `false`。

### Example

定义一个类似 `Verified` 的打分项，如下：

```
  [label "Copyright-Check"]
      function = MaxWithBlock
      value = -1 Do not have copyright
      value = 0 No score
      value = +1 Copyright clear
```

上面的例子可以添加到配置文件的结尾。

### Default Value Example

下面的例子描述了打分项的默认值是如何工作的，假设配置如下：

```
  [access "refs/heads/*"]
      label-Snarky-Review = -3..+3 group Administrators
      label-Snarky-Review = -2..+2 group Project Owners
      label-Snarky-Review = -1..+1 group Registered Users
  [label "Snarky-Review"]
      value = -3 Ohh, hell no!
      value = -2 Hmm, I'm not a fan
      value = -1 I'm not sure I like this
      value = 0 No score
      value = +1 I like, but need another to like it as well
      value = +2 Hmm, this is pretty nice
      value = +3 Ohh, hell yes!
      defaultValue = -3
```

点击 `Reply` 按钮：

* 管理员有 -3..+3 的打分权限， -3 是默认值。
* project owner 有 -2..+2 的打分权限， -2 是默认值。
* 注册用户有 -1..+1 的打分权限， -1 是默认值。

### Patch Set Lock Example

下面是配置了 `PatchSetLock` 打分项的例子：

```
  [access "refs/heads/*"]
      label-Patch-Set-Lock = +0..+1 group Administrators
  [label "Patch-Set-Lock"]
      function = PatchSetLock
      value =  0 Patch Set Unlocked
      value = +1 Patch Set Locked
      defaultValue = 0
```

