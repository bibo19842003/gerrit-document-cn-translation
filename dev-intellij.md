# Gerrit Code Review - IntelliJ IDEA Setup

## Prerequisites

### Bazel

需要安装 bazel，可以参考 [dev-bazel](dev-bazel.md) 中的相关章节。

强烈建议先在命令行下，为 Java 8 使用 bazel 对 gerrit 构建进行验证，确保 `bazel build gerrit` 可以正确执行。

### IntelliJ version and Bazel plugin

下载 IntelliJ 之前，查看一下 [JetBrains plugin repository page of the Bazel plugin](https://plugins.jetbrains.com/plugin/8609-bazel/versions)，确认 IntelliJ IDEA 的版本是否兼容。

需要注意的是，有的 bazel plugin 版本可能会与 bazel 不兼容。

另外，Java 8 需要通过 `JAVA_HOME` 来明确路径，才可以使用 bazel plugin 进行构建。

**TIP:**
*如果项目与 `Bazel plugin` 使用的 BUILD 文件同步失败并且 IntelliJ 显示 **Could not get Bazel roots** 错误，那么表明 `Bazel plugin` 没有找到 Java 8 。*

### Installation of IntelliJ IDEA

参考 [installation guide provided by Jetbrains](https://www.jetbrains.com/help/idea/installation-guide.html) 在对应的平台上进行安装。确保所安装的版本可以与上面提到的 bazel plugin 兼容。

## Installation of the Bazel plugin

. 依次点击 *File -> Settings -> Plugins* (或者在 welcome 页面 *Configure -> Plugins*)
. 激活 *Marketplace* 标签页
. 搜索 plugin `Bazel`

**TIP:**
*如果没有显示 Bazel plugin 或者显示的是过期的版本，需要通过 [the JetBrains plugin page](https://plugins.jetbrains.com/plugin/8609-bazel/versions) 来验证 Bazel plugin 和 IntelliJ IDEA 的兼容性。*
. 安装
. 重新启动 IntelliJ IDEA.

**TIP:**
*如果 bazel build 失败，并报错：**Cannot run program "bazel": No such file or directory**，此时需要在 bazel plugin 的设置中来配置存放二进制文件的位置：*
*. 依次点击 Preferences -> Other Settings -> Bazel Settings.*
*. 设置 Bazel 二进制的位置*

## Creation of the project

. 依次点击 *File -> Import Bazel Project* (或者在 welcome 页面，可以看到 *Import Bazel Project* )
. *Use existing bazel workspace -> Workspace*, 选择 gerrit 源码的路径
. 点击 *Import from workspace* ，选择 `.bazelproject` 文件的位置， 此文件在 gerrit 代码目录的顶层。
. 有需要的话，可以调整项目数据目录位置和项目的名称。
. 完成 project 的创建
. 对 project 进行构建的验证。点击 bazel 按钮图标（默认在顶部的右侧）可以进行构建，并会显示 warnings 信息。

此时，可以使用一些基本的功能了，如：Java class 的分析和运行单元测试。

**TIP:**
*项目数据目录可以和代码目录分开。这样的好处是项目文件不需要进行版本控制。*

## Recommended settings

### Code style

#### google-java-format plugin

按照下面步骤安装 `google-java-format`：

. 依次点击 *File -> Settings -> Plugins*.
. 激活 *Marketplace* 标签页.
. 搜索 plugin `google-java-format`.
. 安装
. 重启 IntelliJ IDEA.

每次启动 IntelliJ IDEA，需要确认每行代码都使用了 *Code → Reformat with google-java-format* 的设置，这样会代替默认的 CodeStyleManager 使用的风格。代码风格的设定可以通过依次点击 *Code -> Reformat Code*，或键盘的快捷键，或 commit 的时候选择 `google-java-format` plugin 来完成。

可以参考[dev-contributing](dev-contributing.md) 的 `google-java-format` 相关章节。

#### Code style settings

首选使用 `google-java-format` plugin 来规范化代码的风格。建议设置代码风格，这样随时可以保证风格统一。

通过下面的设置，不能完全像 `google-java-format` plugin 一样来强制规范代码风格，因此，在提交代码前，需要执行 *Reformat Code* 。

. 下载 [intellij-java-google-style.xml](https://raw.githubusercontent.com/google/styleguide/gh-pages/intellij-java-google-style.xml) 。
. 依次点击 *File -> Settings -> Editor -> Code Style*.
. 在 'Show Scheme Actions' 工具栏点击扳手图标
. 依次点击 *Import Scheme*.
. 选择之前下载的 `intellij-java-google-style.xml` 文件
. 确保当前的 *Scheme* 选择了 `GoogleStyle`

另外，首选要对 `EditorConfig` 进行设置 (确保在 Eclipse, IntelliJ, 以及其他编辑器中使用相同风格)。这些的设置在 gerrit 代码的 `.editorconfig` 文件中。如果启用了 `EditorConfig` plugin ，在配置正确的情况下，IntelliJ 会自动使用这些设置。验证配置正确与否的方法如下：

. 依次点击 *File -> Settings -> Plugins*.
. 确保 `EditorConfig` plugin 已启用
. 依次点击 *File -> Settings -> Editor -> Code Style*.
. 确保进行了 *Enable EditorConfig support* 的检查

**NOTE:**
*如果 IntelliJ 有 `EditorConfig` 设置已经重载了代码风格的配置，说明文件配置验证通过。*

### Copyright

将文件夹 `$(gerrit_source_code)/tools/intellij/copyright` 复制到 `$(project_data_directory)/.idea` 下面。如果已存在，需要进行替换。如果没有选择一个自定义的数据目录，那么会把 gerrit 的源码目录作为工作目录并中执行下面类似的命令：

```
cp -r tools/intellij/copyright .ijwb/.idea/
```
. 依次点击 *File -> Settings -> Editor -> Copyright -> Copyright Profiles*.
. 验证当前的 *Gerrit Copyright* 

如果没有自动提取 copyright 文件，那么需要从文件夹中手动导入 `Gerrit_Copyright.xml`。

### Git integration

如果在 IntelliJ IDEA 中使用 Git integration plugin，可以参考此部分的描述。

创建与 [Gerrit 社区](dev-contributing.md) 兼容的 commit-msg 格式，可按如下步骤操作：

. 依次点击 *File -> Settings -> Version Control -> Commit Dialog*.
. 在 *Commit message inspections* 中，激活下面三个检查：
  *Blank line between subject and body
  *Limit body line
  *Limit subject line
. 对于 limit line inspections, 可以将值设置为 72
. 对于 *Limit body line*, 点击 *Show right margin* 和 *Wrap when typing reaches right margin*

另外，如果生成 commit-msg 还是有问题的话，可以参考如下说明进行操作：

* 安装可以生成 `Change-Id` 的 commit-msg hook 。
* 设置 HTTP 访问

如果设置了 HTTP 访问，那么通过 IntelliJ 上传 commit 的时候，不需要明确具体的认证方式。commit-msg hook 执行的时候，不会有相关的提示，因为 IntelliJ 的 commit 窗口此时已经关闭了。

## Run configurations

`run configuration` 在工具栏上。可在 `run configuration` 的下拉列表中选择 *Edit Configurations* 进行编辑，或依次点击 *Run -> Edit Configurations* 来运行。

### Gerrit Daemon

**WARNING:**
*运行 configuration 的时候，`java.io.FileNotFoundException` 会输出相关结果。为了使用 IntelliJ 调试本地的 gerrit，可以参考 [开发者指导](dev-readme.md) 的 `Running the Daemon` 部分和本文的 `Debugging a remote Gerrit server` 部分。([Issue 11360](https://bugs.chromium.org/p/gerrit/issues/detail?id=11360))*

复制 `$(gerrit_source_code)/tools/intellij/gerrit_daemon.xml` 到 `$(project_data_directory)/.idea/runConfigurations/`，可以运行 gerrit 服务，此服务运行的方式和 [开发者指导](dev-readme.md) 的 `Running the Daemon` 方式类似。

**NOTE:**
*站点初始化的操作需要在执行 `run configuration` 之前来完成。*

### Unit tests

做单元测试，需要创建 `run configuration`，可以在 method, class, file, package 上通过右键单击来运行或调试它们。通过从菜单中选择 *Create +'Bazel test [...]'...* 来创建的 `run configuration`，可以是临时的，也可以进行永久保存。

通常，此方法生成 JUnit 的 `run configuration`。当 Bazel plugin 管理项目时，会创建一个 Bazel 测试的 `run configuration`。

### Debugging a remote Gerrit server

如果远端的 gerrit 服务器在运行并启用了一个调试端口，IntelliJ 可以通过 `Remote debug configuration` 来进行调试：

. 依次点击 *Run -> Edit Configurations*.
. 点击 *+* 来添加新的配置
. 在 *Templates* 中选择 *Remote*.
. 依次点击 *Configuration -> Settings -> Host* and *Port*.
. 使用 `Debug` 模式进行启动

**TIP:**
*此运行的窗口显示了 JVM 的配置信息，可以将此信息复制到 `$(gerrit_test_site)/etc/gerrit.config` 文件的 `[container]` 部分。*

