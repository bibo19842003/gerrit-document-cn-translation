# Gerrit Inspector

## NAME
`Gerrit Inspector` - 给 gerrit 准备的交互式 Jython 环境

## SYNOPSIS
```
_java_ -jar gerrit.war _daemon_
  -d <SITE_PATH>
  [--enable-httpd | --disable-httpd]
  [--enable-sshd | --disable-sshd]
  [--console-log]
  [--slave]
```

## DESCRIPTION
交互式 Jython 环境中 gerrit 的使用可以参考 [Daemon 文档](pgm-daemon.md)。

**CAUTION:**
*`Gerrit Inspector` 直接工作在 JVM 对象的实例上面，并可以像调用 Java 函数一些读写实例的成员，甚至是 'private' 和 'protected' 成员。因此，有可能会改变系统的状态。所以使用时要小心，确保相关的数据不要被破坏。*

## INSTALLATION

`Gerrit Inspector` 需要 Jython 的 lib 库 ('jython.jar') 安装到 '$site_path/lib' 目录下。
Jython 是 JVM 的 python 解释器。，可以从 http://www.jython.org/ 下载。只需要 'jython.jar' 文件，其他的 Jython lib 文件都是非必要的。`Gerrit Inspector` 在 Jython 2.5.2 版本上已经经过了测试，有可能还可以在更早的版本上工作。

## STARTUP

启动时，Jython 会根据 classpath 检查 Java lib 库。如果检查到 lib 库，会显示相关信息：

```
*sys-package-mgr*: processing new jar, '/home/user/.gerritcodereview/tmp/gerrit_4890671371398741854_app/sshd-core-0.5.1-r1095809.jar'
```

在此之后，一个系统范围的嵌入的脚本开始安装使用。此脚本归档在 gerrit 的 war 文件中。脚本通过控制台会产生如下输出信息：

```
"Shell" is "com.google.gerrit.pgm.shell.JythonShell@61644f2d"
"m" is "com.google.gerrit.lifecycle.LifecycleManager@6f03b248"

Welcome to the `Gerrit Inspector`
Enter help() to see the above again, EOF to quit and stop Gerrit
```

此时，系统会处理一些非必要的用户脚本。脚本在用户的根目录下面：'.gerritcodereview/Startup.py'。

此脚本可以访问系统中所有定义的变量 (如：上面脚本中的变量)。启动脚本已定义的变量和函数可以被解释器访问使用。

当解释器退出的时候，gerrit 实例会关闭。

## USING THE INTERPRETER

`Gerrit Inspector` 在 gerrit 的 JVM 中启动 Jython 的解释器。用户可以使用所有 Jython 及 Python 的功能。

也可以使用一些额外的功能，如：把 Jython 所发布的 'Lib' 文件夹下的文件放到 '$site_path/lib/Lib' 目录下，然后可以使用更多的 Python 标准模块。Jython 可以使用更多的 Java classes 和 lib 文件以及 Python 模块和脚本。

Inspector 默认可以在 JVM 中访问可用的 classes 和 对象以及可用的 *private* and *protected* 成员。

