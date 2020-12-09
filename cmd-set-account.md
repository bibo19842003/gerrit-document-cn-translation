# gerrit set-account

## NAME
gerrit set-account - 更改用户的设置

## SYNOPSIS
```
ssh -p <port> <host> gerrit set-account
  [--full-name <FULLNAME>] [--active|--inactive]
  [--add-email <EMAIL>] [--delete-email <EMAIL> | ALL]
  [--preferred-email <EMAIL>]
  [--add-ssh-key - | <KEY>]
  [--delete-ssh-key - | <KEY> | ALL]
  [--generate-http-password]
  [--http-password <PASSWORD>]
  [--clear-http-password] <USER>
```

## DESCRIPTION
更改用户的设置。对失效用户进行操作很有帮助，如：设置 HTTP 密码，添加或删除 key 等。

修改邮箱信息时，不需要网页上的验证。

## ACCESS
用户可以更新自己的帐号设置。如果要更新其他用户的设置，需要管理员权限或 'Modify Account' 权限。

由于安全原因，只有管理员才可以添加或删除 SSH KEY。

设置用户密码 (参数 --http-password) 或清除用户密码 (option --clear-http-password) 需要管理员权限。

## SCRIPTING
建议在脚本中执行此命令

## OPTIONS
**<USER>**
    必要; 可以是全名，email，用户名，account-id 

**--full-name**
    设置用户的全名，页就是用户显示的名称。

 名字如果含有空格，需要加单引号(')，整体再用双引号，如：`--full-name "'A description string'"`。

**--active**
    激活用户。

**--inactive**
    将用户设置为失效。用户将不能登录。

**--add-email**
    添加邮箱时，不需要网页上的验证。

**--delete-email**
    删除 email。如果参数值是 'ALL', 那么将删除此用户的所有的 email。

**--preferred-email**
    设置默认 email。email 需要用户之前在系统中注册过。

**--add-ssh-key**
    添加用户的 SSH KEY。如果输入 `-`，那么 key 来源与标输入，而不是命令行。

**--delete-ssh-key**
    删除用户的 SSH KEY。如果输入 `-`，那么 key 来源与标输入，而不是命令行；如果参数值是 'ALL', 表示删除所有的 key。

**--generate-http-password**
    生成 HTTP 的随机密码，成功后，命令行会显示密码。

**--http-password**
    设置 HTTP 密码

**--clear-http-password**
    清除 HTTP 密码

## EXAMPLES
给用户 `watcher` 添加 email 和 SSH KEY:

```
$ cat ~/.ssh/id_watcher.pub | ssh -p 29418 review.example.com gerrit set-account --add-ssh-key - --add-email mail@example.com watcher
```

