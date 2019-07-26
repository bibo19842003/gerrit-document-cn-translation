# gerrit flush-caches

## NAME
gerrit flush-caches - 刷新内存中的缓存

## SYNOPSIS
```
_ssh_ -p <port> <host> _gerrit flush-caches_ --all
_ssh_ -p <port> <host> _gerrit flush-caches_ --list
_ssh_ -p <port> <host> _gerrit flush-caches_ --cache <NAME> ...
```

## DESCRIPTION
清除内存中的缓存，根据相关配置文件重新将信息载入缓存。

如果管理员直接在 project 中修改了 NoteDb metadata ，需要手动刷新缓存。

默认参数：`--all`.

## ACCESS

需要有管理员权限或者下面其中的一个权限。

* `Flush Caches` ，不包括 "web_sessions"
* `Maintain Server`，不包括 "web_sessions"
* `Administrate Server`，包括 "web_sessions"

## SCRIPTING
建议在脚本中执行此命令

## OPTIONS
**--all**
	刷新所有的缓存。此参数不刷新 "web_sessions"。

**--list**
	显示可以刷新的缓存

**--cache <NAME>**
	刷新具体的缓存

## EXAMPLES
显示可以刷新的缓存:

```
$ ssh -p 29418 review.example.com gerrit flush-caches --list

accounts
groups
ldap_groups
openid
projects
sshkeys
web_sessions
```

刷新所有的缓存:

```
$ ssh -p 29418 review.example.com gerrit flush-caches --all
```

或

```
$ ssh -p 29418 review.example.com gerrit flush-caches
```

只刷新 "sshkeys" 缓存:

```
$ ssh -p 29418 review.example.com gerrit flush-caches --cache sshkeys
```

刷新 "web_sessions" 缓存，所有的用户需要重新登录:

```
$ ssh -p 29418 review.example.com gerrit flush-caches --cache web_sessions
```

## SEE ALSO

* [gerrit show-caches](cmd-show-caches.md)
* [系统配置](config-gerrit.md) 中的 Cache 部分

