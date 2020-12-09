# plugin reload

## NAME
reload-config - Reloads the gerrit.config.

## SYNOPSIS
```
ssh -p <port> <host> gerrit reload-config <NAME> ...
```

## DESCRIPTION
重载 gerrit.config

不是所有的修改都可以重载，只有文档 [系统配置](config-gerrit.md) 支持的才可以重载。

_系统会输出已生效的变更。_

如果在文件中添加或者删除某些条目后，没有发生变化，有可能是系统默认值导致的。

## ACCESS
需要有管理员权限

## SCRIPTING
建议在脚本中执行此命令

## EXAMPLES
重载 gerrit.config:

```
ssh -p 29418 localhost gerrit reload-config
```

