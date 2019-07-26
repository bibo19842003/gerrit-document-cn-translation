# gerrit ls-groups

## NAME
gerrit ls-groups - 列出当前用户可以看到的群组

## SYNOPSIS
```
_ssh_ -p <port> <host> _gerrit ls-groups_
  [--project <NAME> | -p <NAME>]
  [--user <NAME> | -u <NAME>]
  [--owned]
  [--visible-to-all]
  [-q <GROUP>]
  [--verbose | -v]
```

## DESCRIPTION
列出当前用户可以看到的群组，每行一个群组名称

如果当前用户是管理员，那么会列出所有群组。

## ACCESS
需要 SSH 访问权限

## SCRIPTING
建议在脚本中执行此命令

所有的非显示字符(ASCII 值小于等于 31)会根据语言类型(C, Python, Perl)进行转义输出，如：`\n` and `\t`, `\xNN` 等。shell 脚本中, `printf` 命令可以进行非转义输出。

## OPTIONS
**--project**
**-p**
	描述的是列出 project 及 所继承的 project 中配置的群组名称。

 此参数不能和参数 '--user' 一起使用.

**--user**
**-u**
	列出某用户所在的群组。

  需要当前用户为群组 owner 或管理员。

  此参数不能和 '--project' 参数一起使用。

**--owned**
	列出群组 owner 是用户的群组，需要和参数 `--user` 一起使用， `--user` 默认值是当前用户。

**--visible-to-all**
	显示只有所有注册用户可以看到的群组(被标识为所有注册用户可见)。

**-q**
	用于检验。例如：与参数 `--owned` ， `--user` 一起使用，检验群组的 owner 是否为用户。

**--verbose**
**-v**
	输出详细信息，使用 `tab` 对组名, UUID, description, owner 组名, owner group UUID，是否全员可见 (`true` or `false`) 进行分隔。如果群组没有 owner 群组，那么 owner 组名的那列显示为 `n/a`.

## EXAMPLES

列出可以看到的群组:
```
$ ssh -p 29418 review.example.com gerrit ls-groups
Administrators
Anonymous Users
MyProject_Committers
Project Owners
Registered Users
```

列出 "MyProject" 设置的群组:
```
$ ssh -p 29418 review.example.com gerrit ls-groups --project MyProject
MyProject_Committers
Project Owners
Registered Users
```

列出当前人员为 owner 的群组：
```
$ ssh -p 29418 review.example.com gerrit ls-groups --owned
MyProject_Committers
MyProject_Verifiers
```

检验当前用户是否为群组 `MyProject_Committers` 的 owner，如果返回 `MyProject_Committers` ，说明是此群组 owner 。
```
$ ssh -p 29418 review.example.com gerrit ls-groups --owned -q MyProject_Committers
MyProject_Committers
```

提取 'Administrators' 群组的 UUID:

```
$ ssh -p 29418 review.example.com gerrit ls-groups -v | awk '-F\t' '$1 == "Administrators" {print $2}'
ad463411db3eec4e1efb0d73f55183c1db2fd82a
```

提取 'Administrators' 群组的描述：

```
$ printf "$(ssh -p 29418 review.example.com gerrit ls-groups -v | awk '-F\t' '$1 == "Administrators" {print $3}')\n"
This is a
multi-line
description.
```

