# Gerrit Code Review - Quota

Gerrit 不支持配额功能，但是可以通过扩展的 plugin 来实现，如：[Quota Plugin](https://gerrit.googlesource.com/plugins/quota/)。

此文档面向的对象是 plugin 开发人员，因为 plugin 包含了 gerrit 中所有的配额接口。

## Quota Groups

Gerrit 中定义了如下的 quota groups:

### REST API

REST API 在资源解析（如果适用）之后，在逻辑执行之前强制执行配额。配额在了解一些信息（change，project，account 等）的同时，限制某些函数的调用。

如果要对 HTTP 的请求进行配额，那么需要使用 [HTTP Requests](quota.md) 的 http-requests 部分。

quota groups 用于检查 REST API 中所定义的函数，但会删除所有的 ID。schema 如下:

/restapi/<ENDPOINT>:<HTTP-METHOD>

示例:

|HTTP call                                 |Quota Group                    |Metadata
| :------| :------| :------|
|GET /a/changes/1/revisions/current/detail |/changes/revisions/detail:GET  |CurrentUser, Change.Id, Project.NameKey
|POST /a/changes/                          |/changes/:POST                 |CurrentUser
|GET /a/accounts/self/detail               |/accounts/detail:GET           |CurrentUser, Account.Id

被检查的元数据中会调用用户的一些信息（比方说用户模拟其他用户操作的时候）。

