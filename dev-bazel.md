# Gerrit Code Review - Building with Bazel

## TL;DR

如何依赖的工具、环境都准备好了，可以执行：

```
  $ bazel build gerrit
```

此时会生成一个 .war 文件，如： `bazel-bin/gerrit.war`.

## Prerequisites

构建 gerrit 源码，需要工具如下：

* Linux 或 macOS 操作系统 (目前不支持 Windows 操作系统)
* Java 版本：8|9|10|11|...
* Python 2 or 3
* [Node.js (including npm)](https://github.com/nodesource/distributions/blob/master/README.md)
* Bower (`sudo npm install -g bower`)
* [Bazel](https://docs.bazel.build/versions/master/install.html) 和 [Bazelisk](https://github.com/bazelbuild/bazelisk)
* Maven
* zip, unzip
* curl
* gcc

### Bazel

[Bazelisk](https://github.com/bazelbuild/bazelisk) 包括了 [Bazel](https://bazel.build/) 的版本检查和下载的功能。对 Gerrit 来说，`bazel` 使用 Bazelisk 进行启动。安装 Bazelisk 后，会自动创建 `bazel` 的链接文件，因此当执行 `bazel` 命令时，会调用 Bazelisk。

### Java

#### MacOS

在 MacOS 系统中，确保 "Java for MacOS X 10.5 Update 4" (或更高版本) 被安装并且 `JAVA_HOME` 已按照 [Java version 描述](install.md)进行设置。

Java 可以在下面的路径中找到 "/System/Library/Frameworks/JavaVM.framework/Versions"。

可以打开一个命令行窗口执行 `java -version` 命令来查看 Java 版本。

#### Java 13 support

通过配置 vanilla java toolchain [Bazel option](https://docs.bazel.build/versions/master/toolchains.html)，可以支持Java 13 (及以后版本)。
若使用 Java 13 (及以后版本) 进行构建 Gerrit，需要在 JDK HOME 中明确 vanilla java toolchain：

 ```
   $ bazel build \
    --define=ABSOLUTE_JAVABASE=<path-to-java-13> \
    --javabase=@bazel_tools//tools/jdk:absolute_javabase \
     --host_javabase=@bazel_tools//tools/jdk:absolute_javabase \
     --host_java_toolchain=@bazel_tools//tools/jdk:toolchain_vanilla \
     --java_toolchain=@bazel_tools//tools/jdk:toolchain_vanilla \
    :release
```

如要进行测试，需要添加 `--javabase` 参数，因为 bazel test 运行和测试的时候会使用 javabase:

```
  $ bazel test \
    --define=ABSOLUTE_JAVABASE=<path-to-java-13> \
    --javabase=@bazel_tools//tools/jdk:absolute_javabase \
    --host_javabase=@bazel_tools//tools/jdk:absolute_javabase \
    --host_java_toolchain=@bazel_tools//tools/jdk:toolchain_vanilla \
    --java_toolchain=@bazel_tools//tools/jdk:toolchain_vanilla \
    //...
```

在使用 bazel 构建的时候，为了避免每次都解析所有的参数，可以把相关参数添加到 `~/.bazelrc` 文件中：

```
$ cat << EOF > ~/.bazelrc
> build --define=ABSOLUTE_JAVABASE=<path-to-java-13>
> build --javabase=@bazel_tools//tools/jdk:absolute_javabase
> build --host_javabase=@bazel_tools//tools/jdk:absolute_javabase
> build --host_java_toolchain=@bazel_tools//tools/jdk:toolchain_vanilla
> build --java_toolchain=@bazel_tools//tools/jdk:toolchain_vanilla
> EOF
```

现在，执行 `bazel build :release` 命令时，会调用上面的参数。

#### Java 11 support
 
通过变更 `java toolchain` 的 [Bazel 参数](https://docs.bazel.build/versions/master/toolchains.html)，可以支持 Java 11 的使用。为了在构建的时候使用 Java 11,需要明确 JDK 11 java toolchain：
 
 ```
   $ bazel build \
      --host_javabase=@bazel_tools//tools/jdk:remote_jdk11 \
      --javabase=@bazel_tools//tools/jdk:remote_jdk11 \
      --host_java_toolchain=@bazel_tools//tools/jdk:toolchain_java11 \
      --java_toolchain=@bazel_tools//tools/jdk:toolchain_java11 \
       :release
 ```
 
### Node.js and npm packages
参考 [Installing Node.js and npm packages](https://gerrit.googlesource.com/gerrit/+/master/polygerrit-ui/README.md#installing-node_js-and-npm-packages).
 
## Building on the Command Line

### Gerrit Development WAR File

构建 gerrit 的 web 应用：

```
  bazel build gerrit
```

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
  bazel-bin/api.zip
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
  bazel-bin/plugins/<name>/<name>.jar
```

JAR 文件会被打包在:

```
  bazel-bin/plugins/core.zip
```

构建指定的 plugin:

```
  bazel build plugins/<name>
```

输出的 JAR 文件会存放在：

```
  bazel-bin/plugins/<name>/<name>.jar
```

构建单独的 plugin，`core.zip` 文件不会重新生成。

## Using an IDE.

### IntelliJ

构建 gerrit 使用 bazel 的 [IntelliJ plugin](https://ij.bazel.build)，请参考 [IntelliJ 设置](dev-intellij.md) 。

### Eclipse

#### Generating the Eclipse Project

创建 Eclipse 的项目：

```
  tools/eclipse/project.py
```

然后进行设置，可以参考 [Eclipse 设置](dev-eclipse.md) 。

#### Refreshing the Classpath

如果 classpath 需要更新，Eclipse 项目会通过执行 `project.py` 来刷新并下载依赖的 JARs 文件。对于 IntelliJ，需要点击 [IntelliJ plugin](https://ij.bazel.build) 的 `Sync Project with BUILD Files` 按钮。

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

执行测试的时候，需要指定 git 协议的版本:

```
  bazel test --test_tag_filters=-git-protocol-v2 //...
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
* git-protocol-v2
* git-upload-archive
* notedb
* pgm
* rest
* server
* ssh

### Elasticsearch

需要使用 docker 来完成对 Elasticsearch 的测试，并且本地需要配置 [virtual memory](https://www.elastic.co/guide/en/elasticsearch/reference/current/vm-max-map-count.html) 和 [macOS](link:https://www.elastic.co/guide/en/elasticsearch/reference/current/docker.html#_set_vm_max_map_count_to_at_least_262144)。

对于 macOS, 如果使用[Docker Desktop](https://docs.docker.com/docker-for-mac/)，可以根据实际情况设置内存的大小。默认内存的值偏小，需要将其调大，如：默认值是 2GB，但至少需要设置 5GB。

如果没有明确 Docker，那么会忽略对 Elasticsearch 的测试。目前，bazel 不显示 [忽略的测试](https://github.com/bazelbuild/bazel/issues/3476) 的结果。

### Controlling logging level

所有测试的 logging 的默认级别为 `INFO` ，可以启动 `DEBUG` 级别的 log。

IDE 中， 需要设置 VM 参数：`-Dgerrit.logLevel=debug`。并且使用 `bazel` 配置环境变量 `GERRIT_LOG_LEVEL=debug`，

```
  bazel test --test_filter=com.google.gerrit.server.notedb.ChangeNotesTest \
  --test_env=GERRIT_LOG_LEVEL=debug \
  javatests/com/google/gerrit/server:server_tests
```

log 结果可以安装下面路径进行查看：`bazel-testlogs/javatests/com/google/gerrit/server/server_tests/test.log`。

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

构建时为了使用未发布的 Maven JARs 文件，比如： PrologCafe。定制的 JARs 文件需要安装到本地的 Maven repository (`mvn clean install`) 并且 `maven_jar()` 的 repository 要更新为 `MAVEN_LOCAL` ：

```
 maven_jar(
   name = 'prolog-runtime',
   artifact = 'com.googlecode.prolog-cafe:prolog-runtime:42',
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

## Building against SNAPSHOT Maven JARs
 
为了构建 SNAPSHOT Maven JARs, 可以指定具体的 SNAPSHOT version：

```python
 maven_jar(
   name = "pac4j-core",
   artifact = "org.pac4j:pac4j-core:3.5.0-SNAPSHOT-20190112.120241-16",
   sha1 = "da2b1cb68a8f87bfd40813179abd368de9f3a746",
 )
```

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

  # Note - yarn must be installed before running the following commands
  yarn global add license-checker && \
  rm -rf /tmp/$package-$version && mkdir -p /tmp/$package-$version && \
  cd /tmp/$package-$version && \
  yarn add $package@$version && \
  license-checker | grep licenses: | sort -u
```

上面的命令会通过包及其依赖项输出不同的许可列表。在许可允许的范围内，可以发布 bundle。只要使用 [Google's standards](https://opensource.google.com/docs/thirdparty/licenses/)，这些列表都是允许的。任何 `by_exception_only`, 商用的, 被禁止的, 或者列表外的许可是不被允许发现的。如有疑问，请联系 google 相关人员。

下一步，检查文件的类型：

```
  cd /tmp/$package-$version
  find . -type f | xargs file | grep -v 'ASCII\|UTF-8\|empty$'
```

如果文件看起来像库文件或二进制文件，则不能使用 bundle。相反，可以使用下面命令进行安装相关文件：

```
# Add to ui_npm. Other packages.json can be updated in the same way
cd $gerrit_repo/polygerrit-ui/app
bazel run @nodejs//:yarn add $package
```

更新 `polygerrit-ui/app/node_modules_licenses/licenses.ts` 文件。需要为 package 和 所有的依赖文件添加 licenses。如果忘记添加 license，`Documentation:check_licenses` 测试会失败。

更新后，需要对所有的修改进行提交 (包括 `yarn.lock`)。

[说明]
```
如果 npm package 所依赖文件的 license 不允许使用，那么只能添加这个 package。
```

* 将依赖的文件信息添加到 license.ts ，并标识：`allowed: false`

* 更新 package.json 脚本，移除非 allowed 文件 (如果不更新 postinstall 脚本, `Documentation:check_licenses` 测试会识别)
 
### Update NPM Binaries
更新 NPM 文件后，需要执行上面的操作 (检查 licenses，更新 `licenses.ts` 文件等)。不同的地方是 package 的安装命令：`bazel run @nodejs//:yarn add $package` 替换为 e `bazel run @nodejs//:yarn upgrade ...`，相关的命令参数可以参考：[yarn 更新文档](https://classic.yarnpkg.com/en/docs/cli/upgrade/).

## Google Remote Build Support

Bazel 可以通过 `Google's Remote Build Execution` 来进行构建。

需要如下设置：

```
gcloud auth application-default login
gcloud services enable remotebuildexecution.googleapis.com  --project=${PROJECT}
```

创建工作池。至少需要 4 CPU，否则性能不足。

```
gcloud alpha remote-build-execution worker-pools create default \
    --project=${PROJECT} \
    --instance=default_instance \
    --worker-count=50 \
    --machine-type=e2-standard-4 \
    --disk-size=200
```

为了使用 RBE，执行：

```
bazel test --config=remote \
    --remote_instance_name=projects/${PROJECT}/instances/default_instance \
    javatests/...
```


