# gerrit convert-ref-storage

## NAME
gerrit 将 ref 转换为 reftable 存储(目前处于试验阶段).

reftable 文件是便携式的二进制文件，文件格式可以为 reference 存储进行定制。 

新的存储方式中，reference 可以被排序，线性扫描，查询。

更多信息可以参考 [reftable](https://www.git-scm.com/docs/reftable).

## SYNOPSIS
```
_ssh_ -p <port> <host> _gerrit convert-ref-storage_
  [--format <format>]
  [--backup | -b]
  [--reflogs | -r]
  [--project <PROJECT> | -p <PROJECT>]
```

## DESCRIPTION
将 ref 转换为 reftable 存储

## ACCESS
Administrators

## OPTIONS
**--project**
**-p**
	必要参数; project 的名称

**--format**
	格式转换为: `reftable` 或 `refdir`.
	默认: reftable

**--backup**
**-b**
	对以前 `ref` 存储格式的备份
	默认: true

**--reflogs**
**-r**
	将 reflogs 写入 reftable
	默认: true.

## EXAMPLES

将 project "core" 由 ref 转换为 reftable:
```
$ ssh -p 29418 review.example.com gerrit convert-ref-format -p core
```

