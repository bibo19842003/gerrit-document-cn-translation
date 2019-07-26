# too many commits

向服务器直接推送多个 commit 的时候，如果超过服务器端支持的验证数量，那么会报此错误。

push 命令中添加参数 `skip-validation` 可以避免这个问题。

服务器端不启用对 commit 的校验也会避免这个问题。

或者服务器端配置 maxBatchCommits 参数，增加上限。

