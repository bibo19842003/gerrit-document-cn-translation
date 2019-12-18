# Request Tracing

## On-demand Request Tracing

Gerrit 支持对单个请求的跟踪，跟踪结果的 log 和调试信息会被写入到 `error_log`。`error_log` 中的 trace-id 和请求中的 trace-id 是一致的。trace-id 与服务器端的响应一起返回，这样便于管理员方便查找对应的 log 信息。

如何启用跟踪并且在不同的请求类型中 trace-id 如果返回：

* REST API: 可以添加请求参数 `trace` 或设置 `X-Gerrit-Trace` 头部来实现跟踪。trace-id 会作为 `X-Gerrit-Trace` 头部进行返回。更多细节可以参考 [REST API](rest-api.md) 的 Tracing 部分。
* SSH API: SSH 命令可以添加参数 `--trace` 来启动跟踪。更多细节可以参考 [命令行工具](cmd-index.md) 的 Trace 部分。
* Git Push (需要使用 git protocol v2): git push 的跟踪可以启用参数 `trace`，trace ID 会在命令行的输出信息中显示。更多细节可以参考 [上传 changes](user-upload.md) 的 Trace 部分。
* Git Clone/Fetch/Ls-Remote (需要使用 git protocol v2): Git clone/fetch/ls-remote 的跟踪可以设置参数 `trace`。可以为命令 `git fetch` 和 `git ls-remote` 使用参数'-o trace=<TRACE-ID>';`git clone` 命令使用参数 '--server-option trace=<TRACE-ID>'。如果 `trace` 没有设置具体的 `TRACE-ID`，那么服务器会自动生成 `TRACE-ID`，但 `TRACE-ID` 不会返回给客户端。

启动跟踪的时候，最好手动指定一个 trace-id ，这样便于管理员搜索 log。如果没有提供 trace-id，那么系统会自动生成。

因为启用跟踪，服务器会消耗而外的资源，所以在有需要的情况下才对单个请求进行跟踪。

## Automatic Request Tracing

在启用 tracing 的情况下，对于不可恢复请求的失败，gerrit 可以配置自动重试。并且系统会自动捕获相关 trace 的数据，用于 gerrit 管理员进行分析。

auto-retry 的行为和用户重试操作的方式是一样的。

auto-retry 失败了会触发新的 the auto-retry, 但有些情况会有例外，如下：

* 不是所有 gerrit 的操作都有完整的原子性，有的环节会在其他的失败环节前操作成功。这时 auto-retry 会报出其他的异常。
* 一些异常可能会被错误的认做为不可恢复，并且 auto-retry 可以成功。

如果 auto-retry 成功的话，可以填写[Gerrit issue](https://bugs.chromium.org/p/gerrit/issues/entry?template=GoogleSource+Issue) ，这样的话 gerrit 的开发者可以修复这个问题并且把这个异常视为可恢复的。

auto-retry 的 trace IDs 以 `retry-on-failure-` 开头，例如 `retry-on-failure-1534166888910-3985dfba`。对于 REST 请求来说， trace IDs 会返回到客户端的 `X-Gerrit-Trace` 头部。

log 中查找 auto-retry 最好的方法是查找 `AutoRetry`。每次的 auto-retry 会在 log 中匹配到 1 - 2 条信息：

* 一个是 auto-retry 的异常的 `ERROR` 信息。
* 另一个是 auto-retry 的恢复的 `FINE` 信息。（auto-retry 成功的情况下）

**NOTE:**
*失败时的 Auto-retrying, 只有部分 `REST endpoints (change REST endpoints that perform updates)` 支持。*

### Metrics

如果启用了 auto-retry，那么相关数据会在 metric 报告中体现：

* `action/auto_retry_count`: 自动重试的次数
* `action/failures_on_auto_retry_count`: 自动重试时失败的次数

通过上面数据的比较可以看出 auto-retry 成功的频率。


## Find log entries for a trace ID

如果启用了跟踪，那么与此相关 log 的 `TRACE_ID` 都是相同的。

```
[2018-08-13 15:28:08,913] [HTTP-76] TRACE com.google.gerrit.httpd.restapi.RestApiServlet : Received REST request: GET /a/accounts/self (parameters: [trace]) [CONTEXT forced=true TRACE_ID="1534166888910-3985dfba" ]
[2018-08-13 15:28:08,914] [HTTP-76] TRACE com.google.gerrit.httpd.restapi.RestApiServlet : Calling user: admin [CONTEXT forced=true TRACE_ID="1534166888910-3985dfba" ]
[2018-08-13 15:28:08,942] [HTTP-76] TRACE com.google.gerrit.httpd.restapi.RestApiServlet : REST call succeeded: 200 [CONTEXT forced=true TRACE_ID="1534166888910-3985dfba" ]
```

可以用一些搜索命令对 log 进行过滤，如：grep 命令。

**NOTE:**
*通常只有服务器管理员可以访问 log 文件。*

## Which information is captured in a trace?

* 请求信息
    REST API: 请求路径，请求参数，用户名，响应码，报错的响应主体
    SSH API: 参数名称
    Git API: push 参数，branch 名称
* 缓存情况
* 读写 NoteDb 的信息
* 读写 meta data 文件的信息
* 索引的查询信息
* 重构索引的信息
* 权限的校验
* 时间信息
* 其他级别的 log 信息

