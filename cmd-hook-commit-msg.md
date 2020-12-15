# commit-msg Hook

## NAME

commit-msg hook 自动向 commit messages 中插入 `Change-Id` 信息。

## DESCRIPTION

此 hook 会在执行 `git commit` 的时候被调用，其他的图形化工具(`git citool`,`git gui`)同理。Gerrit 使用 `Change-Id` 来跟踪 commit 的 cherry-pick 和 rebase 操作。

hook 安装到本地的 Git repository 后，会修改 commit message，如下：

```
Improve foo widget by attaching a bar.

We want a bar, because it improves the foo by providing more
wizbangery to the dowhatimeanery.

Signed-off-by: A. U. Thor <author@example.com>
```

在 commit message 底部插入一行： `Change-Id: ` 

```
Improve foo widget by attaching a bar.

We want a bar, because it improves the foo by providing more
wizbangery to the dowhatimeanery.

Change-Id: Ic8aaa0728a43936cd4c6e1ed590e01ba8f0fbf5b
Signed-off-by: A. U. Thor <author@example.com>
```

hook 在 commit message 中将 `Change-Id` 插入到 `Signed-off-by` 和 `Acked-by` 之前，如果没有 `Signed-off-by` 和 `Acked-by` 的话，插入到 commit message 的底部。

如果 `Change-Id` 已经在 commit message 存在的话，hook 不会对其修改。

如果 git config 将 `gerrit.createChangeId` 设置为 `false`，那么 `Change-Id` 不会添加到 commit message 中。

如果配置了 `gerrit.reviewUrl` 参数，那么在上传 change 的时候，会生成类似 `Change-Id` 信息的链接，便于快速访问相关 change。如：

```
Improve foo widget by attaching a bar.

We want a bar, because it improves the foo by providing more
wizbangery to the dowhatimeanery.

Link: https://gerrit-review.googlesource.com/id/Ic8aaa0728a43936cd4c6e1ed590e01ba8f0fbf5b
Signed-off-by: A. U. Thor <author@example.com>
```

可以通过此链接来访问 change。方式与 `Change-Id` trailer 类似。

## OBTAINING

可以使用 scp, curl 或 wget 命令下载脚本 `commit-msg` 。

```
$ scp -p -P 29418 <your username>@<your Gerrit review server>:hooks/commit-msg <local path to your git>/.git/hooks/

$ curl -Lo <local path to your git>/.git/hooks/commit-msg <your Gerrit http URL>/tools/hooks/commit-msg
```

例子如下：

```
$ scp -p -P 29418 john.doe@review.example.com:hooks/commit-msg ~/duhproject/.git/hooks/

$ curl -Lo ~/duhproject/.git/hooks/commit-msg http://review.example.com/tools/hooks/commit-msg
```

给 hook 文件添加执行权限：

```
$ chmod u+x ~/duhproject/.git/hooks/commit-msg
```

## SEE ALSO

* [change-id](user-changeid.md)
* [git-commit(1)](http://www.kernel.org/pub/software/scm/git/docs/git-commit.html)
* [githooks(5)](http://www.kernel.org/pub/software/scm/git/docs/githooks.html)

## IMPLEMENTATION

`Change-Id` 根据下列属性计算出来：

* 现有的 SHA-1 tree
* 父节点的 SHA-1
* commit 作者的Name, email address, timestamp
* commit 提交者的Name, email address, timestamp
* commit message (`Change-Id` 上面的内容)

通过上面属性的复合计算，以确保 `Change-Id` 的值是唯一的。

