# Making a Gerrit Release

**NOTE:**
*此文主要用于 gerrit 维护人员使用。维护人员具有评审，submit ，owner 的权限。*

gerrit 发布新的版本需要处理大量的复杂任务，很容易错过一个步骤进而影响版本的发布。本文描述了发布的过程。

## Gerrit Release Type

下面是关于发布方法的指导，具体的指导需要参考所要发布的类型(`stable-fix`, `stable`, `rc0`,`rc1`...)。

### Stable

一个 `stable` 发布通常是基于 `master` 分支构建出来的，并且在最终的发布前需要经过多轮稳定性的测试。

* 建议把相关的发布计划推送到维护人员的邮件列表中

* 创建 gerrit `rc0` 版本

* 如果需要，创建 gerrit `rc1` 版本

**NOTE:**
*此版本需要包含一些新的功能。*

* 如果需要，创建 gerrit `rc2` 版本

*此版本不包含新功能，只有一些 bug 的修复。*

* 最终创建 `stable` 发布 (不包含 `rc`)

### Stable-Fix

`stable-fix` 的发布会包含 bug 的修复和文档的更新。

* 建议把相关的发布计划推送到维护人员的邮件列表中

* 此类型的发布不需要 RC 版本，只有完成目标，即可发布。

### Security-Fix

`security-fix` 的发布会包含安全问题的修复。

对于安全相关的问题，重要的是只有在修复后，相关版本才会公布出来。因此，`security-fix` 的发布不会在公开的 gerrit 中出现。

`security-fix` 的版本在 `gerrit-security-fixes` project 中维护，只有 gerrit 的维护人员才可以访问。只有 `security-fix` 的版本发布后，才会把相关的 commit 从 `gerrit-security-fixes` 移植到公开的 gerrit 中。

## Create the Actual Release

### Update Versions and Create Release Tag

在做发布的版本构建之前，要更新`version.bzl` 文件中的 `GERRIT_VERSION` 版本，例如：将 `$version-SNAPSHOT` 修改为 `$version` 。

另外，所有 *_pom.xml` 文件中的版本也要进行更新。

可以执行 `./tools/version.py` 脚本来更新版本，如：

```shell
  version=2.15
  ./tools/version.py $version
```

commit 并且在新的 commit 上创建 signed tag：

```shell
  git tag -s -m "v$version" "v$version"
```

plugin 也要打 tag：

```shell
  git submodule foreach '[ "$path" == "modules/jgit" ] || git tag -s -m "v$version" "v$version"'
```

### Build Gerrit

* 构建 Gerrit WAR, API JARs, documentation

```
  bazel build release Documentation:searchfree
  ./tools/maven/api.sh war_install
  ./tools/maven/api.sh install
```

* 验证 WAR 版本:

```shell
  java -jar bazel-bin/release.war --version
```

* 测试更新一个站点并启动 gerrit 服务

* 验证 plugin 版本：

```shell
  java -jar bazel-bin/release.war init --list-plugins
```

### Publish the Gerrit Release

#### Publish the Gerrit artifacts to Maven Central

* 确认已经完成了部署 maven 中心库 [配置](dev-release-deploy-config.md)

* 确认 `version.bzl` 和 `*_pom.xml` 文件中的版本已更新

* 将 WAR 推送到 Maven 中心库:

```
  ./tools/maven/api.sh war_deploy
```

* 将 plugin artifacts 推送到 Maven 中心库:

```
  ./tools/maven/api.sh deploy
```

* `version.bzl` 文件中 `GERRIT_VERSION` 所依赖的 artifacts 需要上传:

    SNAPSHOT 的新版本文件直接上传到 Sonatype 的 snapshots 仓库，https://oss.sonatype.org/content/repositories/snapshots/com/google/gerrit/

    Release 的新版本文件上传到 [Sonatype Nexus Server](https://oss.sonatype.org/) 的 `staging repository`。

* 验证 `staging repository`

    访问 [Sonatype Nexus Server](https://oss.sonatype.org/)，并登录。

    在左侧导航栏的 'Staging Repositories' 下方，点击 'Build Promotion'，寻找 `comgooglegerrit-XXXX` `staging repository`。

    验证内容

        打开 `staging repository` 后，可以上传及更新文件。如果认为 `staging repository` 有问题的话，可以选择 `Drop` 来进行删除。

    在 `staging repository` 运行 Sonatype 验证

        选择 `staging repository` 并点击 `Close`。此时可以为 `staging repository` 运行 Sonatype 验证。如果验证通过，那么 repository 会关闭，被关闭的 repository 不能被修改，如果发现有问题的话，只等被删除。

    测试关闭 `staging repository`

        一旦 repository 被关闭，可以在 `Summary` 部分找到其相关的 URL，例如：https://oss.sonatype.org/content/repositories/comgooglegerrit-1029

        使用这个 URL 可以对这个 repository 的 artifacts 进行测试，例如：更新 `*_pom.xml` 文件的相关配置后，使用这个 repository 中的文件进行相关 plugin 的构建，配置更改如下：

```
  <repositories>
    <repository>
      <id>gerrit-staging-repository</id>
      <url>https://oss.sonatype.org/content/repositories/comgooglegerrit-1029</url>
    </repository>
  </repositories>
