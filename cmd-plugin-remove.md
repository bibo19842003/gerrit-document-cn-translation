# plugin remove

## NAME
plugin remove - 禁用 plugin

plugin rm - 禁用 plugin

## SYNOPSIS
```
_ssh_ -p <port> <host> _gerrit plugin remove_ | _rm_
  <NAME> ...
```

## DESCRIPTION
禁用 plugin。禁用后，plugin 名称将变更为  `<plugin-jar-name>.disabled`。

## ACCESS
* 需要有管理员权限
* `$site_path/etc/gerrit.config` 需要启动 `plugins.allowRemoteAdmin`。
* 强制性的 plugin 不能被禁用。

## SCRIPTING
建议在脚本中执行此命令

## OPTIONS
**<NAME>**
	禁用的 plugin 名称

## EXAMPLES
禁用 plugin

```
ssh -p 29418 localhost gerrit plugin remove my-plugin
```

