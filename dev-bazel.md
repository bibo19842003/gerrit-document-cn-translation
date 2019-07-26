# Gerrit Code Review - Building with Bazel

## Prerequisites

构建 gerrit 源码，需要工具如下：

* Linux 或 macOS 操作系统 (目前不支持 Windows 操作系统)
* Java 版本：8|9|10|11|...
* Python 2 or 3
* Node.js
* [Bazel](https://www.bazel.io/versions/master/docs/install.html)
* Maven
* zip, unzip
* gcc

通过 `vanilla java toolchain` 的 [Bazel 参数](https://docs.bazel.build/versions/master/toolchains.html) ，可以支持 Java 10 (及更新版本)。为了使用 Java 10 及更新版本来构建 gerrit，需要明确 `vanilla java toolchain` 和 JDK 的 `home` 路径。

```
  $ bazel build \
    --define=ABSOLUTE_JAVABASE=<path-to-java-10> \
    --host_javabase=@bazel_tools//tools/jdk:absolute_javabase \
    --host_java_toolchain=@bazel_tools//tools/jdk:toolchain_vanilla \
    --java_toolchain=@bazel_tools//tools/jdk:toolchain_vanilla \
    :release
```

如要进行测试，需要添加 `--javabase` 参数，因为 bazel test 运行和测试的时候会使用 javabase:

```
  $ bazel test \
    --define=ABSOLUTE_JAVABASE=<path-to-java-10> \
    --javabase=@bazel_tools//tools/jdk:absolute_javabase \
    --host_javabase=@bazel_tools//tools/jdk:absolute_javabase \
    --host_java_toolchain=@bazel_tools//tools/jdk:toolchain_vanilla \
    --java_toolchain=@bazel_tools//tools/jdk:toolchain_vanilla \
    //...
```

在使用 bazel 构建的时候，为了避免每次都解析所有的参数，可以把相关参数添加到 `~/.bazelrc` 文件中：

```
$ cat << EOF > ~/.bazelrc
> build --define=ABSOLUTE_JAVABASE=<path-to-java-10>
> build --javabase=@bazel_tools//tools/jdk:absolute_javabase
> build --host_javabase=@bazel_tools//tools/jdk:absolute_javabase
> build --host_java_toolchain=@bazel_tools//tools/jdk:toolchain_vanilla
> build --java_toolchain=@bazel_tools//tools/jdk:toolchain_vanilla
> EOF
```

现在，执行 `bazel build :release` 命令时，会调用上面的参数。

`$gerrit_site/etc/gerrit.config` 若配置了 `Java 10|11|...`，那么一定要添加以下参数：

```
[container]
  javaOptions = --add-opens=jdk.management/com.sun.management.internal=ALL-UNNAMED
```

通过变更 `java toolchain` 的 [Bazel 参数](https://docs.bazel.build/versions/master/toolchains.html)，可以支持 Java 9 的使用。Java 9 支持向后兼容。目前默认使用的是 Java 8。为了在构建的时候使用 Java 9,需要明确 JDK 9 java toolchain：

```
  $ bazel build \
      --host_java_toolchain=@bazel_tools//tools/jdk:toolchain_java9 \
      --java_toolchain=@bazel_tools//tools/jdk:toolchain_java9 \
      :release
```

`$gerrit_site/etc/gerrit.config` 若配置了 `Java 9`，那么一定要添加以下参数：

```
[container]
  javaOptions = --add-opens=jdk.management/com.sun.management.internal=ALL-UNNAMED
```

## Building on the Command Line

### Gerrit Development WAR File

构建 gerrit 的 web 应用：

```
  bazel build gerrit
```

**NOTE:**
*PolyGerrit UI 需要使用额外的工具，如 npm。*

输出的 WAR 文件的路径如下：

```
  bazel-bin/gerrit.war
```

### Gerrit Release WAR File

为了构建 gerrit 的所有应用，包括 PolyGerrit UI, core plugins 和 documentation ，可以使用如下命令：

```
  bazel build release
```

输出的 WAR 文件的路径如下：

```
  bazel-bin/release.war
```

### Headless Mode

为了构建 Gerrit 的 headless 模式（无 UI 模式），可以使用如下命令：

```
  bazel build headless
```

输出的 WAR 文件的路径如下：

```
  bazel-bin/headless.war
```

### Extension and Plugin API JAR Files

构建 gerrit 的 extension, plugin 和 acceptance-framework JAR 文件，可以使用如下命令：

```
  bazel build api
```

输出的含有 Java 二进制文件, Java 源码 和 Java 文档的路径如下：

```
  bazel-genfiles/api.zip
```

安装 {extension,plugin,acceptance-framework}-api 到本地的 maven repository:

```
  tools/maven/api.sh install
```

安装 gerrit.war 到本地的 maven repository:

```
  tools/maven/api.sh war_install
```

### Plugins

```
  bazel build plugins:core
```

输出 plugin 的 JAR 文件会存放在：

```
  bazel-genfiles/plugins/<name>/<name>.jar
```

JAR 文件会被打包在:

```
  bazel-genfiles/plugins/core.zip
```

构建指定的 plugin:

```
  bazel build plugins/<name>
```

输出的 JAR 文件会存放在：

```
  bazel-genfiles/plugins/<name>/<name>.jar
```

构建单独的 plugin，`core.zip` 文件不会重新生成。

构建时打印所有的报错信息，可以执行：

```
  bazel build --java_toolchain //tools:error_prone_warnings_toolchain //...
```

## Using an IDE.

### IntelliJ

构建 gerrit 使用 bazel 的 [IntelliJ plugin](https://ij.bazel.io)，请参考 [IntelliJ 设置](dev-intellij.md) 。

### Eclipse

#### Generating the Eclipse Project

创建 Eclipse 的项目：

```
  tools/eclipse/project.py
```

然后进行设置，可以参考 [Eclipse 设置](dev-eclipse.md) 。

#### Refreshing the Classpath

如果 classpath 需要更新，Eclipse 项目会通过执行 `project.py` 来刷新并下载依赖的 JARs 文件。对于 IntelliJ，需要点击 [IntelliJ plugin](https://ij.bazel.io) 的 `Sync Project with BUILD Files` 按钮。

### Documentation

为测试或者静态服务器构建文档：

```
  bazel build Documentation:searchfree
```

html 文件会被打包到如下位置：

```
  bazel-bin/Documentation/searchfree.zip
```

构建 WAR 和 文档，命令如下：

```
  bazel build withdocs
```

WAR 文件存放的位置如下：

```
  bazel-bin/withdocs.war
```

## Running Unit Tests

```
  bazel test --build_tests_only //...
```

调测：

```
  bazel test --test_output=streamed --test_filter=com.gerrit.TestClass.testMethod  testTarget
```

调测示例：

```
  bazel test --test_output=streamed --test_filter=com.google.gerrit.acceptance.api.change.ChangeIT.getAmbiguous //javatests/com/google/gerrit/acceptance/api/change:api_change
```

执行群组的测试，例如：测试的群组名称 rest-account：

```
  bazel test //javatests/com/google/gerrit/acceptance/rest/account:rest_account
```

执行测试但不使用 SSH:

```
  bazel test --test_env=GERRIT_USE_SSH=NO //...
```

排除标识为 `flaky` 的测试：

```
  bazel test --test_tag_filters=-flaky //...
```

使用 docker 执行测试：

```
  bazel test --test_tag_filters=-docker //...
```

忽略被缓存的测试相关数据：

```
  bazel test --cache_test_results=NO //...
```

执行一个或多个测试群组：

```
  bazel test --test_tag_filters=api,git //...
```

下面是群组名称可以使用的值：

* annotation
* api
* docker
* edit
* elastic
* git
* notedb
* pgm
* rest
* server
* ssh

### Elasticsearch

需要使用 docker 来完成对 Elasticsearch 的测试，并且本地需要配置 [virtual memory](https://www.elastic.co/guide/en/elasticsearch/reference/current/vm-max-map-count.html) 。

如果没有明确 Docker，那么会忽略对 Elasticsearch 的测试。目前，bazel 不显示 [忽略的测试](https://github.com/bazelbuild/bazel/issues/3476) 的结果。

## Dependencies

可以事先下载所依赖的 JARs 文件，在没有网络链接的情况下非常有用。

```
  bazel fetch //...
```

如果下载需要通过 proxy 来完成，一定要配置 `curl` 的代理：

```
  export http_proxy=http://<proxy_user_id>:<proxy_password>@<proxy_server>:<proxy_port>
```

Maven 和 ‘Gerrit storage bucket’ 可以根据 `local.properties` 从镜像来下载，如下：

```
  echo download.GERRIT = http://nexus.my-company.com/ >>local.properties
  echo download.MAVEN_CENTRAL = http://nexus.my-company.com/ >>local.properties
```

`local.properties` 文件一般存储在 gerrit 仓库的根目录下或者 `~/.gerritcodereview/` 目录。优先使用 gerrit 仓库根目录下的文件。

## Building against unpublished Maven JARs

构建时为了使用未发布的 Maven JARs 文件，比如： gwtorm 或 PrologCafe。定制的 JARs 文件需要安装到本地的 Maven repository (`mvn clean install`) 并且 `maven_jar()` 的 repository 要更新为 `MAVEN_LOCAL` ：

```
 maven_jar(
   name = 'gwtorm',
   artifact = 'gwtorm:gwtorm:42',
   repository = MAVEN_LOCAL,
 )
```

## Building against artifacts from custom Maven repositories

构建时为了使用自定义的 Maven repository ，支持两种操作方式：重写 local.properties 和不重新。

通过使用 maven_jar() 函数，而不重写定制 Maven repository 的 URL:

```
  GERRIT_FORGE = 'http://gerritforge.com/snapshot'

  maven_jar(
    name = 'gitblit',
    artifact = 'com.gitblit:gitblit:1.4.0',
    sha1 = '1b130dbf5578ace37507430a4a523f6594bf34fa',
    repository = GERRIT_FORGE,
 )
```

如要重写定制的 URL， then the same logic as with Gerrit
known Maven repository is used: Repo name must be defined that matches an entry
in local.properties file:

如要自定义定制的 URL，使用与 Gerrit 已知的 Maven repository 的逻辑是相同的：需要定义 Repo 名称，并且要与 local.properties 文件中的名称保持一致。

```
  download.GERRIT_FORGE = http://my.company.mirror/gerrit-forge
```

与之相关的部分内容如下： 

```
  GERRIT_FORGE = 'GERRIT_FORGE:'

  maven_jar(
    name = 'gitblit',
    artifact = 'com.gitblit:gitblit:1.4.0',
    sha1 = '1b130dbf5578ace37507430a4a523f6594bf34fa',
    repository = GERRIT_FORGE,
 )
```

To consume the JGit dependency from the development tree, edit
`lib/jgit/jgit.bzl` setting LOCAL_JGIT_REPO to a directory holding a
JGit repository.
如果要从开发目录中使用 JGit 的依赖，需要编辑 `lib/jgit/jgit.bzl` 将 LOCAL_JGIT_REPO 设置为包含 JGit repository 的目录。

为了加快构建，可以使用如下默认的缓存：

* ~/.gerritcodereview/bazel-cache/downloaded-artifacts
* ~/.gerritcodereview/bazel-cache/repository
* ~/.gerritcodereview/bazel-cache/cas

目前，这些缓存的存储没有上限，具体可以参考 [tbazel issue](https://github.com/bazelbuild/bazel/issues/5139)。用户可以手动清除缓存。

## NPM Binaries

PolyGerrit 的构建需要执行基于 NPM 的 JavaScript 的二进制文件。构建时不会尝试解析和下载 NPM 的依赖，而是使用 NPM 二进制及其依赖项的预编译 bundle。[registry.npmjs.org](https://docs.npmjs.com/misc/registry) 上面的一些包文件自带依赖的 bundle 文件，这不是规定而是例外的情况。如果要想列表中添加二进制文件，需要用户自己将其打包。

**NOTE:**
*我们只能使用某些符合许可要求的二进制文件，并且不包含任何代码。*

检查可以接受的许可和 bundle 的文件类型：

```
  gerrit_repo=/path/to/gerrit
  package=some-npm-package
  version=1.2.3

  npm install -g license-checker && \
  rm -rf /tmp/$package-$version && mkdir -p /tmp/$package-$version && \
  cd /tmp/$package-$version && \
  npm install $package@$version && \
  license-checker | grep licenses: | sort -u
```

上面的命令会通过包及其依赖项输出不同的许可列表。在许可允许的范围内，可以发布 bundle。只要使用 [Google's standards](https://opensource.google.com/docs/thirdparty/licenses/)，这些列表都是允许的。任何 `by_exception_only`, 商用的, 被禁止的, 或者列表外的许可是不被允许发现的。如有疑问，请联系 google 相关人员。

下一步，检查文件的类型：

```
  cd /tmp/$package-$version
  find . -type f | xargs file | grep -v 'ASCII\|UTF-8\|empty$'
```

如果文件看起来像库文件或二进制文件，则不能使用 bundle。相反，可以创建 bundle 文件，并记录相关的 SHA-1：

```
  $gerrit_repo/tools/js/npm_pack.py $package $version && \
  sha1sum $package-$version.tgz
```

在工作目录创建一个名为  `$package-$version.tgz` 的文件。

任何一个项目维护人员可以上传这种类型的文件到 [storage bucket](https://console.cloud.google.com/storage/browser/gerrit-maven/npm-packages)。

最后，构建过程中添加新的二进制文件：

```
  # WORKSPACE
  npm_binary(
      name = "some-npm-package",
      repository = GERRIT,
  )

  # lib/js/npm.bzl
  NPM_VERSIONS = {
    ...
    "some-npm-package": "1.2.3",
  }

  NPM_SHA1S = {
    ...
    "some-npm-package": "<sha1>",
  }
```

为了使用 bazel 构建产生的二进制文件，可以使用 `run_npm_binary.py` 脚本。例如：参考 `tools/bzl/js.bzl` 中 `crisper` 的使用。

