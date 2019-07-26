# not Signed-off-by author/committer/uploader in commit message footer

如果 project 中配置了需要 [Signed-off-by](user-signedoffby.md) , gerrit 会对 commit-msg 进行校验，如果没有 `Signed-off-by` 的话，会报此错误。

`Forge Committer` 这个权限可以不对 `Signed-off-by` 进行校验。

如果没有 `Forge Committer` 权限的话，会有下面几个原因导致此错误：

 * commit-msg 底部缺少 `Signed-off-by`
 * `Signed-off-by` 不包含 author 或 committer 或 uploader 的信息

或者系统关闭对 `Signed-off-by` 的校验。

