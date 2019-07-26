# LocalUsernamesToLowerCase

## NAME
LocalUsernamesToLowerCase - 将用户名转换为小写

## SYNOPSIS
```
_java_ -jar gerrit.war _LocalUsernamesToLowerCase_
  -d <SITE_PATH>
```

## DESCRIPTION
将用户名转换为小写。此用户名用于登录 gerrit 页面。

```
**重要：**
此命令不修改 `username` scheme 中的用户名。
```

如果关联了 LDAP 系统，需要在 `gerrit.config` 文件中设置 `ldap.localUsernameToLowerCase` 属性值为 `true` 以后，再执行此命令。

转换为小写后，不能再转换为大写，过程不可逆。

如果帐号中有相同的用户名，那么执行过程中会报错，报错帐号并不执行转换。

当所有的帐号转换后，系统会自动执行 [reindex](pgm-reindex.md) 来重新对帐号执行索引操作。

运行此命令需要先暂停 gerrit 服务。

## OPTIONS

**-d**
**--site-path**
	gerrit 的初始化目录的位置。

## CONTEXT
此命令只在服务器端运行。

## EXAMPLES
将用户名转换为小写:

```
	$ java -jar gerrit.war LocalUsernamesToLowerCase -d site_path
```

## SEE ALSO

* 参数配置可以参考 [ldap.localUsernameToLowerCase](config-gerrit.md) 的 localUsernameToLowerCase 部分

