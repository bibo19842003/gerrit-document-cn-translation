# Gerrit Code Review - Accounts

## Overview

gerrit 从 2.15 开始，账户的元数据信息存储在 [NoteDb](note-db.md) 。

用户数据由序列号(account ID)，account properties(full name, display name, preferred email, registration date, status,inactive flag), preferences (general, diff and edit preferences), project watches, SSH keys, external IDs, starred changes 和 reviewed flags 组成。

大多数的用户数据存储在 `All-Users` 中，每个用户一个分支，每个分支包含了一些 git 风格的配置文件用来存储用户的不同数据，如：`account.config`，`preferences.config`，`watch.config` 和 `SSH keys` 的认证文件。

用户分支通过 commit 来记录数据的变化。

`external IDs` 作为 git notes 存储在 `All-Users` 的 `refs/meta/external-ids` notes 分支中。所有的 `external IDs` 存储在一个 notes branch 上，这样可以确保每个 `external IDs` 只能使用一次。

`starred changes` 以单独的 refs 存储在 `All-Users`。他们并不存储在用户分支上，因为这些数据不需要进行版本控制。

`reviewed flags` 没有存储在 git 中，而是存储在数据库中。因为大量的 `reviewed flags` 使用 git 存储的话，比较低效。

因为搜索 git 中的用户数据不是很快，所以把用户数据放到了 index 中，加快搜索速度。

## `All-Users` repository

`All-Users` 是一个特别的 project，因为这个 project 值包含用户相关的数据。每个用户一个分支，格式为 `refs/users/CD/ABCD`，其中 `CD/ABCD` 是 `sharded account ID`，例如，用户帐号是 `1000856`，则对应的用户分支为 `refs/users/56/1000856`。

对应每个账户来说，需要有一个对应的用户分支，但分支下不一定要有文件。

可以使用 [Gerrit REST API](rest-api-accounts.md) 更新用户分支。但用户也可以手动下载相关分支，并将 change 推送回 gerrit。推送的时候，gerrit 会校验数据，无效用户的数据会被拒绝。

为了隐匿 ref 中 `sharded account ID` 的实施过程，gerrit 提供了一个命名空间：`refs/users/self`，这个命名空间可以自动地解析成调用者的用户分支。用户可以使用这个 ref 对自己的用户分支进行下载和推送，例如：用户 `1000856` 向 `refs/users/self` 进行推送，分支 `refs/users/56/1000856` 会被更新。在 gerrit 中，`self` 是一个术语，用来描述调用者（比如在 change 搜索中的使用）。这是用户调用自己分支的时候，可以使用 `refs/users/self` 的原因。

用户对自己的用户分支应该有读写的权限。为了给用户分配权限，可以使用分支 `refs/users/${shardeduserid}`。`${shardeduserid}` 是一个变量，可以解析成 `sharded account ID`。这个变量用来在所有的用户分支中，给用户的自己的分支分配权限。当新安装的 gerrit 版本或升级到的新版本，如果支持用户分支的话，gerrit 会默认添加如下配置：

_All-Users project.config_
```
[access "refs/users/${shardeduserid}"]
  exclusiveGroupPermissions = read push submit
  read = group Registered Users
  push = group Registered Users
  label-Code-Review = -2..+2 group Registered Users
  submit = group Registered Users
```

用户分支包含了一些含有用户数据的文件，具体的文件信息可以参考本文后面的描述。

另外，对于 `All-Users` ，不仅有用户分支，还有 `external IDs` 等一些其他的分支。

`account sequence` 同样也存储在 `All-Users` 中。

## Account Index

下面的情况，gerrit 需要进行搜索账户，如：

* 给 project 的关注者发送邮件通知
* 向群组，向评审列表添加人员时，会自动提示人员信息

如果直接搜索 git 中的用户数据，因为需要访问所有的用户分支并且还要解析分支上的文件，因此速度比较慢。为了解决这个问题，gerrit 对账户执行索引操作，这样可以加快用户的搜索速度。索引的相关说明，可以参考 [系统配置](config-gerrit.md) 的 `Lucene or Elasticsearch` 部分。