```

* 发布 `staging repository`

`staging repository` 的发布可以参考 [Sonatype OSS Maven Repository 使用指导](https://docs.sonatype.org/display/Repository/Sonatype+OSS+Maven+Repository+Usage+Guide#SonatypeOSSMavenRepositoryUsageGuide-8.a.2.ReleasingaStagingRepository)。

**WARNING:**
*发布到 Maven 中心库的 artifacts 不能被回退！*

    在 [Sonatype Nexus Server](https://oss.sonatype.org/) 找到关闭的 `staging repository`，点击 `Release`。

    已发布的 artifacts 可以在 https://oss.sonatype.org/content/repositories/releases/com/google/gerrit/ 进行查看。

    直到 Maven 中心库(http://central.maven.org/maven2/com/google/gerrit/)同步到 artifacts，大概需要 2 个小时的时间。

* 可选操作: 下载查看静态文件

    登录 [Sonatype Nexus Server](https://oss.sonatype.org/)

    在左侧导航栏的 'Central Statistics' 下方点击 'Views/Repositories'。

    选择 `com.google.gerrit` 作为 `Project`。

#### 将 Gerrit WAR 发布到 Google Cloud Storage

* 打开 [gerrit-releases bucket in the Google cloud storage console](https://console.cloud.google.com/storage/browser/gerrit-releases/?project=api-project-164060093628)
* 要使用 Gmail 账户登录
* 点击 `Upload` 按钮并上传 Gerrit WAR 文件

#### Push the Stable Branch

* 在 [gerrit](https://gerrit-review.googlesource.com/admin/repos/gerrit) 中创建 `stable-$version` 分支
* 对 `stable-$version` 分支可以做相关修改并合入
* 创建一个 change，更新 `.gitreview` 的 `defaultbranch` 字段用来匹配分支名称。

#### Push the Release Tag

推送新的 Release Tag:

```shell
  git push gerrit-review tag v$version
```

为 plugin 推送新的 Release Tag:

```shell
  git submodule foreach git push gerrit-review tag v$version
```

#### Upload the Documentation

* 从构建命令生成的打包文件 `bazel build searchfree`: `bazel-bin/Documentation/searchfree.zip` 解压相关文档。

* 将文件手动上传到 [gerrit-documentation](https://console.cloud.google.com/storage/browser/gerrit-documentation/?project=api-project-164060093628)。

### Finalize the Release Notes

向 homepage project 上传 change:

* 相关部分中移除关于 'In Development' 的描述。

* 添加已发布的 .war 文件和 文档的链接，并将最新版本的字体进行加粗处理。

#### Update homepage links

向 [homepage project](https://gerrit-review.googlesource.com/admin/repos/homepage) 上传 change 将版本号更新到最新。

#### Update the Issues

手动更新问题的状态，没有脚本支持。

在发布之前，如果有 change 提交，那么将当前问题的状态更新为：`Status = Submitted, FixedIn-$version`。

在发布后，搜索 `Status=Submitted FixedIn=$version`，并将状态更新为 to say `Status=Released`。

#### Announce on Mailing List

发邮件给社区的维护者，宣布已发布新版本。邮件内容可以使用 gerrit-release-tools 仓库的 `release-announcement.py` 脚本来生成，生成的内容包括必要的链接，hash 值及 PGP 签名。

文档的详细描述可以参考脚本的头部，或者执行如下命令：

```shell
 ~/gerrit-release-tools/release-announcement.py --help
```

### Increase Gerrit Version for Current Development

所有的新的开发需要在 `master` 分支的下一个发布中完成，gerrit 的版本需要为下一次发布设定为 snapshot 版本。

使用 `version` 工具在 `version.bzl` 文件中设定版本：

```
 ./tools/version.py 2.6-SNAPSHOT
```

然后将修改合入 master 分支。

### Merge `stable` into `master`

每次发布新的版本后，stable 分支需要 merge 到 master 分支，确保相关 changes/fixes 不会丢失。

```shell
  git config merge.summary true
  git checkout master
  git reset --hard origin/master
  git branch -f stable origin/stable
  git merge stable
```

Bazlets 用于 gerrit plugin 简单的构建。plugin 可以使用的 Bazlets 版本，可以参考 [gerrit_api.bzl](https://gerrit.googlesource.com/bazlets/+/master/gerrit_api.bzl#8)。如果 api 版本有更新，需要上传 change 到 bazlets 仓库。

### Clean up on master

一旦完成了发布，需要在下个发布中检查 master 分支超期的未完成的 change ，大多数是一些废弃的功能，这些代码需要删除。

可以参考 [向 Gerrit 社区贡献](dev-processes.md) 中 `Deprecating` 的相关章节。

