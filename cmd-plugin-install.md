# plugin install

## NAME
plugin install - 安装 plugin.

plugin add - 安装 plugin.

## SYNOPSIS
```
_ssh_ -p <port> <host> _gerrit plugin install_ | _add_
  [--name <NAME> | -n <NAME>]
  - | <URL> | <PATH>
```

## DESCRIPTION
安装 plugin。需要把 plugin 放到 gerrit 安装目录的 `plugins` 目录中。

## ACCESS
* 需要有管理员权限
* `$site_path/etc/gerrit.config` 需要启动 `plugins.allowRemoteAdmin`。

## SCRIPTING
建议在脚本中执行此命令

## OPTIONS
**-**
	Plugin 的 jar 文件或者 js 文件通过管道输入安装。

**<URL>**
	plugin 文件的地址。

**<PATH>**
	plugin 文件的绝对路径。

**--name**
**-n**
	plugin 文件的名称。如果 MANIFEST 文件中提供了名字，那么安装后，MANIFEST 中的名字会覆盖当前参数的值。

## EXAMPLES
从服务器的绝对路径安装 plugin:

```
ssh -p 29418 localhost gerrit plugin install -n name.jar $(pwd)/my-plugin.jar
```

从服务器的绝对路径安装 WebUI plugin:

```
ssh -p 29418 localhost gerrit plugin install -n name.js $(pwd)/my-webui-plugin.js
```

从 HTTP 网站安装 plugin:

```
ssh -p 29418 localhost gerrit plugin install -n name.jar http://build-server/output/our-plugin
```

从管道安装 plugin:

```
ssh -p 29418 localhost gerrit plugin install -n name.jar - <target/name-0.1.jar
```

