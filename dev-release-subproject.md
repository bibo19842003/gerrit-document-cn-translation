# Making a Release of a Gerrit Subproject

## Make a Snapshot

* 构建最新的 snapshot 并将其安装到本地的 Maven 仓库中：

```
  mvn clean install
```

* 使用本地的 snapshot 测试 Gerrit

## Publish Snapshot

如果 subproject 创建了一个 snapshot，并且 gerrit 引用了这个 snapshot，那么在 gerrit 的开发过程中，此 snapshot 需要尽快发布。

* 确认已为部署准备好了相关的配置文件：
    [配置 Maven 的 `settings.xml` 文件](dev-release-deploy-config.md)
    为 [subprojects](dev-release-deploy-config.md) 配置 `pom.xml` 文件

* 部署新的 snapshot:

```
  mvn deploy
```

* 在 `/WORKSPACE` 目录中，将 subproject 的 `maven_jar` 中的 `id`, `bin_sha1`, `src_sha1` 值修改为 `SNAPSHOT` 所对应的版本。

Gerrit 发布的时候，subproject 需要完成相关的发布，因为 gerrit 需要关联 subproject 的版本。

## Prepare the Release

* 为 subproject 创建和测试最新的 snapshot
* 更新 `pom.xml` 中相关的项目版本信息
* 创建发布的 Tag

```
  git tag -a -m "prolog-cafe 1.3" v1.3
```

* 构建并将其安装到本地的 Maven 仓库中:

```
  mvn clean install
```

## Publish the Release

* 确认已经完成了部署所需要的配置文件：
    [配置 Maven 的 `settings.xml` 文件](dev-release-deploy-config.md)
    为 [subprojects](dev-release-deploy-config.md) 配置 `pom.xml` 文件

* 部署新的发布:

```
  mvn deploy -DperformRelease=true
```

* 将 pom 的修改推送到 project 中

* 推送发布的 tag：

```
  git push gerrit-review refs/tags/v1.3:refs/tags/v1.3
```

