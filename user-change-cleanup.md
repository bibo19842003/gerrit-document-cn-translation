# Gerrit Code Review - Change Cleanup

Gerrit 管理员可以配置 `change cleanups` 用来定期清理 change。

## Auto-Abandon

cleanup 任务可以自动 abandon 超过某个时间段的未关闭的 change。

abondan 无用的 change 有如下好处：

* 对 change 的作者来说这是一个超时的提醒
* 让 dashboards 清爽
* 减少服务器的负载 (需要定期对 open 状态的 change 进行 mergeability 检验)

如果 change 需要继续合入到代码库，可以点击 `Restore` 按钮。

