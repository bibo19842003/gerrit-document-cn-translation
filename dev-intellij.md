# Gerrit Code Review - IntelliJ Setup

## Prerequisites

需要安装 IntelliJ 的版本是 2016.2 或者是更新的版本。最新版本有可能未与 IntelliJ 的 Bazel plugin 同步。使用最新的 IntelliJ 版本后，还要将 Bazel plugin 更新到最新版本。

另外，Java 8 需要通过 `JAVA_HOME` 来明确路径，才可以使用 bazel plugin 进行构建。

**NOTE:**
*如果项目与 `Bazel plugin` 使用的 BUILD 文件同步失败并且 IntelliJ 显示 **Could not get Bazel roots** 错误，那么表明 `Bazel plugin` 没有找到 Java 8 。*

Bazel 的安装可以参考 [使用 Bazel 构建](dev-bazel.md) 的 `Prerequisites` 部分。

## Installation of the Bazel plugin

. 依次点击 *File -> Settings -> Plugins*.
. 点击 *Browse Repositories*.
. 搜索 plugin `IntelliJ with Bazel`.
. 安装
. 重新启动 IntelliJ.

**NOTE:**
*如果项目的 bazel 构建失败并显示 **Cannot run program "bazel": No such file or directory** 错误，那么需要在 `Bazel plugin` 中设置二进制的位置：*
*. 依次点击 Preferences -> Other Settings -> Bazel Settings.*
*. 设置 Bazel 二进制的位置*

## Creation of IntelliJ project

. 依次点击 *File -> Import Bazel Project* 
. *Use existing bazel workspace -> Workspace*, 选择 gerrit 源码的路径
. 点击 *Import from workspace* ，选择 `.bazelproject` 文件的位置， 此文件在 gerrit 代码目录的顶层。
. 有需要的话，可以调整项目数据目录位置和项目的名称。

**NOTE:**
*项目数据目录可以和代码目录分开。这样的好处是项目文件不需要进行版本控制。*

如果创建的项目的输出路径有问题，可以按下面的步骤处理：

. 依次点击 *File -> Project Structure -> Project Settings -> Modules*.
. 切换到 *Paths* 标签页
. 点击 *Inherit project compile output path*
. 点击 *Use module compile output path*

## Recommended settings

### Code style

#### google-java-format plugin

按照下面步骤安装 `google-java-format`：

. 依次点击 *File -> Settings -> Plugins*.
. 点击 *Browse Repositories*.
. 搜索 plugin `google-java-format`.
. 安装
. 重启 IntelliJ

每次启动 IntelliJ，需要确认每行代码都使用了 *Code → Reformat with google-java-format* 的设置，这样会代替默认的 CodeStyleManager 使用的风格。代码风格的设定可以通过依次点击 *Code -> Reformat Code*，或键盘的快捷键，或 commit 的时候选择 `google-java-format` plugin 来完成。

#### Code style settings

首选使用 `google-java-format` plugin 来规范化代码的风格。建议设置代码风格，这样随时可以保证风格统一。

通过下面的设置，不能完全像 `google-java-format` plugin 一样来强制规范代码风格，因此，在提交代码前，需要执行 *Reformat Code* 。

