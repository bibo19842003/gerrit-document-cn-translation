# init

## NAME
init - 初始化 gerrit 安装目录或升级 gerrit 版本。

## SYNOPSIS
```
_java_ -jar gerrit.war _init_
  -d <SITE_PATH>
  [--batch]
  [--delete-caches]
  [--no-auto-start]
  [--skip-plugins]
  [--list-plugins]
  [--install-plugin=<PLUGIN_NAME>]
  [--install-all-plugins]
  [--secure-store-lib]
  [--dev]
  [--skip-all-downloads]
  [--skip-download=<LIBRARY_NAME>]
```

## DESCRIPTION
初始化 gerrit 安装目录，可使用交互的方式来完成。

升级 gerrit，对一些目录（notedb，plugins）进行必要的更新。

## OPTIONS
**-b**
**--batch**
	batch 模式运行，忽略交互式模式。

 如果在此模式中，系统检查到了所集成的未使用的对象 (如 tables, columns)，这些对象不会被删除，如要删除，需要手动执行相关命令。

**--delete-caches**
	重新生成缓存文件，不过需要耗费一些时间。

**--no-auto-start**
	初始化后不启动 gerrit 服务。

**-d**
**--site-path**
	gerrit 的初始化路径。

**--skip-plugins**
	不安装插件。

**--list-plugins**
	列出可以安装的 plugin 信息。

**--install-all-plugins**
	自动安装自带的 plugin，安装过程中，没有交互过程。此按参数可在 batch 模式下使用，但不能与 `--install-plugin` 一起使用。

**--secure-store-lib**
	明确 [SecureStore](dev-plugins.md) 的 jar 的路径。用法与参数 `--new-secure-store-lib` 一样。

**--install-plugin**
	自动安装自带的 plugin，无交互过程。此参数需要提供一个或多个所要安装的 plugin 名称，不能与参数 `--install-all-plugins` 一起使用。

**--dev**
	启用开发者模式。

**--skip-all-downloads**
	不下载相关的二进制文件。可以手动下载放到 `lib/` 目录下。

**--skip-download**
	不下载相关的二进制文件。可以手动下载放到 `lib/` 目录下。

