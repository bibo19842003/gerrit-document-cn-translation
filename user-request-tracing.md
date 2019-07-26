# Request Tracing

Gerrit 支持对单个请求的跟踪，跟踪结果的 log 和调试信息会被写入到 `error_log`。`error_log` 中的 trace-id 和请求中的 trace-id 是一致的。trace-id 与服务器端的响应一起返回，这样便于管理员方便查找对应的 log 信息。

如何启用跟踪并且在不同的请求类型中 trace-id 如果返回：

* REST API: 可以添加请求参数 `trace` 或设置 `X-Gerrit-Trace` 头部来实现跟踪。trace-id 会作为 `X-Gerrit-Trace` 头部进行返回。更多细节可以参考 [REST API](rest-api.md) 的 Tracing 部分。
* SSH API: SSH 命令可以添加参数 `--trace` 来启动跟踪。更多细节可以参考 [命令行工具](cmd-index.md) 的 Trace 部分。
* Git: For Git pushes 时，可以添加参数 `trace` 来启动跟踪。命令行会返回 trace-id。只有请求支持跟踪，其他的 push 操作不支持跟踪。更多细节可以参考 [上传 changes](user-upload.md) 的 Trace 部分。

启动跟踪的时候，最好手动指定一个 trace-id ，这样便于管理员搜索 log。如果没有提供 trace-id，那么系统会自动生成。

因为启用跟踪，服务器会消耗而外的资源，所以在有需要的情况下才对单个请求进行跟踪。

## Find log entries for a trace ID

如果启用了跟踪，那么与此相关 log 的 `TRACE_ID` 都是相同的。

```
[2018-08-13 15:28:08,913] [HTTP-76] TRACE com.google.gerrit.httpd.restapi.RestApiServlet : Received REST request: GET /a/accounts/self (parameters: [trace]) [CONTEXT forced=true TRACE_ID="1534166888910-3985dfba" ]
[2018-08-13 15:28:08,914] [HTTP-76] TRACE com.google.gerrit.httpd.restapi.RestApiServlet : Calling user: admin [CONTEXT forced=true TRACE_ID="1534166888910-3985dfba" ]
[2018-08-13 15:28:08,942] [HTTP-76] TRACE com.google.gerrit.httpd.restapi.RestApiServlet : REST call succeeded: 200 [CONTEXT forced=true TRACE_ID="1534166888910-3985dfba" ]
```

可以用一些搜索命令对 log 进行过滤，如：grep 命令。

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

