# Gerrit Code Review - Superproject subscription to submodules updates

## Description

Gerrit 有一个定制的 superproject 用于跟踪子模块的变化。如果被跟踪的子模块有了更新，那么这个 superproject 也会随之更新。

假设有一个 superproject 名叫 'super'，'super' 有个开发分支 'dev'，superproject 有一个子模块 'sub'，'sub' 有一个分支 'dev-of-sub'。当有一个 commit 合入了 'sub' 的 'dev-of-sub' 分支，那么 gerrit 会自动在 'super' 的 'dev' 分支上创建一个新的提交用来更新指向新节点的 gitlink。

为了使用这个特性，可按如下操作：

 * 确保 superproject 在 gerrit.config 中配置了 `submodule.enableSuperProjectSubscriptions`
 * 为 superproject 配置子模块
 * 确保 superproject 中的 .gitmodules 文件包含如下信息：
    branch 字段
    url 路径，参考 gerrit.config 中的 `gerrit.canonicalWebUrl` 

此功能默认是开启的。

## Git submodules overview

Submodules 是 Git 的一个功能，允许其他的 project 嵌套在里面。这里只是一个简短的描述，更多的细节可以参考 git 的官方文档。

假设有两个 project 名叫 'super' 和 'sub'，把 'sub' 设置成 'super' 的子模块，如下:
```
git submodule add ssh://server/sub sub
```

执行上面的命令后，在 'super' 的目录中新增了一个 `.gitmodules` 文件，此描述了其子模块的相关信息。如果要查看子模块的节点信息，可以使用下面的命令进行查看：
```
git submodule status
```

还是上面的示例，如果 'sub' 更新了，那么 'super' 也会随之更新。

## Creating a new subscription

### Ensure the subscription is allowed

为了确保 superproject 可以获取到子模块的相关信息，子模块需要启用 `superproject subscription`。在子模块的客户端，检出 refs/meta/config 分支，并且在 'project.config' 文件中设置 subscribe，相关操作如下：
```
    git fetch <remote> refs/meta/config:refs/meta/config
    git checkout refs/meta/config
    $EDITOR project.config
```
添加下列信息:
```
  [allowSuperproject "<superproject>"]
    matching = <refspec>
```
上面两行信息中，'superproject' 为具体的 superproject 的名称；'refspec' ，与 superproject 所关联的分支名称。

```
  git add project.config
  git commit -m "Allow <superproject> to subscribe"
  git push <remote> HEAD:refs/for/refs/meta/config
```
上面的修改合入后，关联子项目的配置就搞定了。

配置可以继承，例如 "All-Projects" 的配置如下：
```
    [allowSuperproject "my-only-superproject"]
        matching = refs/heads/*:refs/heads/*
```
此刻，不用再担心单独的 project 的配置了，因为配置都向下继承了。

### Defining the submodule branch

子模块添加到 superproject 后，需要将子模块的分支信息添加到 `.gitmodules` 文件。

由于 branch 字段的信息不会由 `git submodule` 命令自动添加，所以需要手动编辑来完成。branch 的值对应的是子模块的分支，在子模块的分支有更新的时候，gitlink 也会自动更新。

如果子模块的分支与 gitlinks/.gitmodules 文件所提交的目标分支相同，那么此处 branch 的值可以是 "'.'" 。

如果打算使用 Gerrit 的这个功能，那么在添加子模块后需要手动更新 `.gitmodules` 文件。

如果 `.gitmodules` 文件缺失 branch 字段相关信息，那么 gerrit 不会启用子模块功能。

每当有 commit 合入时，gerrit 都会做检查，看看是否有相关的 superproject。如果有，则检查 superproject 中的 `.gitmodules` 文件是否存在包含 `branch` 字段和 `url`字段。

### The RefSpec in the allowSuperproject section

superproject 配置关联子项目的分支时，需要指定两个参数。`allowSuperproject.<superproject>.matching` 是 Git-style 的配置, 需要指定具体的分支名称，不支持正则表达式。

需要明确分支的对应关系，格式如下:

```
  [allowSuperproject "<superproject>"]
    matching = refs/heads/<submodule-branch>:refs/heads/<superproject-branch>
```

如果是 1:1 对应关系，如：'master' 对应 'master', 'stable' 对应 'stable', 而不是 'master' 对应 'stable'。

```
  [allowSuperproject "<superproject>"]
    matching = refs/heads/master:refs/heads/master
```

如果是 1 对多的关系，参考如下：
```
  [allowSuperproject "<superproject>"]
     all = refs/heads/<submodule-branch>:refs/heads/*
```

如果是多对多的关系，如下：

```
  [allowSuperproject "<superproject>"]
     all = refs/heads/*:refs/heads/*
```

### Subscription Limitations

因为子模块的 URL 与 `canonical web URL` 的起始部分有可能不一样，所以关联子模块与 `canonical web URL` 不能一起使用，可以使用相关的子模块来代替。

通过向 `.gitmodules` 文件添加 `branch` 字段将已存在的子模块转换为订阅模式，直到子模块的下一次更新前，gerrit 不会变更子模块的 revision（superproject 的 gitlink）。换句话说，如果子模块不是最新的状态，添加订阅模式后也不会进行更新，这种情况下，只能手动更新。

### Relative submodules

Gerrit 试图匹配完整的子模块名称，包括目录名称。因此，提供 project 的全名称是必要的，参考如下：

有一个 superproject ，如下：`product/super_repository.git`；在这个目录中添加一个子模块 "deeper" ，如下：`product/framework/subcomponent.git`。

现在编辑 `.gitmodules` 文件，使用 project 的完整路径。使用两个 `../` 来完成 project 的整个路径。

```
  path = subcomponent.git
  url = ../../product/framework/subcomponent.git
  branch = master
```

相反，下面的配置会失败：

```
  path = subcomponent.git
  url = ../framework/subcomponent.git
  branch = master
```

## Removing Subscriptions

如果要移除子模块，可以在子模块中移除相关配置，或者在 superproject 中移除子模块相关信息。

