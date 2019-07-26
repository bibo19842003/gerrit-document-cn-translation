# Gerrit Code Review - NoteDb Backend

NoteDb 是下一代的 gerrit 后台存储，用来取代 change，账户和群组元数据的传统 SQL 后台存储。

_优势_
- *简单*: 所有的数据都存储在本地的 project 中。一些数据不在存储在外部的数据库中。
- *一致性*: Replication 和 备份只使用 refs 的 snapshot ，change 的元数据可以直接指向相关的 refs。
- *审计*: 之前在数据库中，每行表示一个修改记录；现在用 git commit 来标识修改记录。
- *扩展*: Plugin 开发人员可以方便的在元数据中添加新的字段；而之前，添加新的字段的话需要在数据库中操作。
- *新特性*: gerrit 服务器之间的联系更加方便；线下的 code review 可以更好的和其他工具集成。

## Current Status

- 在发布的 2.15 版本中，已实现 notedb 对 change 元数据的存储。对于新站点来说，默认使用 notedb。
- 管理员可以通过线下或线上工具来实现 change 的元数据从 ReviewDb 迁移到 notedb。
- 在发布的 2.15 版本中，已实现 notedb 对 用户元数据的存储。在执行 gerrit 升级过程中，用户的元数据从 ReviewDb 自动迁移到 notedb。
- 在发布的 2.16 版本中，已实现 notedb 对 群组元数据的存储。在执行 gerrit 升级过程中，群组的元数据从 ReviewDb 自动迁移到 notedb。
- `googlesource.com` 上的账户, 群组 和 change 的元数据已经集成到了 notedb。换句话说，[gerrit-review](https://gerrit-review.googlesource.com/) 已经在使用 notedb 了。
- NoteDb 目前只有 Gerrit 3.0 支持。change 数据的迁移工具只存在于 Gerrit 2.15 和 2.16 版本中，Gerrit 3.0 不包含此工具。

例如，对应 notedb 中 change ，下载命令为:

```
  git fetch https://gerrit.googlesource.com/gerrit refs/changes/70/98070/meta \
      && git log -p FETCH_HEAD
```

## Migration

对于比较大的站点来说，元数据从数据库迁移到 notedb ，无论是线下还是线上的操作都需要很长的时间。

只有 change 的 元数据需要手动进行迁移；账户和群组的元数据在 `gerrit.war init` 时会自动迁移。

### Online

**NOTE:**
*只有可以在 2.x 版本中可以执行在线数据迁移。若 2.14.x 或 2.15.x 要升级到到 3.0，需要先升级到 2.16.x*

启动在线迁移，需要在 `gerrit.config` 文件中设置 `noteDb.changes.autoMigrate` 参数，并重启 gerrit 服务：

```
[noteDb "changes"]
  autoMigrate = true
```

另外，也可以 对 `gerrit.war daemon` 通过添加参数 `--migrate-to-note-db` 来实现：

```
  java -jar gerrit.war daemon -d /path/to/site --migrate-to-note-db
```

上面两种方法的在线操作是相同的。一旦开始操作，可以随时重启 gerrit 服务，因为迁移会从中断的地方继续操作。迁移的过程会在 gerrit 的 log 中显示。

_优势_

* 不需要暂停 gerrit 服务

_劣势_

* 不能在 3.0 版本使用，只能在 2.x 版本使用。
* 只能使用单线程操作，速度比线下迁移要慢。
* 服务器的性能会下降，因为在迁移的时候，数据需要同时写入 ReviewDb 和 notedb。

### Offline

线下操作，可添加 `migrate-to-note-db` 参数来操作:
```
  java -jar gerrit.war migrate-to-note-db -d /path/to/site
```

迁移开始，可以取消，重启迁移操作，或者切换到线上操作。

**NOTE:**
*数据迁移需要使用 heap，默认情况下大小和 gerrit 配置的 heap 相同。也可以在使用 `gerrit.war daemon` 命令时添加 `-Xmx` 参数来实现。*

_优势_

* 可以多线程执行，比线上操作要快。
* 不会影响服务器的性能，因为只往一个地方写入数据

_劣势_

* 只有 gerrit 2.15 和 2.16 可以使用
* 需要大量的停机时间。差不多是 [offline reindex](pgm-reindex.md) 两倍的时间。

#### Trial mode

迁移支持 "trial mode"，change 可以迁移到 notedb，并且 gerrit 运行的时候从 notedb 读取数据；但是此种情况下，数据还是存储在 ReviewDb，只不过会往 notedb 进行同步。

可以添加 `--trial` 参数来启动试验模式：
```shell
  java -jar gerrit.war migrate-to-note-db --trial -d /path/to/site
  # OR
  java -jar gerrit.war daemon -d /path/to/site --migrate-to-note-db --trial
```

或者，设置 `noteDb.changes.trial=true` 在 `gerrit.config` 配置文件中。

下面是使用试验模式的一些场景：

* 可以用来测试数据迁移工具
* 用来测试只有 notedb 才有的特性，如：hashtags

执行试验模式后，可以使用线下或线上的操作来完成数据实际的迁移。若要返回到 ReviewDb-only 模式，可以在配置文件中移除 `noteDb.changes.read` 和 `noteDb.changes.write`，然后重启 gerrit 服务。

## Configuration

数据迁移的过程是：每个环节都会设置 `notedb.config` 参数，然后根据设置的参数进行数据迁移。

首先，先从 `notedb.config` 读取配置，然后再将配置返回到 `gerrit.config`。在不影响数据迁移的情况下可以手动修改 `gerrit.config`，但不能修改 `notedb.config`，可以将 `notedb.config` 中的值拷贝到 `gerrit.config`，迁移完成后，再删除 `notedb.config` 文件。

通常，用户不需要手动设置下面描述的参数，此部分只要用于参考：

- `noteDb.changes.write=true`: 同时往 notedb 写入新 change 的元数据信息。
- `noteDb.changes.read=true`: 从 notedb 读取 change 的元数据信息。先从 reviewdb 中读，再从 notedb 中读，如果数据不一致，reviewdb 中的为准。
- `noteDb.changes.primaryStorage=NOTE_DB`: 新 change 的元数据只写入 notedb。先从 reviewdb 中读，如果没有，再从 notedb 中读取。
- `noteDb.changes.disableReviewDb=true`: 取消对 ReviewDb 中表格的数据使用。

