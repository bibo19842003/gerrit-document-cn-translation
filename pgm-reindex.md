# reindex

## NAME
reindex - 重新构建 secondary index

## SYNOPSIS
```
_java_ -jar gerrit.war _reindex_
  -d <SITE_PATH>
  [--threads]
  [--changes-schema-version]
  [--verbose]
  [--list]
  [--index]
```

## DESCRIPTION
重新构建 secondary index.

## OPTIONS
**--threads**
	构建时的线程数量

**--changes-schema-version**
	secondary index 后使用的 Schema 版本。默认是最新版本。

**--verbose**
	输出调试信息。

**--list**
	显示 index 信息

**--index**
	对指定的 index 进行重构

## CONTEXT
必须要启用 secondary index。

