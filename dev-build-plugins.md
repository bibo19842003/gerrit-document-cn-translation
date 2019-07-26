# Gerrit Code Review - Building plugins

从构建过程的角度看，有三种类型的 plugin：

* Maven driven
* Bazel tree driven
* Bazel standalone

如果 plugin 的根目录包含全部下面的文件，那么这些类型可以整合到一起：

* `BUILD`
* `pom.xml`

这个 plugin 可以使用 Bazel 和 Maven 进行构建。

## Maven driven build

如果 plugin 包含 `pom.xml` 文件，可以使用 Maven 进行构建：

```
mvn clean package
```

但下面的规则除外：

### Exception 1:

Plugin 的 `pom.xml` 关联了 plugin API 的 snapshot 版本：`2.8-SNAPSHOT`。这种情况下有两个可能：

* 切换到发布的 API。将 `pom.xml` 中的 plugin API 版本由 `2.8-SNAPSHOT` 修改为 `2.8.1` 。
* 在本地构建和安装 plugin API 的 snapshot 版本：

```
./tools/maven/api.sh install
```

### Exception 2:

Plugin 的 `pom.xml` 关联了其他的 lib 库或 gerrit plugin。 这些 lib 库或 plugin 一定要在本地构建并安装到本地的 Maven repository：

```
mvn install
```

## Bazel in tree driven


事实上，plugin 包含了 `BUILD` 文件并不意味着这个 plugin 可以直接进行构建。

`Bazel in tree driven` 意味着只能在 gerrit 的目录中进行构建。将 plugin 链接或 clone 到 gerrit/plugins 目录下：

```
cd gerrit
bazel build plugins/<plugin-name>:<plugin-name>
```

构建结果可以在下面的目录中找到：

```
bazel-genfiles/plugins/<plugin-name>/<plugin-name>.jar
```

`src/main/resources/Documentation/build.md` 文件中描述了 plugin 的构建过程，需要严格进行检查。

### Plugins with external dependencies

如果 plugin 有外部的依赖，那么需要在 gerrit 目录的 WORKSPACE 文件中包含这些依赖。可以把依赖项添加到 `external_plugin_deps.bzl` 文件来实现，在 gerrit 目录中构建的过程中，此文件需要复制到 `plugin` 目录。

`external_plugin_deps.bzl` 文件的示例如下:

```
load("//tools/bzl:maven_jar.bzl", "maven_jar")

def external_plugin_deps():
  maven_jar(
      name = 'org_apache_tika_tika_core',
      artifact = 'org.apache.tika:tika-core:1.12',
      sha1 = '5ab95580d22fe1dee79cffbcd98bb509a32da09b',
  )
```

### Bundle custom plugin in release.war

为了将定制的 plugin 打包到 release.war 文件，需要将定制的 plugin 清单添加到 `tools/bzl/plugins.bzl`。

`tools/bzl/plugins.bzl` 包含自定义 plugin `my-plugin` 的示例如下：

```
CORE_PLUGINS = [
    "commit-message-length-validator",
    "download-commands",
    "hooks",
    "replication",
    "reviewnotes",
    "singleusergroup",
]

CUSTOM_PLUGINS = [
    "my-plugin",
]

CUSTOM_PLUGINS_TEST_DEPS = [
    # Add custom core plugins with tests deps here
]
```

如果打包到 release.war 中的 plugin 有外部的依赖，那么这些依赖要添加到 `plugins/external_plugin_deps`。可以给 `external_plugin_deps()` 命名成其他的名字，这样可以被更多的 plugin 导入，例如：

```
load(":my-plugin/external_plugin_deps.bzl", my_plugin="external_plugin_deps")
load(":my-other-plugin/external_plugin_deps.bzl", my_other_plugin="external_plugin_deps")

def external_plugin_deps():
  my_plugin()
  my_other_plugin()
```

**NOTE:**
*因为 `tools/bzl/plugins.bzl` 和 `plugins/external_plugin_deps.bzl` 是 gerrit 的源码部分，并且 war 文件需要基于当前的 git 仓构建出来，建议构建前将修改进行 commit，否则构建出的版本号会有 ‘dirty’ 的标识。*

## Bazel standalone driven

现在只有少数的 plugin 支持这种模式：

```
cd reviewers
bazel build reviewers
```

