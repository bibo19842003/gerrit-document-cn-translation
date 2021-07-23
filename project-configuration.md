# Gerrit Code Review - Project Configuration

## 创建 Project

在 gerrit 上面创建 project 有几种方式：

- 在网页上依次点击 'Projects' > 'Create Project'
- 可以通过 rest api 的方式来 [创建 Project](rest-api-projects.md)
- 通过 SSH 命令 [创建 Project](cmd-create-project.md) 

创建 project 需要有 `Create Project` 权限。

另外，可以在服务器存储 project 的目录直接用 git 命令创建。

### 手动创建 Project

 在 `gerrit.basePath` 目录下创建 project:

```
  git --git-dir=$base_path/new/project.git init
```

**NOTE:**
*创建 project 的时候，project 的名称要以 `.git` 结尾。*

新创建的 project 如果要添加 `git://` 协议进行匿名访问，需要添加 `git-daemon-export-ok` 文件:

```shell
  touch $base_path/new/project.git/git-daemon-export-ok
```

    注册 Project

可以重启 gerrit 服务，或者刷新 `project_list` 缓存:

```shell
  ssh -p 29418 localhost gerrit flush-caches --cache project_list
```

## Project Options

可以参考 [project section](config-project-config.md) 的 `project section` 部分。

## Branch Administration

### 创建 Branch

在 project 中创建 branch 有几种方式:

- 在网页上依次点击 'Projects' > 'List' > <project> > 'Branches'
- 可以通过 rest api 的方式来 [创建 branch](rest-api-projects.md)
- 通过 SSH 命令 [创建 branch](cmd-create-branch.md) 
- 客户端使用 push 命令进行创建 branch

创建 branch 需要有 `Create Reference` 权限。

通过网页，rest api，或者 SSH 命令创建分支时，只能根据 project 中已有的 commit 节点来创建。

如果新分支名称不已 `refs/` 开头，那么系统会自动添加前缀 `refs/heads/`。

新分支启始的 revision 需要是一个有效的 `SHA-1`，但不能是简短的 `SHA-1`。

### 删除 Branch

在 project 中删除 branch 有几种方式:

- 在网页上依次点击 'Projects' > 'List' > <project> > 'Branches'
- 可以通过 rest api 的方式来 [删除 branch](rest-api-projects.md)
- 客户端使用 push 命令进行删除 branch

```shell
  $ git push origin --delete refs/heads/<branch-to-delete>
```

另外，可以用 `--force` 参数来删除已有的分支:

```shell
  $ git push --force origin :refs/heads/<branch-to-delete>
```

删除 branch 需要有 `Delete Reference` 权限，或者有 push 的 `force` 权限。

### 默认 Branch

远端 project 默认分支一般定义为 `HEAD`。

新 project 被创建的时候，初始化的 branch 可以设置为默认 branch。或者通过 `gerrit.defaultBranch` 参数进行设置默认 branch。

当远端的 project 被 clone 到本地后，本地默认检出的分支就是 `HEAD` 对应的分支。

Project 的 owner 可以设置 `HEAD`

- 在网页上依次点击 'Projects' > 'List' > <project> > 'Branches' 
- - 可以通过 rest api 的方式来 [Set HEAD](rest-api-projects.md)


