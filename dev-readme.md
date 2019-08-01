# Gerrit Code Review: Developer Setup

为了构建 gerrit，需要安装 [Bazel](https://bazel.build/) 。

## Getting the Source

客户端创建一个工作空间：

```
  git clone --recurse-submodules https://gerrit.googlesource.com/gerrit
  cd gerrit
```

参数 `--recursive` 确保 `git clone` 的时候可以下载 core plugin，此参数用于下载 git 的 submodules 。

## Compiling

关于编译，请参考 [使用 Bazel 构建](dev-bazel.md)。

## Configuring Eclipse

使用 Eclipse IDE 进行开发，参考 [Eclipse 设置](dev-eclipse.md)。

配置 Eclipse 与 Bazel 的集成，参考 [使用 Bazel 构建](dev-bazel.md) 的 eclipse 部分。

## Configuring IntelliJ IDEA

请参考 [IntelliJ 设置](dev-intellij.md) 。

## MacOS

在 MacOS 系统中，确保已安装 "Java for MacOS X 10.5 Update 4" (或更高版本)，并且需要设置 `JAVA_HOME`，可参考 [安装指导](install.md) 的 Requirements 部分。

通常，Java 默认安装的路径如下："/System/Library/Frameworks/JavaVM.framework/Versions".

打开终端窗口，可以使用下面命令查看已安装 java 的版本：`java -version`

## Site Initialization

代码编译后，可以执行 gerrit init 命令创建一个测试的站点：

```shell
  $(bazel info output_base)/external/local_jdk/bin/java \
     -jar bazel-bin/gerrit.war init -d ../gerrit_testsite
```
**NOTE:**
*gerrit.config 文件中的 java 版本要与 bazel 构建使用的 java 版本保持一致，bazel 使用的 java 路径如下：`$(bazel info output_base)/external/local_jdk/bin/java`。*

安装的时候，需要更改两处设置：

*  确保开发样例不能被外界访问，将 `listen addresses` 从 '*' 修改为 'localhost'
*  允许为开发样例创建测试账户，将 `auth type` 从 'OPENID' 修改为 'DEVELOPMENT_BECOME_ANY_ACCOUNT'.

在初始化测试站点后，gerrit 开始在后台运行，可以通过 web 进行访问。

打开页面，然后：

.  用已创建的用户进行登录
.  注册额外的账户
.  创建 project

停止 gerrit 服务，可以执行命令：

```shell
  ../gerrit_testsite/bin/gerrit.sh stop
```

## Working with the Local Server

在开发样例中创建更多的帐户：

.  点击 'become' 按钮
.  选择 'Switch User'.
.  注册新用户
.  配置 SSH key

使用 `ssh` 协议进行 clone 和 push 操作。例如，使用具有管理员权限的帐号进行 clone 操作：

```shell
git clone ssh://username@localhost:29418/projectname
```

创建 change：

```shell
git push origin HEAD:refs/for/master
```

## Testing

### Running the acceptance tests

Gerrit 包含验收测试，如：通过 REST, SSH, Git protocol 验证 gerrit 是否可用。

测试的时候，会创建新的站点，并且会启动 gerrit 服务，当测试完成的时候，gerrit 服务会自动关闭。

使用 bazel 进行验收测试的说明，请参考 [使用 Bazel 构建](dev-bazel.md) 的 `Running Unit Tests` 部分。

### Running the Daemon

构建出来的二进制包，可以直接使用，不用拷贝到测试站点：

```shell
  $(bazel info output_base)/external/local_jdk/bin/java \
     -jar bazel-bin/gerrit.war daemon -d ../gerrit_testsite \
     --console-log
```

**NOTE:**
*为什么 `java -jar` 要使用前缀，因为构建使用的 java 版本要和运行 gerrit 使用的 java 版本保持一致。*

调试测试的 gerrit 站点：

* 使用一个调试端口 (如端口 5005)。在先前的命令中，`-jar` 的后面插入下面的代码。如果使用 IntelliJ，请参考 [IntelliJ 设置](dev-intellij.md) 中的 `Gerrit Daemon` 部分。

```
-agentlib:jdwp=transport=dt_socket,server=y,suspend=n,address=5005
```

### Running the Daemon with Gerrit Inspector

[Gerrit Inspector](dev-inspector.md) 是一个交互式的脚本环境，用来查看和修改系统的内部状态。

`Gerrit Inspector` 在系统的控制器中使用，当 `Gerrit Inspector` 关闭的时候，里面运行的 gerrit 服务也会关闭。

为了排除故障，`Inspector` 可以使用交互式的环境进行排除。

启动 `Inspector` 需要在启动命令中添加参数 '-s' ：

```shell
  $(bazel info output_base)/external/local_jdk/bin/java \
     -jar bazel-bin/gerrit.war daemon -d ../gerrit_testsite -s
```

**NOTE:**
*为什么 `java -jar` 要使用前缀，因为构建使用的 java 版本要和运行 gerrit 使用的 java 版本保持一致。*

`Inspector` 会查看 `Java libraries`，加载初始化脚本，并在控制台打印提示:

```
  Welcome to the Gerrit Inspector
  Enter help() to see the above again, EOF to quit and stop Gerrit
  Jython 2.5.2 (Release_2_5_2:7206, Mar 2 2011, 23:12:06)
  [OpenJDK 64-Bit Server VM (Sun Microsystems Inc.)] on java1.6.0 running for
  Gerrit 2.3-rc0-163-g01967ef
  >>>
```

当 `Inspector` 启动的时候，可以像正常一样使用 gerrit 的所有端口，如：SSH，HTTP。

**CATUTION:**
*使用 `Inspector` 的时候，不要修改系统的内部状态。*

## Switching between branches

`git checkout` 不添加参数 `--recurse-submodules` 时，可以切换分支，但 submodule 版本不会变化，会导致如下问题：

*  plugin 版本不正确
*  丢失 plugin

切换分支后，确保子模块的版本是正确的：

**CAUTION:**
*如果在 gerrit 源码中存放了 Eclipse 或 IntelliJ 的 project 文件，不要执行 `git clean -fdx`。因为这个命令会移除 untracked 文件，并且会毁坏 project。更多信息 请参考 [git-clean](https://git-scm.com/docs/git-clean) 。*
执行下面命令:

```shell
  git submodule update
  git clean -ffd
```

