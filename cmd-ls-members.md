# gerrit ls-members

## NAME
gerrit ls-members - 显示群组成员

## SYNOPSIS
```
_ssh_ -p <port> <host> _gerrit ls-members_ GROUPNAME
  [--recursive]
```

## DESCRIPTION
显示可见群组的成员，每行显示一个用户信息。id, 用户名, 全名 和 email 用 `tab` 分隔。

## ACCESS
需要 SSH 访问权限

## SCRIPTING
建议在脚本中执行此命令。 输出信息有可能是报错信息，除行头外的零行或多行信息。如果字段值为空，会显示 "n/a" 。

所有的非显示字符(ASCII 值小于等于 31)会根据语言类型(C, Python, Perl)进行转义输出，如：`\n` and `\t`, `\xNN` 等。shell 脚本中, `printf` 命令可以进行非转义输出。

## OPTIONS
**--recursive**
	显示群组子群组成员。

## EXAMPLES

显示 Administrators 群组成员:
```
$ ssh -p 29418 review.example.com gerrit ls-members Administrators
id      username  full name    email
100000  jim     Jim Bob somebody@example.com
100001  johnny  John Smith      n/a
100002  mrnoname        n/a     someoneelse@example.com
```

显示不存在的群组成员:
```
$ ssh -p 29418 review.example.com gerrit ls-members BadlySpelledGroup
Group not found or not visible
```

