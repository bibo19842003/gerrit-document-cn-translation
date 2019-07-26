# plugin ls

## NAME
plugin ls - 显示已安装的 plugin

## SYNOPSIS
```
_ssh_ -p <port> <host> _gerrit plugin ls_
  [--all | -a]
  [--format {text | json | json_compact}]
```

## DESCRIPTION
显示已安装 plugin 的版本及状态

## ACCESS
* 需要有管理员权限或者 `View Plugins` 权限
* `$site_path/etc/gerrit.config` 需要启动 `plugins.allowRemoteAdmin`。

## SCRIPTING
建议在脚本中执行此命令

## OPTIONS
**--all**
**-a**
	列出所有 plugin，包括禁用的 plugin

**--format**
	输出格式

```
**`text`** 文本格式
**`json`** JSON 格式
**`json_compact`** 最小 JSON 格式
```

