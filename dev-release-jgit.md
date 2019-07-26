# Making a Snapshot Release of JGit

如果我们要创建非官方的 JGit 快照并将其保存到 [Google Cloud Storage](https://developers.google.com/storage/)，那么下面的说明是必要的。

## 准备 Maven 环境

首先，确认 `settings.xml` 进行了 Maven 的正确配置。

为了应用 JGit 的 `pom.xml` 中的必要设置，可以参考 `pom.xml` 的配置说明或者在 JGit 的工作目录中执行下列命令来应用所提供的差异：

```
  git apply /path/to/gerrit/tools/jgit-snapshot-deploy-pom.diff
```

## 准备 Release

因为 JGit 有其自己的发布过程，所以我们不需要推送任何发布的标签。我们可以使用 `git describe` 的输出信息最为 JGit 快照的版本。

在 JGit 的工作目录, 执行下面命令：

```
  ./tools/version.sh --release $(git describe)
```

## 发布 Release

为了部署新的 snapshot, 在 JGit 的工作目录执行如下命令：

```
  mvn deploy
```


