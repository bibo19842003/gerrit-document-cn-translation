# Gerrit Code Review - Repo admin customization API

此 API 由 [plugin.restApi()](pg-plugin-dev.md) 提供，用于为 Gerrit REST API 提供接口。

## getLoggedIn
`repoApi.getLoggedIn()`

获取用户登录状态

_Params_
- None

_Returns_
- Promise<boolean>

## getVersion
`repoApi.getVersion()`

获取 gerrit 版本

_Params_
- None

_Returns_
- Promise<string>

## get
`repoApi.get(url)`

发布一个可以被 API 所调用的 URL，如果解析成功，返回成功的约定值；如果失败，返回网络错误的约定值。

_Params_
- *url* ：String，URL 不需要基础路径或 plugin 前缀。

_Returns_
- 返回约定的响应值

## post
`repoApi.post(url, opt_payload)`

发布一个可以被 API 所调用的 URL，如果解析成功，返回成功的约定值；如果失败，返回网络错误的约定值。

_Params_
- *url* ：String，URL 不需要基础路径或 plugin 前缀。
- *opt_payload* (非比选) 与请求一起发送的对象

_Returns_
- 返回约定的响应值

## put
`repoApi.put(url, opt_payload)`

发布一个可以被 API 所调用的 URL，如果解析成功，返回成功的约定值；如果失败，返回网络错误的约定值。

_Params_
- *url* ：String，URL 不需要基础路径或 plugin 前缀。
- *opt_payload* (非比选) 与请求一起发送的对象

_Returns_
- 返回约定的响应值

## delete
`repoApi.delete(url)`

发布一个可以被 API 所调用的 URL，返回 204，否则被拒绝。

_Params_
- *url* ：String，URL 不需要基础路径或 plugin 前缀。

_Returns_
- 返回约定的响应值

## send
`repoApi.send(method, url, opt_payload)`

如果请求成功，发送对象并解析响应。否则，返回被拒绝的信息或网络相关的 HTTP 错误。

_Params_
- *method* ：String ，HTTP 方法
- *url* ：String，URL 不需要基础路径或 plugin 前缀。
- *opt_payload* (非必选) ，仅在 POST 和 PUT 模式下使用

_Returns_
- 返回解析后的响应

## fetch
`repoApi.fetch(method, url, opt_payload)`

发送对象并返回响应。此方法是低级别的链接，用来实现自定义错误的操作和解析。

_Params_
- *method* ：String ，HTTP 方法
- *url* ：String，URL 不需要基础路径或 plugin 前缀。
- *opt_payload* (非必选) ，仅在 POST 和 PUT 模式下使用

_Returns_
- 返回约定的响应值