账户在更新后会自动的重新进行索引操作。也可以进行手动索引操作(参考[API 用户部分](rest-api-accounts.md) 的 index 部分) 。也可以线下对账户执行[索引](pgm-reindex.md)。

## Account Data in User Branch

用户分支包含了一些 git 风格的配置文件用来存储用户的不同数据：

* `account.config`:

存储 `account properties`，如下。

* `preferences.config`:

存储 `user preferences`，如下。

* `watch.config`:

存储用户的 `project watches`，如下。

另外，还包含了用户的 `SSH keys` 的[认证文件](https://en.wikibooks.org/wiki/OpenSSH/Client_Configuration_Files#.7E.2F.ssh.2Fauthorized_keys).

### Account Properties

用户的属性信息存储在用户分支的 `account.config` 文件中:

```
[account]
  fullName = John Doe
  displayName = John
  preferredEmail = john.doe@example.com
  status = OOO
  active = false
```

对于 active 状态的用户来说，`active` 参数可以忽略。

用户注册的时间戳并不在 `account.config` 文件中显示，此时间戳可以在用户分支首次 commit 信息中查询。

当用户向自己的用户分支推送时，账户信息会进行更新。用户的 `preferred email` 存在于 `external IDs` 中。

用户不允许设置自己的 active 属性，这个属性只有管理员或者 `Modify Account` 权限才可以设置。

虽然用户的数据存储在 `account.config` 文件中，但用户分支上并不一定包含 `account.config` 文件，因为用户的属性信息可以从公共配置中继承。

### Preferences

用户的 properties 存储在用户分支的 `preferences.config` 文件中。对于配置来说，有多个部分：

```
[diff]
  hideTopMenu = true
[edit]
  lineLength = 80
```

使用 REST API 的时候，配置文件中的参数名称要和 API 中的参数名称保持一致，可以参考 [API 用户部分](rest-api-accounts.md) 的相关章节。

如果设置 preference 的参数值和 preference 默认的值一致，那么这个参数设置会被 `preferences.config` 文件忽略。

所有用户的 preferences 默认值可以在 `All-Users` 的 `refs/users/default` 分支中进行设置。

### Project Watches

用户可以关注 project ，当此 project 有 change 更新的时候，系统会发送邮件给关注的用户。

watch 的配置由 project 名称和可选的 change 搜索条件组成。如果明确了 change 的搜索条件，邮件也会根据匹配的搜索进行对应的发送。

另外，每个 watch 的配置可以包含一系列的 notification 类型，用来决定发送通知邮件的场景。例如：上传新的 patch-set 和 change 提交的时候发送通知邮件，其他的情况不进行发送。

watch 信息存储在用户分支的 `watch.config` 文件中，如下：

```
[project "foo"]
  notify = * [ALL_COMMENTS]
  notify = branch:master [ALL_COMMENTS, NEW_PATCHSETS]
  notify = branch:master owner:self [SUBMITTED_CHANGES]
```

watch.config 文件有一个 project 部分，用于 project 的关注。project 名称用作 subsection 的命名（如：foo）；过滤条件作为 notification 的类型，此类型决定了何时来发送邮件，通过 `notify` 的值来表示。`notify` 值的格式为 "<filter> [<comma-separated-list-of-notification-types>]"。邮件通知的类型可以参考 [邮件订阅](user-notify.md) 的相关部分。

对于 change 事件，根据 `notify` 的值来发送相关邮件通知。

为了发送和 change 相关的邮件通知，Gerrit 需要找到关注 project 的用户。为了进行快速查找，系统使用了 account 的索引。account 的索引包含了一个重复的字段，用来存储用户关注的 project。在索引中检索到关注 project 的账户以后，可以从帐户的缓存中获取完整的关注配置，Gerrit 可以根据 change 和 事件检查关注是否匹配了。

### SSH Keys

`SSH keys` 存储在用户分支的 `authorized_keys` 文件中，此文件是 [标准 OpenSSH 文件格式](https://en.wikibooks.org/wiki/OpenSSH/Client_Configuration_Files#.7E.2F.ssh.2Fauthorized_keys) 。

```
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAAAgQCgug5VyMXQGnem2H1KVC4/HcRcD4zzBqSuJBRWVonSSoz3RoAZ7bWXCVVGwchtXwUURD689wFYdiPecOrWOUgeeyRq754YWRhU+W28vf8IZixgjCmiBhaL2gt3wff6pP+NXJpTSA4aeWE5DfNK5tZlxlSxqkKOS8JRSUeNQov5Tw== john.doe@example.com
# DELETED
# INVALID ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAAAgQDm5yP7FmEoqzQRDyskX+9+N0q9GrvZeh5RG52EUpE4ms/Ujm3ewV1LoGzc/lYKJAIbdcZQNJ9+06EfWZaIRA3oOwAPe1eCnX+aLr8E6Tw2gDMQOGc5e9HfyXpC2pDvzauoZNYqLALOG3y/1xjo7IH8GYRS2B7zO/Mf9DdCcCKSfw== john.doe@example.com
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAAAgQCaS7RHEcZ/zjl9hkWkqnm29RNr2OQ/TZ5jk2qBVMH3BgzPsTsEs+7ag9tfD8OCj+vOcwm626mQBZoR2e3niHa/9gnHBHFtOrGfzKbpRjTWtiOZbB9HF+rqMVD+Dawo/oicX/dDg7VAgOFSPothe6RMhbgWf84UcK5aQd5eP5y+tQ== john.doe@example.com
```

当使用 SSH API 的时候，gerrit 需要一个有效的方式来搜索 SSH keys，使用 username 搜索就是一个有效的方式。因为 username 可以快速的根据缓存被解析成 `account ID`，因此访问用户分支的时候就会快很多。

REST API 通过使用每个账户的序列号来识别 SSH keys。这是因为 `authorized_keys` 文件中的 keys 是按序列号进行排序的。序列号从 1 开始。

当一个 key 被删除了，为了保证序列号的完整性，'# DELETED' 此行会插入到被删除的位置。

无效的 keys 的前面会有前缀 '# INVALID' 进行标识。

## External IDs

`External IDs` 用来链接内部的身份标识（如：username email）和外部的身份标识（如：LDAP 账户，或者 OAUTH 账户）。

`External IDs` 作为 `Git Notes` 存储在 `All-Users` 的 `refs/meta/external-ids` 分支中。

`external ID` 的 SHA-1 作为 note key 来使用，例如：`external ID` `username:jdoe` 对应的 note key 是 `e0b751ae90ef039f320e097d7d212f490e933706`。确保 `external ID` 只能使用一次，因为 `external ID` 不能同一时间分配给多个账户使用。

如下命令显示了如何查找 `external ID` 的 SHA-1:
```
$ echo -n 'gerrit:jdoe' | shasum
7c2a55657d911109dbc930836e7a770fb946e8ef  -

$ echo -n 'username:jdoe' | shasum
e0b751ae90ef039f320e097d7d212f490e933706  -
```

**IMPORTANT:**
*如果手动更改了 `external ID`，那么需要手动用新的 SHA-1 适配 note key，否则 `external ID` 会与 note key 不一致，进而会被 gerrit 忽略。*

note 是 git 风格的文件，格式如下：

```
[externalId "username:jdoe"]
  accountId = 1003407
  email = jdoe@example.com
  password = bcrypt:4:LCbmSBDivK/hhGVQMfkDpA==:XcWn0pKYSVU/UJgOvhidkEtmqCp6oKB7
```

如果知道了 `external ID` 的 SHA-1，下面的命令可以显示其相关的内容:

```
$ echo -n 'gerrit:jdoe' | shasum
7c2a55657d911109dbc930836e7a770fb946e8ef  -

$ git show refs/meta/external-ids:7c/2a55657d911109dbc930836e7a770fb946e8ef
[externalId "username:jdoe"]
  accountId = 1003407
  email = jdoe@example.com
  password = bcrypt:4:LCbmSBDivK/hhGVQMfkDpA==:XcWn0pKYSVU/UJgOvhidkEtmqCp6oKB7
```

配置文件有一个 `externalId` 部分，`external ID` 由 scheme 和 ID 组成，格式为 '<scheme>:<id>'，作为 subsection 的名称。

`accountId` 字段是必填项；`email` 和 `password` 字段是选填项。

git 会在不同的目录层级进行查找，比如：如果 `refs/meta/external-ids:7c/2a55657d911109dbc930836e7a770fb946e8ef` 没有找到，那么将查找 `refs/meta/external-ids:7c/2a/55657d911109dbc930836e7a770fb946e8ef` 。

`external IDs` 由 gerrit 系统自动维护，意味着不能手动编辑 `external IDs`。如果用户有 `Access Database` 权限，那么可以更新 `refs/meta/external-ids` 分支。然而，下面情况 gerrit 是拒绝接受推送的：
* `external ID` 的配置文件不能被解析
* `note key` 与 `external ID` 的 SHA-1 不匹配
* `external IDs` 包含在了不存在的账户中
* 包含无效的邮件地址
* 邮件信息不是唯一的 (同一个 email 分配给了多个账户)
* 不能使用 `username` 解析 `external IDs` 的 `hashed passwords`

## Starred Changes

[星标 changes](dev-stars.md) 允许用户对 change 进行标识，然后发送通知邮件。

每个被星标的 change 可以看作是一个由 `account-ID`，`change-ID`，`label` 组成的元组。

gerrit 在 `All-Users` 创建了 `refs/starred-changes/YY/XXXX/ZZZZZZZ` ref 用来跟踪加星标的用户，其中 `YY/XXXX` 是 change-id 的 `sharded numeric`，`ZZZZZZZ` 是 account-ID。

starred-changes 的 ref 由标签的列表组成，标签记录了相关的信息，标签存储在文本文件中，每行存储一个标签信息。

当前缀以 '/' 结尾的时候，JGit 在搜索 refs 的时候会根据此前缀会做一些优化，便于根据 change-id 查找星标的 change。通过 change-id 查找星标 change，如果 change 有更新，那么系统会发送邮件通知用户。

With the ref format as described above the lookup of starred changes by account ID is expensive, as this requires a scan of the full `refs/starred-changes/*` namespace. 
To overcome this the users that have starred a change are stored in the change index together with the star labels.


Gerrit 提供了一种有效的方法来查找星标的 change，例如，搜索栏中输入搜索条件 `is:starred`。如果按照上面描述的 ref 的格式来通过 account-id 来搜索星标 change，代价比较大，因为需要扫描 `refs/starred-changes/*` 的所有命名空间。为了解决这个问题，系统将星标用户和标签一起存储到索引中。

## Reviewed Flags

在 Gerrit UI 评审 patch-set 的时候，评审人会对评审过的文件进行标识。这样的标识可以称作 `Reviewed Flags`，`reviewed flag` 是由 `patch-set ID`, 文件，`account-ID` 组成的元组。

每个用户有很多的 `reviewed flags`，并且随着时间的增加，数量一直会没有限制的上涨。

大量的 `reviewed flags` 不适合存储在 git 中，因为每次的更新都需要进行 commit，这样操作的负载很大。因此将 `reviewed flags` 存储在数据库的表格中。默认存储在本地的 H2 数据库中，不过这个存储方式是可以变更的，可以通过 plugin 来实现，可以参考 [Plugins 开发说明](dev-plugins.md) 中的 `AccountPatchReviewStore` 部分。例如，如果 gerrit 配置多主机集群模式的话，`reviewed flags` 可以存储在 MySQL 中，并在各个主机节点中进行复制。

## Account Sequence

`Account Sequence` 存储在 `All-Users` 的 `refs/sequences/accounts` 分支的文本文件中。

计数的增加的时候，git ref 会进行相应的更新，并且多个进程在处理同一个序列。为了缓存这些 ref 的更新，进程把计数器设定了一个比较大的值，直到缓存用尽，再进行分配。每个进程一次检索用户 ID 的数量通过 `gerrit.config` 文件中的 `notedb.accounts.sequenceBatchSize` 参数进行控制。

## Replication

`All-Users` 的下列 refs 一定要进行 replication：

* `refs/users/*` (user branches)
* `refs/meta/external-ids` (external IDs)
* `refs/starred-changes/*` (star labels)
* `refs/sequences/accounts` (账户的序列号，gerrit 的 replicas 不需要此分支)

