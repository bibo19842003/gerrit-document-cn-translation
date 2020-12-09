# gerrit create-group

## NAME
gerrit create-group - 创建群组

## SYNOPSIS
```
ssh -p <port> <host> gerrit create-group
  [--owner <GROUP> | -o <GROUP>]
  [--description <DESC> | -d <DESC>]
  [--member <USERNAME>]
  [--group <GROUP>]
  [--visible-to-all]
  <GROUP>
```

## DESCRIPTION
创建一个新的用户群组。命令行群组创建后，创建者不会自动被添加到群组中，这个地方和网页上创建群组有点差异。

## ACCESS
需要有管理员权限

## SCRIPTING
建议在脚本中执行此命令

## OPTIONS
**<GROUP>**
	必要; 新群组的名称

**--owner, -o**
	新群组的 owner 群组，如果不指定，owner 群组默认为新群组。

**--description, -d**
	群组描述

 描述中如果有空格的话，需要加单引号 (') 如：`--full-name "'A description string'"`

**--member**
	添加的群组成员。

 添加 gerrit 系统不存在的用户会报错，使用 LDAP 认证的情况除外。如果 LDAP 的用户没有找到，那么会到 LDAP 系统中进行查找，查找通过后，可以添加到群组中。

**--group**
	添加的子群组。

**--visible-to-all**
	是否全员可见，默认不启动此参数。

## EXAMPLES
创建新群组 `gerritdev` ，添加两个成员 `developer1` 和 `developer2`，指定 owner 群组为自身群组:

```
$ ssh -p 29418 user@review.example.com gerrit create-group --member developer1 --member developer2 gerritdev
```

创建新群组 `Foo` ，设置 owner 群组为 `Foo-admin`，并添加成员 `developer1`:

```
$ ssh -p 29418 user@review.example.com gerrit create-group --owner Foo-admin --member developer1 --description "'Foo description'" Foo
```

 **重要** 添加的描述中，如果有空格，要添加两次引号。