. 下载 [intellij-java-google-style.xml](https://raw.githubusercontent.com/google/styleguide/gh-pages/intellij-java-google-style.xml) 。
. 依次点击 *File -> Settings -> Editor -> Code Style*.
. 点击 *Manage*.
. 点击 *Import*.
. 选择 `IntelliJ IDEA Code Style XML`.
. S选择之前下载的 `intellij-java-google-style.xml` 文件
. 确保 *Scheme* 选择了 `Google Style`

另外，首选要对 `EditorConfig` 进行设置 (确保在 Eclipse, IntelliJ, 以及其他编辑器中使用相同风格)。这些的设置在 gerrit 代码的 `.editorconfig` 文件中。如果启用了 `EditorConfig` plugin ，在配置正确的情况下，IntelliJ 会自动使用这些设置。验证配置正确与否的方法如下：

. 依次点击 *File -> Settings -> Plugins*.
. 确保 `EditorConfig` plugin 已启用
. 依次点击 *File -> Settings -> Editor -> Code Style*.
. 确保进行了 *Enable EditorConfig support* 的检查

**NOTE:**
*如果 IntelliJ 有 `EditorConfig` 设置已经重载了代码风格的配置，说明文件配置验证通过。*

### Copyright

将文件夹 `$(gerrit_source_code)/tools/intellij/copyright` 复制到 `$(project_data_directory)/.idea` 下面。如果已存在，需要进行替换。 然后依次点击 *File -> Settings -> Editor -> Copyright -> Copyright Profiles*，如果不能自动加载 copyright，需要手动将`Gerrit_Copyright.xml` 导入到 IntelliJ。

### File header

默认，IntelliJ 创建新文件时，需要将文件的作者和当前日期添加到文件头部。可按如下步骤取消此过程：

. 依次点击 *File -> Settings -> Editor -> File and Code Templates*.
. 选择 *Includes* 标签页
. 选择 *File Header*.
. 移除模板

### Commit message

创建与 [Gerrit 社区](dev-contributing.md) 兼容的 commit-msg 格式，可按如下步骤操作：

. 依次点击 *File -> Settings -> Version Control*.
. 检查 *Commit message right margin (columns)*.
. 确保长度不要超过 72 个字符
. 检查 *Wrap when typing reaches right margin*.

另外，如果生成 commit-msg 还是有问题的话，可以参考如下说明进行操作：

* 安装可以生成 `Change-Id` 的 commit-msg hook 。
* 设置 HTTP 访问

如果设置了 HTTP 访问，那么通过 IntelliJ 上传 commit 的时候，不需要明确具体的认证方式。commit-msg hook 执行的时候，不会有相关的提示，因为 IntelliJ 的 commit 窗口此时已经关闭了。

## Run configurations

`run configuration` 在工具栏上。可在 `run configuration` 的下拉列表中选择 *Edit Configurations* 进行编辑，或依次点击 *Run -> Edit Configurations* 来运行。

### Pre-configured run configurations

为了可以使用预配置的 `run configuration`，需按如下步骤进行操作：

. 确保 `$(project_data_directory)/.idea` 下有 `runConfigurations` 目录存在，如果没有，需要创建。 
. 需要明确 IntelliJ 的 path 变量：`GERRIT_TESTSITE`。 (This configuration is shared among all IntelliJ projects.)
.. 依次点击 *Settings -> Appearance & Behavior -> Path Variables*.
.. 点击 *+* 添加 path 变量
.. 输入 `GERRIT_TESTSITE` 变量的名称和路径

被复制的 `run configuration` 会自动的添加到 IntelliJ 项目中。

#### Gerrit Daemon

```
**警告：**
运行 configuration 的时候，`java.io.FileNotFoundException` 会输出相关结果。为了使用 IntelliJ 调试本地的 gerrit，可以参考 [开发者指导](dev-readme.md) 的 `Running the Daemon` 部分和本文的 `Debugging a remote Gerrit server` 部分。
```

复制 `$(gerrit_source_code)/tools/intellij/gerrit_daemon.xml` 到 `$(project_data_directory)/.idea/runConfigurations/`，可以运行 gerrit 服务，此服务运行的方式和 [开发者指导](dev-readme.md) 的 `Running the Daemon` 方式类似。

**NOTE:**
*站点初始化的操作需要在执行 `run configuration` 之前来完成。*

### Unit tests

做单元测试，需要创建 `run configuration`，可以在 method, class, file, package 上通过右键单击来运行或调试它们。创建的 `run configuration`，可以是临时的，页永久进行保存。

通常，此方法生成 JUnit 的 `run configuration`。当 Bazel plugin 管理项目时，会创建一个 Bazel 测试的 `run configuration`。

### Debugging a remote Gerrit server

如果远端的 gerrit 服务器在运行并启用了一个调试端口，IntelliJ 可以通过 `Remote debug configuration` 来进行调试：

. 依次点击 *Run -> Edit Configurations*.
. 点击 *+* 来添加新的配置
. 选择 *Remote*.
. 依次点击 *Configuration -> Settings -> Host* and *Port*.
. 使用 `Debug` 模式进行启动

