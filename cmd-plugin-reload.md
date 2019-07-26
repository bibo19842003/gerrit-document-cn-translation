# plugin reload

## NAME
plugin reload - 重载 plugin

## SYNOPSIS
```
_ssh_ -p <port> <host> _gerrit plugin reload_
  <NAME> ...
```

## DESCRIPTION
重载 plugin

plugin 的 reload 和 restart 的定义可以参考 [Plugins 开发](dev-plugins.md) 的 `reload method` 章节。

如果 plugin 的配置文件变更了，此时可以使用此命令重新加载配置文件。

## ACCESS
* 需要有管理员权限
* `$site_path/etc/gerrit.config` 需要启动 `plugins.allowRemoteAdmin`。

## SCRIPTING
建议在脚本中执行此命令

## OPTIONS
**<NAME>**
	重载的 plugin 的名称。

## EXAMPLES
重载 plugin

```
ssh -p 29418 localhost gerrit plugin reload my-plugin
```

