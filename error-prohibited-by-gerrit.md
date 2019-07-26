# prohibited by Gerrit

由于没有权限导致，如下：

1. commit 上传评审，可在分支 `refs/for/refs/heads/*` 配置 `push` 权限。
2. commit 直接 push 入库，可在分支 `refs/heads/*` 配置 `push` 权限。
3. 创建分支，可在分支 `refs/heads/*` 配置 `Create Reference` 权限。
4. 创建 Annotated tag ，可在分支 `refs/tags/*` 配置 `Create Annotated Tag` 权限。
5. 创建 Signed tag ，可在分支 `refs/tags/*` 配置 `Create Signed Tag` 权限。
6. 创建 lightweight tag ，可在分支 `refs/tags/*` 配置 `Create Reference` 权限。
7. 创建其他人生成的 tag ，可在分支 `refs/tags/*` 配置 `Forge Committer` 权限。
8. 向状态为 'Read Only' 的 project 推送 commit。

