# The refs/for namespace

在向 gerrit 推送 commit 的时候，需要在 `refs/for` 命名空间中使用 [reference](https://www.kernel.org/pub/software/scm/git/docs/gitglossary.html#def_ref)。此 reference 一般为目标分支，如：`refs/for/[目标分支]`.

例如，在 master 分支上创建一个新的 change，可以使用下面的命令进行推送：

```shell
git push origin HEAD:refs/for/master
```

`refs/for/[目标分支]` 语法格式会让 Gerrit 区分 commit 是生成评审还是直接推送到代码库。

Gerrit 支持长名和短名形式的分支，如下： 

```shell
git commit
git push origin HEAD:refs/for/master
```

与下面是相同的:

```shell
git commit
git push origin HEAD:refs/for/refs/heads/master
```

Gerrit 使用 `refs/for/` 前缀来匹配 "Pushing for Review" 。对于 git client 来说，更像是往同一个分支推送，例如：`refs/for/master`。事实上，每个 commit 推送到这个分支上，gerrit 都会在 `refs/changes/` 命名空间下创建一个新的 ref，格式如下：
```
refs/changes/[CD]/[ABCD]/[EF]
```

其中:

* [CD] change 号的后两位
* [ABCD] change 号
* [EF] patch-set 号

例如:

```
refs/changes/20/884120/1
```

可以使用 change 的 reference 来下载 commit：

```shell
git fetch https://[GERRIT_SERVER_URL]/[PROJECT] refs/changes/[XX]/[YYYY]/[ZZ] \
&& git checkout FETCH_HEAD
```
**NOTE:**
*fetch 命令可以在 change 页面上进行复制，可以参考 [changes 评审](user-review-ui.md) 的 `download` 相关章节。*


