# plugin enable

## NAME
plugin enable - 启用 plugins

## SYNOPSIS
```
ssh -p <port> <host> gerrit plugin enable <NAME> ...
```

## DESCRIPTION
启用被禁用的 plugin。 `plugins` 目录中，文件名称将由 `<plugin-jar-name>.disabled` 变更为 `<plugin-jar-name>`。

## ACCESS
* 需要有管理员权限
* `$site_path/etc/gerrit.config` 需要启动 `plugins.allowRemoteAdmin`。

## SCRIPTING
建议在脚本中执行此命令

## OPTIONS
**<NAME>**
	被启用 plugin 的名称。

## EXAMPLES
启用 plugin:

```
ssh -p 29418 localhost gerrit plugin enable my-plugin
```

