
# Gerrit Code Review - Groups

## Overview

在 Gerrit 中，我们通过群组来给用户分配权限。群组可以来自外部的系统，如 LDAP。但是，gerrit 也有内部的群组。

gerrit 从 2.16 开始，群组的元数据信息存储在 [NoteDb](note-db.md) 。

一个群组有如下特征：

* 列举成员 (帐号)
* 列举子群组
* 属性
  - 全员可见
  - 群组 owner

群组可以通过下列属性进行唯一的标识：

* GroupID, 数据库的序列号

* UUID, 40位的字符串

* Name: Gerrit 中的名称

## Storage format

群组的数据存储在 `All-Users` repository 中。每个群组，都有对应的一个 UUID 命名的 ref。

```
  refs/groups/ef/deafbeefdeafbeefdeafbeefdeafbeefdeafbeef
```

ref 包含如下文件：

* `members`, holding numeric account IDs of members, one per line
* `subgroups`, holding group UUIDs of subgroups, one per line
* `group.config`, holding further configuration.

`group.config` 文件的格式如下：

```
[group]
  name = <name of the group>
  id = 42
  visibleToAll = false
  description = <description of the group>
  groupOwnerUuid = <UUID of the owner group>
```

Gerrit 基于 REST API 来更新群组的 ref，使用 commit 的方式来记录每次的更新。

为了确保群组名称的唯一性，一个独立的 ref ：`refs/meta/group-names` 包含了一个 notemap，map 表示了分支对应文件的列表。

此 map 的格式如下：

* keys : SHA-1 样式的组名
* values : 类似 blob

```
[group]
  name = <name of the group>
  uuid = <hex UUID identifier of the group>
```

为了确保 ID 的唯一性，新群组的 ID 来自 `refs/sequences/groups` 下面的序列计算，与用户和 change 类似。

## Visibility

群组的所有权和 `visibleToAll` 决定了群组是否被用户可见。

只有群组的 owner 有此 ref 的读权限，即使非 owner 角色的用户有读权限，也不能查看或下载此 ref。另外，如果用户有了 `Access Database` 权限，那么可以访问所有群组的 refs。

## Pushing to group refs

目前，未实现向群组的 ref 推送 change，因此所有推送的时候会被拒绝。应该避免不经过 gerrit 的 push，因为 names, IDs 和 UUIDs 在所有的分支之间需要保证内部的一致性。另外，群组的 refs 不能手动的创建或者删除。如果需要手动操作，操作后，一定要手动 reindex 这些群组。

## Replication

在 replication 的设置中(backups 或者 primary/replica 配置)，`All-Users` 所有的 refs 需要进行传递，包括 `refs/groups/*`, `refs/meta/group-names` 和 `refs/sequences/groups`。

