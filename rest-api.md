# Gerrit Code Review - REST API

Gerrit Code Review 内置基于 HTTP 的 REST API。API 适用于自动化工具的构建，以及一些特定的脚本。

请参考 [REST API 开发者须知](dev-rest-api.md)。

## Endpoints

**[/access/](rest-api-access.md)**
  Access Right related REST endpoints

**[/accounts/](rest-api-accounts.md)**
  Account related REST endpoints

**[/changes/](rest-api-changes.md)**
  Change related REST endpoints

**[/config/](rest-api-config.md)**
  Config related REST endpoints

**[/groups/](rest-api-groups.md)**
  Group related REST endpoints

**[/plugins/](rest-api-plugins.md)**
  Plugin related REST endpoints

**[/projects/](rest-api-projects.md)**
  Project related REST endpoints

**[/Documentation/](rest-api-documentation.md)**
  Documentation related REST endpoints

## Protocol Details

### Authentication

通过 API 认证的时候，需要在地址中添加字符串 `/a/`，如，对 `/projects/` 认证，则请求的 URL 为 `/a/projects/`。Gerrit 使用 `HTTP basic` 认证方式的话，密码在 gerrit 的个人设置页面，此种情况不需要 XSRF（Cross-site request forgery 跨域请求伪造）。

### CORS（ Cross-origin resource sharing 跨域资源共享）

如果管理员在 gerrit.config 文件中配置了 `site.allowOriginRegex`，那么支持跨站点脚本的使用。

Gerrit 接受额外的查询参数 `$m` 来重载请求方式（PUT，POST，DELETE）以及参数 `$ct` 来明确实际的内容类型，例如 `application/json; charset=UTF-8`。 如下：

```
    POST /changes/42/topic?$m=PUT&$ct=application/json%3B%20charset%3DUTF-8&access_token=secret HTTP/1.1
	Content-Type: text/plain
	Content-Length: 23

	{"topic": "new-topic"}
```

### Preconditions

客户端通过向请求的 HTTP 头部添加 `If-None-Match: *`，发送 PUT 请求来创建一个新的资源，但不能覆盖已有的资源。如果资源已存在，服务器会发送 `412 Precondition Failed` 的响应。

### Output Format

JSON 的相应使用 UTF-8 编码，内容类型使用 `application/json`。

默认，API 会返回容读格式的 JSON，这样的格式中包含一些额外的空格。

通过设置 `pp=0` 查询参数或者设置 `Accept`（不过需要 HTTP 的请求头部需要包含 `application/json`）来发送 JSON 格式的请求：

```
  GET /projects/ HTTP/1.0
  Accept: application/json
```

尽可能使用紧凑格式（没有多余空格）的 JSON 来发送请求。

为了防范 Cross Site Script Inclusion (XSSI) 攻击，JSON 响应的主体会以一个神奇的前缀行来开头，在解析 JSON 格式的时候可以忽略此行。

```
  )]}'
  [ ... valid JSON ... ]
```

如果 HTTP 的请求头部将 `Accept-Encoding` 设置成了 `gzip`，那么服务器端响应的时候会把相关信息以 gzip 格式进行压缩，因为这样可以节省传输时间。

### Input Format

Gerrit 为了避免异常情况发生，会忽略一些未知的 JSON 参数。JSON 对大小写敏感，如：map keys。

### Timestamp

时间戳，使用 UTC 时间，格式如下："'yyyy-mm-dd hh:mm:ss.fffffffff'" ，其中 "'ffffffffff'" 表示纳秒。

### Encoding

URL 中出现的所有的 IDs (e.g. project name, group name)，必须使用 URL 编码。

### Response Codes

Gerrit API 的 HTTP 状态码请参考 [HTTP specification](http://www.w3.org/Protocols/rfc2616/rfc2616-sec10.html)。

大多数情况下，错误响应的响应主体是文本格式，利于人们读取的错误信息。

下面是 Gerrit REST API 常见的 HTTP 状态码：

#### 400 Bad Request

"`400 Bad Request`" ，请求异常，语法有问题。

例如： "`400 Bad Request`" ，想要以 JSON 格式输入，请求时应该使用 'application/json'，结果使用了 'Content-Type' ，或者 JSON 的格式写的有问题。

"`400 Bad Request`" ，还有可能是缺少输入信息；或者输入信息断开，没有连接好。

#### 403 Forbidden

"`403 Forbidden`" ，无权限导致。

#### 404 Not Found

"`404 Not Found`" ，资源未找到。有可能服务器端的资源真的不存在，有可能 URL 路径写的有问题，有可能所访问的资源对用户不可见。

#### 405 Method Not Allowed

"`405 Method Not Allowed`" ，资源存在，但访问时，对资源的操作方式不对。

比如， `/groups/` 只支持 gerrit 内部群组的操作，如果外部群组调用此参数，会报此错误。

#### 409 Conflict

"`409 Conflict`" ，请求无法完成，因为当前状态的资源不允许相关操作。

例如，一个 change 已经被 abandon 了，这个时候对 change 进行 submit 操作，会失败，并报 "`409 Conflict`" 错误，因为 abandon 状态的 change 不允许进行 submit 操作。

"`409 Conflict`" ，创建资源的时候，如果名称已经存在，仍然会报此错误。

#### 412 Precondition Failed

"`412 Precondition Failed`" ，请求的头部内容缺失，会报此错误。可以参考本文的 `preconditions`。

#### 422 Unprocessable Entity

"`422 Unprocessable Entity`" ，资源的 ID 在请求的主体中不能被解析。

#### 429 Too Many Requests

"`429 Too Many Requests`" ，请求的资源配额用尽了。

### Request Tracing

通过设置 `trace=<trace-id>` 请求参数，可以启动 API 的跟踪。建议使用 issue 的 ID 作为跟踪的 ID 。

_Example Request_
```
  GET /changes/myProject~master~I8473b95934b5732ac55d26311a706c9c2bde9940/suggest_reviewers?trace=issue/123&q=J
```

如果自动生成跟踪 ID 的话，ID 有可能被忽略掉。

_Example Request_
```
  GET /changes/myProject~master~I8473b95934b5732ac55d26311a706c9c2bde9940/suggest_reviewers?trace&q=J
```

通过设置请求的头部参数 `X-Gerrit-Trace` ，可以启用跟踪。

_Example Request_
```
  GET /changes/myProject~master~I8473b95934b5732ac55d26311a706c9c2bde9940/suggest_reviewers?q=J
  X-Gerrit-Trace: issue/123
```

跟踪的调试信息会被写入 `error_log`，所有的跟踪 log 都会有跟踪 ID 进行标识。跟踪 ID 与响应的头部参数 `X-Gerrit-Trace` 一起返回。

_Example Response_
```
HTTP/1.1 200 OK
  Content-Disposition: attachment
  Content-Type: application/json; charset=UTF-8
  X-Gerrit-Trace: 1533885943749-8257c498

  )]}'
  ... <json> ...
```

把跟踪 ID 提供给管理员，便于管理员在 log 中查找相关信息。

