# prolog-shell

## NAME
prolog-shell - 简单的交互式环境

## SYNOPSIS
```
_java_ -jar gerrit.war _prolog-shell_
  [-q] [-s FILE.pl ...]
```

## DESCRIPTION
提供一个简单的交互式环境，用于开发人员测试。

## OPTIONS
**-q**
	不显示提示信息。
**-s**
	启动 gerrit 的时候 加载 `['FILE.pl'].` ，可同时加载多个文件。

## EXAMPLES
定义一个声明并对声明进行测试。

```
	$ cat >simple.pl
	food(apple).
	food(orange).
	^D

	$ java -jar gerrit.war prolog-shell -s simple.pl
	Gerrit Code Review 2.2.1-84-ge9c3992 - Interactive Prolog Shell
	based on Prolog Cafe 1.2.5 (mantis)
	         Copyright(C) 1997-2009 M.Banbara and N.Tamura
	(type Ctrl-D or "halt." to exit, "['path/to/file.pl']." to load a file)

	{consulting /usr/local/google/users/sop/gerrit/gerrit/simple.pl ...}
	{/usr/local/google/users/sop/gerrit/gerrit/simple.pl consulted 99 msec}

	| ?- food(Type).

	Type = apple ? ;

	Type = orange ? ;

	no
	| ?-
```

