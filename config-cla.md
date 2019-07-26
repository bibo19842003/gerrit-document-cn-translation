# Gerrit Code Review - Contributor Agreements

用户在向 project 提交 change 之前，有时需要签署贡献者声明。

贡献者声明是全局配置的，需要在 `All-Projects` 的 `project.config` 文件中进行配置。

为了获取 `project.config` 文件，可以临时初始化一个 git 仓库，以便修改配置文件：

```
  mkdir cfg_dir
  cd cfg_dir
  git init
```

从 gerrit 下载配置文件：
```
  git fetch ssh://localhost:29418/All-Projects refs/meta/config
  git checkout FETCH_HEAD
```

贡献者声明需要在 `project.config` 文件的 `contributor-agreement` 部分进行定义：

```
  [contributor-agreement "Individual"]
    description = If you are going to be contributing code on your own, this is the one you want. You can sign this one online.
    agreementUrl = static/cla_individual.html
    autoVerify = group CLA Accepted - Individual
    accepted = group CLA Accepted - Individual
    matchProjects = ^/.*$
    excludeProjects = ^/not/my/project/
```

每个 `contributor-agreement` 部分需要使用唯一的名字，此名字会在网页上显示。

如果页面上还没有显示，可以把 `autoVerify` 对应的组名和 `accepted` 变量写入到 `groups` 文件中：

```
    # UUID                                  	Group Name
    #
    3dedb32915ecdbef5fced9f0a2587d164cd614d4	CLA Accepted - Individual
```

git commit 和 git push :

```
  git commit -a -m "Add Individual contributor agreement"
  git push ssh://localhost:29418/All-Projects HEAD:refs/meta/config
```

**contributor-agreement.<name>.description**

贡献者声明的描述。当用户选择声明的时候，描述会出现。

**contributor-agreement.<name>.agreementUrl**

贡献者声明的地址。可以是绝对路径，也可以是相对路径，地址需要以 http 或 https 开头。此地址与 `gerrit.config` 文件中的 `gerrit.basePath` 变量值相同。 

**contributor-agreement.<name>.autoVerify**

签署者加入的群组名称。用户可以在线签署贡献者声明，签署后，会自动加入这个群组。因此，`groups` 文件中要有这个群组的 UUID 的信息。

**contributor-agreement.<name>.accepted**

接受可以签署贡献者声明的群组列表，`groups` 文件中要有这个群组的 UUID 的信息。

**contributor-agreement.<name>.matchProjects**

用正则表达式配置哪些 project 需要进行签署。如果忽略此参数，默认所有 project 都需要签署。

**contributor-agreement.<name>.excludeProjects**

用正则表达式配置哪些 project 不需要进行签署。如果忽略此参数，那么表示没有不需要签署的 project。

