# gerrit apropos

## NAME
gerrit apropos - 搜索 Gerrit 的文档的索引

## SYNOPSIS
```
_ssh_ -p <port> <host> _gerrit apropos_
  <query>
```

## DESCRIPTION
搜索文档的索引并反回匹配到的结果

## ACCESS
需要 SSH 的访问权限

## SCRIPTING
建议在脚本中执行此命令

**NOTE:**
*如果对文档的索引进行了构建，那么可以使用此功能。*

## EXAMPLES

```shell
$ ssh -p 29418 review.example.com gerrit apropos capabilities

    Gerrit Code Review - /config/ REST API:
    http://localhost:8080/Documentation/rest-api-config.html

    Gerrit Code Review - /accounts/ REST API:
    http://localhost:8080/Documentation/rest-api-accounts.html

    Gerrit Code Review - Project Configuration File Format:
    http://localhost:8080/Documentation/config-project-config.html

    Gerrit Code Review - Access Controls:
    http://localhost:8080/Documentation/access-control.html

    Gerrit Code Review - Plugin Development:
    http://localhost:8080/Documentation/dev-plugins.html

    Gerrit Code Review - REST API:
    http://localhost:8080/Documentation/rest-api.html

    Gerrit Code Review - /access/ REST API:
    http://localhost:8080/Documentation/rest-api-access.html
```

## SEE ALSO

* [访问控制](access-control.md)