Jython 的更多使用，特别是在 JVM 中的限制，可以参考 [Jython 文档](http://www.jython.org/)。

初始化成功后，可以检查 Java packages, classes 和 实例的组件信息。

```
>>> import com.google.inject
>>> dir(com.google.inject)
['AbstractModule', 'Binder', 'Binding', 'BindingAnnotation', 'ConfigurationException', 'CreationException', 'Exposed', 'Guice', 'ImplementedBy', 'Inject', 'Injector', 'Key', 'MembersInjector', 'Module', 'OutOfScopeException', 'PrivateBinder', 'PrivateModule', 'ProvidedBy', 'Provider', 'Provides', 'ProvisionException', 'Scope', 'ScopeAnnotation', 'Scopes', 'Singleton', 'Stage', 'TypeLiteral', '__name__', 'assistedinject', 'binder', 'internal', 'matcher', 'name', 'servlet', 'spi', 'util']
>>> type(com.google.inject)
<type 'javapackage'>
>>> dir(com.google.inject.Guice)
['__class__', '__copy__', '__deepcopy__', '__delattr__', '__doc__',
'__eq__', '__getattribute__', '__hash__', '__init__', '__ne__',
'__new__', '__reduce__', '__reduce_ex__', '__repr__', '__setattr__',
'__str__', '__unicode__', 'class', 'clone', 'createInjector',
'equals', 'finalize', 'getClass', 'hashCode', 'notify', 'notifyAll',
'registerNatives', 'toString', 'wait']
```

内置的 *help()* 函数可以在解释器中使用：

```
>>> help()
"m" is "com.google.gerrit.lifecycle.LifecycleManager@6f03b248"
"Shell" is "com.google.gerrit.pgm.shell.JythonShell@61644f2d"
"d" is "com.google.gerrit.pgm.Daemon@28a3f689"

Welcome to the `Gerrit Inspector`
Enter help() to see the above again, EOF to quit and stop Gerrit
```

Java 和 Python 的异常可以被 Inspector 拦截：
```
>>> import java.lang.RuntimeException
>>> raise java.lang.RuntimeException("Exiting")
Traceback (most recent call last):
  File "<stdin>", line 1, in <module>
        at sun.reflect.NativeConstructorAccessorImpl.newInstance0(Native Method)
        at sun.reflect.NativeConstructorAccessorImpl.newInstance(NativeConstructorAccessorImpl.java:57)
        at sun.reflect.DelegatingConstructorAccessorImpl.newInstance(DelegatingConstructorAccessorImpl.java:45)
        at java.lang.reflect.Constructor.newInstance(Constructor.java:532)
        at org.python.core.PyReflectedConstructor.constructProxy(PyReflectedConstructor.java:210)

java.lang.RuntimeException: java.lang.RuntimeException: Exiting
>>>
```

可以使用 EOF 字符退出 interpreter。(或：linux Ctrl-D，Windows Ctrl-Z )

也可以使用 *System.exit()* 关闭 JVM。

```
>>> import java.lang.System
>>> java.lang.System.exit(1)
```

最后，gerrit 会关闭所有的相关子系统并退出：

```
[2012-04-17 15:31:08,458] INFO  com.google.gerrit.pgm.Daemon : caught shutdown, cleaning up
```

## TROUBLESHOOTING

`Gerrit Inspector` 会把 log 存储到 gerrit 的 errlog 文件中。

成功启动的 log 如下：

```
  [2012-04-17 13:43:44,888] INFO  com.google.gerrit.pgm.shell.JythonShell : Jython shell instance created.
```

如果没有 'jython.jar' 的 lib 文件，gerrit 在启动时会拒绝使用 *-s* 参数：

```
[2012-04-17 13:57:29,611] ERROR com.google.gerrit.pgm.Daemon : Unable to start daemon
com.google.inject.ProvisionException: Guice provision errors:

(1) Error injecting constructor, java.lang.UnsupportedOperationException: Cannot create Jython shell: Class org.python.util.InteractiveConsole not found
     (You might need to install jython.jar in the lib directory)
  at com.google.gerrit.pgm.shell.JythonShell.<init>(JythonShell.java:47)
  while locating com.google.gerrit.pgm.shell.JythonShell
  while locating com.google.gerrit.pgm.shell.InteractiveShell
```

'Startup.py' 启动时，如果有错误，如下：

```
[2012-04-17 14:20:30,558] INFO  com.google.gerrit.pgm.shell.JythonShell : Jython shell instance created.
[2012-04-17 14:20:38,005] ERROR com.google.gerrit.pgm.shell.JythonShell : Exception occurred while loading file Startup.py :
java.lang.reflect.InvocationTargetException
        at sun.reflect.NativeMethodAccessorImpl.invoke0(Native Method)
        at sun.reflect.NativeMethodAccessorImpl.invoke(NativeMethodAccessorImpl.java:57)
        at sun.reflect.DelegatingMethodAccessorImpl.invoke(DelegatingMethodAccessorImpl.java:43)
        at java.lang.reflect.Method.invoke(Method.java:616)
        at com.google.gerrit.pgm.shell.JythonShell.runMethod0(JythonShell.java:112)
        at com.google.gerrit.pgm.shell.JythonShell.execFile(JythonShell.java:194)
        at com.google.gerrit.pgm.shell.JythonShell.reload(JythonShell.java:178)
        at com.google.gerrit.pgm.shell.JythonShell.run(JythonShell.java:152)
        at com.google.gerrit.pgm.Daemon.run(Daemon.java:190)
        at com.google.gerrit.pgm.util.AbstractProgram.main(AbstractProgram.java:67)
        at sun.reflect.NativeMethodAccessorImpl.invoke0(Native Method)
        at sun.reflect.NativeMethodAccessorImpl.invoke(NativeMethodAccessorImpl.java:57)
        at sun.reflect.DelegatingMethodAccessorImpl.invoke(DelegatingMethodAccessorImpl.java:43)
        at java.lang.reflect.Method.invoke(Method.java:616)
        at com.google.gerrit.launcher.GerritLauncher.invokeProgram(GerritLauncher.java:167)
        at com.google.gerrit.launcher.GerritLauncher.mainImpl(GerritLauncher.java:91)
        at com.google.gerrit.launcher.GerritLauncher.main(GerritLauncher.java:49)
        at Main.main(Main.java:25)
Caused by: Traceback (most recent call last):
  File "/home/user/.gerritcodereview/Startup.py", line 1, in <module>
    Test
NameError: name 'Test' is not defined
```

这些报错是非致命的。`Gerrit Inspector` 控制台执行下面的命令可以重新载入相关脚本：

```
Shell.reload()
```

## LOGGING

Error 和 warning 信息会自动写入 '$site_path/logs/error_log' 文件中。

输出和哦 error 信息(包括 Java 和 Python 异常) 会在控制台上显示。

## KNOWN ISSUES
Inspector 不能识别 Google Guice 的绑定。

