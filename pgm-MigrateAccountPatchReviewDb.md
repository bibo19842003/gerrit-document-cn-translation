# MigrateAccountPatchReviewDb

## NAME
MigrateAccountPatchReviewDb - AccountPatchReviewDb 的迁移

## SYNOPSIS
```
_java_ -jar gerrit.war MigrateAccountPatchReviewDb
  -d <SITE_PATH>
  [--sourceUrl] [--chunkSize]
```

## DESCRIPTION
AccountPatchReviewDb 从一个数据库迁移到另外一个数据库。

此命令只在 `accountPatchReviewDb.url` 参数变更时使用。

迁移步骤:

* 停止 Gerrit 服务
* 配置 `accountPatchReviewDb.url` 新参数
* 运行数据库迁移命令
* 启动 Gerrit 服务

**NOTE:**
*如果使用 MySQL, `account_patch_reviews` 表中的 `file_name` 字段的长度需要设置为 255 characters，而不是 4096 characters。因为 [MySQL 限制](https://dev.mysql.com/doc/refman/5.7/en/innodb-restrictions.html)（每列的索引上限是 767 bytes）导致。*

## OPTIONS

**-d**
**--site-path**
	gerrit 的初始化目录的位置。

**--sourceUrl**
	原数据库如果不是默认的 H2 ,那么需要指定具体的 Url。

**--chunkSize**
	每次传递 Chunk 的大小。默认是 100000。

## CONTEXT
此命令只在服务器端运行并且可以连接数据库。

## EXAMPLES
从 H2 迁移到其他数据库，命令如下：

```
	$ java -jar gerrit.war MigrateAccountPatchReviewDb -d site_path
```

## SEE ALSO

* 参数配置请参考 [accountPatchReviewDb.url](config-gerrit.md) 的 accountPatchReviewDb 部分。

