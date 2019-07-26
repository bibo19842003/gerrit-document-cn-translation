# Gerrit Code Review - REST API Developers' Notes

此文描述了如何开发 `REST API`。更多的 API 信息可以参考 [REST API](rest-api.md)。

## Testing REST API Functionality

### Basic Testing

可以使用 `curl` 进行基本的 `REST API` 的测试:

```
  curl http://localhost:8080/path/to/api/
```

默认，`curl` 发送 `GET` 请求。若要测试 API 的 `PUT`, `POST`, `DELETE`, 需要添加额外的参数：

```
 curl -X PUT http://localhost:8080/path/to/api/
 curl -X POST http://localhost:8080/path/to/api/
 curl -X DELETE http://localhost:8080/path/to/api/
```

### Sending Data in the Request

有的 `REST API` 在 `PUT` 的请求主体或 `POST` 请求中介绍数据。

测试数据可以来自本地的文件： 

```
  curl -X PUT -d@testdata.txt --header "Content-Type: application/json" http://localhost:8080/path/to/api/
```

注意：`-d` 参数会移除本地文件中的换行符。如果内容要保持不变，需要使用参数 `--data-binary`：

```
  curl -X PUT --data-binary @testdata.txt --header "Content-Type: text/plain" http://localhost:8080/path/to/api/
```

示例，设置 project 的[描述](rest-api-projects.md) :

```
 curl -X PUT --user john:2LlAB3K9B0PF --data-binary @project-desc.txt --header "Content-Type: application/json; charset=UTF-8" http://localhost:8080/a/projects/myproject/description
```

### Authentication

有时，测试 `REST API` 需要进行认证，需要在命令行中明确用户名和密码：

```
 curl --user username:password http://localhost:8080/a/path/to/api/
```

也可以将用户名和密码写入 `.netrc` 文件(Windows 系统使用的是 `_netrc` 文件):

```
 curl -n http://localhost:8080/a/path/to/api/
```

密码为用户的 [HTTP password](user-upload.md) 。

### Verifying Header Content

To verify the headers returned from a REST API call, use `curl` in verbose mode:

```
  curl -v -n -X DELETE http://localhost:8080/a/path/to/api/
```

执行命令后，请求和响应的头部信息会被显示出来。

