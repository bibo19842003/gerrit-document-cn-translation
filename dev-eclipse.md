# Gerrit Code Review - Eclipse Setup

此文档描述了如何配置 Eclipse 的开发环境，默认需要安装 Java 11 及以后版本，其他 Java 版本需要配置额外的参数。

## Project Setup

在 Eclipse 的 [`eclipse.ini`](https://wiki.eclipse.org/Eclipse.ini) 安装文件中，在 `vmargs` 部分添加下面的信息：

```
  -DmaxCompiledUnitsAtOnce=10000
```

如果没有这个设置，相关的进程不能稳定的工作，构建的时候会报如下错误：

```
  Could not write generated class ... javax.annotation.processing.FilerException: Source file already created
```

和

```
  AutoAnnotation_Commands_named cannot be resolved to a type
```

首选，通过 `tools/eclipse/project.py` 脚本创建 Eclipse 项目。如果使用 Java 8 运行 Eclipse，需要添加额外参数 `-e='--java_toolchain=//tools:error_prone_warnings_toolchain'`。其次，在 Eclipse, 中，选择 'Import existing project' 后，再选中当前工作目录中  `gerrit` 项目的路径。

展开 `gerrit` 项目, 右键单击 `eclipse-out` 文件夹，选择 'Properties'，并在 'Attributes' 查看 'Derived'。

如果做了上面的操作，相关的修改会保存到 `.project` 文件，例如，在文件夹上添加了 `Resource Filters`，在下次执行 `tools/eclipse/project.py` 的时候，修改会被覆盖掉。

### Eclipse project on MacOS

默认情况下，bazel 使用 `/private/var/tmp` 作为 [outputRoot on MacOS](https://docs.bazel.build/versions/master/output_directories.html)。这意味着 eclipse 项目会参考 libraries 的存储结构。
然而，MacOS 会定期清理 `/private/var/tmp` 目录中长期不使用或长期不修改的内容，默认是 3 天清理一次。由于所参考的 libraries 被删除，这样会破坏 Eclipse 项目的目录结构，需要提前做好如下配置：

#### Change the location of the bazel output directory
Linux 系统中，默认的输出目录是 `$HOME/.cache/bazel`。若 Mac 系统中配置同样的路径，需要编辑或创建 `$HOME/.bazelrc` 文件，文件内容如下：
```
startup --output_user_root=/Users/johndoe/.cache/bazel
```

#### Increase the treshold for the cleanup of temporary files
上面提到的默认的清理周期，可以修改 `/etc/periodic.conf` 文件中的 `daily_clean_tmps_days` 参数：

`/etc/periodic.conf` 文件内容如下:

```
# This file overrides the settings from /etc/defaults/periodic.conf
daily_clean_tmps_days="45"                              # If not accessed for
```

更多的描述和建议可以参考 [链接](https://superuser.com/a/187105)。

### Eclipse project with custom plugins

对 eclipse 项目来说，可以把定制的 plugin 添加到 `tools/bzl/plugins.bzl`，然后执行 `tools/eclipse/project.py`。可以参考 [bundling in release.war](dev-build-plugins.md) 的 `custom plugin` 部分。

## Java Versions
 
默认支持的是 Java 11，其他版本的 Java SDK需要添加额外的参数： 
* 添加 JRE, 如目录 /usr/lib64/jvm/java-9-openjdk，名称 java-9-openjdk-9
* 将 gerrit 项目的运行环境修改为：JavaSE-9 (java-9-openjdk-9)
* 将 gerrit 项目中的编译器的 `compliance` 级别设置为：9


## Code Formatter Settings

gerrit 使用 [`google-java-format`](https://github.com/google/google-java-format) 这个工具(version 1.7) 按照下面的‘风格指导’来自动化规范代码的统一书写格式。命令行中如何使用这个工具，可以参考 [Code Style](dev-contributing.md) 的 `style` 部分。在 Eclipse IDE 中，有相关的 plugin 可以对代码的风格进行处理，可以参考 [Eclipse plugin](https://github.com/google/google-java-format) 的 `eclipse` 部分。

## Site Initialization

[使用 Bazel 构建](dev-bazel.md)，然后按照 [开发者指导](dev-readme.md) 进行相关的配置和测试。

## Testing

### Gerrit UI 需要先启动 `server.go` 进程
执行如下命令:

```
  $ bazel run polygerrit-ui:devserver
```

### Running the Daemon

复制已存在的启动配置：

* Eclipse 中，选择 Run -> Debug Configurations ...
* Java Application -> `gerrit_daemon`
* 单击右键，复制
* 修改成一个唯一的名字
* 切换到 Arguments 标签页
* 编辑 `-d` 参数，此参数要与 `init` 的路径相同。文档推荐将模板的启动配置解析为 `../gerrit_testsite`。
* 切换到 Common 标签页
* 修改保存到本地文件
* 关闭调试的配置窗口，并且按照提示进行保存修改

