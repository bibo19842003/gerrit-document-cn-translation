# Gerrit Code Review: Developer Setup

为了构建 gerrit，需要安装 [Bazel](https://bazel.build/) 。

## Git Setup

### Getting the Source

客户端创建一个工作空间：

```
  git clone --recurse-submodules https://gerrit.googlesource.com/gerrit
  cd gerrit
```

参数 `--recursive-submodules` 确保 `git clone` 的时候可以下载 core plugin，此参数用于下载 git 的 submodules 。

### Switching between branches

若使用 `git checkout` 命令，但没有添加参数 `--recurse-submodules`，那么只会切换分支，但 submodule 的版本却不会变化，这样会导致：

*  不正确或不需要的 plugin 版本
*  缺少 plugin

在切换分支后，要确检查 submodule 的版本是否正确。

**Notice:**
*如果在 Gerrit 的源目录中存放了 Eclipse 或 IntelliJ 项目的相关文件，不要执行 `git clean -fdx`命令，这样会移除 untracked 文件并毁坏当前的项目。可以参考 [git-clean](https://git-scm.com/docs/git-clean).*

*可以执行下面命令:*

```
  git submodule update
  git clean -ffd
```

## Compiling

关于编译，请参考 [使用 Bazel 构建](dev-bazel.md)。

## Testing

### Running the acceptance tests
 
Gerrit 包含的测试可以用来验证 Gerrit daemon 的 REST, SSH, Git protocol 模块。
 
每次 test 都会创建一个新的 review site，并且会启动 Gerrit daemon。当 test 结束的时候，Gerrit daemon 也会自动关闭。
 
Bazel 的相关测试说明，可以参考 [dev-bazel](dev-bazel.md) 的相关部分。
 
## Local server

### Site Initialization

代码编译后，可以执行 gerrit init 命令创建一个测试的站点：

```shell
  export GERRIT_SITE=~/gerrit_testsite
   $(bazel info output_base)/external/local_jdk/bin/java \
      -jar bazel-bin/gerrit.war init --batch --dev -d $GERRIT_SITE
```
**NOTE:**
*gerrit.config 文件中的 java 版本要与 bazel 构建使用的 java 版本保持一致，bazel 使用的 java 路径如下：`$(bazel info output_base)/external/local_jdk/bin/java`。*

此命令需要两个参数：

* `--batch`: 用来设置一些 gerrit 的默认配置，可以参考 [Configuration](config-gerrit.md)
* `--dev`: 用来设置 gerrit server 的认证方式。`DEVELOPMENT_BECOME_ANY_ACCOUNT`, 可以切换登录用户用来探索 gerrit 的工作方式。可以参考 [Gerrit Code Review: Developer Setup](dev-readme.md)

在初始化测试站点后，gerrit 开始在后台运行，可以通过 web 进行访问。

打开页面，然后：

.  用已创建的用户进行登录
.  注册额外的账户
.  创建 project

停止 gerrit 服务，可以执行命令：

```shell
  $GERRIT_SITE/bin/gerrit.sh stop
```

### Working with the Local Server

在开发样例中创建更多的帐户：

.  点击 'become' 按钮
.  选择 'Switch User'.
.  注册新用户
.  配置 SSH key

使用 `ssh` 协议进行 clone 和 push 操作。例如，使用具有管理员权限的帐号进行 clone 操作：

```shell
git clone ssh://username@localhost:29418/projectname
```

使用 HTTP 协议进行操作：

```shell
git clone http://username@localhost:29418/projectname
```

默认用 `admin` 的密码是 `secret`。可以在 gerrit 页面的 `User Settings` 中的 HTTP credentials 重新生成密码。密码可以用下面命令存储在本地，避免反复输入密码：
 
```
git config --global credential.helper store
git pull
```
 
创建 change，可以执行下面命令：
 
```
git push origin HEAD:refs/for/master
```

### Running the Daemon

构建出来的二进制包，可以直接使用，不用拷贝到测试站点：

```shell
  $(bazel info output_base)/external/local_jdk/bin/java \
     -jar bazel-bin/gerrit.war daemon -d $GERRIT_SITE \
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
     -jar bazel-bin/gerrit.war daemon -d $GERRIT_SITE -s
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

## Setup for backend developers
 
### Configuring Eclipse
 
若要使用 Eclipse IDE 进行开发，可以参考 [Eclipse Setup](dev-eclipse.md)。
 
在 Eclipse 工作目录中配置 Bazel, 请参考 [Eclipse integration with Bazel](dev-bazel.md) 相关章节。
 
### Configuring IntelliJ IDEA

参考 [dev-intellij ](dev-intellij.md) 相关章节。

## Setup for frontend developers
参考[Frontend Developer Setup](https://gerrit.googlesource.com/gerrit/+/master/polygerrit-ui/README.md)


