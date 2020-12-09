# gerrit create-account

## NAME
gerrit create-account - 创建用户

## SYNOPSIS
```
_ssh_ -p <port> <host> _gerrit create-account_
  [--group <GROUP>]
  [--full-name <FULLNAME>]
  [--email <EMAIL>]
  [--ssh-key - | <KEY>]
  [--http-password <PASSWORD>]
  <USERNAME>
```

## DESCRIPTION
创建用户

创建用户时如果没有添加 email，那么只能创建 batch 角色，例如自动构建系统的帐号，或者用于监控 [gerrit stream-events](cmd-stream-events.md) 的帐号。

batch 角色的帐号，需要添加到群组 'Service Users' 中。

如果使用了 LDAP 认证的方式，创建用户的时候不会与校验 LADP 系统进行校验，因此有时会创建出 LDAP 系统中不存在的帐号。

## ACCESS
需要有管理员权限

## SCRIPTING
建议在脚本中执行此命令

## OPTIONS
**<USERNAME>**
	必要; 新用户名称

**--ssh-key**
	导入 ssh-key 公钥的内容。参数 `-` 说明需要导入。

**--group**
	新用户要添加到的群组名称

**--full-name**
	新用户的全名

 名字中如果有空格的话，需要加单引号 (') 如：`--full-name "'A description string'"`

**--email**
	新用户的 email

**--http-password**
	新用户的 HTTP 密码

## EXAMPLES
创建用户 `watcher` ，batch 角色，并添加到群组 'Service Users'

```
$ cat ~/.ssh/id_watcher.pub | ssh -p 29418 review.example.com gerrit create-account --group "'Service Users'" --ssh-key - watcher
```

