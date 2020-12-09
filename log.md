# Gerrit Code Review - Logs

Gerrit 的 log 文件默认保存在 `$site_path/logs/` 文件夹中，主要记录了 `tracking requests`,`background`,`plugin activity`,`errors`。默认的 log 格式为 `text format`, 也可以使用 `JSON format` 格式。`log.compress` 默认在每天的 23 点；`log.rotate` 默认在每天的 0 点。

## Time format

timestamps 的格式为 `[yyyy-MM-dd'T'HH:mm:ss,SSSXXX]`。此格式兼容 [ISO 8601](https://www.w3.org/TR/NOTE-datetime) 和 [RFC3339](https://tools.ietf.org/html/rfc3339) 。

## Logs

logs 类型。

### HTTPD Log

httpd log 记录了 HTTP requests 处理的相关信息，路径为：`$site_path/logs/httpd_log`。可通过 `httpd.requestLog` 参数进行配置。

格式为 [NCSA combined log](https://httpd.apache.org/docs/2.4/logs.html#combined) 增强模式，若字段内容为空，则用 `-` 来表示。

* `host`: 客户端的 IP 地址。
* `[thread name]`: 执行请求的 Java thread 名称
* `remote logname`:  识别符号用来[标识客户端作出了 http 请求](https://tools.ietf.org/html/rfc1413), Gerrit 使用 `-` 符号表示。
* `username`: 客户端认证使用的用户名。"-" 标识 `anonymous` 的请求。
* `[date:time]`: 系统收到 HTTP 请求的日期和时间。
* `request`: 客户端的请求信息，用双引号标注。
    ** 客户端使用的 HTTP method
    ** 客户端请求的 resource
    ** 客户端使用的 protocol/version
* `statuscode`: 服务器端返回给客户端的 [HTTP 状态码](https://tools.ietf.org/html/rfc2616#section-10)
* `response size`: response 的数据大小，不包括 `HTTP header`。
* `latency`: response 时间，用 millisecond 表上。
* `referer`: HTTP 请求 header 中的 `Referer` 部分。表明发出请求的地址。
* `client agent`: 客户端发出请求所用的 agent 信息。

例如:
```
12.34.56.78 [HTTP-4136374] - johndoe [28/Aug/2020:10:02:20 +0200] "GET /a/plugins/metrics-reporter-prometheus/metrics HTTP/1.1" 200 1247498 1900 - "Prometheus/2.13.1"
```

### SSHD Log

sshd log 记录了 ssh requests 处理的相关信息，路径为：`$site_path/logs/sshd_log`。可通过 `sshd.requestLog` 参数进行配置。

Log format:

* `[date time]`: 收到请求的时间
* `sessionid`: 用户 ssh session 16进制的标识。
* `[thread name]`: 执行请求的 Java thread 名称
* `username`: 客户端认证使用的用户名
* `a/accountid`: gerrit 用户的序号名称。
* `operation`: ssh 的操作名称
    ** `LOGIN FROM <host>`: 客户端登录及开始 ssh session 的时间
    ** `AUTH FAILURE FROM <host> <message>`: 认证失败的 IP 信息
    ** `LOGOUT`: 客户端 logout 及终止 SSH session 的时间
    ** `git-upload-pack.<projectname>`: 客户端 git fetch 或 clone 命令所涉及的 project 信息
    ** `git-receive-pack.<projectname>`: 客户端 git push 命令所涉及的 project 信息
    ** Gerrit ssh 命令信息
* `wait`: 命令执行前，所等待的时长
* `exec`: 执行命令所用的时长
* `status`: 命令执行状态码。0 表上成功，其他数值表示失败。

`git-upload-pack` 字段命令提供了下面额外的信息，这些信息在 `exec` 和 `status` 之间。若 upload-pack 请求返回空结果，则字段信息为 `-1`.

* `time negotiating`: object 传输前的 negotiating 时长。
* `time searching for reuse`: jgit 搜索可以复用的 delata （服务器端及客户端已存在的 delta）的时长。
* `time searching for sizes`: jgit 查询所有 object 大小所花费的时长。根据大小，可以方便找出相似的 object，一起压缩进而可以提高压缩比
* `time counting`: jgit 计算哪些 object 需要传递所用的时长。此时长包括了复用已缓存的 pack 时长。
* `time compressing`: jgit 压缩 object 所用的时长。此时间为 cpu wall 时间。
* `time writing`: jgit 写 packfile（从 header 开始，到 trailer 结束）所用的时长。传输速度近似 `total bytes` 除以此数值。
* `total time in UploadPack`: 花费 upload-pack 的总时长
* `bitmap index misses`: bitmap index 使用的 misses 数量（ 未被 bitmap 的 object 数量 ）。`-1` 表示 bitmap index 不可访问。
* `total deltas`: 总的传输的 delta 数量。如果复用了缓存的 pack，那么此值会比实际的 delta 数量要少。
* `total objects`: 总的传输的 object 数量。包括了 `total deltas`。
* `total bytes`: 总的传输数据的大小。数据包括：pack header, trailer, thin pack, 和 reused cached packs.
* `client agent`: 客户端发出请求所用的 agent/version 信息。

例如: 一个 CI 系统建立了一个 SSH 链接，发送一个 upload-pack 命令 (git fetch) 最后关闭链接:
```
[2020-08-28 11:00:01,391 +0200] 8a154cae [sshd-SshServer[570fc452]-nio2-thread-299] voter a/1000023 LOGIN FROM 12.34.56.78
[2020-08-28 11:00:01,556 +0200] 8a154cae [SSH git-upload-pack /AP/ajs/jpaas-msg-svc.git (voter)] voter a/1000056 git-upload-pack./demo/project.git 0ms 115ms 92ms 1ms 0ms 6ms 0ms 0ms 7ms 3 10 26 2615 0 git/2.26.2
[2020-08-28 11:00:01,583 +0200] 8a154cae [sshd-SshServer[570fc452]-nio2-thread-168] voter a/1000023 LOGOUT
```

### Error Log

error log 记录了 `errors` 和 `stack traces`，文件路径为 `$site_path/logs/error_log`。

Log 格式:

* `[date time]`: 收到请求的时间
* `[thread name]`: 执行请求的 Java thread 名称
* `level`: log 级别 (ERROR, WARN, INFO, DEBUG).
* `logger`: logger 名称
* `message`: log 信息
* `stacktrace`: 异常时捕获的 `Java stacktrace` 信息，通常用多行来表示。

### GC Log

gc log 记录了 `git gc` 的相关信息，路径为：`$site_path/logs/gc_log`。

Log format:

* `[date time]`: The time that the request was received.
* `level`: log level (ERROR, WARN, INFO, DEBUG).
* `message`: log message.

### Plugin Logs

有的 plugin 有其自己的 log 文件。 例如：replication plugin 的 log 路径：`$site_path/logs/replication_log`。

