# passwd

## NAME
passwd - 设置 secure.config 文件中的密码

## SYNOPSIS
```
_java_ -jar gerrit.war _passwd_
  -d <SITE_PATH>
  <SECTION.KEY>
  [PASSWORD]

```

## DESCRIPTION
设置 secure.config 文件中的密码，通过命令行交互的方式来完成。

## OPTIONS

**-d**
**--site-path**
	gerrit 的初始化目录的位置。

## ARGUMENTS

**SECTION.KEY**
	`secure.config` 文件设置密码的部分。

**PASSWORD**
	与 `SECTION.KEY` 对应的密码。batch 模式下，忽略交互方式。

## CONTEXT

当配置加密的密码时，此命令十分有用。

