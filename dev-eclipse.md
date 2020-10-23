# Gerrit Code Review - Eclipse Setup

此文档描述的是如何配置一个 Eclipse 的开发环境，并需要安装 Java 8 及以后版本。

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

首选，通过 `tools/eclipse/project.py` 脚本创建 Eclipse 项目。其次，在 Eclipse, 中，选择 'Import existing project' 后，再选中当前工作目录中  `gerrit` 项目的路径。

展开 `gerrit` 项目, 右键单击 `eclipse-out` 文件夹，选择 'Properties'，并在 'Attributes' 查看 'Derived'。

如果做了上面的操作，相关的修改会保存到 `.project` 文件，例如，在文件夹上添加了 `Resource Filters`，在下次执行 `tools/eclipse/project.py` 的时候，修改会被覆盖掉。

### Eclipse project with custom plugins ===

对 eclipse 项目来说，可以把定制的 plugin 添加到 `tools/bzl/plugins.bzl`，然后执行 `tools/eclipse/project.py`。可以参考 [bundling in release.war](dev-build-plugins.md) 的 `custom plugin` 部分。

若使用 Java 9 及更新版本，需要修改一些参数，因为 Java 8 使用的都是默认值：

* 添加 JRE, 如目录 /usr/lib64/jvm/java-9-openjdk，名称 java-9-openjdk-9
* 将 gerrit 项目的运行环境修改为：JavaSE-9 (java-9-openjdk-9)
* 将 gerrit 项目中的编译器的 `compliance` 级别设置为：9


## Code Formatter Settings

gerrit 使用 [`google-java-format`](https://github.com/google/google-java-format) 这个工具(version 1.7) 按照下面的‘风格指导’来自动化规范代码的统一书写格式。命令行中如何使用这个工具，可以参考 [Code Style](dev-contributing.md) 的 `style` 部分。在 Eclipse IDE 中，有相关的 plugin 可以对代码的风格进行处理，可以参考 [Eclipse plugin](https://github.com/google/google-java-format) 的 `eclipse` 部分。

## Site Initialization

[使用 Bazel 构建](dev-bazel.md)，然后按照 [开发者指导](dev-readme.md) 进行相关的配置和测试。

## Testing

### PolyGerrit UI 需要先启动 `server.go` 进程
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

