# Gerrit Code Review - Backup

Gerrit 的一些数据需要 backup，此文档介绍了如何 backup 相关数据。

## 必须备份的数据

**Git repositories**

Gerrit 的 git project 默认存放在 `${SITE}/git` 目录中，具体存放目录可以参考 `${SITE}/etc/gerrit.config` 文件。从 3.0 版本以及 2.15 开始，change、 review metadata、 accounts、 groups 的数据存放在 project 中的 _NoteDb_ 中。

**SQL database**

Gerrit 2.x 版本：在安装 Gerrit 的时候，需要选择把一些数据放到数据库中。若使用 2.16 版本，如果配置了 _NoteDb_，那么只有 schema version 信息存放在数据库中。如果使用了 h2, 需要备份 `${SITE}/db` 目录中的 `.db` 文件。其他的数据库需要参考对应的备份文档。

Gerrit 3.x 及以后版本：所有的 primary 数据存放在 project 的 _NoteDb_ 中。只有 Gerrit UI 的 review 标记的相关信息存放在数据库中，如果配置的是 h2, 那么对应的数据库名称为 `account_patch_reviews.h2.db`。

## 选择备份的数据

**Search index**

用于搜索的 _Lucene_ index 存放在 `${SITE}/index` 目录。如果重新生成的话需要较长的时间。

_Elastic Search_ 的 index 备份可以参考 [备份说明](https://www.elastic.co/guide/en/elasticsearch/reference/current/modules-snapshots.html)。

**Caches**

Gerrit 的 caches 是自动生成的，存放在 `${SITE}/cache` 目录。即使重启，缓存数据也保持不变，因为重新生成缓存数据需要较长的时间。。

**Configuration**

Gerrit 的配置文件存放在 `${SITE}/etc` 目录中，secrets 相关文件也在此目录中，如：

* `secure.config` 包含密码和 `auth.registerEmailPrivateKey`
* public、private SSH host keys

可以考虑使用 [secure-config plugin](https://gerrit.googlesource.com/plugins/secure-config/) 加密 secrets 相关文件。

**Plugin Data**

`${SITE}/data/` 目录存放了 plugin 的相关数据文件，如：delete-project 和 replication plugin.

**Libraries**

`${SITE}/lib/` 目录存放了 plugin 依赖的相关文件。

**Plugins**

`${SITE}/plugins/` 目录存放了安装的 plugin。

**Static Resources**

`${SITE}/static/` 目录存放了静态资源文件，用于 Gerrit UI 的定制和 email 模板。

**Logs**

`${SITE}/logs/` 目录存放了相关的 log 文件。

## 备份的一致性

下面是 `primary data` 的备份方法。

### 使用文件系统的 snapshots

**Gerrit 3.0 及以后版本**

* 所有的 primary data 存放在 git 中
* 文件系统，如：lvm, zfs, btrfs 或 nfs 支持 snapshots 功能，可以对 snapshots 进行归档。

**Gerrit 2.x 版本**

Gerrit 2.16 如果使用了 _NoteDb_ ，对 Gerrit 的安装目录进行 Snapshot，以及对数据库进行备份。

2.x 的其他版本，change meta data、 review comments、 votes、accounts、 group 信息都存放在 SQL 数据库中。数据库的存储的信息和 git project 是有关联关系的，备份时需要关闭 gerrit 的写服务，这样可以保证数据库中的信息和 git project 中的信息是一致的。

### 备份时，primary 服务器需要设置只读模式

确保备份时，primary 服务器需要设置只读模式。可以使用 [_readonly_](https://gerrit.googlesource.com/plugins/readonly/) plugin。

### Replicate 操作

Replicate 可以备份 git project 中的重要数据，但有些数据不会进行备份，例如： project description file, ref-logs, git configs, 和 alternate configs。

Replicate 可以使用命令：`git clone --mirror`, 也可以使用 [replication plugin](https://gerrit.googlesource.com/plugins/replication) 或 [pull-replication plugin](https://gerrit.googlesource.com/plugins/pull-replication)。

推荐使用文档系统的 snapshot 功能进行备份归档操作。

不要忽略备份的数据，有时，可以从备份中恢复一些被删除的数据。

Replication 可以关闭删除操作，可以参考 [server 配置](https://gerrit.googlesource.com/plugins/replication/+/refs/heads/master/src/main/resources/Documentation/config.md) 的 
`remote.NAME.replicateProjectDeletions` 部分。

可以使用备份对 gerrit 的下载进行数据分流。

### 备份时，将 primary 服务器关闭写操作

备份时，primary 服务器需要设置只读模式或停止服务。

## 备份方法

### 文档系统的 snapshots

**snapshots 的备份和恢复**

支持 snapshots 的文件系统：[btrfs](https://btrfs.wiki.kernel.org/index.php/SysadminGuide#Snapshots) 或 [zfs](https://wiki.debian.org/ZFS#Snapshots).

**其他支持 snapshots 的文件系统**
[lvm](https://wiki.archlinux.org/index.php/LVM#Snapshots) 或 nfs。

创建并归档 snapshot。

在其他数据中心备份 snapshot。W

**3.0 or newer**
Gerrit 的安装目录进行 Snapshot 。

**2.x**
Gerrit 的安装目录需要进行 Snapshot，以及数据库需要备份。

### 其他备份方法

备份时，服务器需要设置为只读模式，避免数据不一致导致备份文件不能使用（有些数据是有关联性的），备份操作如下：

* 使用 `tar.gz` 操作
* `rsync`
* `cp`

## 备份测试

确保可以快速有效的恢复数据。

## 灾难恢复

### 备份数据的归档

需要将备份数据备份到其他的数据中心。并使用备份数据进行恢复。

### Multi-site 配置

使用 [multi-site plugin](https://gerrit.googlesource.com/plugins/multi-site) 来将 Gerrit 安装到不同的数据中心。这样可以确保如果某个 Gerrit 出现问题的时候，其他数据中心的 Gerrit 仍然可以提供持续不断的服务。

