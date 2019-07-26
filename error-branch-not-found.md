# branch ... not found

当向 gerrit 推送一个不存在的分支的时候，会报这个错误。

将 commit 推向分支 `refs/for/'branch` 生成 change 的时候，如果分支 `refs/for/'branch` 不存在，那么会报错：'branch ... not found'。

可以通过下面的操作解决问题：

* 分支名称是否正确（大小写敏感）
* 分支名称是否在 project 中存在

如果要创建新的分支：

* 不走评审直接 push
* 在网页上直接创建

创建分支需要有 `Create reference` 权限。


