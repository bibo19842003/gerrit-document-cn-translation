# rulec

## NAME
rulec - 编译具体 project 的 Prolog rule 到 JAR 文件。

## SYNOPSIS
```
_java_ -jar gerrit.war _rulec_
  -d <SITE_PATH>
  [--quiet]
  [--all | <PROJECT>...]
```

## DESCRIPTION
可以在 project 的 `refs/meta/config` 分支上查看 `rules.pl` 文件。如果此文件存在，可以生成一个格式为 `rules-'SHA1'.jar` 的 jar 文件，然后将其放到目录 `'$site_path'/cache/rules` 中。

## OPTIONS
**-d**
**--site-path**
	gerrit 的初始化目录的位置。

**--all**
	为所有的 project 编译 rule

**--quiet**
	非 error 信息不输出

<PROJECT>:
	为指定的 project 编译 rule

## CONTEXT
此命令只在服务器端运行，并需要管理员权限。

需要启动 cache。

## EXAMPLES
为 test/project 编译出 rule 的 jar 文件：

```
	$ java -jar gerrit.war rulec -d site_path test/project
```

